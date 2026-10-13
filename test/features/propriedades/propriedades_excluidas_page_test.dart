import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/features/propriedades/application/propriedades_providers.dart';
import 'package:tecmuu/features/propriedades/presentation/pages/propriedades_excluidas_page.dart';

/// A lixeira de propriedades travava o app ao abrir com algum item.
///
/// A ListView ficava num Expanded dentro de uma Row, e a Row direto na Column
/// do body. Expanded numa Row só limita a largura; a Column dava altura
/// ilimitada à Row, e o viewport da ListView estourava ("Vertical viewport was
/// given unbounded height"). Em debug o isolate pausava na exceção — a tela
/// congelava inteira.
void main() {
  const tecnico = 'tecnico/t1';

  Future<void> abrirLixeira(
    WidgetTester tester,
    List<PropriedadeEntity> excluidas,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tecnicoPathProvider.overrideWithValue(tecnico),
          propriedadesExcluidasProvider(tecnico)
              .overrideWith((ref) => Stream.value(excluidas)),
        ],
        child: const MaterialApp(
          home: PropriedadesExcluiasPage(
            visitaPresencial: false,
            uidTecnico: null,
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('abre a lixeira com propriedades sem erro de layout',
      (tester) async {
    await abrirLixeira(tester, [
      PropriedadeEntity(firestoreId: 'p1', displayName: 'Fazenda Excluída'),
    ]);

    expect(tester.takeException(), isNull);
    expect(find.text('Fazenda Excluída'), findsOneWidget);
  });

  testWidgets('lixeira vazia mostra a mensagem', (tester) async {
    await abrirLixeira(tester, []);

    expect(tester.takeException(), isNull);
    expect(
      find.text('Pasta vazia: não há nenhuma propriedade na lixeira.'),
      findsOneWidget,
    );
  });
}
