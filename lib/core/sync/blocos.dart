/// Quebra [itens] em blocos de até [tamanho].
///
/// O `whereIn` do Firestore aceita no máximo 30 valores por consulta. A busca
/// das ações de um produtor vai pelos ANIMAIS dele (e não por
/// `uidPropriedade`), porque ação antiga foi gravada sem esse campo — DG,
/// secagem e aborto nunca o preenchiam — e ficaria invisível para sempre.
List<List<T>> emBlocos<T>(List<T> itens, int tamanho) {
  assert(tamanho > 0, 'bloco precisa de tamanho positivo');
  return [
    for (var i = 0; i < itens.length; i += tamanho)
      itens.sublist(i, i + tamanho > itens.length ? itens.length : i + tamanho),
  ];
}
