import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/features/animais/application/baixa_animal_service.dart';
import 'package:tecmuu/features/animais/presentation/widgets/vender_animal_widget.dart';

class _FakeService extends Fake implements BaixaAnimalService {
  final chamadas = <({String dt, double valor})>[];

  @override
  Future<void> vender({
    required AnimalEntity animal,
    required String propriedadePath,
    required String dtVenda,
    required double valor,
  }) async {
    chamadas.add((dt: dtVenda, valor: valor));
  }
}

void main() {
  late _FakeService service;

  Future<void> pump(WidgetTester tester) async {
    service = _FakeService();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: VenderAnimalWidget(
          animal: AnimalEntity(
              firestoreId: 'a1', nomeAnimal: 'Mimosa', grupoAnimal: 'Vacas'),
          propriedadePath: 'tecnico/t/propriedades/p',
          service: service,
        ),
      ),
    ));
    await tester.pump();
  }

  testWidgets('data vem preenchida com hoje', (tester) async {
    await pump(tester);
    final hoje = DateFormat('dd/MM/yyyy').format(DateTime.now());
    expect(find.widgetWithText(TextFormField, hoje), findsOneWidget);
  });

  testWidgets('salvar sem valor mostra erro e não vende', (tester) async {
    await pump(tester);
    await tester.tap(find.text('Salvar'));
    await tester.pump();
    expect(find.text('Informe o valor da venda'), findsOneWidget);
    expect(service.chamadas, isEmpty);
  });

  testWidgets('salvar com data futura mostra erro e não vende', (tester) async {
    await pump(tester);
    await tester.enterText(find.byKey(const Key('venda-data')), '01/01/2999');
    await tester.enterText(find.byKey(const Key('venda-valor')), '1500');
    await tester.tap(find.text('Salvar'));
    await tester.pump();
    expect(find.text('A data da venda não pode ser no futuro'), findsOneWidget);
    expect(service.chamadas, isEmpty);
  });

  testWidgets('salvar válido vende uma vez com data e valor', (tester) async {
    await pump(tester);
    final ontem = DateFormat('dd/MM/yyyy')
        .format(DateTime.now().subtract(const Duration(days: 1)));
    await tester.enterText(find.byKey(const Key('venda-data')), ontem);
    await tester.enterText(find.byKey(const Key('venda-valor')), '1.500,50');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(service.chamadas, hasLength(1));
    expect(service.chamadas.single.dt, ontem);
    expect(service.chamadas.single.valor, 1500.5);
  });
}
