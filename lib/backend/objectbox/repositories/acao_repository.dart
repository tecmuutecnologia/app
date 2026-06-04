import 'dart:async';

import '../objectbox_service.dart';
import '../entities/index.dart';
import '../../../objectbox.g.dart';
import 'base_sync_repository.dart';

/// Repositório de Ações (subcoleção `acoes` de cada animal).
///
/// Toda a orquestração de sincronização vem de [BaseSyncRepository]; aqui só
/// declaramos a box, o nome da coleção e as queries indexadas.
class AcaoRepository extends BaseSyncRepository<AcaoEntity> {
  AcaoRepository({
    ObjectBoxService? objectBox,
    super.syncService,
    super.firestore,
  }) : _objectBox = objectBox ?? ObjectBoxService.instance;

  final ObjectBoxService _objectBox;

  @override
  Box<AcaoEntity> get box => _objectBox.acaoBox;

  @override
  String get collectionName => 'acoes';

  /// Busca uma ação pelo ID do Firestore (query indexada).
  AcaoEntity? getByFirestoreId(String firestoreId) => box
      .query(AcaoEntity_.firestoreId.equals(firestoreId))
      .build()
      .findFirst();

  @override
  List<AcaoEntity> getByParentPath(String parentPath) =>
      box.query(AcaoEntity_.parentPath.equals(parentPath)).build().find();

  @override
  List<AcaoEntity> getPendingSync() =>
      box.query(AcaoEntity_.needsSync.equals(true)).build().find();

  /// Stream reativa das ações de um animal (path do documento pai).
  Stream<List<AcaoEntity>> watchByParentPath(String parentPath) => box
      .query(AcaoEntity_.parentPath.equals(parentPath))
      .watch(triggerImmediately: true)
      .map((query) => query.find());
}
