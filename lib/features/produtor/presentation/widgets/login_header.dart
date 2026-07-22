import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/theme/flutter_flow_theme.dart';

/// Header do formulário de login com título e subtítulo.
class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
    this.title = 'Login',
    this.subtitle = 'Preencha os campos\nabaixo para entrar',
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context).displaySmall.override(
                font: GoogleFonts.outfit(
                  fontWeight:
                      FlutterFlowTheme.of(context).displaySmall.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).displaySmall.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight:
                    FlutterFlowTheme.of(context).displaySmall.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).displaySmall.fontStyle,
              ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 24.0),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).labelLarge.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelLarge.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                ),
          ),
        ),
      ],
    );
  }
}
