import 'dart:async';

import '../objectbox_service.dart';
import '../entities/index.dart';
import '../../../objectbox.g.dart';
import 'base_sync_repository.dart';

/// Repositório de Ações Sanitárias (subcoleção `acoes_sanitario` de cada animal).
/// A sincronização é herdada de [BaseSyncRepository].
class AcaoSanitarioRepository extends BaseSyncRepository<AcaoSanitarioEntity> {
  AcaoSanitarioRepository({
    ObjectBoxService? objectBox,
    super.syncService,
    super.firestore,
  }) : _objectBox = objectBox ?? ObjectBoxService.instance;

  final ObjectBoxService _objectBox;

  @override
  Box<AcaoSanitarioEntity> get box => _objectBox.acaoSanitarioBox;

  @override
  String get collectionName => 'acoes_sanitario';

  AcaoSanitarioEntity? getByFirestoreId(String firestoreId) => box
      .query(AcaoSanitarioEntity_.firestoreId.equals(firestoreId))
      .build()
      .findFirst();

  @override
  List<AcaoSanitarioEntity> getByParentPath(String parentPath) => box
      .query(AcaoSanitarioEntity_.parentPath.equals(parentPath))
      .build()
      .find();

  @override
  List<AcaoSanitarioEntity> getPendingSync() =>
      box.query(AcaoSanitarioEntity_.needsSync.equals(true)).build().find();

  Stream<List<AcaoSanitarioEntity>> watchByParentPath(String parentPath) => box
      .query(AcaoSanitarioEntity_.parentPath.equals(parentPath))
      .watch(triggerImmediately: true)
      .map((query) => query.find());
}
