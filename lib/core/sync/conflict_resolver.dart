/// Política CANÔNICA de resolução de conflitos para sincronização bidirecional
/// (Firestore -> ObjectBox).
///
/// Antes da refatoração, cada listener decidia de um jeito: o de animais
/// comparava timestamps, mas os de ações/tratamentos só olhavam `needsSync`,
/// sem comparar datas — comportamento inconsistente e propenso a perder dados.
/// Esta classe centraliza a regra única, para que todos os listeners (atuais e
/// futuros) decidam da mesma forma.
///
/// É lógica pura (sem ObjectBox/Firestore), portanto 100% testável.
///
/// ## Regra
///
/// Ao receber uma mudança REMOTA de um documento que também existe localmente:
///
/// 1. **Local pendente vence.** Se o registro local tem alterações ainda não
///    enviadas (`needsSync == true`), a mudança remota é IGNORADA — caso
///    contrário, perderíamos uma edição offline do usuário. Ela será enviada e
///    reconciliada no próximo push.
/// 2. **Mais novo vence (precisão de milissegundos).** Sem pendências locais e
///    com ambos os timestamps disponíveis, o remoto só sobrescreve se for
///    estritamente mais recente. Empate => mantém o local (evita escrita inútil).
/// 3. **Sem timestamps comparáveis => aplica o remoto.** Um evento de
///    modificação remota significa que o servidor é a fonte da verdade e o local
///    não tem nada pendente; na ausência de datas para comparar, aceita o remoto.
class ConflictResolver {
  const ConflictResolver._();

  /// Decide se a mudança remota deve sobrescrever o estado local.
  ///
  /// - [localHasPendingChanges]: o registro local tem `needsSync == true`?
  /// - [localLastModified] / [remoteLastModified]: datas de última modificação.
  static bool shouldApplyRemote({
    required bool localHasPendingChanges,
    required DateTime? localLastModified,
    required DateTime? remoteLastModified,
  }) {
    // 1. Edição local não sincronizada nunca é sobrescrita.
    if (localHasPendingChanges) return false;

    // 2. Ambos os timestamps presentes: mais novo vence (precisão de ms).
    if (remoteLastModified != null && localLastModified != null) {
      return remoteLastModified.millisecondsSinceEpoch >
          localLastModified.millisecondsSinceEpoch;
    }

    // 3. Sem datas comparáveis e sem pendência local: aceita o remoto.
    return true;
  }
}
