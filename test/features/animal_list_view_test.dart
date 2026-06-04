import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/backend/objectbox/entities/index.dart';
import 'package:tecmuu/features/animais/application/animais_providers.dart';
import 'package:tecmuu/features/animais/presentation/animal_list_view.dart';

/// Valida o piloto de migração de LEITURA: o AnimalListView renderiza a lista
/// vinda do provider (sobrescrito no teste), sem ObjectBox/Firestore reais.
void main() {
  const path = 'produtor/p1/propriedades/prop1';

  Future<void> pump(
    WidgetTester tester,
    List<AnimalEntity> animais,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          animaisByPropriedadeProvider(path)
              .overrideWith((ref) => Stream.value(animais)),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: AnimalListView(propriedadePath: path),
          ),
        ),
      ),
    );
    await tester.pump(); // deixa o stream emitir
  }

  testWidgets('renderiza os animais da propriedade', (tester) async {
    await pump(tester, [
      AnimalEntity(
        nomeBrincoConcat: 'Mimosa #12',
        brincoAnimal: 12,
        status: 'Prenha',
      ),
      AnimalEntity(
        nomeAnimal: 'Estrela',
        brincoAnimal: 7,
        status: 'Lactação',
      ),
    ]);

    expect(find.text('Mimosa #12'), findsOneWidget);
    expect(find.text('Estrela'), findsOneWidget);
    expect(find.text('Brinco 12'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(2));
  });

  testWidgets('mostra estado vazio quando não há animais', (tester) async {
    await pump(tester, []);
    expect(find.text('Nenhum animal cadastrado'), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });
}
