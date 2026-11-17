import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/features/receituario/application/ordenacao_tratamentos.dart';

void main() {
  group('compararDataMaisVelhaPrimeiro', () {
    test('lista de secagem sai da data mais velha para a mais nova', () {
      final datas = ['11/11/2026', '31/10/2026', '05/11/2026'];
      datas.sort(compararDataMaisVelhaPrimeiro);
      expect(datas, ['31/10/2026', '05/11/2026', '11/11/2026']);
    });

    test('compara como data, não como texto (vira o ano)', () {
      final datas = ['01/01/2026', '31/12/2025'];
      datas.sort(compararDataMaisVelhaPrimeiro);
      expect(datas, ['31/12/2025', '01/01/2026']);
    });

    test('sem data válida vai para o fim', () {
      final datas = <String?>[null, '11/11/2026', '', 'abc', '31/10/2026'];
      datas.sort(compararDataMaisVelhaPrimeiro);
      expect(datas.take(2), ['31/10/2026', '11/11/2026']);
    });

    test('datas iguais empatam (o desempate fica com quem chama)', () {
      expect(compararDataMaisVelhaPrimeiro('11/11/2026', '11/11/2026'), 0);
      expect(compararDataMaisVelhaPrimeiro(null, ''), 0);
    });
  });
}
