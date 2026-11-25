/// Desenho da Roda da Reprodução (paleta Embrapa).
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';
import '/domain/roda_reproducao/ciclo_reproducao.dart';
import '../../application/animal_roda_adapter.dart';
import 'geometria_roda.dart';

// ---------------------------------------------------------------------------
// Paleta Embrapa (fiel ao app "Roda da Reprodução")
// ---------------------------------------------------------------------------

const Map<FaseRoda, Color> kCoresFase = {
  FaseRoda.posParto: Color(0xFFE5482F),
  FaseRoda.cobertura: Color(0xFFF2C230),
  FaseRoda.prenhe: Color(0xFF2F7FD8),
  FaseRoda.seca: Color(0xFF7AA64A),
};
const Color kNovilhaCoberta = Color(0xFFF6B3C6);
const Color kNovilhaPrenhe = Color(0xFFE4589A);

/// Cor da bolinha/avatar: estado real; novilha coberta/prenhe em rosa.
Color corDoAnimal(AnimalRoda a) {
  if (a.novilha && a.coberta) {
    return a.faseEstado == FaseRoda.cobertura
        ? kNovilhaCoberta
        : kNovilhaPrenhe;
  }
  return kCoresFase[a.faseEstado]!;
}

/// Texto legível sobre [fundo] (amarelo e rosa-claro pedem número escuro).
Color corTextoSobre(Color fundo) => fundo.computeLuminance() > 0.45
    ? const Color(0xFF3A2A00)
    : Colors.white;

// ---------------------------------------------------------------------------
// Widget
// ---------------------------------------------------------------------------

class RodaWidget extends StatelessWidget {
  const RodaWidget({
    super.key,
    required this.posicoes,
    required this.data,
    required this.avanco,
    required this.aoTocarFaixa,
    required this.aoTocarAnimal,
    this.faixaDestacada,
  });

  /// Só os animais que estão na roda (`naRoda`) são desenhados; os demais
  /// entram no "+N fora do ciclo" do centro.
  final List<PosicaoRoda> posicoes;

  /// Data exibida (hoje + [avanco]).
  final DateTime data;
  final int avanco;
  final FaseRoda? faixaDestacada;
  final ValueChanged<FaseRoda> aoTocarFaixa;
  final ValueChanged<PosicaoRoda> aoTocarAnimal;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      final lado = math.min(cons.maxWidth, 460.0);
      final size = Size(lado, lado);
      final g = GeometriaRoda(size);
      final naRoda = posicoes.where((p) => p.naRoda).toList();
      final dist = g.distribuirBolinhas([for (final p in naRoda) p.dia]);
      final fora = posicoes.length - naRoda.length;

