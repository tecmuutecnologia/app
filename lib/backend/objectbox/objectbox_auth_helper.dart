import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'objectbox_service.dart';
import 'sync_service.dart';

/// Helper para integração do ObjectBox com autenticação
class ObjectBoxAuthHelper {
  /// Sincroniza dados do usuário após login
  static Future<void> onUserLogin(User user) async {
    if (kIsWeb) return;

    if (!ObjectBoxService.isInitialized) {
      await ObjectBoxService.initialize();
    }

    if (!SyncService.isInitialized) {
      await SyncService.initialize();
    }

    try {
      // Sincroniza dados do usuário do Firestore para ObjectBox
      await SyncService.instance.syncFromFirestore(userId: user.uid);
      debugPrint('✅ Dados do usuário sincronizados após login');
    } catch (e) {
      debugPrint('❌ Erro ao sincronizar dados após login: $e');
    }
  }

  /// Limpa dados locais após logout
  static Future<void> onUserLogout(String? userId) async {
    if (kIsWeb) return;

    if (!ObjectBoxService.isInitialized) return;

    try {
      // Sincroniza operações pendentes antes de limpar
      if (SyncService.isInitialized && SyncService.instance.isOnline) {
        await SyncService.instance.syncPendingOperations();
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

  /// Força uma sincronização manual
  static Future<void> forceSync(String userId) async {
    if (kIsWeb) return;

    if (!SyncService.isInitialized) return;

    try {
      await SyncService.instance.syncFromFirestore(
        userId: userId,
        fullSync: true,
      );
      debugPrint('✅ Sincronização forçada concluída');
    } catch (e) {
      debugPrint('❌ Erro na sincronização forçada: $e');
      rethrow;
    }
  }

  /// Verifica se existem operações pendentes de sincronização
  static int getPendingOperationsCount() {
    if (kIsWeb || !ObjectBoxService.isInitialized) return 0;

    return ObjectBoxService.instance.pendingOperationBox.count();
  }

  /// Limpa todo o cache local (use com cuidado!)
  static Future<void> clearAllLocalData() async {
    if (kIsWeb || !ObjectBoxService.isInitialized) return;

    await ObjectBoxService.instance.clearAllData();
    debugPrint('⚠️ Todos os dados locais foram limpos');
  }
}
