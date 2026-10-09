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
}
