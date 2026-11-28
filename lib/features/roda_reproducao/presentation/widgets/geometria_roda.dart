/// Geometria da roda: dia do ciclo ↔ ângulo/ponto e a distribuição das
/// bolinhas sem sobreposição. Sem widgets, para poder testar.
library;

import 'dart:math' as math;
import 'dart:ui';

import '/domain/roda_reproducao/ciclo_reproducao.dart';

class GeometriaRoda {
  GeometriaRoda(Size s)
      : centro = Offset(s.width / 2, s.height / 2),
        rFora = s.width / 2 - 48;

  final Offset centro;

  /// Raio externo da faixa colorida.
  final double rFora;

  static const double espessura = 22;
  static const double raioPonto = 10;

  double get rDentro => rFora - espessura;
  double get rCentro => rFora * 0.29;
  double get rMeio => rFora - espessura / 2;

  /// Anel dos meses, logo em volta do centro.
  double get rMeses => rCentro + 8;

  /// Dia 0 embaixo; sentido horário (para a esquerda, depois para cima).
  double angulo(num dia) => math.pi / 2 + dia / kCiclo * 2 * math.pi;

  Offset ponto(num dia, double r) =>
      centro + Offset(math.cos(angulo(dia)), math.sin(angulo(dia))) * r;

  /// Dia do ciclo (0..365) correspondente à posição [pos].
  double diaDoAngulo(Offset pos) {
    final d = pos - centro;
    var a = math.atan2(d.dy, d.dx) - math.pi / 2;
    while (a < 0) {
      a += 2 * math.pi;
    }
    while (a >= 2 * math.pi) {
      a -= 2 * math.pi;
    }
    return a / (2 * math.pi) * kCiclo;
  }

  static const double raioMinimo = 7.5;

  /// Quanto uma bolinha pode deslizar para o lado (dias) sem mudar a
  /// leitura da roda.
  static const double desvioMaximo = 12;

  /// Raio do selo "+N" para bolinhas de raio [raio].
  static double raioGrupo(double raio) => math.max(9, raio + 4);

  /// Centro de cada bolinha, na mesma ordem de [dias], e o raio usado.
  ///
  /// Quem colide desce uma camada (para o centro, como no original da
  /// Embrapa); sem camada livre, desliza até [desvioMaximo] dias para o lado.
  /// Se não couber, as bolinhas diminuem (até [raioMinimo]); o que ainda
  /// sobrar (ex.: lote grande de IATF no mesmo dia) vira um selo "+N" no
  /// lugar certo, em vez de ser desenhado em outra faixa.
  Distribuicao distribuirBolinhas(List<num> dias) {
    var raio = raioPonto;
    while (raio > raioMinimo && _capacidade(raio) < dias.length) {
      raio -= 0.5;
    }
    for (;; raio -= 0.5) {
      final ultima = raio <= raioMinimo;
      final d = _tentar(dias, raio, agrupar: ultima);
      if (d != null) return d;
    }
  }

  double _passo(double raio) => raio * 2 + 2;
  double _rExterno(double raio) => rDentro - raio - 4;
  double _rInterno(double raio) => rMeses + 4 + raio;

  int _capacidade(double raio) {
    var total = 0;
    for (var r = _rExterno(raio); r >= _rInterno(raio); r -= _passo(raio)) {
      total += (2 * math.pi * r / _passo(raio)).floor();
    }
    return total;
  }

