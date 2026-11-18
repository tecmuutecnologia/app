import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/features/animais/application/animais_providers.dart';
import 'package:tecmuu/features/animais/application/ordenacao_animais.dart';
import 'package:tecmuu/features/animais/presentation/animal_group_list_view.dart';

/// Valida o piloto de substituição de UMA aba por uma lista ÚNICA do ObjectBox:
/// AnimalGroupListView renderiza só o grupo, com ação de editar (offline), a
/// partir do provider sobrescrito.
void main() {
  const path = 'produtor/p1/propriedades/prop1';

  Future<void> pump(
    WidgetTester tester,
    List<AnimalEntity> animais, {
    void Function(String)? onTap,
    void Function(String)? onEdit,
    OrdemAnimais ordem = OrdemAnimais.nome,
    bool crescente = true,
    String busca = '',
    bool permiteDescarte = false,
    void Function(String)? onDescartar,
    void Function(String)? onVender,
    bool mostrarBotaoVender = false,
    String grupo = 'Vacas',
  }) async {
    final args = (propriedadePath: path, grupo: grupo);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          animaisByGrupoProvider(args).overrideWith((ref) => Stream.value(animais)),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: AnimalGroupListView(
              propriedadePath: path,
              grupo: grupo,
              onTapAnimal: onTap,
              onEditAnimal: onEdit,
              ordem: ordem,
              crescente: crescente,
              busca: busca,
              permiteDescarte: permiteDescarte,
              onDescartar: onDescartar,
              onVender: onVender,
              mostrarBotaoVender: mostrarBotaoVender,
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
    // Reskin: cada animal é uma linha ListTile dentro de um AppCard.
    expect(find.byType(ListTile), findsOneWidget);
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

    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.edit_outlined));
    expect(edited, 'a1');
  });

  testWidgets('sem onEditAnimal não mostra botão de editar', (tester) async {
    await pump(tester, [
      AnimalEntity(firestoreId: 'a1', nomeAnimal: 'X', grupoAnimal: 'Vacas'),
    ]);
    expect(find.byIcon(Icons.edit_outlined), findsNothing);
  });

  /// Tres vacas fora de ordem, para provar que a lista nao sai na ordem bruta
  /// do ObjectBox.
  List<AnimalEntity> desordenadas() => [
        AnimalEntity(
            firestoreId: 'c', nomeAnimal: 'Carmem', brincoAnimal: 3, grupoAnimal: 'Vacas'),
        AnimalEntity(
            firestoreId: 'a', nomeAnimal: 'Aurora', brincoAnimal: 47, grupoAnimal: 'Vacas'),
        AnimalEntity(
            firestoreId: 'b', nomeAnimal: 'Bonita', brincoAnimal: 12, grupoAnimal: 'Vacas'),
      ];

  List<String> titulosNaTela(WidgetTester tester) => tester
      .widgetList<ListTile>(find.byType(ListTile))
      .map((t) => (t.title as Text).data!)
      .toList();

  testWidgets('ordena por nome A-Z quando a ordem e nome', (tester) async {
    await pump(tester, desordenadas(), ordem: OrdemAnimais.nome);

    expect(titulosNaTela(tester), ['Aurora', 'Bonita', 'Carmem']);
  });

  testWidgets('ordena por brinco crescente quando a ordem e brinco',
      (tester) async {
    await pump(tester, desordenadas(), ordem: OrdemAnimais.brinco);

    expect(titulosNaTela(tester), ['Carmem', 'Bonita', 'Aurora']);
  });

  testWidgets('busca filtra por nome dentro do grupo', (tester) async {
    await pump(tester, desordenadas(), busca: 'bonit');

    expect(titulosNaTela(tester), ['Bonita']);
  });

  testWidgets('busca filtra por brinco dentro do grupo', (tester) async {
    await pump(tester, desordenadas(), busca: '47');

    expect(titulosNaTela(tester), ['Aurora']);
  });

  testWidgets('busca sem resultado avisa que a busca nao achou, e nao que o '
      'grupo esta vazio', (tester) async {
    await pump(tester, desordenadas(), busca: 'zebu');

    expect(find.text('Nenhum animal no grupo Vacas'), findsNothing);
    expect(find.textContaining('Nenhum animal encontrado'), findsOneWidget);
  });

  testWidgets('repassa a direcao invertida para a lista', (tester) async {
    await pump(tester, desordenadas(),
        ordem: OrdemAnimais.nome, crescente: false);

    expect(titulosNaTela(tester), ['Carmem', 'Bonita', 'Aurora']);
  });

  group('arrasto vender | descartar', () {
    AnimalEntity animal(
            {String status = 'Vazia',
            String grupo = 'Vacas',
            String? tipoBaixa}) =>
        AnimalEntity(
            firestoreId: 'a1',
            nomeAnimal: 'Mimosa',
            brincoAnimal: 7,
            status: status,
            tipoBaixa: tipoBaixa,
            grupoAnimal: grupo);

    Future<void> arrastar(WidgetTester tester) async {
      await tester.drag(find.byType(Slidable), const Offset(-300, 0));
      await tester.pumpAndSettle();
    }

    testWidgets('sem permissao o card nem e arrastavel', (tester) async {
      await pump(tester, [animal()], permiteDescarte: false);

      expect(find.byType(Slidable), findsNothing);
    });

    testWidgets('arrastar revela Vender e Descartar e o card fica', (tester) async {
      await pump(tester, [animal()],
          permiteDescarte: true, onDescartar: (_) {}, onVender: (_) {});

      await arrastar(tester);

      expect(find.text('Vender'), findsOneWidget);
      expect(find.text('Descartar'), findsOneWidget);
      expect(find.text('Mimosa'), findsOneWidget);
    });

    testWidgets('tocar em Vender pede a venda com o firestoreId', (tester) async {
      String? pedido;
      await pump(tester, [animal()],
          permiteDescarte: true,
          onDescartar: (_) {},
          onVender: (id) => pedido = id);

      await arrastar(tester);
      await tester.tap(find.text('Vender'));
      await tester.pumpAndSettle();

      expect(pedido, 'a1');
    });

    testWidgets('tocar em Descartar pede o descarte com o firestoreId',
        (tester) async {
      String? pedido;
      await pump(tester, [animal()],
          permiteDescarte: true,
          onDescartar: (id) => pedido = id,
          onVender: (_) {});

      await arrastar(tester);
      await tester.tap(find.text('Descartar'));
      await tester.pumpAndSettle();

      expect(pedido, 'a1');
    });

    testWidgets('sêmen só oferece Descartar', (tester) async {
      await pump(tester, [animal(grupo: 'Sêmens')],
          grupo: 'Sêmens',
          permiteDescarte: true,
          onDescartar: (_) {},
          onVender: (_) {});

      await arrastar(tester);

      expect(find.text('Descartar'), findsOneWidget);
      expect(find.text('Vender'), findsNothing);
    });

    testWidgets('animal ja em baixa nao oferece o arrasto', (tester) async {
      await pump(tester, [animal(status: 'Descarte')],
          permiteDescarte: true, onDescartar: (_) {}, onVender: (_) {});

      expect(find.byType(Slidable), findsNothing);
    });

    testWidgets('botão Vender fixo aparece sem arrastar (bezerros)',
        (tester) async {
      String? pedido;
      await pump(tester, [animal(grupo: 'Bezerros')],
          grupo: 'Bezerros',
          permiteDescarte: true,
          onDescartar: (_) {},
          onVender: (id) => pedido = id,
          mostrarBotaoVender: true);

      expect(find.text('Vender'), findsOneWidget);
      await tester.tap(find.text('Vender'));
      await tester.pumpAndSettle();
      expect(pedido, 'a1');
    });

    testWidgets('sem mostrarBotaoVender não há botão fixo', (tester) async {
      await pump(tester, [animal()],
          permiteDescarte: true, onDescartar: (_) {}, onVender: (_) {});

      expect(find.text('Vender'), findsNothing);
    });
  });

  testWidgets('animal vendido aparece como "Vendido", não "Descarte"',
      (tester) async {
    await pump(tester, [
      AnimalEntity(
          firestoreId: 'a1',
          nomeAnimal: 'Mimosa',
          brincoAnimal: 7,
          status: 'Descarte',
          tipoBaixa: 'venda',
          grupoAnimal: 'Vacas'),
    ]);

    expect(find.textContaining('Vendido'), findsOneWidget);
    expect(find.textContaining('Descarte'), findsNothing);
  });
}
