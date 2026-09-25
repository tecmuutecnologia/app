/// Quanto do banco local ainda não chegou ao Firestore: operações na fila mais
/// entidades marcadas `needsSync` (inclusive exclusões ainda não enviadas).
///
/// Existe para o logout. Ele apaga o banco inteiro — senão o próximo usuário do
/// aparelho herdaria propriedades e animais do anterior — e o que não foi
/// enviado se perde junto. O usuário precisa saber disso antes de confirmar.
///
/// Recebe contagens, e não as entidades, porque o chamador conta com uma query
/// no ObjectBox: carregar as ~16 mil ações de um técnico só para contar
/// travaria o botão de sair.
int contarNaoEnviados({
  required int filaPendente,
  required Iterable<int> pendentesPorColecao,
}) =>
    pendentesPorColecao.fold(filaPendente, (total, n) => total + n);
