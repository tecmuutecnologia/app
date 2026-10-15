import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/services/create_receituario.dart';

void main() {
  group('numeroParaOrdenar', () {
    test('usa o brinco quando ele é válido', () {
      expect(numeroParaOrdenar(9681, '182'), 9681);
      expect(numeroParaOrdenar(' 74 ', null), 74);
    });

    test('sem brinco, usa o nome se ele for um número (vaca 182)', () {
      expect(numeroParaOrdenar(0, '182'), 182);
      expect(numeroParaOrdenar(-1, ' 182 '), 182);
      expect(numeroParaOrdenar(null, '182'), 182);
    });

    test('sentinelas e nomes de texto não viram número', () {
      expect(numeroParaOrdenar(99999, 'Mimosa'), isNull);
      expect(numeroParaOrdenar('', ''), isNull);
      expect(numeroParaOrdenar(0, '0'), isNull);
    });
  });
}
