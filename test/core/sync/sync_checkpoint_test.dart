import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/sync_checkpoint.dart';
import 'package:tecmuu/core/sync/sync_etapa.dart';

void main() {
  group('SyncCheckpoint.pendentes', () {
    test('sem nada concluído, devolve as 8 etapas na ordem de execução', () {
      const c = SyncCheckpoint({});
      expect(c.pendentes, SyncEtapa.values);
      expect(c.pendentes.length, 8);
    });

    test('retoma da primeira etapa não concluída, preservando a ordem', () {
      const c = SyncCheckpoint({
        SyncEtapa.referencias,
        SyncEtapa.usuario,
        SyncEtapa.tecnico,
        SyncEtapa.produtores,
        SyncEtapa.propriedades,
      });
      expect(c.pendentes, [
        SyncEtapa.animais,
        SyncEtapa.acoes,
        SyncEtapa.financeiro,
      ]);
    });

    test('etapa concluída fora de ordem não reordena o restante', () {
      const c = SyncCheckpoint({SyncEtapa.animais});
      expect(c.pendentes, [
        SyncEtapa.referencias,
        SyncEtapa.usuario,
        SyncEtapa.tecnico,
        SyncEtapa.produtores,
        SyncEtapa.propriedades,
        SyncEtapa.acoes,
        SyncEtapa.financeiro,
      ]);
    });
  });

  group('SyncCheckpoint.tudoConcluido', () {
    test('falso quando falta ao menos uma etapa', () {
      const c = SyncCheckpoint({SyncEtapa.referencias});
      expect(c.tudoConcluido, false);
    });

    test('verdadeiro com todas as etapas marcadas', () {
      final c = SyncCheckpoint(SyncEtapa.values.toSet());
      expect(c.tudoConcluido, true);
    });
  });

  group('SyncCheckpoint.chaveDe', () {
    test('gera chave estável e distinta por etapa', () {
      expect(SyncCheckpoint.chaveDe(SyncEtapa.animais), 'etapa_animais');
      expect(SyncCheckpoint.chaveDe(SyncEtapa.financeiro), 'etapa_financeiro');
      final chaves = SyncEtapa.values.map(SyncCheckpoint.chaveDe).toSet();
      expect(chaves.length, SyncEtapa.values.length);
    });

    test('nenhuma chave colide com a linha agregadora initial_download', () {
      final chaves = SyncEtapa.values.map(SyncCheckpoint.chaveDe);
      expect(chaves.contains('initial_download'), false);
    });
  });
}
