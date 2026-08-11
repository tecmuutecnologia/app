import 'package:flutter/material.dart';

import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';

/// Identidade visual de cada seção da ficha.
///
/// A tela antiga usava sete matizes saturados em blocos de cor cheia. O
/// problema não era ter cor — era a saturação e a área. Aqui o mesmo matiz
/// aparece em 12% no fundo do tile e cheio só no ícone e na espinha, que é o
/// padrão que o app já usa nos cartões do menu.
///
/// As cores têm luminosidade parecida entre si de propósito: variam em matiz,
/// não em peso, então nenhuma seção grita mais alto que as outras.
class IdentidadeSecao {
  const IdentidadeSecao(this.icone, this.cor);

  final IconData icone;
  final Color cor;

  static const inseminacoes =
      IdentidadeSecao(Icons.water_drop_rounded, Color(0xFF12A594));
  static const acoes = IdentidadeSecao(Icons.bolt_rounded, Color(0xFFD97706));
  static const abortos =
      IdentidadeSecao(Icons.heart_broken_rounded, Color(0xFFDC2626));
  static const diagnosticos =
      IdentidadeSecao(Icons.pregnant_woman_rounded, Color(0xFF7B61FF));
  static const cios =
      IdentidadeSecao(Icons.autorenew_rounded, Color(0xFF2563EB));
  static const vacinas =
      IdentidadeSecao(Icons.vaccines_rounded, Color(0xFF0891B2));
  static const exames =
      IdentidadeSecao(Icons.biotech_rounded, Color(0xFF4F46E5));
  static const doencas =
      IdentidadeSecao(Icons.healing_rounded, Color(0xFFE11D48));
}

/// Cabeçalho de uma seção da ficha: rótulo, filete até a borda e "Ver mais".
///
/// A tela usava oito blocos de cor cheia — amarelo, vermelho, magenta, azul,
/// oliva, verde, índigo — cada um um `FFButtonWidget` cujo `onPressed` só fazia
/// `print`. Sete matizes saturados competindo, e as seções sem registro
/// ocupando um bloco inteiro sem conteúdo nenhum.
///
/// O prontuário é uma ficha clínica, então passa a se ler como uma. A cor sai
/// da decoração e vai só para onde carrega informação.
class TituloSecao extends StatelessWidget {
  const TituloSecao({
    super.key,
    required this.titulo,
    required this.identidade,
    this.onVerMais,
  });

  final String titulo;

  final IdentidadeSecao identidade;

  /// Nulo esconde o atalho — seções sem tela própria não o oferecem.
  final VoidCallback? onVerMais;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4.0, 24.0, 4.0, 10.0),
      child: Row(
        children: [
          // Tile tonalizado: mesmo gesto dos cartoes do menu, para a secao ter
          // identidade sem ocupar uma faixa de cor cheia.
          Container(
            width: 34.0,
            height: 34.0,
            decoration: BoxDecoration(
              color: identidade.cor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Icon(identidade.icone, color: identidade.cor, size: 19.0),
          ),
          const SizedBox(width: 10.0),
          Text(
            titulo.toUpperCase(),
            style: tema.bodySmall.override(
              color: tema.primaryText,
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(width: 10.0),
          // O filete liga o rótulo ao resto da largura: é o que faz a seção ler
          // como cabeçalho de ficha, e não como etiqueta solta.
          Expanded(child: Container(height: 1.0, color: tema.alternate)),
          if (onVerMais != null) ...[
            const SizedBox(width: 10.0),
            InkWell(
              borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
              onTap: onVerMais,
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(6.0, 6.0, 6.0, 6.0),
                child: Text(
                  'Ver mais',
                  style: tema.bodySmall.override(
                    color: AppTokens.brand,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Uma entrada da ficha: data na calha lateral, título e detalhe.
///
/// A calha tem largura fixa para as linhas alinharem verticalmente — é o que
/// permite percorrer a coluna de datas com o olho sem ler o resto.
class LinhaProntuario extends StatelessWidget {
  const LinhaProntuario({
    super.key,
    required this.data,
    required this.titulo,
    required this.identidade,
    this.detalhe,
    this.onLongPress,
  });

  final IdentidadeSecao identidade;

  /// Data no formato que a tela já usa (dd/MM/yyyy).
  final String data;

  final String titulo;

  /// Segunda linha, opcional (observação, parto previsto).
  final String? detalhe;

  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final partes = data.split('/');
    final diaMes = partes.length >= 2 ? '${partes[0]}/${partes[1]}' : data;
    final ano = partes.length >= 3 ? partes[2] : '';

    return InkWell(
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4.0, 12.0, 4.0, 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 56.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    diaMes,
                    style: tema.bodyMedium.override(
                      color: tema.primaryText,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (ano.isNotEmpty)
                    Text(
                      ano,
                      style: tema.bodySmall.override(
                        color: tema.secondaryText,
                        fontSize: 12.0,
                      ),
                    ),
                ],
              ),
            ),
            // A espinha separa a calha do conteúdo. É o único traço de cor da
            // linha, e ele marca o eixo do tempo.
            Container(
              width: 3.0,
              height: 36.0,
              margin:
                  const EdgeInsetsDirectional.fromSTEB(12.0, 2.0, 14.0, 0.0),
              decoration: BoxDecoration(
                color: identidade.cor.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: tema.bodyMedium.override(
                      color: tema.primaryText,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (detalhe != null && detalhe!.isNotEmpty) ...[
                    const SizedBox(height: 2.0),
                    Text(
                      detalhe!,
                      style: tema.bodySmall.override(
                        color: tema.secondaryText,
                        fontSize: 13.0,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// O que uma seção mostra quando não há registro.
///
/// Antes a seção vazia ocupava um bloco de cor inteiro sem nada dentro. Uma
/// linha discreta diz a mesma coisa e devolve a tela ao conteúdo.
class SecaoVazia extends StatelessWidget {
  const SecaoVazia({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    // Na mesma superfície das seções com registro: uma delas sobre cartão e
    // outra solta no fundo faria a tela parecer quebrada.
    return CorpoSecao(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4.0, 14.0, 4.0, 14.0),
        child: Text(
          'Nenhum registro',
          style: tema.bodySmall.override(
            color: tema.secondaryText,
            fontSize: 13.0,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}

/// Superfície que agrupa as linhas de uma seção.
///
/// A primeira versão deixou as linhas soltas sobre o branco e a tela ficou
/// pobre: sem superfície, nada separava uma seção da seguinte além do espaço.
/// O cartão devolve a profundidade que o resto do app tem, sem trazer de volta
/// a faixa de cor.
class CorpoSecao extends StatelessWidget {
  const CorpoSecao({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 4.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(AppTokens.radius),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: child,
    );
  }
}
