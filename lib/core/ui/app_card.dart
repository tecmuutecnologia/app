import 'package:flutter/material.dart';

import '/app/theme/flutter_flow_theme.dart';

/// Tokens do design-system (reskin baseado em `layout_inspirations/`): cards
/// brancos com cantos arredondados e sombra suave (em vez de borda dura),
/// espaçamento generoso. As CORES seguem o tema atual do app (laranja/vermelho)
/// — estes tokens só padronizam forma/elevação/raio.
class AppTokens {
  AppTokens._();

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
