import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/sync_etapa.dart';
import 'package:tecmuu/features/sincronizacao/domain/sync_state.dart';
import 'package:tecmuu/features/sincronizacao/presentation/widgets/sync_progress_view.dart';

void main() {
  var continuouClicado = false;

  setUp(() => continuouClicado = false);

  Future<void> montar(WidgetTester tester, SyncState estado) {
    return tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SyncProgressView(
          estado: estado,
          onTentarNovamente: () {},
          onContinuarAssimMesmo: () {},
          onContinuar: () => continuouClicado = true,
        ),
      ),
    ));
  }

  testWidgets('mostra contador quando a etapa tem total', (tester) async {
    await montar(
      tester,
      const SyncBaixando(
        etapa: SyncEtapa.animais,
        rotulo: 'Animais',
        progresso: 0.65,
        atual: 1240,
        total: 3000,
      ),
    );

    expect(find.textContaining('1.240 de 3.000'), findsOneWidget);
  });

  testWidgets('esconde ritmo e ETA quando nao ha total', (tester) async {
    await montar(
      tester,
      const SyncBaixando(
        etapa: SyncEtapa.referencias,
        rotulo: 'Tabelas de referência',
        progresso: 0.0,
      ),
    );

    // Checagem por substring literal ' de ' colidiria com o proprio rotulo da
    // etapa ('Tabelas de referência', sempre visivel na checklist), que nao
    // e um contador. O padrao real do contador e "numero de numero".
    expect(
      find.byWidgetPredicate((w) =>
          w is Text &&
          w.data != null &&
          RegExp(r'\d[\d.]* de \d[\d.]*').hasMatch(w.data!)),
      findsNothing,
    );
    expect(find.textContaining('/s'), findsNothing);
    expect(find.textContaining('Restam'), findsNothing);
  });

  testWidgets('mostra ritmo e ETA quando disponiveis', (tester) async {
    await montar(
      tester,
      const SyncBaixando(
        etapa: SyncEtapa.animais,
        rotulo: 'Animais',
        progresso: 0.65,
        atual: 1240,
        total: 3000,
        ritmo: 380,
        eta: Duration(seconds: 5),
      ),
    );

    expect(find.textContaining('380/s'), findsOneWidget);
    expect(find.textContaining('Restam ~5s'), findsOneWidget);
  });

  testWidgets('falha no download mostra os dois botoes', (tester) async {
    await montar(
      tester,
      const SyncErro(
        tipo: SyncErroTipo.falhaDownload,
        etapa: SyncEtapa.animais,
        mensagem: 'timeout',
      ),
    );

    expect(find.text('Tentar novamente'), findsOneWidget);
    expect(find.text('Continuar assim mesmo'), findsOneWidget);
  });

  testWidgets('sem conexao mostra so tentar novamente', (tester) async {
    await montar(
      tester,
      const SyncErro(
        tipo: SyncErroTipo.semConexao,
        mensagem: 'Sem conexão com a internet.',
      ),
    );

    expect(find.text('Tentar novamente'), findsOneWidget);
    expect(find.text('Continuar assim mesmo'), findsNothing);
  });

  testWidgets('checklist tem seis linhas', (tester) async {
    expect(linhasVisiveis, hasLength(6));
    expect(linhasVisiveis.contains(SyncEtapa.usuario), false,
        reason: 'usuario e agrupado em referencias');
    expect(linhasVisiveis.contains(SyncEtapa.tecnico), false,
        reason: 'tecnico e agrupado em referencias');
  });

  testWidgets('etapa usuario mantem a linha de referencias como atual',
      (tester) async {
    await montar(
      tester,
      const SyncBaixando(
        etapa: SyncEtapa.usuario,
        rotulo: 'Tabelas de referência',
        progresso: 0.18,
      ),
    );

    // referencias e a primeira linha da checklist: nao ha linha anterior a
    // ela, entao nenhuma linha pode aparecer como concluida ainda.
    expect(find.byIcon(Icons.check_circle), findsNothing);
    expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
  });

  testWidgets('etapa tecnico mantem a linha de referencias como atual',
      (tester) async {
    await montar(
      tester,
      const SyncBaixando(
        etapa: SyncEtapa.tecnico,
        rotulo: 'Tabelas de referência',
        progresso: 0.25,
      ),
    );

    expect(find.byIcon(Icons.check_circle), findsNothing);
    expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
  });

  testWidgets(
      'etapa animais marca linhas anteriores como concluidas e posteriores como pendentes',
      (tester) async {
    await montar(
      tester,
      const SyncBaixando(
        etapa: SyncEtapa.animais,
        rotulo: 'Animais',
        progresso: 0.65,
      ),
    );

    // referencias, produtores e propriedades: concluidas.
    expect(find.byIcon(Icons.check_circle), findsNWidgets(3));
    // animais: atual.
    expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
    // acoes e financeiro: pendentes.
    expect(find.byIcon(Icons.radio_button_unchecked), findsNWidgets(2));
  });

  group('estado concluido', () {
    testWidgets('mostra "Tudo pronto!" e o botao Continuar', (tester) async {
      await montar(tester, const SyncConcluido(DestinoDashboardTecnico()));

      expect(find.text('Tudo pronto!'), findsOneWidget);
      expect(find.text('Continuar'), findsOneWidget);
      // Todas as seis linhas da checklist aparecem concluidas.
      expect(find.byIcon(Icons.check_circle), findsNWidgets(7));
    });

    testWidgets('nao avanca sozinho — so o toque no botao dispara',
        (tester) async {
      await montar(tester, const SyncConcluido(DestinoDashboardTecnico()));

      // Varios frames sem interacao: a tela tem de continuar onde esta.
      await tester.pump(const Duration(seconds: 5));
      expect(continuouClicado, false,
          reason: 'a tela nao pode navegar por conta propria');

      await tester.tap(find.text('Continuar'));
      await tester.pump();
      expect(continuouClicado, true);
    });

    testWidgets('nao mostra a barra de progresso nem contador',
        (tester) async {
      await montar(tester, const SyncConcluido(DestinoDashboardTecnico()));

      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(find.textContaining(RegExp(r'\d[\d.]* de \d[\d.]*')), findsNothing);
    });
  });
}
