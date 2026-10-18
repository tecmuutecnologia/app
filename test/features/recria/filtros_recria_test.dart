import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/features/recria/application/filtros_recria.dart';

void main() {
  test('semen NAO entra na recria', () {
    expect(ehDaRecria('Sêmens'), isFalse);
  });

  test('pega tambem a grafia legada Semêns', () {
    // O dropdown de cadastro oferece 'Semêns' e as telas filtram por 'Sêmens'.
    // Comparar a string direto deixaria passar metade dos registros.
    expect(ehDaRecria('Semêns'), isFalse);
  });

  test('os grupos da recria entram', () {
    for (final grupo in ['Bezerras', 'Bezerros', 'Novilhas', 'Touros']) {
      expect(ehDaRecria(grupo), isTrue, reason: '$grupo deveria entrar');
    }
  });

  test('grupo nulo ou vazio entra: nao e semen', () {
    expect(ehDaRecria(null), isTrue);
    expect(ehDaRecria(''), isTrue);
  });

  group('apareceNaRecria (mesma regra do card, para a contagem bater)', () {
    test('novilha com lactacao induzida NAO aparece', () {
      expect(
          apareceNaRecria(
              grupo: 'Novilhas', status: 'Vazia', temInducaoLactacao: true),
          isFalse);
    });

    test('novilha sem inducao aparece', () {
      expect(
          apareceNaRecria(
              grupo: 'Novilhas', status: 'Prenha', temInducaoLactacao: false),
          isTrue);
    });

    test('descarte e Pré Parto NAO aparecem', () {
      expect(
          apareceNaRecria(
              grupo: 'Bezerras', status: 'Descarte', temInducaoLactacao: false),
          isFalse);
      expect(
          apareceNaRecria(
              grupo: 'Novilhas',
              status: 'Pré Parto',
              temInducaoLactacao: false),
          isFalse);
    });

    test('vaca NAO aparece (nao e da recria)', () {
      expect(
          apareceNaRecria(
              grupo: 'Vacas', status: 'Vazia', temInducaoLactacao: false),
          isFalse);
    });

    test('bezerros, bezerras e touros aparecem', () {
      for (final grupo in ['Bezerras', 'Bezerros', 'Touros']) {
        expect(
            apareceNaRecria(
                grupo: grupo, status: '', temInducaoLactacao: false),
            isTrue,
            reason: grupo);
      }
    });
  });
}