      return Center(
        child: ClipRect(
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 3.5,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: (d) => _tocar(d.localPosition, g, naRoda, dist),
              child: Semantics(
                label: 'Roda da reprodução com ${naRoda.length} animais',
                child: SizedBox.fromSize(
                  size: size,
                  child: CustomPaint(
                    painter: _PintorRoda(
                      g: g,
                      posicoes: naRoda,
                      dist: dist,
                      faixaDestacada: faixaDestacada,
                      data: data,
                      avanco: avanco,
                      fora: fora,
                      tema: FlutterFlowTheme.of(context),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _tocar(Offset pos, GeometriaRoda g, List<PosicaoRoda> naRoda,
      Distribuicao dist) {
    // Selo "+N" (animais agrupados): filtra pela faixa daquele dia.
    for (final gr in dist.grupos) {
      if ((gr.centro - pos).distance <= _raioGrupo(dist) + 6) {
        aoTocarFaixa(faseDoDia(gr.dia.floor() % kCiclo));
        return;
      }
    }
    var melhor = double.infinity;
    PosicaoRoda? perto;
    for (var i = 0; i < naRoda.length; i++) {
      final c = dist.centros[i];
      if (c == null) continue;
      final d = (c - pos).distance;
      if (d < melhor) {
        melhor = d;
        perto = naRoda[i];
      }
    }
    if (perto != null && melhor <= dist.raio + 6) {
      aoTocarAnimal(perto);
      return;
    }
    final r = (pos - g.centro).distance;
    if (r >= g.rDentro - 6 && r <= g.rFora + 22) {
      aoTocarFaixa(faseDoDia(g.diaDoAngulo(pos).floor() % kCiclo));
    }
  }
}

double _raioGrupo(Distribuicao d) => GeometriaRoda.raioGrupo(d.raio);

// ---------------------------------------------------------------------------
// Pintor
// ---------------------------------------------------------------------------

class _PintorRoda extends CustomPainter {
  _PintorRoda({
    required this.g,
    required this.posicoes,
    required this.dist,
    required this.faixaDestacada,
    required this.data,
    required this.avanco,
    required this.fora,
    required this.tema,
  });

  final GeometriaRoda g;
  final List<PosicaoRoda> posicoes;
  final Distribuicao dist;
  final FaseRoda? faixaDestacada;
  final DateTime data;
  final int avanco;
  final int fora;
  final FlutterFlowTheme tema;

  static const _faixas = [
    (FaseRoda.posParto, 0, kDiaCobertura),
    (FaseRoda.cobertura, kDiaCobertura, kFimCobertura),
    (FaseRoda.prenhe, kFimCobertura, kDiaSecar),
    (FaseRoda.seca, kDiaSecar, kCiclo),
  ];

  static const _marcas = [
    (30, '30'),
    (45, '45'),
    (60, '60'),
    (kDiaCobertura, 'Cobrir'),
    (kDiaCobertura + 21, 'Cio 21d'),
    (kDiaCobertura + 40, 'DG 40d'),
    (kDiaSecar, 'Secar'),
    (kCiclo - 30, '30'),
  ];

  static const _meses = [
    'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
    'jul', 'ago', 'set', 'out', 'nov', 'dez',
  ];

  bool _apagada(FaseRoda f) => faixaDestacada != null && faixaDestacada != f;

  @override
  void paint(Canvas canvas, Size size) {
    final c = g.centro;
    final rect = Rect.fromCircle(center: c, radius: g.rMeio);

    // Fundo branco da área das bolinhas.
    canvas.drawCircle(c, g.rDentro, Paint()..color = Colors.white);
    canvas.drawCircle(
        c,
        g.rDentro,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = const Color(0xFFE3E6EC));

    _desenharMeses(canvas);

    // Faixas sólidas + tracinhos brancos a cada 7 dias (como o original).
    for (final (fase, ini, fim) in _faixas) {
      final cor = kCoresFase[fase]!.withValues(alpha: _apagada(fase) ? 0.3 : 1);
      canvas.drawArc(
          rect,
          g.angulo(ini) + 0.006,
          (fim - ini) / kCiclo * 2 * math.pi - 0.012,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = GeometriaRoda.espessura
            ..color = cor);
      for (var d = ini + 7; d < fim; d += 7) {
        canvas.drawLine(
            g.ponto(d, g.rDentro),
            g.ponto(d, g.rFora),
            Paint()
              ..color = Colors.white.withValues(alpha: 0.55)
              ..strokeWidth = 1);
      }
    }

    // Marcas: traço escuro cruzando a faixa + rótulo por fora.
    for (final (dia, rotulo) in _marcas) {
      canvas.drawLine(
          g.ponto(dia, g.rDentro - 2),
          g.ponto(dia, g.rFora + 5),
          Paint()
            ..color = tema.primaryText
            ..strokeWidth = 1.4);
      final tp = _tp(rotulo, tema.primaryText, 10, FontWeight.w600);
      final ang = g.angulo(dia);
      final afasta = 9 +
          math.cos(ang).abs() * tp.width / 2 +
          math.sin(ang).abs() * tp.height / 2;
      final p = g.ponto(dia, g.rFora + afasta);
      tp.paint(canvas, p - Offset(tp.width / 2, tp.height / 2));
    }

    // HOJE · PARTO embaixo.
    final base = g.ponto(0, g.rFora + 1);
    canvas.drawLine(g.ponto(0, g.rCentro + 2), g.ponto(0, g.rDentro),
        Paint()
          ..color = tema.primaryText.withValues(alpha: 0.35)
          ..strokeWidth = 1.2);
    canvas.drawPath(
        Path()
          ..moveTo(base.dx, base.dy - 3)
          ..lineTo(base.dx - 7, base.dy + 8)
          ..lineTo(base.dx + 7, base.dy + 8)
          ..close(),
        Paint()..color = tema.primaryText);
    _pilula(canvas, 'HOJE · PARTO', Offset(c.dx, base.dy + 17));

    _desenharBolinhas(canvas);
    _desenharGrupos(canvas);
    _desenharCentro(canvas);
  }

  /// Meses no anel interno: a data D fica no dia (data − D); gira com a data.
  void _desenharMeses(Canvas canvas) {
    final cor = tema.secondaryText.withValues(alpha: 0.8);
    for (var m = 0; m < 12; m++) {
      final inicio = DateTime(data.year, data.month - m, 1);
      final dInicio = data.difference(inicio).inDays;
      if (dInicio > 0 && dInicio < kCiclo) {
        canvas.drawLine(
            g.ponto(dInicio, g.rCentro + 1),
            g.ponto(dInicio, g.rMeses + 7),
            Paint()
              ..color = const Color(0xFFD5D9E0)
              ..strokeWidth = 1);
      }
      final meio = DateTime(data.year, data.month - m, 15);
      final d = data.difference(meio).inDays;
      if (d < 0 || d >= kCiclo) continue;
      final tp = _tp(_meses[meio.month - 1], cor, 8, FontWeight.w500);
      final p = g.ponto(d, g.rMeses);
      tp.paint(canvas, p - Offset(tp.width / 2, tp.height / 2));
    }
  }

  void _desenharBolinhas(Canvas canvas) {
    final r = dist.raio;
    for (var i = 0; i < posicoes.length; i++) {
      final p = posicoes[i];
      final centro = dist.centros[i];
      if (centro == null) continue;
      final cor = corDoAnimal(p.animal);
      final apagada = _apagada(p.faixa);
      final a = apagada ? 0.25 : 1.0;

      if (p.alerta != null) {
        canvas.drawCircle(
            centro,
            r + 2.6,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.8
              ..color = tema.primaryText.withValues(alpha: 0.85 * a));
      }
      canvas.drawCircle(
          centro, r + 1, Paint()..color = Colors.white.withValues(alpha: a));
      canvas.drawCircle(centro, r, Paint()..color = cor.withValues(alpha: a));

      final texto = rotuloBrinco(p.animal.brinco, p.animal.nome);
      final base = switch (texto.length) { <= 2 => 9.0, 3 => 8.0, _ => 6.6 };
      _texto(canvas, texto, centro,
          corTextoSobre(cor).withValues(alpha: a), base * r / GeometriaRoda.raioPonto,
          peso: FontWeight.w700);

      if (p.alerta != null && !apagada) {
        final b = centro + Offset(r * 0.8, -r * 0.8);
        final rb = math.max(3.2, r * 0.45);
        canvas.drawCircle(b, rb + 0.8, Paint()..color = Colors.white);
        canvas.drawCircle(b, rb, Paint()..color = AppTokens.negativo);
        _texto(canvas, '!', b.translate(0, 0.3), Colors.white, rb * 1.6,
            peso: FontWeight.w800);
      }
    }
  }

  /// Selo "+N" para animais que não couberam perto do dia certo.
  void _desenharGrupos(Canvas canvas) {
    final r = _raioGrupo(dist);
    for (final gr in dist.grupos) {
      final apagada = _apagada(faseDoDia(gr.dia.floor() % kCiclo));
      final a = apagada ? 0.3 : 1.0;
      canvas.drawCircle(
          gr.centro, r + 1.5, Paint()..color = Colors.white.withValues(alpha: a));
      canvas.drawCircle(gr.centro, r,
          Paint()..color = tema.primaryText.withValues(alpha: 0.88 * a));
      _texto(canvas, '+${gr.indices.length}', gr.centro,
          Colors.white.withValues(alpha: a), r * 0.95,
          peso: FontWeight.w700);
    }
  }

  void _desenharCentro(Canvas canvas) {
    final c = g.centro;
    canvas.drawCircle(c, g.rCentro, Paint()..color = const Color(0xFFF4F6F9));
    final escala = g.rCentro / 42;
    _texto(canvas, '${posicoes.length}', c.translate(0, -12 * escala),
        tema.primaryText, 28 * escala,
        peso: FontWeight.w700, outfit: true);
    _texto(canvas, posicoes.length == 1 ? 'animal' : 'animais',
        c.translate(0, 6 * escala), tema.secondaryText, 9.5 * escala);
    _texto(
        canvas,
        avanco == 0 ? 'hoje ${_fmt(data)}' : '${_fmt(data)} (+$avanco d)',
        c.translate(0, 18 * escala),
        avanco == 0 ? tema.secondaryText : AppTokens.brand,
        9 * escala,
        peso: FontWeight.w600);
    if (fora > 0) {
      _texto(canvas, '+$fora fora do ciclo', c.translate(0, 30 * escala),
          AppTokens.negativo, 8.5 * escala,
          peso: FontWeight.w600);
    }
  }

  static String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

  void _pilula(Canvas canvas, String t, Offset centro) {
    final tp = _tp(t, Colors.white, 10, FontWeight.w700);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: centro, width: tp.width + 18, height: tp.height + 8),
            const Radius.circular(10)),
        Paint()..color = tema.primaryText);
    tp.paint(canvas, centro - Offset(tp.width / 2, tp.height / 2));
  }

  TextPainter _tp(String t, Color cor, double tam, FontWeight peso,
          {bool outfit = false}) =>
      TextPainter(
        text: TextSpan(
          text: t,
          style: (outfit ? GoogleFonts.outfit() : GoogleFonts.readexPro())
              .copyWith(fontSize: tam, color: cor, fontWeight: peso, height: 1),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

  void _texto(Canvas canvas, String t, Offset centro, Color cor, double tam,
      {FontWeight peso = FontWeight.w400, bool outfit = false}) {
    final tp = _tp(t, cor, tam, peso, outfit: outfit);
    tp.paint(canvas, centro - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _PintorRoda old) =>
      old.posicoes != posicoes ||
      old.faixaDestacada != faixaDestacada ||
      old.data != data ||
      old.fora != fora ||
      old.dist.raio != dist.raio;
}
