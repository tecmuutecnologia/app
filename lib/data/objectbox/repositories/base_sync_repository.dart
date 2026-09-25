import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:objectbox/objectbox.dart';

import '../../../core/result/result.dart';
import '../entities/syncable_entity.dart';
import '../offline_first_sync_service.dart';

/// Camada base, offline-first, para repositórios de entidades sincronizáveis.
///
/// Centraliza a orquestração de sincronização ObjectBox <-> Firestore que antes
/// era copiada/colada em cada repositório (criar/atualizar/excluir com fallback
/// para a fila de pendências quando offline ou em caso de erro). As subclasses
/// só precisam declarar a [box] tipada e o [collectionName] do Firestore.
///
/// Padrão offline-first aplicado em todas as operações de escrita:
/// 1. a fonte da verdade é sempre o ObjectBox (a UI lê dele);
/// 2. quando online, tenta refletir a mudança no Firestore imediatamente;
/// 3. se offline ou em caso de falha, enfileira a operação para retry posterior.
abstract class BaseSyncRepository<E extends SyncableEntity> {
  BaseSyncRepository({
    OfflineFirstSyncService? syncService,
    FirebaseFirestore? firestore,
  })  : _syncService = syncService ?? OfflineFirstSyncService.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final OfflineFirstSyncService _syncService;
  final FirebaseFirestore _firestore;

  /// Box tipada do ObjectBox para a entidade `E`. Implementada pela subclasse
  /// (ex.: `ObjectBoxService.instance.animalBox`).
  @protected
  Box<E> get box;

  /// Nome da (sub)coleção no Firestore (ex.: `'animaisProdutores'`).
  @protected
  String get collectionName;

  /// Acesso protegido ao Firestore para queries específicas da subclasse.
  @protected
  FirebaseFirestore get firestore => _firestore;

  /// `true` se há conectividade real no momento.
  bool get isOnline => _syncService.isOnline;

  // ---------------------------------------------------------------------------
  // Leitura local (ObjectBox como fonte primária)
  // ---------------------------------------------------------------------------

  /// Busca pelo ID local do ObjectBox.
  E? getById(int id) => box.get(id);

  /// Retorna todas as entidades (incluindo soft-deleted).
  List<E> getAll() => box.getAll();

  /// Conta o total de entidades.
  int count() => box.count();

  /// Entidades com mudanças locais pendentes de sincronização.
  ///
  /// Implementação padrão por varredura em memória; subclasses podem sobrescrever
  /// com uma query indexada (`EntityName_.needsSync.equals(true)`) para datasets
  /// grandes.
  List<E> getPendingSync() => box.getAll().where((e) => e.needsSync).toList();

  /// Entidades cujo documento pai no Firestore é [parentPath].
  ///
  /// Implementação padrão por varredura em memória; subclasses podem sobrescrever
  /// com uma query indexada (`EntityName_.parentPath.equals(parentPath)`).
  List<E> getByParentPath(String parentPath) =>
      box.getAll().where((e) => e.parentPath == parentPath).toList();

  /// Persiste a entidade localmente e retorna seu ID.
  int put(E entity) => box.put(entity);

  /// Predicado puro: uma entidade pode ser removida do cache local quando já foi
  /// excluída (soft delete) E já está sincronizada (não tem mudança pendente).
  /// Manter soft-deletes sincronizados só faz o banco crescer à toa.
  static bool isPurgeable(SyncableEntity entity) =>
      entity.isDeleted && !entity.needsSync;

  /// Remove do cache local os soft-deletes já sincronizados ([isPurgeable]).
  /// Retorna a quantidade de registros removidos.
  int purgeSyncedSoftDeletes() {
    final ids = box.getAll().where(isPurgeable).map((e) => e.id).toList();
    if (ids.isNotEmpty) box.removeMany(ids);
    return ids.length;
  }

