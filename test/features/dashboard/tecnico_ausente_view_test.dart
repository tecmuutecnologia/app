import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/features/dashboard/presentation/widgets/tecnico_ausente_view.dart';

void main() {
  Future<void> montar(WidgetTester tester, {VoidCallback? onSair}) {
    return tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TecnicoAusenteView(onSair: onSair ?? () {}),
      ),
    ));
  }

  testWidgets('explica a falta do cadastro em vez de deixar a tela vazia',
      (tester) async {
    await montar(tester);

    expect(find.textContaining('não está salvo neste aparelho'), findsOneWidget);
  });

  testWidgets('a saida oferecida aciona o logout', (tester) async {
    var saiu = false;
    await montar(tester, onSair: () => saiu = true);

    await tester.tap(find.text('Sair e entrar novamente'));
    await tester.pump();

    expect(saiu, isTrue);
  });
}
