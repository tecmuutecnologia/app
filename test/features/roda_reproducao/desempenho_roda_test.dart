import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/features/roda_reproducao/presentation/widgets/geometria_roda.dart';

/// Rebanho grande não pode travar a tela: a distribuição roda no build.
void main() {
  final g = GeometriaRoda(const Size(370, 370));
  for (final n in [300, 600, 1000]) {
    test('$n animais distribuídos em menos de 250 ms', () {
      final r = math.Random(7);
      final dias = [for (var i = 0; i < n; i++) r.nextInt(365)];
      g.distribuirBolinhas(dias); // aquecimento
      final sw = Stopwatch()..start();
      final d = g.distribuirBolinhas(dias);
      sw.stop();
      // ignore: avoid_print
      print('$n animais: ${sw.elapsedMilliseconds} ms, raio ${d.raio}, '
          'grupos ${d.grupos.length}');
      expect(sw.elapsedMilliseconds, lessThan(250));
    });
  }
}
