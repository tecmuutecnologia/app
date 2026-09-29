import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/domain/animais/vinculo_acao_animal.dart';

/// Uma ação se liga ao animal pelo caminho no Firestore. Animal criado offline
/// ainda não tem `firestoreId` — e portanto não tem caminho —, então as ações
/// dele guardam `uidAnimalOffline`. Quem casa os dois só pelo caminho perde o
/// histórico do animal offline (foi o que tirou esse animal do relatório).
void main() {
  AnimalEntity animal({String? id, String? offline}) => AnimalEntity(
        parentPath: 'tecnico/T1',
        firestoreId: id,
        uidAnimalOffline: offline,
      );

  test('casa pelo caminho quando o animal já subiu', () {
    final acao = AcaoEntity(
        uidAnimalAnimaisProdutoresPath: 'tecnico/T1/animaisProdutores/A1');
    expect(acaoEhDoAnimal(acao, animal(id: 'A1')), true);
  });

  test('ação de outro animal não entra', () {
    final acao = AcaoEntity(
        uidAnimalAnimaisProdutoresPath: 'tecnico/T1/animaisProdutores/OUTRO');
    expect(acaoEhDoAnimal(acao, animal(id: 'A1')), false);
  });

  test('casa pela identidade offline quando o animal ainda não subiu', () {
    final acao = AcaoEntity(uidAnimalOffline: 'off-123');
    expect(acaoEhDoAnimal(acao, animal(offline: 'off-123')), true);
  });

  test('identidade offline diferente não entra', () {
    final acao = AcaoEntity(uidAnimalOffline: 'off-999');
    expect(acaoEhDoAnimal(acao, animal(offline: 'off-123')), false);
  });

  test('ação sem vínculo nenhum não entra', () {
    expect(acaoEhDoAnimal(AcaoEntity(), animal(id: 'A1')), false);
  });

  test('animal sem vínculo nenhum não puxa ação solta', () {
    final acao = AcaoEntity(uidAnimalOffline: 'off-123');
    expect(acaoEhDoAnimal(acao, animal()), false);
  });
}
