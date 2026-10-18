/// Quem entra na lista de Recria.
library;

import '../../../domain/animais/classificacao_animal.dart';

/// `false` para semen. Recria e manejo de animal que cresce; semen e insumo de
/// inseminacao e nao tem o que ser recriado.
///
/// Usa `ehSemens`, que casa as DUAS grafias legadas ('Sêmens' e 'Semêns'). O
/// filtro de chip da tela compara a string direto, entao sozinho ele deixaria
/// passar os registros gravados com a outra grafia.
bool ehDaRecria(String? grupoAnimal) => !ehSemens(grupoAnimal);

/// Se o animal aparece como card na Recria. Era a regra escondida no
/// `AnimalCardWidget` (que devolvia um card vazio); morando aqui, a lista e
/// os contadores das abas usam a MESMA regra e o número nunca diverge do que
/// aparece.
///
/// Entram bezerras, bezerros, touros e novilhas sem lactação induzida (a
/// induzida é tratada nas Secas); descarte e pré-parto ficam de fora.
bool apareceNaRecria({
  required String? grupo,
  required String? status,
  required bool temInducaoLactacao,
}) {
  if (!ehDaRecria(grupo)) return false;
  final grupoValido = ehTouros(grupo) ||
      (ehNovilha(grupo) && !temInducaoLactacao) ||
      ehBezerras(grupo) ||
      ehBezerros(grupo);
  return grupoValido && !ehDescarte(status) && status != 'Pré Parto';
}
