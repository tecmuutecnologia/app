import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/domain/animais/dias_desde.dart';

/// Texto do contador de dias de um evento (DEL, Dias IA).
///
/// `calcularDiferencaEmDias` LANÇA `FormatException` quando a data não está em
/// dd/MM/yyyy — inclusive quando é vazia. Cada tela repetia um guard `!= ''`
/// antes de chamar; onde o guard faltasse, a tela quebrava.
void main() {
  String dias(int atras) {
    final d = DateTime.now().subtract(Duration(days: atras));
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  test('conta os dias desde a data', () {
    expect(diasDesde(dias(37)), '37');
  });

  test('hoje é zero dia', () => expect(diasDesde(dias(0)), '0'));

  test('sem data não mostra nada', () => expect(diasDesde(''), ''));

  test('nulo não mostra nada', () => expect(diasDesde(null), ''));

  test('data inválida não mostra nada em vez de quebrar a tela',
      () => expect(diasDesde('31/13/xxxx'), ''));

  test('sem data usa o texto pedido pela tela', () {
    // O prontuário mostra 'N/D'; as listas deixam em branco.
    expect(diasDesde('', seVazio: 'N/D'), 'N/D');
    expect(diasDesde('31/13/xxxx', seVazio: 'N/D'), 'N/D');
  });

  group('diasDesdeNum', () {
    // A planilha recebe NÚMERO: virar texto mudaria o tipo da coluna.
    test('devolve o número de dias', () => expect(diasDesdeNum(dias(37)), 37));

    test('sem data devolve nulo', () => expect(diasDesdeNum(''), isNull));

    test('data inválida devolve nulo em vez de derrubar a exportação',
        () => expect(diasDesdeNum('31/13/xxxx'), isNull));
  });
}
