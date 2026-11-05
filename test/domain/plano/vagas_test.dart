import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/animal_entity.dart';
import 'package:tecmuu/data/objectbox/entities/propriedade_entity.dart';
import 'package:tecmuu/domain/plano/vagas.dart';

void main() {
  test('descartado e excluído não ocupam vaga', () {
    expect(animalOcupaVaga(AnimalEntity(status: 'Vazia')), isTrue);
    expect(animalOcupaVaga(AnimalEntity(status: 'Descarte')), isFalse);
    expect(animalOcupaVaga(AnimalEntity(status: 'Vazia', isDeleted: true)),
        isFalse);
  });
  test('conta só animais do técnico', () {
    final a = [
      AnimalEntity(parentPath: 'tecnico/t1', status: 'Vazia'),
      AnimalEntity(parentPath: 'tecnico/t1', grupoAnimal: 'Sêmens'),
      AnimalEntity(parentPath: 'tecnico/t1', status: 'Descarte'),
      AnimalEntity(parentPath: 'tecnico/t2', status: 'Vazia'),
    ];
    expect(contarAnimaisAtivos(a, tecnicoPath: 'tecnico/t1'), 2);
  });
  test('produtor na lixeira continua ocupando vaga', () {
    final p = [
      PropriedadeEntity(parentPath: 'tecnico/t1', contaCriada: true),
      PropriedadeEntity(
          parentPath: 'tecnico/t1', contaCriada: true, isDeleted: true),
      PropriedadeEntity(parentPath: 'tecnico/t1', contaCriada: false),
    ];
    expect(contarProdutoresAtivos(p, tecnicoPath: 'tecnico/t1'), 2);
  });
  test('recalcula pelo plano e permite saldo negativo', () {
    expect(recalcularSaldo(limiteDoPlano: 200, limiteAtual: 50, ativos: 230),
        const SaldoVagas(limite: 200, quantidade: 230, restante: -30));
  });
  test('limiteAusenteMantemAtual', () {
    expect(recalcularSaldo(limiteDoPlano: 0, limiteAtual: 50, ativos: 10),
        const SaldoVagas(limite: 50, quantidade: 10, restante: 40));
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
