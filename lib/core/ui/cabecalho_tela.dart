import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/core/ui/flutter_flow_icon_button.dart';
import '/core/ui/flutter_flow_util.dart';

/// Cabeçalho padrão das telas (`docs/padrao-layout-listas.md`): faixa reta em
/// degradê laranja→rosa com o botão de voltar e o título.
///
/// Nasceu do cabeçalho da Lista completa, mais baixo (era 100) e com os
/// cantos retos. Sem conexão o degradê fica mais claro, como a cor lisa
/// fazia nas telas antigas.
class CabecalhoTela extends StatelessWidget implements PreferredSizeWidget {
  const CabecalhoTela({
    super.key,
    required this.titulo,
    this.online = true,
    this.aoVoltar,
    this.acoes = const [],
  });

  final String titulo;
  final bool online;

  /// Padrão: `context.safePop()`. Telas com modo de seleção passam o próprio
  /// (ex.: voltar só cancela a seleção).
  final VoidCallback? aoVoltar;

  /// Botões à direita do título (opcional).
  final List<Widget> acoes;

  static const altura = 64.0;
  static const _inicio = Color(0xFFF75E38);
  static const _fim = Color(0xFFEC3B5B);

  @override
  Size get preferredSize => const Size.fromHeight(altura);

  @override
  Widget build(BuildContext context) {
    final cores = online
        ? const [_inicio, _fim]
        // ignore: deprecated_member_use
        : [_inicio.withOpacity(0.7), _fim.withOpacity(0.7)];
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      // Sem o "escurecer ao rolar" do Material 3 por cima do degradê.
      scrolledUnderElevation: 0.0,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: altura,
      titleSpacing: 0.0,
      // `SizedBox.expand`: sem ele o fundo não tem tamanho (o AppBar passa
      // restrições soltas ao flexibleSpace) e o degradê não aparece.
      flexibleSpace: SizedBox.expand(
          child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: cores,
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
          ),
        ),
      )),
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4.0),
            child: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 48.0,
              icon: const Icon(Icons.arrow_back_rounded,
                  color: Colors.white, size: 26.0),
              onPressed: aoVoltar ?? () => context.safePop(),
            ),
          ),
          const SizedBox(width: 4.0),
          Expanded(
            child: Text(
              titulo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      actions: acoes,
    );
  }
}
