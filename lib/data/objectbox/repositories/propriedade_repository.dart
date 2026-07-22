import 'dart:async';

import '../../../core/result/result.dart';
import '../objectbox_service.dart';
import '../entities/index.dart';
import '../../../objectbox.g.dart';
import 'base_sync_repository.dart';

/// Repositório de Propriedades (subcoleção `propriedades` de cada produtor).
/// A sincronização é herdada de [BaseSyncRepository].
class PropriedadeRepository extends BaseSyncRepository<PropriedadeEntity> {
  PropriedadeRepository({
    ObjectBoxService? objectBox,
    super.syncService,
    super.firestore,
  }) : _objectBox = objectBox ?? ObjectBoxService.instance;

  final ObjectBoxService _objectBox;

  @override
  Box<PropriedadeEntity> get box => _objectBox.propriedadeBox;

  @override
  String get collectionName => 'propriedades';

  /// A propriedade nasce com um firestoreId real (offline) e sincroniza sozinha
  /// ao reconectar — independentemente da ativação da conta do produtor.
  @override
  bool get preGeneratesFirestoreId => true;

  /// O CREATE/UPDATE da propriedade é feito pelo laço `_syncModifiedPropriedades`
  /// (set-merge no id). Não enfileirar evita dupla-sync.
  @override
  bool get syncedByModifiedLoop => true;

  /// Reanexa o vínculo com o produtor (`uidPersonProdutor` como
  /// `DocumentReference`) quando já existe — a entity pura (`toFirestore`) não o
  /// inclui. Com `set(merge)` no sync, o campo nunca é apagado quando ausente.
  @override
  Map<String, dynamic> firestorePayloadFor(PropriedadeEntity entity) {
    final data = entity.toFirestore();
    if (entity.uidPersonProdutorPath != null) {
      data['uidPersonProdutor'] = firestore.doc(entity.uidPersonProdutorPath!);
    }
    return data;
  }

  /// Gera um firestoreId real (offline) para uma propriedade que ainda não tem
  /// — usado no backfill de pendentes legadas (criadas antes deste mecanismo).
  String gerarFirestoreId(PropriedadeEntity entity) =>
      firestore.collection('${entity.parentPath}/propriedades').doc().id;

  /// Garante um firestoreId (backfill de pendente legada). Persiste e marca
  /// `needsSync` para a propriedade subir sozinha. Retorna o id garantido.
  String ensureFirestoreId(PropriedadeEntity entity) {
    if (entity.firestoreId != null) return entity.firestoreId!;
    entity.firestoreId = gerarFirestoreId(entity);
    entity.needsSync = true;
    entity.lastModified = DateTime.now();
    box.put(entity);
    return entity.firestoreId!;
  }

  /// Busca uma propriedade pelo ID do Firestore (query indexada).
  PropriedadeEntity? getByFirestoreId(String firestoreId) => box
      .query(PropriedadeEntity_.firestoreId.equals(firestoreId))
      .build()
      .findFirst();

  @override
  List<PropriedadeEntity> getByParentPath(String parentPath) => box
      .query(PropriedadeEntity_.parentPath.equals(parentPath))
      .build()
      .find();

  @override
  List<PropriedadeEntity> getPendingSync() =>
      box.query(PropriedadeEntity_.needsSync.equals(true)).build().find();

  /// Stream reativa das propriedades de um produtor.
  Stream<List<PropriedadeEntity>> watchByParentPath(String parentPath) => box
      .query(PropriedadeEntity_.parentPath.equals(parentPath))
      .watch(triggerImmediately: true)
      .map((query) => query.find());

  /// Propriedades ATIVAS de um técnico: conta já criada e não excluídas,
  /// ordenadas por nome (espelha o `orderBy('display_name')` do Firestore).
  Stream<List<PropriedadeEntity>> watchAtivasByTecnico(String tecnicoPath) =>
      box
          .query(PropriedadeEntity_.parentPath
              .equals(tecnicoPath)
              .and(PropriedadeEntity_.isDeleted.equals(false))
              .and(PropriedadeEntity_.contaCriada.equals(true)))
          .order(PropriedadeEntity_.displayName)
          .watch(triggerImmediately: true)
          .map((query) => query.find());

