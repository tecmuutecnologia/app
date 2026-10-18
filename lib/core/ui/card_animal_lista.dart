import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/domain/animais/classificacao_animal.dart';

/// Peças do card de animal do padrão de listas
/// (`docs/padrao-layout-listas.md`). Desenho de referência: tela de secas.
///
/// ```
/// CartaoLista ─ branco, raio 16, sombra, margem 12/6, toque → prontuário
///   └ ConteudoCardAnimal
///       ├ AvatarGrupoAnimal + título (+ selo opcional)
///       ├ FaixaInfoAnimal [InfoAnimal | InfoAnimal | …]   ← informações
///       └ LinhaAcoes [botão | botão | …]                   ← ações por último
/// ```

/// "Nome - brinco", só o nome ou só o brinco — o mesmo título em todas as
/// listas.
String tituloNomeBrinco(String nome, int? brinco) {
  if (nome.isNotEmpty && brinco != null && brinco != -1) {
    return '$nome - $brinco';
  }
  if (nome.isNotEmpty) return nome;
  return brinco?.toString() ?? '';
}

/// Moldura do card: branco, cantos `AppTokens.radius`, sombra suave.
/// [marcado] contorna na cor da marca (modo de seleção).
class CartaoLista extends StatelessWidget {
  const CartaoLista({
    super.key,
    required this.child,
    this.aoTocar,
    this.aoSegurar,
    this.marcado = false,
  });

  final Widget child;
  final VoidCallback? aoTocar;
  final VoidCallback? aoSegurar;
  final bool marcado;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12.0, 6.0, 12.0, 6.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: AppTokens.softShadow(context),
          borderRadius: BorderRadius.circular(AppTokens.radius),
          border: Border.all(
            color: marcado ? AppTokens.brand : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
          child: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: aoTocar,
            onLongPress: aoSegurar,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Conteúdo do card: avatar + título no topo; abaixo, a faixa de
/// informações e por último as ações, ambas na largura TOTAL do card (assim as
/// datas cabem inteiras, com ano).
class ConteudoCardAnimal extends StatelessWidget {
  const ConteudoCardAnimal({
    super.key,
    required this.grupo,
    required this.titulo,
    this.subtitulo,
    this.selo,
    this.info = const [],
    this.acoes,
  });

  /// Grupo do animal — define o avatar (VAC/NOV).
  final String grupo;
  final String titulo;

  /// Linha cinza abaixo do título (ex.: o status do animal); vazia = sem
  /// linha.
  final String? subtitulo;

  /// Etiqueta curta à direita do título (ex.: [SeloStatus] "Inseminada").
  final Widget? selo;

  /// Tiles da faixa (normalmente [InfoAnimal]); vazia = sem faixa.
  final List<Widget> info;

  /// Normalmente uma [LinhaAcoes].
  final Widget? acoes;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AvatarGrupoAnimal(grupo: grupo),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tema.bodyLarge.override(
                      font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitulo?.isNotEmpty ?? false)
                    Text(
                      subtitulo!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.readexPro(
                          fontSize: 13.0, color: tema.secondaryText),
                    ),
                ],
              ),
            ),
            if (selo != null) ...[
              const SizedBox(width: 8.0),
              selo!,
            ],
          ],
        ),
        if (info.isNotEmpty) ...[
          const SizedBox(height: 12.0),
          FaixaInfoAnimal(tiles: info),
        ],
        if (acoes != null) ...[
          const SizedBox(height: 12.0),
          acoes!,
        ],
      ],
    );
  }
}

/// Avatar circular do grupo: VAC (marca), NOV (roxo) ou N/C.
class AvatarGrupoAnimal extends StatelessWidget {
  const AvatarGrupoAnimal({super.key, required this.grupo});

  final String grupo;

  @override
  Widget build(BuildContext context) {
    final (cor, sigla) = ehVaca(grupo)
        ? (AppTokens.brand, 'VAC')
        : ehNovilha(grupo)
            ? (AppTokens.secondary, 'NOV')
            : (FlutterFlowTheme.of(context).secondaryText, 'N/C');
    return Container(
      width: 44.0,
      height: 44.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
      child: Text(
        sigla,
        style: GoogleFonts.readexPro(
          color: Colors.white,
          fontSize: 13.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Etiqueta de status ao lado do título (texto curto, fundo tonalizado).
class SeloStatus extends StatelessWidget {
  const SeloStatus(this.texto, {super.key, this.cor = AppTokens.positivo});

  final String texto;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: cor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Text(
        texto,
        style: GoogleFonts.readexPro(
          color: cor,
          fontSize: 11.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Faixa cinza que agrupa os [InfoAnimal], separados por divisores.
class FaixaInfoAnimal extends StatelessWidget {
  const FaixaInfoAnimal({super.key, required this.tiles});

  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: tema.primaryBackground,
        borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(12.0, 10.0, 12.0, 10.0),
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (var i = 0; i < tiles.length; i++) ...[
              if (i > 0)
                VerticalDivider(
                    width: 17.0, thickness: 1.0, color: tema.alternate),
              Expanded(child: tiles[i]),
            ],
          ],
        ),
      ),
    );
  }
}

/// Rótulo pequeno + valor destacado. Valor vazio vira '—' para o usuário
/// perceber que o dado não existe.
///
/// [ehData] usa `FittedBox` em vez de reticências: numa tela estreita a data
/// ENCOLHE em vez de perder o ano ("20/12/2026" nunca vira "20/12..."). Para
/// texto livre (ex.: motivo do descarte) usa reticências, que é o correto.
class InfoAnimal extends StatelessWidget {
  const InfoAnimal(
    this.rotulo,
    this.valor, {
    super.key,
    this.destaque = false,
    this.ehData = true,
  });

  final String rotulo;
  final String valor;
  final bool destaque;
  final bool ehData;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final estiloValor = GoogleFonts.readexPro(
      color: destaque ? AppTokens.brand : tema.primaryText,
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
    );
    final texto = valor.isEmpty ? '—' : valor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          rotulo,
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.readexPro(
            color: tema.secondaryText,
            fontSize: 11.0,
          ),
        ),
        const SizedBox(height: 3.0),
        if (ehData)
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(texto, maxLines: 1, style: estiloValor),
          )
        else
          Text(
            texto,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: estiloValor,
          ),
      ],
    );
  }
}

/// Ações do card dividindo a largura em partes iguais (botões do mesmo
/// tamanho), separadas por 8.
class LinhaAcoes extends StatelessWidget {
  const LinhaAcoes({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: 8.0),
          Expanded(child: children[i]),
        ],
      ],
    );
  }
}

/// Estilo dos botões de ação do card (altura 40, texto branco 12, cantos
/// `radiusSmall`).
FFButtonOptions opcoesBotaoCard(BuildContext context, Color cor) {
  final tema = FlutterFlowTheme.of(context);
  const corTexto = Colors.white;
  return FFButtonOptions(
    height: 40.0,
    padding: const EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 6.0, 0.0),
    iconPadding: EdgeInsetsDirectional.zero,
    color: cor,
    iconColor: corTexto,
    textStyle: tema.titleSmall.override(
      font: GoogleFonts.readexPro(fontWeight: tema.titleSmall.fontWeight),
      color: corTexto,
      fontSize: 12.0,
      letterSpacing: 0.0,
    ),
    elevation: 0.0,
    borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
    borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
    // Sem este par, o `color` acima pinta também o estado desabilitado — foi
    // assim que o "DG +" da lista completa ficou com cara de clicável sem
    // responder ao toque.
    disabledColor: tema.primaryBackground,
    disabledTextColor: tema.secondaryText,
  );
}
