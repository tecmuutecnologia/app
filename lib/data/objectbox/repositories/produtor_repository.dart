import '../objectbox_service.dart';
import '../entities/index.dart';
import '../../../objectbox.g.dart';
import 'top_level_sync_repository.dart';

/// Repositório de Produtor (coleção de topo `produtor`).
/// A sincronização é herdada de [TopLevelSyncRepository].
class ProdutorRepository extends TopLevelSyncRepository<ProdutorEntity> {
  ProdutorRepository({
    ObjectBoxService? objectBox,
    super.syncService,
    super.firestore,
  }) : _objectBox = objectBox ?? ObjectBoxService.instance;

  final ObjectBoxService _objectBox;

  @override
  Box<ProdutorEntity> get box => _objectBox.produtorBox;

  @override
  String get collectionName => 'produtor';

  ProdutorEntity? getByFirestoreId(String firestoreId) => box
      .query(ProdutorEntity_.firestoreId.equals(firestoreId))
      .build()
      .findFirst();

  @override
  List<ProdutorEntity> getPendingSync() =>
      box.query(ProdutorEntity_.needsSync.equals(true)).build().find();
}
