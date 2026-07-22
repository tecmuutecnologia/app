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
    // para não piscar o banner no startup. (O status reflete a INTERFACE de
    // rede — não a sonda profunda — então não dá falso "offline" estando online.)
    final isOnline = ref.watch(isOnlineProvider).valueOrNull ?? true;

    // Online: zero altura e zero inset — não desloca nada na tela.
    if (isOnline) return const SizedBox.shrink();

    // Offline: barra fina com inset próprio da status bar (o app.dart NÃO
    // envolve mais em SafeArea, p/ não reservar espaço quando online).
    return Material(
      color: const Color(0xFFF2886E), // tom suave do laranja do app
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.cloud_off_rounded, color: Colors.white, size: 18.0),
              SizedBox(width: 8.0),
              Flexible(
                child: Text(
                  'Sem conexão — trabalhando offline',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
