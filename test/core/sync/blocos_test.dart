import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/blocos.dart';

/// O `whereIn` do Firestore aceita no máximo 30 valores, então a busca das
/// ações de um produtor pelos animais dele vai em blocos.
void main() {
  test('lista menor que o limite vira um bloco só', () {
    expect(emBlocos([1, 2, 3], 30), [[1, 2, 3]]);
  });

  test('quebra no limite', () {
    expect(emBlocos(List.generate(65, (i) => i), 30).map((b) => b.length),
        [30, 30, 5]);
  });

  test('lista vazia não gera bloco', () {
    expect(emBlocos(<int>[], 30), isEmpty);
  });

  test('limite inválido não trava em laço infinito', () {
    expect(() => emBlocos([1], 0), throwsA(isA<AssertionError>()));
  });
}
