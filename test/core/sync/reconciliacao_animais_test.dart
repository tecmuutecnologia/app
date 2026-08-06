import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/reconciliacao_animais.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';

void main() {
  const parentPath = 'tecnico/abc';

  DocAnimal doc(String id, String nome) =>
      DocAnimal(id, <String, dynamic>{'nomeAnimal': nome});

  group('reconciliarAnimais', () {
    test('doc novo vira entidade com id local zerado', () {
      final r = reconciliarAnimais(
        docs: [doc('f1', 'Mimosa')],
        existentesPorFirestoreId: {},
        parentPath: parentPath,
      );

      expect(r, hasLength(1));
      expect(r.single.firestoreId, 'f1');
      expect(r.single.id, 0, reason: 'ObjectBox atribui o id no put');
    });

    test('doc ja existente preserva o id local (nao duplica)', () {
      final existente = AnimalEntity.fromFirestore(
        <String, dynamic>{'nomeAnimal': 'Mimosa'},
        'f1',
        parentPath,
      )..id = 42;

      final r = reconciliarAnimais(
        docs: [doc('f1', 'Mimosa II')],
        existentesPorFirestoreId: {'f1': existente},
        parentPath: parentPath,
      );

      expect(r.single.id, 42);
      expect(r.single.nomeAnimal, 'Mimosa II');
    });

    test('aplicar o mesmo lote duas vezes nao insere de novo', () {
      // Simula o 2o download completo do aparelho, que ja derrubou o download
      // inteiro uma vez por violar o indice unico de firestoreId.
      final primeira = reconciliarAnimais(
        docs: [doc('f1', 'Mimosa'), doc('f2', 'Estrela')],
        existentesPorFirestoreId: {},
        parentPath: parentPath,
      );
      // O put atribuiria ids; simulamos isso.
      primeira[0].id = 1;
      primeira[1].id = 2;

      final segunda = reconciliarAnimais(
        docs: [doc('f1', 'Mimosa'), doc('f2', 'Estrela')],
        existentesPorFirestoreId: {
          for (final e in primeira) e.firestoreId!: e,
        },
        parentPath: parentPath,
      );

      expect(segunda.map((e) => e.id), [1, 2]);
    });

    test('lote misto separa novos de existentes', () {
      final existente = AnimalEntity.fromFirestore(
        <String, dynamic>{'nomeAnimal': 'Mimosa'},
        'f1',
        parentPath,
      )..id = 7;

      final r = reconciliarAnimais(
        docs: [doc('f1', 'Mimosa'), doc('f2', 'Nova')],
        existentesPorFirestoreId: {'f1': existente},
        parentPath: parentPath,
      );

      expect(r.map((e) => e.id), [7, 0]);
    });

    test('lote vazio devolve lista vazia', () {
      expect(
        reconciliarAnimais(
          docs: const [],
          existentesPorFirestoreId: {},
          parentPath: parentPath,
        ),
        isEmpty,
      );
    });
  });
}
