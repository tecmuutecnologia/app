import 'sync_etapa.dart';

/// Quais etapas do download completo ainda faltam.
///
/// Existe porque `performFullDownload` era tudo-ou-nada: uma falha na etapa
/// `animais` descartava as cinco anteriores e o próximo login rebaixava tudo
/// desde o começo. Sob restrição de quota isso nunca converge — cada tentativa
/// gasta o orçamento nas etapas que já tinham dado certo.
///
/// A decisão de "o que rodar agora" fica aqui, pura, porque o serviço de sync é
/// I/O puro e não se testa sem rede nem banco.
class SyncCheckpoint {
  const SyncCheckpoint(this.concluidas);

  /// Etapas já concluídas com sucesso, lidas das marcas persistidas.
  final Set<SyncEtapa> concluidas;

  /// Etapas que faltam, na ordem declarada em [SyncEtapa] — que é a ordem de
  /// execução e também a ordem de dependência (referências antes de tudo,
  /// técnico antes de animais).
  List<SyncEtapa> get pendentes =>
      SyncEtapa.values.where((e) => !concluidas.contains(e)).toList();

  bool get tudoConcluido => pendentes.isEmpty;

  /// Nome da linha em `SyncMetadataEntity` que guarda a marca da etapa. O
  /// prefixo evita colisão com as linhas de coleção já existentes
  /// (`initial_download`, `reparo_path_propriedades`).
  static String chaveDe(SyncEtapa etapa) => 'etapa_${etapa.name}';
}
