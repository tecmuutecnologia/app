/// Faz as entidades recém-baixadas herdarem o `id` local das que já existem,
/// para que o `put` do ObjectBox seja um UPDATE em vez de um INSERT.
///
/// As tabelas de referência (grupo, raça, status, tipo de ação, calendário,
/// cidades) são reconstruídas do zero a cada download completo, e
/// `fromFirestore` devolve sempre `id = 0` — o que significa INSERT. Como o
/// `firestoreId` delas é `@Unique`, o segundo download completo do aparelho
/// (troca de usuário, ou o re-download automático quando o cache de animais
/// está vazio) estourava:
///
///   Unique constraint for GrupoEntity.firestoreId would be violated
///
/// E como esse erro sobe, ele derrubava o download inteiro no primeiro passo:
/// o usuário não recebia nem propriedades nem animais.
///
/// Quem não existe localmente fica com `id = 0` de propósito — esse é o INSERT
/// legítimo.
void reaproveitarIds<T>({
  required Iterable<T> existentes,
  required Iterable<T> baixados,
  required String? Function(T) firestoreIdDe,
  required int Function(T) idDe,
  required void Function(T entity, int id) definirId,
}) {
  final idPorFirestoreId = <String, int>{};
  for (final existente in existentes) {
    final firestoreId = firestoreIdDe(existente);
    if (firestoreId != null && firestoreId.isNotEmpty) {
      idPorFirestoreId[firestoreId] = idDe(existente);
    }
  }

  if (idPorFirestoreId.isEmpty) return;

  for (final baixado in baixados) {
    final firestoreId = firestoreIdDe(baixado);
    if (firestoreId == null) continue;

    final idLocal = idPorFirestoreId[firestoreId];
    if (idLocal != null) definirId(baixado, idLocal);
  }
}
