import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tecmuu/domain/financeiro/vendas_por_mes.dart';

VendaResumo v(String id, DateTime? data, double valor) => VendaResumo(
    id: id, titulo: id, data: data, dtTexto: '', valor: valor);

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR'));

  test('agrupa por mês, mais recente primeiro, total somado', () {
    final g = agruparVendasPorMes([
      v('a', DateTime(2026, 10, 5), 100),
      v('b', DateTime(2026, 11, 2), 50),
      v('c', DateTime(2026, 11, 20), 25.5),
    ]);
    expect(g.map((x) => x.rotulo), ['Novembro 2026', 'Outubro 2026']);
    expect(g.first.total, 75.5);
    expect(g.first.vendas.map((x) => x.id), ['c', 'b']);
    expect(g.last.total, 100);
  });

  test('mesmo mês de anos diferentes ficam separados', () {
    final g = agruparVendasPorMes([
      v('a', DateTime(2025, 11, 5), 1),
      v('b', DateTime(2026, 11, 5), 2),
    ]);
    expect(g.map((x) => x.rotulo), ['Novembro 2026', 'Novembro 2025']);
  });

  test('venda sem data vai para "Sem data" no fim', () {
    final g = agruparVendasPorMes([
      v('x', null, 10),
      v('a', DateTime(2026, 1, 5), 1),
    ]);
    expect(g.map((x) => x.rotulo), ['Janeiro 2026', 'Sem data']);
    expect(g.last.mes, isNull);
    expect(g.last.total, 10);
  });

  test('lista vazia', () => expect(agruparVendasPorMes([]), isEmpty));

  group('parseDataBr', () {
    test('válida', () => expect(parseDataBr('05/03/2026'), DateTime(2026, 3, 5)));
    test('rejeita 31/02/2026', () => expect(parseDataBr('31/02/2026'), isNull));
    test('rejeita lixo e vazio', () {
      expect(parseDataBr('lixo'), isNull);
      expect(parseDataBr(''), isNull);
      expect(parseDataBr(null), isNull);
      expect(parseDataBr('5/3/26'), isNull);
    });
  });

  test('formatarReais no padrão brasileiro', () {
    expect(formatarReais(1234.56), 'R\$\u00a01.234,56');
  });
}
