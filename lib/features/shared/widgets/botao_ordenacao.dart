import 'package:flutter/material.dart';

import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';

/// Botão que inverte a ordem de uma lista de animais.
///
/// Mostra a ordem ATUAL ("Menor"/"Maior") em vez de nomear a ação ("Ordenar").
/// Nomear a ação obriga a um passo mental — em que ordem está agora? — cuja
/// resposta não estaria em lugar nenhum. Assim o botão é a própria resposta, e
/// tocar inverte o rótulo e a lista juntos.
///
/// A palavra fica: um glifo sozinho traz de volta o "adivinhe o que faz". E o
/// glifo é `swap_vert`, não um par A/Z — as listas ordenam por brinco, que são
/// números, e um símbolo alfabético afirmaria uma ordem que não é a aplicada.
///
/// Mora ao lado da busca, nunca na AppBar: a barra já tem a seta de voltar, e
/// um segundo ícone de seta ali é confundível com navegação.
/// Os dois rótulos de um controle de ordenação.
///
/// Cada tela ordena por um critério: a maioria por brinco, mas as de secas e
/// prenhas por data de inseminação — nelas as mais adiantadas, que parem antes,
/// vêm no topo. O rótulo tem de dizer a verdade sobre o critério aplicado, ou o
/// botão vira ruído.
class RotulosOrdenacao {
  const RotulosOrdenacao({
    required this.crescente,
    required this.decrescente,
    required this.descricaoCrescente,
    required this.descricaoDecrescente,
  });

  /// Listas ordenadas pelo brinco do animal.
  const RotulosOrdenacao.brinco()
      : crescente = 'Menor',
        decrescente = 'Maior',
        descricaoCrescente = 'menor brinco primeiro',
        descricaoDecrescente = 'maior brinco primeiro';

  /// Listas ordenadas pela data de inseminação.
  const RotulosOrdenacao.dataInseminacao()
      : crescente = 'Mais antigas',
        decrescente = 'Mais recentes',
        descricaoCrescente = 'inseminações mais antigas primeiro',
        descricaoDecrescente = 'inseminações mais recentes primeiro';

  final String crescente;
  final String decrescente;
  final String descricaoCrescente;
  final String descricaoDecrescente;
}

class BotaoOrdenacao extends StatelessWidget {
  const BotaoOrdenacao({
    super.key,
    required this.crescente,
    required this.onAlternar,
    this.rotulos = const RotulosOrdenacao.brinco(),
  });

  /// `true` = primeiro critério (menor brinco / mais antigas).
  final bool crescente;

  final VoidCallback onAlternar;

  final RotulosOrdenacao rotulos;

  @override
  Widget build(BuildContext context) {
    final rotulo = crescente ? rotulos.crescente : rotulos.decrescente;
    final descricao =
        crescente ? rotulos.descricaoCrescente : rotulos.descricaoDecrescente;

    return Semantics(
      button: true,
      label: 'Ordem: $descricao. Tocar para inverter.',
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
        onTap: onAlternar,
        child: Container(
          // Alvo de toque confortável para uso com uma mão no curral.
          constraints: const BoxConstraints(minHeight: 48.0),
          padding: const EdgeInsetsDirectional.fromSTEB(10.0, 8.0, 12.0, 8.0),
          decoration: BoxDecoration(
            color: AppTokens.brandTint,
            borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.swap_vert_rounded,
                color: AppTokens.brand,
                size: 20.0,
              ),
              const SizedBox(width: 6.0),
              Text(
                rotulo,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      color: AppTokens.brand,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
