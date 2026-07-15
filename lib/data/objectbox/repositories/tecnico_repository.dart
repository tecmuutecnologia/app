import '../objectbox_service.dart';
import '../entities/index.dart';
import '../../../objectbox.g.dart';
import 'top_level_sync_repository.dart';

/// Repositório de Tecnico (coleção de topo `tecnico`).
/// A sincronização é herdada de [TopLevelSyncRepository].
class TecnicoRepository extends TopLevelSyncRepository<TecnicoEntity> {
  TecnicoRepository({
    ObjectBoxService? objectBox,
    super.syncService,
    super.firestore,
  }) : _objectBox = objectBox ?? ObjectBoxService.instance;

  final ObjectBoxService _objectBox;

  @override
  Box<TecnicoEntity> get box => _objectBox.tecnicoBox;

  @override
  String get collectionName => 'tecnico';

  TecnicoEntity? getByFirestoreId(String firestoreId) => box
      .query(TecnicoEntity_.firestoreId.equals(firestoreId))
      .build()
      .findFirst();

  /// Busca o Técnico vinculado a um Person.
  TecnicoEntity? getByUidPerson(String uidPerson) =>
      box.query(TecnicoEntity_.uidPerson.equals(uidPerson)).build().findFirst();

  /// Técnico logado, reativo: os limites (`restanteLimiteProdutores`) mudam
  /// quando uma propriedade é criada ou uma conta de produtor é ativada.
  Stream<TecnicoEntity?> watchByUidPerson(String uidPerson) => box
      .query(TecnicoEntity_.uidPerson.equals(uidPerson))
      .watch(triggerImmediately: true)
      .map((query) => query.findFirst());

  @override
  List<TecnicoEntity> getPendingSync() =>
      box.query(TecnicoEntity_.needsSync.equals(true)).build().find();
}