  Distribuicao? _tentar(List<num> dias, double raio, {required bool agrupar}) {
    final passo = _passo(raio);
    final r0 = _rExterno(raio);
    final camadas =
        math.max(1, ((r0 - _rInterno(raio)) / passo).floor() + 1);
    final ordem = List.generate(dias.length, (i) => i)
      ..sort((a, b) => dias[a].compareTo(dias[b]));
    final grade = _Grade(passo);
    final out = List<Offset?>.filled(dias.length, null);
    final sobras = <int>[];

    for (final i in ordem) {
      Offset? achado;
      // desvio em dias: 0, +1, -1, +2, -2, ... até o limite.
      for (var k = 0; achado == null; k++) {
        final desvio = (k + 1) ~/ 2 * (k.isOdd ? 1.0 : -1.0);
        if (desvio.abs() > desvioMaximo) break;
        for (var c = 0; c < camadas; c++) {
          final p = ponto(dias[i] + desvio, r0 - c * passo);
          if (grade.livre(p)) {
            achado = p;
            break;
          }
        }
      }
      if (achado == null) {
        if (!agrupar) return null;
        sobras.add(i);
        continue;
      }
      grade.add(achado);
      out[i] = achado;
    }
    return Distribuicao(out, raio,
        grupos: _agrupar(dias, sobras, raio, [
          for (final c in out)
            if (c != null) c,
        ]));
  }

  /// Sobras próximas (até 2×[desvioMaximo] dias) viram UM selo, posto num
  /// lugar livre perto do dia médio — sem cobrir bolinhas nem outro selo.
  List<GrupoBolinhas> _agrupar(
      List<num> dias, List<int> sobras, double raio, List<Offset> ocupados) {
    if (sobras.isEmpty) return const [];
    final ordenadas = [...sobras]..sort((a, b) => dias[a].compareTo(dias[b]));
    final clusters = <List<int>>[
      [ordenadas.first]
    ];
    for (final i in ordenadas.skip(1)) {
      if (dias[i] - dias[clusters.last.first] <= 2 * desvioMaximo) {
        clusters.last.add(i);
      } else {
        clusters.add([i]);
      }
    }

    final rb = raioGrupo(raio);
    final selos = <Offset>[];
    bool livre(Offset p) =>
        ocupados.every((o) => (o - p).distance >= rb + raio) &&
        selos.every((o) => (o - p).distance >= 2 * rb);

    final grupos = <GrupoBolinhas>[];
    for (final idx in clusters) {
      final dia = idx.fold<num>(0, (s, i) => s + dias[i]) / idx.length;
      Offset? achado;
      // Do anel de dentro para fora, deslizando até 2×desvioMaximo.
      for (var k = 0; achado == null && k <= 4 * desvioMaximo; k++) {
        final desvio = (k + 1) ~/ 2 * (k.isOdd ? 1.0 : -1.0);
        for (var r = rMeses + 4 + rb; r <= rDentro - rb; r += 2) {
          final p = ponto(dia + desvio, r);
          if (livre(p)) {
            achado = p;
            break;
          }
        }
      }
      achado ??= ponto(dia, rMeses + 4 + rb);
      selos.add(achado);
      grupos.add(GrupoBolinhas(dia.toDouble(), achado, idx));
    }
    return grupos;
  }
}

/// Grade espacial para checar colisão sem varrer todas as bolinhas.
class _Grade {
  _Grade(this.passo);
  final double passo;
  final _celulas = <(int, int), List<Offset>>{};

  (int, int) _celula(Offset p) =>
      ((p.dx / passo).floor(), (p.dy / passo).floor());

  bool livre(Offset p) {
    final (cx, cy) = _celula(p);
    for (var dx = -1; dx <= 1; dx++) {
      for (var dy = -1; dy <= 1; dy++) {
        for (final o in _celulas[(cx + dx, cy + dy)] ?? const <Offset>[]) {
          if ((o - p).distance < passo) return false;
        }
      }
    }
    return true;
  }

  void add(Offset p) => _celulas.putIfAbsent(_celula(p), () => []).add(p);
}

/// Animais que não couberam perto do dia certo: desenhados como "+N".
class GrupoBolinhas {
  const GrupoBolinhas(this.dia, this.centro, this.indices);
  final double dia;
  final Offset centro;
  final List<int> indices;
}

class Distribuicao {
  const Distribuicao(this.centros, this.raio, {this.grupos = const []});

  /// `null` = o animal está dentro de um [GrupoBolinhas].
  final List<Offset?> centros;
  final double raio;
  final List<GrupoBolinhas> grupos;
}
