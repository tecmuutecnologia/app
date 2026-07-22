// ignore_for_file: avoid_print
// Serviço de DEBUG (dev-only): print no console é intencional aqui.
import 'package:objectbox/objectbox.dart';

import 'objectbox_service.dart';
import 'package:flutter/foundation.dart';

/// Serviço para gerenciar debug do ObjectBox
/// Permite inspecionar dados e outras ferramentas de debug
class ObjectBoxDebugService {
  static bool _adminStarted = false;

  /// Mantém a instância viva enquanto o Admin estiver rodando (senão é coletada
  /// e o servidor cai). `Admin` vem do core `objectbox`; o servidor só fica
  /// disponível quando a native lib do Android é a `objectbox-android-
  /// objectbrowser` (debugImplementation no android/app/build.gradle).
  static Admin? _admin;

  /// Inicia o ObjectBox Admin (UI web de inspeção do banco). Só nativo + debug:
  /// requer a native lib `objectbox-android-objectbrowser` (`Admin.isAvailable()`).
  static Future<bool> startAdmin({int port = 8090}) async {
    try {
      if (kIsWeb) {
        print('⚠️ ObjectBox Admin não é suportado na Web');
        return false;
      }

      if (!ObjectBoxService.isInitialized) {
        print('❌ ObjectBox não foi inicializado');
        return false;
      }

      if (_adminStarted) {
        print('⚠️ Admin já está rodando em http://127.0.0.1:$port');
        return true;
      }

      if (!Admin.isAvailable()) {
        print('❌ ObjectBox Admin indisponível neste build.');
        print('💡 Use a native lib `objectbox-android-objectbrowser` '
            '(debugImplementation no android/app/build.gradle); só funciona '
            'em debug no Android.');
        return false;
      }

      final store = ObjectBoxService.instance.store;
      // Mantém a referência viva até stopAdmin()/coleta manual.
      _admin = Admin(store, bindUri: 'http://0.0.0.0:$port');
      _adminStarted = true;

      print('✅ ObjectBox Admin iniciado!');
      print('🌐 Acesse: http://127.0.0.1:$port (no navegador do PC/Mac)');
      return true;
    } catch (e) {
      print('❌ Erro ao iniciar Admin: $e');
      print('💡 Dica: confirme a native lib `objectbox-android-objectbrowser` '
          'no android/app/build.gradle.');
      return false;
    }
  }

  /// Para o ObjectBox Admin
  static Future<void> stopAdmin() async {
    try {
      if (!_adminStarted) {
        print('⚠️ Admin não está rodando');
        return;
      }

      _admin?.close();
      _admin = null;
      _adminStarted = false;
      print('✅ Admin parado');
    } catch (e) {
      print('❌ Erro ao parar Admin: $e');
    }
  }

  /// Imprime estatísticas do banco de dados
  static void printDatabaseStats() {
    try {
      if (!ObjectBoxService.isInitialized) {
        print('❌ ObjectBox não foi inicializado');
        return;
      }

      final objectBox = ObjectBoxService.instance;

      print('\n═══════════════════════════════════════════════════════');
      print('📊 ESTATÍSTICAS DO OBJECTBOX');
      print('═══════════════════════════════════════════════════════');

      print('👤 Pessoas: ${objectBox.personBox.count()}');
      print('👨‍🌾 Técnicos: ${objectBox.tecnicoBox.count()}');
      print('👨‍🚜 Produtores: ${objectBox.produtorBox.count()}');
      print('🏠 Propriedades: ${objectBox.propriedadeBox.count()}');
      print('🐄 Animais: ${objectBox.animalBox.count()}');
      print('🔄 Operações Pendentes: ${objectBox.pendingOperationBox.count()}');
      print('📱 Sessões Ativas: ${objectBox.userSessionBox.count()}');

      print('─────────────────────────────────────────────────────');
      print('Ações: ${objectBox.acaoBox.count()}');
      print('Visitas: ${objectBox.acaoDaVisitaBox.count()}');
      print('Tratamentos: ${objectBox.tratamentoBox.count()}');

      print('═══════════════════════════════════════════════════════\n');
    } catch (e) {
      print('❌ Erro ao obter estatísticas: $e');
    }
  }

