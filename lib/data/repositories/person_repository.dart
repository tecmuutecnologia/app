import 'package:cloud_firestore/cloud_firestore.dart';
import '../../objectbox.g.dart'; // Gerado pelo build_runner
import '../local/person_entity.dart';
import '../objectbox_store.dart';
import 'base_repository.dart';

/// Repositório para Person com padrão local-first
///
/// Fluxo de dados:
/// 1. Leitura: Busca primeiro no ObjectBox local
/// 2. Escrita: Salva primeiro no ObjectBox, depois sincroniza com Firestore
/// 3. Sincronização: Background sync entre ObjectBox e Firestore
class PersonRepository implements BaseRepository<PersonEntity, PersonEntity> {
  late final Box<PersonEntity> _box;
  final CollectionReference _firestoreCollection =
      FirebaseFirestore.instance.collection('person');

  PersonRepository() {
    _box = ObjectBoxStore.instance.store.box<PersonEntity>();
  }

  @override
  Future<PersonEntity?> getById(int localId) async {
    return _box.get(localId);
  }

  @override
  Future<PersonEntity?> getByFirestoreId(String firestoreId) async {
    final query =
        _box.query(PersonEntity_.firestoreId.equals(firestoreId)).build();
    final result = query.findFirst();
    query.close();
    return result;
  }

  @override
  Future<List<PersonEntity>> getAll() async {
    final query = _box.query(PersonEntity_.isDeleted.equals(false)).build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Busca persons por UID do usuário
  Future<List<PersonEntity>> getByUid(String uid) async {
    final query = _box
        .query(PersonEntity_.uid.equals(uid) &
            PersonEntity_.isDeleted.equals(false))
        .build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Busca persons por empresa
  Future<List<PersonEntity>> getByEmpresa(String empresa) async {
    final query = _box
        .query(PersonEntity_.empresa.equals(empresa) &
            PersonEntity_.isDeleted.equals(false))
        .build();
    final results = query.find();
    query.close();
    return results;
  }

  @override
  Future<int> save(PersonEntity item) async {
    item.markForSync();
    final id = _box.put(item);

    // Trigger background sync (não bloqueia a operação)
    syncWithFirestore().catchError((e) {
      print('Erro ao sincronizar person: $e');
    });

    return id;
  }

  @override
  Future<List<int>> saveAll(List<PersonEntity> items) async {
    for (final item in items) {
      item.markForSync();
    }
    final ids = _box.putMany(items);

    // Trigger background sync
    syncWithFirestore().catchError((e) {
      print('Erro ao sincronizar persons: $e');
    });

    return ids;
  }

  @override
  Future<void> delete(int localId) async {
    final person = await getById(localId);
    if (person != null) {
      person.isDeleted = true;
      person.markForSync();
      _box.put(person);

      // Trigger background sync
      syncWithFirestore().catchError((e) {
        print('Erro ao sincronizar deleção de person: $e');
      });
    }
  }

  @override
  Future<void> syncWithFirestore() async {
    // Busca todos os itens que precisam ser sincronizados
    final query = _box.query(PersonEntity_.needsSync.equals(true)).build();
    final itemsToSync = query.find();
    query.close();

    for (final item in itemsToSync) {
      try {
        if (item.isDeleted) {
          // Deleta no Firestore
          if (item.firestoreId != null) {
            await _firestoreCollection.doc(item.firestoreId).delete();
          }
          // Remove completamente do ObjectBox
          _box.remove(item.id);
        } else {
          // Atualiza ou cria no Firestore
          if (item.firestoreId != null) {
            // Atualiza existente
            await _firestoreCollection
                .doc(item.firestoreId)
                .update(item.toFirestoreMap());
          } else {
            // Cria novo
            final docRef =
                await _firestoreCollection.add(item.toFirestoreMap());
            item.firestoreId = docRef.id;
          }

          item.markAsSynced();
          _box.put(item);
        }
      } catch (e) {
        print('Erro ao sincronizar item ${item.id}: $e');
        // Mantém needsSync = true para tentar novamente depois
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

        // Verifica se já existe localmente
        final existingQuery =
            _box.query(PersonEntity_.firestoreId.equals(firestoreId)).build();
        final existing = existingQuery.findFirst();
        existingQuery.close();

        if (existing != null) {
          // Atualiza apenas se não tiver alterações pendentes
          if (!existing.needsSync) {
            final updated = PersonEntity.fromFirestore(
              firestoreId: firestoreId,
              data: data,
            );
            updated.id = existing.id; // Mantém o ID local
            _box.put(updated);
          }
        } else {
          // Cria novo registro local
          final newEntity = PersonEntity.fromFirestore(
            firestoreId: firestoreId,
            data: data,
          );
          _box.put(newEntity);
        }
      }
    } catch (e) {
      print('Erro ao buscar persons do Firestore: $e');
      rethrow;
    }
  }

  /// Força sincronização bidirecional
  Future<void> fullSync() async {
    await fetchFromFirestore();
    await syncWithFirestore();
  }
}
