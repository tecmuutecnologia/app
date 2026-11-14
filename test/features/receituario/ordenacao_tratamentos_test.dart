import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/features/receituario/application/ordenacao_tratamentos.dart';

void main() {
  group('compararDataMaisNovaPrimeiro', () {
    test('lista de secagem sai da data mais nova para a mais velha', () {
      final datas = ['31/10/2026', '11/11/2026', '05/11/2026'];
      datas.sort(compararDataMaisNovaPrimeiro);
      expect(datas, ['11/11/2026', '05/11/2026', '31/10/2026']);
    });

    test('compara como data, não como texto (vira o ano)', () {
      final datas = ['31/12/2025', '01/01/2026'];
      datas.sort(compararDataMaisNovaPrimeiro);
      expect(datas, ['01/01/2026', '31/12/2025']);
    });

    test('sem data válida vai para o fim', () {
      final datas = <String?>[null, '31/10/2026', '', 'abc', '11/11/2026'];
      datas.sort(compararDataMaisNovaPrimeiro);
      expect(datas.take(2), ['11/11/2026', '31/10/2026']);
    });

    test('datas iguais empatam (o desempate fica com quem chama)', () {
      expect(compararDataMaisNovaPrimeiro('11/11/2026', '11/11/2026'), 0);
      expect(compararDataMaisNovaPrimeiro(null, ''), 0);
    });
  });
}