  // ---------------------------------------------------------------------------
  // Escrita com sincronização (offline-first)
  // ---------------------------------------------------------------------------

  /// `true` se esta entidade nasce com um `firestoreId` REAL gerado no cliente
  /// (offline) já na criação — em vez de reconciliar o id depois do envio.
  /// Firestore gera ids no cliente (`collection(path).doc().id`) sem escrever.
  /// Com isto, o sync vira um `set(merge)` idempotente no id e os filhos já
  /// referenciam o path definitivo. Padrão `false` (comportamento antigo).
  @protected
  bool get preGeneratesFirestoreId => false;

  /// Adiciona uma NOVA entidade: marca para sync, persiste localmente e
  /// sincroniza (ou enfileira se offline/erro). A entidade deve ter `parentPath`
  /// definido.
  Future<Result<E>> add(E entity) async {
    // Gera o firestoreId REAL na criação (offline) para as entidades que optam
    // por isso — os filhos já podem referenciar o path definitivo e o sync é um
    // `set` idempotente, sem reconciliação pós-envio.
    if (preGeneratesFirestoreId && entity.firestoreId == null) {
      entity.firestoreId =
          _firestore.collection(collectionPathFor(entity)).doc().id;
    }
    entity.needsSync = true;
    entity.lastModified = DateTime.now();
    final id = put(entity);
    entity.id = id;
    return pushCreate(entity);
  }

  /// Salva alterações de uma entidade EXISTENTE: marca como modificada, persiste
  /// localmente e sincroniza (ou enfileira).
  Future<Result<E>> save(E entity) async {
    entity.markAsModified();
    put(entity);
    return pushUpdate(entity);
  }

  /// Exclui (soft delete) a entidade e sincroniza (ou enfileira).
  Future<Result<void>> softDelete(E entity) => pushDelete(entity);

  // ---------------------------------------------------------------------------
  // Construção de paths do Firestore (sobrescrevível por subclasses)
  // ---------------------------------------------------------------------------

  /// Path da coleção onde o documento de [entity] vive.
  ///
  /// Padrão para subcoleções: `<parentPath>/<collectionName>`. Repositórios de
  /// coleção de topo (ex.: `person`) sobrescrevem para retornar só [collectionName]
  /// (ver [TopLevelSyncRepository]).
  @protected
  String collectionPathFor(E entity) => '${entity.parentPath}/$collectionName';

  /// Path completo do documento de [entity] no Firestore.
  @protected
  String documentPathFor(E entity, String firestoreId) =>
      '${collectionPathFor(entity)}/$firestoreId';

  /// Payload enviado ao Firestore para [entity]. Por padrão é
  /// `entity.toFirestore()`; repositórios podem sobrescrever para adicionar
  /// campos de referência (`DocumentReference`) que a entidade pura — sem acesso
  /// ao Firestore — não consegue construir. O `QueuePayloadCodec` serializa
  /// `DocumentReference` na fila offline.
  ///
  /// Público para que o `OfflineFirstSyncService` (que tem seu próprio laço de
  /// sync por-entidade) use o mesmo payload e não perca as referências.
  ///
  /// NÃO carimba `lastModified`: quem carimba é [payloadParaGravar]. Enquanto o
  /// carimbo morava aqui, todo override o perdia — e os quatro que existem
  /// (animal, ação, ação sanitária, propriedade) gravavam sem ele.
  Map<String, dynamic> firestorePayloadFor(E entity) => entity.toFirestore();

  /// Payload das gravações diretas no Firestore, com o carimbo do servidor.
  ///
  /// Não pode ser sobrescrito para que nenhum repositório consiga gravar sem o
  /// carimbo. Sem ele o documento fica invisível ao pull incremental dos outros
  /// aparelhos até o próximo login.
  ///
  /// Público porque o `OfflineFirstSyncService` grava por fora do repositório
  /// (laço de reenvio por entidade) e precisa do MESMO payload: quando cada um
  /// montava o seu, a criação online de visita e tratamento subia sem os
  /// vínculos que o download usa para filtrar.
  @nonVirtual
  Map<String, dynamic> payloadParaGravar(E entity) =>
      carimbarLastModified(firestorePayloadFor(entity));

