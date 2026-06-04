import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/backend/objectbox/entities/index.dart';
import 'package:tecmuu/features/animais/application/animais_providers.dart';
import 'package:tecmuu/features/animais/presentation/animal_group_list_view.dart';

/// Valida o piloto de substituição de UMA aba: AnimalGroupListView renderiza
/// só os animais do grupo, a partir do provider (sobrescrito), e dispara o
/// callback de toque com o firestoreId.
void main() {
  const path = 'produtor/p1/propriedades/prop1';
  const args = (propriedadePath: path, grupo: 'Vacas');

  Future<void> pump(
    WidgetTester tester,
    List<AnimalEntity> animais, {
    void Function(String)? onTap,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          animaisByGrupoProvider(args).overrideWith((ref) => Stream.value(animais)),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: AnimalGroupListView(
              propriedadePath: path,
              grupo: 'Vacas',
              onTapAnimal: onTap,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('renderiza os animais do grupo', (tester) async {
    await pump(tester, [
      AnimalEntity(
        firestoreId: 'a1',
        nomeBrincoConcat: 'Mimosa #12',
        brincoAnimal: 12,
        status: 'Prenha',
        grupoAnimal: 'Vacas',
      ),
    ]);

    expect(find.text('Mimosa #12'), findsOneWidget);
    expect(find.text('Brinco 12'), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('estado vazio menciona o grupo', (tester) async {
    await pump(tester, []);
    expect(find.text('Nenhum animal no grupo Vacas'), findsOneWidget);
  });

  testWidgets('toque dispara onTapAnimal com o firestoreId', (tester) async {
    String? tapped;
    await pump(
      tester,
      [
        AnimalEntity(
          firestoreId: 'a1',
          nomeAnimal: 'Estrela',
          brincoAnimal: 7,
          grupoAnimal: 'Vacas',
        ),
      ],
      onTap: (id) => tapped = id,
    );

    await tester.tap(find.byType(ListTile));
    expect(tapped, 'a1');
  });
}
