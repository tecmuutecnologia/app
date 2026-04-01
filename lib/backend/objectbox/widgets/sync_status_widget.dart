import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../sync_service.dart';

/// Widget que exibe o status de sincronização
class SyncStatusIndicator extends StatelessWidget {
  const SyncStatusIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Não mostra no Web
    if (kIsWeb || !SyncService.isInitialized) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<SyncStatus>(
      stream: SyncService.instance.statusStream,
      initialData: SyncService.instance.currentStatus,
      builder: (context, snapshot) {
        final status = snapshot.data ?? SyncStatus.idle;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildStatusWidget(status),
        );
      },
    );
  }

  Widget _buildStatusWidget(SyncStatus status) {
    switch (status) {
      case SyncStatus.syncing:
        return Container(
          key: const ValueKey('syncing'),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Sincronizando...',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );

      case SyncStatus.offline:
        return Container(
          key: const ValueKey('offline'),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off, size: 16, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                'Offline',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );

      case SyncStatus.error:
        return Container(
          key: const ValueKey('error'),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 16, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Erro na sincronização',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );

      case SyncStatus.completed:
        return Container(
          key: const ValueKey('completed'),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_done, size: 16, color: Colors.green),
              SizedBox(width: 8),
              Text(
                'Sincronizado',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );

      case SyncStatus.idle:
        return const SizedBox.shrink(key: ValueKey('idle'));
    }
  }
}

/// Widget compacto para usar na AppBar
class SyncStatusIcon extends StatelessWidget {
  const SyncStatusIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !SyncService.isInitialized) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<SyncStatus>(
      stream: SyncService.instance.statusStream,
      initialData: SyncService.instance.currentStatus,
      builder: (context, snapshot) {
        final status = snapshot.data ?? SyncStatus.idle;

        return IconButton(
          icon: _buildIcon(status),
          onPressed: () => _showSyncDialog(context, status),
          tooltip: _getTooltip(status),
        );
      },
    );
  }

  Widget _buildIcon(SyncStatus status) {
    switch (status) {
      case SyncStatus.syncing:
        return const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
          ),
        );
      case SyncStatus.offline:
        return const Icon(Icons.cloud_off, color: Colors.orange);
      case SyncStatus.error:
        return const Icon(Icons.sync_problem, color: Colors.red);
      case SyncStatus.completed:
        return const Icon(Icons.cloud_done, color: Colors.green);
      case SyncStatus.idle:
        return const Icon(Icons.cloud_queue, color: Colors.white70);
    }
  }

  String _getTooltip(SyncStatus status) {
    switch (status) {
      case SyncStatus.syncing:
        return 'Sincronizando...';
      case SyncStatus.offline:
        return 'Modo offline';
      case SyncStatus.error:
        return 'Erro na sincronização';
      case SyncStatus.completed:
        return 'Sincronizado';
      case SyncStatus.idle:
        return 'Status da sincronização';
    }
  }

  void _showSyncDialog(BuildContext context, SyncStatus status) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Status da Sincronização'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildIcon(status),
                const SizedBox(width: 12),
                Text(_getStatusText(status)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _getStatusDescription(status),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          if (status == SyncStatus.offline || status == SyncStatus.error)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                SyncService.instance.syncPendingOperations();
              },
              child: const Text('Tentar Sincronizar'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  String _getStatusText(SyncStatus status) {
    switch (status) {
      case SyncStatus.syncing:
        return 'Sincronizando...';
      case SyncStatus.offline:
        return 'Modo Offline';
      case SyncStatus.error:
        return 'Erro na Sincronização';
      case SyncStatus.completed:
        return 'Sincronizado';
      case SyncStatus.idle:
        return 'Pronto';
    }
  }

  String _getStatusDescription(SyncStatus status) {
    switch (status) {
      case SyncStatus.syncing:
        return 'Seus dados estão sendo sincronizados com a nuvem.';
      case SyncStatus.offline:
        return 'Você está offline. As alterações serão sincronizadas quando a conexão for restabelecida.';
      case SyncStatus.error:
        return 'Houve um erro ao sincronizar. Tente novamente mais tarde.';
      case SyncStatus.completed:
        return 'Todos os dados foram sincronizados com sucesso.';
      case SyncStatus.idle:
        return 'O sistema está pronto para uso.';
    }
  }
}
