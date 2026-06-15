import 'package:flutter/material.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';

/// Card container do formulário de login com sombra e borda arredondada.
class LoginFormCard extends StatelessWidget {
  const LoginFormCard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 570.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: AppTokens.softShadow(context),
        borderRadius: BorderRadius.circular(AppTokens.radius),
      ),
      child: Align(
        alignment: const AlignmentDirectional(0.0, 0.0),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: child,
        ),
      ),
    );
  }
}
