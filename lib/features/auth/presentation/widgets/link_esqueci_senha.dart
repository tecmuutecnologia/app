import '/core/auth/firebase_auth/auth_util.dart';
import '/app/theme/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

/// Envia o e-mail de redefinição de senha do Firebase para o endereço
/// digitado no login. É também o caminho para o produtor trocar a senha
/// padrão (o CPF), como o e-mail de boas-vindas recomenda.
class LinkEsqueciSenha extends StatelessWidget {
  const LinkEsqueciSenha({super.key, required this.emailController});

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: TextButton(
        onPressed: () async {
          final email = emailController.text.trim();
          if (email.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  'Digite seu e-mail no campo acima para receber o link de redefinição de senha.'),
            ));
            return;
          }
          await authManager.resetPassword(email: email, context: context);
        },
        child: Text(
          'Esqueci minha senha',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                color: const Color(0xFFF75E38),
                letterSpacing: 0.0,
              ),
        ),
      ),
    );
  }
}
