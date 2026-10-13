import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/domain/animais/media_del.dart';

/// DEL (Dias em Lactação) médio do painel de índices zootécnicos.
///
/// Entram só as VACAS em lactação — status Vazia, Inseminada, Inseminada PP ou
/// Prenha. Secas, pré-partos e novilhas ficam fora. A versão antiga do painel
/// fazia a média de todo animal com último parto, sem filtro nenhum.
void main() {
  String dias(int atras) {
    final d = DateTime.now().subtract(Duration(days: atras));
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  ({String? grupo, String? status, String? dtUltimoParto}) vaca(
    String status,
    String? parto,
  ) =>
      (grupo: 'Vacas', status: status, dtUltimoParto: parto);

  group('ehVacaEmLactacao', () {
    for (final status in ['Vazia', 'Inseminada', 'Inseminada PP', 'Prenha']) {
      test('vaca $status está em lactação',
          () => expect(ehVacaEmLactacao('Vacas', status), isTrue));
    }

    for (final status in ['Seca', 'Pré Parto', 'Pré-parto', 'Aborto', '']) {
      test('vaca "$status" não está em lactação',
          () => expect(ehVacaEmLactacao('Vacas', status), isFalse));
    }

    test('novilha não entra, mesmo vazia ou prenha', () {
      expect(ehVacaEmLactacao('Novilhas', 'Vazia'), isFalse);
      expect(ehVacaEmLactacao('Novilhas', 'Prenha'), isFalse);
    });
  });

  group('mediaDiasEmLactacao', () {
    test('média dos dias desde o último parto das vacas em lactação', () {
      expect(
        mediaDiasEmLactacao([
          vaca('Vazia', dias(100)),
          vaca('Inseminada', dias(200)),
          vaca('Inseminada PP', dias(150)),
          vaca('Prenha', dias(250)),
        ]),
        175,
      );
    });

    test('secas, pré-partos e novilhas ficam fora da média', () {
      expect(
        mediaDiasEmLactacao([
          vaca('Vazia', dias(100)),
          vaca('Seca', dias(400)),
          vaca('Pré Parto', dias(500)),
          (grupo: 'Novilhas', status: 'Vazia', dtUltimoParto: dias(900)),
        ]),
        100,
      );
    });

    test('vaca em lactação sem data de parto válida não pesa na média', () {
      expect(
        mediaDiasEmLactacao([
          vaca('Vazia', dias(100)),
          vaca('Prenha', ''),
          vaca('Prenha', null),
          vaca('Inseminada', '31/13/xxxx'),
        ]),
        100,
      );
    });

    test('arredonda para o dia mais próximo', () {
      expect(
        mediaDiasEmLactacao([vaca('Vazia', dias(10)), vaca('Vazia', dias(11))]),
        11,
      );
    });

    test('sem nenhuma vaca em lactação com parto devolve null', () {
      expect(mediaDiasEmLactacao([]), isNull);
      expect(mediaDiasEmLactacao([vaca('Seca', dias(30))]), isNull);
    });
  });
}
