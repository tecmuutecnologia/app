import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/total_estimado.dart';

void main() {
  group('totalEstimado', () {
    test('devolve a contagem quando ela é positiva', () {
      expect(totalEstimado(2232), 2232);
    });

    test('zero vira nulo — contador nunca preenchido não é estimativa', () {
      expect(totalEstimado(0), isNull);
    });

    test('nulo continua nulo', () {
      expect(totalEstimado(null), isNull);
    });

    test('negativo vira nulo — contador corrompido não vira barra ao contrário',
        () {
      expect(totalEstimado(-5), isNull);
    });
  });
}
