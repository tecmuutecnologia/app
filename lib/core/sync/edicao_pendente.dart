import '../../data/objectbox/entities/syncable_entity.dart';

/// Filtra os [ids] baixados, tirando os que têm edição local ainda não enviada.
///
/// Com o listener em tempo real, um evento remoto pode chegar antes de o push
/// local sair. A edição pendente vence: ela vai chegar ao servidor e voltar
/// para os outros aparelhos. Mesma regra de `reconciliarAnimais`.
List<String> semEdicaoPendente(
  List<String> ids,
  Iterable<SyncableEntity> existentes,
) {
  final pendentes = {
    for (final e in existentes)
      if (e.needsSync && e.firestoreId != null) e.firestoreId!,
  };
  return [
    for (final id in ids)
      if (!pendentes.contains(id)) id
  ];
}
