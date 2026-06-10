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

  group('agregações de lista (rebanho/grupos)', () {
    test('retornaStringEmLista: split por vírgula + trim; vazio -> []', () {
      expect(functions.retornaStringEmLista('Vacas, Novilhas ,Touros'),
          ['Vacas', 'Novilhas', 'Touros']);
      expect(functions.retornaStringEmLista(''), <String>[]);
    });

    test('retornaGruposUnicos: únicos, ordem alfabética', () {
      expect(functions.retornaGruposUnicos(['Vacas', 'Novilhas', 'Vacas']),
          ['Novilhas', 'Vacas']);
    });

    test('retornaContagemGrupos: contagens (>0) na ordem canônica', () {
      // ordem do mapa: Novilhas, Sêmens, Bezerras, Touros, Bezerros, Vacas
      expect(functions.retornaContagemGrupos(['Vacas', 'Vacas', 'Novilhas']),
          [1, 2]);
      // grupo desconhecido é ignorado
      expect(functions.retornaContagemGrupos(['Vacas', 'Inexistente']), [1]);
    });

    test('retornaGruposComContagem: "Grupo - N" ordenado', () {
      expect(functions.retornaGruposComContagem(['Vacas', 'Vacas', 'Novilhas']),
          ['Novilhas - 1', 'Vacas - 2']);
    });
  });

  group('cálculos financeiros (relatório de leite)', () {
    test('calcularLitrosLeiteMes = litros/dia * 30', () {
      expect(functions.calcularLitrosLeiteMes('10'), 300);
    });

    test('calcularMediaProducaoPorVaca = litros / vacas (2 casas)', () {
      expect(functions.calcularMediaProducaoPorVaca('100', '8'), 12.5);
    });

    test('calcularTotalRecebido formata R\$ com milhar e 2 casas', () {
      expect(functions.calcularTotalRecebido('R\$ 2,00', '100'), 'R\$ 200,00');
      expect(functions.calcularTotalRecebido('2,50', '1000'), 'R\$ 2.500,00');
    });
  });

  group('criarUidRandom', () {
    test('20 chars alfanuméricos e razoavelmente único', () {
      final id = functions.criarUidRandom();
      expect(id.length, 20);
      expect(RegExp(r'^[A-Za-z0-9]{20}$').hasMatch(id), true);
      expect(functions.criarUidRandom() == functions.criarUidRandom(), false);
    });
  });
}
