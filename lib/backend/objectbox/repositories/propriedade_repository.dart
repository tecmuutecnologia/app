import 'dart:async';

import '../objectbox_service.dart';
import '../entities/index.dart';
import '../../../objectbox.g.dart';
import 'base_sync_repository.dart';

/// Repositório de Propriedades (subcoleção `propriedades` de cada produtor).
/// A sincronização é herdada de [BaseSyncRepository].
class PropriedadeRepository extends BaseSyncRepository<PropriedadeEntity> {
  PropriedadeRepository({
    ObjectBoxService? objectBox,
    super.syncService,
    super.firestore,
  }) : _objectBox = objectBox ?? ObjectBoxService.instance;

  final ObjectBoxService _objectBox;

  @override
  Box<PropriedadeEntity> get box => _objectBox.propriedadeBox;

  @override
  String get collectionName => 'propriedades';

  /// Busca uma propriedade pelo ID do Firestore (query indexada).
  PropriedadeEntity? getByFirestoreId(String firestoreId) => box
      .query(PropriedadeEntity_.firestoreId.equals(firestoreId))
      .build()
      .findFirst();

  @override
  List<PropriedadeEntity> getByParentPath(String parentPath) => box
      .query(PropriedadeEntity_.parentPath.equals(parentPath))
      .build()
      .find();

  @override
  List<PropriedadeEntity> getPendingSync() => box
      .query(PropriedadeEntity_.needsSync.equals(true))
      .build()
      .find();

  /// Stream reativa das propriedades de um produtor.
  Stream<List<PropriedadeEntity>> watchByParentPath(String parentPath) => box
      .query(PropriedadeEntity_.parentPath.equals(parentPath))
      .watch(triggerImmediately: true)
      .map((query) => query.find());
}
