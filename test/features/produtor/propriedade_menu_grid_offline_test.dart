import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/ui/flutter_flow_animations.dart';
import 'package:tecmuu/core/ui/menu_acao_card.dart';
import 'package:tecmuu/data/objectbox/entities/animal_entity.dart';
import 'package:tecmuu/domain/animais/classificacao_animal.dart';
import 'package:tecmuu/features/produtor/presentation/utils/navigation_params.dart';
import 'package:tecmuu/features/produtor/presentation/widgets/propriedade_menu_grid.dart';

/// O menu de ações do PRODUTOR lê de uma fonte única — a lista de animais do
/// ObjectBox que a página injeta — e não de conectividade.
///
/// Antes, a home do produtor alimentava este grid com uma consulta ao Firestore
/// e o badge de Prenhas trocava de fonte conforme a flag `isOnline`: online
/// contava a lista do Firestore, offline relia o ObjectBox por fora. Como toda
/// escrita (DG+, cadastro) vai primeiro ao ObjectBox e só depois ao Firestore
/// pelo motor de sync — que é gated em conectividade —, offline a lista do
/// Firestore congelava e só o badge de Prenhas continuava certo. Os outros seis
/// mostravam números velhos.
void main() {
  /// Os cards usam `animateOnPageLoad`, que só precisa do `effectsBuilder` —
  /// o controller pertence às animações disparadas por ação, não usadas aqui.
  Map<String, AnimationInfo> animationsMap() => {
        for (var i = 1; i <= 13; i++)
          'containerOnPageLoadAnimation$i': AnimationInfo(
            trigger: AnimationTrigger.onPageLoad,
            effectsBuilder: () => [],
          ),
      };

  const params = PropriedadeNavigationParams(
    uidPropriedade: null,
    nomePropriedade: 'Fazenda Teste',
    uidTecnico: null,
    emailPropriedade: 'teste@teste.com',
    visitaPresencial: false,
    diasDg: '30',
  );

  AnimalEntity animal({required String status, required String grupo}) =>
      AnimalEntity(status: status, grupoAnimal: grupo);

  /// A grade é preguiçosa: numa janela pequena as últimas linhas nem chegam a
  /// ser construídas, e o teste passaria a medir o viewport em vez do menu.
  /// A superfície grande garante que todos os 13 cards existam de fato.
  Future<void> pumpGrid(WidgetTester tester,
      {List<AnimalEntity> animais = const []}) async {
    await tester.binding.setSurfaceSize(const Size(1000, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PropriedadeMenuGrid(
            animaisRecordList: animais,
            navigationParams: params,
            animationsMap: animationsMap(),
          ),
        ),
      ),
    );
    // `flutter_animate` agenda um timer no initState de cada card; sem drenar,
    // o teste falha no teardown por timer pendente.
    await tester.pumpAndSettle();
  }

  /// Os 13 itens do menu, na ordem em que o grid os monta.
  const rotulos = <String>[
    'Animais',
    'Inseminações',
    'Diagnóstico Gestação',
    'Prenhas',
    'Secas',
    'Exame Ginecológico',
    'Recria',
    'Lista completa',
    'Receituário',
    'Resumo Rebanho',
    'Calendário Sanitário',
    'Índices Zootécnicos',
    'Financeiro',
  ];

  int badgeDe(WidgetTester tester, String rotulo) => tester
      .widgetList<MenuAcaoCard>(find.byType(MenuAcaoCard))
      .firstWhere((c) => c.rotulo == rotulo)
      .contador!;

  testWidgets('renderiza todos os itens do menu', (tester) async {
    await pumpGrid(tester);

    for (final rotulo in rotulos) {
      expect(find.text(rotulo), findsOneWidget, reason: '"$rotulo" sumiu');
    }
  });

  testWidgets('o badge de Prenhas conta a lista recebida, so as VACAS',
      (tester) async {
    // Novilha prenha nao entra: o badge segue `ehVacaPrenha`, a mesma regra da
    // lista de prenhas. Antes contava novilha e a lista tambem a exibia — as
    // duas pontas erradas juntas, o que escondia o problema.
    await pumpGrid(tester, animais: [
      animal(status: kStatusPrenha, grupo: kGrupoVacas),
      animal(status: kStatusPrenha, grupo: kGrupoNovilhas),
      animal(status: kStatusVazia, grupo: kGrupoVacas),
    ]);

    expect(badgeDe(tester, 'Prenhas'), 1);
  });

  testWidgets('o badge de Prenhas acompanha um animal gravado só localmente',
      (tester) async {
    // Um animal sem `firestoreId` é exatamente o que uma escrita offline
    // produz: existe no ObjectBox e ainda não chegou ao Firestore. O badge
    // precisa contá-lo — era isto que a home do produtor perdia.
    await pumpGrid(tester, animais: [
      animal(status: kStatusPrenha, grupo: kGrupoVacas),
      AnimalEntity(
        status: kStatusPrenha,
        grupoAnimal: kGrupoVacas,
        uidAnimalOffline: 'local-1',
      ),
    ]);

    expect(badgeDe(tester, 'Prenhas'), 2);
  });
}
