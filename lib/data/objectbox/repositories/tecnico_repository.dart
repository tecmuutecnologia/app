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
    // Aparelho de PRODUTOR não tem o técnico na box: o delta vai só para a
    // fila e o contador do servidor continua certo, como no débito direto
    // que existia antes do offline-first.
    final tecnico = getByFirestoreId(tecnicoFirestoreId);
    if (tecnico != null) {
      tecnico.quantidadeAnimaisCadastrados += quantidade;
      tecnico.restanteLimiteAnimais -= quantidade;
      box.put(tecnico);
    }

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

  /// Devolve uma vaga de produtor ao técnico, no mesmo formato offline-first de
  /// [debitarCotaAnimais]: contadores locais na hora + delta na fila.
  ///
  /// Chamado quando uma propriedade com conta ativada é excluída de vez. Só a
  /// ativação ("Ativar conta"/"Liberar acesso") consome a vaga, então só a
  /// exclusão de uma propriedade ativada a devolve.
  void devolverVagaProdutor(String tecnicoFirestoreId) {
    final tecnico = getByFirestoreId(tecnicoFirestoreId);
    if (tecnico == null) return;

    if (tecnico.quantidadeProdutoresCadastrados > 0) {
      tecnico.quantidadeProdutoresCadastrados -= 1;
    }
    tecnico.restanteLimiteProdutores += 1;
    box.put(tecnico);

    _objectBox.pendingOperationBox.put(
      PendingOperationEntity(
        operationType: 'UPDATE',
        collectionName: collectionName,
        firestoreId: tecnicoFirestoreId,
        documentPath: '$collectionName/$tecnicoFirestoreId',
        dataJson: QueuePayloadCodec.encode({
          'quantidadeProdutoresCadastrados': QueueIncrement(-1),
          'restanteLimiteProdutores': QueueIncrement(1),
        }),
      ),
    );
  }

  /// Devolve vagas de animal ao técnico (descarte ou exclusão de animal ativo).
  /// Espelho de [debitarCotaAnimais]: contadores locais na hora + delta na fila.
  void devolverCotaAnimais(String tecnicoFirestoreId, {int quantidade = 1}) {
    // Sem o técnico na box (aparelho de produtor), só o delta vai à fila.
    final tecnico = getByFirestoreId(tecnicoFirestoreId);
    if (tecnico != null) {
      // Nunca deixa o contador local negativo (dados legados dessincronizados).
      tecnico.quantidadeAnimaisCadastrados =
          (tecnico.quantidadeAnimaisCadastrados - quantidade).clamp(0, 1 << 30);
      tecnico.restanteLimiteAnimais += quantidade;
      box.put(tecnico);
    }

    _objectBox.pendingOperationBox.put(
      PendingOperationEntity(
        operationType: 'UPDATE',
        collectionName: collectionName,
        firestoreId: tecnicoFirestoreId,
        documentPath: '$collectionName/$tecnicoFirestoreId',
        dataJson: QueuePayloadCodec.encode({
          'quantidadeAnimaisCadastrados': QueueIncrement(-quantidade),
          'restanteLimiteAnimais': QueueIncrement(quantidade),
        }),
      ),
    );
  }

  /// Há alteração do técnico ainda na fila? Quem recalcula o saldo a partir do
  /// servidor deve esperar a fila esvaziar para não sobrescrever deltas locais.
  bool temOperacaoPendente(String tecnicoFirestoreId) {
    final query = _objectBox.pendingOperationBox
        .query(PendingOperationEntity_.collectionName.equals(collectionName) &
            PendingOperationEntity_.firestoreId.equals(tecnicoFirestoreId))
        .build();
    try {
      return query.count() > 0;
    } finally {
      query.close();
    }
  }
}
