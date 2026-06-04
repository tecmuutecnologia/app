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

  /// Persiste a entidade localmente e retorna seu ID.
  int put(E entity) => box.put(entity);

  // ---------------------------------------------------------------------------
  // Escrita com sincronização (offline-first)
  // ---------------------------------------------------------------------------

  /// Cria a entidade no Firestore (ou enfileira se offline/erro).
  ///
  /// Pré-condição: [entity] já foi persistida localmente (tem `id` e
  /// `parentPath`). Em caso de sucesso online, grava o `firestoreId` retornado e
  /// limpa `needsSync`.
  @protected
  Future<Result<E>> pushCreate(E entity) async {
    final collectionPath = '${entity.parentPath}/$collectionName';

    if (isOnline) {
      try {
        final docRef = _firestore.collection(collectionPath).doc();
        await docRef.set(entity.toFirestore());

        entity.firestoreId = docRef.id;
        entity.needsSync = false;
        entity.lastSynced = DateTime.now();
        box.put(entity);
        return Success(entity);
      } catch (e, st) {
        debugPrint('❌ [$collectionName] erro ao criar no Firestore: $e');
        _queue('CREATE', '$collectionPath/${entity.id}',
            data: entity.toFirestore());
        return Failure('Falha ao criar $collectionName (enfileirado)',
            error: e, stackTrace: st);
      }
    }

    _queue('CREATE', '$collectionPath/${entity.id}',
        data: entity.toFirestore());
    return Success(entity);
  }

  /// Atualiza a entidade no Firestore (ou enfileira se offline/erro).
  ///
  /// No-op se a entidade ainda não tem `firestoreId` (nunca foi enviada).
  @protected
  Future<Result<E>> pushUpdate(E entity) async {
    final firestoreId = entity.firestoreId;
    if (firestoreId == null) return Success(entity);

    final documentPath = '${entity.parentPath}/$collectionName/$firestoreId';

    if (isOnline) {
      try {
        await _firestore.doc(documentPath).update(entity.toFirestore());
        entity.needsSync = false;
        entity.lastSynced = DateTime.now();
        box.put(entity);
        return Success(entity);
      } catch (e, st) {
        debugPrint('❌ [$collectionName] erro ao atualizar no Firestore: $e');
        _queue('UPDATE', documentPath,
            firestoreId: firestoreId, data: entity.toFirestore());
        return Failure('Falha ao atualizar $collectionName (enfileirado)',
            error: e, stackTrace: st);
      }
    }

    _queue('UPDATE', documentPath,
        firestoreId: firestoreId, data: entity.toFirestore());
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

    final documentPath = '${entity.parentPath}/$collectionName/$firestoreId';

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
