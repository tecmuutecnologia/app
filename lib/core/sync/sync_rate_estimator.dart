/// Calcula ritmo (registros por segundo) e tempo restante estimado a partir de
/// amostras `(quantidade acumulada, instante)`.
///
/// Puro de proposito: o `OfflineFirstSyncService` emite fatos (quantos de
/// quantos) e quem transforma isso em ritmo/ETA e a camada de apresentacao.
/// Sem isso, o servico de sincronizacao acumularia logica de UI.
class SyncRateEstimator {
  SyncRateEstimator({this.janela = 3});

  /// Quantas transicoes entram na media movel. Curta de proposito: sao ~12
  /// lotes num download de 3000 animais, e uma janela maior so produziria
  /// numero depois que o download ja acabou.
  final int janela;

  final List<_Amostra> _amostras = [];

  void registrar(int atual, DateTime em) {
    _amostras.add(_Amostra(atual, em));
    // Guarda uma amostra a mais que a janela: N transicoes exigem N+1 pontos.
    while (_amostras.length > janela + 1) {
      _amostras.removeAt(0);
    }
  }

  void reiniciar() => _amostras.clear();

  double? get registrosPorSegundo {
    if (_amostras.length < 2) return null;

    final primeira = _amostras.first;
    final ultima = _amostras.last;
    final segundos =
        ultima.em.difference(primeira.em).inMicroseconds / Duration.microsecondsPerSecond;
    if (segundos <= 0) return null;

    final delta = ultima.atual - primeira.atual;
    if (delta <= 0) return null;

    return delta / segundos;
  }

  Duration? etaPara(int total) {
    final ritmo = registrosPorSegundo;
    if (ritmo == null || ritmo <= 0) return null;

    // Numero cru logo no comeco pula demais ("47s" virando "4s" um segundo
    // depois destroi mais confianca do que a ausencia do numero).
    final decorrido = _amostras.last.em.difference(_amostras.first.em);
    if (decorrido < const Duration(seconds: 2)) return null;

    final restantes = total - _amostras.last.atual;
    if (restantes <= 0) return null;

    final segundos = restantes / ritmo;
    if (segundos < 3) return null;

    return Duration(milliseconds: (segundos * 1000).round());
  }
}

class _Amostra {
  const _Amostra(this.atual, this.em);
  final int atual;
  final DateTime em;
}
