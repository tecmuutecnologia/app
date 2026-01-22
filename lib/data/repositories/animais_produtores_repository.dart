import 'package:cloud_firestore/cloud_firestore.dart';
import '../../objectbox.g.dart';
import '../local/animais_produtores_entity.dart';
import '../objectbox_store.dart';
import 'base_repository.dart';

/// Repositório para AnimaisProdutores com padrão local-first
class AnimaisProdutoresRepository
    implements
        BaseRepository<AnimaisProdutoresEntity, AnimaisProdutoresEntity> {
  late final Box<AnimaisProdutoresEntity> _box;

  AnimaisProdutoresRepository() {
    _box = ObjectBoxStore.instance.store.box<AnimaisProdutoresEntity>();
  }

  @override
  Future<AnimaisProdutoresEntity?> getById(int localId) async {
    return _box.get(localId);
  }

  @override
  Future<AnimaisProdutoresEntity?> getByFirestoreId(String firestoreId) async {
    final query = _box
        .query(AnimaisProdutoresEntity_.firestoreId.equals(firestoreId))
        .build();
    final result = query.findFirst();
    query.close();
    return result;
  }

  @override
  Future<List<AnimaisProdutoresEntity>> getAll() async {
    final query =
        _box.query(AnimaisProdutoresEntity_.isDeleted.equals(false)).build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Busca animais por propriedade
  Future<List<AnimaisProdutoresEntity>> getByPropriedade(
      String propriedadeRef) async {
    final query = _box
        .query(AnimaisProdutoresEntity_.uidTecnicoPropriedade
                .equals(propriedadeRef) &
            AnimaisProdutoresEntity_.isDeleted.equals(false))
        .build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Busca por brinco
  Future<AnimaisProdutoresEntity?> getByBrinco(int brinco) async {
    final query = _box
        .query(AnimaisProdutoresEntity_.brincoAnimal.equals(brinco) &
            AnimaisProdutoresEntity_.isDeleted.equals(false))
        .build();
    final result = query.findFirst();
    query.close();
    return result;
  }

  /// Busca por status
  Future<List<AnimaisProdutoresEntity>> getByStatus(String status) async {
    final query = _box
        .query(AnimaisProdutoresEntity_.status.equals(status) &
            AnimaisProdutoresEntity_.isDeleted.equals(false))
        .build();
    final results = query.find();
    query.close();
    return results;
  }

  @override
  Future<int> save(AnimaisProdutoresEntity item) async {
    item.markForSync();
    final id = _box.put(item);

    syncWithFirestore().catchError((e) {
      print('Erro ao sincronizar animal: $e');
    });

    return id;
  }

  @override
  Future<List<int>> saveAll(List<AnimaisProdutoresEntity> items) async {
    for (final item in items) {
      item.markForSync();
    }
    final ids = _box.putMany(items);

    syncWithFirestore().catchError((e) {
      print('Erro ao sincronizar animais: $e');
    });

    return ids;
  }

  @override
  Future<void> delete(int localId) async {
    final animal = await getById(localId);
    if (animal != null) {
      animal.isDeleted = true;
      animal.markForSync();
      _box.put(animal);

      syncWithFirestore().catchError((e) {
        print('Erro ao sincronizar deleção de animal: $e');
      });
    }
  }

  @override
  Future<void> syncWithFirestore() async {
    final query =
        _box.query(AnimaisProdutoresEntity_.needsSync.equals(true)).build();
    final itemsToSync = query.find();
    query.close();

    for (final item in itemsToSync) {
      try {
        if (item.isDeleted) {
          if (item.firestoreId != null && item.parentReference != null) {
            await FirebaseFirestore.instance
                .doc(item.parentReference!)
                .collection('animais_produtores')
                .doc(item.firestoreId)
                .delete();
          }
          _box.remove(item.id);
        } else {
          if (item.firestoreId != null && item.parentReference != null) {
            await FirebaseFirestore.instance
                .doc(item.parentReference!)
                .collection('animais_produtores')
                .doc(item.firestoreId)
                .update(item.toFirestoreMap());
          }
          // Note: Criação de novos não implementada pois precisa do parent reference

          item.markAsSynced();
          _box.put(item);
        }
      } catch (e) {
        print('Erro ao sincronizar item ${item.id}: $e');
      }
    }
  }

  @override
  Future<void> fetchFromFirestore() async {
    try {
      // Note: AnimaisProdutores é uma subcoleção, precisa buscar por técnico
      // Esta implementação básica será melhorada conforme necessidade
      print(
          'fetchFromFirestore para animais_produtores requer parent reference');
    } catch (e) {
      print('Erro ao buscar animais do Firestore: $e');
      rethrow;
    }
  }

  Future<void> fullSync() async {
    await fetchFromFirestore();
    await syncWithFirestore();
  }
}
