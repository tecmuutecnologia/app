import '../entities/syncable_entity.dart';
import 'base_sync_repository.dart';

/// Base para repositórios de entidades em coleções de TOPO do Firestore
/// (ex.: `person`, `tecnico`, `produtor`), que não têm documento pai.
///
/// A única diferença para [BaseSyncRepository] é a construção do path: o
/// documento vive em `<collectionName>/<id>` (sem `parentPath`). Toda a
/// orquestração de sincronização é herdada.
///
/// As entidades de topo expõem `parentPath => null` (getter computado, não
/// persistido) apenas para cumprir o contrato [SyncableEntity].
abstract class TopLevelSyncRepository<E extends SyncableEntity>
    extends BaseSyncRepository<E> {
  TopLevelSyncRepository({super.syncService, super.firestore});

  @override
  String collectionPathFor(E entity) => collectionName;

  @override
  String documentPathFor(E entity, String firestoreId) =>
      '$collectionName/$firestoreId';
}
