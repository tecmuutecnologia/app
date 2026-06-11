import 'package:flutter/material.dart';

/// Container de fundo com gradiente e imagem para tela de login.
class LoginBackground extends StatelessWidget {
  const LoginBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.none,
          alignment: const AlignmentDirectional(0.3, 0.4),
          image: Image.asset(
            'assets/images/farmer-cowshed-looking-after-cows.jpg',
          ).image,
        ),
        gradient: const LinearGradient(
          colors: [Color(0xFFF75E38), Color(0xFFEC3B5B)],
          stops: [0.0, 1.0],
          begin: AlignmentDirectional(0.87, -1.0),
          end: AlignmentDirectional(-0.87, 1.0),
        ),
      ),
      alignment: const AlignmentDirectional(0.0, -1.0),
      child: child,
    );
  }
}

/// Widget do logo do app para tela de login.
class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 70.0, 0.0, 32.0),
      child: Container(
        width: 200.0,
        height: 140.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
        ),
        alignment: const AlignmentDirectional(0.0, 0.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            'assets/images/logo-2.png',
            width: 130.0,
            height: 130.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
