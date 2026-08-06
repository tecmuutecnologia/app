import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/sync/sync_etapa.dart';
import '../../../../core/sync/sync_exceptions.dart';
import '../../../../core/sync/sync_rate_estimator.dart';
import '../../../../data/objectbox/offline_first_sync_service.dart';
import '../../domain/sync_gateway.dart';
import '../../domain/sync_state.dart';

/// Orquestra a tela de sincronizacao: download completo, resolucao de perfil e
/// destino. Nao conhece GoRouter nem widgets — devolve um [SyncDestino] e a
/// page traduz para navegacao.
class SyncPageController extends Notifier<SyncState> {
  StreamSubscription<SyncProgress>? _inscricao;
  final SyncRateEstimator _estimador = SyncRateEstimator();
  SyncPapel _papel = SyncPapel.tecnico;

  @override
  SyncState build() {
    ref.onDispose(() => _inscricao?.cancel());
    return const SyncPreparando();
  }

  SyncGateway get _gateway => ref.read(syncGatewayProvider);

  Future<void> iniciar(SyncPapel papel) async {
    _papel = papel;
    await _executar();
  }

  Future<void> tentarNovamente() => _executar();

  Future<void> _executar() async {
    state = const SyncPreparando();
    _estimador.reiniciar();

    await _inscricao?.cancel();
    _inscricao = _gateway.progressStream.listen(_aoProgredir);

    final ultimo = _gateway.ultimoProgresso;
    if (ultimo != null) _aoProgredir(ultimo);

    try {
      await _gateway.baixarTudo();
    } on SyncOfflineException {
      // Offline com dados locais e o caso normal do tecnico em campo: segue.
      // Sem dados locais, entrar num app vazio pareceria perda de dados.
      if (!_gateway.temDadosLocais) {
        state = const SyncErro(
          tipo: SyncErroTipo.semConexao,
          mensagem: 'Sem conexão com a internet.',
        );
        return;
      }
    } on SyncFalhaException catch (e) {
      state = SyncErro(
        tipo: SyncErroTipo.falhaDownload,
        etapa: e.etapa,
        mensagem: e.mensagem,
      );
      return;
    } catch (e) {
      state = SyncErro(
        tipo: SyncErroTipo.falhaDownload,
        mensagem: e.toString(),
      );
      return;
    }

    await _concluir();
  }

  /// Vai ao destino com os dados parciais. Seguro porque `initial_download` so
  /// e marcado completo no fim do download: o proximo login rebaixa tudo.
  Future<void> continuarAssimMesmo() => _concluir();

  Future<void> _concluir() async {
    try {
      final destino = await _gateway.concluirLogin(_papel);
      state = SyncConcluido(destino);
    } catch (e) {
      state = SyncErro(
        tipo: SyncErroTipo.falhaDownload,
        mensagem: e.toString(),
      );
    }
  }

  void _aoProgredir(SyncProgress p) {
    if (p.atual != null && p.total != null) {
      _estimador.registrar(p.atual!, DateTime.now());
    }

    state = SyncBaixando(
      etapa: p.etapa,
      rotulo: p.message,
      progresso: p.progress,
      atual: p.atual,
      total: p.total,
      ritmo: _estimador.registrosPorSegundo,
      eta: p.total == null ? null : _estimador.etaPara(p.total!),
    );
  }
}

final syncPageControllerProvider =
    NotifierProvider<SyncPageController, SyncState>(SyncPageController.new);
