import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/schema/structs/animais_produtores_struct.dart';
import 'package:tecmuu/features/inseminacoes/application/filtros_inseminacao.dart';

AnimaisProdutoresStruct animal({
  String nome = 'Mimosa',
  int brinco = 7,
  String? status,
  String? grupo,
}) =>
    AnimaisProdutoresStruct(
      nomeAnimal: nome,
      brincoAnimal: brinco,
      status: status,
      grupoAnimal: grupo,
    );

List<String> nomes(List<AnimaisProdutoresStruct> l) =>
    l.map((e) => e.nomeAnimal).toList();

void main() {
  test('aceita vaca e novilha vazias, inseminadas e inseminadas PP', () {
    final lista = [
      animal(nome: 'Vazia', grupo: 'Vacas', status: 'Vazia'),
      animal(nome: 'Insem', grupo: 'Novilhas', status: 'Inseminada'),
      animal(nome: 'InsemPP', grupo: 'Vacas', status: 'Inseminada PP'),
    ];

    expect(nomes(elegiveisInseminacao(lista)),
        ['Vazia', 'Insem', 'InsemPP']);
  });

  test('descarta status fora da regra', () {
    final lista = [
      animal(nome: 'Prenha', grupo: 'Vacas', status: 'Prenha'),
      animal(nome: 'Seca', grupo: 'Vacas', status: 'Seca'),
    ];

    expect(elegiveisInseminacao(lista), isEmpty);
  });

  test('descarta grupo fora de vaca/novilha', () {
    final lista = [
      animal(nome: 'Touro', grupo: 'Touros', status: 'Vazia'),
      animal(nome: 'Bezerra', grupo: 'Bezerras', status: 'Vazia'),
    ];

    expect(elegiveisInseminacao(lista), isEmpty);
  });

  group('busca', () {
    final lista = [
      animal(nome: 'Bonita', brinco: 47, grupo: 'Vacas', status: 'Vazia'),
      animal(nome: 'Aurora', brinco: 12, grupo: 'Vacas', status: 'Vazia'),
    ];

    test('vazia devolve todas', () {
      expect(elegiveisInseminacao(lista, busca: ''), hasLength(2));
    });

    test('casa por nome', () {
      expect(nomes(elegiveisInseminacao(lista, busca: 'bonit')), ['Bonita']);
    });

    test('casa por brinco', () {
      expect(nomes(elegiveisInseminacao(lista, busca: '12')), ['Aurora']);
    });
  });
}
