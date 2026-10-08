/// Quem aparece na lista de "Exame ginecológico".
///
/// O predicado vivia dentro de um `Visibility` em cada card, sobre a lista do
/// rebanho INTEIRO. Aqui ele filtra antes de construir.
library;

import '../../../data/schema/structs/animais_produtores_struct.dart';
import '../../../domain/animais/classificacao_animal.dart';
import '../../../domain/animais/filtro_lista_animais.dart';

/// Vacas e novilhas vazias e sem inducao de lactacao, filtradas tambem pelo
/// termo buscado.
///
/// Nao filtra por propriedade: isso acontece na origem, com a consulta
/// indexada `getAnimaisByPropriedade`.
List<AnimaisProdutoresStruct> elegiveisExame(
  List<AnimaisProdutoresStruct> animais, {
  String busca = '',
}) {
  return animais
      .where((item) =>
          ehVazia(item.status) &&
          ehVacaOuNovilha(item.grupoAnimal) &&
          item.dtInducaoLactacao == null &&
          casaBuscaAnimal(
              nome: item.nomeAnimal, brinco: item.brincoAnimal, termo: busca))
      .toList();
}
