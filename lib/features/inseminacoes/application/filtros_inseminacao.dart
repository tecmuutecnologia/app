/// Quem aparece na lista de "Inseminações".
///
/// O predicado vivia dentro de um `Visibility` em cada card, sobre a lista do
/// rebanho INTEIRO — e ainda com um `ListView` de `shrinkWrap` aninhado em
/// outro `ListView`. Aqui ele filtra antes de construir.
library;

import '../../../data/schema/structs/animais_produtores_struct.dart';
import '../../../domain/animais/classificacao_animal.dart';
import '../../../domain/animais/filtro_lista_animais.dart';

/// Animais elegiveis a inseminacao (vaca/novilha vazia, inseminada ou
/// inseminada PP), filtrados tambem pelo termo buscado.
///
/// Nao filtra por propriedade: a tela le o rebanho do aparelho por um provider
/// reativo e aplica esse recorte antes de chamar esta funcao.
List<AnimaisProdutoresStruct> elegiveisInseminacao(
  Iterable<AnimaisProdutoresStruct> animais, {
  String busca = '',
}) {
  return animais
      .where((item) =>
          ehElegivelInseminacao(item.grupoAnimal, item.status) &&
          casaBuscaAnimal(
              nome: item.nomeAnimal, brinco: item.brincoAnimal, termo: busca))
      .toList();
}
