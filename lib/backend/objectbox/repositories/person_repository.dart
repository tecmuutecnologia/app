import '../objectbox_service.dart';
import '../entities/index.dart';
import '../../../objectbox.g.dart';
import 'top_level_sync_repository.dart';

/// Repositório de Person (coleção de topo `person`).
/// A sincronização é herdada de [TopLevelSyncRepository].
class PersonRepository extends TopLevelSyncRepository<PersonEntity> {
  PersonRepository({
    ObjectBoxService? objectBox,
    super.syncService,
    super.firestore,
  }) : _objectBox = objectBox ?? ObjectBoxService.instance;

  final ObjectBoxService _objectBox;

  @override
  Box<PersonEntity> get box => _objectBox.personBox;

  @override
  String get collectionName => 'person';

  PersonEntity? getByFirestoreId(String firestoreId) => box
      .query(PersonEntity_.firestoreId.equals(firestoreId))
      .build()
      .findFirst();

  /// Busca o Person pelo UID do Firebase Auth.
  PersonEntity? getByUid(String uid) =>
      box.query(PersonEntity_.uid.equals(uid)).build().findFirst();

  @override
  List<PersonEntity> getPendingSync() =>
      box.query(PersonEntity_.needsSync.equals(true)).build().find();
}
