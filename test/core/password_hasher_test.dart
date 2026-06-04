import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/security/password_hasher.dart';

void main() {
  group('PasswordHasher', () {
    test('hash + verify aceita a senha correta', () {
      final stored = PasswordHasher.hash('senhaForte123');
      expect(PasswordHasher.verify('senhaForte123', stored), true);
    });

    test('verify rejeita senha incorreta', () {
      final stored = PasswordHasher.hash('senhaForte123');
      expect(PasswordHasher.verify('senhaErrada', stored), false);
    });

    test('usa salt: a mesma senha gera verificadores diferentes', () {
      final a = PasswordHasher.hash('mesmaSenha');
      final b = PasswordHasher.hash('mesmaSenha');
      expect(a, isNot(equals(b)));
      // mas ambos validam a senha
      expect(PasswordHasher.verify('mesmaSenha', a), true);
      expect(PasswordHasher.verify('mesmaSenha', b), true);
    });

    test('formato serializado tem 4 partes: pbkdf2, iter, salt, hash', () {
      final stored = PasswordHasher.hash('x', random: Random(1));
      final parts = stored.split('\$');
      expect(parts.length, 4);
      expect(parts[0], 'pbkdf2');
      expect(int.parse(parts[1]), 100000);
      // salt e hash são base64 válidos
      expect(() => base64.decode(parts[2]), returnsNormally);
      expect(() => base64.decode(parts[3]), returnsNormally);
    });

    test('salt determinístico com Random injetado é reprodutível', () {
      final a = PasswordHasher.hash('abc', random: Random(42));
      final b = PasswordHasher.hash('abc', random: Random(42));
      expect(a, equals(b));
    });

    group('compatibilidade com formato legado (SHA256 puro)', () {
      String legacySha256(String p) =>
          sha256.convert(utf8.encode(p)).toString();

      test('verify aceita verificador legado correto', () {
        final legacy = legacySha256('senhaLegada');
        expect(PasswordHasher.verify('senhaLegada', legacy), true);
        expect(PasswordHasher.verify('outra', legacy), false);
      });

      test('isLegacyFormat distingue legado de pbkdf2', () {
        expect(PasswordHasher.isLegacyFormat(legacySha256('x')), true);
        expect(PasswordHasher.isLegacyFormat(PasswordHasher.hash('x')), false);
      });
    });

    test('verify lida com entrada malformada sem lançar', () {
      expect(PasswordHasher.verify('x', 'pbkdf2\$abc\$def\$ghi'), false);
      expect(PasswordHasher.verify('x', 'pbkdf2\$100\$@@@\$@@@'), false);
    });
  });
}
