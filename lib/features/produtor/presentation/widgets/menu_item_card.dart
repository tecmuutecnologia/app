import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';

/// Card de menu (reskin baseado em `layout_inspirations/`): card branco
/// arredondado com sombra suave, ícone num "tile" quadrado-arredondado
/// tonalizado, e o rótulo abaixo (AutoSizeText, responsivo).
class MenuItemCard extends StatelessWidget {
  const MenuItemCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconSize = 26.0,
    this.accent = AppTokens.brand,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double iconSize;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
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
