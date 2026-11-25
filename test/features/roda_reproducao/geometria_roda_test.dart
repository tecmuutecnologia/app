import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/features/roda_reproducao/presentation/widgets/geometria_roda.dart';

void main() {
  final g = GeometriaRoda(const Size(360, 360));

  test('dia 0 aponta para baixo (HOJE · PARTO)', () {
    expect(g.angulo(0), closeTo(math.pi / 2, 1e-9));
    final p = g.ponto(0, 100);
    expect(p.dx, closeTo(g.centro.dx, 1e-9));
    expect(p.dy, closeTo(g.centro.dy + 100, 1e-9));
  });

  test('sentido horário: dia ~91 fica à esquerda', () {
    final p = g.ponto(365 / 4, 100);
    expect(p.dx, closeTo(g.centro.dx - 100, 1e-6));
  });

  test('diaDoAngulo é o inverso de ponto', () {
    for (final d in [0.0, 30.0, 100.0, 250.0, 364.0]) {
      expect(g.diaDoAngulo(g.ponto(d, 120)), closeTo(d, 1e-6));
    }
  });

  void semSobreposicao(Distribuicao d) {
    final c = d.centros.whereType<Offset>().toList();
    for (var i = 0; i < c.length; i++) {
      for (var j = i + 1; j < c.length; j++) {
        expect((c[i] - c[j]).distance, greaterThanOrEqualTo(d.raio * 2),
            reason: '$i x $j');
      }
    }
  }

  test('poucas bolinhas usam o tamanho cheio', () {
    final d = g.distribuirBolinhas([10, 50, 200]);
    expect(d.raio, GeometriaRoda.raioPonto);
  });

  double desvio(double a, double b) {
    final d = (a - b).abs() % 365;
    return d > 182.5 ? 365 - d : d;
  }

  for (final n in [5, 20, 60, 150]) {
    test('$n no mesmo dia: sem sobreposição e sem sair de perto do dia', () {
      final d = g.distribuirBolinhas(List.filled(n, 150));
      expect(d.centros.length, n);
      semSobreposicao(d);
      var desenhadas = 0;
      for (final c in d.centros) {
        if (c == null) continue;
        desenhadas++;
        expect(desvio(g.diaDoAngulo(c), 150),
            lessThanOrEqualTo(GeometriaRoda.desvioMaximo + 0.01));
      }
      final agrupadas = d.grupos.fold<int>(0, (s, gr) => s + gr.indices.length);
      expect(desenhadas + agrupadas, n);
      if (n >= 60) {
        expect(d.grupos, isNotEmpty);
        expect(d.raio, lessThan(GeometriaRoda.raioPonto));
      }
    });
  }

  test('selos "+N" não cobrem bolinhas nem outros selos (caso teste100)', () {
    // Dias reais do teste100 em 24/11/2026 (roda de 382 px).
    final g382 = GeometriaRoda(const Size(382, 382));
    final dias = [293, 258, 267, 127, 127, 364, 325, 87, 293, 61, 240, 119,
      185, 185, 151, 121, 121, 120, 119, 157, 105, 155, 116, 155];
    final d = g382.distribuirBolinhas(dias);
    final rb = GeometriaRoda.raioGrupo(d.raio);
    for (final gr in d.grupos) {
      for (final c in d.centros.whereType<Offset>()) {
        expect((gr.centro - c).distance, greaterThanOrEqualTo(rb + d.raio),
            reason: 'selo cobre bolinha');
      }
      for (final o in d.grupos) {
        if (identical(o, gr)) continue;
        expect((gr.centro - o.centro).distance, greaterThanOrEqualTo(2 * rb),
            reason: 'selo cobre selo');
      }
    }
  });

  test('60 animais espalhados cabem sem grupos', () {
    final dias = [for (var i = 0; i < 60; i++) (i * 6) % 365];
    final d = g.distribuirBolinhas(dias);
    expect(d.grupos, isEmpty);
    semSobreposicao(d);
  });

  test('bolinhas ficam dentro da faixa colorida e fora dos meses', () {
    final d = g.distribuirBolinhas([10, 10, 10, 10, 200]);
    for (final c in d.centros.whereType<Offset>()) {
      final r = (c - g.centro).distance;
      expect(r, lessThanOrEqualTo(g.rDentro - d.raio));
      expect(r, greaterThanOrEqualTo(g.rMeses + 4 + d.raio));
    }
  });

  test('mesmo dia empilha para dentro no raio', () {
    final c = g.distribuirBolinhas([100, 100]).centros.cast<Offset>();
    expect(g.diaDoAngulo(c[0]), closeTo(100, 1e-6));
    expect(g.diaDoAngulo(c[1]), closeTo(100, 1e-6));
    expect((c[1] - g.centro).distance, lessThan((c[0] - g.centro).distance));
  });
}
