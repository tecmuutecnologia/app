import 'package:tecmuu/data/objectbox/entities/tecnico_entity.dart';
import 'package:tecmuu/domain/plano/vagas.dart';

/// Campos do técnico a gravar após recalcular as vagas, ou `null` quando não
/// há o que gravar. Com a fila do técnico pendente não grava nada: o servidor
/// ainda não recebeu os incrementos locais e o recálculo os sobrescreveria.
Map<String, int>? camposParaGravar({
  required TecnicoEntity atual,
  required SaldoVagas animais,
  required SaldoVagas produtores,
  required bool filaPendente,
}) {
  if (filaPendente) return null;
  final campos = <String, int>{};
  void se(String chave, int antes, int depois) {
    if (antes != depois) campos[chave] = depois;
  }

  se('limiteAnimaisContratado', atual.limiteAnimaisContratado, animais.limite);
  se('quantidadeAnimaisCadastrados', atual.quantidadeAnimaisCadastrados,
      animais.quantidade);
  se('restanteLimiteAnimais', atual.restanteLimiteAnimais, animais.restante);
  se('limiteProdutoresContratado', atual.limiteProdutoresContratado,
      produtores.limite);
  se('quantidadeProdutoresCadastrados', atual.quantidadeProdutoresCadastrados,
      produtores.quantidade);
  se('restanteLimiteProdutores', atual.restanteLimiteProdutores,
      produtores.restante);
  return campos.isEmpty ? null : campos;
}
