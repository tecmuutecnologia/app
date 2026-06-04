import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../objectbox_service.dart';
import '../offline_first_sync_service.dart';
import '../entities/index.dart';
import '../../../objectbox.g.dart';

/// Repositório para gerenciar AnimaisProdutores (Animais)
/// Usa ObjectBox como fonte primária e Firestore para sincronização
class AnimalRepository {
  final ObjectBoxService _objectBox;
  final OfflineFirstSyncService _syncService;
  final FirebaseFirestore _firestore;

  AnimalRepository({
    ObjectBoxService? objectBox,
    OfflineFirstSyncService? syncService,
    FirebaseFirestore? firestore,
  })  : _objectBox = objectBox ?? ObjectBoxService.instance,
        _syncService = syncService ?? OfflineFirstSyncService.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Obtém todos os animais de uma propriedade (local)
  List<AnimalEntity> getAnimaisByPropriedade(String propriedadePath) {
    return _objectBox.animalBox
        .query(AnimalEntity_.parentPath.equals(propriedadePath))
        .build()
        .find();
  }

  /// Obtém um animal pelo ID do Firestore
  AnimalEntity? getByFirestoreId(String firestoreId) {
    return _objectBox.animalBox
        .query(AnimalEntity_.firestoreId.equals(firestoreId))
        .build()
        .findFirst();
  }

  /// Obtém um animal pelo ID local do ObjectBox
  AnimalEntity? getById(int id) {
    return _objectBox.animalBox.get(id);
  }

  /// Busca animais pelo nome ou brinco
  List<AnimalEntity> search(String query, {String? propriedadePath}) {
    final queryLower = query.toLowerCase();

    var queryBuilder = _objectBox.animalBox.query();

    if (propriedadePath != null) {
      queryBuilder = _objectBox.animalBox
          .query(AnimalEntity_.parentPath.equals(propriedadePath));
    }

    final allAnimals = queryBuilder.build().find();

    return allAnimals.where((animal) {
      final nome = animal.nomeAnimal?.toLowerCase() ?? '';
      final brinco = animal.brincoAnimal.toString();
      final nomeBrinco = animal.nomeBrincoConcat?.toLowerCase() ?? '';

      return nome.contains(queryLower) ||
          brinco.contains(queryLower) ||
          nomeBrinco.contains(queryLower);
    }).toList();
  }

  /// Cria um novo animal
  Future<AnimalEntity> create({
    required String propriedadePath,
    required Map<String, dynamic> data,
  }) async {
    // Cria localmente
    final entity = AnimalEntity(
      parentPath: propriedadePath,
      nomeAnimal: data['nomeAnimal'],
      racaAnimal: data['racaAnimal'],
      pesoAnimal: data['pesoAnimal'],
      dtNascimento: data['dtNascimento'],
      touro: data['touro'],
      vaca: data['vaca'],
      status: data['status'],
      grupoAnimal: data['grupoAnimal'],
      brincoAnimal: data['brincoAnimal'] ?? 0,
      brincoAnimalOrder: data['brincoAnimalOrder'] ?? 0,
      nomeBrincoConcat: data['nomeBrincoConcat'],
      idGrupoAnimal: data['idGrupoAnimal'] ?? 0,
      idStatusAnimal: data['idStatusAnimal'] ?? 0,
      lastModified: DateTime.now(),
      needsSync: true,
    );

    final id = _objectBox.animalBox.put(entity);
    entity.id = id;

    // Agenda sincronização com Firestore
    if (_syncService.isOnline) {
      try {
        final collectionRef =
            _firestore.collection('$propriedadePath/animaisProdutores');
        final docRef = collectionRef.doc();
        await docRef.set(entity.toFirestore());

        entity.firestoreId = docRef.id;
        entity.needsSync = false;
        entity.lastSynced = DateTime.now();
        _objectBox.animalBox.put(entity);
      } catch (e) {
        debugPrint('❌ Erro ao sincronizar animal: $e');
        // Adiciona à fila de pendências
        _syncService.queueOperation(
          operationType: 'CREATE',
          collectionName: 'animaisProdutores',
          documentPath: '$propriedadePath/animaisProdutores/${entity.id}',
          data: entity.toFirestore(),
        );
      }
    } else {
      // Offline - adiciona à fila
      _syncService.queueOperation(
        operationType: 'CREATE',
        collectionName: 'animaisProdutores',
        documentPath: '$propriedadePath/animaisProdutores/${entity.id}',
        data: entity.toFirestore(),
      );
    }

    return entity;
  }

