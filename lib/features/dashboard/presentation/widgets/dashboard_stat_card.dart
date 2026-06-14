import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';

/// Card de estatística para o dashboard com valor e label.
class DashboardStatCard extends StatelessWidget {
  const DashboardStatCard({
    super.key,
    required this.value,
    required this.label,
    this.fontSize = 13.0,
  });

  final String value;
  final String label;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(AppTokens.radius),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: Padding(
        padding: AppTokens.cardPadding,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: FlutterFlowTheme.of(context).displaySmall.override(
                    font: GoogleFonts.outfit(
                      fontWeight:
                          FlutterFlowTheme.of(context).displaySmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).displaySmall.fontStyle,
                    ),
                    color: const Color(0xFFEC3B5B),
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).displaySmall.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).displaySmall.fontStyle,
                  ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
              child: Text(
                label,
                style: FlutterFlowTheme.of(context).labelMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).labelMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelMedium.fontStyle,
                      ),
                      fontSize: fontSize,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).labelMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card de estatística com loading indicator.
class DashboardStatCardWithStream extends StatelessWidget {
  const DashboardStatCardWithStream({
    super.key,
    required this.valueWidget,
    required this.label,
    this.fontSize = 13.0,
  });

  final Widget valueWidget;
  final String label;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(AppTokens.radius),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: Padding(
        padding: AppTokens.cardPadding,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            valueWidget,
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
              child: Text(
                label,
                style: FlutterFlowTheme.of(context).labelMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).labelMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelMedium.fontStyle,
                      ),
                      fontSize: fontSize,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).labelMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
