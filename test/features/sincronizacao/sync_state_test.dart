import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/sync_etapa.dart';
import 'package:tecmuu/features/sincronizacao/domain/sync_state.dart';

void main() {
  group('SyncBaixando', () {
    test('mostra contador so quando tem total', () {
      final semTotal = SyncBaixando(
        etapa: SyncEtapa.referencias,
        rotulo: 'Tabelas de referência',
        progresso: 0.0,
      );
      expect(semTotal.temContador, false);

      final comTotal = SyncBaixando(
        etapa: SyncEtapa.animais,
        rotulo: 'Animais',
        progresso: 0.65,
        atual: 1240,
        total: 3000,
      );
      expect(comTotal.temContador, true);
    });

    test('total zero nao conta como contador', () {
      final e = SyncBaixando(
        etapa: SyncEtapa.animais,
        rotulo: 'Animais',
        progresso: 0.6,
        atual: 0,
        total: 0,
      );
      expect(e.temContador, false);
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
