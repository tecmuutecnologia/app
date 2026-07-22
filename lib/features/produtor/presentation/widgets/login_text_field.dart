import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';

/// Widget reutilizável para campos de texto com estilo padrão do app.
class LoginTextField extends StatelessWidget {
  const LoginTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.labelText,
    this.autofillHints = const [],
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final List<String> autofillHints;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(BuildContext, String?)? validator;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: true,
        autofillHints: autofillHints,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelLarge.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primaryBackground,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTokens.secondary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).primaryBackground,
          suffixIcon: suffixIcon,
        ),
        style: FlutterFlowTheme.of(context).bodyLarge.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
            ),
        keyboardType: keyboardType,
        validator:
            validator != null ? (value) => validator!(context, value) : null,
      ),
    );
  }
}

/// Widget para campo de email com configurações padrão.
class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.validator,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String? Function(BuildContext, String?)? validator;

  @override
  Widget build(BuildContext context) {
    return LoginTextField(
      controller: controller,
      focusNode: focusNode,
      labelText: 'E-mail',
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
      validator: validator,
    );
  }
}

/// Widget para campo de senha com toggle de visibilidade.
class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isVisible,
    required this.onToggleVisibility,
    this.validator,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isVisible;
  final VoidCallback onToggleVisibility;
  final String? Function(BuildContext, String?)? validator;

  @override
  Widget build(BuildContext context) {
    return LoginTextField(
      controller: controller,
      focusNode: focusNode,
      labelText: 'Senha',
      autofillHints: const [AutofillHints.password],
      obscureText: !isVisible,
      validator: validator,
      suffixIcon: InkWell(
        onTap: onToggleVisibility,
        focusNode: FocusNode(skipTraversal: true),
        child: Icon(
          isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: FlutterFlowTheme.of(context).secondaryText,
          size: 24.0,
        ),
      ),
    );
  }
}
