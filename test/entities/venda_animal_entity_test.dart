import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';

void main() {
  const prop = 'tecnico/t1/propriedades/p1';

  test('round-trip toFirestore -> fromFirestore preserva os campos', () {
    final v = VendaAnimalEntity(
      firestoreId: 'v1',
      parentPath: prop,
      animalId: 'a1',
      nomeAnimal: 'Mimosa',
      brincoAnimal: 12,
      grupoAnimal: 'Vacas',
      dtVenda: '18/11/2026',
      valorVenda: 1500.5,
    );

    final back = VendaAnimalEntity.fromFirestore(v.toFirestore(), 'v1',
        parentPath: prop);

    expect(back.firestoreId, 'v1');
    expect(back.parentPath, prop);
    expect(back.animalId, 'a1');
    expect(back.nomeAnimal, 'Mimosa');
    expect(back.brincoAnimal, 12);
    expect(back.grupoAnimal, 'Vacas');
    expect(back.dtVenda, '18/11/2026');
    expect(back.valorVenda, 1500.5);
    expect(back.needsSync, isFalse);
  });

  test('valorVenda inteiro vindo do Firestore vira double', () {
    final v = VendaAnimalEntity.fromFirestore(
        {'valorVenda': 1200, 'dtVenda': '01/01/2026'}, 'v2',
        parentPath: prop);
    expect(v.valorVenda, 1200.0);
  });

  test('markAsModified liga needsSync', () {
    final v = VendaAnimalEntity()..markAsModified();
    expect(v.needsSync, isTrue);
    expect(v.lastModified, isNotNull);
  });
}
