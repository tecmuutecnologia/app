import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'objectbox_service.dart';
import 'sync_service.dart' as legacy;
import 'offline_first_sync_service.dart';

/// Helper para integração do ObjectBox com autenticação
/// Gerencia o ciclo de vida de sincronização offline-first
class ObjectBoxAuthHelper {
  /// Inicializa o sistema de sincronização
  /// Deve ser chamado uma vez no startup do app (main.dart)
  static Future<void> initializeOfflineFirst() async {
    if (kIsWeb) return;

    if (!ObjectBoxService.isInitialized) {
      await ObjectBoxService.initialize();
    }

    if (!OfflineFirstSyncService.isInitialized) {
      await OfflineFirstSyncService.initialize();
    }

    // Inicia sincronização periódica
    OfflineFirstSyncService.instance.startPeriodicSync();
  }

  /// Sincroniza dados do usuário após login
  /// Se é a primeira vez ou dados locais não existem, faz download completo
  static Future<void> onUserLogin(User user) async {
    if (kIsWeb) return;

    if (!ObjectBoxService.isInitialized) {
      await ObjectBoxService.initialize();
    }

    if (!OfflineFirstSyncService.isInitialized) {
      await OfflineFirstSyncService.initialize();
    }

    final syncService = OfflineFirstSyncService.instance;

    try {
      // Verifica se precisa de sincronização inicial
      if (syncService.needsInitialSync()) {
        debugPrint('📥 Primeira sincronização - baixando todos os dados...');
        await syncService.performFullDownload(userId: user.uid);
      } else {
        // Sincroniza apenas alterações pendentes
        debugPrint('🔄 Sincronizando alterações pendentes...');
        await syncService.syncPendingChangesToFirestore();
      }

      debugPrint('✅ Sincronização após login concluída');
    } catch (e) {
      debugPrint('❌ Erro ao sincronizar dados após login: $e');
      // Não lança erro para permitir uso offline
    }
  }

  /// Limpa dados locais após logout
  static Future<void> onUserLogout(String? userId) async {
    if (kIsWeb) return;

    if (!ObjectBoxService.isInitialized) return;

    try {
      // Sincroniza operações pendentes antes de limpar
      if (OfflineFirstSyncService.isInitialized &&
          OfflineFirstSyncService.instance.isOnline) {
        await OfflineFirstSyncService.instance.syncPendingChangesToFirestore();
      }

      // Para sincronização periódica
      if (OfflineFirstSyncService.isInitialized) {
        OfflineFirstSyncService.instance.stopPeriodicSync();
      }

      // Limpa dados do usuário do cache local
      if (userId != null) {
        await ObjectBoxService.instance.clearUserData(userId);
      }

      debugPrint('✅ Dados locais limpos após logout');
    } catch (e) {
      debugPrint('❌ Erro ao limpar dados locais: $e');
    }
  }

  /// Força uma sincronização completa (download)
  static Future<void> forceFullSync(String userId) async {
    if (kIsWeb) return;

    if (!OfflineFirstSyncService.isInitialized) return;

    try {
      await OfflineFirstSyncService.instance
          .performFullDownload(userId: userId);
      debugPrint('✅ Sincronização completa forçada concluída');
    } catch (e) {
      debugPrint('❌ Erro na sincronização forçada: $e');
      rethrow;
    }
  }

  /// Sincroniza alterações locais para o Firestore
  static Future<void> syncPendingChanges() async {
    if (kIsWeb || !OfflineFirstSyncService.isInitialized) return;

    await OfflineFirstSyncService.instance.syncPendingChangesToFirestore();
  }

  /// Verifica se existem operações pendentes de sincronização
  static int getPendingOperationsCount() {
    if (kIsWeb || !ObjectBoxService.isInitialized) return 0;

    return ObjectBoxService.instance.pendingOperationBox.count();
  }

  /// Verifica se está online
  static bool get isOnline {
    if (kIsWeb || !OfflineFirstSyncService.isInitialized) return true;
    return OfflineFirstSyncService.instance.isOnline;
  }

  /// Stream de status de sincronização
  static Stream<SyncStatus>? get syncStatusStream {
    if (kIsWeb || !OfflineFirstSyncService.isInitialized) return null;
    return OfflineFirstSyncService.instance.statusStream;
  }

  /// Limpa todo o cache local (use com cuidado!)
  static Future<void> clearAllLocalData() async {
    if (kIsWeb || !ObjectBoxService.isInitialized) return;

    await ObjectBoxService.instance.clearAllData();
    debugPrint('⚠️ Todos os dados locais foram limpos');
  }

  // ==========================================================================
  // Métodos legados para compatibilidade com SyncService antigo
  // ==========================================================================

  @Deprecated('Use onUserLogin com OfflineFirstSyncService')
  static Future<void> syncFromFirestoreLegacy(String userId) async {
    if (kIsWeb) return;

    if (!ObjectBoxService.isInitialized) {
      await ObjectBoxService.initialize();
    }

    if (!legacy.SyncService.isInitialized) {
      await legacy.SyncService.initialize();
    }

    try {
      await legacy.SyncService.instance.syncFromFirestore(userId: userId);
      debugPrint('✅ Dados do usuário sincronizados (legacy)');
    } catch (e) {
      debugPrint('❌ Erro ao sincronizar dados (legacy): $e');
    }
  }
}
