import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../objectbox.g.dart';
import 'objectbox_service.dart';
import 'offline_first_sync_service.dart';

/// Serviço de debug para validar sincronização offline-first
/// Use para testar:
/// 1. Se dados salvam localmente no ObjectBox
/// 2. Se mudanças são marcadas com needsSync = true
/// 3. Se sincronização ocorre quando online
/// 4. Se dados remotos atualizam localmente
class SyncDebuggerService {
  static SyncDebuggerService? _instance;
  final ObjectBoxService _objectBox;
  final OfflineFirstSyncService _syncService;

  final _debugEventController = StreamController<SyncDebugEvent>.broadcast();
  Stream<SyncDebugEvent> get debugEventStream => _debugEventController.stream;

  SyncDebuggerService._({
    required ObjectBoxService objectBox,
    required OfflineFirstSyncService syncService,
  })  : _objectBox = objectBox,
        _syncService = syncService;

  static SyncDebuggerService get instance {
    if (_instance == null) {
      throw StateError(
        'SyncDebuggerService não foi inicializado. '
        'Chame SyncDebuggerService.initialize() primeiro.',
      );
    }
    return _instance!;
  }

  static bool get isInitialized => _instance != null;

  static Future<SyncDebuggerService> initialize({
    FirebaseFirestore? firestore,
    Connectivity? connectivity,
  }) async {
    if (_instance != null) {
      return _instance!;
    }

    if (!ObjectBoxService.isInitialized) {
      await ObjectBoxService.initialize();
    }

    if (!OfflineFirstSyncService.isInitialized) {
      await OfflineFirstSyncService.initialize();
    }

    _instance = SyncDebuggerService._(
      objectBox: ObjectBoxService.instance,
      syncService: OfflineFirstSyncService.instance,
    );

    return _instance!;
  }

  // =========================================================================
  // TESTE 1: VERIFICAR DADOS SALVOS LOCALMENTE
  // =========================================================================

  /// Verifica se um animal foi salvo no ObjectBox
  Future<void> validateAnimalSavedLocally(String nomeAnimal) async {
    try {
      final animals = _objectBox.animalBox
          .query(AnimalEntity_.nomeAnimal.equals(nomeAnimal))
          .build()
          .find();

      if (animals.isEmpty) {
        _logEvent(
          SyncDebugEvent(
            type: SyncDebugEventType.error,
            message: '❌ Animal "$nomeAnimal" NÃO encontrado no ObjectBox',
            entityType: 'Animal',
            details: {'esperado': nomeAnimal, 'encontrado': 0},
          ),
        );
        return;
      }

      final animal = animals.first;
      _logEvent(
        SyncDebugEvent(
          type: SyncDebugEventType.success,
          message: '✅ Animal "$nomeAnimal" salvo localmente no ObjectBox',
          entityType: 'Animal',
          details: {
            'firestoreId': animal.firestoreId ?? 'novo',
            'needsSync': animal.needsSync,
            'lastModified': animal.lastModified?.toString(),
            'isDeleted': animal.isDeleted,
          },
        ),
      );
    } catch (e) {
      _logEvent(
        SyncDebugEvent(
          type: SyncDebugEventType.error,
          message: '❌ Erro ao validar animal: $e',
          entityType: 'Animal',
        ),
      );
    }
  }

  /// Verifica se uma ação foi salva no ObjectBox
  Future<void> validateAcaoSavedLocally(String nomeAcao) async {
    try {
      final acoes = _objectBox.acaoBox
          .query(AcaoEntity_.acao.equals(nomeAcao))
          .build()
          .find();

      if (acoes.isEmpty) {
        _logEvent(
          SyncDebugEvent(
            type: SyncDebugEventType.error,
            message: '❌ Ação "$nomeAcao" NÃO encontrada no ObjectBox',
            entityType: 'Acao',
          ),
        );
        return;
      }

      final acao = acoes.first;
      _logEvent(
        SyncDebugEvent(
          type: SyncDebugEventType.success,
          message: '✅ Ação "$nomeAcao" salva localmente',
          entityType: 'Acao',
          details: {
            'firestoreId': acao.firestoreId ?? 'novo',
            'needsSync': acao.needsSync,
            'lastModified': acao.lastModified?.toString(),
          },
        ),
      );
    } catch (e) {
      _logEvent(
        SyncDebugEvent(
          type: SyncDebugEventType.error,
          message: '❌ Erro ao validar ação: $e',
          entityType: 'Acao',
        ),
      );
    }
  }

  // =========================================================================
  // TESTE 2: VERIFICAR MUDANÇAS PENDENTES
  // =========================================================================

