/// Quais animais aparecem em cada aba de "Animais em secagem".
///
/// Antes estes predicados viviam dentro de um `Visibility` em cada card, e a
/// lista iterada era o rebanho INTEIRO do tecnico. O resultado medido numa
/// propriedade de 3 animais: 2304 cards construidos para 1 visivel, e 4608
/// durante a animacao de troca de aba — porque `Visibility` esconde um widget
/// que ja foi montado, e o `shrinkWrap` da lista montava todos de uma vez.
///
/// Filtrando ANTES de construir, a lista recebe so o que vai aparecer.
library;

import '../../../data/schema/structs/animais_produtores_struct.dart';
import '../../../domain/animais/classificacao_animal.dart';
import '../../../domain/animais/filtro_lista_animais.dart';

export '../../../domain/animais/filtro_lista_animais.dart'
    show temDataSentinela;

enum AbaSecas { vacasSecas, preParto, inducaoLactacao, descarte }

/// Os animais de UMA aba, ja filtrados pela busca.
///
/// Nao filtra por propriedade de proposito: isso passou a acontecer na origem,
/// com a consulta indexada `getAnimaisByPropriedade`, em vez de carregar o
/// rebanho todo com `getAll()` e descartar card por card.
List<AnimaisProdutoresStruct> animaisDaAba(
  List<AnimaisProdutoresStruct> animais, {
  required AbaSecas aba,
  String busca = '',
}) {
  return animais.where((item) {
    if (!casaBuscaAnimal(
        nome: item.nomeAnimal, brinco: item.brincoAnimal, termo: busca)) {
      return false;
    }

    switch (aba) {
      case AbaSecas.vacasSecas:
        return ehVacaSeca(item.grupoAnimal, item.status) &&
            !temDataSentinela(item.compararDtUltimaInseminacao);
      case AbaSecas.preParto:
        // Grafia com ESPACO, como estava no card. O dominio tem `ehPreParto`,
        // que casa tambem 'Pré-parto' (hifen) — trocar aqui mudaria quem
        // aparece na aba, entao fica como estava ate alguem decidir unificar.
        return item.status == kStatusPrePartoEspaco &&
            !temDataSentinela(item.compararDtUltimaInseminacao);
      case AbaSecas.inducaoLactacao:
        return item.dtInducaoLactacao != null;
      case AbaSecas.descarte:
        return ehDescarte(item.status);
    }
  }).toList();
}
