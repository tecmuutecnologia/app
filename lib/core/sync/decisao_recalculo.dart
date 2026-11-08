import 'package:tecmuu/data/objectbox/entities/tecnico_entity.dart';

/// Depois do `update` no servidor: a entidade a gravar no ObjectBox, ou `null`
/// para não mexer no local. [fresca] precisa ser relida APÓS o `update`, para
/// não sobrescrever um débito feito enquanto o recálculo aguardava a rede. Se
/// a fila do técnico ganhou operação nesse meio-tempo, o local já está certo e
/// o servidor converge quando a fila subir.
TecnicoEntity? aplicarAposGravar({
  required TecnicoEntity? fresca,
  required Map<String, int> campos,
  required bool filaPendente,
}) {
  if (fresca == null || filaPendente) return null;
  campos.forEach((chave, valor) {
    switch (chave) {
      case 'limiteAnimaisContratado':
        fresca.limiteAnimaisContratado = valor;
      case 'quantidadeAnimaisCadastrados':
        fresca.quantidadeAnimaisCadastrados = valor;
      case 'restanteLimiteAnimais':
        fresca.restanteLimiteAnimais = valor;
      case 'limiteProdutoresContratado':
        fresca.limiteProdutoresContratado = valor;
      case 'quantidadeProdutoresCadastrados':
        fresca.quantidadeProdutoresCadastrados = valor;
      case 'restanteLimiteProdutores':
        fresca.restanteLimiteProdutores = valor;
    }
  });
  return fresca;
}

/// Soma em [base] os [deltas] ainda na fila; campos fora de [base] são
/// ignorados. O servidor ainda não recebeu esses deltas, e somá-los evita que
/// uma operação que nunca sobe congele o saldo local num valor antigo.
Map<String, int> somarDeltasDaFila(
  Map<String, int> base,
  Iterable<Map<String, int>> deltas,
) {
  final soma = Map<String, int>.of(base);
  for (final delta in deltas) {
    delta.forEach((campo, valor) {
      if (soma.containsKey(campo)) soma[campo] = soma[campo]! + valor;
    });
  }
  return soma;
}

/// Antes de aplicar o técnico baixado do servidor: com a fila do técnico
/// pendente, os 6 campos de cota locais já contêm deltas que o servidor ainda
/// não recebeu — devolve-os para regravar por cima (via [aplicarAposGravar]).
/// `null` = sem fila, vale o servidor.
Map<String, int>? cotaLocalAPreservar({
  required TecnicoEntity local,
  required bool filaPendente,
}) {
  if (!filaPendente) return null;
  return {
    'limiteAnimaisContratado': local.limiteAnimaisContratado,
    'quantidadeAnimaisCadastrados': local.quantidadeAnimaisCadastrados,
    'restanteLimiteAnimais': local.restanteLimiteAnimais,
    'limiteProdutoresContratado': local.limiteProdutoresContratado,
    'quantidadeProdutoresCadastrados': local.quantidadeProdutoresCadastrados,
    'restanteLimiteProdutores': local.restanteLimiteProdutores,
  };
}
