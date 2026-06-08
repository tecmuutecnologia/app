import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/conflict_resolver.dart';

/// Testa a política canônica de resolução de conflitos (Firestore -> ObjectBox).
/// É lógica pura, então cobrimos todas as ramificações da regra.
void main() {
  final t0 = DateTime(2026, 1, 1, 12, 0, 0);
  final t1ms = t0.add(const Duration(milliseconds: 1));

  group('ConflictResolver.shouldApplyRemote', () {
    group('1. edição local pendente nunca é sobrescrita', () {
      test('pendente vence mesmo com remoto mais novo', () {
        expect(
          ConflictResolver.shouldApplyRemote(
            localHasPendingChanges: true,
            localLastModified: t0,
            remoteLastModified: t1ms,
          ),
          false,
        );
      });

      test('pendente vence mesmo sem timestamps', () {
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

    group('2. sem pendência, ambos timestamps: mais novo vence (ms)', () {
      test('remoto 1ms mais novo sobrescreve', () {
        expect(
          ConflictResolver.shouldApplyRemote(
            localHasPendingChanges: false,
            localLastModified: t0,
            remoteLastModified: t1ms,
          ),
          true,
        );
      });

      test('remoto mais antigo NÃO sobrescreve', () {
        expect(
          ConflictResolver.shouldApplyRemote(
            localHasPendingChanges: false,
            localLastModified: t1ms,
            remoteLastModified: t0,
          ),
          false,
        );
      });

      test('empate mantém o local (evita escrita inútil)', () {
        expect(
          ConflictResolver.shouldApplyRemote(
            localHasPendingChanges: false,
            localLastModified: t0,
            remoteLastModified: t0,
          ),
          false,
        );
      });
    });

    group('3. sem pendência e sem datas comparáveis: aceita o remoto', () {
      test('remoto sem data', () {
        expect(
          ConflictResolver.shouldApplyRemote(
            localHasPendingChanges: false,
            localLastModified: t0,
            remoteLastModified: null,
          ),
          true,
        );
      });

      test('local sem data', () {
        expect(
          ConflictResolver.shouldApplyRemote(
            localHasPendingChanges: false,
            localLastModified: null,
            remoteLastModified: t0,
          ),
          true,
        );
      });

      test('ambos sem data', () {
        expect(
          ConflictResolver.shouldApplyRemote(
            localHasPendingChanges: false,
            localLastModified: null,
            remoteLastModified: null,
          ),
          true,
        );
      });
    });
  });
}
