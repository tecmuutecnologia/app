import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';

/// Medidas do padrão de telas de lista (ver `docs/padrao-layout-listas.md`).
///
/// Ficam juntas para que cada tela migrada use exatamente os mesmos números:
/// pequenas diferenças de margem entre telas são o que faz o app parecer
/// "montado por partes".
class LayoutLista {
  LayoutLista._();

  /// Margem lateral do conteúdo do painel (busca, linhas, abas).
  static const double margemPainel = 10.0;

  /// Altura do campo de busca e dos botões que ficam ao lado dele.
  static const double alturaControle = 44.0;

  /// Altura das abas e dos chips de seleção (ordem etc.).
  static const double alturaChip = 36.0;

  /// Raio dos controles do painel (busca, abas, chips).
  static const double raio = 10.0;

  /// Espaço entre linhas do painel.
  static const double espacoLinhas = 8.0;
}

/// Painel branco, reto, com sombra, que fica entre o cabeçalho e a lista:
/// busca (com uma ação opcional ao lado), linhas extras (ex.: ordenação) e as
/// abas. A sombra o separa da lista, que rola sobre o fundo cinza da tela
/// (`primaryBackground`).
class PainelLista extends StatelessWidget {
  const PainelLista({
    super.key,
    required this.busca,
    this.acaoBusca,
    this.linhas = const [],
    this.abas,
  });

  /// Normalmente um [CampoBuscaLista].
  final Widget busca;

  /// Botão ao lado da busca (ex.: `BotaoOrdenacao` com
  /// `alturaMinima: LayoutLista.alturaControle`).
  final Widget? acaoBusca;

  /// Linhas abaixo da busca, já com a margem lateral do painel.
  final List<Widget> linhas;

  /// Normalmente um `AbasPilula`, que traz a própria margem lateral para
  /// poder rolar até a borda da tela.
  final Widget? abas;

  @override
  Widget build(BuildContext context) {
    const margem = LayoutLista.margemPainel;
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: AppTokens.softShadow(context),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(margem, 10.0, margem, 0.0),
            child: Row(
              children: [
                Expanded(child: busca),
                if (acaoBusca != null) ...[
                  const SizedBox(width: 8.0),
                  acaoBusca!,
                ],
              ],
            ),
          ),
          for (final linha in linhas)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  margem, LayoutLista.espacoLinhas, margem, 0.0),
              child: linha,
            ),
          if (abas != null) ...[
            const SizedBox(height: 6.0),
            abas!,
          ] else
            const SizedBox(height: 12.0),
        ],
      ),
    );
  }
}

/// Campo de busca baixo (44pt) do padrão de listas.
///
/// Usa dica em vez de rótulo flutuante (o rótulo reserva altura para subir) e
/// tira a caixa mínima de 48pt que o Material dá aos ícones — as duas coisas
/// deixavam o campo "gordo".
class CampoBuscaLista extends StatelessWidget {
  const CampoBuscaLista({
    super.key,
    required this.controller,
    required this.onChanged,
    this.focusNode,
    this.dica = 'Pesquisar animal',
  });

  final TextEditingController controller;
  final FocusNode? focusNode;

  /// Chamado ao digitar e ao limpar (com '').
  final ValueChanged<String> onChanged;

  final String dica;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    OutlineInputBorder borda(Color cor, double largura) => OutlineInputBorder(
          borderSide: BorderSide(color: cor, width: largura),
          borderRadius: BorderRadius.circular(LayoutLista.raio),
        );

    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      maxLines: 1,
      style: GoogleFonts.readexPro(fontSize: 14.0, color: tema.primaryText),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 13.0),
        hintText: dica,
        hintStyle:
            GoogleFonts.readexPro(fontSize: 14.0, color: tema.secondaryText),
        filled: true,
        fillColor: tema.primaryBackground,
        enabledBorder: borda(Colors.transparent, 1.0),
        focusedBorder: borda(AppTokens.secondary, 1.5),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 40.0, minHeight: 40.0),
        prefixIcon: Icon(Icons.search_rounded, color: tema.secondaryText),
        suffixIconConstraints:
            const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
        suffixIcon: controller.text.isNotEmpty
            ? InkWell(
                onTap: () {
                  controller.clear();
                  onChanged('');
                },
                child: Icon(Icons.clear, color: tema.secondaryText, size: 18.0),
              )
            : null,
      ),
    );
  }
}
