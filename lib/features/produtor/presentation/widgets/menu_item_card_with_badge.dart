import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';

/// Conteúdo central (tile de ícone + rótulo) compartilhado pelos cards de menu
/// com badge.
class _MenuCardBody extends StatelessWidget {
  const _MenuCardBody({
    required this.icon,
    required this.label,
    required this.iconSize,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final double iconSize;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MenuIconTile(icon: icon, accent: accent, iconSize: iconSize),
          const SizedBox(height: 8.0),
          Flexible(
            child: AutoSizeText(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              minFontSize: 8.0,
              overflow: TextOverflow.ellipsis,
              style: FlutterFlowTheme.of(context).labelMedium.override(
                    font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge "pill" roxo (acento secundário) no canto superior direito.
///
/// O centramento do número vem de um [Center] com `widthFactor`/`heightFactor`
/// em 1.0, e NÃO da propriedade `alignment` do [Container]. A diferença não é
/// cosmética: um Container com `alignment` sob constraints limitadas se expande
/// para preencher o pai (está na doc do Container). Como o pai aqui é um
/// [Align] que repassa o tamanho do card inteiro, a pílula crescia até cobrir
/// card, ícone e rótulo — sobrava um bloco roxo com o número no meio. Com os
/// fatores em 1.0, o Center se dimensiona pelo filho e a pílula volta a
/// envolver só o número.
class _BadgePill extends StatelessWidget {
  const _BadgePill({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 24.0),
      padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: AppTokens.secondary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: child,
      ),
    );
  }
}

/// Card de menu COM badge de contagem (reskin): card branco + tile de ícone +
/// badge pill roxo no canto.
class MenuItemCardWithBadge extends StatelessWidget {
  const MenuItemCardWithBadge({
    super.key,
    required this.icon,
    required this.label,
    required this.badgeCount,
    required this.onTap,
    this.iconSize = 26.0,
    this.accent = AppTokens.brand,
  });

  final IconData icon;
  final String label;
  final String badgeCount;
  final VoidCallback onTap;
  final double iconSize;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          _MenuCardBody(
            icon: icon,
            label: label,
            iconSize: iconSize,
            accent: accent,
          ),
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: _BadgePill(
              child: Text(
                badgeCount,
                style: FlutterFlowTheme.of(context).labelSmall.override(
                      font: GoogleFonts.readexPro(fontWeight: FontWeight.bold),
                      color: Colors.white,
                      fontSize: 11.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Variante com badge vindo de um `Widget` builder (ex.: StreamBuilder interno).
class MenuItemCardWithBadgeBuilder extends StatelessWidget {
  const MenuItemCardWithBadgeBuilder({
    super.key,
    required this.icon,
    required this.label,
    required this.badgeBuilder,
    required this.onTap,
    this.iconSize = 26.0,
    this.accent = AppTokens.brand,
  });

  final IconData icon;
  final String label;
  final Widget badgeBuilder;
  final VoidCallback onTap;
  final double iconSize;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          _MenuCardBody(
            icon: icon,
            label: label,
            iconSize: iconSize,
            accent: accent,
          ),
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: _BadgePill(child: badgeBuilder),
          ),
        ],
      ),
    );
  }
}
