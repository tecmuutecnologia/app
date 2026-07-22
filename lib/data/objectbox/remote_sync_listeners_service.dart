import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'objectbox_service.dart';
import 'repositories/propriedade_repository.dart';
import 'entities/index.dart';
import '../../core/sync/conflict_resolver.dart';
import '../../objectbox.g.dart';

/// Serviço de listeners para sincronização BIDIRECIONAL
/// Monitora mudanças no Firestore e atualiza o ObjectBox automaticamente
/// Isto garante que dados atualizados em outro dispositivo chegam automaticamente
class RemoteSyncListenersService {
  static RemoteSyncListenersService? _instance;
  final FirebaseFirestore _firestore;
  final ObjectBoxService _objectBox;

  final Map<String, dynamic> _listeners = {};

  RemoteSyncListenersService._({
    required FirebaseFirestore firestore,
    required ObjectBoxService objectBox,
  })  : _firestore = firestore,
        _objectBox = objectBox;

  static RemoteSyncListenersService get instance {
    if (_instance == null) {
      throw StateError(
        'RemoteSyncListenersService não foi inicializado. '
        'Chame RemoteSyncListenersService.initialize() primeiro.',
      );
    }
    return _instance!;
  }

  static bool get isInitialized => _instance != null;

  static Future<RemoteSyncListenersService> initialize({
    FirebaseFirestore? firestore,
  }) async {
    if (_instance != null) {
      return _instance!;
    }

    if (!ObjectBoxService.isInitialized) {
      await ObjectBoxService.initialize();
    }

    _instance = RemoteSyncListenersService._(
      firestore: firestore ?? FirebaseFirestore.instance,
      objectBox: ObjectBoxService.instance,
    );

    return _instance!;
  }

  // =========================================================================
  // LISTENERS DE ANIMAIS
  // =========================================================================

  /// Inicia listener para mudanças de animais no Firestore
  /// Qualquer mudança remota é refletida no ObjectBox
  void listenToAnimalsChanges(String propriedadeParentPath) {
    final listenerId = 'animals_$propriedadeParentPath';

    if (_listeners.containsKey(listenerId)) {
      debugPrint('⚠️ Listener para $listenerId já ativo');
      return;
    }

    final ref = _firestore.doc(propriedadeParentPath);

    _listeners[listenerId] = ref
        .collection('animaisProdutores')
        .snapshots(
          includeMetadataChanges: true,
        )
        .listen(
      (snapshot) {
        for (final change in snapshot.docChanges) {
          _processAnimalChange(change);
        }
      },
      onError: (error) {
        debugPrint('❌ Erro no listener de animais: $error');
      },
    );

    debugPrint('👂 Listener iniciado para animais em $propriedadeParentPath');
  }

  void _processAnimalChange(DocumentChange change) {
    final animalId = change.doc.id;
    final data = change.doc.data() as Map<String, dynamic>;

    switch (change.type) {
      case DocumentChangeType.added:
        _onAnimalAdded(
            animalId, data, change.doc.reference.parent.parent!.path);
        break;
      case DocumentChangeType.modified:
        _onAnimalModified(animalId, data);
        break;
      case DocumentChangeType.removed:
        _onAnimalRemoved(animalId);
        break;
    }
  }

  void _onAnimalAdded(
      String animalId, Map<String, dynamic> data, String parentPath) {
    try {
      // Verifica se já existe localmente
      final existing = _objectBox.animalBox
          .query(AnimalEntity_.firestoreId.equals(animalId))
          .build()
          .findFirst();

      if (existing == null) {
        // Novo animal remoto - adiciona ao cache
        final entity = AnimalEntity.fromFirestore(data, animalId, parentPath);
        _objectBox.animalBox.put(entity);
        debugPrint(
          '✨ Novo animal remoto adicionado ao cache: ${entity.nomeAnimal}',
        );
      }
    } catch (e) {
      debugPrint('❌ Erro ao processar novo animal: $e');
    }
  }

  void _onAnimalModified(String animalId, Map<String, dynamic> data) {
    try {
      final existing = _objectBox.animalBox
          .query(AnimalEntity_.firestoreId.equals(animalId))
          .build()
          .findFirst();

      if (existing != null) {
        final remoteTimestamp =
            (data['lastModified'] as dynamic)?.toDate() as DateTime?;

        if (ConflictResolver.shouldApplyRemote(
          localHasPendingChanges: existing.needsSync,
          localLastModified: existing.lastModified,
          remoteLastModified: remoteTimestamp,
        )) {
          existing.updateFromFirestore(data);
          _objectBox.animalBox.put(existing);
          debugPrint(
            '🔄 Animal ${existing.nomeAnimal} atualizado do Firestore',
          );
        } else {
          debugPrint(
            '⚠️ Mudança remota ignorada para ${existing.nomeAnimal} '
            '(local mais recente ou com edição pendente)',
          );
        }
      }
    } catch (e) {
      debugPrint('❌ Erro ao processar mudança de animal: $e');
    }
  }

