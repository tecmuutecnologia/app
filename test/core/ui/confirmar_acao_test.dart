import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/ui/app_card.dart';
import 'package:tecmuu/core/ui/confirmar_acao.dart';

/// Confirmação no padrão visual do app. Nasceu do descarte em "Animais em
/// secagem": confirmar (ou cancelar) fechava a TELA junto com o diálogo, e o
/// técnico voltava ao menu a cada vaca eliminada.
void main() {
  Future<List<bool>> montar(WidgetTester tester,
      {bool perigosa = false}) async {
    final respostas = <bool>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Column(
              children: [
                const Text('Tela de origem'),
                TextButton(
                  onPressed: () async => respostas.add(await confirmarAcao(
                    context,
                    titulo: 'Eliminar o animal?',
                    mensagem: 'Essa ação é irreversível.',
                    textoConfirmar: 'Eliminar',
                    perigosa: perigosa,
                  )),
                  child: const Text('abrir'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    return respostas;
  }

  testWidgets('confirmar devolve true e a tela de origem continua',
      (tester) async {
    final respostas = await montar(tester);

    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();

    expect(respostas, [true]);
    expect(find.text('Tela de origem'), findsOneWidget);
    expect(find.text('Eliminar o animal?'), findsNothing);
  });

  testWidgets('cancelar devolve false e a tela de origem continua',
      (tester) async {
    final respostas = await montar(tester);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(respostas, [false]);
    expect(find.text('Tela de origem'), findsOneWidget);
  });

  testWidgets('tocar fora devolve false', (tester) async {
    final respostas = await montar(tester);

    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    expect(respostas, [false]);
    expect(find.text('Tela de origem'), findsOneWidget);
  });

  testWidgets('ação perigosa confirma em vermelho', (tester) async {
    await montar(tester, perigosa: true);

    final botao = tester
        .widget<FilledButton>(find.widgetWithText(FilledButton, 'Eliminar'));
    expect(botao.style?.backgroundColor?.resolve({}), AppTokens.negativo);
  });

  testWidgets('ação comum confirma na cor da marca', (tester) async {
    await montar(tester);

    final botao = tester
        .widget<FilledButton>(find.widgetWithText(FilledButton, 'Eliminar'));
    expect(botao.style?.backgroundColor?.resolve({}), AppTokens.brand);
  });
}
