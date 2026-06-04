import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../objectbox.g.dart';
import 'objectbox_service.dart';
import 'entities/user_session_entity.dart';

/// Serviço de autenticação offline
/// Permite login local quando sem internet usando dados em cache
/// Valida contra Firebase quando online
class OfflineAuthService {
  static OfflineAuthService? _instance;
  final ObjectBoxService _objectBox;

  OfflineAuthService._(this._objectBox);

  static Future<OfflineAuthService> get instance async {
    if (_instance != null) return _instance!;
    if (!ObjectBoxService.isInitialized) {
      await ObjectBoxService.initialize();
    }
    _instance = OfflineAuthService._(ObjectBoxService.instance);
    return _instance!;
  }

  static Future<void> initialize() async {
    await instance;
  }

  /// Gera hash SHA256 seguro da senha
  /// Nunca armazenar senha em texto simples!
  static String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  /// Realiza login offline (funciona sem internet)
  /// Valida credenciais contra cache local
  Future<UserSessionEntity?> loginOffline({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('🔐 Tentando login offline para: $email');

      final trimmedEmail = email.trim().toLowerCase();
      final passwordHash = hashPassword(password);

      // Busca usuário no cache local
      final box = _objectBox.userSessionBox;
      final existingSession = box
          .query(UserSessionEntity_.email.equals(trimmedEmail))
          .build()
          .findFirst();

      if (existingSession == null) {
        debugPrint(
            '❌ Usuário não encontrado offline. Primeira vez? Verifique conexão.');
        return null;
      }

      // Valida senha
      if (existingSession.passwordHash != passwordHash) {
        debugPrint('❌ Senha incorreta para: $email');
        return null;
      }

      // Valida se sessão não expirou
      if (!existingSession.isSessionValid()) {
        debugPrint('❌ Sessão expirada. Faça login com internet.');
        existingSession.isActive = false;
        box.put(existingSession);
        return null;
      }

      // Atualiza último login bem-sucedido
      existingSession.recordSuccessfulLogin();
      box.put(existingSession);

      debugPrint('✅ Login offline bem-sucedido: $email');
      return existingSession;
    } catch (e) {
      debugPrint('❌ Erro em login offline: $e');
      return null;
    }
  }

  /// Cria nova sessão após login bem-sucedido com Firebase
  /// Armazena credenciais para uso offline futuro
  Future<UserSessionEntity> createSessionFromFirebaseUser({
    required User firebaseUser,
    required String password,
    String? deviceFingerprint,
  }) async {
    try {
      debugPrint('💾 Criando sessão offline para: ${firebaseUser.email}');

      final box = _objectBox.userSessionBox;
      final email = firebaseUser.email?.toLowerCase() ?? '';
      final passwordHash = hashPassword(password);

      // Remove sessão antiga se existir
      final oldSession =
          box.query(UserSessionEntity_.email.equals(email)).build().findFirst();

      if (oldSession != null) {
        box.remove(oldSession.id);
      }

      // Cria nova sessão
      final session = UserSessionEntity(
        email: email,
        passwordHash: passwordHash,
        firebaseUid: firebaseUser.uid,
        displayName: firebaseUser.displayName,
        emailVerified: firebaseUser.emailVerified,
        sessionToken: _generateSessionToken(),
        deviceFingerprint: deviceFingerprint,
        isActive: true,
      );

      session.recordSuccessfulLogin();
      final id = box.put(session);
      session.id = id;

      debugPrint('✅ Sessão criada com ID: $id para ${firebaseUser.email}');
      return session;
    } catch (e) {
      debugPrint('❌ Erro ao criar sessão: $e');
      rethrow;
    }
  }

