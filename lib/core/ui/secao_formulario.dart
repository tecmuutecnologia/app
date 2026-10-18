import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/painel_lista.dart';

/// Seção de uma tela de formulário (`docs/padrao-layout-listas.md`): card
/// branco com ícone e título, um texto de ajuda opcional e o conteúdo.
class SecaoFormulario extends StatelessWidget {
  const SecaoFormulario({
    super.key,
    required this.icone,
    required this.titulo,
    required this.filhos,
    this.ajuda,
    this.acao,
    this.espaco = 12.0,
  });

  final IconData icone;
  final String titulo;
  final List<Widget> filhos;

  /// Linha cinza abaixo do título (ex.: "Deixe vazio para incluir todos").
  final String? ajuda;

  /// Botão à direita do título (ex.: "Marcar todas").
  final Widget? acao;

  /// Espaço entre os [filhos].
  final double espaco;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
      padding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 16.0),
      decoration: BoxDecoration(
        color: tema.secondaryBackground,
        borderRadius: BorderRadius.circular(AppTokens.radius),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icone, color: AppTokens.brand, size: 20.0),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  titulo,
                  style: GoogleFonts.readexPro(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: tema.primaryText,
                  ),
                ),
              ),
              if (acao != null) acao!,
            ],
          ),
          if (ajuda != null) ...[
            const SizedBox(height: 2.0),
            Text(ajuda!,
                style: GoogleFonts.readexPro(
                    fontSize: 12.0, color: tema.secondaryText)),
          ],
          const SizedBox(height: 12.0),
          for (var i = 0; i < filhos.length; i++) ...[
            if (i > 0) SizedBox(height: espaco),
            filhos[i],
          ],
        ],
      ),
    );
  }
}

/// Rodapé fixo com a ação principal da tela (use em
/// `Scaffold.bottomNavigationBar`): sempre visível, laranja, 48pt.
///
/// [aoTocar] nulo deixa o botão desabilitado; [aviso] explica o porquê, numa
/// linha acima dele (melhor que esconder o botão, que deixava o usuário sem
/// saber como salvar). [ocupado] mostra o carregamento e bloqueia toque duplo.
class RodapeAcao extends StatelessWidget {
  const RodapeAcao({
    super.key,
    required this.texto,
    required this.icone,
    required this.aoTocar,
    this.aviso,
    this.ocupado = false,
    this.textoOcupado,
  });

  final String texto;
  final IconData icone;
  final VoidCallback? aoTocar;
  final String? aviso;
  final bool ocupado;
  final String? textoOcupado;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final habilitado = aoTocar != null && !ocupado;
    return Container(
      decoration: BoxDecoration(
        color: tema.secondaryBackground,
        boxShadow: const [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 16.0, offset: Offset(0, -4)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (aviso != null && aoTocar == null) ...[
              Text(aviso!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.readexPro(
                      fontSize: 12.0, color: tema.secondaryText)),
              const SizedBox(height: 6.0),
            ],
            FFButtonWidget(
              onPressed: habilitado ? aoTocar : null,
              text: ocupado ? (textoOcupado ?? texto) : texto,
              icon: ocupado
                  ? const SizedBox(
                      width: 16.0,
                      height: 16.0,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.0, color: Colors.white),
                    )
                  : Icon(icone, size: 20.0),
              options: FFButtonOptions(
                width: double.infinity,
                height: 48.0,
                padding: EdgeInsets.zero,
                iconPadding: EdgeInsets.zero,
                color: AppTokens.brand,
                textStyle: GoogleFonts.readexPro(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600),
                elevation: 0.0,
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(LayoutLista.raio),
                // Ocupado continua laranja (mais claro); desabilitado de fato
                // fica cinza, para não parecer clicável.
                disabledColor: ocupado
                    // ignore: deprecated_member_use
                    ? AppTokens.brand.withOpacity(0.7)
                    : tema.alternate,
                disabledTextColor: ocupado ? Colors.white : tema.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