  /// Lixeira: propriedades soft-deletadas, mais recentes primeiro.
  Stream<List<PropriedadeEntity>> watchExcluidasByTecnico(
          String tecnicoPath) =>
      box
          .query(PropriedadeEntity_.parentPath
              .equals(tecnicoPath)
              .and(PropriedadeEntity_.isDeleted.equals(true)))
          .order(PropriedadeEntity_.deletedAt, flags: Order.descending)
          .watch(triggerImmediately: true)
          .map((query) => query.find());

  /// Uma propriedade específica, reativa (telas de detalhe/edição).
  Stream<PropriedadeEntity?> watchByFirestoreId(String firestoreId) => box
      .query(PropriedadeEntity_.firestoreId.equals(firestoreId))
      .watch(triggerImmediately: true)
      .map((query) => query.findFirst());

  /// Uma propriedade pelo ID LOCAL do ObjectBox, reativa. Usada para editar
  /// propriedades PENDENTES (criadas offline), que ainda não têm `firestoreId`.
  Stream<PropriedadeEntity?> watchByLocalId(int id) => box
      .query(PropriedadeEntity_.id.equals(id))
      .watch(triggerImmediately: true)
      .map((query) => query.findFirst());

  /// Busca local por CPF (checagem offline de duplicidade). Ignora excluídos.
  PropriedadeEntity? getByCpf(String cpf) => box
      .query(PropriedadeEntity_.cpf
          .equals(cpf)
          .and(PropriedadeEntity_.isDeleted.equals(false)))
      .build()
      .findFirst();

  /// Busca local por e-mail (checagem offline de duplicidade). Ignora excluídos.
  PropriedadeEntity? getByEmail(String email) => box
      .query(PropriedadeEntity_.email
          .equals(email)
          .and(PropriedadeEntity_.isDeleted.equals(false)))
      .build()
      .findFirst();

  /// Propriedades salvas offline aguardando ativação da conta, sob um técnico.
  List<PropriedadeEntity> getPendingActivation(String parentPath) => box
      .query(PropriedadeEntity_.parentPath
          .equals(parentPath)
          .and(PropriedadeEntity_.contaCriada.equals(false))
          .and(PropriedadeEntity_.isDeleted.equals(false)))
      .build()
      .find();

  /// Stream reativa das propriedades pendentes de ativação de um técnico.
  Stream<List<PropriedadeEntity>> watchPendingActivation(String parentPath) =>
      box
          .query(PropriedadeEntity_.parentPath
              .equals(parentPath)
              .and(PropriedadeEntity_.contaCriada.equals(false))
              .and(PropriedadeEntity_.isDeleted.equals(false)))
          .watch(triggerImmediately: true)
          .map((query) => query.find());

  /// Restaura uma propriedade da lixeira (offline-first: vira um UPDATE no
  /// Firestore, enfileirado se estiver sem internet).
  Future<Result<PropriedadeEntity>> restaurar(PropriedadeEntity entity) {
    entity.isDeleted = false;
    entity.deletedAt = null;
    return save(entity);
  }

  /// Exclusão PERMANENTE (esvaziar da lixeira): apaga o documento no Firestore
  /// e remove o registro local. Diferente do soft-delete da lista, que só marca
  /// `isDeleted` para manter a propriedade restaurável.
  Future<Result<void>> excluirPermanente(PropriedadeEntity entity) =>
      softDelete(entity);

  /// Persiste uma propriedade criada offline. Ela nasce com um firestoreId REAL
  /// e `needsSync = true`, então sincroniza sozinha ao reconectar (via
  /// `_syncModifiedPropriedades`) — sem depender da ativação. `contaCriada`
  /// permanece `false` (sem produtor vinculado) até a ativação.
  PropriedadeEntity saveLocalPending(PropriedadeEntity entity) {
    entity.contaCriada = false;
    entity.firestoreId ??= gerarFirestoreId(entity);
    entity.needsSync = true;
    entity.lastModified = DateTime.now();
    entity.id = box.put(entity);
    return entity;
  }

  /// Reconcilia o registro local após a ATIVAÇÃO vincular o produtor: marca a
  /// conta como criada e guarda o path do produtor. O `firestoreId` já existe
  /// desde a criação (não muda na ativação).
  void markContaCriada(PropriedadeEntity entity,
      {required String uidPersonProdutorPath}) {
    entity.contaCriada = true;
    entity.uidPersonProdutorPath = uidPersonProdutorPath;
    entity.needsSync = false;
    entity.lastSynced = DateTime.now();
    box.put(entity);
  }
}
