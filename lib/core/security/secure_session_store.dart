import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Guarda o token de sessão (e o email associado) no armazenamento SEGURO do SO
/// — Keychain no iOS, Keystore/EncryptedSharedPreferences no Android — em vez de
/// em texto no ObjectBox/SharedPreferences.
///
/// Serve para reabrir a sessão offline (ex.: após biometria, ver
/// [BiometricService]) sem voltar a guardar a senha. A senha em si NUNCA é
/// armazenada (o verificador continua em PBKDF2 no `PasswordHasher`).
class SecureSessionStore {
  SecureSessionStore({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _storage;

  static const String _kToken = 'tecmuu_session_token';
  static const String _kEmail = 'tecmuu_session_email';

  Future<void> save({required String email, required String token}) async {
    await _storage.write(key: _kEmail, value: email);
    await _storage.write(key: _kToken, value: token);
  }

  Future<String?> readToken() => _storage.read(key: _kToken);

  Future<String?> readEmail() => _storage.read(key: _kEmail);

  Future<bool> hasSession() async => (await readToken()) != null;

  Future<void> clear() async {
    await _storage.delete(key: _kToken);
    await _storage.delete(key: _kEmail);
  }
}
