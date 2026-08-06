import 'sync_etapa.dart';

/// Download completo pedido sem conexao. Distinta de uma falha: nao ha nada a
/// tentar consertar alem de reconectar, e a tela oferece so "Tentar novamente".
class SyncOfflineException implements Exception {
  const SyncOfflineException();

  @override
  String toString() => 'SyncOfflineException';
}

/// Uma etapa do download completo quebrou. Carrega a etapa para a tela poder
/// dizer o que falhou em vez de mostrar um erro generico.
class SyncFalhaException implements Exception {
  const SyncFalhaException(this.etapa, this.causa);

  final SyncEtapa? etapa;
  final Object causa;

  String get mensagem => causa.toString();

  @override
  String toString() => 'SyncFalhaException($etapa): $mensagem';
}
