import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import 'objectbox_service.dart';
import 'entities/index.dart';
import '../../objectbox.g.dart';

/// Status da sincronização
enum SyncStatus {
  idle,
  syncing,
  completed,
  error,
  offline,
}

/// Serviço de sincronização entre ObjectBox e Firestore
class SyncService {
  static SyncService? _instance;

  final ObjectBoxService _objectBox;
  final FirebaseFirestore _firestore;
  final Connectivity _connectivity;

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  /// Stream controller para notificar sobre mudanças de status
  final _statusController = StreamController<SyncStatus>.broadcast();
  Stream<SyncStatus> get statusStream => _statusController.stream;

  SyncStatus _currentStatus = SyncStatus.idle;
  SyncStatus get currentStatus => _currentStatus;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  SyncService._({
    required ObjectBoxService objectBox,
    FirebaseFirestore? firestore,
    Connectivity? connectivity,
  })  : _objectBox = objectBox,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _connectivity = connectivity ?? Connectivity();

  /// Obtém a instância singleton do SyncService
  static SyncService get instance {
    if (_instance == null) {
      throw StateError(
        'SyncService não foi inicializado. '
        'Chame SyncService.initialize() primeiro.',
      );
    }
    return _instance!;
  }

  /// Verifica se o SyncService foi inicializado
  static bool get isInitialized => _instance != null;

  /// Inicializa o SyncService
  static Future<SyncService> initialize({
    FirebaseFirestore? firestore,
    Connectivity? connectivity,
  }) async {
    if (_instance != null) {
      return _instance!;
    }

    // Garante que o ObjectBox foi inicializado
    if (!ObjectBoxService.isInitialized) {
      await ObjectBoxService.initialize();
    }

    _instance = SyncService._(
      objectBox: ObjectBoxService.instance,
      firestore: firestore,
      connectivity: connectivity,
    );

    await _instance!._setupConnectivityListener();

    return _instance!;
  }

