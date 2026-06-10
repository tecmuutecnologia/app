import 'package:local_auth/local_auth.dart';

/// Wrapper fino sobre `local_auth` para o desbloqueio offline por
/// biometria/PIN/padrão do dispositivo.
///
/// Todas as chamadas são defensivas (try/catch -> `false`): em qualquer falha
/// ou indisponibilidade, o app cai no fluxo de senha (sem travar o login).
class BiometricService {
  BiometricService({LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  /// `true` se o aparelho suporta e tem alguma credencial cadastrada
  /// (biometria ou PIN/padrão do dispositivo).
  Future<bool> isAvailable() async {
    try {
      return await _auth.isDeviceSupported() && await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  /// Solicita a autenticação local. Retorna `true` somente se o usuário
  /// confirmar com sucesso. Permite o PIN/padrão como fallback à biometria.
  Future<bool> authenticate({
    String motivo = 'Confirme sua identidade para entrar offline',
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: motivo,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
