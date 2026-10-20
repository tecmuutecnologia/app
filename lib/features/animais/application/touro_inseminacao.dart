/// Touro/sêmen da última inseminação: as opções do campo nos formulários de
/// animal (novo e editar).
library;

import '../../../data/objectbox/entities/index.dart';

/// Rótulos dos touros e sêmens liberados para inseminação, sem repetição e em
/// ordem alfabética.
///
/// [atual] (o touro já gravado no animal) entra mesmo que não esteja mais na
/// lista — ex.: o sêmen foi descartado ou deixou de estar liberado. Sem isso o
/// campo do editar abria vazio, e salvar apagaria o vínculo.
List<String> opcoesTouroInseminacao(
  Iterable<AnimalEntity> animaisDaPropriedade, {
  String? atual,
}) {
  final rotulos = animaisDaPropriedade
      .where((a) => !a.isDeleted && a.liberaInseminacao)
      .map((a) => (a.nomeBrincoConcat ?? '').trim())
      .where((r) => r.isNotEmpty)
      .toSet()
      .toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  final gravado = (atual ?? '').trim();
  if (gravado.isNotEmpty && !rotulos.contains(gravado)) {
    rotulos.insert(0, gravado);
  }
  return rotulos;
}
