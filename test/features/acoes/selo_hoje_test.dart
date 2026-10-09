import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/features/shared/widgets/selo_hoje.dart';

void main() {
  final agora = DateTime(2026, 10, 8);

  Future<void> pump(WidgetTester tester, String? data) => tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SeloHoje(dtUltimaAcao: data, agora: agora)),
        ),
      );

  testWidgets('acao de hoje mostra o selo', (tester) async {
    await pump(tester, '08/10/2026');

    expect(find.text('Hoje'), findsOneWidget);
  });

  testWidgets('acao de ontem nao ocupa espaco nenhum', (tester) async {
    await pump(tester, '07/10/2026');

    expect(find.text('Hoje'), findsNothing);
    // Encolhe em vez de desenhar vazio: quem chama nao precisa de `if`.
    expect(tester.getSize(find.byType(SeloHoje)), Size.zero);
  });

  testWidgets('sem data nao mostra', (tester) async {
    await pump(tester, null);
    expect(find.text('Hoje'), findsNothing);
  });

  testWidgets('data malformada nao mostra e nao quebra', (tester) async {
    await pump(tester, 'xx/yy/zzzz');

    expect(find.text('Hoje'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
