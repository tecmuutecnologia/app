/// Quem aparece na lista de "Animais prenhas".
///
/// O predicado vivia dentro de um `Visibility` em cada card, sobre a lista do
/// rebanho INTEIRO — montava a arvore de cada animal para esconder quase
/// todas. Aqui ele filtra antes, e a lista recebe so o que vai aparecer.
library;

import '../../../data/schema/structs/animais_produtores_struct.dart';
import '../../../domain/animais/classificacao_animal.dart';
import '../../../domain/animais/filtro_lista_animais.dart';

/// Vacas e novilhas prenhas, filtradas tambem pelo termo buscado.
///
/// Nao filtra por propriedade: isso passou a acontecer na origem, com a
/// consulta indexada `getAnimaisByPropriedade`.
List<AnimaisProdutoresStruct> prenhasVisiveis(
  List<AnimaisProdutoresStruct> animais, {
  String busca = '',
}) {
  return animais
      .where((item) =>
          ehVacaOuNovilha(item.grupoAnimal) &&
          ehPrenha(item.status) &&
          !temDataSentinela(item.compararDtUltimaInseminacao) &&
          casaBuscaAnimal(
              nome: item.nomeAnimal, brinco: item.brincoAnimal, termo: busca))
      .toList();
}
