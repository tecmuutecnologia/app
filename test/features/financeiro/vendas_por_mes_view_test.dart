import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/features/financeiro/presentation/widgets/vendas_por_mes_view.dart';

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR'));

  Future<void> pump(WidgetTester tester, List<VendaAnimalEntity> vendas,
      {VoidCallback? aoAbrir}) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: VendasPorMesView(
          propriedadePath: 'tecnico/t/propriedades/p',
          vendas: Stream.value(vendas),
          aoAbrir: aoAbrir ?? () {},
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  VendaAnimalEntity venda(String nome, String dt, double valor,
          {bool excluida = false}) =>
      VendaAnimalEntity(
          firestoreId: nome,
          nomeAnimal: nome,
          dtVenda: dt,
          valorVenda: valor,
          isDeleted: excluida);

  testWidgets('agrupa por mês com total formatado', (tester) async {
    await pump(tester, [
      venda('Mimosa', '05/11/2026', 1000),
      venda('Estrela', '10/11/2026', 234.56),
      venda('Boneca', '20/10/2026', 500),
    ]);

    expect(find.text('Novembro 2026'), findsOneWidget);
    expect(find.text('R\$ 1.234,56'), findsOneWidget);
    expect(find.text('Outubro 2026'), findsOneWidget);
    expect(find.text('Mimosa'), findsOneWidget);
    expect(find.text('10/11/2026'), findsOneWidget);
  });

  testWidgets('venda desfeita (excluída) não aparece', (tester) async {
    await pump(tester, [
      venda('Mimosa', '05/11/2026', 1000),
      venda('Fantasma', '06/11/2026', 99, excluida: true),
    ]);

    expect(find.text('Fantasma'), findsNothing);
  });

  testWidgets('sem vendas mostra o estado vazio', (tester) async {
    await pump(tester, []);
    expect(find.text('Nenhuma venda registrada'), findsOneWidget);
  });

  testWidgets('ao abrir busca as vendas uma vez', (tester) async {
    var chamadas = 0;
    await pump(tester, [], aoAbrir: () => chamadas++);
    expect(chamadas, 1);
  });
}
