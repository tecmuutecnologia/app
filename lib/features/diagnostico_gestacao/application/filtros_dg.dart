/// Quem aparece na lista de "Diagnóstico de gestação".
///
/// O predicado vivia dentro de um `Visibility` em cada card, sobre a lista do
/// rebanho INTEIRO. Aqui ele filtra antes de construir.
library;

import '../../../core/ui/custom_functions.dart' as functions;
import '../../../data/schema/structs/animais_produtores_struct.dart';
import '../../../domain/animais/classificacao_animal.dart';
import '../../../domain/animais/filtro_lista_animais.dart';

/// Vacas e novilhas inseminadas cujo prazo de [diasDg] ja venceu.
///
/// [agora] e injetavel para o teste nao depender do relogio; em producao cai
/// no `obterDataAtual()` de sempre.
///
/// Nao filtra por propriedade: isso acontece na origem, com a consulta
/// indexada `getAnimaisByPropriedade`.
List<AnimaisProdutoresStruct> vencidosParaDg(
  List<AnimaisProdutoresStruct> animais, {
  required String diasDg,
  String busca = '',
  DateTime? agora,
}) {
  final referencia = agora ?? functions.obterDataAtual();

  return animais
      .where((item) =>
          item.dtUltimaInseminacao != '' &&
          ehVacaOuNovilha(item.grupoAnimal) &&
          (ehInseminada(item.status) || ehInseminadaPP(item.status)) &&
          !functions
              .converterStringParaData(item.dtUltimaInseminacao, diasDg)
              .isAfter(referencia) &&
          casaBuscaAnimal(
              nome: item.nomeAnimal, brinco: item.brincoAnimal, termo: busca))
      .toList();
}
