import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/features/inseminacoes/application/inseminacao_lote.dart';

void main() {
  group('comInseminacaoMaisRecente', () {
    const a = AlvoInseminacao(nome: 'Darth', dtUltimaInseminacao: '13/10/2026');
    const b = AlvoInseminacao(nome: 'Tetê', dtUltimaInseminacao: '');
    const c = AlvoInseminacao(nome: '21', dtUltimaInseminacao: '20/10/2026');

    test('lista só quem já tem inseminação depois da data nova', () {
      expect(comInseminacaoMaisRecente([a, b, c], '15/10/2026'), [c]);
    });

    test('mesma data não conta como mais antiga', () {
      expect(comInseminacaoMaisRecente([a], '13/10/2026'), isEmpty);
    });

    test('sem inseminação anterior nunca entra', () {
      expect(comInseminacaoMaisRecente([b], '01/01/2020'), isEmpty);
    });
  });

  group('resumoAlvos', () {
    test('um animal: o título dele', () {
      expect(resumoAlvos(const [AlvoInseminacao(nome: 'Darth')]), 'Darth');
    });

    test('vários: quantidade e nomes', () {
      expect(
          resumoAlvos(const [
            AlvoInseminacao(nome: 'Darth'),
            AlvoInseminacao(nome: 'Tetê'),
            AlvoInseminacao(nome: '21'),
          ]),
          '3 animais: Darth, Tetê, 21');
    });

    test('muitos: corta a lista e diz quantos faltam', () {
      final alvos = [
        for (var i = 1; i <= 7; i++) AlvoInseminacao(nome: 'V$i'),
      ];
      expect(resumoAlvos(alvos), '7 animais: V1, V2, V3, V4, V5 e mais 2');
    });
  });
}