  /// Payload da fila de pendências, SEM carimbo.
  ///
  /// A fila é serializada em JSON e `FieldValue.serverTimestamp()` não é
  /// serializável. O executor da fila carimba na hora em que grava.
  @nonVirtual
  @visibleForTesting
  Map<String, dynamic> payloadParaFila(E entity) => firestorePayloadFor(entity);

  /// Acrescenta o carimbo de modificação ao payload, sem mutar o original.
  ///
  /// Existe porque `lastModified` é campo só local do ObjectBox: nenhum
  /// `toFirestore()` o escrevia, e sem ele no documento o pull incremental não
  /// teria sobre o que filtrar. O carimbo é do servidor para não depender do
  /// relógio do aparelho, que em campo costuma estar errado.
  static Map<String, dynamic> carimbarLastModified(
    Map<String, dynamic> payload,
  ) =>
      {...payload, 'lastModified': FieldValue.serverTimestamp()};

  /// `true` se o CREATE/UPDATE desta entidade já é feito pelo laço por-entidade
  /// (`_syncModifiedX`) do [OfflineFirstSyncService] ao reconectar.
  ///
  /// Quando `true`, `pushCreate`/`pushUpdate` NÃO enfileiram na fila de
  /// pendências — senão a entidade subiria DUAS vezes (a fila com um `set` e o
  /// laço com um `add`). O laço é a autoridade porque, diferente da fila, ele
  /// reconcilia o `firestoreId`/`needsSync` de volta no ObjectBox após criar.
  /// O DELETE continua sempre indo pela fila (nenhum laço exclui no Firestore).
  ///
  /// Padrão `false`: a maioria dos repositórios não tem laço próprio e depende
  /// inteiramente da fila.
  @protected
  bool get syncedByModifiedLoop => false;

  /// Cria a entidade no Firestore (ou enfileira se offline/erro).
  ///
  /// Pré-condição: [entity] já foi persistida localmente (tem `id` e
  /// `parentPath`). Em caso de sucesso online, grava o `firestoreId` retornado e
  /// limpa `needsSync`.
  @protected
  Future<Result<E>> pushCreate(E entity) async {
    final collectionPath = collectionPathFor(entity);
    // Com firestoreId pré-gerado, o CREATE é um `set(merge)` idempotente no id
    // definitivo — sem auto-id nem reconciliação.
    final preId = entity.firestoreId;

    if (isOnline) {
      try {
        if (preId != null) {
          await _firestore
              .doc('$collectionPath/$preId')
              .set(payloadParaGravar(entity), SetOptions(merge: true));
        } else {
          final docRef = _firestore.collection(collectionPath).doc();
          await docRef.set(payloadParaGravar(entity));
          entity.firestoreId = docRef.id;
        }
        entity.needsSync = false;
        entity.lastSynced = DateTime.now();
        box.put(entity);
        return Success(entity);
      } catch (e, st) {
        debugPrint('❌ [$collectionName] erro ao criar no Firestore: $e');
        if (!syncedByModifiedLoop) {
          _queueCreate(entity, collectionPath);
        }
        // needsSync permanece true: recriado pela fila (acima) ou, para
        // entidades com laço próprio, pelo `_syncModifiedX` ao reconectar.
        return Failure('Falha ao criar $collectionName (será re-sincronizado)',
            error: e, stackTrace: st);
      }
    }

    if (!syncedByModifiedLoop) {
      _queueCreate(entity, collectionPath);
    }
    // needsSync permanece true: recriado pela fila (acima) ou, para entidades
    // com laço próprio, pelo `_syncModifiedX` ao reconectar.
    return Success(entity);
  }

