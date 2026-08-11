import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/janela_pull.dart';

void main() {
  group('JanelaPull.desde', () {
    test('recua a margem de segurança sobre a última sincronização', () {
      final ultima = DateTime.utc(2026, 8, 10, 12, 0, 0);
      expect(JanelaPull.desde(ultima), ultima.subtract(JanelaPull.margem));
    });

    test('sem sincronização anterior, usa a época para trazer tudo', () {
      expect(JanelaPull.desde(null), JanelaPull.epoca);
    });

    test('margem é positiva — janela que não recua perde escritas em voo', () {
      expect(JanelaPull.margem, greaterThan(Duration.zero));
    });
  });
}
