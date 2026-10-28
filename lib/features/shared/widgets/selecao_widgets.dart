import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';
import '/features/shared/application/selecao_animais.dart';

/// Barra acima da lista para marcar vários animais (Descarte, Inseminações).
///
/// Fora da seleção: "[resumo] · Selecionar". Na seleção: caixinha de
/// "Selecionar todos" (só os [visiveis]), a contagem e "Cancelar".
class BarraSelecao extends StatelessWidget {
  const BarraSelecao({
    super.key,
    required this.selecao,
    required this.visiveis,
    required this.resumo,
    required this.aoMudar,
  });

  final SelecaoAnimais selecao;

  /// Chaves dos animais visíveis agora (com a busca aplicada).
  final List<String> visiveis;

  /// Texto fora da seleção, ex.: "5 animais no descarte".
  final String resumo;

  /// Chamado com a alteração a aplicar; a tela faz o setState.
  final void Function(VoidCallback alteracao) aoMudar;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final estiloTexto =
        GoogleFonts.readexPro(color: tema.secondaryText, fontSize: 13.0);
    final estiloAcao = GoogleFonts.readexPro(fontWeight: FontWeight.w600);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 8.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: selecao.ativa
            ? Row(
                children: [
                  Checkbox(
                    value: selecao.todosMarcados(visiveis),
                    onChanged: (_) =>
                        aoMudar(() => selecao.alternarTodos(visiveis)),
                    activeColor: AppTokens.brand,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                  ),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: Text(
                      selecao.quantidade == 0
                          ? 'Selecionar todos'
                          : '${rotuloAnimais(selecao.quantidade)} '
                              '${selecao.quantidade == 1 ? 'selecionado' : 'selecionados'}',
                      style: estiloTexto.copyWith(
                          color: tema.primaryText, fontWeight: FontWeight.w600),
                    ),
                  ),
                  TextButton(
                    onPressed: () => aoMudar(selecao.sair),
                    style: TextButton.styleFrom(
                        foregroundColor: tema.secondaryText,
                        textStyle: estiloAcao),
                    child: const Text('Cancelar'),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(child: Text(resumo, style: estiloTexto)),
                  TextButton.icon(
                    onPressed: () => aoMudar(() => selecao.entrar()),
                    icon: const Icon(Icons.checklist_rounded, size: 18.0),
                    label: const Text('Selecionar'),
                    style: TextButton.styleFrom(
                        foregroundColor: AppTokens.brand,
                        textStyle: estiloAcao),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Caixinha do card no modo de seleção, na altura dos botões que ela
/// substitui para o card não pular.
class MarcadorSelecao extends StatelessWidget {
  const MarcadorSelecao({
    super.key,
    required this.marcado,
    required this.aoAlternar,
  });

  final bool marcado;
  final VoidCallback aoAlternar;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: Row(
        children: [
          Checkbox(
            value: marcado,
            onChanged: (_) => aoAlternar(),
            activeColor: AppTokens.brand,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)),
          ),
          const SizedBox(width: 4.0),
          Text(
            marcado ? 'Selecionado' : 'Toque para selecionar',
            style: GoogleFonts.readexPro(
              color: marcado
                  ? AppTokens.brand
                  : FlutterFlowTheme.of(context).secondaryText,
              fontSize: 13.0,
              fontWeight: marcado ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