  /// Enfileira o CREATE garantindo um `firestoreId` REAL.
  ///
  /// O id do ObjectBox é local: serve de chave dentro daquele aparelho e mais
  /// nada. Quando a fila o usava como id de documento
  /// (`<colecao>/<entity.id>`), a primeira recomendação de qualquer aparelho ia
  /// para o documento `1` — dois aparelhos na mesma propriedade sobrescreviam a
  /// recomendação um do outro. O Firestore gera ids no cliente sem escrever
  /// (`collection(path).doc().id`), então o id definitivo sai daqui e fica
  /// gravado no local: fila e aparelho passam a apontar para o mesmo documento.
  void _queueCreate(E entity, String collectionPath) {
    var id = entity.firestoreId;
    if (id == null) {
      id = _firestore.collection(collectionPath).doc().id;
      entity.firestoreId = id;
      box.put(entity);
    }
    _queue('CREATE', '$collectionPath/$id',
        firestoreId: id, data: payloadParaFila(entity));
  }

  /// Atualiza a entidade no Firestore (ou enfileira se offline/erro).
  ///
  /// No-op se a entidade ainda não tem `firestoreId` (nunca foi enviada).
  @protected
  Future<Result<E>> pushUpdate(E entity) async {
    final firestoreId = entity.firestoreId;
    if (firestoreId == null) return Success(entity);

    final documentPath = documentPathFor(entity, firestoreId);

    if (isOnline) {
      try {
        await _firestore.doc(documentPath).update(payloadParaGravar(entity));
        entity.needsSync = false;
        entity.lastSynced = DateTime.now();
        box.put(entity);
        return Success(entity);
      } catch (e, st) {
        debugPrint('❌ [$collectionName] erro ao atualizar no Firestore: $e');
        if (!syncedByModifiedLoop) {
          _queue('UPDATE', documentPath,
              firestoreId: firestoreId, data: payloadParaFila(entity));
        }
        // needsSync permanece true: reenviado pela fila (acima) ou pelo laço.
        return Failure(
            'Falha ao atualizar $collectionName (será re-sincronizado)',
            error: e,
            stackTrace: st);
      }
    }

    if (!syncedByModifiedLoop) {
      _queue('UPDATE', documentPath,
          firestoreId: firestoreId, data: payloadParaFila(entity));
    }
    // needsSync permanece true: reenviado pela fila (acima) ou pelo laço.
    return Success(entity);
  }

  /// Exclui (soft delete) a entidade: marca localmente e propaga ao Firestore.
  ///
  /// A entidade é marcada como `isDeleted` e persistida localmente; em caso de
  /// sucesso online é removida do ObjectBox. Offline/erro vai para a fila.
  @protected
  Future<Result<void>> pushDelete(E entity) async {
    entity.isDeleted = true;
    entity.markAsModified();
    box.put(entity);

    final firestoreId = entity.firestoreId;
    if (firestoreId == null) return const Success(null);

    final documentPath = documentPathFor(entity, firestoreId);

    if (isOnline) {
      try {
        await _firestore.doc(documentPath).delete();
        box.remove(entity.id);
        return const Success(null);
      } catch (e, st) {
        debugPrint('❌ [$collectionName] erro ao excluir no Firestore: $e');
        _queue('DELETE', documentPath, firestoreId: firestoreId);
        return Failure('Falha ao excluir $collectionName (enfileirado)',
            error: e, stackTrace: st);
      }
    }

    _queue('DELETE', documentPath, firestoreId: firestoreId);
    return const Success(null);
  }

  void _queue(
    String operationType,
    String documentPath, {
    String? firestoreId,
    Map<String, dynamic>? data,
  }) {
    _syncService.queueOperation(
      operationType: operationType,
      collectionName: collectionName,
      documentPath: documentPath,
      firestoreId: firestoreId,
      data: data,
    );
  }
}
