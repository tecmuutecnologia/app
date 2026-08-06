/// Etapas do download completo, na ordem em que `performFullDownload` executa.
enum SyncEtapa {
  referencias,
  usuario,
  tecnico,
  produtores,
  propriedades,
  animais,
  acoes,
  financeiro,
}

/// Faixa que cada etapa ocupa na barra global. Os valores reproduzem os que o
/// `performFullDownload` ja reportava, para o ritmo da barra nao mudar.
extension SyncEtapaFaixa on SyncEtapa {
  double get inicio => switch (this) {
        SyncEtapa.referencias => 0.00,
        SyncEtapa.usuario => 0.15,
        SyncEtapa.tecnico => 0.20,
        SyncEtapa.produtores => 0.30,
        SyncEtapa.propriedades => 0.50,
        SyncEtapa.animais => 0.60,
        SyncEtapa.acoes => 0.70,
        SyncEtapa.financeiro => 0.85,
      };

  double get fim => switch (this) {
        SyncEtapa.referencias => 0.15,
        SyncEtapa.usuario => 0.20,
        SyncEtapa.tecnico => 0.30,
        SyncEtapa.produtores => 0.50,
        SyncEtapa.propriedades => 0.60,
        SyncEtapa.animais => 0.70,
        SyncEtapa.acoes => 0.85,
        SyncEtapa.financeiro => 1.00,
      };
}

/// Fracao 0..1 da barra global. Com `atual`/`total`, interpola dentro da faixa
/// da etapa; sem eles, fica no inicio da faixa.
double progressoGlobal(SyncEtapa etapa, {int? atual, int? total}) {
  if (atual == null || total == null || total <= 0) return etapa.inicio;
  final fracao = (atual / total).clamp(0.0, 1.0);
  return etapa.inicio + (etapa.fim - etapa.inicio) * fracao;
}
