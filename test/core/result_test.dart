import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/result/result.dart';

void main() {
  group('Result<T>', () {
    test('Success expõe valor e flags corretas', () {
      const result = Success<int>(42);

      expect(result.isSuccess, true);
      expect(result.isFailure, false);
      expect(result.valueOrNull, 42);
    });

    test('Failure expõe mensagem, erro e flags corretas', () {
      final cause = Exception('boom');
      final result = Failure<int>('Falhou', error: cause);

      expect(result.isSuccess, false);
      expect(result.isFailure, true);
      expect(result.valueOrNull, isNull);
      expect(result.message, 'Falhou');
      expect(result.error, cause);
    });

    test('fold direciona para onSuccess no caso de sucesso', () {
      const Result<String> result = Success('ok');

      final out = result.fold(
        onSuccess: (v) => 'valor=$v',
        onFailure: (f) => 'erro=${f.message}',
      );

      expect(out, 'valor=ok');
    });

    test('fold direciona para onFailure no caso de falha', () {
      const Result<String> result = Failure('quebrou');

      final out = result.fold(
        onSuccess: (v) => 'valor=$v',
        onFailure: (f) => 'erro=${f.message}',
      );

      expect(out, 'erro=quebrou');
    });

    test('pattern matching exaustivo via switch', () {
      const Result<int> result = Success(7);

      final described = switch (result) {
        Success(:final value) => 'sucesso $value',
        Failure(:final message) => 'falha $message',
      };

      expect(described, 'sucesso 7');
    });
  });
}