  /// Lista todas as entidades marcadas para sincronização
  Future<void> listPendingChanges() async {
    try {
      final pendingAnimals = _objectBox.animalBox
          .query(AnimalEntity_.needsSync.equals(true))
          .build()
          .find();

      final pendingAcoes = _objectBox.acaoBox
          .query(AcaoEntity_.needsSync.equals(true))
          .build()
          .find();

      final pendingTratamentos = _objectBox.tratamentoBox
          .query(TratamentoEntity_.needsSync.equals(true))
          .build()
          .find();

      final pendingOperations = _objectBox.pendingOperationBox.getAll();

      _logEvent(
        SyncDebugEvent(
          type: SyncDebugEventType.info,
          message: '📋 Mudanças pendentes encontradas',
          entityType: 'PendingChanges',
          details: {
            'animaisPendentes': pendingAnimals.length,
            'acoesPendentes': pendingAcoes.length,
            'tratamentosPendentes': pendingTratamentos.length,
            'operacoesPendentes': pendingOperations.length,
            'totalMudanças': pendingAnimals.length +
                pendingAcoes.length +
                pendingTratamentos.length,
          },
        ),
      );

      // Detalha cada mudança
      for (final animal in pendingAnimals) {
        debugPrint(
          '  🐄 Animal: ${animal.nomeAnimal} (${animal.firestoreId ?? 'novo'})',
        );
      }

      for (final acao in pendingAcoes) {
        debugPrint(
          '  📝 Ação: ${acao.acao} (${acao.firestoreId ?? 'novo'})',
        );
      }

      for (final tratamento in pendingTratamentos) {
        debugPrint(
          '  💊 Tratamento: ${tratamento.medicamento} (${tratamento.firestoreId ?? 'novo'})',
        );
      }
    } catch (e) {
      _logEvent(
        SyncDebugEvent(
          type: SyncDebugEventType.error,
          message: '❌ Erro ao listar mudanças: $e',
          entityType: 'PendingChanges',
        ),
      );
    }
  }

  // =========================================================================
  // TESTE 3: FORÇAR SINCRONIZAÇÃO
  // =========================================================================

  /// Força sincronização agora
  Future<void> forceSyncNow() async {
    try {
      _logEvent(
        SyncDebugEvent(
          type: SyncDebugEventType.info,
          message: '🔄 Iniciando sincronização forçada...',
          entityType: 'Sync',
        ),
      );

      if (!_syncService.isOnline) {
        _logEvent(
          SyncDebugEvent(
            type: SyncDebugEventType.warning,
            message: '⚠️ Dispositivo OFFLINE - sincronização será adiada',
            entityType: 'Sync',
          ),
        );
        return;
      }

      await _syncService.syncPendingChangesToFirestore();

      _logEvent(
        SyncDebugEvent(
          type: SyncDebugEventType.success,
          message: '✅ Sincronização completada com sucesso',
          entityType: 'Sync',
        ),
      );
    } catch (e) {
      _logEvent(
        SyncDebugEvent(
          type: SyncDebugEventType.error,
          message: '❌ Erro ao sincronizar: $e',
          entityType: 'Sync',
        ),
      );
    }
  }

  // =========================================================================
  // TESTE 4: VERIFICAR STATUS DE SINCRONIZAÇÃO
  // =========================================================================

  /// Retorna estatísticas de sincronização
  Future<void> getSyncStatistics() async {
    try {
      final totalAnimals = _objectBox.animalBox.getAll().length;
      final totalAcoes = _objectBox.acaoBox.getAll().length;
      final totalTratamentos = _objectBox.tratamentoBox.getAll().length;

      final syncMetadata = _objectBox.syncMetadataBox.getAll();

      _logEvent(
        SyncDebugEvent(
          type: SyncDebugEventType.info,
          message: '📊 Estatísticas de sincronização',
          entityType: 'Statistics',
          details: {
            'totalAnimaisCachados': totalAnimals,
            'totalAcoesCachadas': totalAcoes,
            'totalTratamentosCachados': totalTratamentos,
            'isOnline': _syncService.isOnline,
            'initialSyncComplete': _syncService.initialSyncComplete,
            'syncMetadataCount': syncMetadata.length,
          },
        ),
      );
    } catch (e) {
      _logEvent(
        SyncDebugEvent(
          type: SyncDebugEventType.error,
          message: '❌ Erro ao obter estatísticas: $e',
          entityType: 'Statistics',
        ),
      );
    }
  }

  // =========================================================================
  // TESTE 5: SIMULAR MUDANÇA E VERIFICAR FLAG
  // =========================================================================

  /// Simula uma mudança local em um animal
  Future<void> simulateAnimalChange(String nomeAnimal) async {
    try {
      final animals = _objectBox.animalBox
          .query(AnimalEntity_.nomeAnimal.equals(nomeAnimal))
          .build()
          .find();

      if (animals.isEmpty) {
        _logEvent(
          SyncDebugEvent(
            type: SyncDebugEventType.error,
            message: '❌ Animal "$nomeAnimal" não encontrado',
            entityType: 'Animal',
          ),
        );
        return;
      }

      final animal = animals.first;
      final originalNeedSync = animal.needsSync;

      // Simula mudança
      animal.pesoAnimal = '${double.parse(animal.pesoAnimal ?? "0") + 5}';
      animal.needsSync = true;
      animal.lastModified = DateTime.now();
      _objectBox.animalBox.put(animal);

      _logEvent(
        SyncDebugEvent(
          type: SyncDebugEventType.success,
          message: '✅ Mudança simulada em "$nomeAnimal"',
          entityType: 'Animal',
          details: {
            'pesoAnterior': animal.pesoAnimal,
            'needsSyncAnterior': originalNeedSync,
            'needsSyncNovo': true,
            'lastModified': animal.lastModified?.toString(),
          },
        ),
      );
    } catch (e) {
      _logEvent(
        SyncDebugEvent(
          type: SyncDebugEventType.error,
          message: '❌ Erro ao simular mudança: $e',
          entityType: 'Animal',
        ),
      );
    }
  }

