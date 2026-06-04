import 'package:objectbox/objectbox.dart';

/// Entidade para armazenar sessão de usuário offline
/// Permite login local quando sem internet
/// Sincroniza com Firebase quando online
@Entity()
class UserSessionEntity {
  @Id()
  int id = 0;

  /// Email do usuário
  @Unique()
  String email = '';

  /// Hash SHA256 da senha (nunca armazenar senha em texto)
  String passwordHash = '';

  /// UID do Firebase (sincronizado)
  String? firebaseUid;

  /// Token de sessão (gerado localmente)
  String sessionToken = '';

  /// Nome do usuário (cache)
  String? displayName;

  /// Email verificado
  bool emailVerified = false;

  /// Timestamp de último login bem-sucedido
  DateTime? lastSuccessfulLogin;

  /// Timestamp de última sincronização com Firebase
  DateTime? lastSyncedAt;

  /// Flag indicando que credenciais precisam sincronizar
  bool needsSync = false;

  /// Dispositivo/fingerprint para validação
  String? deviceFingerprint;

  /// Timestamp de criação da sessão local
  DateTime createdAt = DateTime.now();

  /// Timestamp de atualização
  DateTime updatedAt = DateTime.now();

  /// Ativo ou inativo
  bool isActive = true;

  UserSessionEntity({
    required this.email,
    required this.passwordHash,
    this.firebaseUid,
    this.sessionToken = '',
    this.displayName,
    this.emailVerified = false,
    this.lastSuccessfulLogin,
    this.lastSyncedAt,
    this.needsSync = false,
    this.deviceFingerprint,
    this.isActive = true,
  }) {
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  /// Atualiza timestamp de último login
  void recordSuccessfulLogin() {
    lastSuccessfulLogin = DateTime.now();
    updatedAt = DateTime.now();
  }

  /// Marca como sincronizado com Firebase
  void markSynced() {
    lastSyncedAt = DateTime.now();
    needsSync = false;
    updatedAt = DateTime.now();
  }

  /// Valida se sessão não expirou (30 dias de inatividade)
  bool isSessionValid({int maxDaysInactive = 30}) {
    if (!isActive) return false;
    if (lastSuccessfulLogin == null) return false;

    final daysSinceLastLogin =
        DateTime.now().difference(lastSuccessfulLogin!).inDays;
    return daysSinceLastLogin < maxDaysInactive;
  }

  @override
  String toString() =>
      'UserSessionEntity(email=$email, firebaseUid=$firebaseUid, active=$isActive)';
}
