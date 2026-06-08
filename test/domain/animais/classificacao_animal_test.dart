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
      expect(ehPreParto('Pré-parto'), true);
      // negativos cruzados
      expect(ehVazia('Prenha'), false);
      expect(ehSeca(null), false);
      expect(ehPreParto('Pre-parto'), false); // acento importa
    });
  });

  group('predicados de grupo', () {
    test('ehVaca / ehNovilha', () {
      expect(ehVaca('Vacas'), true);
      expect(ehVaca('Novilhas'), false);
      expect(ehNovilha('Novilhas'), true);
      expect(ehVaca(null), false);
    });

    test('ehVacaOuNovilha', () {
      expect(ehVacaOuNovilha('Vacas'), true);
      expect(ehVacaOuNovilha('Novilhas'), true);
      expect(ehVacaOuNovilha('Touros'), false);
      expect(ehVacaOuNovilha(null), false);
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
  });
}
