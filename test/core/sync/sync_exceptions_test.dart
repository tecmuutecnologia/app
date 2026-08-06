import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/sync_etapa.dart';
import 'package:tecmuu/core/sync/sync_exceptions.dart';

void main() {
  test('SyncFalhaException expoe a etapa que quebrou', () {
    const e = SyncFalhaException(SyncEtapa.animais, 'timeout');
    expect(e.etapa, SyncEtapa.animais);
    expect(e.mensagem, contains('timeout'));
  });

  test('SyncFalhaException aceita etapa desconhecida', () {
    const e = SyncFalhaException(null, 'boom');
    expect(e.etapa, isNull);
    expect(e.mensagem, contains('boom'));
  });

  test('SyncOfflineException e um Exception', () {
    expect(const SyncOfflineException(), isA<Exception>());
  });
}
