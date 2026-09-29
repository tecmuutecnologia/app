/// Categorias que o relatório deve considerar.
///
/// Nenhuma marcada significa TODAS: é o que o filtro vazio sugere e o que a
/// tela já faz ao abrir (o dropdown nasce com tudo selecionado). Antes o botão
/// simplesmente não fazia nada quando o usuário desmarcava tudo — clique sem
/// efeito e sem aviso.
List<String> categoriasDoRelatorio(
  List<String>? selecionadas,
  List<String> disponiveis,
) =>
    (selecionadas == null || selecionadas.isEmpty) ? disponiveis : selecionadas;
