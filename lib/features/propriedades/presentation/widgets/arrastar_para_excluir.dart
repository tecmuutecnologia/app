import 'package:flutter/material.dart';

import '/app/theme/flutter_flow_theme.dart';

/// Envolve o card de uma propriedade: arrastar para a esquerda revela a faixa
/// "Excluir" e pede confirmação — a mesma mecânica do descarte de animal.
class ArrastarParaExcluir extends StatelessWidget {
  const ArrastarParaExcluir({
    super.key,
    required this.chave,
    required this.onExcluir,
    required this.child,
    this.margem = EdgeInsets.zero,
    this.raio = 16.0,
  });

  /// Identifica o card entre os irmãos da lista (o `Dismissible` exige).
  final String chave;

  /// Chamado só depois que o técnico confirma.
  final Future<void> Function() onExcluir;

  final Widget child;

  /// Margem e cantos do card, para a faixa ocupar exatamente o lugar dele.
  final EdgeInsetsGeometry margem;
  final double raio;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('excluir-$chave'),
      direction: DismissDirection.endToStart,
      background: _faixa(context),
      // Devolve `false` SEMPRE: o arrasto apenas PEDE a exclusão. Quem tira o
      // card da lista é a gravação no ObjectBox, que a lista observa — se o
      // card sumisse aqui e a gravação falhasse, ele voltaria piscando.
      confirmDismiss: (_) async {
        if (await _confirmar(context)) await onExcluir();
        return false;
      },
      child: child,
    );
  }

  Future<bool> _confirmar(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Excluir Propriedade'),
          content: const Text(
              'Tem certeza que deseja excluir essa propriedade? Ela será '
              'movida para a lixeira e poderá ser restaurada posteriormente.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Excluir'),
            ),
          ],
        ),
      ) ??
      false;

  Widget _faixa(BuildContext context) {
    return Container(
      margin: margem,
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 24, 0),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).error,
        borderRadius: BorderRadius.circular(raio),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_outline, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text(
            'Excluir',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
