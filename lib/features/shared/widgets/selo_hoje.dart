import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app/theme/flutter_flow_theme.dart';
import '/domain/animais/data_ultima_acao.dart';

/// Selo verde "Hoje" no card do animal, quando a ultima acao foi hoje.
///
/// Existia em tres copias — `listacompleta` com um `_selo` generico,
/// `exame_ginecologico` com as cores escritas no braco e `recria` com a
/// terceira. Cada tela nova repetia a condicao e o markup, e a condicao era a
/// parte perigosa: chamava `verificaDataAcaoDataAtual`, que lanca em data
/// malformada.
///
/// Encolhe sozinho quando nao e hoje, entao quem chama nao precisa de `if`.
class SeloHoje extends StatelessWidget {
  const SeloHoje({super.key, required this.dtUltimaAcao, this.agora});

  /// Data da ultima acao do animal, como gravada: `dd/MM/yyyy`.
  final String? dtUltimaAcao;

  /// Injetavel para o teste nao depender do relogio.
  final DateTime? agora;

  static const _verde = Color(0xFF048508);

  @override
  Widget build(BuildContext context) {
    if (!acaoFoiHoje(dtUltimaAcao, agora: agora)) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 3.0, 8.0, 3.0),
      decoration: BoxDecoration(
        color: _verde.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: _verde, size: 13.0),
          const SizedBox(width: 4.0),
          Text(
            'Hoje',
            style: FlutterFlowTheme.of(context).labelSmall.override(
                  font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                  color: _verde,
                  fontSize: 11.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
