import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';

/// Banner reativo de conectividade, alimentado pelo `ConnectivityService` via
/// Riverpod (`isOnlineProvider`).
///
/// Piloto de consumo da camada offline-first pela UI: é um `ConsumerWidget`
/// autocontido que pode ser colocado no topo de qualquer tela (ex.: no `body`,
/// acima do conteúdo). Não depende de `FFAppState`.
///
/// Comportamento: invisível quando online; mostra um aviso laranja quando offline.
class SyncStatusBanner extends ConsumerWidget {
  const SyncStatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Otimista: assume online enquanto a primeira leitura do stream não chega,
    // para não piscar o banner no startup.
    final isOnline = ref.watch(isOnlineProvider).valueOrNull ?? true;

    if (isOnline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: Colors.orange.shade700,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, color: Colors.white, size: 18),
          SizedBox(width: 8),
          Text(
            'Sem conexão — trabalhando offline',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
