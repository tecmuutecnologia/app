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

  /// O CREATE/UPDATE das ações já é feito por `_syncModifiedAcoes` (set-merge no
  /// id). Não enfileirar evita a dupla-sincronização.
  @override
  bool get syncedByModifiedLoop => true;

  /// A ação nasce com um firestoreId real (offline), sincronizando via set-merge
  /// idempotente no id — sem reconciliação pós-envio.
  @override
  bool get preGeneratesFirestoreId => true;

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
  /// Ações de UM animal, filtradas por tipo, mais recentes primeiro.
  ///
  /// [incluir] restringe aos tipos listados; [excluir] remove os listados. Uma
  /// seção usa um ou outro, nunca os dois.
  ///
  /// O filtro acontece na QUERY, não depois. Três seções do prontuário faziam o
  /// contrário: buscavam as 3 ações mais recentes de qualquer tipo e escondiam
  /// as que não serviam com `Visibility`. Se as 3 mais recentes fossem todas
  /// inseminações, a seção de abortos aparecia vazia mesmo com abortos no
  /// histórico — a tela mentia em silêncio.
  Stream<List<AcaoEntity>> watchByAnimalComTipos(
    String animalPath, {
    Set<String> incluir = const {},
    Set<String> excluir = const {},
    int? limite,
  }) {
    assert(incluir.isEmpty || excluir.isEmpty,
        'Use incluir OU excluir, nao os dois');

    var condicao = AcaoEntity_.uidAnimalAnimaisProdutoresPath
        .equals(animalPath)
        .and(AcaoEntity_.isDeleted.equals(false));

    if (incluir.isNotEmpty) {
      condicao = condicao.and(AcaoEntity_.acao.oneOf(incluir.toList()));
    }
    for (final tipo in excluir) {
      condicao = condicao.and(AcaoEntity_.acao.notEquals(tipo));
    }

    return box
        .query(condicao)
        .order(AcaoEntity_.dataDaAcao, flags: Order.descending)
        .watch(triggerImmediately: true)
        .map((q) {
      final achados = q.find();
      return (limite == null || achados.length <= limite)
          ? achados
          : achados.sublist(0, limite);
    });
  }

  /// Ações de UM animal, de UM tipo, mais recentes primeiro.
  ///
  /// Alimenta as seções do prontuário, que antes abriam um `.snapshots()` do
  /// Firestore cada — cinco listeners de rede por animal aberto, com os dados
  /// já baixados localmente.
  ///
  /// `limite` reproduz o `limit` que as queries do Firestore usavam: as seções
  /// mostram só as primeiras e oferecem "Ver mais".
  Stream<List<AcaoEntity>> watchByAnimalEAcao(
    String animalPath,
    String acao, {
    int? limite,
  }) =>
      box
          .query(AcaoEntity_.uidAnimalAnimaisProdutoresPath
              .equals(animalPath)
              .and(AcaoEntity_.acao.equals(acao))
              .and(AcaoEntity_.isDeleted.equals(false)))
          .order(AcaoEntity_.dataDaAcao, flags: Order.descending)
          .watch(triggerImmediately: true)
          .map((q) {
        final achados = q.find();
        return (limite == null || achados.length <= limite)
            ? achados
            : achados.sublist(0, limite);
      });

  Stream<List<AcaoEntity>> watchByParentPath(String parentPath) => box
      .query(AcaoEntity_.parentPath.equals(parentPath))
      .watch(triggerImmediately: true)
      .map((query) => query.find());
}
