import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app/theme/flutter_flow_theme.dart';
import 'app_card.dart';

/// Geometria da grade do menu de ações. Fica aqui junto do card porque a
/// altura da célula é derivada do conteúdo dele: padding 14 + tile 48 + gap 10
/// + caixa do rótulo 34 + padding 10 = 116, mais a borda de 1px em cima e
/// embaixo. Se o card mudar de altura, é este número que acompanha.
const SliverGridDelegateWithFixedCrossAxisCount menuAcaoGridDelegate =
    SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 3,
  crossAxisSpacing: 12.0,
  mainAxisSpacing: 12.0,
  mainAxisExtent: 124.0,
);

/// Título de seção do menu de ações.
class MenuAcaoCabecalho extends StatelessWidget {
  const MenuAcaoCabecalho({super.key, this.texto = 'Menu de Ações'});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 4.0),
      child: Text(
        texto,
        textAlign: TextAlign.start,
        style: FlutterFlowTheme.of(context).titleSmall.override(
              font: GoogleFonts.readexPro(
                fontWeight: FontWeight.w600,
                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
              ),
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 17.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
            ),
      ),
    );
  }
}

/// Card do menu de ações — a mesma célula para o menu do TÉCNICO e o do
/// PRODUTOR.
///
/// Ser um widget só é o ponto. As duas telas já tiveram cópias separadas desta
/// célula, e a consequência apareceu em produção: um bug de layout no badge foi
/// corrigido de um lado e continuou vivo do outro por não haver nada ligando os
/// dois. Qualquer ajuste visual daqui em diante vale para os dois menus.
///
/// Decisões que a estrutura carrega:
///
/// - **A caixa do rótulo tem altura fixa e o texto é ancorado no topo dela.**
///   Sem isso, um rótulo de duas linhas ("Trocar Produtor") empurra o ícone
///   para cima e ele sai do alinhamento dos vizinhos de uma linha — numa grade,
///   ícone desalinhado é o que faz a tela parecer inacabada.
/// - **Laranja é a moldura, roxo é o dado.** O card é definido por uma linha
///   laranja de 1px, sem sombra; ícone e badge usam o acento secundário.
/// - **O toque tem ripple**, recortado no raio do card. As duas grades nasceram
///   do FlutterFlow com splash/focus/hover/highlight em `transparent`, ou seja,
///   sem retorno visual nenhum ao tocar.
class MenuAcaoCard extends StatelessWidget {
  const MenuAcaoCard({
    super.key,
    required this.icone,
    required this.rotulo,
    required this.onTap,
    this.contador,
  });

  final IconData icone;
  final String rotulo;
  final VoidCallback onTap;

  /// Contagem exibida no badge. `null` ou `0` não desenha badge nenhum: zero
  /// significa "não há nada a fazer aqui", e um badge chamando atenção para o
  /// nada é ruído. Some o badge, sobra só o que realmente pede ação.
  final int? contador;

  static const double _raio = 18.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(_raio),
        border: AppTokens.brandBorder(context),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_raio),
          splashColor: AppTokens.brandTint,
          highlightColor: AppTokens.brandTintSoft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6.0, 14.0, 6.0, 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TileComContador(icone: icone, contador: contador),
                const SizedBox(height: 10.0),
                SizedBox(
                  height: 34.0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: AutoSizeText(
                      rotulo,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      minFontSize: 8.0,
                      // Sem isto o AutoSizeText prefere quebrar DENTRO da
                      // palavra a diminuir a fonte, e "Inseminações" vira
                      // "Inseminaçõe / s". Palavra longa agora encolhe.
                      wrapWords: false,
                      overflow: TextOverflow.ellipsis,
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                            font: GoogleFonts.readexPro(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 13.0,
                            letterSpacing: 0.0,
                            lineHeight: 1.25,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Tile do ícone com o contador preso no canto, como badge de app.
///
/// O badge fica ancorado ao tile, e não solto no canto do card, para que o
/// número pertença visualmente àquilo que ele conta.
class _TileComContador extends StatelessWidget {
  const _TileComContador({required this.icone, required this.contador});

  final IconData icone;
  final int? contador;

  @override
  Widget build(BuildContext context) {
    final tile = MenuIconTile(icon: icone, accent: AppTokens.secondary);
    if (contador == null || contador == 0) return tile;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        tile,
        Positioned(
          top: -6.0,
          right: -8.0,
          child: Container(
            height: 22.0,
            constraints: const BoxConstraints(minWidth: 22.0),
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            decoration: BoxDecoration(
              color: AppTokens.secondary,
              borderRadius: BorderRadius.circular(11.0),
              // O anel branco descola o badge do tile por baixo.
              border: Border.all(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                width: 2.0,
              ),
            ),
            // Center com os fatores em 1.0 centraliza SEM expandir. Usar a
            // propriedade `alignment` do Container aqui seria um bug: sob
            // constraints limitadas ele se expande para preencher o pai, que
            // foi exatamente como o badge do menu do produtor chegou a cobrir
            // o card inteiro.
            child: Center(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: Text(
                contador.toString(),
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      font: GoogleFonts.readexPro(
                        fontWeight: FontWeight.w700,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodySmall.fontStyle,
                      ),
                      color: Colors.white,
                      fontSize: 11.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w700,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodySmall.fontStyle,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
