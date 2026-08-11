import 'package:firebase_core/firebase_core.dart';
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

  group('ehErroDeCota', () {
    test('reconhece FirebaseException com code resource-exhausted', () {
      final e = FirebaseException(
        plugin: 'cloud_firestore',
        code: 'resource-exhausted',
        message: 'Quota exceeded.',
      );
      expect(ehErroDeCota(e), true);
    });

    test('nao confunde com outros codigos do Firebase', () {
      final e = FirebaseException(
        plugin: 'cloud_firestore',
        code: 'permission-denied',
      );
      expect(ehErroDeCota(e), false);
    });

    test('nao reconhece erro generico', () {
      expect(ehErroDeCota(StateError('qualquer coisa')), false);
    });

    test('reconhece pelo texto quando a excecao vem embrulhada pela plataforma',
        () {
      // O canal Android entrega PlatformException, cuja mensagem carrega
      // RESOURCE_EXHAUSTED mas cujo `code` nao e o do Firestore.
      expect(ehErroDeCota(Exception('RESOURCE_EXHAUSTED: Quota exceeded.')),
          true);
    });
  });

  group('SyncCotaExcedidaException', () {
    test('carrega a etapa em que parou', () {
      const e = SyncCotaExcedidaException(SyncEtapa.animais, 'x');
      expect(e.etapa, SyncEtapa.animais);
    });

    test('mensagem expoe a causa', () {
      const e = SyncCotaExcedidaException(SyncEtapa.animais, 'estourou');
      expect(e.mensagem, contains('estourou'));
    });
  });
}