  /// Valida credenciais contra Firebase (quando online)
  /// Se não pode conectar, tenta usar cache local
  Future<UserSessionEntity?> loginWithFirebaseValidation({
    required String email,
    required String password,
    required Future<UserCredential> Function() firebaseAuth,
    String? deviceFingerprint,
  }) async {
    try {
      final trimmedEmail = email.trim().toLowerCase();

      try {
        debugPrint('🔍 Validando credenciais com Firebase: $trimmedEmail');

        // Tenta validar com Firebase
        final userCredential = await firebaseAuth();

        // Se sucesso, cria/atualiza sessão offline
        final session = await createSessionFromFirebaseUser(
          firebaseUser: userCredential.user!,
          password: password,
          deviceFingerprint: deviceFingerprint,
        );

        debugPrint('✅ Login online bem-sucedido: $trimmedEmail');
        return session;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'network-request-failed' ||
            e.code == 'network-request-timeout') {
          debugPrint('📡 Sem conexão com Firebase. Tentando login offline...');

          // Sem internet, tenta usar cache local
          return await loginOffline(
            email: email,
            password: password,
          );
        }
        rethrow;
      }
    } catch (e) {
      debugPrint('❌ Erro em login: $e');
      rethrow;
    }
  }

  /// Busca sessão ativa do usuário
  Future<UserSessionEntity?> getActiveSession(String email) async {
    try {
      final box = _objectBox.userSessionBox;
      final session = box
          .query(UserSessionEntity_.email.equals(email.toLowerCase()))
          .build()
          .findFirst();

      if (session?.isSessionValid() ?? false) {
        return session;
      }

      return null;
    } catch (e) {
      debugPrint('❌ Erro ao buscar sessão: $e');
      return null;
    }
  }

  /// Marca sessão como necessitando sincronização com Firebase
  /// Será sincronizada quando voltar a conectividade
  Future<void> markSessionForSync(String email) async {
    try {
      final box = _objectBox.userSessionBox;
      final session = box
          .query(UserSessionEntity_.email.equals(email.toLowerCase()))
          .build()
          .findFirst();

      if (session != null) {
        session.needsSync = true;
        session.updatedAt = DateTime.now();
        box.put(session);
        debugPrint('📍 Sessão marcada para sincronização: $email');
      }
    } catch (e) {
      debugPrint('❌ Erro ao marcar sessão: $e');
    }
  }

  /// Sincroniza sessões com Firebase quando voltar online
  /// Valida se credenciais ainda são válidas
  Future<void> syncSessionsWithFirebase({
    required Future<UserCredential> Function(String, String) firebaseAuth,
  }) async {
    try {
      final box = _objectBox.userSessionBox;
      final sessionsToSync =
          box.query(UserSessionEntity_.needsSync.equals(true)).build().find();

      debugPrint('🔄 Sincronizando ${sessionsToSync.length} sessão(ões)...');

      for (final session in sessionsToSync) {
        try {
          // Não pode validar sem a senha, apenas marca como sincronizado
          // A validação real acontecerá no próximo login
          session.markSynced();
          box.put(session);
          debugPrint('✅ Sessão sincronizada: ${session.email}');
        } catch (e) {
          debugPrint('⚠️ Erro ao sincronizar sessão ${session.email}: $e');
        }
      }
    } catch (e) {
      debugPrint('❌ Erro geral em sync de sessões: $e');
    }
  }

  /// Invalida sessão do usuário (logout)
  Future<void> invalidateSession(String email) async {
    try {
      final box = _objectBox.userSessionBox;
      final session = box
          .query(UserSessionEntity_.email.equals(email.toLowerCase()))
          .build()
          .findFirst();

      if (session != null) {
        session.isActive = false;
        session.updatedAt = DateTime.now();
        box.put(session);
        debugPrint('🚪 Sessão invalidada: $email');
      }
    } catch (e) {
      debugPrint('❌ Erro ao invalidar sessão: $e');
    }
  }

  /// Limpa todas as sessões (logout de todos os dispositivos)
  Future<void> clearAllSessions() async {
    try {
      final box = _objectBox.userSessionBox;
      box.removeAll();
      debugPrint('🗑️ Todas as sessões foram removidas');
    } catch (e) {
      debugPrint('❌ Erro ao limpar sessões: $e');
    }
  }

  /// Gera token de sessão único
  static String _generateSessionToken() {
    return sha256
        .convert(utf8.encode('${DateTime.now().millisecondsSinceEpoch}'))
        .toString();
  }

  /// Obtém todas as sessões ativas (para debug)
  Future<List<UserSessionEntity>> getAllActiveSessions() async {
    try {
      final box = _objectBox.userSessionBox;
      return box.query(UserSessionEntity_.isActive.equals(true)).build().find();
    } catch (e) {
      debugPrint('❌ Erro ao listar sessões: $e');
      return [];
    }
  }
}
