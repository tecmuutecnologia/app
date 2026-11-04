import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/animal_entity.dart';
import 'package:tecmuu/features/calendario_sanitario/application/animais_calendario.dart';

AnimalEntity _a(String nome, String grupo,
        {String status = 'Vazia', bool apagado = false, int brinco = 0}) =>
    AnimalEntity(
      nomeAnimal: nome,
      grupoAnimal: grupo,
      status: status,
      isDeleted: apagado,
      brincoAnimalOrder: brinco,
    );

void main() {
  final rebanho = [
    _a('Mimosa', 'Vacas', status: 'Prenha'),
    _a('Estrela', 'Vacas'),
    _a('Velha', 'Vacas', status: 'Descarte'),
    _a('Apagada', 'Vacas', apagado: true),
    _a('Dose', 'Sêmens'),
    _a('Bidu', 'Bezerros'),
  ];

  test('todos: sem sêmen nem apagados, ordenados por grupo e nome', () {
    expect(animaisDoCalendario(rebanho).map((a) => a.nomeAnimal),
        ['Bidu', 'Estrela', 'Mimosa', 'Velha']);
  });

  test('por grupo: sem descarte, ordenados por status e nome', () {
    expect(
        animaisDoCalendario(rebanho, grupo: 'Vacas').map((a) => a.nomeAnimal),
        ['Mimosa', 'Estrela']);
  });

  test('desempata pelo brinco', () {
    final lista = [
      _a('X', 'Touros', brinco: 9),
      _a('X', 'Touros', brinco: 2),
    ];
    expect(
        animaisDoCalendario(lista, grupo: 'Touros')
            .map((a) => a.brincoAnimalOrder),
        [2, 9]);
  });
}
