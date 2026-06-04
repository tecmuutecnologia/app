import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Derivação e verificação segura de senha para o login offline.
///
/// ## Por que existe
///
/// O serviço de login offline precisa validar a senha sem internet, comparando-a
/// com um verificador guardado localmente. A implementação anterior guardava um
/// **SHA256 puro da senha** — rápido de calcular e, portanto, vulnerável a ataques
/// de força bruta/rainbow table caso o dispositivo seja comprometido, além de não
/// usar salt (senhas iguais geram o mesmo hash).
///
/// Esta classe troca isso por **PBKDF2-HMAC-SHA256 com salt aleatório e muitas
/// iterações**, o padrão para armazenar verificadores de senha. A verificação usa
/// comparação em tempo constante para não vazar informação por timing.
///
/// O verificador é serializado num único campo de texto, no formato:
///
///     pbkdf2$<iterations>$<saltBase64>$<derivedKeyBase64>
///
/// assim cabe no campo `passwordHash` existente, sem alterar o modelo do ObjectBox.
///
/// ## Migração
///
/// [verify] aceita o formato legado (SHA256 puro) para que sessões já existentes
/// continuem validando. Quem chama deve, após um login bem-sucedido em formato
/// legado, regravar o verificador com [hash] (ver `OfflineAuthService.loginOffline`).
class PasswordHasher {
  const PasswordHasher._();

  static const String _algorithmId = 'pbkdf2';
  static const int _iterations = 100000;
  static const int _saltLength = 16; // 128 bits
  static const int _keyLength = 32; // 256 bits (um bloco SHA256)

  /// Gera um verificador salgado para [password].
  ///
  /// [random] permite injetar uma fonte determinística em testes; em produção,
  /// usa `Random.secure()`.
  static String hash(String password, {Random? random}) {
    final salt = _generateSalt(random ?? Random.secure());
    final derived = _pbkdf2(password, salt, _iterations);
    return '$_algorithmId\$$_iterations\$${base64.encode(salt)}\$${base64.encode(derived)}';
  }

  /// Verifica [password] contra um verificador [stored] previamente gerado.
  ///
  /// Aceita também o formato legado (SHA256 puro) para compatibilidade.
  static bool verify(String password, String stored) {
    final parts = stored.split('\$');

    // Formato legado: não tem o prefixo do algoritmo (SHA256 puro).
    if (parts.length != 4 || parts[0] != _algorithmId) {
      return _legacySha256(password) == stored;
    }

    final iterations = int.tryParse(parts[1]);
    if (iterations == null) return false;

    final List<int> salt;
    final List<int> expected;
    try {
      salt = base64.decode(parts[2]);
      expected = base64.decode(parts[3]);
    } on FormatException {
      return false;
    }

    final actual = _pbkdf2(password, salt, iterations);
    return _constantTimeEquals(actual, expected);
  }

  /// `true` se [stored] está no formato legado (SHA256 puro) e deve ser
  /// regravado com [hash] após um login bem-sucedido.
  static bool isLegacyFormat(String stored) {
    final parts = stored.split('\$');
    return parts.length != 4 || parts[0] != _algorithmId;
  }

  // ---------------------------------------------------------------------------

  static List<int> _generateSalt(Random random) =>
      List<int>.generate(_saltLength, (_) => random.nextInt(256));

  /// PBKDF2-HMAC-SHA256 para um único bloco de saída (dkLen == 32).
  static List<int> _pbkdf2(String password, List<int> salt, int iterations) {
    final hmac = Hmac(sha256, utf8.encode(password));

    // Bloco 1: U1 = PRF(password, salt || INT_32_BE(1))
    var u = hmac.convert([...salt, 0, 0, 0, 1]).bytes;
    final result = List<int>.from(u);

    // Tn = U1 ^ U2 ^ ... ^ Uc
    for (var i = 1; i < iterations; i++) {
      u = hmac.convert(u).bytes;
      for (var k = 0; k < _keyLength; k++) {
        result[k] ^= u[k];
      }
    }
    return result;
  }

  static String _legacySha256(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  static bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}
