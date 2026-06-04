import 'dart:async';

import '../objectbox_service.dart';
import '../entities/index.dart';
import '../../../objectbox.g.dart';
import 'base_sync_repository.dart';

/// Repositório de Resumos de Visita (subcoleção `resumo_da_visita` de cada
/// propriedade). A sincronização é herdada de [BaseSyncRepository].
class ResumoVisitaRepository extends BaseSyncRepository<ResumoVisitaEntity> {
  ResumoVisitaRepository({
    ObjectBoxService? objectBox,
    super.syncService,
    super.firestore,
  }) : _objectBox = objectBox ?? ObjectBoxService.instance;

  final ObjectBoxService _objectBox;

  @override
  Box<ResumoVisitaEntity> get box => _objectBox.resumoVisitaBox;

  @override
  String get collectionName => 'resumo_da_visita';

  ResumoVisitaEntity? getByFirestoreId(String firestoreId) => box
      .query(ResumoVisitaEntity_.firestoreId.equals(firestoreId))
      .build()
      .findFirst();

  @override
  List<ResumoVisitaEntity> getByParentPath(String parentPath) => box
      .query(ResumoVisitaEntity_.parentPath.equals(parentPath))
      .build()
      .find();

  @override
  List<ResumoVisitaEntity> getPendingSync() => box
      .query(ResumoVisitaEntity_.needsSync.equals(true))
      .build()
      .find();

  Stream<List<ResumoVisitaEntity>> watchByParentPath(String parentPath) => box
      .query(ResumoVisitaEntity_.parentPath.equals(parentPath))
      .watch(triggerImmediately: true)
      .map((query) => query.find());
}
