import 'dart:async';

import '../objectbox_service.dart';
import '../entities/index.dart';
import '../../../objectbox.g.dart';
import 'base_sync_repository.dart';

/// Repositório de Tratamentos (subcoleção `tratamentos` de cada animal).
/// A sincronização é herdada de [BaseSyncRepository].
class TratamentoRepository extends BaseSyncRepository<TratamentoEntity> {
  TratamentoRepository({
    ObjectBoxService? objectBox,
    super.syncService,
    super.firestore,
  }) : _objectBox = objectBox ?? ObjectBoxService.instance;

  final ObjectBoxService _objectBox;

  @override
  Box<TratamentoEntity> get box => _objectBox.tratamentoBox;

  @override
  String get collectionName => 'tratamentos';

  TratamentoEntity? getByFirestoreId(String firestoreId) => box
      .query(TratamentoEntity_.firestoreId.equals(firestoreId))
      .build()
      .findFirst();

  @override
  List<TratamentoEntity> getByParentPath(String parentPath) => box
      .query(TratamentoEntity_.parentPath.equals(parentPath))
      .build()
      .find();

  @override
  List<TratamentoEntity> getPendingSync() => box
      .query(TratamentoEntity_.needsSync.equals(true))
      .build()
      .find();

  Stream<List<TratamentoEntity>> watchByParentPath(String parentPath) => box
      .query(TratamentoEntity_.parentPath.equals(parentPath))
      .watch(triggerImmediately: true)
      .map((query) => query.find());
}
