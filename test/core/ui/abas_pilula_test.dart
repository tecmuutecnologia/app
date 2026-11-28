import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tecmuu/core/ui/abas_pilula.dart';

/// Na Roda da Reprodução as abas ficam ABAIXO da roda, dentro da rolagem da
/// página. Trocar de aba não pode rolar a página (a roda sumia da tela).
void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('trocar de aba não rola a página vertical', (tester) async {
    final vertical = ScrollController();
    late TabController abas;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: DefaultTabController(
          length: 6,
          child: Builder(builder: (context) {
            abas = DefaultTabController.of(context);
            return ListView(
              controller: vertical,
              children: [
                const SizedBox(height: 300, child: Text('roda')),
                AbasPilula(controller: abas, abas: [
                  for (var i = 0; i < 6; i++)
                    AbaPilula('Aba número $i', contagem: i),
                ]),
                const SizedBox(height: 2000),
              ],
            );
          }),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(vertical.offset, 0);

    await tester.tap(find.text('Aba número 2'));
    await tester.pumpAndSettle();
    abas.animateTo(5);
    await tester.pumpAndSettle();

    expect(abas.index, 5);
    expect(vertical.offset, 0);
  });
}
