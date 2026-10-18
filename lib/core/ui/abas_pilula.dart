import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';
import '/core/ui/painel_lista.dart';

/// Uma aba do [AbasPilula]: rótulo e, opcionalmente, quantos itens ela tem.
class AbaPilula {
  const AbaPilula(this.rotulo, {this.contagem});

  final String rotulo;
  final int? contagem;
}

/// Seletor de abas compacto em pílulas, com contador por aba.
///
/// Substitui o `FlutterFlowButtonTabBar` de botões altos: as pílulas têm a
/// altura de um chip, e o contador deixa o técnico ver quantos animais há em
/// cada aba sem precisar abrir uma por uma. Segue o [controller] também
/// durante o arrasto entre abas (não só ao soltar), e rola sozinho para
/// manter a aba ativa visível.
class AbasPilula extends StatefulWidget {
  const AbasPilula({
    super.key,
    required this.controller,
    required this.abas,
    this.cor = AppTokens.secondary,
    // Folga vertical para a sombra da pílula ativa não ser cortada pelo
    // recorte do scroll.
    this.padding = const EdgeInsets.fromLTRB(
        LayoutLista.margemPainel, 4.0, LayoutLista.margemPainel, 12.0),
  });

  final TabController controller;
  final List<AbaPilula> abas;
  final Color cor;
  final EdgeInsets padding;

  @override
  State<AbasPilula> createState() => _AbasPilulaState();
}

class _AbasPilulaState extends State<AbasPilula> {
  late List<GlobalKey> _chaves;
  int _ativa = 0;

  @override
  void initState() {
    super.initState();
    _chaves = List.generate(widget.abas.length, (_) => GlobalKey());
    _ativa = widget.controller.index;
    widget.controller.animation?.addListener(_aoAnimar);
  }

  @override
  void didUpdateWidget(AbasPilula old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller.animation?.removeListener(_aoAnimar);
      widget.controller.animation?.addListener(_aoAnimar);
    }
    if (old.abas.length != widget.abas.length) {
      _chaves = List.generate(widget.abas.length, (_) => GlobalKey());
    }
  }

  @override
  void dispose() {
    widget.controller.animation?.removeListener(_aoAnimar);
    super.dispose();
  }

  /// A aba "ativa" é a mais próxima da posição da animação: no meio do
  /// arrasto a pílula já troca, em vez de esperar o dedo soltar.
  void _aoAnimar() {
    final valor = widget.controller.animation!.value.round();
    if (valor == _ativa) return;
    setState(() => _ativa = valor);
    final ctx = _chaves[valor].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.5,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: widget.padding,
      child: Row(
        children: [
          for (var i = 0; i < widget.abas.length; i++) ...[
            if (i > 0) const SizedBox(width: 8.0),
            _Pilula(
              key: _chaves[i],
              aba: widget.abas[i],
              ativa: i == _ativa,
              cor: widget.cor,
              onTap: () => widget.controller.animateTo(i),
            ),
          ],
        ],
      ),
    );
  }
}

class _Pilula extends StatelessWidget {
  const _Pilula({
    super.key,
    required this.aba,
    required this.ativa,
    required this.cor,
    required this.onTap,
  });

  final AbaPilula aba;
  final bool ativa;
  final Color cor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final corTexto = ativa ? Colors.white : tema.secondaryText;
    const duracao = Duration(milliseconds: 220);

    return Semantics(
      selected: ativa,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: duracao,
          curve: Curves.easeOutCubic,
          height: LayoutLista.alturaChip,
          padding: EdgeInsets.fromLTRB(
              14.0, 0.0, aba.contagem == null ? 14.0 : 7.0, 0.0),
          decoration: BoxDecoration(
            color: ativa ? cor : tema.primaryBackground,
            borderRadius: BorderRadius.circular(LayoutLista.raio),
            boxShadow: ativa
                ? [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: cor.withOpacity(0.28),
                      blurRadius: 8.0,
                      offset: const Offset(0.0, 3.0),
                    ),
                  ]
                : const [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: duracao,
                style: GoogleFonts.readexPro(
                  fontSize: 14.0,
                  fontWeight: ativa ? FontWeight.w600 : FontWeight.w500,
                  color: corTexto,
                ),
                child: Text(aba.rotulo),
              ),
              if (aba.contagem != null) ...[
                const SizedBox(width: 8.0),
                Container(
                  // Altura fixa: com `alignment` o container se esticaria
                  // até a altura da aba inteira.
                  height: 22.0,
                  constraints: const BoxConstraints(minWidth: 22.0),
                  padding: const EdgeInsets.symmetric(horizontal: 7.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ativa
                        // ignore: deprecated_member_use
                        ? Colors.white.withOpacity(0.22)
                        : tema.secondaryBackground,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Text(
                    '${aba.contagem}',
                    style: GoogleFonts.readexPro(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: ativa ? Colors.white : tema.primaryText,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
