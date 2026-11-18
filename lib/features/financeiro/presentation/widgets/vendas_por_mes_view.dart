import 'dart:async';

import 'package:flutter/material.dart';

import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';
import '/core/ui/card_animal_lista.dart' show tituloNomeBrinco;
import '/data/objectbox/entities/index.dart';
import '/data/objectbox/offline_first_sync_service.dart';
import '/data/objectbox/repositories/venda_animal_repository.dart';
import '/domain/financeiro/vendas_por_mes.dart';

/// Aba "Vendas" do Financeiro: receita das vendas de animais da propriedade,
/// separada por mês (mais recente primeiro) com o total de cada mês.
///
/// Lê do ObjectBox (offline-first). Ao abrir, busca no servidor as vendas que
/// outro aparelho registrou — elas não têm escuta em tempo real.
class VendasPorMesView extends StatefulWidget {
  const VendasPorMesView({
    super.key,
    required this.propriedadePath,
    this.vendas,
    this.aoAbrir,
  });

  final String propriedadePath;

  /// Injetáveis para teste; o padrão lê o ObjectBox e puxa do servidor.
  final Stream<List<VendaAnimalEntity>>? vendas;
  final VoidCallback? aoAbrir;

  @override
  State<VendasPorMesView> createState() => _VendasPorMesViewState();
}

class _VendasPorMesViewState extends State<VendasPorMesView> {
  late final Stream<List<VendaAnimalEntity>> _vendas = widget.vendas ??
      VendaAnimalRepository().watchByParentPath(widget.propriedadePath);

  @override
  void initState() {
    super.initState();
    final aoAbrir = widget.aoAbrir;
    if (aoAbrir != null) {
      aoAbrir();
    } else {
      unawaited(
          OfflineFirstSyncService.instance.puxarVendas(widget.propriedadePath));
    }
  }

  static VendaResumo _resumo(VendaAnimalEntity v) => VendaResumo(
        id: v.firestoreId ?? '${v.id}',
        titulo: tituloNomeBrinco(
                v.nomeAnimal ?? '', v.brincoAnimal > 0 ? v.brincoAnimal : null)
            .ifEmpty('Animal sem nome'),
        data: parseDataBr(v.dtVenda),
        dtTexto: v.dtVenda ?? '',
        valor: v.valorVenda,
      );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<VendaAnimalEntity>>(
      stream: _vendas,
      builder: (context, snapshot) {
        final grupos = agruparVendasPorMes([
          for (final v in snapshot.data ?? const <VendaAnimalEntity>[])
            if (!v.isDeleted) _resumo(v),
        ]);
        if (grupos.isEmpty) return _vazio(context);
        return ListView(
          padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
          children: [for (final g in grupos) _mes(context, g)],
        );
      },
    );
  }

  Widget _vazio(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sell_outlined,
                  size: 48, color: AppTokens.secondary),
              const SizedBox(height: 12),
              Text('Nenhuma venda registrada',
                  style: FlutterFlowTheme.of(context)
                      .titleSmall
                      .copyWith(
                          color: FlutterFlowTheme.of(context).primaryText)),
              const SizedBox(height: 4),
              Text(
                'Venda um animal pela lista de animais para ver a receita aqui.',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodySmall,
              ),
            ],
          ),
        ),
      );

  Widget _mes(BuildContext context, GrupoVendasMes grupo) {
    final tema = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
      child: AppCard(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(grupo.rotulo,
                      style: tema.titleSmall
                          .copyWith(
                          color: tema.primaryText,
                          fontWeight: FontWeight.w700)),
                ),
                Text(
                  formatarReais(grupo.total),
                  style: tema.titleSmall.copyWith(
                      color: AppTokens.positivo, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const Divider(height: 16),
            for (final v in grupo.vendas)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(v.titulo, style: tema.bodyMedium),
                          Text(v.dtTexto, style: tema.bodySmall),
                        ],
                      ),
                    ),
                    Text(formatarReais(v.valor), style: tema.bodyMedium),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

extension on String {
  String ifEmpty(String alternativa) => isEmpty ? alternativa : this;
}
