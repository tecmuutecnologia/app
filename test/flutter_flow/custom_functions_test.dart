import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:tecmuu/flutter_flow/custom_functions.dart' as functions;

/// Cobre as funções PURAS de data/cálculo de `custom_functions.dart` usadas
/// pelos formulários offline-first (parto/secagem/pré-parto previstos etc.).
/// Sem dependência de Firebase/ObjectBox — só `intl`.
void main() {
  final fmt = DateFormat('dd/MM/yyyy');
  int diasEntre(String a, String b) =>
      fmt.parse(b).difference(fmt.parse(a)).inDays;

  group('soma de datas previstas (usadas nos forms de ação)', () {
    test('somarDataParto = +280 dias', () {
      expect(diasEntre('01/01/2026', functions.somarDataParto('01/01/2026')),
          280);
    });

    test('somarDataSecagem = +220 dias', () {
      expect(diasEntre('01/01/2026', functions.somarDataSecagem('01/01/2026')),
          220);
    });

    test('somarDataPreParto = +259 dias', () {
      expect(diasEntre('01/01/2026', functions.somarDataPreParto('01/01/2026')),
          259);
    });

    test('atravessa ano bissexto (fev/2024) corretamente', () {
      expect(diasEntre('01/12/2023', functions.somarDataParto('01/12/2023')),
          280);
    });

    test('data inválida retorna a própria entrada (fallback seguro)', () {
      expect(functions.somarDataParto('xx/yy/zzzz'), 'xx/yy/zzzz');
      expect(functions.somarDataSecagem(''), '');
      expect(functions.somarDataPreParto('sem data'), 'sem data');
    });
  });

  group('converterStringParaData', () {
    test('soma N dias à data', () {
      expect(functions.converterStringParaData('01/01/2026', '10'),
          DateTime(2026, 1, 11));
    });
  });

  group('calcularIntervaloMedioIndi', () {
    test('inseminação após o parto = diferença em dias', () {
      expect(
          functions.calcularIntervaloMedioIndi('01/01/2026', '11/01/2026'), 10);
    });

    test('inseminação antes/igual ao parto = 0', () {
      expect(
          functions.calcularIntervaloMedioIndi('11/01/2026', '01/01/2026'), 0);
    });

    test('alguma data vazia = 0', () {
      expect(functions.calcularIntervaloMedioIndi('', '01/01/2026'), 0);
      expect(functions.calcularIntervaloMedioIndi('01/01/2026', ''), 0);
    });
  });
}
