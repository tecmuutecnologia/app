import 'package:cloud_firestore/cloud_firestore.dart';
import '../../objectbox.g.dart';
import '../local/tecnico_entity.dart';
import '../objectbox_store.dart';
import 'base_repository.dart';

/// Repositório para Tecnico com padrão local-first
class TecnicoRepository
    implements BaseRepository<TecnicoEntity, TecnicoEntity> {
  late final Box<TecnicoEntity> _box;
  final CollectionReference _firestoreCollection =
      FirebaseFirestore.instance.collection('tecnico');

  TecnicoRepository() {
    _box = ObjectBoxStore.instance.store.box<TecnicoEntity>();
  }

  @override
  Future<TecnicoEntity?> getById(int localId) async {
    return _box.get(localId);
  }

  @override
  Future<TecnicoEntity?> getByFirestoreId(String firestoreId) async {
    final query =
        _box.query(TecnicoEntity_.firestoreId.equals(firestoreId)).build();
    final result = query.findFirst();
    query.close();
    return result;
  }

  @override
  Future<List<TecnicoEntity>> getAll() async {
    final query = _box.query(TecnicoEntity_.isDeleted.equals(false)).build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Busca técnico por UID da pessoa
  Future<TecnicoEntity?> getByUidPerson(String uidPerson) async {
    final query = _box
        .query(TecnicoEntity_.uidPerson.equals(uidPerson) &
            TecnicoEntity_.isDeleted.equals(false))
        .build();
    final result = query.findFirst();
    query.close();
    return result;
  }

  /// Busca técnicos liberados
  Future<List<TecnicoEntity>> getLiberados() async {
    final query = _box
        .query(TecnicoEntity_.liberado.equals(true) &
            TecnicoEntity_.isDeleted.equals(false))
        .build();
    final results = query.find();
    query.close();
    return results;
  }

  @override
  Future<int> save(TecnicoEntity item) async {
    item.markForSync();
    final id = _box.put(item);

    syncWithFirestore().catchError((e) {
      print('Erro ao sincronizar técnico: $e');
    });

    return id;
  }

  @override
  Future<List<int>> saveAll(List<TecnicoEntity> items) async {
    for (final item in items) {
      item.markForSync();
    }
    final ids = _box.putMany(items);

    syncWithFirestore().catchError((e) {
      print('Erro ao sincronizar técnicos: $e');
    });

    return ids;
  }

  @override
  Future<void> delete(int localId) async {
    final tecnico = await getById(localId);
    if (tecnico != null) {
      tecnico.isDeleted = true;
      tecnico.markForSync();
      _box.put(tecnico);

      syncWithFirestore().catchError((e) {
        print('Erro ao sincronizar deleção de técnico: $e');
      });
    }
  }

  @override
  Future<void> syncWithFirestore() async {
    final query = _box.query(TecnicoEntity_.needsSync.equals(true)).build();
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
            _box.query(TecnicoEntity_.firestoreId.equals(firestoreId)).build();
        final existing = existingQuery.findFirst();
        existingQuery.close();

        if (existing != null) {
          if (!existing.needsSync) {
            final updated = TecnicoEntity.fromFirestore(
              firestoreId: firestoreId,
              data: data,
            );
            updated.id = existing.id;
            _box.put(updated);
          }
        } else {
          final newEntity = TecnicoEntity.fromFirestore(
            firestoreId: firestoreId,
            data: data,
          );
          _box.put(newEntity);
        }
      }
    } catch (e) {
      print('Erro ao buscar técnicos do Firestore: $e');
      rethrow;
    }
  }

  Future<void> fullSync() async {
    await fetchFromFirestore();
    await syncWithFirestore();
  }
}
