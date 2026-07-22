import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/domain/animais/classificacao_animal.dart';

/// Cobre os predicados puros de classificação de animal (status/grupo).
void main() {
  group('predicados de status', () {
    test('ehPrenha', () {
      expect(ehPrenha('Prenha'), true);
      expect(ehPrenha('Vazia'), false);
      expect(ehPrenha(null), false);
      expect(ehPrenha(''), false);
    });

    test('ehVazia / ehInseminada / ehSeca / ehAborto / ehPreParto', () {
      expect(ehVazia('Vazia'), true);
      expect(ehInseminada('Inseminada'), true);
      expect(ehSeca('Seca'), true);
      expect(ehAborto('Aborto'), true);
      expect(ehDescarte('Descarte'), true);
      expect(ehPreParto('Pré-parto'), true);
      expect(
          ehPreParto('Pré Parto'), true); // grafia com espaço (legado) também
      // negativos cruzados
      expect(ehVazia('Prenha'), false);
      expect(ehSeca(null), false);
      expect(ehPreParto('Pre-parto'), false); // sem acento não casa
    });
  });

  group('predicados de grupo', () {
    test('ehVaca / ehNovilha', () {
      expect(ehVaca('Vacas'), true);
      expect(ehVaca('Novilhas'), false);
      expect(ehNovilha('Novilhas'), true);
      expect(ehVaca(null), false);
    });

    test('ehBezerros / ehBezerras', () {
      expect(ehBezerros('Bezerros'), true);
      expect(ehBezerras('Bezerras'), true);
      expect(ehBezerros('Bezerras'), false);
      expect(ehBezerras('Bezerros'), false);
      expect(ehBezerros(null), false);
      expect(ehTouros('Touros'), true);
      expect(ehTouros('Vacas'), false);
    });

    test('ehVacaOuNovilha', () {
      expect(ehVacaOuNovilha('Vacas'), true);
      expect(ehVacaOuNovilha('Novilhas'), true);
      expect(ehVacaOuNovilha('Touros'), false);
      expect(ehVacaOuNovilha(null), false);
    });

    test('ehSemens casa as duas grafias legadas', () {
      expect(ehSemens('Sêmens'), true); // canônico das telas
      expect(ehSemens('Semêns'), true); // grafia da constante de dropdown
      expect(ehSemens('Touros'), false);
      expect(ehSemens('Vacas'), false);
      expect(ehSemens(null), false);
      expect(ehSemens(''), false);
    });

    test('ehTouroOuSemem = Touros || Sêmens', () {
      expect(ehTouroOuSemem('Touros'), true);
      expect(ehTouroOuSemem('Sêmens'), true);
      expect(ehTouroOuSemem('Semêns'), true);
      expect(ehTouroOuSemem('Vacas'), false);
      expect(ehTouroOuSemem('Novilhas'), false);
      expect(ehTouroOuSemem(null), false);
    });
  });

  group('predicado composto', () {
    test('ehVacaPrenha = Vacas && Prenha', () {
      expect(ehVacaPrenha('Vacas', 'Prenha'), true);
      expect(ehVacaPrenha('Novilhas', 'Prenha'), false);
      expect(ehVacaPrenha('Vacas', 'Vazia'), false);
      expect(ehVacaPrenha(null, null), false);
    });

    test('equivale à comparação inline original', () {
      // Garante refactor sem mudança de comportamento.
      for (final g in ['Vacas', 'Novilhas', 'Touros', null]) {
        for (final s in ['Prenha', 'Vazia', null]) {
          expect(
            ehVacaPrenha(g, s),
            (g == 'Vacas') && (s == 'Prenha'),
            reason: 'grupo=$g status=$s',
          );
        }
      }
    });

    test('ehVacaSeca = Vacas && Seca', () {
      expect(ehVacaSeca('Vacas', 'Seca'), true);
      expect(ehVacaSeca('Novilhas', 'Seca'), false);
      expect(ehVacaSeca('Vacas', 'Prenha'), false);
      for (final g in ['Vacas', 'Novilhas', null]) {
        for (final s in ['Seca', 'Prenha', null]) {
          expect(ehVacaSeca(g, s), (g == 'Vacas') && (s == 'Seca'));
        }
      }
    });

    test(
        'ehElegivelInseminacao = (Vacas|Novilhas) & (Vazia|Inseminada|Insem.PP)',
        () {
      expect(ehElegivelInseminacao('Vacas', 'Vazia'), true);
      expect(ehElegivelInseminacao('Novilhas', 'Inseminada'), true);
      expect(ehElegivelInseminacao('Vacas', 'Inseminada PP'), true);
      expect(ehElegivelInseminacao('Vacas', 'Prenha'), false);
      expect(ehElegivelInseminacao('Touros', 'Vazia'), false);
    });

    test('ehElegivelInseminacao equivale ao inline original', () {
      for (final g in ['Vacas', 'Novilhas', 'Touros', null]) {
        for (final s in [
          'Vazia',
          'Inseminada',
          'Inseminada PP',
          'Prenha',
          null
        ]) {
          expect(
            ehElegivelInseminacao(g, s),
            ((g == 'Vacas') || (g == 'Novilhas')) &&
                ((s == 'Vazia') ||
                    (s == 'Inseminada') ||
                    (s == 'Inseminada PP')),
            reason: 'grupo=$g status=$s',
          );
        }
      }
    });
  });
}
