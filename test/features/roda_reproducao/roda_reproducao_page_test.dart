import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tecmuu/data/objectbox/entities/animal_entity.dart';
import 'package:tecmuu/features/roda_reproducao/presentation/pages/roda_reproducao_page.dart';

final hoje = DateTime(2026, 11, 24);
String fmt(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
String ha(int dias) => fmt(hoje.subtract(Duration(days: dias)));
String daqui(int dias) => fmt(hoje.add(Duration(days: dias)));

int _id = 0;
AnimalEntity vaca(String nome, int brinco,
        {String status = 'Vazia',
        String grupo = 'Vacas',
        String? parto,
        String? ia,
        String? previsto}) =>
    AnimalEntity(
      nomeAnimal: nome,
      brincoAnimal: brinco,
      status: status,
      grupoAnimal: grupo,
      dtUltimoParto: parto,
      dtUltimaInseminacao: ia,
      dtPartoPrevisto: previsto,
    )..id = ++_id;

final rebanho = [
  vaca('Mimosa', 1, parto: ha(10)),
  vaca('Estrela', 2, status: 'Seca', ia: ha(277), previsto: daqui(3)),
  vaca('Cereja', 3, status: 'Inseminada', ia: ha(20), parto: ha(120)),
  vaca('Bonita', 4, status: 'Prenha', previsto: daqui(100)),
  vaca('Princesa', 5, parto: ha(100)),
  vaca('Bezerrinha', 6, grupo: 'Bezerras'),
];

Future<void> montar(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1179, 2556);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(
    home: RodaReproducaoPage(
      uidPropriedade: null,
      nomePropriedade: 'teste100',
      uidTecnico: null,
      emailPropriedade: 'x@y.z',
      visitaPresencial: false,
      diasDg: '30',
      carregarAnimais: () => rebanho,
      agora: hoje,
    ),
  ));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('contadores por estado e abas da semana', (tester) async {
    await montar(tester);
    expect(find.text('Roda da Reprodução'), findsOneWidget);
    // Pós-parto 2 (Mimosa, Princesa), Cobertura 1, Prenhe 1, Seca 1.
    expect(find.byKey(const ValueKey('contador-posParto-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('contador-cobertura-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('contador-prenhe-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('contador-seca-1')), findsOneWidget);
    // Aba inicial: Parir → Estrela.
    expect(find.text('Estrela - 2'), findsOneWidget);
    expect(find.text('Bezerrinha - 6'), findsNothing);
  });

  testWidgets('aba Atrasadas mostra a vaca sem cobertura', (tester) async {
    await montar(tester);
    await tester.ensureVisible(find.text('Atrasadas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Atrasadas'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Princesa - 5'), 200,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('Princesa - 5'), findsOneWidget);
    expect(find.textContaining('Sem cobertura há 100 dias'), findsOneWidget);
  });

  testWidgets('tocar no contador filtra pela faixa e "Limpar" volta',
      (tester) async {
    await montar(tester);
    await tester.tap(find.byKey(const ValueKey('contador-prenhe-1')));
    await tester.pumpAndSettle();
    expect(find.text('Faixa Prenhe'), findsOneWidget);
    // Bonita está no dia 265 (faixa prenhe).
    expect(find.text('Bonita - 4'), findsOneWidget);
    await tester.tap(find.text('Limpar'));
    await tester.pumpAndSettle();
    expect(find.text('Faixa Prenhe'), findsNothing);
  });

  testWidgets('+30 dias mostra o aviso de simulação', (tester) async {
    await montar(tester);
    expect(find.textContaining('Simulação'), findsNothing);
    await tester.tap(find.text('+30 dias'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Simulação'), findsOneWidget);
  });
}
