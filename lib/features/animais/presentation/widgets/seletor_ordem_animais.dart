import 'package:flutter/material.dart';

import '../../application/ordenacao_animais.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';

/// Escolhe por qual criterio a lista de animais e ordenada: nome ou brinco.
///
/// Sao dois botoes, e nao um que alterna, porque o tecnico no curral quer
/// APONTAR o criterio que precisa agora — esta lendo um brinco na orelha do
/// animal ou procurando pelo nome que deu a ele. Um botao que alterna obriga a
/// ler o rotulo para descobrir em que estado esta antes de saber se deve tocar.
///
/// Tocar no criterio JA ativo inverte a direcao (A-Z vira Z-A, menor brinco
/// vira maior). A seta no botao ativo diz qual direcao esta valendo, entao a
/// inversao nunca e uma mudanca silenciosa: o rotulo muda junto com a lista.
///
/// Trocar de criterio sempre recomeca na direcao crescente — assim o resultado
/// de um toque nao depende do que foi feito na categoria anterior.
class SeletorOrdemAnimais extends StatelessWidget {
  const SeletorOrdemAnimais({
    super.key,
    required this.ordem,
    required this.crescente,
    required this.onSelecionar,
    required this.onInverter,
    this.mostrarInseminacao = false,
  });

  final OrdemAnimais ordem;

  /// `true` = A-Z / menor brinco primeiro.
  final bool crescente;

  /// Pedido de troca de criterio (so dispara no botao inativo).
  final ValueChanged<OrdemAnimais> onSelecionar;

  /// Pedido de inversao (so dispara no botao ja ativo).
  final VoidCallback onInverter;

  /// Terceiro botao, "Inseminação": so a aba Novilhas da Recria liga.
  final bool mostrarInseminacao;

  @override
  Widget build(BuildContext context) {
    // Wrap e nao Row: com o terceiro botao, numa tela estreita ele desce
    // para a linha de baixo em vez de estourar a largura.
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        _botao(context, OrdemAnimais.nome, 'Nome',
            crescente ? 'por nome, de A a Z' : 'por nome, de Z a A'),
        _botao(
            context,
            OrdemAnimais.brinco,
            'Brinco',
            crescente
                ? 'por brinco, do menor ao maior'
                : 'por brinco, do maior ao menor'),
        if (mostrarInseminacao)
          _botao(
              context,
              OrdemAnimais.inseminacao,
              'Inseminação',
              crescente
                  ? 'por inseminação, das mais antigas às mais recentes'
                  : 'por inseminação, das mais recentes às mais antigas'),
      ],
    );
  }

  Widget _botao(
    BuildContext context,
    OrdemAnimais criterio,
    String rotulo,
    String descricao,
  ) {
    final ativo = ordem == criterio;

    return Semantics(
      button: true,
      selected: ativo,
      label: ativo
          ? 'Ordenado $descricao. Tocar para inverter.'
          : 'Ordenar $descricao',
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
        onTap: ativo ? onInverter : () => onSelecionar(criterio),
        child: Container(
          // Alvo de toque confortavel para uso com uma mao no curral.
          constraints: const BoxConstraints(minHeight: 48.0),
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
          decoration: BoxDecoration(
            color: ativo ? AppTokens.brand : AppTokens.brandTint,
            borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                switch (criterio) {
                  OrdemAnimais.nome => Icons.sort_by_alpha_rounded,
                  OrdemAnimais.brinco => Icons.tag_rounded,
                  OrdemAnimais.inseminacao => Icons.event_rounded,
                },
                color: ativo ? Colors.white : AppTokens.brand,
                size: 18.0,
              ),
              const SizedBox(width: 6.0),
              Text(
                rotulo,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      color: ativo ? Colors.white : AppTokens.brand,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              // A seta so existe no ativo: no inativo ela afirmaria uma direcao
              // que nao esta valendo em lista nenhuma.
              if (ativo) ...[
                const SizedBox(width: 4.0),
                Icon(
                  crescente
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: Colors.white,
                  size: 16.0,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
