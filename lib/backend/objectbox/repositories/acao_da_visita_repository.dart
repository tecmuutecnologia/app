import 'dart:async';

import '../objectbox_service.dart';
import '../entities/index.dart';
import '../../../objectbox.g.dart';
import 'base_sync_repository.dart';

/// Repositório de Ações da Visita (subcoleção `acoes_da_visita` de cada
/// propriedade). A sincronização é herdada de [BaseSyncRepository].
class AcaoDaVisitaRepository extends BaseSyncRepository<AcaoDaVisitaEntity> {
  AcaoDaVisitaRepository({
    ObjectBoxService? objectBox,
    super.syncService,
    super.firestore,
  }) : _objectBox = objectBox ?? ObjectBoxService.instance;

  final ObjectBoxService _objectBox;

  @override
  Box<AcaoDaVisitaEntity> get box => _objectBox.acaoDaVisitaBox;

  @override
  String get collectionName => 'acoes_da_visita';

  /// Busca uma ação da visita pelo ID do Firestore (query indexada).
  AcaoDaVisitaEntity? getByFirestoreId(String firestoreId) => box
      .query(AcaoDaVisitaEntity_.firestoreId.equals(firestoreId))
      .build()
      .findFirst();

  @override
  List<AcaoDaVisitaEntity> getByParentPath(String parentPath) => box
      .query(AcaoDaVisitaEntity_.parentPath.equals(parentPath))
      .build()
      .find();

  @override
  List<AcaoDaVisitaEntity> getPendingSync() => box
      .query(AcaoDaVisitaEntity_.needsSync.equals(true))
      .build()
      .find();

  /// Stream reativa das ações da visita de uma propriedade.
  Stream<List<AcaoDaVisitaEntity>> watchByParentPath(String parentPath) => box
      .query(AcaoDaVisitaEntity_.parentPath.equals(parentPath))
      .watch(triggerImmediately: true)
      .map((query) => query.find());
}
