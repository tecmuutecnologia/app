import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/features/propriedades/presentation/widgets/arrastar_para_excluir.dart';

/// Excluir propriedade arrastando o card para a esquerda — a mesma mecânica
/// do descarte de animal. Antes era preciso segurar o card, abrir a edição e
/// achar o botão de excluir no fim do formulário.
void main() {
  Future<List<int>> montar(WidgetTester tester) async {
    final excluidas = <int>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ArrastarParaExcluir(
            chave: 'p1',
            onExcluir: () async => excluidas.add(1),
            child: const SizedBox(
              height: 72,
              width: double.infinity,
              child: Text('Fazenda Boa Vista'),
            ),
          ),
        ),
      ),
    );
    return excluidas;
  }

  Future<void> arrastarParaEsquerda(WidgetTester tester) async {
    await tester.drag(find.text('Fazenda Boa Vista'), const Offset(-500, 0));
    await tester.pumpAndSettle();
  }

  testWidgets('arrastar para a esquerda pede confirmação', (tester) async {
    final excluidas = await montar(tester);

    await arrastarParaEsquerda(tester);

    expect(find.text('Excluir Propriedade'), findsOneWidget);
    expect(excluidas, isEmpty, reason: 'nada é excluído antes de confirmar');
  });

  testWidgets('confirmar exclui', (tester) async {
    final excluidas = await montar(tester);

    await arrastarParaEsquerda(tester);
    await tester.tap(find.widgetWithText(TextButton, 'Excluir'));
    await tester.pumpAndSettle();

    expect(excluidas, [1]);
  });

  testWidgets('cancelar não exclui e o card volta ao lugar', (tester) async {
    final excluidas = await montar(tester);

    await arrastarParaEsquerda(tester);
    await tester.tap(find.widgetWithText(TextButton, 'Cancelar'));
    await tester.pumpAndSettle();

    expect(excluidas, isEmpty);
    expect(find.text('Fazenda Boa Vista'), findsOneWidget);
  });

  testWidgets(
      'o card não some no arrasto: quem o tira da lista é a gravação no banco',
      (tester) async {
    await montar(tester);

    await arrastarParaEsquerda(tester);
    await tester.tap(find.widgetWithText(TextButton, 'Excluir'));
    await tester.pumpAndSettle();

    // Se o Dismissible removesse o card, ele piscaria de volta caso a
    // gravação falhasse; a lista observa o ObjectBox e o retira sozinha.
    expect(find.text('Fazenda Boa Vista'), findsOneWidget);
  });

  testWidgets('arrastar para a direita não faz nada', (tester) async {
    final excluidas = await montar(tester);

    await tester.drag(find.text('Fazenda Boa Vista'), const Offset(500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Excluir Propriedade'), findsNothing);
    expect(excluidas, isEmpty);
  });
}
