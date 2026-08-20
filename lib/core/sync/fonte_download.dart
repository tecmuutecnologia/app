/// De onde o download completo tira os dados.
enum FonteDeDownload {
  /// Subcoleções do documento do técnico logado (`tecnico/{id}/...`).
  tecnico,

  /// Pelas propriedades do produtor — ver `alvosAnimaisProdutor`.
  produtor,
}

/// Decide a fonte do download a partir do papel JÁ resolvido no login.
///
/// Existe porque o papel era decidido duas vezes, por critérios diferentes: o
/// login dá preferência à propriedade ligada à pessoa (`decidirPosLogin`), e o
/// download olhava só para "existe documento de técnico com este uid?". Um
/// técnico fantasma na conta de um produtor — sobra de um cadastro indevido,
/// com `uidPerson` preenchido e mais nada — bastava para o download inteiro
/// apontar para um documento vazio: nenhuma propriedade, nenhum animal, e
/// nenhum erro na tela.
///
/// [ehProdutor] nulo = ninguém informou (chamadas que não vêm do login, como
/// `forceFullSync`); aí vale o critério antigo.
FonteDeDownload fonteDeDownload({
  required bool? ehProdutor,
  required bool temDocumentoDeTecnico,
}) {
  if (ehProdutor == true) return FonteDeDownload.produtor;
  return temDocumentoDeTecnico
      ? FonteDeDownload.tecnico
      : FonteDeDownload.produtor;
}
