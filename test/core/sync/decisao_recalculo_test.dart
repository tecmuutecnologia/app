import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/decisao_recalculo.dart';
import 'package:tecmuu/data/objectbox/entities/tecnico_entity.dart';
import 'package:tecmuu/domain/plano/vagas.dart';

TecnicoEntity _tecnico() => TecnicoEntity(
      firestoreId: 't1',
      limiteAnimaisContratado: 50,
      quantidadeAnimaisCadastrados: 40,
      restanteLimiteAnimais: 10,
      limiteProdutoresContratado: 5,
      quantidadeProdutoresCadastrados: 2,
      restanteLimiteProdutores: 3,
    );

const _produtoresIguais = SaldoVagas(limite: 5, quantidade: 2, restante: 3);

void main() {
  _aposGravarTests();

  test('pulaComFilaPendente', () {
    final campos = camposParaGravar(
      atual: _tecnico(),
      animais: const SaldoVagas(limite: 200, quantidade: 38, restante: 162),
      produtores: const SaldoVagas(limite: 9, quantidade: 1, restante: 8),
      filaPendente: true,
    );
    expect(campos, isNull);
  });

  test('semMudancaNaoGrava', () {
    final campos = camposParaGravar(
      atual: _tecnico(),
      animais: const SaldoVagas(limite: 50, quantidade: 40, restante: 10),
      produtores: _produtoresIguais,
      filaPendente: false,
    );
    expect(campos, isNull);
  });

  test('gravaSoOQueMudou', () {
    final campos = camposParaGravar(
      atual: _tecnico(),
      animais: const SaldoVagas(limite: 200, quantidade: 38, restante: 162),
      produtores: _produtoresIguais,
      filaPendente: false,
    );
    expect(campos, {
      'limiteAnimaisContratado': 200,
      'quantidadeAnimaisCadastrados': 38,
      'restanteLimiteAnimais': 162,
    });
  });
}

void _aposGravarTests() {
  test('aposGravarComFilaPendenteNaoAplica', () {
    final fresca = _tecnico();
    final r = aplicarAposGravar(
      fresca: fresca,
      campos: const {'quantidadeAnimaisCadastrados': 38},
      filaPendente: true,
    );
    expect(r, isNull);
    expect(fresca.quantidadeAnimaisCadastrados, 40);
  });

  test('aposGravarAplicaSoOsCamposSobreAEntidadeFresca', () {
    // A fresca já tem um débito local feito durante o recálculo.
    final fresca = _tecnico()..restanteLimiteProdutores = 1;
    final r = aplicarAposGravar(
      fresca: fresca,
      campos: const {
        'limiteAnimaisContratado': 200,
        'quantidadeAnimaisCadastrados': 38,
        'restanteLimiteAnimais': 162,
      },
      filaPendente: false,
    );
    expect(r, same(fresca));
    expect(r!.limiteAnimaisContratado, 200);
    expect(r.quantidadeAnimaisCadastrados, 38);
    expect(r.restanteLimiteAnimais, 162);
    expect(r.restanteLimiteProdutores, 1);
    expect(r.limiteProdutoresContratado, 5);
    expect(r.needsSync, isFalse);
  });

  test('aposGravarSemEntidadeLocalNaoAplica', () {
    expect(
      aplicarAposGravar(
          fresca: null,
          campos: const {'restanteLimiteAnimais': 1},
          filaPendente: false),
      isNull,
    );
  });
}
