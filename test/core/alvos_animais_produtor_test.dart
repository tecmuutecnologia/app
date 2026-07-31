import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/alvos_animais_produtor.dart';
import 'package:tecmuu/data/objectbox/entities/propriedade_entity.dart';

/// O download completo baixava animais e ações a partir do documento do
/// TÉCNICO. Quem loga como PRODUTOR não tem documento de técnico, então o
/// `tecnicoRef` chegava nulo e as duas funções retornavam na primeira linha:
/// nenhum animal descia do Firestore, e o produtor só via o que ele mesmo havia
/// criado offline naquele aparelho — exatamente o sintoma relatado.
///
/// O produtor chega nos animais pelo caminho das propriedades dele, que o
/// download anterior já gravou com o `parentPath` do técnico dono.
void main() {
  PropriedadeEntity prop(String? firestoreId, String? parentPath) =>
      PropriedadeEntity(firestoreId: firestoreId, parentPath: parentPath);

  group('alvosAnimaisProdutor', () {
    test('deriva o técnico e a propriedade a partir das propriedades locais',
        () {
      final alvos = alvosAnimaisProdutor([prop('faz1', 'tecnico/abc')]);

      expect(alvos, hasLength(1));
      expect(alvos.single.tecnicoPath, 'tecnico/abc');
      // É por este path que os animais referenciam a propriedade
      // (`uidTecnicoPropriedade`).
      expect(alvos.single.propriedadePath, 'tecnico/abc/propriedades/faz1');
    });

    test('produtor com propriedades sob técnicos diferentes busca nos dois', () {
      final alvos = alvosAnimaisProdutor([
        prop('faz1', 'tecnico/abc'),
        prop('faz2', 'tecnico/xyz'),
      ]);

      expect(alvos.map((a) => a.tecnicoPath), ['tecnico/abc', 'tecnico/xyz']);
    });

    test('propriedade que nunca subiu ao Firestore é ignorada', () {
      // Criada offline: sem firestoreId não há documento para filtrar, e montar
      // um path com id vazio buscaria a coleção errada.
      expect(alvosAnimaisProdutor([prop(null, 'tecnico/abc')]), isEmpty);
      expect(alvosAnimaisProdutor([prop('', 'tecnico/abc')]), isEmpty);
    });

    test('propriedade sem parentPath é ignorada', () {
      expect(alvosAnimaisProdutor([prop('faz1', null)]), isEmpty);
      expect(alvosAnimaisProdutor([prop('faz1', '')]), isEmpty);
    });

    test('duplicatas não viram consultas repetidas', () {
      final alvos = alvosAnimaisProdutor([
        prop('faz1', 'tecnico/abc'),
        prop('faz1', 'tecnico/abc'),
      ]);

      expect(alvos, hasLength(1));
    });

    test('lista vazia não gera consulta', () {
      expect(alvosAnimaisProdutor(const []), isEmpty);
    });
  });
}
