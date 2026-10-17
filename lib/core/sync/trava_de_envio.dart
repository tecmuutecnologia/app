import 'dart:async';

/// Serializa os envios ao Firestore: nunca duas rodadas ao mesmo tempo.
///
/// O push é disparado por timer, reconexão, `queueOperation` (sem `await`) e
/// logout, sem coordenação entre eles. Duas rodadas simultâneas liam os mesmos
/// registros ainda sem `firestoreId`, e cada uma criava o seu documento — daí
/// os tratamentos em dobro no receituário.
class TravaDeEnvio {
  Future<void> _ultima = Future<void>.value();
  Future<void>? _rodadaAgendada;

  /// Roda [corpo] depois que tudo que já estava na trava terminar.
  ///
  /// Erro de um corpo volta só para quem o chamou; a trava segue liberando os
  /// próximos.
  Future<T> executar<T>(Future<T> Function() corpo) {
    final resultado = _ultima.then((_) => corpo());
    _ultima = resultado.then<void>((_) {}, onError: (_) {});
    return resultado;
  }

  /// Como [executar], mas pedidos repetidos enquanto uma rodada espera a vez
  /// viram essa mesma rodada.
  ///
  /// A vaga é liberada quando a rodada COMEÇA, não quando termina: o que for
  /// gravado depois de ela ler as pendências ganha uma rodada nova, em vez de
  /// esperar o próximo gatilho. Pedidos que se juntam a uma rodada já agendada
  /// rodam o corpo de quem a agendou.
  Future<void> agendar(Future<void> Function() corpo) {
    return _rodadaAgendada ??= executar(() {
      _rodadaAgendada = null;
      return corpo();
    });
  }
}
