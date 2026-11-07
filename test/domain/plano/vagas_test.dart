import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/animal_entity.dart';
import 'package:tecmuu/domain/plano/vagas.dart';

void main() {
  test('descartado e excluído não ocupam vaga', () {
    expect(animalOcupaVaga(AnimalEntity(status: 'Vazia')), isTrue);
    expect(animalOcupaVaga(AnimalEntity(status: 'Descarte')), isFalse);
    expect(animalOcupaVaga(AnimalEntity(status: 'Vazia', isDeleted: true)),
        isFalse);
  });
  test('temVaga e quantosCabem', () {
    expect(temVaga(null), isTrue);
    expect(temVaga(0), isFalse);
    expect(temVaga(-3), isFalse);
    expect(quantosCabem(restante: 3, validos: 10), 3);
    expect(quantosCabem(restante: -2, validos: 10), 0);
    expect(quantosCabem(restante: null, validos: 10), 10);
  });
  test('tecnicoIdDoPath', () {
    expect(tecnicoIdDoPath('tecnico/abc'), 'abc');
    expect(tecnicoIdDoPath('produtor/abc'), isNull);
    expect(tecnicoIdDoPath(null), isNull);
  });
}
