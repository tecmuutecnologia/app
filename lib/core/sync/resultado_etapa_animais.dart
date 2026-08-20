/// Devolve o erro que deve derrubar a etapa de animais, ou `null` se ela pode
/// ser dada por concluída.
///
/// O laço de alvos do produtor só relançava erro de cota; o resto virava um
/// `debugPrint` e a etapa era marcada como concluída mesmo sem ter baixado
/// nada. Um erro de índice ou de permissão ficava invisível: o produtor entrava
/// num app sem rebanho e sem mensagem alguma.
///
/// Falha parcial (um alvo entre vários) continua tolerada de propósito: os
/// animais das outras propriedades desceram e valem mais do que um login
/// abortado.
Object? erroFatalDaEtapaAnimais({
  required int alvos,
  required int falhas,
  required Object? primeiroErro,
}) =>
    alvos > 0 && falhas == alvos ? primeiroErro : null;
