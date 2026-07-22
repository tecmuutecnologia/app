import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_widgets.dart';

/// Botão de login com estilo padrão do app.
class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.onPressed,
    this.text = 'Entrar',
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return FFButtonWidget(
      onPressed: isLoading ? null : onPressed,
      text: text,
      options: FFButtonOptions(
        width: double.infinity,
        height: 44.0,
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        color: const Color(0xFFF75E38),
        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
              ),
              color: Colors.white,
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
            ),
        elevation: 3.0,
        borderSide: const BorderSide(
          color: Colors.transparent,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}