  /// Lista todas as sessões de usuário (debug)
  static void printSessions() {
    try {
      if (!ObjectBoxService.isInitialized) {
        print('❌ ObjectBox não foi inicializado');
        return;
      }

      final objectBox = ObjectBoxService.instance;
      final sessions = objectBox.userSessionBox.getAll();

      print('\n═══════════════════════════════════════════════════════');
      print('🔐 SESSÕES DE USUÁRIO (DEBUG)');
      print('═══════════════════════════════════════════════════════');

      if (sessions.isEmpty) {
        print('Nenhuma sessão encontrada');
        print('═══════════════════════════════════════════════════════\n');
        return;
      }

      for (final session in sessions) {
        print('\n📧 Email: ${session.email}');
        print('   Firebase UID: ${session.firebaseUid ?? 'N/A'}');
        print('   Ativa: ${session.isActive ? '✅' : '❌'}');
        print('   Último Login: ${session.lastSuccessfulLogin ?? 'Nunca'}');
        print('   Última Sync: ${session.lastSyncedAt ?? 'Nunca'}');
        print('   Precisa Sync: ${session.needsSync ? '⚠️' : '✅'}');
        print('   Criada em: ${session.createdAt}');
      }

      print('\n═══════════════════════════════════════════════════════\n');
    } catch (e) {
      print('❌ Erro ao listar sessões: $e');
    }
  }

  /// Limpa todas as sessões (logout de todos)
  static Future<void> clearAllSessions() async {
    try {
      if (!ObjectBoxService.isInitialized) {
        print('❌ ObjectBox não foi inicializado');
        return;
      }

      final objectBox = ObjectBoxService.instance;
      final count = objectBox.userSessionBox.count();

      objectBox.userSessionBox.removeAll();

      print('✅ $count sessão(ões) removida(s)');
    } catch (e) {
      print('❌ Erro ao limpar sessões: $e');
    }
  }

  /// Limpa o banco de dados inteiro (cuidado!)
  static Future<void> clearAllData() async {
    try {
      if (!ObjectBoxService.isInitialized) {
        print('❌ ObjectBox não foi inicializado');
        return;
      }

      print('⚠️ Limpando TODOS os dados do ObjectBox...');
      await ObjectBoxService.instance.clearAllData();
      print('✅ Banco de dados limpo');
    } catch (e) {
      print('❌ Erro ao limpar banco: $e');
    }
  }

  /// Exporta dados para JSON (debug)
  static Map<String, dynamic> exportDebugData() {
    try {
      if (!ObjectBoxService.isInitialized) {
        return {'error': 'ObjectBox não inicializado'};
      }

      final objectBox = ObjectBoxService.instance;

      return {
        'timestamp': DateTime.now().toIso8601String(),
        'stats': {
          'pessoas': objectBox.personBox.count(),
          'tecnicos': objectBox.tecnicoBox.count(),
          'produtores': objectBox.produtorBox.count(),
          'propriedades': objectBox.propriedadeBox.count(),
          'animais': objectBox.animalBox.count(),
          'acoes': objectBox.acaoBox.count(),
          'visitas': objectBox.acaoDaVisitaBox.count(),
          'tratamentos': objectBox.tratamentoBox.count(),
          'operacoesPendentes': objectBox.pendingOperationBox.count(),
          'sessoesAtivas': objectBox.userSessionBox.count(),
        },
        'sessoes': objectBox.userSessionBox
            .getAll()
            .map((s) => {
                  'email': s.email,
                  'firebaseUid': s.firebaseUid,
                  'ativa': s.isActive,
                  'ultimoLogin': s.lastSuccessfulLogin?.toIso8601String(),
                  'ultimaSync': s.lastSyncedAt?.toIso8601String(),
                })
            .toList(),
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  /// Obtém status de inicialização
  static bool get isAdminRunning => _adminStarted;

  /// Obtém status do ObjectBox
  static Map<String, dynamic> getStatus() {
    return {
      'initialized': ObjectBoxService.isInitialized,
      'adminRunning': _adminStarted,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
