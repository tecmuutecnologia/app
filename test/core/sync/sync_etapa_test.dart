import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/sync_etapa.dart';

void main() {
  group('faixas das etapas', () {
    test('cobrem 0..1 sem buraco nem sobreposicao', () {
      final etapas = SyncEtapa.values;
      expect(etapas.first.inicio, 0.0);
      expect(etapas.last.fim, 1.0);
      for (var i = 0; i < etapas.length - 1; i++) {
        expect(etapas[i].fim, etapas[i + 1].inicio,
            reason: '${etapas[i]} deve encostar em ${etapas[i + 1]}');
      }
    });

    test('toda faixa avanca', () {
      for (final e in SyncEtapa.values) {
        expect(e.fim, greaterThan(e.inicio), reason: '$e');
      }
    });
  });

  group('progressoGlobal', () {
    test('sem contador devolve o inicio da faixa', () {
      expect(progressoGlobal(SyncEtapa.animais), 0.60);
    });

    test('interpola dentro da faixa da etapa', () {
      // animais vai de 0.60 a 0.70; metade dos animais = 0.65.
      expect(progressoGlobal(SyncEtapa.animais, atual: 1500, total: 3000),
          closeTo(0.65, 0.0001));
    });

    test('contador completo chega ao fim da faixa', () {
      expect(progressoGlobal(SyncEtapa.animais, atual: 3000, total: 3000),
          closeTo(0.70, 0.0001));
    });

    test('total zero nao divide por zero', () {
      expect(progressoGlobal(SyncEtapa.animais, atual: 0, total: 0), 0.60);
    });

    test('atual acima do total nao estoura a faixa', () {
      expect(progressoGlobal(SyncEtapa.animais, atual: 5000, total: 3000),
          closeTo(0.70, 0.0001));
    });

    test('primeira etapa comeca em zero', () {
      expect(progressoGlobal(SyncEtapa.referencias), 0.0);
    });
  });
}
