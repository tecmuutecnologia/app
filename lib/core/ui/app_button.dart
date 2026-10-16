import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app/theme/flutter_flow_theme.dart';
import 'app_card.dart';

/// Peso visual do botão. Uma tela tem UMA ação [principal]; o resto é
/// [secundario]. Antes cada botão ganhava uma cor própria (marrom, laranja,
/// três verdes) e a tela não dizia qual era o caminho esperado.
enum AppButtonTipo { principal, secundario }

/// Botão padrão do design-system: largura total, cantos de [AppTokens.radiusSmall],
/// sem sombra. Principal = preenchido na cor da marca; secundário = contorno.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.tipo = AppButtonTipo.principal,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonTipo tipo;

  @override
  Widget build(BuildContext context) {
    final principal = tipo == AppButtonTipo.principal;
    final corTexto = principal ? Colors.white : AppTokens.brand;
    final forma = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
    );
    final estilo = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size.fromHeight(50.0)),
      shape: WidgetStatePropertyAll(forma),
      elevation: const WidgetStatePropertyAll(0.0),
      backgroundColor:
          WidgetStatePropertyAll(principal ? AppTokens.brand : Colors.white),
      foregroundColor: WidgetStatePropertyAll(corTexto),
      overlayColor: WidgetStatePropertyAll(
          principal ? Colors.white24 : AppTokens.brandTint),
      side: WidgetStatePropertyAll(principal
          ? BorderSide.none
          : const BorderSide(color: AppTokens.brand, width: 1.5)),
      textStyle: WidgetStatePropertyAll(
        FlutterFlowTheme.of(context).titleSmall.override(
              font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
              color: corTexto,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
            ),
      ),
    );

    return SizedBox(
      width: double.infinity,
      child: icon == null
          ? ElevatedButton(
              onPressed: onPressed, style: estilo, child: Text(text))
          : ElevatedButton.icon(
              onPressed: onPressed,
              style: estilo,
              icon: Icon(icon, size: 20.0),
              label: Text(text),
            ),
    );
  }
}
