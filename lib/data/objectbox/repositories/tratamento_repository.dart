import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

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

  /// Reanexa os vínculos do tratamento (animal, visita, ação lançada).
  ///
  /// Sem eles o receituário não consegue agrupar o tratamento na visita nem
  /// ligá-lo ao animal: a criação online mandava só os campos escalares.
  @override
  Map<String, dynamic> firestorePayloadFor(TratamentoEntity entity) {
    final data = entity.toFirestore();
    if (entity.uidAnimalPath != null) {
      data['uidAnimal'] = firestore.doc(entity.uidAnimalPath!);
    }
    if (entity.uidResumoDaVisitaPath != null) {
      data['uidResumoDaVisita'] = firestore.doc(entity.uidResumoDaVisitaPath!);
    }
    if (entity.uidAcaoLancadaPath != null) {
      data['uidAcaoLancada'] = firestore.doc(entity.uidAcaoLancadaPath!);
    }
    if (entity.compararDtUltimaInseminacao != null) {
      data['compararDtUltimaInseminacao'] =
          Timestamp.fromDate(entity.compararDtUltimaInseminacao!);
    }
    return data;
  }

  /// O CREATE/UPDATE dos tratamentos já é feito por `_syncModifiedTratamentos`
  /// (que reconcilia o `firestoreId`). Não enfileirar evita a dupla-sincronização.
  @override
  bool get syncedByModifiedLoop => true;

  TratamentoEntity? getByFirestoreId(String firestoreId) => box
      .query(TratamentoEntity_.firestoreId.equals(firestoreId))
      .build()
      .findFirst();

  @override
  List<TratamentoEntity> getByParentPath(String parentPath) =>
      box.query(TratamentoEntity_.parentPath.equals(parentPath)).build().find();

  @override
  List<TratamentoEntity> getPendingSync() =>
      box.query(TratamentoEntity_.needsSync.equals(true)).build().find();

  Stream<List<TratamentoEntity>> watchByParentPath(String parentPath) => box
      .query(TratamentoEntity_.parentPath.equals(parentPath))
      .watch(triggerImmediately: true)
      .map((query) => query.find());

  /// Tratamentos ativos de uma visita (opcionalmente de um tipo de ação).
  ///
  /// Filtra no banco. O receituário fazia `getAll()` e filtrava em Dart — a
  /// tabela inteira de tratamentos materializada a cada recomendação.
  List<TratamentoEntity> getDaVisita(String resumoPath, {String? tipoAcao}) {
    var condicao = TratamentoEntity_.uidResumoDaVisitaPath
        .equals(resumoPath)
        .and(TratamentoEntity_.isDeleted.equals(false));
    if (tipoAcao != null) {
      condicao = condicao.and(TratamentoEntity_.tipoAcao.equals(tipoAcao));
    }
    return box.query(condicao).build().find();
  }
}
