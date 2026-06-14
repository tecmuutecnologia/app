import 'dart:async';

import '../objectbox_service.dart';
import '../entities/index.dart';
import '../../../objectbox.g.dart';
import 'base_sync_repository.dart';

/// Repositório de Recomendações (subcoleção `recomendacoes` de cada propriedade).
/// A sincronização é herdada de [BaseSyncRepository].
class RecomendacaoRepository extends BaseSyncRepository<RecomendacaoEntity> {
  RecomendacaoRepository({
    ObjectBoxService? objectBox,
    super.syncService,
    super.firestore,
  }) : _objectBox = objectBox ?? ObjectBoxService.instance;

  final ObjectBoxService _objectBox;

  @override
  Box<RecomendacaoEntity> get box => _objectBox.recomendacaoBox;

  @override
  String get collectionName => 'recomendacoes';

  RecomendacaoEntity? getByFirestoreId(String firestoreId) => box
      .query(RecomendacaoEntity_.firestoreId.equals(firestoreId))
      .build()
      .findFirst();

  @override
  List<RecomendacaoEntity> getByParentPath(String parentPath) => box
      .query(RecomendacaoEntity_.parentPath.equals(parentPath))
      .build()
      .find();

  @override
  List<RecomendacaoEntity> getPendingSync() =>
      box.query(RecomendacaoEntity_.needsSync.equals(true)).build().find();

  Stream<List<RecomendacaoEntity>> watchByParentPath(String parentPath) => box
      .query(RecomendacaoEntity_.parentPath.equals(parentPath))
      .watch(triggerImmediately: true)
      .map((query) => query.find());
}
