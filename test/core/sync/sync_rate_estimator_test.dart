import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/sync_rate_estimator.dart';

void main() {
  final t0 = DateTime(2026, 1, 1, 12, 0, 0);
  DateTime em(int ms) => t0.add(Duration(milliseconds: ms));

  group('SyncRateEstimator.registrosPorSegundo', () {
    test('sem amostras devolve null', () {
      expect(SyncRateEstimator().registrosPorSegundo, isNull);
    });

    test('uma amostra so nao da ritmo (falta um delta)', () {
      final e = SyncRateEstimator()..registrar(250, em(0));
      expect(e.registrosPorSegundo, isNull);
    });

    test('duas amostras dao o ritmo do intervalo', () {
      final e = SyncRateEstimator()
        ..registrar(0, em(0))
        ..registrar(250, em(1000));
      expect(e.registrosPorSegundo, closeTo(250.0, 0.01));
    });

    test('media movel usa apenas as ultimas 3 transicoes', () {
      // Deltas: 100/s, 100/s, 100/s, depois 1000/s tres vezes.
      final e = SyncRateEstimator(janela: 3)
        ..registrar(0, em(0))
        ..registrar(100, em(1000))
        ..registrar(200, em(2000))
        ..registrar(300, em(3000));
      expect(e.registrosPorSegundo, closeTo(100.0, 0.01));

      e
        ..registrar(1300, em(4000))
        ..registrar(2300, em(5000))
        ..registrar(3300, em(6000));
      // As tres transicoes antigas de 100/s ja sairam da janela.
      expect(e.registrosPorSegundo, closeTo(1000.0, 0.01));
    });

    test('reiniciar zera o historico', () {
      final e = SyncRateEstimator()
        ..registrar(0, em(0))
        ..registrar(250, em(1000))
        ..reiniciar();
      expect(e.registrosPorSegundo, isNull);
    });
  });

  group('SyncRateEstimator.etaPara', () {
    test('sem ritmo devolve null', () {
      expect(SyncRateEstimator().etaPara(3000), isNull);
    });

    test('suprime ETA antes de 2s de amostragem', () {
      // Ritmo existe, mas so 1s decorrido desde a primeira amostra.
      final e = SyncRateEstimator()
        ..registrar(0, em(0))
        ..registrar(100, em(1000));
      expect(e.etaPara(3000), isNull);
    });

    test('devolve ETA depois de 2s de amostragem', () {
      final e = SyncRateEstimator()
        ..registrar(0, em(0))
        ..registrar(100, em(1000))
        ..registrar(200, em(2000));
      // Faltam 2800 a 100/s = 28s.
      expect(e.etaPara(3000)!.inSeconds, 28);
    });

    test('suprime ETA quando a estimativa cai abaixo de 3s', () {
      final e = SyncRateEstimator()
        ..registrar(0, em(0))
        ..registrar(1000, em(1000))
        ..registrar(2000, em(2000));
      // Faltam 100 a 1000/s = 0,1s.
      expect(e.etaPara(2100), isNull);
    });

    test('total ja alcancado devolve null', () {
      final e = SyncRateEstimator()
        ..registrar(0, em(0))
        ..registrar(1500, em(1000))
        ..registrar(3000, em(2000));
      expect(e.etaPara(3000), isNull);
    });
  });
}
