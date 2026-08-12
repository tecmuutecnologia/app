import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/features/animais/application/animais_providers.dart';
import 'package:tecmuu/features/animais/presentation/animais_ordenados_view.dart';

/// `parentPath` nulo de proposito: assim o adapter nao monta DocumentReference
/// e o teste roda sem Firebase.
AnimalEntity animal(String nome, String status) =>
    AnimalEntity(nomeAnimal: nome, status: status);

void main() {
  testWidgets('reflete o novo status quando o ObjectBox emite de novo',
      (tester) async {
    final controle = StreamController<List<AnimalEntity>>();
    addTearDown(controle.close);

    await tester.pumpWidget(ProviderScope(
      overrides: [
        animaisTodosProvider.overrideWith((ref) => controle.stream),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: AnimaisOrdenadosView(
            comparador: (a, b) => 0,
            builder: (context, lista) => Text(
              lista.isEmpty ? 'vazio' : lista.first.status,
            ),
          ),
        ),
      ),
    ));

    controle.add([animal('novilha 3', 'Vazia')]);
    await tester.pump();
    expect(find.text('Vazia'), findsOneWidget);

    // A escrita da inseminacao: o ObjectBox emite o animal atualizado.
    controle.add([animal('novilha 3', 'Inseminada')]);
    await tester.pump();
    await tester.pump();

    expect(find.text('Inseminada'), findsOneWidget);
  });
}
