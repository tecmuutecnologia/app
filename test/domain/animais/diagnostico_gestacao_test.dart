import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/domain/animais/diagnostico_gestacao.dart';

void main() {
  group('tipoDiagnostico', () {
    test('mantém PP, DG+, DG- e Aborto', () {
      for (final t in ['PP', 'DG+', 'DG-', 'Aborto']) {
        expect(tipoDiagnostico(acao: t), t);
      }
    });

    test('Secagem com dtDgMais é o DG+ de novilha gravado no legado', () {
      expect(tipoDiagnostico(acao: 'Secagem', dtDgMais: '15/10/2026'), 'DG+');
    });

    test('Secagem de verdade (sem dtDgMais) não é diagnóstico', () {
      expect(tipoDiagnostico(acao: 'Secagem'), isNull);
      expect(tipoDiagnostico(acao: 'Secagem', dtDgMais: ''), isNull);
    });

    test('outras ações não são diagnóstico', () {
      expect(tipoDiagnostico(acao: 'Inseminada'), isNull);
      expect(tipoDiagnostico(acao: null), isNull);
    });
  });

  group('inseminacaoDiagnosticada', () {
    final dg = DateTime(2026, 10, 15);

    test('pega a última inseminação até o dia do DG', () {
      expect(
        inseminacaoDiagnosticada(['10/07/2026', '12/09/2026'], ate: dg),
        '12/09/2026',
      );
    });

    test('ignora inseminação posterior ao DG', () {
      expect(
        inseminacaoDiagnosticada(['06/09/2026', '20/10/2026'], ate: dg),
        '06/09/2026',
      );
    });

    test('inseminação no próprio dia do DG conta', () {
      expect(inseminacaoDiagnosticada(['15/10/2026'], ate: dg), '15/10/2026');
    });

    test('sem inseminação válida devolve vazio', () {
      expect(inseminacaoDiagnosticada([], ate: dg), '');
      expect(inseminacaoDiagnosticada([null, '', 'lixo'], ate: dg), '');
    });
  });
}
