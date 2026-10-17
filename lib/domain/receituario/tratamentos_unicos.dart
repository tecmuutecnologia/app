import '/data/objectbox/entities/index.dart';

/// Tira os tratamentos repetidos de uma lista, mantendo o primeiro de cada.
///
/// Repetido é o mesmo animal com o mesmo tipo de ação, na mesma visita e com a
/// mesma observação. Esses documentos são cópias deixadas por envios
/// duplicados do sync. Dois manejos do animal no mesmo dia geram tipos
/// diferentes e continuam todos.
///
/// Fica na leitura porque o app não aplica exclusões remotas: limpar o
/// Firestore não tira as cópias que um aparelho já baixou.
List<TratamentoEntity> tratamentosUnicos(Iterable<TratamentoEntity> lista) {
  final vistos = <String>{};
  return [
    for (final t in lista)
      if (vistos.add(_chave(t))) t,
  ];
}

String _chave(TratamentoEntity t) => [
      t.uidResumoDaVisitaPath,
      t.tipoAcao,
      t.uidAnimalPath ?? '${t.brincoAnimal}|${t.nomeAnimal}',
      t.observacaoAcao ?? '',
    ].join('\u0000');
