import 'classificacao_animal.dart';

/// Baixa do animal: ele sai do rebanho por DESCARTE ou por VENDA.
///
/// Os dois casos gravam `status = 'Descarte'` — assim todos os filtros
/// existentes (`ehDescarte`), a conta de vagas, o painel web e as versões
/// antigas do app continuam tratando o animal como fora do rebanho. O que
/// diferencia a venda é o campo `tipoBaixa`. Descartes gravados antes desta
/// versão não têm `tipoBaixa` e contam como descarte.
const String kTipoBaixaVenda = 'venda';
const String kTipoBaixaDescarte = 'descarte';

/// Motivo gravado em `motivoDescarteAnimal` numa venda, para que telas e
/// versões antigas que exibem o motivo mostrem algo coerente.
const String kMotivoVenda = 'Venda';

/// Vendido = em baixa E com `tipoBaixa` de venda. Nunca olhar só o
/// `tipoBaixa`: uma versão antiga pode restaurar o animal (status volta a
/// 'Vazia') sem limpar o campo.
bool ehVendido(String? status, String? tipoBaixa) =>
    ehDescarte(status) && tipoBaixa == kTipoBaixaVenda;

/// Em baixa por descarte (inclui descartes antigos, sem `tipoBaixa`).
bool ehDescartadoSemVenda(String? status, String? tipoBaixa) =>
    ehDescarte(status) && tipoBaixa != kTipoBaixaVenda;

/// Sêmen nunca é vendido; animal já vendido ou excluído também não. Um
/// descartado pode ser vendido (sai dos Descartados e vai para os Vendidos).
bool podeVender({
  required String? grupo,
  required String? status,
  required String? tipoBaixa,
  required bool isDeleted,
}) =>
    !isDeleted && !ehSemens(grupo) && !ehVendido(status, tipoBaixa);
