import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/edicao_pendente.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';

void main() {
  group('semEdicaoPendente', () {
    test('descarta ids cujo registro local tem edição não enviada', () {
      final existentes = [
        AcaoEntity(firestoreId: 'a1', needsSync: true),
        AcaoEntity(firestoreId: 'a2', needsSync: false),
      ];

      expect(
        semEdicaoPendente(['a1', 'a2', 'a3'], existentes),
        ['a2', 'a3'],
      );
    });

    test('sem existentes, mantém todos', () {
      expect(semEdicaoPendente(['a1'], const <AcaoEntity>[]), ['a1']);
    });
  });
}
