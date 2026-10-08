import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/features/animais/application/ordenacao_animais.dart';
import 'package:tecmuu/features/animais/presentation/widgets/seletor_ordem_animais.dart';

void main() {
  /// Registra o que o seletor pediu, para o teste afirmar sobre a intencao e
  /// nao sobre pintura de pixel.
  late List<String> pedidos;

  Future<void> pump(
    WidgetTester tester, {
    required OrdemAnimais ordem,
    bool crescente = true,
  }) async {
    pedidos = [];
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SeletorOrdemAnimais(
          ordem: ordem,
          crescente: crescente,
          onSelecionar: (nova) => pedidos.add('selecionar:${nova.name}'),
          onInverter: () => pedidos.add('inverter'),
        ),
      ),
    ));
  }

  testWidgets('mostra um botao para cada criterio', (tester) async {
    await pump(tester, ordem: OrdemAnimais.nome);

    expect(find.text('Nome'), findsOneWidget);
    expect(find.text('Brinco'), findsOneWidget);
  });

  testWidgets('tocar no criterio inativo troca o criterio', (tester) async {
    await pump(tester, ordem: OrdemAnimais.nome);

    await tester.tap(find.text('Brinco'));

    expect(pedidos, ['selecionar:brinco']);
  });

  testWidgets('tocar no criterio ja ativo inverte a direcao', (tester) async {
    await pump(tester, ordem: OrdemAnimais.nome);

    await tester.tap(find.text('Nome'));

    expect(pedidos, ['inverter']);
  });

  testWidgets('a seta do criterio ativo acompanha a direcao', (tester) async {
    await pump(tester, ordem: OrdemAnimais.nome, crescente: true);
    expect(find.byIcon(Icons.arrow_downward_rounded), findsOneWidget);
    expect(find.byIcon(Icons.arrow_upward_rounded), findsNothing);

    await pump(tester, ordem: OrdemAnimais.nome, crescente: false);
    expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
    expect(find.byIcon(Icons.arrow_downward_rounded), findsNothing);
  });

  testWidgets('o criterio inativo nao mostra seta', (tester) async {
    await pump(tester, ordem: OrdemAnimais.brinco, crescente: true);

    // Uma seta so na tela: a do criterio ativo (Brinco).
    expect(find.byIcon(Icons.arrow_downward_rounded), findsOneWidget);
  });

  testWidgets('o criterio ativo se anuncia como selecionado', (tester) async {
    await pump(tester, ordem: OrdemAnimais.brinco);

    expect(tester.getSemantics(find.text('Brinco')).hasFlag(SemanticsFlag.isSelected),
        isTrue);
    expect(tester.getSemantics(find.text('Nome')).hasFlag(SemanticsFlag.isSelected),
        isFalse);
  });
}
