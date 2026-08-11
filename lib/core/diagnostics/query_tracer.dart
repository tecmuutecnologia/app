import 'package:flutter/foundation.dart';

/// Instrumentação TEMPORÁRIA de diagnóstico (debug-only).
///
/// Objetivo: responder, olhando o log, se uma tela leu do **ObjectBox** (local)
/// ou bateu no **Firestore** (rede) — e quanto tempo cada leitura custou.
///
/// - Leituras ObjectBox aparecem como `⬛OBX`.
/// - Leituras Firestore aparecem como `🔥FS` (as feitas via repositório) e
///   também no log nativo do SDK (`setLoggingEnabled`, ligado no bootstrap).
/// - Troca de tela aparece como `🧭NAV`.
///
/// Tudo é no-op fora de `kDebugMode`. Remover quando o diagnóstico terminar.
class QueryTracer {
  QueryTracer._();

  /// Liga/desliga sem recompilar toda a árvore.
  static bool enabled = kDebugMode;

  /// Leituras acima disso são marcadas como lentas (`🐢`).
  static const Duration slowThreshold = Duration(milliseconds: 16);

  static String _rota = '-';

  /// Registrado pelo [TracingNavigatorObserver]; usado para correlacionar
  /// cada query com a tela que estava aberta no momento.
  static void setRota(String rota) {
    if (!enabled) return;
    _rota = rota;
    debugPrint('🧭NAV | $rota');
  }

  /// Traça uma leitura síncrona do ObjectBox.
  static T obx<T>(String label, T Function() body) {
    if (!enabled) return body();
    final sw = Stopwatch()..start();
    final out = body();
    sw.stop();
    _log('⬛OBX', label, sw.elapsedMicroseconds, _tamanho(out));
    return out;
  }

  /// Traça uma leitura assíncrona que vai à rede (Firestore).
  static Future<T> fs<T>(String label, Future<T> Function() body) async {
    if (!enabled) return body();
    final sw = Stopwatch()..start();
    try {
      final out = await body();
      sw.stop();
      _log('🔥FS', label, sw.elapsedMicroseconds, _tamanho(out));
      return out;
    } catch (e) {
      sw.stop();
      _log('🔥FS', '$label ERRO($e)', sw.elapsedMicroseconds, null);
      rethrow;
    }
  }

  /// Marca a abertura de um stream (o custo real vem nos eventos, não aqui).
  static void stream(String label) {
    if (!enabled) return;
    debugPrint('⬛OBX·stream | $_rota | $label | assinado');
  }

  static int? _tamanho(Object? out) => out is Iterable ? out.length : null;

  static void _log(String tag, String label, int micros, int? n) {
    final ms = micros / 1000.0;
    final lento = micros >= slowThreshold.inMicroseconds ? ' 🐢' : '';
    final qtd = n == null ? '' : ' | $n itens';
    debugPrint('$tag | $_rota | $label | ${ms.toStringAsFixed(2)}ms$qtd$lento');
  }
}
