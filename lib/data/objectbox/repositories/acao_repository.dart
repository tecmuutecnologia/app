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

  /// O CREATE/UPDATE das ações já é feito por `_syncModifiedAcoes` (que reconcilia
  /// o `firestoreId` de volta). Não enfileirar evita a dupla-sincronização.
  @override
  bool get syncedByModifiedLoop => true;

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

  /// Reanexa ao payload as referências (`DocumentReference`) que a entity pura
  /// não constrói: `uidAnimalAnimaisProdutores` e `uidPropriedade`. Sem isso, as
  /// ações sobem ao Firestore sem o vínculo com o animal/propriedade (reports e
  /// segundo-device filtram por essas refs).
  ///
  /// Para animal já sincronizado usa o path guardado. Para animal criado offline
  /// (sem path, só `uidAnimalOffline`) o vínculo é resolvido no Estágio 3.
  @override
  Map<String, dynamic> firestorePayloadFor(AcaoEntity entity) {
    final data = entity.toFirestore();
    if (entity.uidAnimalAnimaisProdutoresPath != null) {
      data['uidAnimalAnimaisProdutores'] =
          firestore.doc(entity.uidAnimalAnimaisProdutoresPath!);
    }
    if (entity.uidPropriedadePath != null) {
      data['uidPropriedade'] = firestore.doc(entity.uidPropriedadePath!);
    }
    return data;
  }

  /// Stream reativa das ações de um animal (path do documento pai).
  Stream<List<AcaoEntity>> watchByParentPath(String parentPath) => box
      .query(AcaoEntity_.parentPath.equals(parentPath))
      .watch(triggerImmediately: true)
      .map((query) => query.find());
}
