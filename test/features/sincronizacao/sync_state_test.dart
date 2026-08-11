import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/sync_etapa.dart';
import 'package:tecmuu/features/sincronizacao/domain/sync_state.dart';

void main() {
  group('SyncBaixando', () {
    test('etapa curta, sem atual, nao mostra contador', () {
      // Etapas de um documento (usuario, tecnico) reportam progresso sem
      // `atual`; mostrar numero nelas so produziria um valor piscando.
      final semAtual = SyncBaixando(
        etapa: SyncEtapa.referencias,
        rotulo: 'Tabelas de referência',
        progresso: 0.0,
      );
      expect(semAtual.temContador, false);
      expect(semAtual.temTotal, false);
    });

    test('com atual e total, mostra contador e total', () {
      final comTotal = SyncBaixando(
        etapa: SyncEtapa.animais,
        rotulo: 'Animais',
        progresso: 0.65,
        atual: 1240,
        total: 3000,
      );
      expect(comTotal.temContador, true);
      expect(comTotal.temTotal, true);
      expect(comTotal.indeterminado, false);
    });

    test('com atual e SEM total, ainda mostra o contador', () {
      // Este e o caso que fazia a tela parecer travada: sem total, a view
      // escondia contador e ritmo, e a barra ficava imovel por minutos.
      final semTotal = SyncBaixando(
        etapa: SyncEtapa.acoes,
        rotulo: 'Ações e tratamentos',
        progresso: 0.70,
        atual: 4820,
      );
      expect(semTotal.temContador, true);
      expect(semTotal.temTotal, false);
    });

    test('sem total, o progresso e indeterminado', () {
      final semTotal = SyncBaixando(
        etapa: SyncEtapa.acoes,
        rotulo: 'Ações e tratamentos',
        progresso: 0.70,
        atual: 4820,
      );
      expect(semTotal.indeterminado, true);
    });

    test('nada baixado ainda nao conta como contador', () {
      final e = SyncBaixando(
        etapa: SyncEtapa.animais,
        rotulo: 'Animais',
        progresso: 0.6,
        atual: 0,
        total: 0,
      );
      expect(e.temContador, false);
      expect(e.temTotal, false);
    });
  });

  group('SyncErro', () {
    test('semConexao nao oferece continuar com dados parciais', () {
      final e = SyncErro(
        tipo: SyncErroTipo.semConexao,
        mensagem: 'Sem conexão',
      );
      expect(e.podeContinuarAssimMesmo, false);
      expect(e.etapa, isNull);
    });

    test('falhaDownload oferece continuar com o que baixou', () {
      final e = SyncErro(
        tipo: SyncErroTipo.falhaDownload,
        etapa: SyncEtapa.animais,
        mensagem: 'timeout',
      );
      expect(e.podeContinuarAssimMesmo, true);
      expect(e.etapa, SyncEtapa.animais);
    });
  });
}
