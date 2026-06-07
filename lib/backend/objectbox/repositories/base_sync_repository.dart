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

  /// Adiciona uma NOVA entidade: marca para sync, persiste localmente e
  /// sincroniza (ou enfileira se offline/erro). A entidade deve ter `parentPath`
  /// definido.
  Future<Result<E>> add(E entity) async {
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
  Map<String, dynamic> firestorePayloadFor(E entity) => entity.toFirestore();

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

    if (isOnline) {
      try {
        final docRef = _firestore.collection(collectionPath).doc();
        await docRef.set(firestorePayloadFor(entity));

        entity.firestoreId = docRef.id;
        entity.needsSync = false;
        entity.lastSynced = DateTime.now();
        box.put(entity);
        return Success(entity);
      } catch (e, st) {
        debugPrint('❌ [$collectionName] erro ao criar no Firestore: $e');
        if (!syncedByModifiedLoop) {
          _queue('CREATE', '$collectionPath/${entity.id}',
              data: firestorePayloadFor(entity));
        }
        // needsSync permanece true: recriado pela fila (acima) ou, para
        // entidades com laço próprio, pelo `_syncModifiedX` ao reconectar.
        return Failure('Falha ao criar $collectionName (será re-sincronizado)',
            error: e, stackTrace: st);
      }
    }

    if (!syncedByModifiedLoop) {
      _queue('CREATE', '$collectionPath/${entity.id}',
          data: firestorePayloadFor(entity));
    }
    // needsSync permanece true: recriado pela fila (acima) ou, para entidades
    // com laço próprio, pelo `_syncModifiedX` ao reconectar.
    return Success(entity);
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
        await _firestore.doc(documentPath).update(firestorePayloadFor(entity));
        entity.needsSync = false;
        entity.lastSynced = DateTime.now();
        box.put(entity);
        return Success(entity);
      } catch (e, st) {
        debugPrint('❌ [$collectionName] erro ao atualizar no Firestore: $e');
        if (!syncedByModifiedLoop) {
          _queue('UPDATE', documentPath,
              firestoreId: firestoreId, data: firestorePayloadFor(entity));
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
          firestoreId: firestoreId, data: firestorePayloadFor(entity));
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
