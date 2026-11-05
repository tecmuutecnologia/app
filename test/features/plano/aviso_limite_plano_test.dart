import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/features/plano/presentation/aviso_limite_plano.dart';

void main() {
  Future<List<bool>> pump(WidgetTester tester, int? restante) async {
    final resultados = <bool>[];
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              resultados.add(await mostrarAvisoSeSemVaga(
                context,
                restante: restante,
                titulo: 'Sem vaga',
                mensagem: 'Mensagem',
              ));
            },
            child: const Text('Go'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();
    return resultados;
  }

  testWidgets('restante 0 mostra o aviso e devolve false', (tester) async {
    final r = await pump(tester, 0);
    expect(find.text('Sem vaga'), findsOneWidget);
    expect(r, isEmpty);
    await tester.tap(find.text('Ok'));
    await tester.pumpAndSettle();
    expect(r, [false]);
    expect(find.text('Sem vaga'), findsNothing);
  });

  for (final restante in <int?>[5, null]) {
    testWidgets('restante $restante não mostra aviso e devolve true',
        (tester) async {
      final r = await pump(tester, restante);
      expect(find.text('Sem vaga'), findsNothing);
      expect(r, [true]);
    });
  }
}
