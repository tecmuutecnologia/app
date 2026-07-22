import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';

/// Casca compartilhada do card de estatística (reskin baseado em
/// `layout_inspirations/`): card branco arredondado com sombra suave, um ícone
/// num container circular tonalizado no topo, o valor em destaque e o rótulo.
class _StatCardShell extends StatelessWidget {
  const _StatCardShell({
    required this.icon,
    required this.accent,
    required this.valueWidget,
    required this.label,
    required this.fontSize,
  });

  final IconData icon;
  final Color accent;
  final Widget valueWidget;
  final String label;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: 150.0,
      padding: const EdgeInsets.all(14.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(icon, color: accent, size: 22.0),
          ),
          const SizedBox(height: 12.0),
          valueWidget,
          const SizedBox(height: 2.0),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: fontSize,
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
  }
}

/// Card de estatística para o dashboard com valor e label.
class DashboardStatCard extends StatelessWidget {
  const DashboardStatCard({
    super.key,
    required this.value,
    required this.label,
    this.icon = Icons.insights_rounded,
    this.accent = AppTokens.brand,
    this.fontSize = 13.0,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color accent;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return _StatCardShell(
      icon: icon,
      accent: accent,
      label: label,
      fontSize: fontSize,
      valueWidget: Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: FlutterFlowTheme.of(context).displaySmall.override(
              font: GoogleFonts.outfit(fontWeight: FontWeight.w700),
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 28.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

/// Card de estatística com loading indicator (valor vem de um stream).
class DashboardStatCardWithStream extends StatelessWidget {
  const DashboardStatCardWithStream({
    super.key,
    required this.valueWidget,
    required this.label,
    this.icon = Icons.insights_rounded,
    this.accent = AppTokens.brand,
    this.fontSize = 13.0,
  });

  final Widget valueWidget;
  final String label;
  final IconData icon;
  final Color accent;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return _StatCardShell(
      icon: icon,
      accent: accent,
      label: label,
      fontSize: fontSize,
      valueWidget: Align(
        alignment: AlignmentDirectional.centerStart,
        child: valueWidget,
      ),
    );
  }
}
