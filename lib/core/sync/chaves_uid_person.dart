/// Valores aceitáveis para o campo `uidPerson` de um documento de técnico.
///
/// O campo nasceu ambíguo: o cadastro de perfil gravava o id do documento
/// `person`, enquanto as telas de propriedade gravavam o uid do Auth. Os dois
/// coincidem quando o `person` foi criado como `person/{uid}`, e só por isso o
/// descompasso passou despercebido — um técnico cujo `person` tenha id
/// automático fica invisível à consulta do download, que devolve nulo e o trata
/// como produtor.
///
/// Ordem estável (Auth primeiro) e sem repetição: `whereIn` rejeita valores
/// duplicados.
List<String> chavesUidPerson({
  required String authUid,
  required String? personDocId,
}) =>
    <String>{
      authUid,
      if (personDocId != null && personDocId.isNotEmpty) personDocId,
    }.toList();
