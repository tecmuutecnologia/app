import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/features/animais/application/animais_providers.dart';
import 'package:tecmuu/features/animais/presentation/animal_group_list_view.dart';

/// Valida o piloto de substituição de UMA aba por uma lista ÚNICA do ObjectBox:
/// AnimalGroupListView renderiza só o grupo, com ação de editar (offline), a
/// partir do provider sobrescrito.
void main() {
  const path = 'produtor/p1/propriedades/prop1';
  const args = (propriedadePath: path, grupo: 'Vacas');

  Future<void> pump(
    WidgetTester tester,
    List<AnimalEntity> animais, {
    void Function(String)? onTap,
    void Function(String)? onEdit,
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
              onEditAnimal: onEdit,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('renderiza os animais do grupo com brinco/status', (tester) async {
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
    expect(find.text('Brinco 12 • Prenha'), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('estado vazio menciona o grupo', (tester) async {
    await pump(tester, []);
    expect(find.text('Nenhum animal no grupo Vacas'), findsOneWidget);
  });

  testWidgets('botão de editar dispara onEditAnimal com o firestoreId',
      (tester) async {
    String? edited;
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
      onEdit: (id) => edited = id,
    );

    expect(find.byIcon(Icons.edit), findsOneWidget);
    await tester.tap(find.byIcon(Icons.edit));
    expect(edited, 'a1');
  });

  testWidgets('sem onEditAnimal não mostra botão de editar', (tester) async {
    await pump(tester, [
      AnimalEntity(firestoreId: 'a1', nomeAnimal: 'X', grupoAnimal: 'Vacas'),
    ]);
    expect(find.byIcon(Icons.edit), findsNothing);
  });
}