  void _onAnimalRemoved(String animalId) {
    try {
      final existing = _objectBox.animalBox
          .query(AnimalEntity_.firestoreId.equals(animalId))
          .build()
          .findFirst();

      if (existing != null && !existing.needsSync) {
        // Marca como deletado em vez de remover (soft delete)
        existing.isDeleted = true;
        _objectBox.animalBox.put(existing);
        debugPrint('🗑️ Animal ${existing.nomeAnimal} marcado como deletado');
      }
    } catch (e) {
      debugPrint('❌ Erro ao processar remoção de animal: $e');
    }
  }

  // =========================================================================
  // LISTENERS DE AÇÕES
  // =========================================================================

  /// Inicia listener para mudanças de ações
  void listenToAcoesChanges(String animalParentPath) {
    final listenerId = 'acoes_$animalParentPath';

    if (_listeners.containsKey(listenerId)) {
      return;
    }

    final ref = _firestore.doc(animalParentPath);

    _listeners[listenerId] = ref.collection('acoes').snapshots().listen(
      (snapshot) {
        for (final change in snapshot.docChanges) {
          _processAcaoChange(change, animalParentPath);
        }
      },
      onError: (error) {
        debugPrint('❌ Erro no listener de ações: $error');
      },
    );

    debugPrint('👂 Listener iniciado para ações em $animalParentPath');
  }

  void _processAcaoChange(DocumentChange change, String parentPath) {
    final acaoId = change.doc.id;
    final data = change.doc.data() as Map<String, dynamic>?;

    if (data == null) return;

    switch (change.type) {
      case DocumentChangeType.added:
        _onAcaoAdded(acaoId, data, parentPath);
        break;
      case DocumentChangeType.modified:
        _onAcaoModified(acaoId, data);
        break;
      case DocumentChangeType.removed:
        _onAcaoRemoved(acaoId);
        break;
    }
  }

  void _onAcaoAdded(
      String acaoId, Map<String, dynamic> data, String parentPath) {
    try {
      final existing = _objectBox.acaoBox
          .query(AcaoEntity_.firestoreId.equals(acaoId))
          .build()
          .findFirst();

      if (existing == null) {
        final entity = AcaoEntity.fromFirestore(data, acaoId, parentPath);
        _objectBox.acaoBox.put(entity);
        debugPrint('✨ Nova ação remota adicionada: ${entity.acao}');
      }
    } catch (e) {
      debugPrint('❌ Erro ao processar nova ação: $e');
    }
  }

  void _onAcaoModified(String acaoId, Map<String, dynamic> data) {
    try {
      final existing = _objectBox.acaoBox
          .query(AcaoEntity_.firestoreId.equals(acaoId))
          .build()
          .findFirst();

      if (existing != null) {
        final remoteTimestamp =
            (data['lastModified'] as dynamic)?.toDate() as DateTime?;

        if (ConflictResolver.shouldApplyRemote(
          localHasPendingChanges: existing.needsSync,
          localLastModified: existing.lastModified,
          remoteLastModified: remoteTimestamp,
        )) {
          // Re-cria entidade a partir dos dados remotos, preservando o parentPath.
          final updated = AcaoEntity.fromFirestore(
            data,
            acaoId,
            existing.parentPath ?? '',
          );
          _objectBox.acaoBox.put(updated);
          debugPrint('🔄 Ação atualizada do Firestore');
        }
      }
    } catch (e) {
      debugPrint('❌ Erro ao processar mudança de ação: $e');
    }
  }

  void _onAcaoRemoved(String acaoId) {
    try {
      final existing = _objectBox.acaoBox
          .query(AcaoEntity_.firestoreId.equals(acaoId))
          .build()
          .findFirst();

      if (existing != null && !existing.needsSync) {
        _objectBox.acaoBox.remove(existing.id);
        debugPrint('🗑️ Ação removida do cache');
      }
    } catch (e) {
      debugPrint('❌ Erro ao processar remoção de ação: $e');
    }
  }

  // =========================================================================
  // LISTENERS DE TRATAMENTOS
  // =========================================================================

  /// Inicia listener para mudanças de tratamentos de UMA propriedade.
  ///
  /// Tratamentos são subcoleção da PROPRIEDADE. Antes este listener recebia o
  /// caminho do TÉCNICO (o parâmetro chamava-se `animalParentPath`, mas
  /// `startAllListeners` passava o técnico), ou seja escutava
  /// `tecnico/{id}/tratamentos` — coleção que nunca existiu. Nunca disparava;
  /// se disparasse, gravaria `parentPath` errado.
  void listenToTratamentosChanges(String propriedadePath) {
    final listenerId = 'tratamentos_$propriedadePath';

    if (_listeners.containsKey(listenerId)) {
      return;
    }

    final ref = _firestore.doc(propriedadePath);

    _listeners[listenerId] = ref.collection('tratamentos').snapshots().listen(
      (snapshot) {
        for (final change in snapshot.docChanges) {
          _processTratamentoChange(change, propriedadePath);
        }
      },
      onError: (error) {
        debugPrint('❌ Erro no listener de tratamentos: $error');
      },
    );

    debugPrint('👂 Listener iniciado para tratamentos em $propriedadePath');
  }

