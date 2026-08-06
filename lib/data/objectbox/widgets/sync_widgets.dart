import 'package:flutter/material.dart';
import '../offline_first_sync_service.dart';

/// Widget para exibir indicador de status de sincronização (offline-first)
class OfflineFirstSyncStatusIndicator extends StatelessWidget {
  final SyncStatus status;
  final bool showText;

  const OfflineFirstSyncStatusIndicator({
    super.key,
    required this.status,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, color, text) = _getStatusInfo(status);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        if (showText) ...[
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: color, fontSize: 12),
          ),
        ],
      ],
    );
  }

  (IconData, Color, String) _getStatusInfo(SyncStatus status) {
    switch (status) {
      case SyncStatus.idle:
        return (Icons.cloud_done, Colors.green, 'Sincronizado');
      case SyncStatus.syncing:
        return (Icons.sync, Colors.blue, 'Sincronizando...');
      case SyncStatus.completed:
        return (Icons.check_circle, Colors.green, 'Concluído');
      case SyncStatus.error:
        return (Icons.error, Colors.red, 'Erro na sincronização');
      case SyncStatus.offline:
        return (Icons.cloud_off, Colors.orange, 'Offline');
    }
  }
}

/// Widget para exibir status de conexão com opção de sincronização manual
class ConnectionStatusBanner extends StatelessWidget {
  final bool isOnline;
  final SyncStatus syncStatus;
  final VoidCallback? onSync;
  final int pendingOperations;

  const ConnectionStatusBanner({
    super.key,
    required this.isOnline,
    required this.syncStatus,
    this.onSync,
    this.pendingOperations = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (isOnline &&
        pendingOperations == 0 &&
        syncStatus != SyncStatus.syncing) {
      return const SizedBox.shrink();
    }

    return Material(
      elevation: 2,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: _getBackgroundColor(),
        child: Row(
          children: [
            Icon(_getIcon(), color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _getMessage(),
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
            if (isOnline &&
                pendingOperations > 0 &&
                syncStatus != SyncStatus.syncing)
              TextButton(
                onPressed: onSync,
                child: const Text(
                  'Sincronizar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            if (syncStatus == SyncStatus.syncing)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (!isOnline) return Colors.orange;
    if (syncStatus == SyncStatus.error) return Colors.red;
    if (syncStatus == SyncStatus.syncing) return Colors.blue;
    if (pendingOperations > 0) return Colors.amber[700]!;
    return Colors.green;
  }

  IconData _getIcon() {
    if (!isOnline) return Icons.cloud_off;
    if (syncStatus == SyncStatus.error) return Icons.error;
    if (syncStatus == SyncStatus.syncing) return Icons.sync;
    if (pendingOperations > 0) return Icons.upload;
    return Icons.cloud_done;
  }

  String _getMessage() {
    if (!isOnline)
      return 'Você está offline. As alterações serão sincronizadas quando houver conexão.';
    if (syncStatus == SyncStatus.error)
      return 'Erro na sincronização. Tente novamente.';
    if (syncStatus == SyncStatus.syncing) return 'Sincronizando alterações...';
    if (pendingOperations > 0)
      return '$pendingOperations alteração(ões) pendente(s)';
    return 'Todos os dados sincronizados';
  }
}

/// Mixin para adicionar funcionalidade de sync a qualquer State
mixin SyncStateMixin<T extends StatefulWidget> on State<T> {
  late final OfflineFirstSyncService _syncService;

  @override
  void initState() {
    super.initState();
    if (OfflineFirstSyncService.isInitialized) {
      _syncService = OfflineFirstSyncService.instance;
    }
  }

  bool get isOnline =>
      OfflineFirstSyncService.isInitialized ? _syncService.isOnline : true;

  SyncStatus get syncStatus => OfflineFirstSyncService.isInitialized
      ? _syncService.currentStatus
      : SyncStatus.idle;

  Stream<SyncStatus> get syncStatusStream =>
      OfflineFirstSyncService.isInitialized
          ? _syncService.statusStream
          : const Stream.empty();

  Future<void> syncNow() async {
    if (OfflineFirstSyncService.isInitialized) {
      await _syncService.syncPendingChangesToFirestore();
    }
  }
}
