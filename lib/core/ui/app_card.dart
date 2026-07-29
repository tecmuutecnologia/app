import 'package:flutter/material.dart';

import '/app/theme/flutter_flow_theme.dart';

/// Tokens do design-system (reskin baseado em `layout_inspirations/`): cards
/// brancos com cantos arredondados e sombra suave (em vez de borda dura),
/// espaçamento generoso. As CORES seguem o tema atual do app (laranja/vermelho)
/// — estes tokens só padronizam forma/elevação/raio.
class AppTokens {
  AppTokens._();

  /// Cor da marca (primária) — laranja do app.
  static const Color brand = Color(0xFFF75E38);

  /// Cor SECUNDÁRIA de acento — roxo. Complementa o laranja sem substituí-lo
  /// (usar em ícones/badges/ações secundárias para dar variedade visual).
  static const Color secondary = Color(0xFF7B61FF);

  /// Versão translúcida do acento secundário (fundo de avatar/chip).
  static const Color secondaryTint = Color(0x1A7B61FF);

  /// Versão translúcida da marca (fundo de avatar/chip, splash de toque).
  static const Color brandTint = Color(0x1AF75E38);

  /// Marca ainda mais diluída — usada no highlight de toque, que fica na tela
  /// enquanto o dedo está pressionado e por isso precisa ser mais discreto
  /// que o splash.
  static const Color brandTintSoft = Color(0x0DF75E38);

  /// Contorno dos cards de ação: o laranja da marca CHEIO, sem alfa.
  ///
  /// Já foi translúcido (35%) e o resultado era um salmão dessaturado que num
  /// LCD lia como bege — cor com alfa compõe com o fundo e perde a identidade
  /// do matiz. Como aqui a linha é o único elemento que define o card, ela
  /// precisa ser reconhecivelmente a cor da marca, a mesma da barra do topo.
  static const Color brandHairline = brand;

  /// Fundo de página das telas cujos cards têm acento laranja. É um off-white
  /// QUENTE de propósito: o `primaryBackground` do tema (#F1F4F8) é um cinza
  /// azulado, e sob ele o halo laranja dos cards lê como sujeira. Card branco
  /// sobre página branca não lê como card nenhum — precisa de chão.
  static Color canvas(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? FlutterFlowTheme.of(context).primaryBackground
          : const Color(0xFFF7F4F1);

  /// Raio padrão dos cards/superfícies.
  static const double radius = 16.0;

  /// Raio menor (chips, inputs internos).
  static const double radiusSmall = 12.0;

  /// Padding interno padrão de um card.
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);

  /// Sombra suave padrão (substitui as bordas 2px duras do layout FlutterFlow).
  static List<BoxShadow> softShadow(BuildContext context) => const [
        BoxShadow(
          color: Color(0x14000000), // ~8% preto
          blurRadius: 16.0,
          offset: Offset(0.0, 6.0),
        ),
      ];

  /// Contorno dos cards de ação: uma linha laranja de 1px e nada mais. Sem
  /// sombra — o card é definido pela linha, não por elevação.
  static Border brandBorder(BuildContext context) =>
      Border.all(color: brandHairline, width: 1.0);
}

/// "Tile" quadrado-arredondado com o ícone tonalizado — base visual dos cards
/// de menu e de estatística (reskin). O fundo é uma versão translúcida do
/// [accent]; o ícone usa o [accent] cheio.
class MenuIconTile extends StatelessWidget {
  const MenuIconTile({
    super.key,
    required this.icon,
    this.accent = AppTokens.brand,
    this.iconSize = 26.0,
    this.size = 48.0,
  });

  final IconData icon;
  final Color accent;
  final double iconSize;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Icon(icon, color: accent, size: iconSize),
    );
  }
}

/// Card branco arredondado com sombra suave — superfície base do reskin.
/// Reutilizável em todas as telas (lista de stats, seções, linhas de menu).
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = AppTokens.cardPadding,
    this.onTap,
    this.width,
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: color ?? FlutterFlowTheme.of(context).secondaryBackground,
      borderRadius: BorderRadius.circular(AppTokens.radius),
      boxShadow: AppTokens.softShadow(context),
    );

    final content = Padding(padding: padding, child: child);

    return Container(
      width: width,
      decoration: decoration,
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(AppTokens.radius),
                child: content,
              ),
            ),
    );
  }
}
