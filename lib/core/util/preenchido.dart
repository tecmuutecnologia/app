/// `true` quando o campo de texto tem conteúdo de verdade.
///
/// As telas herdadas do FlutterFlow decidem por `campo != ''` / `campo == ''`,
/// porque ali campo vazio era string vazia. As entidades do ObjectBox usam
/// `null`, e `null != ''` é TRUE: toda comparação dessas inverteu de sentido na
/// migração. No receituário, o efeito foi a tela nunca pedir a assinatura e
/// liberar o "Gerar PDF" como se o documento já estivesse assinado.
///
/// Só espaços conta como vazio: assinatura e observação em branco não são
/// conteúdo.
bool preenchido(String? valor) => (valor ?? '').trim().isNotEmpty;
