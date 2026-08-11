/// Converte um contador já disponível em total para a barra de progresso.
///
/// A sincronização usava `count()` do Firestore só para saber o total de cada
/// etapa. Essa *aggregation query* tem cota própria e, esgotada, derrubava o
/// download inteiro — um indicador cosmético matando a sincronização.
///
/// Os contadores que alimentam esta função já estão no aparelho (o documento do
/// técnico traz `quantidadeAnimaisCadastrados`; as etapas guardam o total da
/// última execução), então a barra volta a andar sem nenhuma ida à rede.
///
/// Zero e negativo viram nulo: significam "nunca foi preenchido" ou "contador
/// corrompido", e um total desses produziria uma barra parada ou ao contrário.
/// Nulo aqui é honesto — a tela mostra progresso indeterminado.
int? totalEstimado(int? contagem) =>
    (contagem == null || contagem <= 0) ? null : contagem;
