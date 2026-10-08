/// Regras puras compartilhadas pelas telas-lista de animais (secas, prenhas,
/// diagnostico de gestacao, exame ginecologico, inseminacoes).
///
/// Elas existem para que o filtro aconteca ANTES de montar os cards. Quando
/// vivia dentro de um `Visibility` em cada card, a tela montava a arvore
/// inteira de cada animal do rebanho para esconder quase todas: medido na
/// `secas`, 2304 cards construidos para 1 visivel.
library;

/// Data impossivel que o codigo legado usa como "sem data".
///
/// Antes cada tela verificava isto FORMATANDO a data e comparando com a string
/// '31/12/2050' — uma regra de negocio que dependia do locale do contexto.
/// `null` nao e sentinela: animal sem data continua na lista.
bool temDataSentinela(DateTime? data) =>
    data != null && data.day == 31 && data.month == 12 && data.year == 2050;

/// `true` quando nome ou brinco casam com o termo pesquisado.
/// Termo vazio casa com todos.
bool casaBuscaAnimal({
  required String nome,
  required int brinco,
  required String termo,
}) {
  if (termo.isEmpty) return true;
  final alvo = termo.toLowerCase();
  return nome.toLowerCase().contains(alvo) || brinco.toString().contains(alvo);
}
