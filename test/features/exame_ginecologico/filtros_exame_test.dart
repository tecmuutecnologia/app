import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/schema/structs/animais_produtores_struct.dart';
import 'package:tecmuu/features/exame_ginecologico/application/filtros_exame.dart';

AnimaisProdutoresStruct animal({
  String nome = 'Mimosa',
  int brinco = 7,
  String? status,
  String? grupo,
  DateTime? inducao,
}) =>
    AnimaisProdutoresStruct(
      nomeAnimal: nome,
      brincoAnimal: brinco,
      status: status,
      grupoAnimal: grupo,
      dtInducaoLactacao: inducao,
    );

List<String> nomes(List<AnimaisProdutoresStruct> l) =>
    l.map((e) => e.nomeAnimal).toList();

void main() {
  test('mantem vaca e novilha vazias', () {
    final lista = [
      animal(nome: 'Vaca', grupo: 'Vacas', status: 'Vazia'),
      animal(nome: 'Novilha', grupo: 'Novilhas', status: 'Vazia'),
    ];

    expect(nomes(elegiveisExame(lista)), ['Vaca', 'Novilha']);
  });

  test('descarta quem nao esta vazia', () {
    final lista = [
      animal(nome: 'Vazia', grupo: 'Vacas', status: 'Vazia'),
      animal(nome: 'Prenha', grupo: 'Vacas', status: 'Prenha'),
    ];

    expect(nomes(elegiveisExame(lista)), ['Vazia']);
  });

  test('descarta grupo fora de vaca/novilha', () {
    final lista = [animal(nome: 'Bezerra', grupo: 'Bezerras', status: 'Vazia')];

    expect(elegiveisExame(lista), isEmpty);
  });

  test('descarta quem tem inducao de lactacao', () {
    final lista = [
      animal(
          nome: 'Induzida',
          grupo: 'Vacas',
          status: 'Vazia',
          inducao: DateTime(2026, 3, 1)),
    ];

    expect(elegiveisExame(lista), isEmpty);
  });

  group('busca', () {
    final lista = [
      animal(nome: 'Bonita', brinco: 47, grupo: 'Vacas', status: 'Vazia'),
      animal(nome: 'Aurora', brinco: 12, grupo: 'Vacas', status: 'Vazia'),
    ];

    test('vazia devolve todas', () {
      expect(elegiveisExame(lista, busca: ''), hasLength(2));
    });

    test('casa por nome', () {
      expect(nomes(elegiveisExame(lista, busca: 'auro')), ['Aurora']);
    });

    test('casa por brinco', () {
      expect(nomes(elegiveisExame(lista, busca: '47')), ['Bonita']);
    });
  });
}
