import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';
import '/core/ui/secao_formulario.dart';
import '/features/animais/application/importar_animais.dart';

/// Fim da importação: quantos entraram, quantos ficaram de fora e o motivo de
/// cada linha recusada, para o técnico corrigir a planilha.
class ResultadoImportacaoView extends StatelessWidget {
  const ResultadoImportacaoView({
    super.key,
    required this.resultado,
    required this.aoVoltar,
  });

  final ResultadoImportacao resultado;
  final VoidCallback aoVoltar;

  @override
  Widget build(BuildContext context) {
    final recusadas = resultado.recusadas;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            children: [
              SecaoFormulario(
                icone: Icons.fact_check_outlined,
                titulo: 'Resultado',
                filhos: [
                  _Contagem(
                    texto: '${resultado.importados} importados',
                    cor: AppTokens.positivo,
                  ),
                  _Contagem(
                    texto: '${recusadas.length} não importados',
                    cor: recusadas.isEmpty
                        ? FlutterFlowTheme.of(context).secondaryText
                        : AppTokens.negativo,
                  ),
                ],
              ),
              if (recusadas.isNotEmpty)
                SecaoFormulario(
                  icone: Icons.report_outlined,
                  titulo: 'Não importados',
                  espaco: 8.0,
                  filhos: [
                    for (final r in recusadas)
                      Text(
                        'Linha ${r.linha} — ${r.identificacao} — ${r.motivo}',
                        style: GoogleFonts.readexPro(
                          fontSize: 13.0,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
        RodapeAcao(
          texto: 'Voltar para a lista',
          icone: Icons.list_alt_rounded,
          aoTocar: aoVoltar,
        ),
      ],
    );
  }
}

class _Contagem extends StatelessWidget {
  const _Contagem({required this.texto, required this.cor});

  final String texto;
  final Color cor;

  @override
  Widget build(BuildContext context) => Text(
        texto,
        style: GoogleFonts.readexPro(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: cor,
        ),
      );
}
