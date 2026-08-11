import 'package:flutter/material.dart';

import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';

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
    this.onVerMais,
  });

  final String titulo;

  /// Nulo esconde o atalho — seções sem tela própria não o oferecem.
  final VoidCallback? onVerMais;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4.0, 24.0, 4.0, 10.0),
      child: Row(
        children: [
          Text(
            titulo.toUpperCase(),
            style: tema.bodySmall.override(
              color: tema.secondaryText,
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
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
    this.detalhe,
    this.onLongPress,
  });

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
              width: 2.0,
              height: 34.0,
              margin:
                  const EdgeInsetsDirectional.fromSTEB(12.0, 2.0, 14.0, 0.0),
              decoration: BoxDecoration(
                color: AppTokens.brandTint,
                borderRadius: BorderRadius.circular(1.0),
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
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4.0, 4.0, 4.0, 8.0),
      child: Text(
        'Nenhum registro',
        style: tema.bodySmall.override(
          color: tema.secondaryText,
          fontSize: 13.0,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
