import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/domain/animais/ordenacao_animal.dart';

/// Atalho para reduzir ruído nos testes.
int cmp(int? ba, String? na, int? bb, String? nb) =>
    compararAnimais(brincoA: ba, nomeA: na, brincoB: bb, nomeB: nb);

void main() {
  group('temBrinco', () {
    test('numero positivo e brinco', () => expect(temBrinco(429), true));
    test('nulo nao e brinco', () => expect(temBrinco(null), false));
    test('zero nao e brinco — e o default de quem nunca recebeu um',
        () => expect(temBrinco(0), false));
    test('menos um nao e brinco — sentinela do FlutterFlow',
        () => expect(temBrinco(-1), false));
  });

  group('compararAnimais com brinco nos dois', () {
    test('ordena numericamente, nao como texto', () {
      // O caso reportado: como texto, 390 viria antes de 428.
      final brincos = [429, 428, 390, 430];
      brincos.sort((a, b) => cmp(a, null, b, null));
      expect(brincos, [390, 428, 429, 430]);
    });

    test('brinco maior vem depois', () => expect(cmp(430, null, 429, null), 1));
    test('brinco menor vem antes', () => expect(cmp(390, null, 428, null), -1));

    test('brincos iguais desempatam pelo nome', () {
      expect(cmp(429, 'Zebu', 429, 'Alfa'), greaterThan(0));
      expect(cmp(429, 'Alfa', 429, 'Zebu'), lessThan(0));
    });
  });

  group('compararAnimais com brinco em apenas um', () {
    test('quem tem brinco vem primeiro', () {
      expect(cmp(429, null, null, 'Mimosa'), lessThan(0));
      expect(cmp(null, 'Mimosa', 429, null), greaterThan(0));
    });

    test('zero conta como sem brinco', () {
      expect(cmp(429, null, 0, 'Mimosa'), lessThan(0));
    });

    test('menos um conta como sem brinco', () {
      expect(cmp(429, null, -1, 'Mimosa'), lessThan(0));
    });
  });

  group('compararAnimais sem brinco em nenhum', () {
    test('ordena por nome', () {
      expect(cmp(null, 'Alfa', null, 'Zebu'), lessThan(0));
      expect(cmp(null, 'Zebu', null, 'Alfa'), greaterThan(0));
    });

    test('ignora maiuscula/minuscula', () {
      expect(cmp(null, 'alfa', null, 'ALFA'), 0);
      expect(cmp(null, 'zebu', null, 'Alfa'), greaterThan(0));
    });

    test('nome nulo vira vazio e vai para o comeco', () {
      expect(cmp(null, null, null, 'Alfa'), lessThan(0));
    });

    test('dois sem nome sao equivalentes', () {
      expect(cmp(null, null, null, null), 0);
    });
  });

  group('ordenacao completa de uma lista', () {
    test('brincados em ordem numerica, depois os sem brinco por nome', () {
      final animais = <({int? brinco, String? nome})>[
        (brinco: 429, nome: 'D'),
        (brinco: null, nome: 'Zebu'),
        (brinco: 390, nome: 'B'),
        (brinco: 0, nome: 'Alfa'),
        (brinco: 430, nome: 'C'),
        (brinco: 428, nome: 'A'),
      ];

      animais.sort((a, b) => compararAnimais(
            brincoA: a.brinco,
            nomeA: a.nome,
            brincoB: b.brinco,
            nomeB: b.nome,
          ));

      // Projeta para o identificador visivel: brinco quando ha um, senao nome.
      // `?? ` nao serve — brinco 0 nao e nulo, mas tambem nao e brinco.
      expect(
        animais
            .map((a) => temBrinco(a.brinco) ? a.brinco : a.nome)
            .toList(),
        [390, 428, 429, 430, 'Alfa', 'Zebu'],
      );
    });
  });
}
