import '../../../core/sync/queue_payload_codec.dart';
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

  /// Debita a cota de animais do técnico: aplica o efeito no ObjectBox na hora
  /// e enfileira o incremento atômico para o Firestore.
  ///
  /// Offline-first de verdade: os contadores locais mudam imediatamente (a UI e
  /// as checagens de limite leem daqui, então funcionam sem internet) e o
  /// Firestore é atualizado quando a fila drenar. Antes isto era um
  /// `update(FieldValue.increment)` direto no Firestore, feito só quando havia
  /// conexão — animal criado offline nunca debitava a cota, e a contagem do
  /// servidor ia ficando para trás do rebanho real.
  ///
  /// O que vai para a fila é o DELTA, não o total: se o técnico cadastrar cinco
  /// animais offline, chegam cinco incrementos de 1, e o resultado é o mesmo de
  /// tê-los cadastrado online, um a um.
  void debitarCotaAnimais(String tecnicoFirestoreId, {int quantidade = 1}) {
    final tecnico = getByFirestoreId(tecnicoFirestoreId);
    if (tecnico == null) return;

    tecnico.quantidadeAnimaisCadastrados += quantidade;
    tecnico.restanteLimiteAnimais -= quantidade;
    box.put(tecnico);

    _objectBox.pendingOperationBox.put(
      PendingOperationEntity(
        operationType: 'UPDATE',
        collectionName: collectionName,
        firestoreId: tecnicoFirestoreId,
        documentPath: '$collectionName/$tecnicoFirestoreId',
        dataJson: QueuePayloadCodec.encode({
          'quantidadeAnimaisCadastrados': QueueIncrement(quantidade),
          'restanteLimiteAnimais': QueueIncrement(-quantidade),
        }),
      ),
    );
  }
}
