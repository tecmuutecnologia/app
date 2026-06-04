import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/conflict_resolver.dart';

void main() {
  group('ConflictResolver.shouldApplyRemote', () {
    final t1 = DateTime(2026, 6, 1, 10, 0, 0, 0);
    final t1PlusMs = DateTime(2026, 6, 1, 10, 0, 0, 1); // +1ms
    final t0 = DateTime(2026, 5, 1);

    test('local com pendência NUNCA é sobrescrito (regra 1)', () {
      expect(
        ConflictResolver.shouldApplyRemote(
          localHasPendingChanges: true,
          localLastModified: t0, // local mais antigo
          remoteLastModified: t1, // remoto mais novo
        ),
        false,
      );
    });

    test('remoto mais novo vence quando não há pendência local (regra 2)', () {
      expect(
        ConflictResolver.shouldApplyRemote(
          localHasPendingChanges: false,
          localLastModified: t1,
          remoteLastModified: t1PlusMs,
        ),
        true,
      );
    });

    test('remoto mais antigo NÃO sobrescreve (regra 2)', () {
      expect(
        ConflictResolver.shouldApplyRemote(
          localHasPendingChanges: false,
          localLastModified: t1,
          remoteLastModified: t0,
        ),
        false,
      );
    });

    test('empate de timestamp mantém o local (regra 2)', () {
      expect(
        ConflictResolver.shouldApplyRemote(
          localHasPendingChanges: false,
          localLastModified: t1,
          remoteLastModified: t1,
        ),
        false,
      );
    });

    test('diferença de 1ms é distinguida (precisão de milissegundos)', () {
      expect(
        ConflictResolver.shouldApplyRemote(
          localHasPendingChanges: false,
          localLastModified: t1PlusMs,
          remoteLastModified: t1,
        ),
        false,
      );
    });

    test('sem timestamp remoto e sem pendência: aceita o remoto (regra 3)', () {
      expect(
        ConflictResolver.shouldApplyRemote(
          localHasPendingChanges: false,
          localLastModified: t1,
          remoteLastModified: null,
        ),
        true,
      );
    });

    test('sem timestamp local e sem pendência: aceita o remoto (regra 3)', () {
      expect(
        ConflictResolver.shouldApplyRemote(
          localHasPendingChanges: false,
          localLastModified: null,
          remoteLastModified: t1,
        ),
        true,
      );
    });

    test('pendência local prevalece mesmo sem timestamps', () {
      expect(
        ConflictResolver.shouldApplyRemote(
          localHasPendingChanges: true,
          localLastModified: null,
          remoteLastModified: null,
        ),
        false,
      );
    });
  });
}