  // =========================================================================
  // TESTE 6: LISTAR DADOS LOCAIS
  // =========================================================================

  /// Lista todos os animais em cache
  Future<void> listLocalAnimals() async {
    try {
      final animals = _objectBox.animalBox.getAll();

      if (animals.isEmpty) {
        _logEvent(
          SyncDebugEvent(
            type: SyncDebugEventType.warning,
            message: '⚠️ Nenhum animal em cache local',
            entityType: 'Animal',
          ),
        );
        return;
      }

      _logEvent(
        SyncDebugEvent(
          type: SyncDebugEventType.info,
          message: '🐄 ${animals.length} animal(is) em cache local',
          entityType: 'Animal',
          details: {
            'total': animals.length,
            'comFirestoreId':
                animals.where((a) => a.firestoreId != null).length,
            'pendentesSync': animals.where((a) => a.needsSync).length,
          },
        ),
      );

      for (final animal in animals.take(10)) {
        debugPrint(
          '  • ${animal.nomeAnimal} (sync: ${animal.needsSync}, id: ${animal.firestoreId ?? 'novo'})',
        );
      }

      if (animals.length > 10) {
        debugPrint('  ... e mais ${animals.length - 10} animais');
      }
    } catch (e) {
      _logEvent(
        SyncDebugEvent(
          type: SyncDebugEventType.error,
          message: '❌ Erro ao listar animais: $e',
          entityType: 'Animal',
        ),
      );
    }
  }

  /// Lista todas as ações em cache
  Future<void> listLocalAcoes() async {
    try {
      final acoes = _objectBox.acaoBox.getAll();

      if (acoes.isEmpty) {
        _logEvent(
          SyncDebugEvent(
            type: SyncDebugEventType.warning,
            message: '⚠️ Nenhuma ação em cache local',
            entityType: 'Acao',
          ),
        );
        return;
      }

      _logEvent(
        SyncDebugEvent(
          type: SyncDebugEventType.info,
          message: '📝 ${acoes.length} ação(ões) em cache',
          entityType: 'Acao',
          details: {
            'total': acoes.length,
            'comFirestoreId': acoes.where((a) => a.firestoreId != null).length,
            'pendentesSync': acoes.where((a) => a.needsSync).length,
          },
        ),
      );

      for (final acao in acoes.take(10)) {
        debugPrint(
          '  • ${acao.acao} (sync: ${acao.needsSync}, id: ${acao.firestoreId ?? 'novo'})',
        );
      }
    } catch (e) {
      _logEvent(
        SyncDebugEvent(
          type: SyncDebugEventType.error,
          message: '❌ Erro ao listar ações: $e',
          entityType: 'Acao',
        ),
      );
    }
  }

  // =========================================================================
  // TESTE 7: LIMPEZA E RESET
  // =========================================================================

  /// Limpa todos os dados locais (usar com cuidado!)
  Future<void> clearAllLocalData() async {
    try {
      await _objectBox.clearAllData();
      _logEvent(
        SyncDebugEvent(
          type: SyncDebugEventType.warning,
          message: '🗑️ Todos os dados locais foram limpos',
          entityType: 'System',
        ),
      );
    } catch (e) {
      _logEvent(
        SyncDebugEvent(
          type: SyncDebugEventType.error,
          message: '❌ Erro ao limpar dados: $e',
          entityType: 'System',
        ),
      );
    }
  }

  void _logEvent(SyncDebugEvent event) {
    debugPrint(event.toString());
    _debugEventController.add(event);
  }

  void dispose() {
    _debugEventController.close();
    _instance = null;
  }
}

// ============================================================================
// MODELOS
// ============================================================================

enum SyncDebugEventType {
  success,
  error,
  warning,
  info,
}

class SyncDebugEvent {
  final SyncDebugEventType type;
  final String message;
  final String entityType;
  final Map<String, dynamic>? details;
  final DateTime timestamp;

  SyncDebugEvent({
    required this.type,
    required this.message,
    required this.entityType,
    this.details,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    final detailsStr =
        details?.entries.map((e) => '${e.key}: ${e.value}').join(', ') ?? '';
    final emoji = {
      SyncDebugEventType.success: '✅',
      SyncDebugEventType.error: '❌',
      SyncDebugEventType.warning: '⚠️',
      SyncDebugEventType.info: 'ℹ️',
    }[type];

    return '$emoji [$entityType] $message' +
        (detailsStr.isNotEmpty ? '\n   $detailsStr' : '');
  }
}
