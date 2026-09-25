import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/data/objectbox/objectbox_service.dart';
import '/data/objectbox/offline_first_sync_service.dart';

/// Pergunta antes de sair quando há alterações que ainda não chegaram ao
/// servidor. Devolve `true` se pode seguir com o `signOut`.
///
/// O logout apaga o banco local inteiro, e o que não foi enviado se perde
/// junto. Antes de contar, tenta enviar (se houver conexão): o aviso só
/// aparece quando a perda é real — tipicamente, aparelho offline.
Future<bool> confirmarSaidaDaConta(BuildContext context) async {
  if (kIsWeb || !ObjectBoxService.isInitialized) return true;

  if (OfflineFirstSyncService.isInitialized &&
      OfflineFirstSyncService.instance.isOnline) {
    await OfflineFirstSyncService.instance.syncPendingChangesToFirestore();
  }

  final naoEnviados = ObjectBoxService.instance.contarNaoEnviados();
  if (naoEnviados == 0) return true;
  if (!context.mounted) return false;

  final sair = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Alterações não enviadas'),
      content: Text(
        naoEnviados == 1
            ? 'Há 1 alteração que ainda não foi enviada ao servidor. '
                'Se sair agora, ela será perdida.\n\n'
                'Conecte-se à internet e aguarde a sincronização para não '
                'perder nada.'
            : 'Há $naoEnviados alterações que ainda não foram enviadas ao '
                'servidor. Se sair agora, elas serão perdidas.\n\n'
                'Conecte-se à internet e aguarde a sincronização para não '
                'perder nada.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Sair mesmo assim'),
        ),
      ],
    ),
  );
  return sair ?? false;
}
