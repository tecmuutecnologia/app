import 'package:cloud_firestore/cloud_firestore.dart';
import '../../objectbox.g.dart';
import '../local/propriedades_entity.dart';
import '../objectbox_store.dart';
import 'base_repository.dart';

/// Repositório para Propriedades com padrão local-first
class PropriedadesRepository
    implements BaseRepository<PropriedadesEntity, PropriedadesEntity> {
  late final Box<PropriedadesEntity> _box;

  PropriedadesRepository() {
    _box = ObjectBoxStore.instance.store.box<PropriedadesEntity>();
  }

  @override
  Future<PropriedadesEntity?> getById(int localId) async {
    return _box.get(localId);
  }

  @override
  Future<PropriedadesEntity?> getByFirestoreId(String firestoreId) async {
    final query =
        _box.query(PropriedadesEntity_.firestoreId.equals(firestoreId)).build();
    final result = query.findFirst();
    query.close();
    return result;
  }

  @override
  Future<List<PropriedadesEntity>> getAll() async {
    final query =
        _box.query(PropriedadesEntity_.isDeleted.equals(false)).build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Busca propriedades por técnico
  Future<List<PropriedadesEntity>> getByTecnico(String tecnicoRef) async {
    final query = _box
        .query(PropriedadesEntity_.parentReference.equals(tecnicoRef) &
            PropriedadesEntity_.isDeleted.equals(false))
        .build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Busca propriedades por produtor
  Future<List<PropriedadesEntity>> getByProdutor(String produtorRef) async {
    final query = _box
        .query(PropriedadesEntity_.uidPersonProdutor.equals(produtorRef) &
            PropriedadesEntity_.isDeleted.equals(false))
        .build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Busca por CPF
  Future<PropriedadesEntity?> getByCpf(String cpf) async {
    final query = _box
        .query(PropriedadesEntity_.cpf.equals(cpf) &
            PropriedadesEntity_.isDeleted.equals(false))
        .build();
    final result = query.findFirst();
    query.close();
    return result;
  }

  @override
  Future<int> save(PropriedadesEntity item) async {
    item.markForSync();
    final id = _box.put(item);

    syncWithFirestore().catchError((e) {
      print('Erro ao sincronizar propriedade: $e');
    });

    return id;
  }

  @override
  Future<List<int>> saveAll(List<PropriedadesEntity> items) async {
    for (final item in items) {
      item.markForSync();
    }
    final ids = _box.putMany(items);

    syncWithFirestore().catchError((e) {
      print('Erro ao sincronizar propriedades: $e');
    });

    return ids;
  }

  @override
  Future<void> delete(int localId) async {
    final propriedade = await getById(localId);
    if (propriedade != null) {
      propriedade.isDeleted = true;
      propriedade.markForSync();
      _box.put(propriedade);

      syncWithFirestore().catchError((e) {
        print('Erro ao sincronizar deleção de propriedade: $e');
      });
    }
  }

  @override
  Future<void> syncWithFirestore() async {
    final query =
        _box.query(PropriedadesEntity_.needsSync.equals(true)).build();
    final itemsToSync = query.find();
    query.close();

    for (final item in itemsToSync) {
      try {
        if (item.isDeleted) {
          if (item.firestoreId != null && item.parentReference != null) {
            await FirebaseFirestore.instance
                .doc(item.parentReference!)
                .collection('propriedades')
                .doc(item.firestoreId)
                .delete();
          }
          _box.remove(item.id);
        } else {
          if (item.firestoreId != null && item.parentReference != null) {
            await FirebaseFirestore.instance
                .doc(item.parentReference!)
                .collection('propriedades')
                .doc(item.firestoreId)
                .update(item.toFirestoreMap());
          } else if (item.parentReference != null) {
            final docRef = await FirebaseFirestore.instance
                .doc(item.parentReference!)
                .collection('propriedades')
                .add(item.toFirestoreMap());
            item.firestoreId = docRef.id;
          }

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
      // Note: Propriedades é uma subcoleção, precisa buscar por técnico
      print('fetchFromFirestore para propriedades requer parent reference');
    } catch (e) {
      print('Erro ao buscar propriedades do Firestore: $e');
      rethrow;
    }
  }

  Future<void> fullSync() async {
    await fetchFromFirestore();
    await syncWithFirestore();
  }
}
