import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/decisao_recalculo.dart';
import 'package:tecmuu/data/objectbox/entities/tecnico_entity.dart';

TecnicoEntity _tecnico() => TecnicoEntity(
      firestoreId: 't1',
      limiteAnimaisContratado: 50,
      quantidadeAnimaisCadastrados: 40,
      restanteLimiteAnimais: 10,
      limiteProdutoresContratado: 5,
      quantidadeProdutoresCadastrados: 2,
      restanteLimiteProdutores: 3,
    );

void main() {
  _aposGravarTests();
  _downloadTests();
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

void _downloadTests() {
  test('downloadSemFilaUsaServidor', () {
    expect(cotaLocalAPreservar(local: _tecnico(), filaPendente: false), isNull);
  });

  test('downloadComFilaMantemOs6CamposLocais', () {
    final local = _tecnico();
    final manter = cotaLocalAPreservar(local: local, filaPendente: true)!;
    expect(manter, {
      'limiteAnimaisContratado': 50,
      'quantidadeAnimaisCadastrados': 40,
      'restanteLimiteAnimais': 10,
      'limiteProdutoresContratado': 5,
      'quantidadeProdutoresCadastrados': 2,
      'restanteLimiteProdutores': 3,
    });
    // O download sobrescreve com o valor do servidor (sem os deltas locais)...
    local
      ..quantidadeAnimaisCadastrados = 30
      ..restanteLimiteAnimais = 20
      ..restanteLimiteProdutores = 4;
    // ...e a cota local volta por cima.
    aplicarAposGravar(fresca: local, campos: manter, filaPendente: false);
    expect(local.quantidadeAnimaisCadastrados, 40);
    expect(local.restanteLimiteAnimais, 10);
    expect(local.restanteLimiteProdutores, 3);
  });
}
