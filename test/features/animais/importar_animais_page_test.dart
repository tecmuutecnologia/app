import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/features/animais/application/importar_animais.dart';
import 'package:tecmuu/features/animais/presentation/widgets/resultado_importacao_view.dart';

void main() {
  testWidgets('mostra importados, não importados e o motivo de cada linha',
      (tester) async {
    var voltou = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ResultadoImportacaoView(
          resultado: const ResultadoImportacao(importados: 3, recusadas: [
            Recusa(3, 'Estrela', 'raça não informada'),
            Recusa(5, 'Mimosa - 12', 'já cadastrado'),
          ]),
          aoVoltar: () => voltou = true,
        ),
      ),
    ));

    expect(find.text('3 importados'), findsOneWidget);
    expect(find.text('2 não importados'), findsOneWidget);
    expect(find.text('Linha 5 — Mimosa - 12 — já cadastrado'), findsOneWidget);
    expect(find.text('Linha 3 — Estrela — raça não informada'), findsOneWidget);

    await tester.tap(find.text('Voltar para a lista'));
    expect(voltou, isTrue);
  });
}
