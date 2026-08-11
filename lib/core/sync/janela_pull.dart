/// A partir de quando buscar alterações remotas no pull incremental.
///
/// A janela recua uma margem sobre a última sincronização em vez de usar o
/// instante exato. Sem isso, um documento cujo `serverTimestamp` cai entre a
/// leitura e a gravação da marca ficaria para sempre fora de toda janela
/// futura — perdido em silêncio. Reprocessar alguns documentos é barato; o
/// upsert é idempotente.
class JanelaPull {
  const JanelaPull._();

  /// Recuo aplicado sobre a última sincronização.
  static const Duration margem = Duration(minutes: 2);

  /// Início dos tempos, para quando nunca houve sincronização.
  static final DateTime epoca = DateTime.utc(1970);

  static DateTime desde(DateTime? ultimaSync) =>
      ultimaSync == null ? epoca : ultimaSync.subtract(margem);
}
