import 'dart:async';

import '../objectbox_service.dart';
import '../entities/index.dart';
import '../../../objectbox.g.dart';
import 'base_sync_repository.dart';

/// Repositório de dados Financeiros (subcoleção `financeiro` de cada propriedade).
/// A sincronização é herdada de [BaseSyncRepository].
class FinanceiroRepository extends BaseSyncRepository<FinanceiroEntity> {
  FinanceiroRepository({
    ObjectBoxService? objectBox,
    super.syncService,
    super.firestore,
  }) : _objectBox = objectBox ?? ObjectBoxService.instance;

  final ObjectBoxService _objectBox;

  @override
  Box<FinanceiroEntity> get box => _objectBox.financeiroBox;

  @override
  String get collectionName => 'financeiro';

  /// Reanexa propriedade e técnico (guardados como caminho): a criação online
  /// mandava só os números do relatório.
  @override
  Map<String, dynamic> firestorePayloadFor(FinanceiroEntity entity) {
    final data = entity.toFirestore();
    if (entity.uidPropriedadePath != null) {
      data['uidPropriedade'] = firestore.doc(entity.uidPropriedadePath!);
    }
    if (entity.uidTecnicoPath != null) {
      data['uidTecnico'] = firestore.doc(entity.uidTecnicoPath!);
    }
    return data;
  }

  /// O CREATE/UPDATE é feito por `_syncModifiedFinanceiro`. Não enfileirar
  /// evita dupla-sync.
  @override
  bool get syncedByModifiedLoop => true;

  /// Id definitivo desde a criação, pelo mesmo motivo dos tratamentos: dois
  /// envios do mesmo registro sem id criavam dois documentos.
  @override
  bool get preGeneratesFirestoreId => true;

  FinanceiroEntity? getByFirestoreId(String firestoreId) => box
      .query(FinanceiroEntity_.firestoreId.equals(firestoreId))
      .build()
      .findFirst();

  @override
  List<FinanceiroEntity> getByParentPath(String parentPath) =>
      box.query(FinanceiroEntity_.parentPath.equals(parentPath)).build().find();

  @override
  List<FinanceiroEntity> getPendingSync() =>
      box.query(FinanceiroEntity_.needsSync.equals(true)).build().find();

  Stream<List<FinanceiroEntity>> watchByParentPath(String parentPath) => box
      .query(FinanceiroEntity_.parentPath.equals(parentPath))
      .watch(triggerImmediately: true)
      .map((query) => query.find());
}
