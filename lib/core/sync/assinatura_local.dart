/// Assinaturas do receituário gravadas no aparelho antes de subir ao Storage.
///
/// A assinatura era enviada ao Storage ANTES de ser gravada: com rede fraca o
/// técnico esperava o upload para fechar o modal, e offline a assinatura se
/// perdia ("Envio de dados falhou"). Agora o PNG vai para um arquivo local e o
/// campo do resumo guarda uma referência `local:<arquivo>` até o sync subir o
/// arquivo e trocar pela URL.
///
/// Guarda-se só o nome do arquivo, não o caminho absoluto: no iOS o diretório
/// do app muda de UUID a cada reinstalação.
library;

const prefixoAssinaturaLocal = 'local:';

/// `true` quando o valor é uma assinatura que ainda não subiu ao Storage.
bool ehAssinaturaLocal(String? valor) =>
    valor != null && valor.startsWith(prefixoAssinaturaLocal);

String referenciaLocal(String nomeArquivo) =>
    '$prefixoAssinaturaLocal$nomeArquivo';

/// Nome do arquivo de uma referência `local:`.
String nomeArquivoLocal(String referencia) =>
    referencia.substring(prefixoAssinaturaLocal.length);

/// Devolve o valor que fica no aparelho quando chega uma versão do servidor.
///
/// O download sobrescreve o resumo inteiro. Sem esta regra, o eco da própria
/// subida (que vai sem a assinatura, ainda local) apagava a referência e a
/// assinatura sumia antes de chegar ao Storage. A local só cede para uma URL
/// de verdade vinda do servidor.
String? assinaturaAposDownload({
  required String? local,
  required String? baixada,
}) {
  if (!ehAssinaturaLocal(local)) return baixada;
  final servidorTemUrl = baixada != null &&
      baixada.trim().isNotEmpty &&
      !ehAssinaturaLocal(baixada);
  return servidorTemUrl ? baixada : local;
}

/// Nome do arquivo de uma URL do Storage, usado como chave da cópia local.
///
/// A URL de download traz o caminho do objeto codificado no último segmento
/// (`.../o/users%2F<uid>%2Fuploads%2Fsignature_123.png?alt=media&token=...`).
/// Como o upload usa o mesmo nome do arquivo local, a assinatura feita neste
/// aparelho continua achando o próprio arquivo depois de virar URL.
/// `null` quando a URL não termina num nome de imagem reconhecível.
String? nomeArquivoDaUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null || uri.pathSegments.isEmpty) return null;
  final nome = uri.pathSegments.last.split('/').last;
  return RegExp(r'^[\w.-]+\.(png|jpe?g)$').hasMatch(nome) ? nome : null;
}
