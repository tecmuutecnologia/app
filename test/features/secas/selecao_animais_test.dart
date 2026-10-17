import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/features/secas/application/selecao_animais.dart';

/// Seleção da aba "Descarte": o técnico marca vários animais e elimina ou
/// restaura todos de uma vez, em vez de repetir a ação card por card.
void main() {
  test('começa desligada e vazia', () {
    final s = SelecaoAnimais();

    expect(s.ativa, isFalse);
    expect(s.quantidade, 0);
  });

  test('entrar com um animal já o deixa marcado', () {
    final s = SelecaoAnimais()..entrar(comChave: 'A1');

    expect(s.ativa, isTrue);
    expect(s.contem('A1'), isTrue);
  });

  test('alternar marca e desmarca', () {
    final s = SelecaoAnimais()..entrar();

    s.alternar('A1');
    expect(s.contem('A1'), isTrue);
    s.alternar('A1');
    expect(s.contem('A1'), isFalse);
  });

  test('selecionar todos marca os visíveis e alterna de volta', () {
    final s = SelecaoAnimais()..entrar();

    s.alternarTodos(['A1', 'A2', 'A3']);
    expect(s.quantidade, 3);
    expect(s.todosMarcados(['A1', 'A2', 'A3']), isTrue);

    s.alternarTodos(['A1', 'A2', 'A3']);
    expect(s.quantidade, 0);
  });

  test('selecionar todos com busca ativa não desmarca quem está escondido', () {
    final s = SelecaoAnimais()
      ..entrar(comChave: 'A9')
      ..alternarTodos(['A1', 'A2']);

    expect(s.chaves, unorderedEquals(['A9', 'A1', 'A2']));

    s.alternarTodos(['A1', 'A2']);
    expect(s.chaves, ['A9']);
  });

  test('lista vazia nunca conta como todos marcados', () {
    final s = SelecaoAnimais()..entrar();

    expect(s.todosMarcados([]), isFalse);
  });

  test('manterApenas descarta quem saiu da aba', () {
    final s = SelecaoAnimais()
      ..entrar()
      ..alternarTodos(['A1', 'A2', 'A3']);

    s.manterApenas(['A2', 'A3', 'A4']);

    expect(s.chaves, unorderedEquals(['A2', 'A3']));
  });

  test('sair desliga e limpa', () {
    final s = SelecaoAnimais()..entrar(comChave: 'A1');

    s.sair();

    expect(s.ativa, isFalse);
    expect(s.quantidade, 0);
  });

  test('rótulo no singular e no plural', () {
    expect(rotuloAnimais(1), '1 animal');
    expect(rotuloAnimais(7), '7 animais');
  });
}
