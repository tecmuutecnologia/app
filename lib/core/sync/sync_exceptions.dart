import 'package:firebase_core/firebase_core.dart';

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

/// A cota do Firestore foi atingida no meio do download completo.
///
/// Distinta de [SyncFalhaException] porque nao e falha do app nem do dado: os
/// registros baixados ate aqui sao validos e o usuario pode entrar. A tela
/// avisa em vez de bloquear, e a retomada por etapa cuida do restante.
class SyncCotaExcedidaException implements Exception {
  const SyncCotaExcedidaException(this.etapa, this.causa);

  final SyncEtapa? etapa;
  final Object causa;

  String get mensagem => causa.toString();

  @override
  String toString() => 'SyncCotaExcedidaException($etapa): $mensagem';
}

/// `true` quando o erro e esgotamento de cota do Firestore.
///
/// Checa duas formas porque o erro chega diferente conforme a camada: o SDK
/// devolve `FirebaseException(code: 'resource-exhausted')`, mas o canal da
/// plataforma no Android embrulha em `PlatformException` e o codigo original
/// so sobrevive no texto.
bool ehErroDeCota(Object erro) {
  if (erro is FirebaseException && erro.code == 'resource-exhausted') {
    return true;
  }
  final texto = erro.toString();
  return texto.contains('RESOURCE_EXHAUSTED') ||
      texto.contains('resource-exhausted');
}