  /// Configura o listener de conectividade
  Future<void> _setupConnectivityListener() async {
    // Verifica conectividade inicial
    final result = await _connectivity.checkConnectivity();
    _isOnline = result != ConnectivityResult.none;

    // Escuta mudanças de conectividade
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        final wasOffline = !_isOnline;
        _isOnline = result != ConnectivityResult.none;

        if (_isOnline && wasOffline) {
          // Voltou a ter conexão - sincroniza pendências
          debugPrint('🔄 Conexão restaurada - iniciando sincronização');
          await syncPendingOperations();
        }

        _updateStatus(_isOnline ? SyncStatus.idle : SyncStatus.offline);
      },
    );
  }

  void _updateStatus(SyncStatus status) {
    _currentStatus = status;
    _statusController.add(status);
  }

  /// Sincroniza todas as operações pendentes com o Firestore
  Future<void> syncPendingOperations() async {
    if (!_isOnline) {
      debugPrint('📴 Offline - sincronização adiada');
      return;
    }

    _updateStatus(SyncStatus.syncing);

    try {
      final pendingOps = _objectBox.pendingOperationBox
          .query()
          .order(PendingOperationEntity_.priority)
          .order(PendingOperationEntity_.createdAt)
          .build()
          .find();

      debugPrint('📤 ${pendingOps.length} operações pendentes');

      for (final op in pendingOps) {
        try {
          await _executePendingOperation(op);
          _objectBox.pendingOperationBox.remove(op.id);
        } catch (e) {
          debugPrint('❌ Erro ao sincronizar operação: $e');
          op.retryCount++;
          op.lastError = e.toString();
          _objectBox.pendingOperationBox.put(op);

          if (op.retryCount >= 5) {
            debugPrint('⚠️ Operação excedeu máximo de tentativas');
          }
        }
      }

      _updateStatus(SyncStatus.completed);
    } catch (e) {
      debugPrint('❌ Erro na sincronização: $e');
      _updateStatus(SyncStatus.error);
    }
  }

  /// Executa uma operação pendente no Firestore
  Future<void> _executePendingOperation(PendingOperationEntity op) async {
    if (op.documentPath == null) return;

    final docRef = _firestore.doc(op.documentPath!);
    final data = op.dataJson != null ? jsonDecode(op.dataJson!) : null;

    switch (op.operationType) {
      case 'CREATE':
        await docRef.set(data);
        break;
      case 'UPDATE':
        await docRef.update(data);
        break;
      case 'DELETE':
        await docRef.delete();
        break;
    }
  }

  /// Sincroniza dados do Firestore para o ObjectBox (download)
  Future<void> syncFromFirestore({
    required String userId,
    bool fullSync = false,
  }) async {
    if (!_isOnline) {
      debugPrint('📴 Offline - usando dados locais');
      _updateStatus(SyncStatus.offline);
      return;
    }

    _updateStatus(SyncStatus.syncing);

    try {
      // Sincroniza Person do usuário atual
      await _syncPersonFromFirestore(userId);

      // Sincroniza Tecnico se existir
      await _syncTecnicoFromFirestore(userId);

      // Sincroniza Produtor se existir
      await _syncProdutorFromFirestore(userId);

      // Atualiza metadados de sincronização
      _updateSyncMetadata('full_sync', DateTime.now());

      _updateStatus(SyncStatus.completed);
      debugPrint('✅ Sincronização concluída');
    } catch (e) {
      debugPrint('❌ Erro na sincronização: $e');
      _updateStatus(SyncStatus.error);
      rethrow;
    }
  }

  /// Sincroniza dados de Person do Firestore
  Future<void> _syncPersonFromFirestore(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('person')
          .where('uid', isEqualTo: userId)
          .get();

      for (final doc in snapshot.docs) {
        final existing = _objectBox.personBox
            .query(PersonEntity_.firestoreId.equals(doc.id))
            .build()
            .findFirst();

        if (existing != null) {
          // Atualiza registro existente
          existing.updateFromFirestore(doc.data());
          _objectBox.personBox.put(existing);
        } else {
          // Cria novo registro
          final entity = PersonEntity.fromFirestore(doc.data(), doc.id);
          _objectBox.personBox.put(entity);
        }
      }

      debugPrint('👤 ${snapshot.docs.length} pessoa(s) sincronizada(s)');
    } catch (e) {
      debugPrint('❌ Erro ao sincronizar Person: $e');
    }
  }

  /// Sincroniza dados de Tecnico do Firestore
  Future<void> _syncTecnicoFromFirestore(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('tecnico')
          .where('uidPerson', isEqualTo: userId)
          .get();

      for (final doc in snapshot.docs) {
        final existing = _objectBox.tecnicoBox
            .query(TecnicoEntity_.firestoreId.equals(doc.id))
            .build()
            .findFirst();

        if (existing != null) {
          existing.updateFromFirestore(doc.data());
          _objectBox.tecnicoBox.put(existing);
        } else {
          final entity = TecnicoEntity.fromFirestore(doc.data(), doc.id);
          _objectBox.tecnicoBox.put(entity);
        }

        // Se é técnico, sincroniza seus produtores e animais
        await _syncProdutoresDoTecnico(doc.reference);
      }

      debugPrint('👨‍⚕️ ${snapshot.docs.length} técnico(s) sincronizado(s)');
    } catch (e) {
      debugPrint('❌ Erro ao sincronizar Tecnico: $e');
    }
  }

  /// Sincroniza dados de Produtor do Firestore
  Future<void> _syncProdutorFromFirestore(String userId) async {
    try {
      // Busca o person do usuário
      final personSnapshot = await _firestore
          .collection('person')
          .where('uid', isEqualTo: userId)
          .limit(1)
          .get();

      if (personSnapshot.docs.isEmpty) return;

      final personRef = personSnapshot.docs.first.reference;

      // Busca produtores vinculados a este person
      final snapshot = await _firestore
          .collection('produtor')
          .where('uidPerson', isEqualTo: personRef)
          .get();

      for (final doc in snapshot.docs) {
        final existing = _objectBox.produtorBox
            .query(ProdutorEntity_.firestoreId.equals(doc.id))
            .build()
            .findFirst();

        if (existing != null) {
          existing.updateFromFirestore(doc.data());
          _objectBox.produtorBox.put(existing);
        } else {
          final entity = ProdutorEntity.fromFirestore(doc.data(), doc.id);
          _objectBox.produtorBox.put(entity);
        }

        // Sincroniza propriedades do produtor
        await _syncPropriedadesDoProdutor(doc.reference);
      }

      debugPrint('🌾 ${snapshot.docs.length} produtor(es) sincronizado(s)');
    } catch (e) {
      debugPrint('❌ Erro ao sincronizar Produtor: $e');
    }
  }

  /// Sincroniza produtores vinculados a um técnico
  Future<void> _syncProdutoresDoTecnico(DocumentReference tecnicoRef) async {
    try {
      final snapshot = await _firestore
          .collection('produtor')
          .where('uidTecnico', isEqualTo: tecnicoRef)
          .get();

      for (final doc in snapshot.docs) {
        final existing = _objectBox.produtorBox
            .query(ProdutorEntity_.firestoreId.equals(doc.id))
            .build()
            .findFirst();

        if (existing != null) {
          existing.updateFromFirestore(doc.data());
          _objectBox.produtorBox.put(existing);
        } else {
          final entity = ProdutorEntity.fromFirestore(doc.data(), doc.id);
          _objectBox.produtorBox.put(entity);
        }

        // Sincroniza propriedades do produtor
        await _syncPropriedadesDoProdutor(doc.reference);
      }
    } catch (e) {
      debugPrint('❌ Erro ao sincronizar produtores do técnico: $e');
    }
  }

  /// Sincroniza propriedades de um produtor
  Future<void> _syncPropriedadesDoProdutor(
      DocumentReference produtorRef) async {
    try {
      final snapshot = await produtorRef.collection('propriedades').get();

      for (final doc in snapshot.docs) {
        final existing = _objectBox.propriedadeBox
            .query(PropriedadeEntity_.firestoreId.equals(doc.id))
            .build()
            .findFirst();

        if (existing != null) {
          existing.updateFromFirestore(doc.data());
          _objectBox.propriedadeBox.put(existing);
        } else {
          final entity = PropriedadeEntity.fromFirestore(
            doc.data(),
            doc.id,
            produtorRef.path,
          );
          _objectBox.propriedadeBox.put(entity);
        }

        // Sincroniza animais da propriedade
        await _syncAnimaisDaPropriedade(doc.reference);
      }

      debugPrint('🏡 ${snapshot.docs.length} propriedade(s) sincronizada(s)');
    } catch (e) {
      debugPrint('❌ Erro ao sincronizar propriedades: $e');
    }
  }

  /// Sincroniza animais de uma propriedade
  Future<void> _syncAnimaisDaPropriedade(
      DocumentReference propriedadeRef) async {
    try {
      final snapshot =
          await propriedadeRef.collection('animaisProdutores').get();

      for (final doc in snapshot.docs) {
        final existing = _objectBox.animalBox
            .query(AnimalEntity_.firestoreId.equals(doc.id))
            .build()
            .findFirst();

        if (existing != null) {
          existing.updateFromFirestore(doc.data());
          _objectBox.animalBox.put(existing);
        } else {
          final entity = AnimalEntity.fromFirestore(
            doc.data(),
            doc.id,
            propriedadeRef.path,
          );
          _objectBox.animalBox.put(entity);
        }
      }

      debugPrint('🐄 ${snapshot.docs.length} animal(is) sincronizado(s)');
    } catch (e) {
      debugPrint('❌ Erro ao sincronizar animais: $e');
    }
  }

  /// Atualiza metadados de sincronização
  void _updateSyncMetadata(String collection, DateTime timestamp) {
    var metadata = _objectBox.syncMetadataBox
        .query(SyncMetadataEntity_.collectionName.equals(collection))
        .build()
        .findFirst();

    if (metadata == null) {
      metadata = SyncMetadataEntity(
        collectionName: collection,
        lastFullSync: timestamp,
        initialSyncComplete: true,
      );
    } else {
      metadata.lastFullSync = timestamp;
    }

    _objectBox.syncMetadataBox.put(metadata);
  }

  /// Adiciona uma operação à fila de pendências
  void queueOperation({
    required String operationType,
    required String collectionName,
    required String documentPath,
    String? firestoreId,
    Map<String, dynamic>? data,
    int priority = 3,
  }) {
    final op = PendingOperationEntity(
      operationType: operationType,
      collectionName: collectionName,
      documentPath: documentPath,
      firestoreId: firestoreId,
      dataJson: data != null ? jsonEncode(data) : null,
      createdAt: DateTime.now(),
      priority: priority,
    );

    _objectBox.pendingOperationBox.put(op);

    // Se está online, tenta sincronizar imediatamente
    if (_isOnline) {
      syncPendingOperations();
    }
  }

  /// Libera recursos
  void dispose() {
    _connectivitySubscription?.cancel();
    _statusController.close();
    _instance = null;
  }
}
