import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../objectbox.g.dart';
import 'objectbox_service.dart';
import 'offline_first_sync_service.dart';
import 'entities/index.dart';
import 'repositories/index.dart';

/// Helper para integração do ObjectBox com autenticação
/// Gerencia o ciclo de vida de sincronização offline-first
class ObjectBoxAuthHelper {
  static bool _tecnicoRefreshStarted = false;

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

    _startTecnicoAutoRefresh();
  }

  /// Rebaixa os dados do técnico (limites/plano, contadores) sempre que o app
  /// abre com uma sessão já salva ou o usuário faz login. O `performFullDownload`
  /// só roda no 1º login, então mudanças feitas direto no Firestore (ex.:
  /// `limiteProdutoresContratado`) não chegariam ao ObjectBox por conta própria.
  ///
  /// No 1º login (`needsInitialSync`) o download completo já baixa o técnico —
  /// pulamos aqui para não competir na mesma box. O retorno do offline para o
  /// online é coberto pelo listener de conectividade do sync service.
  static void _startTecnicoAutoRefresh() {
    if (_tecnicoRefreshStarted) return;
    _tecnicoRefreshStarted = true;

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null || !OfflineFirstSyncService.isInitialized) return;
      final sync = OfflineFirstSyncService.instance;
      if (sync.needsInitialSync()) return;
      unawaited(sync.refreshTecnico(user.uid));
      // App reaberto com sessão salva não passa pelo `onUserLogin`, que é
      // quem abre as escutas depois do download.
      sync.iniciarEscutaRemota();
      // Mesmo motivo: sem isto o reparo dos vínculos só rodaria para quem
      // fizesse login de novo. É no-op depois da primeira execução.
      unawaited(sync.repararVinculosDeVisitas());
    });
  }

  /// Sincroniza dados do usuário após login.
  ///
  /// Propaga [SyncOfflineException] e [SyncFalhaException]: quem chama e a tela
  /// de sincronizacao, que sabe mostrar erro e oferecer nova tentativa. A versao
  /// anterior engolia a excecao aqui, e um download que nao aconteceu chegava na
  /// UI como sucesso.
  static Future<void> onUserLogin(User user, {bool? ehProdutor}) async {
    if (kIsWeb) return;

    if (!ObjectBoxService.isInitialized) {
      await ObjectBoxService.initialize();
    }

    if (!OfflineFirstSyncService.isInitialized) {
      await OfflineFirstSyncService.initialize();
    }

    final syncService = OfflineFirstSyncService.instance;

    // Faz o download completo na primeira sincronização OU quando o cache de
    // animais está vazio (auto-recuperação de instalações cujo sync anterior
    // baixou do path errado e ficou sem animais).
    final semAnimaisLocais = ObjectBoxService.instance.animalBox.count() == 0;
    if (syncService.needsInitialSync() || semAnimaisLocais) {
      debugPrint('📥 Baixando todos os dados...');
      await syncService.performFullDownload(
        userId: user.uid,
        ehProdutor: ehProdutor,
      );
    } else {
      // Sincroniza apenas alterações pendentes
      debugPrint('🔄 Sincronizando alterações pendentes...');
      await syncService.syncPendingChangesToFirestore();
    }

    // Auto-recuperação (uma vez por instalação): quem já tinha sincronizado
    // antes da correção ficou com as propriedades no path do produtor e nunca
    // re-baixa por conta própria. Re-baixa só as propriedades.
    await syncService.repararPathPropriedades(user.uid);

    // Completa no servidor os vínculos das visitas já enviadas (uma vez por
    // instalação). Sem isso o receituário emitido online fica invisível ao
    // produtor e desaparece do técnico no próximo login.
    await syncService.repararVinculosDeVisitas();

    debugPrint('✅ Sincronização após login concluída');

    // O logout para o timer, e o bootstrap é o único outro lugar que o arma:
    // quem trocava de conta sem fechar o app ficava sem pull nem push
    // periódico. Armado só depois do download, para não disputar a box com ele.
    syncService.startPeriodicSync();
    // Depois do download: os alvos do produtor saem das propriedades locais.
    syncService.iniciarEscutaRemota();

    // Manutenção: remove soft-deletes já sincronizados (Fase 1.5).
    final purged = purgeAllSyncedSoftDeletes();
    if (purged > 0) {
      debugPrint('🧹 $purged registro(s) soft-deleted purgado(s)');
    }
  }

  /// Remove do cache local os soft-deletes já sincronizados de TODAS as
  /// entidades sincronizáveis (`isDeleted && !needsSync`), evitando que o banco
  /// cresça indefinidamente. Retorna o total de registros removidos.
  ///
  /// `propriedadeBox` fica DE FORA de propósito: propriedade excluída é um
  /// soft-delete que continua existindo no Firestore — é a lixeira (restaurável)
  /// da `propriedades_excluidas_page`. Purgar localmente esvaziaria a lixeira a
  /// cada login.
  static int purgeAllSyncedSoftDeletes() {
    if (kIsWeb || !ObjectBoxService.isInitialized) return 0;
    final ob = ObjectBoxService.instance;
    return _purgeBox(ob.animalBox) +
        _purgeBox(ob.acaoBox) +
        _purgeBox(ob.acaoDaVisitaBox) +
        _purgeBox(ob.tratamentoBox) +
        _purgeBox(ob.acaoSanitarioBox) +
        _purgeBox(ob.financeiroBox) +
        _purgeBox(ob.resumoVisitaBox) +
        _purgeBox(ob.recomendacaoBox) +
        _purgeBox(ob.personBox) +
        _purgeBox(ob.tecnicoBox) +
        _purgeBox(ob.produtorBox);
  }

  static int _purgeBox<T extends SyncableEntity>(Box<T> box) {
    final ids = box
        .getAll()
        .where(BaseSyncRepository.isPurgeable)
        .map((e) => e.id)
        .toList();
    if (ids.isNotEmpty) box.removeMany(ids);
    return ids.length;
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

      // Para sincronização periódica e as escutas — antes de apagar o banco,
      // para nenhum evento remoto gravar dados da conta que está saindo.
      if (OfflineFirstSyncService.isInitialized) {
        OfflineFirstSyncService.instance.stopPeriodicSync();
        OfflineFirstSyncService.instance.pararEscutaRemota();
      }

      // Apaga o banco local INTEIRO. Antes só saíam o person, a fila e as
      // marcas de sync: propriedades, animais e ações ficavam, e o próximo
      // usuário do aparelho herdava tudo — um produtor chegou a baixar os
      // animais de outros 13 clientes do técnico anterior, porque os alvos do
      // download saem das propriedades locais. Quem avisa sobre o que ainda não
      // foi enviado é a tela, antes de chamar o signOut
      // (`confirmarSaidaDaConta`).
      await ObjectBoxService.instance.clearAllData();

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
}
