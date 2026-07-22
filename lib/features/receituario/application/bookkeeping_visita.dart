import 'package:cloud_firestore/cloud_firestore.dart';

import '/data/objectbox/index.dart';

/// Bookkeeping da visita, offline-first.
///
/// Toda ação de manejo (exame ginecológico, pré-parto, secagem, calendário
/// sanitário) alimenta o receituário do dia: garante que exista um
/// `ResumoDaVisita` para a propriedade naquela data, registra o `Tratamento`
/// e, se ainda não houver, a `Recomendacao` correspondente.
///
/// Antes isso vivia duplicado dentro de cada formulário, em dois ramos quase
/// idênticos (resumo existente / resumo novo) — 8 caminhos no total — e só
/// rodava online, porque eram queries e `set` diretos no Firestore.
///
/// Aqui é um caminho só, gravando no ObjectBox. O `ResumoVisitaRepository`
/// pré-gera o `firestoreId`, então os filhos já nascem apontando para o id
/// definitivo, mesmo sem rede.
Future<void> registrarBookkeepingVisita({
  required DocumentReference? uidPropriedade,
  required DocumentReference? uidTecnico,
  required String dataFormatada,
  required String? tituloRecomendacao,
  required String? descricaoRecomendacao,
  DocumentReference? uidAnimal,
  DocumentReference? uidAcaoLancada,
  String? observacaoAcao,
  String? nomeAnimal,
  String? brincoAnimal,
  String? grupoAnimal,
  int brincoAnimalOrder = 0,
}) async {
  if (uidPropriedade == null) return;

  final propriedadePath = uidPropriedade.path;
  final resumoRepo = ResumoVisitaRepository();

  // 1) Resumo da visita DO DIA para esta propriedade — reaproveita se já
  //    existir, senão cria.
  var resumo = resumoRepo
      .getByPropriedade(propriedadePath)
      .where((e) => !e.isDeleted && e.dtVisitaFormatado == dataFormatada)
      .firstOrNull;

  if (resumo == null) {
    resumo = ResumoVisitaEntity(
      parentPath: 'resumo_da_visita',
      uidPropriedadePath: propriedadePath,
      uidTecnicoPath: uidTecnico?.path,
      dtVisita: DateTime.now(),
      dtVisitaFormatado: dataFormatada,
    );
    await resumoRepo.add(resumo);
    // `uidResumoDaVisita` aponta para o próprio documento (o app já fazia
    // isso, num segundo update depois de criar).
    if (resumo.firestoreId != null) {
      resumo.uidResumoDaVisitaPath = 'resumo_da_visita/${resumo.firestoreId}';
      await resumoRepo.save(resumo);
    }
  }

  final resumoPath = resumo.firestoreId == null
      ? null
      : 'resumo_da_visita/${resumo.firestoreId}';

  // 2) Tratamento sempre entra.
  await TratamentoRepository().add(TratamentoEntity(
    parentPath: propriedadePath,
    uidAnimalPath: uidAnimal?.path,
    uidResumoDaVisitaPath: resumoPath,
    uidAcaoLancadaPath: uidAcaoLancada?.path,
    tipoAcao: tituloRecomendacao,
    observacaoAcao: observacaoAcao,
    nomeAnimal: nomeAnimal,
    dtAcaoTratamento: dataFormatada,
    grupoAnimal: grupoAnimal,
    brincoAnimal: brincoAnimal,
    brincoAnimalOrder: brincoAnimalOrder,
  ));

  // 3) Recomendação só se ainda não houver uma com o mesmo título nesta
  //    visita (mesma checagem que a query original fazia).
  final recomendacaoRepo = RecomendacaoRepository();
  final jaTem = recomendacaoRepo
      .getByParentPath(propriedadePath)
      .any((e) =>
          !e.isDeleted &&
          e.uidResumoDaVisitaPath == resumoPath &&
          e.tituloRecomendacao == tituloRecomendacao);

  if (!jaTem) {
    await recomendacaoRepo.add(RecomendacaoEntity(
      parentPath: propriedadePath,
      uidResumoDaVisitaPath: resumoPath,
      tituloRecomendacao: tituloRecomendacao,
      descricaoRecomendacao: descricaoRecomendacao,
    ));
  }
}
