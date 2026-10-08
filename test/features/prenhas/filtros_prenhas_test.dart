import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/schema/structs/animais_produtores_struct.dart';
import 'package:tecmuu/features/prenhas/application/filtros_prenhas.dart';

AnimaisProdutoresStruct animal({
  String nome = 'Mimosa',
  int brinco = 7,
  String? status,
  String? grupo,
  DateTime? comparar,
}) =>
    AnimaisProdutoresStruct(
      nomeAnimal: nome,
      brincoAnimal: brinco,
      status: status,
      grupoAnimal: grupo,
      compararDtUltimaInseminacao: comparar,
    );

final dataReal = DateTime(2026, 5, 26);

List<String> nomes(List<AnimaisProdutoresStruct> l) =>
    l.map((e) => e.nomeAnimal).toList();

void main() {
  test('mantem vaca e novilha prenhas', () {
    final lista = [
      animal(nome: 'Vaca', grupo: 'Vacas', status: 'Prenha', comparar: dataReal),
      animal(
          nome: 'Novilha',
          grupo: 'Novilhas',
          status: 'Prenha',
          comparar: dataReal),
    ];

    expect(nomes(prenhasVisiveis(lista)), ['Vaca', 'Novilha']);
  });

  test('descarta quem nao esta prenha', () {
    final lista = [
      animal(
          nome: 'Prenha', grupo: 'Vacas', status: 'Prenha', comparar: dataReal),
      animal(
          nome: 'Vazia', grupo: 'Vacas', status: 'Vazia', comparar: dataReal),
    ];

    expect(nomes(prenhasVisiveis(lista)), ['Prenha']);
  });

  test('descarta grupo que nao e vaca nem novilha', () {
    final lista = [
      animal(
          nome: 'Bezerra',
          grupo: 'Bezerras',
          status: 'Prenha',
          comparar: dataReal),
    ];

    expect(prenhasVisiveis(lista), isEmpty);
  });

  test('descarta quem tem a data-sentinela 31/12/2050', () {
    final lista = [
      animal(
          nome: 'Sentinela',
          grupo: 'Vacas',
          status: 'Prenha',
          comparar: DateTime(2050, 12, 31)),
    ];

    expect(prenhasVisiveis(lista), isEmpty);
  });

  test('animal sem data fica de fora: o struct devolve a sentinela como '
      'default', () {
    // `compararDtUltimaInseminacao` nao e nulavel na leitura: o struct devolve
    // 31/12/2050 quando o campo esta vazio. Era assim que a tela ja se
    // comportava — o predicado antigo formatava a data e comparava com a
    // string '31/12/2050'.
    final lista = [animal(nome: 'SemData', grupo: 'Vacas', status: 'Prenha')];

    expect(prenhasVisiveis(lista), isEmpty);
  });

  group('busca', () {
    final lista = [
      animal(
          nome: 'Bonita',
          brinco: 47,
          grupo: 'Vacas',
          status: 'Prenha',
          comparar: dataReal),
      animal(
          nome: 'Aurora',
          brinco: 12,
          grupo: 'Vacas',
          status: 'Prenha',
          comparar: dataReal),
    ];

    test('vazia devolve todas', () {
      expect(prenhasVisiveis(lista, busca: ''), hasLength(2));
    });

    test('casa por nome', () {
      expect(nomes(prenhasVisiveis(lista, busca: 'bonit')), ['Bonita']);
    });

    test('casa por brinco', () {
      expect(nomes(prenhasVisiveis(lista, busca: '12')), ['Aurora']);
    });
  });
}
