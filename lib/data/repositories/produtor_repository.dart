import 'package:cloud_firestore/cloud_firestore.dart';
import '../../objectbox.g.dart';
import '../local/produtor_entity.dart';
import '../objectbox_store.dart';
import 'base_repository.dart';

/// Repositório para Produtor com padrão local-first
class ProdutorRepository
    implements BaseRepository<ProdutorEntity, ProdutorEntity> {
  late final Box<ProdutorEntity> _box;
  final CollectionReference _firestoreCollection =
      FirebaseFirestore.instance.collection('produtor');

  ProdutorRepository() {
    _box = ObjectBoxStore.instance.store.box<ProdutorEntity>();
  }

  @override
  Future<ProdutorEntity?> getById(int localId) async {
    return _box.get(localId);
  }

  @override
  Future<ProdutorEntity?> getByFirestoreId(String firestoreId) async {
    final query =
        _box.query(ProdutorEntity_.firestoreId.equals(firestoreId)).build();
    final result = query.findFirst();
    query.close();
    return result;
  }

  @override
  Future<List<ProdutorEntity>> getAll() async {
    final query = _box.query(ProdutorEntity_.isDeleted.equals(false)).build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Busca produtor por UID da pessoa
  Future<ProdutorEntity?> getByUidPerson(String uidPerson) async {
    final query = _box
        .query(ProdutorEntity_.uidPerson.equals(uidPerson) &
            ProdutorEntity_.isDeleted.equals(false))
        .build();
    final result = query.findFirst();
    query.close();
    return result;
  }

  /// Busca produtores por técnico
  Future<List<ProdutorEntity>> getByTecnico(String uidTecnico) async {
    final query = _box
        .query(ProdutorEntity_.uidTecnico.equals(uidTecnico) &
            ProdutorEntity_.isDeleted.equals(false))
        .build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Busca produtores liberados
  Future<List<ProdutorEntity>> getLiberados() async {
    final query = _box
        .query(ProdutorEntity_.liberado.equals(true) &
            ProdutorEntity_.isDeleted.equals(false))
        .build();
    final results = query.find();
    query.close();
    return results;
  }

  @override
  Future<int> save(ProdutorEntity item) async {
    item.markForSync();
    final id = _box.put(item);

    syncWithFirestore().catchError((e) {
      print('Erro ao sincronizar produtor: $e');
    });

    return id;
  }

  @override
  Future<List<int>> saveAll(List<ProdutorEntity> items) async {
    for (final item in items) {
      item.markForSync();
    }
    final ids = _box.putMany(items);

    syncWithFirestore().catchError((e) {
      print('Erro ao sincronizar produtores: $e');
    });

    return ids;
  }

  @override
  Future<void> delete(int localId) async {
    final produtor = await getById(localId);
    if (produtor != null) {
      produtor.isDeleted = true;
      produtor.markForSync();
      _box.put(produtor);

      syncWithFirestore().catchError((e) {
        print('Erro ao sincronizar deleção de produtor: $e');
      });
    }
  }

  @override
  Future<void> syncWithFirestore() async {
    final query = _box.query(ProdutorEntity_.needsSync.equals(true)).build();
    final itemsToSync = query.find();
    query.close();

    for (final item in itemsToSync) {
      try {
        if (item.isDeleted) {
          if (item.firestoreId != null) {
            await _firestoreCollection.doc(item.firestoreId).delete();
          }
          _box.remove(item.id);
        } else {
          if (item.firestoreId != null) {
            await _firestoreCollection
                .doc(item.firestoreId)
                .update(item.toFirestoreMap());
          } else {
            final docRef =
                await _firestoreCollection.add(item.toFirestoreMap());
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
      final snapshot = await _firestoreCollection.get();

      for (final doc in snapshot.docs) {
        final firestoreId = doc.id;
        final data = doc.data() as Map<String, dynamic>;

        final existingQuery =
            _box.query(ProdutorEntity_.firestoreId.equals(firestoreId)).build();
        final existing = existingQuery.findFirst();
        existingQuery.close();

        if (existing != null) {
          if (!existing.needsSync) {
            final updated = ProdutorEntity.fromFirestore(
              firestoreId: firestoreId,
              data: data,
            );
            updated.id = existing.id;
            _box.put(updated);
          }
        } else {
          final newEntity = ProdutorEntity.fromFirestore(
            firestoreId: firestoreId,
            data: data,
          );
          _box.put(newEntity);
        }
      }
    } catch (e) {
      print('Erro ao buscar produtores do Firestore: $e');
      rethrow;
    }
  }

  Future<void> fullSync() async {
    await fetchFromFirestore();
    await syncWithFirestore();
  }
}
