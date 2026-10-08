import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/features/animais/application/ordenacao_animais.dart';

/// `parentPath` nulo de proposito: a regra e pura e nao toca Firestore.
AnimalEntity animal(String? nome, int brinco, {String? concat}) =>
    AnimalEntity(
        nomeAnimal: nome, brincoAnimal: brinco, nomeBrincoConcat: concat);

List<String?> nomes(List<AnimalEntity> lista) =>
    lista.map((a) => a.nomeAnimal).toList();

List<int> brincos(List<AnimalEntity> lista) =>
    lista.map((a) => a.brincoAnimal).toList();

void main() {
  group('ordem por nome', () {
    test('ordena de A-Z ignorando maiuscula', () {
      final lista = [animal('carmem', 1), animal('Aurora', 2), animal('bonita', 3)];

      final resultado =
          aplicarBuscaEOrdem(lista, ordem: OrdemAnimais.nome, busca: '');

      expect(nomes(resultado), ['Aurora', 'bonita', 'carmem']);
    });

    test('trata acento como a letra base, nao como letra depois do Z', () {
      final lista = [animal('Zulmira', 1), animal('Ângela', 2), animal('Beatriz', 3)];

      final resultado =
          aplicarBuscaEOrdem(lista, ordem: OrdemAnimais.nome, busca: '');

      expect(nomes(resultado), ['Ângela', 'Beatriz', 'Zulmira']);
    });

    test('manda animal sem nome para o fim, nao para o topo', () {
      final lista = [animal(null, 1), animal('Aurora', 2), animal('', 3)];

      final resultado =
          aplicarBuscaEOrdem(lista, ordem: OrdemAnimais.nome, busca: '');

      expect(nomes(resultado).first, 'Aurora');
      expect(nomes(resultado).sublist(1), everyElement(anyOf(isNull, isEmpty)));
    });

    test('desempata nome igual pelo brinco', () {
      final lista = [animal('Bonita', 47), animal('Bonita', 3)];

      final resultado =
          aplicarBuscaEOrdem(lista, ordem: OrdemAnimais.nome, busca: '');

      expect(brincos(resultado), [3, 47]);
    });
  });

  group('ordem por brinco', () {
    test('ordena numericamente, nao como texto', () {
      final lista = [animal('a', 47), animal('b', 3), animal('c', 12)];

      final resultado =
          aplicarBuscaEOrdem(lista, ordem: OrdemAnimais.brinco, busca: '');

      expect(brincos(resultado), [3, 12, 47]);
    });

    test('desempata brinco igual pelo nome', () {
      final lista = [animal('Bonita', 7), animal('Aurora', 7)];

      final resultado =
          aplicarBuscaEOrdem(lista, ordem: OrdemAnimais.brinco, busca: '');

      expect(nomes(resultado), ['Aurora', 'Bonita']);
    });
  });

  group('animal sem brinco', () {
    test('brinco 0 nao disputa o topo da ordem por brinco', () {
      final lista = [animal('Sem brinco', 0), animal('Aurora', 12)];

      final resultado =
          aplicarBuscaEOrdem(lista, ordem: OrdemAnimais.brinco, busca: '');

      expect(nomes(resultado), ['Aurora', 'Sem brinco']);
    });

    test('sentinela -1 do FlutterFlow tambem vai para o fim', () {
      final lista = [animal('Sentinela', -1), animal('Aurora', 12)];

      final resultado =
          aplicarBuscaEOrdem(lista, ordem: OrdemAnimais.brinco, busca: '');

      expect(nomes(resultado), ['Aurora', 'Sentinela']);
    });
  });

  group('ordena pelo texto que o card mostra', () {
    test('usa o nomeBrincoConcat quando ele existe, nao o nomeAnimal cru', () {
      // O card mostra "001" (concat) para um animal cujo nomeAnimal e "1".
      // Ordenar pelo nomeAnimal joga ele entre "004" e "22" — a lista parece
      // fora de ordem para quem olha a tela.
      final lista = [
        animal('002', 2, concat: '002 - 2'),
        animal('004', 4, concat: '004 - 4'),
        animal('1', 1, concat: '001'),
        animal('22', 22, concat: '22'),
      ];

      final resultado =
          aplicarBuscaEOrdem(lista, ordem: OrdemAnimais.nome, busca: '');

      expect(resultado.map((a) => a.nomeBrincoConcat).toList(),
          ['001', '002 - 2', '004 - 4', '22']);
    });

    test('busca encontra pelo texto exibido, nao so pelo nomeAnimal', () {
      final lista = [
        animal('1', 1, concat: '001'),
        animal('2', 2, concat: '002 - 2'),
      ];

      final resultado =
          aplicarBuscaEOrdem(lista, ordem: OrdemAnimais.nome, busca: '001');

      expect(resultado.map((a) => a.nomeBrincoConcat).toList(), ['001']);
    });
  });

  group('ordem invertida', () {
    test('nome decrescente vai de Z a A', () {
      final lista = [animal('Aurora', 1), animal('Carmem', 2), animal('Bonita', 3)];

      final resultado = aplicarBuscaEOrdem(lista,
          ordem: OrdemAnimais.nome, crescente: false, busca: '');

      expect(nomes(resultado), ['Carmem', 'Bonita', 'Aurora']);
    });

    test('animal sem nome continua no fim mesmo invertido', () {
      // Sem nome nao e "o ultimo do alfabeto": ele esta fora da ordem. Inverter
      // a lista nao deve promove-lo ao topo.
      final lista = [animal('Aurora', 1), animal(null, 2), animal('Bonita', 3)];

      final resultado = aplicarBuscaEOrdem(lista,
          ordem: OrdemAnimais.nome, crescente: false, busca: '');

      expect(nomes(resultado), ['Bonita', 'Aurora', null]);
    });

    test('brinco decrescente comeca pelo maior', () {
      final lista = [animal('a', 3), animal('b', 47), animal('c', 12)];

      final resultado = aplicarBuscaEOrdem(lista,
          ordem: OrdemAnimais.brinco, crescente: false, busca: '');

      expect(brincos(resultado), [47, 12, 3]);
    });

    test('animal sem brinco continua no fim mesmo invertido', () {
      final lista = [animal('a', 12), animal('sem', -1), animal('b', 47)];

      final resultado = aplicarBuscaEOrdem(lista,
          ordem: OrdemAnimais.brinco, crescente: false, busca: '');

      expect(brincos(resultado), [47, 12, -1]);
    });
  });

  group('busca', () {
    test('busca vazia devolve a lista inteira', () {
      final lista = [animal('Aurora', 1), animal('Bonita', 2)];

      final resultado =
          aplicarBuscaEOrdem(lista, ordem: OrdemAnimais.nome, busca: '');

      expect(resultado, hasLength(2));
    });

    test('filtra por parte do nome ignorando maiuscula', () {
      final lista = [animal('Aurora', 1), animal('Bonita', 2), animal('Bonitinha', 3)];

      final resultado =
          aplicarBuscaEOrdem(lista, ordem: OrdemAnimais.nome, busca: 'bonit');

      expect(nomes(resultado), ['Bonita', 'Bonitinha']);
    });

    test('filtra por parte do nome ignorando acento digitado ou gravado', () {
      final lista = [animal('Ângela', 1), animal('Bonita', 2)];

      final resultado =
          aplicarBuscaEOrdem(lista, ordem: OrdemAnimais.nome, busca: 'angela');

      expect(nomes(resultado), ['Ângela']);
    });

    test('filtra por brinco', () {
      final lista = [animal('Aurora', 12), animal('Bonita', 47)];

      final resultado =
          aplicarBuscaEOrdem(lista, ordem: OrdemAnimais.nome, busca: '47');

      expect(nomes(resultado), ['Bonita']);
    });

    test('ignora espaco em volta do termo digitado', () {
      final lista = [animal('Aurora', 12), animal('Bonita', 47)];

      final resultado =
          aplicarBuscaEOrdem(lista, ordem: OrdemAnimais.nome, busca: '  aurora  ');

      expect(nomes(resultado), ['Aurora']);
    });

    test('devolve lista vazia quando nada casa', () {
      final lista = [animal('Aurora', 12)];

      final resultado =
          aplicarBuscaEOrdem(lista, ordem: OrdemAnimais.nome, busca: 'zebu');

      expect(resultado, isEmpty);
    });
  });
}
