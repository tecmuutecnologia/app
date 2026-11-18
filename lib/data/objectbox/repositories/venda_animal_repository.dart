import 'dart:async';

import '../objectbox_service.dart';
import '../entities/index.dart';
import '../../../objectbox.g.dart';
import 'base_sync_repository.dart';

/// Repositório das vendas de animais (subcoleção `vendasAnimais` de cada
/// propriedade). Mesmo molde do [FinanceiroRepository].
class VendaAnimalRepository extends BaseSyncRepository<VendaAnimalEntity> {
  VendaAnimalRepository({
    ObjectBoxService? objectBox,
    super.syncService,
    super.firestore,
  }) : _objectBox = objectBox ?? ObjectBoxService.instance;

  final ObjectBoxService _objectBox;

  @override
  Box<VendaAnimalEntity> get box => _objectBox.vendaAnimalBox;

  @override
  String get collectionName => 'vendasAnimais';

  /// Reanexa propriedade e técnico (guardados como caminho).
  @override
  Map<String, dynamic> firestorePayloadFor(VendaAnimalEntity entity) {
    final data = entity.toFirestore();
    if (entity.uidPropriedadePath != null) {
      data['uidPropriedade'] = firestore.doc(entity.uidPropriedadePath!);
    }
    if (entity.uidTecnicoPath != null) {
      data['uidTecnico'] = firestore.doc(entity.uidTecnicoPath!);
    }
    return data;
  }

  /// O CREATE/UPDATE é feito por `_syncModifiedVendas`.
  @override
  bool get syncedByModifiedLoop => true;

  /// Id definitivo desde a criação: dois envios não criam duas vendas.
  @override
  bool get preGeneratesFirestoreId => true;

  VendaAnimalEntity? getByFirestoreId(String firestoreId) => box
      .query(VendaAnimalEntity_.firestoreId.equals(firestoreId))
      .build()
      .findFirst();

  @override
  List<VendaAnimalEntity> getByParentPath(String parentPath) => box
      .query(VendaAnimalEntity_.parentPath.equals(parentPath))
      .build()
      .find();

  @override
  List<VendaAnimalEntity> getPendingSync() =>
      box.query(VendaAnimalEntity_.needsSync.equals(true)).build().find();

  Stream<List<VendaAnimalEntity>> watchByParentPath(String parentPath) => box
      .query(VendaAnimalEntity_.parentPath.equals(parentPath))
      .watch(triggerImmediately: true)
      .map((query) => query.find());
}
