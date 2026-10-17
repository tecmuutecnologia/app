import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app/theme/flutter_flow_theme.dart';
import 'app_card.dart';

/// Pergunta antes de uma ação e devolve `true` só se o usuário confirmar.
/// Cancelar ou tocar fora devolve `false`.
///
/// Fecha APENAS o diálogo. As confirmações da tela de secagem chamavam um
/// `Navigator.pop(context)` a mais depois da resposta, que fechava a tela
/// junto: a cada vaca eliminada o técnico voltava ao menu.
///
/// Segue o resumo da visita: confirmar preenchido na cor da marca e cancelar
/// em contorno. [perigosa] pinta o confirmar de vermelho, reservado para o que
/// apaga dado.
Future<bool> confirmarAcao(
  BuildContext context, {
  required String titulo,
  String? mensagem,
  String textoConfirmar = 'Confirmar',
  bool perigosa = false,
}) async {
  final resposta = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => _DialogoConfirmacao(
      titulo: titulo,
      mensagem: mensagem,
      textoConfirmar: textoConfirmar,
      perigosa: perigosa,
    ),
  );
  return resposta ?? false;
}

class _DialogoConfirmacao extends StatelessWidget {
  const _DialogoConfirmacao({
    required this.titulo,
    required this.mensagem,
    required this.textoConfirmar,
    required this.perigosa,
  });

  final String titulo;
  final String? mensagem;
  final String textoConfirmar;
  final bool perigosa;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final cor = perigosa ? AppTokens.negativo : AppTokens.brand;
    final rotulo = GoogleFonts.readexPro(fontWeight: FontWeight.w600);
    final forma = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
    );

    return Dialog(
      backgroundColor: tema.secondaryBackground,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTokens.radius),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: GoogleFonts.readexPro(
                color: tema.primaryText,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (mensagem != null) ...[
              const SizedBox(height: 8.0),
              Text(
                mensagem!,
                style: GoogleFonts.readexPro(
                    color: tema.secondaryText, fontSize: 14.0),
              ),
            ],
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46.0),
                      shape: forma,
                      foregroundColor: tema.primaryText,
                      side: BorderSide(color: tema.alternate, width: 1.5),
                      textStyle: rotulo,
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ButtonStyle(
                      minimumSize:
                          const WidgetStatePropertyAll(Size.fromHeight(46.0)),
                      shape: WidgetStatePropertyAll(forma),
                      backgroundColor: WidgetStatePropertyAll(cor),
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                      textStyle: WidgetStatePropertyAll(rotulo),
                    ),
                    child: Text(textoConfirmar),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
