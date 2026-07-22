import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/user_session_entity.dart';

/// Testes de caracterização da `UserSessionEntity` (login offline).
///
/// Objetivo (Fase 0): fixar o comportamento ATUAL da sessão offline ANTES da
/// Fase 2, que vai REMOVER o armazenamento de hash de senha e migrar para
/// secure storage + biometria. Estes testes documentam o contrato vigente
/// (incluindo a regra de expiração de 30 dias) para que a migração seja
/// consciente — espera-se que o teste sobre `passwordHash` seja revisto quando
/// o hash deixar de existir.
void main() {
  group('UserSessionEntity - criação', () {
    test('defaults: ativa, sem sync pendente e timestamps inicializados', () {
      final session = UserSessionEntity(
        email: 'tecnico@tecmuu.com',
        passwordHash: 'abc123hash',
      );

      expect(session.email, 'tecnico@tecmuu.com');
      expect(session.passwordHash, 'abc123hash');
      expect(session.isActive, true);
      expect(session.needsSync, false);
      expect(session.emailVerified, false);
      expect(session.createdAt, isNotNull);
      expect(session.updatedAt, isNotNull);
      expect(session.lastSuccessfulLogin, isNull);
    });
  });

  group('UserSessionEntity - ciclo de vida da sessão', () {
    test('recordSuccessfulLogin registra horário do último login', () {
      final session = UserSessionEntity(email: 'a@b.com', passwordHash: 'h');
      expect(session.lastSuccessfulLogin, isNull);

      session.recordSuccessfulLogin();

      expect(session.lastSuccessfulLogin, isNotNull);
    });

    test('markSynced limpa needsSync e grava lastSyncedAt', () {
      final session = UserSessionEntity(
        email: 'a@b.com',
        passwordHash: 'h',
        needsSync: true,
      );

      session.markSynced();

      expect(session.needsSync, false);
      expect(session.lastSyncedAt, isNotNull);
    });
  });

  group('UserSessionEntity - validade da sessão (30 dias)', () {
    test('sessão sem login nunca é válida', () {
      final session = UserSessionEntity(email: 'a@b.com', passwordHash: 'h');
      expect(session.isSessionValid(), false);
    });

    test('login recente mantém a sessão válida', () {
      final session = UserSessionEntity(email: 'a@b.com', passwordHash: 'h');
      session.recordSuccessfulLogin();

      expect(session.isSessionValid(), true);
    });

    test('login há mais de 30 dias invalida a sessão', () {
      final session = UserSessionEntity(email: 'a@b.com', passwordHash: 'h');
      session.lastSuccessfulLogin =
          DateTime.now().subtract(const Duration(days: 31));

      expect(session.isSessionValid(), false);
    });

    test('limite de inatividade é configurável', () {
      final session = UserSessionEntity(email: 'a@b.com', passwordHash: 'h');
      session.lastSuccessfulLogin =
          DateTime.now().subtract(const Duration(days: 5));

      expect(session.isSessionValid(maxDaysInactive: 3), false);
      expect(session.isSessionValid(maxDaysInactive: 10), true);
    });

    test('sessão inativa nunca é válida, mesmo com login recente', () {
      final session = UserSessionEntity(email: 'a@b.com', passwordHash: 'h');
      session.recordSuccessfulLogin();
      session.isActive = false;

      expect(session.isSessionValid(), false);
    });
  });
}
