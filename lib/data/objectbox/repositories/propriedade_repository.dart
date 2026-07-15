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
  Stream<List<PropriedadeEntity>> watchAtivasByTecnico(String tecnicoPath) => box
      .query(PropriedadeEntity_.parentPath
          .equals(tecnicoPath)
          .and(PropriedadeEntity_.isDeleted.equals(false))
          .and(PropriedadeEntity_.contaCriada.equals(true)))
      .order(PropriedadeEntity_.displayName)
      .watch(triggerImmediately: true)
      .map((query) => query.find());

  /// Lixeira: propriedades soft-deletadas, mais recentes primeiro.
  Stream<List<PropriedadeEntity>> watchExcluidasByTecnico(String tecnicoPath) =>
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
  Stream<List<PropriedadeEntity>> watchPendingActivation(String parentPath) => box
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

  /// Persiste uma propriedade criada offline como PENDENTE de ativação.
  ///
  /// Diferente de [BaseSyncRepository.add], NÃO marca `needsSync` — a fila de
  /// sync não deve tentar enviar uma propriedade cujo produtor ainda não existe
  /// no Firestore. A entidade só entra no fluxo normal após [markContaCriada].
  PropriedadeEntity saveLocalPending(PropriedadeEntity entity) {
    entity.contaCriada = false;
    entity.needsSync = false;
    entity.lastModified = DateTime.now();
    entity.id = box.put(entity);
    return entity;
  }

  /// Reconcilia o registro local após a conta ser criada online: marca como
  /// conta criada e associa o `firestoreId` da PropriedadesRecord recém-criada.
  void markContaCriada(PropriedadeEntity entity, {required String firestoreId}) {
    entity.contaCriada = true;
    entity.firestoreId = firestoreId;
    entity.needsSync = false;
    entity.lastSynced = DateTime.now();
    box.put(entity);
  }
}
