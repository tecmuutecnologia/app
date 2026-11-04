/// Quem aparece na seleção de animais do Calendário Sanitário.
library;

import '../../../data/objectbox/entities/animal_entity.dart';
import '../../../domain/animais/classificacao_animal.dart';

/// Filtro e ordem das listas da seleção, lidos do ObjectBox.
///
/// Reproduz as consultas que a tela fazia direto no Firestore (que offline não
/// respondiam e deixavam de fora o animal criado sem internet):
/// - "Todos" ([grupo] nulo): todo o rebanho menos sêmen, por grupo, nome e
///   brinco;
/// - por grupo: só aquele grupo e sem descarte, por status, nome e brinco.
List<AnimalEntity> animaisDoCalendario(
  Iterable<AnimalEntity> animais, {
  String? grupo,
}) {
  final lista = animais.where((a) {
    if (a.isDeleted || ehSemens(a.grupoAnimal)) return false;
    if (grupo == null) return true;
    return a.grupoAnimal == grupo && !ehDescarte(a.status);
  }).toList();

  int texto(String? x, String? y) => (x ?? '').compareTo(y ?? '');
  lista.sort((a, b) {
    final primeiro = grupo == null
        ? texto(a.grupoAnimal, b.grupoAnimal)
        : texto(a.status, b.status);
    if (primeiro != 0) return primeiro;
    final nome = texto(a.nomeAnimal, b.nomeAnimal);
    if (nome != 0) return nome;
    return a.brincoAnimalOrder.compareTo(b.brincoAnimalOrder);
  });
  return lista;
}
