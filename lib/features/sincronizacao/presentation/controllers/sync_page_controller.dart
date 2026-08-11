import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  /// Nulo = a rota nao informou; o gateway descobre.
  SyncPapel? _papel;

  /// Guarda contra reentrancia: a tela tera botoes reais ("tentar novamente",
  /// "continuar assim mesmo") que o usuario pode tocar duas vezes, ou tocar
  /// durante um download em andamento. Sem isto, `baixarTudo`/`concluirLogin`
  /// rodariam duas vezes em paralelo e o estado final dependeria de qual
  /// terminasse por ultimo.
  bool _emAndamento = false;

  @override
  SyncState build() {
    ref.onDispose(() => _inscricao?.cancel());
    return const SyncPreparando();
  }

  SyncGateway get _gateway => ref.read(syncGatewayProvider);

  Future<void> iniciar(SyncPapel? papel) async {
    if (_emAndamento) return;
    _papel = papel;
    // So a primeira tentativa faz sentido reaproveitar `ultimoProgresso`: e
    // para a tela que monta depois do primeiro lote, nao para um retry, onde
    // ele e a amostra (com `atual` alto) da tentativa que acabou de falhar.
    await _executar(replayUltimoProgresso: true);
  }

  Future<void> tentarNovamente() async {
    if (_emAndamento) return;
    await _executar(replayUltimoProgresso: false);
  }

  Future<void> _executar({required bool replayUltimoProgresso}) async {
    _emAndamento = true;
    try {
      state = const SyncPreparando();
      _estimador.reiniciar();

      await _inscricao?.cancel();
      _inscricao = _gateway.progressStream.listen(_aoProgredir);

      if (replayUltimoProgresso) {
        final ultimo = _gateway.ultimoProgresso;
        if (ultimo != null) _aoProgredir(ultimo);
      }

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
      } on SyncCotaExcedidaException catch (e) {
        state = SyncErro(
          tipo: SyncErroTipo.cotaExcedida,
          etapa: e.etapa,
          mensagem: e.mensagem,
        );
        return;
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
    } finally {
      _emAndamento = false;
    }
  }

  /// Vai ao destino com os dados parciais. Seguro porque `initial_download` so
  /// e marcado completo no fim do download: o proximo login rebaixa tudo.
  Future<void> continuarAssimMesmo() async {
    if (_emAndamento) return;
    _emAndamento = true;
    try {
      await _concluir();
    } finally {
      _emAndamento = false;
    }
  }

  Future<void> _concluir() async {
    try {
      final destino = await _gateway.concluirLogin(_papel);
      // Estado terminal: sem isto, um evento de progresso tardio (ex.: um
      // `performFullDownload` concorrente ainda emitindo) reabriria a tela
      // de volta para `SyncBaixando` depois de concluida.
      await _inscricao?.cancel();
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
