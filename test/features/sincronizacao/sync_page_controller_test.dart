import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/sync_etapa.dart';
import 'package:tecmuu/core/sync/sync_exceptions.dart';
import 'package:tecmuu/data/objectbox/offline_first_sync_service.dart';
import 'package:tecmuu/features/sincronizacao/domain/sync_gateway.dart';
import 'package:tecmuu/features/sincronizacao/domain/sync_state.dart';
import 'package:tecmuu/features/sincronizacao/presentation/controllers/sync_page_controller.dart';

/// Dublê escrito à mão: o projeto não usa mockito.
class FakeSyncGateway implements SyncGateway {
  FakeSyncGateway({
    this.temDadosLocais = false,
    this.erroAoBaixar,
    this.destino = const DestinoDashboardTecnico(),
  });

  @override
  bool temDadosLocais;

  Object? erroAoBaixar;
  SyncDestino destino;

  int vezesQueBaixou = 0;
  int vezesQueConcluiu = 0;

  final _controller = StreamController<SyncProgress>.broadcast();

  @override
  Stream<SyncProgress> get progressStream => _controller.stream;

  @override
  SyncProgress? ultimoProgresso;

  void emitir(SyncProgress p) {
    ultimoProgresso = p;
    _controller.add(p);
  }

  @override
  Future<void> baixarTudo() async {
    vezesQueBaixou++;
    if (erroAoBaixar != null) throw erroAoBaixar!;
  }

  @override
  Future<SyncDestino> concluirLogin(SyncPapel papel) async {
    vezesQueConcluiu++;
    return destino;
  }

  void dispose() => _controller.close();
}

ProviderContainer containerCom(FakeSyncGateway fake) {
  final c = ProviderContainer(
    overrides: [syncGatewayProvider.overrideWithValue(fake)],
  );
  addTearDown(c.dispose);
  addTearDown(fake.dispose);
  return c;
}

void main() {
  group('caminho feliz', () {
    test('começa em Preparando', () {
      final fake = FakeSyncGateway();
      final c = containerCom(fake);
      expect(c.read(syncPageControllerProvider), isA<SyncPreparando>());
    });

    test('conclui com o destino do gateway', () async {
      final fake = FakeSyncGateway();
      final c = containerCom(fake);

      await c.read(syncPageControllerProvider.notifier).iniciar(SyncPapel.tecnico);

      final estado = c.read(syncPageControllerProvider);
      expect(estado, isA<SyncConcluido>());
      expect((estado as SyncConcluido).destino, isA<DestinoDashboardTecnico>());
      expect(fake.vezesQueBaixou, 1);
      expect(fake.vezesQueConcluiu, 1);
    });

    test('progresso do gateway vira SyncBaixando com contador', () async {
      final fake = FakeSyncGateway();
      final c = containerCom(fake);

      final estados = <SyncState>[];
      c.listen(syncPageControllerProvider, (_, novo) => estados.add(novo));

      final futuro = c
          .read(syncPageControllerProvider.notifier)
          .iniciar(SyncPapel.tecnico);

      await Future<void>.delayed(Duration.zero);
      fake.emitir(const SyncProgress(
        etapa: SyncEtapa.animais,
        message: 'Animais',
        progress: 0.65,
        atual: 1240,
        total: 3000,
      ));
      await Future<void>.delayed(Duration.zero);
      await futuro;

      final baixando = estados.whereType<SyncBaixando>().toList();
      expect(baixando, isNotEmpty);
      expect(baixando.last.atual, 1240);
      expect(baixando.last.total, 3000);
      expect(baixando.last.temContador, true);
    });
  });

  group('erro', () {
    test('falha no download vira SyncErro com a etapa', () async {
      final fake = FakeSyncGateway(
        erroAoBaixar: const SyncFalhaException(SyncEtapa.animais, 'timeout'),
      );
      final c = containerCom(fake);

      await c.read(syncPageControllerProvider.notifier).iniciar(SyncPapel.tecnico);

      final estado = c.read(syncPageControllerProvider);
      expect(estado, isA<SyncErro>());
      final erro = estado as SyncErro;
      expect(erro.tipo, SyncErroTipo.falhaDownload);
      expect(erro.etapa, SyncEtapa.animais);
      expect(erro.podeContinuarAssimMesmo, true);
    });

    test('tentarNovamente refaz o download', () async {
      final fake = FakeSyncGateway(
        erroAoBaixar: const SyncFalhaException(SyncEtapa.animais, 'timeout'),
      );
      final c = containerCom(fake);
      final notifier = c.read(syncPageControllerProvider.notifier);

      await notifier.iniciar(SyncPapel.tecnico);
      expect(c.read(syncPageControllerProvider), isA<SyncErro>());

      fake.erroAoBaixar = null;
      await notifier.tentarNovamente();

      expect(c.read(syncPageControllerProvider), isA<SyncConcluido>());
      expect(fake.vezesQueBaixou, 2);
    });

    test('continuarAssimMesmo conclui com o destino resolvido', () async {
      final fake = FakeSyncGateway(
        erroAoBaixar: const SyncFalhaException(SyncEtapa.animais, 'timeout'),
      );
      final c = containerCom(fake);
      final notifier = c.read(syncPageControllerProvider.notifier);

      await notifier.iniciar(SyncPapel.tecnico);
      await notifier.continuarAssimMesmo();

      expect(c.read(syncPageControllerProvider), isA<SyncConcluido>());
    });
  });

  group('offline', () {
    test('offline sem dados locais vira erro de conexao', () async {
      final fake = FakeSyncGateway(
        temDadosLocais: false,
        erroAoBaixar: const SyncOfflineException(),
      );
      final c = containerCom(fake);

      await c.read(syncPageControllerProvider.notifier).iniciar(SyncPapel.tecnico);

      final estado = c.read(syncPageControllerProvider) as SyncErro;
      expect(estado.tipo, SyncErroTipo.semConexao);
      expect(estado.podeContinuarAssimMesmo, false);
    });

    test('offline com dados locais conclui direto', () async {
      final fake = FakeSyncGateway(
        temDadosLocais: true,
        erroAoBaixar: const SyncOfflineException(),
      );
      final c = containerCom(fake);

      await c.read(syncPageControllerProvider.notifier).iniciar(SyncPapel.produtor);

      expect(c.read(syncPageControllerProvider), isA<SyncConcluido>());
      expect(fake.vezesQueConcluiu, 1);
    });
  });
}