  void _processTratamentoChange(DocumentChange change, String parentPath) {
    final tratamentoId = change.doc.id;
    final data = change.doc.data() as Map<String, dynamic>?;

    if (data == null) return;

    switch (change.type) {
      case DocumentChangeType.added:
        _onTratamentoAdded(tratamentoId, data, parentPath);
        break;
      case DocumentChangeType.modified:
        _onTratamentoModified(tratamentoId, data);
        break;
      case DocumentChangeType.removed:
        _onTratamentoRemoved(tratamentoId);
        break;
    }
  }

  void _onTratamentoAdded(
      String tratamentoId, Map<String, dynamic> data, String parentPath) {
    try {
      final existing = _objectBox.tratamentoBox
          .query(TratamentoEntity_.firestoreId.equals(tratamentoId))
          .build()
          .findFirst();

      if (existing == null) {
        final entity = TratamentoEntity.fromFirestore(
          data,
          tratamentoId,
          parentPath: parentPath,
        );
        _objectBox.tratamentoBox.put(entity);
        debugPrint(
          '✨ Novo tratamento remoto adicionado: ${entity.nomeAnimal}',
        );
      }
    } catch (e) {
      debugPrint('❌ Erro ao processar novo tratamento: $e');
    }
  }

  void _onTratamentoModified(String tratamentoId, Map<String, dynamic> data) {
    try {
      final existing = _objectBox.tratamentoBox
          .query(TratamentoEntity_.firestoreId.equals(tratamentoId))
          .build()
          .findFirst();

      if (existing != null) {
        // Tratamentos usam a chave snake_case 'last_modified' (Timestamp).
        final remoteTimestamp = (data['last_modified'] as Timestamp?)?.toDate();

        if (ConflictResolver.shouldApplyRemote(
          localHasPendingChanges: existing.needsSync,
          localLastModified: existing.lastModified,
          remoteLastModified: remoteTimestamp,
        )) {
          // Re-cria entidade a partir dos dados remotos, preservando o parentPath.
          final updated = TratamentoEntity.fromFirestore(
            data,
            tratamentoId,
            parentPath: existing.parentPath,
          );
          _objectBox.tratamentoBox.put(updated);
          debugPrint('🔄 Tratamento atualizado do Firestore');
        }
      }
    } catch (e) {
      debugPrint('❌ Erro ao processar mudança de tratamento: $e');
    }
  }

  void _onTratamentoRemoved(String tratamentoId) {
    try {
      final existing = _objectBox.tratamentoBox
          .query(TratamentoEntity_.firestoreId.equals(tratamentoId))
          .build()
          .findFirst();

      if (existing != null && !existing.needsSync) {
        _objectBox.tratamentoBox.remove(existing.id);
        debugPrint('🗑️ Tratamento removido do cache');
      }
    } catch (e) {
      debugPrint('❌ Erro ao processar remoção de tratamento: $e');
    }
  }

  // =========================================================================
  // GERENCIAMENTO DE LISTENERS
  // =========================================================================

  /// Remove um listener específico
  void removeListener(String listenerId) {
    final listener = _listeners.remove(listenerId);
    if (listener != null) {
      listener.cancel();
      debugPrint('🛑 Listener removido: $listenerId');
    }
  }

  /// Remove todos os listeners
  void removeAllListeners() {
    for (final listener in _listeners.values) {
      listener?.cancel();
    }
    _listeners.clear();
    debugPrint('🛑 Todos os listeners foram removidos');
  }

  /// Inicia os listeners de animais, ações e tratamentos para um técnico.
  ///
  /// [tecnicoPath] é o caminho do documento do técnico (`tecnico/<id>`) — é onde
  /// vivem as subcoleções `animaisProdutores`, `acoes` e `tratamentos`. Os
  /// métodos `listenToX` apenas fazem `ref.collection(<nome>)`, então passar o
  /// path do técnico escuta o lugar correto. Idempotente: cada `listenToX` pula
  /// se já houver listener para aquele path.
  ///
  /// Conflitos resolvidos por [ConflictResolver] (edição local pendente vence),
  /// então mudanças remotas NÃO sobrescrevem edições offline ainda não enviadas.
  void startAllListeners(String tecnicoPath) {
    if (tecnicoPath.isEmpty) return;
    listenToAnimalsChanges(tecnicoPath);
    listenToAcoesChanges(tecnicoPath);
    // Animais e ações ficam sob o técnico; tratamentos, sob cada propriedade.
    for (final prop in PropriedadeRepository().getAll()) {
      if (prop.firestoreId == null || prop.parentPath == null) continue;
      listenToTratamentosChanges(
          '${prop.parentPath}/propriedades/${prop.firestoreId}');
    }
    debugPrint('👂 Listeners remotos iniciados para $tecnicoPath');
  }

  /// Retorna quantidade de listeners ativos
  int get activeListenersCount => _listeners.length;

  void dispose() {
    removeAllListeners();
    _instance = null;
  }
}