  /// Atualiza um animal existente
  Future<AnimalEntity> update(
      AnimalEntity entity, Map<String, dynamic> data) async {
    // Atualiza localmente
    entity.nomeAnimal = data['nomeAnimal'] ?? entity.nomeAnimal;
    entity.racaAnimal = data['racaAnimal'] ?? entity.racaAnimal;
    entity.pesoAnimal = data['pesoAnimal'] ?? entity.pesoAnimal;
    entity.dtNascimento = data['dtNascimento'] ?? entity.dtNascimento;
    entity.status = data['status'] ?? entity.status;
    entity.grupoAnimal = data['grupoAnimal'] ?? entity.grupoAnimal;
    entity.dtUltimaInseminacao =
        data['dtUltimaInseminacao'] ?? entity.dtUltimaInseminacao;
    entity.dtUltimoParto = data['dtUltimoParto'] ?? entity.dtUltimoParto;
    entity.liberaInseminacao =
        data['liberaInseminacao'] ?? entity.liberaInseminacao;
    entity.brincoAnimal = data['brincoAnimal'] ?? entity.brincoAnimal;
    entity.brincoAnimalOrder =
        data['brincoAnimalOrder'] ?? entity.brincoAnimalOrder;
    entity.nomeBrincoConcat =
        data['nomeBrincoConcat'] ?? entity.nomeBrincoConcat;
    entity.idGrupoAnimal = data['idGrupoAnimal'] ?? entity.idGrupoAnimal;
    entity.idStatusAnimal = data['idStatusAnimal'] ?? entity.idStatusAnimal;
    entity.totalInseminacoes =
        data['totalInseminacoes'] ?? entity.totalInseminacoes;
    entity.totalPartos = data['totalPartos'] ?? entity.totalPartos;

    entity.markAsModified();
    _objectBox.animalBox.put(entity);

    // Sincroniza com Firestore
    if (entity.firestoreId != null) {
      final documentPath =
          '${entity.parentPath}/animaisProdutores/${entity.firestoreId}';

      if (_syncService.isOnline) {
        try {
          await _firestore.doc(documentPath).update(entity.toFirestore());
          entity.needsSync = false;
          entity.lastSynced = DateTime.now();
          _objectBox.animalBox.put(entity);
        } catch (e) {
          debugPrint('❌ Erro ao atualizar animal no Firestore: $e');
          _syncService.queueOperation(
            operationType: 'UPDATE',
            collectionName: 'animaisProdutores',
            documentPath: documentPath,
            firestoreId: entity.firestoreId,
            data: entity.toFirestore(),
          );
        }
      } else {
        _syncService.queueOperation(
          operationType: 'UPDATE',
          collectionName: 'animaisProdutores',
          documentPath: documentPath,
          firestoreId: entity.firestoreId,
          data: entity.toFirestore(),
        );
      }
    }

    return entity;
  }

  /// Remove um animal (soft delete)
  Future<void> delete(AnimalEntity entity) async {
    entity.isDeleted = true;
    entity.markAsModified();
    _objectBox.animalBox.put(entity);

    if (entity.firestoreId != null) {
      final documentPath =
          '${entity.parentPath}/animaisProdutores/${entity.firestoreId}';

      if (_syncService.isOnline) {
        try {
          await _firestore.doc(documentPath).delete();
          _objectBox.animalBox.remove(entity.id);
        } catch (e) {
          debugPrint('❌ Erro ao deletar animal no Firestore: $e');
          _syncService.queueOperation(
            operationType: 'DELETE',
            collectionName: 'animaisProdutores',
            documentPath: documentPath,
            firestoreId: entity.firestoreId,
          );
        }
      } else {
        _syncService.queueOperation(
          operationType: 'DELETE',
          collectionName: 'animaisProdutores',
          documentPath: documentPath,
          firestoreId: entity.firestoreId,
        );
      }
    }
  }

  /// Obtém stream de animais (reatividade local)
  Stream<List<AnimalEntity>> watchAnimaisByPropriedade(String propriedadePath) {
    return _objectBox.animalBox
        .query(AnimalEntity_.parentPath.equals(propriedadePath))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  /// Conta animais por propriedade
  int countByPropriedade(String propriedadePath) {
    return _objectBox.animalBox
        .query(AnimalEntity_.parentPath.equals(propriedadePath))
        .build()
        .count();
  }

  /// Obtém animais que precisam de sincronização
  List<AnimalEntity> getPendingSync() {
    return _objectBox.animalBox
        .query(AnimalEntity_.needsSync.equals(true))
        .build()
        .find();
  }

  /// Obtém animais por status
  List<AnimalEntity> getByStatus(String status, {String? propriedadePath}) {
    if (propriedadePath != null) {
      return _objectBox.animalBox
          .query(AnimalEntity_.status
              .equals(status)
              .and(AnimalEntity_.parentPath.equals(propriedadePath)))
          .build()
          .find();
    }

    return _objectBox.animalBox
        .query(AnimalEntity_.status.equals(status))
        .build()
        .find();
  }

  /// Obtém animais por grupo
  List<AnimalEntity> getByGrupo(int idGrupo, {String? propriedadePath}) {
    if (propriedadePath != null) {
      return _objectBox.animalBox
          .query(AnimalEntity_.idGrupoAnimal
              .equals(idGrupo)
              .and(AnimalEntity_.parentPath.equals(propriedadePath)))
          .build()
          .find();
    }

    return _objectBox.animalBox
        .query(AnimalEntity_.idGrupoAnimal.equals(idGrupo))
        .build()
        .find();
  }
}
