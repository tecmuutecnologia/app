import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/domain/financeiro/data_relatorio.dart';

void main() {
  test('converte dd/MM/yyyy', () {
    expect(dataDoRelatorio('05/03/2026'), DateTime(2026, 3, 5));
    expect(dataDoRelatorio('lixo'), isNull);
    expect(dataDoRelatorio(null), isNull);
  });

  test('mais recente pela data real, não pelo texto', () {
    final lista = ['28/01/2026', '05/03/2026', '30/12/2025'];
    expect(relatorioMaisRecente(lista, (s) => s), '05/03/2026');
  });

  test('lista vazia devolve null', () {
    expect(relatorioMaisRecente(<String>[], (s) => s), isNull);
  });
}
