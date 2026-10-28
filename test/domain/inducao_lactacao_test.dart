import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/domain/animais/inducao_lactacao.dart';

void main() {
  final inducao = DateTime(2025, 8, 22, 10, 29);

  group('inducaoLactacaoAtiva', () {
    test('sem data de indução nunca está ativa', () {
      expect(inducaoLactacaoAtiva(dtInducao: null), isFalse);
    });

    test('indução sem nada depois continua ativa', () {
      expect(inducaoLactacaoAtiva(dtInducao: inducao), isTrue);
    });

    test('eventos ANTES da indução não encerram', () {
      expect(
          inducaoLactacaoAtiva(
            dtInducao: inducao,
            dtUltimaInseminacao: '12/05/2025',
            dtDgMais: '',
            dtUltimoParto: '10/01/2025',
          ),
          isTrue);
    });

    test('inseminação depois da indução encerra (caso da vaca 354)', () {
      expect(
          inducaoLactacaoAtiva(
              dtInducao: inducao, dtUltimaInseminacao: '06/11/2025'),
          isFalse);
    });

    test('DG+ depois da indução encerra', () {
      expect(inducaoLactacaoAtiva(dtInducao: inducao, dtDgMais: '01/04/2026'),
          isFalse);
    });

    test('parto depois da indução encerra', () {
      expect(
          inducaoLactacaoAtiva(dtInducao: inducao, dtUltimoParto: '15/09/2026'),
          isFalse);
    });

    test('evento no mesmo dia da indução não encerra', () {
      expect(
          inducaoLactacaoAtiva(
              dtInducao: inducao, dtUltimaInseminacao: '22/08/2025'),
          isTrue);
    });

    test('datas vazias ou inválidas são ignoradas', () {
      expect(
          inducaoLactacaoAtiva(
            dtInducao: inducao,
            dtUltimaInseminacao: '',
            dtDgMais: 'abc',
            dtUltimoParto: null,
          ),
          isTrue);
    });
  });
}
