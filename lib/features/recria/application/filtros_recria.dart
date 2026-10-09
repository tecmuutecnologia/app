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
