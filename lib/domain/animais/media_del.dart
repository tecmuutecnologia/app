import 'classificacao_animal.dart';
import 'dias_desde.dart';

/// Vaca em lactação: grupo Vacas com status Vazia, Inseminada, Inseminada PP
/// ou Prenha.
///
/// Secas e pré-partos já pararam de produzir; novilhas ainda não pariram.
/// Os três ficam fora.
bool ehVacaEmLactacao(String? grupo, String? status) =>
    ehVaca(grupo) &&
    (ehVazia(status) ||
        ehInseminada(status) ||
        ehInseminadaPP(status) ||
        ehPrenha(status));

/// DEL (Dias em Lactação) médio do rebanho: média dos dias desde o último
/// parto das vacas em lactação ([ehVacaEmLactacao]), arredondada.
///
/// Vaca sem data de parto (ou com data inválida) não pesa na média. Devolve
/// `null` quando nenhuma vaca entra no cálculo.
///
/// A versão antiga do painel fazia a média de todo animal com último parto —
/// secas, pré-partos e novilhas inclusive.
int? mediaDiasEmLactacao(
  Iterable<({String? grupo, String? status, String? dtUltimoParto})> animais,
) {
  final dias = [
    for (final a in animais)
      if (ehVacaEmLactacao(a.grupo, a.status)) diasDesdeNum(a.dtUltimoParto),
  ].whereType<int>().toList();
  if (dias.isEmpty) return null;
  return (dias.reduce((s, d) => s + d) / dias.length).round();
}
