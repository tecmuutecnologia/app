import 'dart:async';

import '../../../core/result/result.dart';
import '../objectbox_service.dart';
import '../entities/index.dart';
import '../../../objectbox.g.dart';
import 'base_sync_repository.dart';

/// Repositório de AnimaisProdutores (animais).
///
/// Usa ObjectBox como fonte primária e delega a [BaseSyncRepository] toda a
/// orquestração de sincronização com o Firestore (criar/atualizar/excluir com
/// fila de pendências). Aqui ficam apenas as queries e o mapeamento de campos
/// específicos do animal.
class AnimalRepository extends BaseSyncRepository<AnimalEntity> {
  AnimalRepository({
    ObjectBoxService? objectBox,
    super.syncService,
    super.firestore,
  }) : _objectBox = objectBox ?? ObjectBoxService.instance;

  final ObjectBoxService _objectBox;

  @override
  Box<AnimalEntity> get box => _objectBox.animalBox;

  @override
  String get collectionName => 'animaisProdutores';

  /// O CREATE/UPDATE dos animais é feito por `_syncModifiedAnimals` (set-merge
  /// no id). Não enfileirar evita dupla-sync.
  @override
  bool get syncedByModifiedLoop => true;

  /// O animal nasce com um firestoreId real (offline) — seu path/ref fica válido
  /// na hora e as ações já o referenciam, sem depender de reconciliação.
  @override
  bool get preGeneratesFirestoreId => true;

  /// Reanexa o vínculo com a propriedade como `DocumentReference` — a entity
  /// pura (`toFirestore`) não o inclui. Sem isto, animal criado offline sobe ao
  /// Firestore SEM `uidTecnicoPropriedade` (ficaria órfão da propriedade em
  /// reports/segundo device). Espelha `AcaoRepository.firestorePayloadFor`.
  @override
  Map<String, dynamic> firestorePayloadFor(AnimalEntity entity) {
    final data = entity.toFirestore();
    if (entity.uidTecnicoPropriedadePath != null) {
      data['uidTecnicoPropriedade'] =
          firestore.doc(entity.uidTecnicoPropriedadePath!);
    }
    return data;
  }

  // ---------------------------------------------------------------------------
  // Queries específicas de animal
  // ---------------------------------------------------------------------------

  /// Obtém todos os animais de uma propriedade (local).
  List<AnimalEntity> getAnimaisByPropriedade(String propriedadePath) {
    return box
        .query(AnimalEntity_.uidTecnicoPropriedadePath.equals(propriedadePath))
        .build()
        .find();
  }

  /// True se já existe um animal ATIVO (não descartado, não soft-deletado) na
  /// propriedade com o MESMO par (nomeAnimal, brincoAnimal).
  ///
  /// A identidade de um animal é o par nome+brinco: `mimosa` sem brinco só pode
  /// existir uma vez, mas `mimosa` + `123` e `mimosa` + `456` coexistem. Animais
  /// descartados (`status == 'Descarte'`) liberam o par novamente.
  ///
  /// [excluirFirestoreId] / [excluirUidAnimalOffline] ignoram o próprio animal
  /// (usado na edição, para não acusar duplicata contra si mesmo).
  bool existeAnimalAtivoComNomeBrinco({
    required String propriedadePath,
    required String? nome,
    required int brinco,
    String? excluirFirestoreId,
    String? excluirUidAnimalOffline,
  }) {
    return getAnimaisByPropriedade(propriedadePath).any((a) =>
        a.status != 'Descarte' &&
        !a.isDeleted &&
        a.nomeAnimal == nome &&
        a.brincoAnimal == brinco &&
        !(excluirFirestoreId != null && a.firestoreId == excluirFirestoreId) &&
        !(excluirUidAnimalOffline != null &&
            a.uidAnimalOffline == excluirUidAnimalOffline));
  }

  /// Obtém um animal pelo ID do Firestore.
  AnimalEntity? getByFirestoreId(String firestoreId) {
    return box
        .query(AnimalEntity_.firestoreId.equals(firestoreId))
        .build()
        .findFirst();
  }

  /// Obtém um animal criado offline pela sua identidade local (uidAnimalOffline).
  /// Usado para localizar/agir sobre animais que ainda não têm `firestoreId`.
  AnimalEntity? getByUidAnimalOffline(String uidAnimalOffline) {
    return box
        .query(AnimalEntity_.uidAnimalOffline.equals(uidAnimalOffline))
        .build()
        .findFirst();
  }

  /// Busca animais pelo nome ou brinco.
  List<AnimalEntity> search(String query, {String? propriedadePath}) {
    final queryLower = query.toLowerCase();

    final builder = propriedadePath != null
        ? box.query(
            AnimalEntity_.uidTecnicoPropriedadePath.equals(propriedadePath))
        : box.query();
    final allAnimals = builder.build().find();

    return allAnimals.where((animal) {
      final nome = animal.nomeAnimal?.toLowerCase() ?? '';
      final brinco = animal.brincoAnimal.toString();
      final nomeBrinco = animal.nomeBrincoConcat?.toLowerCase() ?? '';

      return nome.contains(queryLower) ||
          brinco.contains(queryLower) ||
          nomeBrinco.contains(queryLower);
    }).toList();
  }

  /// Stream de animais de uma propriedade (reatividade local do ObjectBox).
  Stream<List<AnimalEntity>> watchAnimaisByPropriedade(String propriedadePath) {
    return box
        .query(AnimalEntity_.uidTecnicoPropriedadePath.equals(propriedadePath))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  /// Stream de todos os animais do aparelho (reatividade local do ObjectBox).
  ///
  /// Sem filtro de propriedade de propósito: o cache local contém apenas os
  /// animais do técnico logado, então isto já é o rebanho dele.
  Stream<List<AnimalEntity>> watchTodos() =>
      box.query().watch(triggerImmediately: true).map((q) => q.find());

  /// Conta animais por propriedade.
  int countByPropriedade(String propriedadePath) {
    return box
        .query(AnimalEntity_.uidTecnicoPropriedadePath.equals(propriedadePath))
        .build()
        .count();
  }

  /// Animais pendentes de sincronização (query indexada).
  @override
  List<AnimalEntity> getPendingSync() {
    return box.query(AnimalEntity_.needsSync.equals(true)).build().find();
  }

  /// Obtém animais por status.
  List<AnimalEntity> getByStatus(String status, {String? propriedadePath}) {
    final condition = propriedadePath != null
        ? AnimalEntity_.status.equals(status).and(
            AnimalEntity_.uidTecnicoPropriedadePath.equals(propriedadePath))
        : AnimalEntity_.status.equals(status);
    return box.query(condition).build().find();
  }

  /// Obtém animais por grupo.
  List<AnimalEntity> getByGrupo(int idGrupo, {String? propriedadePath}) {
    final condition = propriedadePath != null
        ? AnimalEntity_.idGrupoAnimal.equals(idGrupo).and(
            AnimalEntity_.uidTecnicoPropriedadePath.equals(propriedadePath))
        : AnimalEntity_.idGrupoAnimal.equals(idGrupo);
    return box.query(condition).build().find();
  }

  // ---------------------------------------------------------------------------
  // Escrita (delega a sincronização à BaseSyncRepository)
  // ---------------------------------------------------------------------------

  /// Cria um novo animal localmente e sincroniza (ou enfileira).
  Future<Result<AnimalEntity>> create({
    required String propriedadePath,
    required Map<String, dynamic> data,
  }) async {
    final entity = AnimalEntity(
      parentPath: propriedadePath,
      nomeAnimal: data['nomeAnimal'],
      racaAnimal: data['racaAnimal'],
      pesoAnimal: data['pesoAnimal'],
      dtNascimento: data['dtNascimento'],
      touro: data['touro'],
      vaca: data['vaca'],
      status: data['status'],
      grupoAnimal: data['grupoAnimal'],
      brincoAnimal: data['brincoAnimal'] ?? 0,
      brincoAnimalOrder: data['brincoAnimalOrder'] ?? 0,
      nomeBrincoConcat: data['nomeBrincoConcat'],
      idGrupoAnimal: data['idGrupoAnimal'] ?? 0,
      idStatusAnimal: data['idStatusAnimal'] ?? 0,
      lastModified: DateTime.now(),
      needsSync: true,
    );

    final id = box.put(entity);
    entity.id = id;

    return pushCreate(entity);
  }

  /// Atualiza um animal existente localmente e sincroniza (ou enfileira).
  Future<Result<AnimalEntity>> update(
      AnimalEntity entity, Map<String, dynamic> data) async {
    entity.nomeAnimal = data['nomeAnimal'] ?? entity.nomeAnimal;
    entity.racaAnimal = data['racaAnimal'] ?? entity.racaAnimal;
    entity.pesoAnimal = data['pesoAnimal'] ?? entity.pesoAnimal;
    entity.dtNascimento = data['dtNascimento'] ?? entity.dtNascimento;
    entity.touro = data['touro'] ?? entity.touro;
    entity.vaca = data['vaca'] ?? entity.vaca;
    entity.status = data['status'] ?? entity.status;
    entity.grupoAnimal = data['grupoAnimal'] ?? entity.grupoAnimal;
    entity.dtUltimaInseminacao =
        data['dtUltimaInseminacao'] ?? entity.dtUltimaInseminacao;
    entity.nomeTouroUltimaInseminacao =
        data['nomeTouroUltimaInseminacao'] ?? entity.nomeTouroUltimaInseminacao;
    entity.compararDtUltimaInseminacao = data['compararDtUltimaInseminacao'] ??
        entity.compararDtUltimaInseminacao;
    entity.dtUltimoParto = data['dtUltimoParto'] ?? entity.dtUltimoParto;
    // Datas de ciclo (definidas/limpas pelos formulários de ação).
    entity.dtPartoPrevisto = data['dtPartoPrevisto'] ?? entity.dtPartoPrevisto;
    entity.dtSecPrevista = data['dtSecPrevista'] ?? entity.dtSecPrevista;
    entity.dtPrePartoPrevista =
        data['dtPrePartoPrevista'] ?? entity.dtPrePartoPrevista;
    entity.dtPreParto = data['dtPreParto'] ?? entity.dtPreParto;
    entity.dtPP = data['dtPP'] ?? entity.dtPP;
    entity.dtUltimoPP = data['dtUltimoPP'] ?? entity.dtUltimoPP;
    entity.dtDgMais = data['dtDgMais'] ?? entity.dtDgMais;
    entity.dtDgMenos = data['dtDgMenos'] ?? entity.dtDgMenos;
    entity.dtAborto = data['dtAborto'] ?? entity.dtAborto;
    entity.dtSecagem = data['dtSecagem'] ?? entity.dtSecagem;
    entity.dtInducaoLactacao =
        data['dtInducaoLactacao'] ?? entity.dtInducaoLactacao;
    entity.dtUltimaAcao = data['dtUltimaAcao'] ?? entity.dtUltimaAcao;
    entity.dtUltimoPartoContingencia =
        data['dtUltimoPartoContingencia'] ?? entity.dtUltimoPartoContingencia;
    entity.dtDesmame = data['dtDesmame'] ?? entity.dtDesmame;
    entity.liberaInseminacao =
        data['liberaInseminacao'] ?? entity.liberaInseminacao;
    entity.brincoAnimal = data['brincoAnimal'] ?? entity.brincoAnimal;
    entity.brincoAnimalOrder =
        data['brincoAnimalOrder'] ?? entity.brincoAnimalOrder;
    entity.nomeBrincoConcat =
        data['nomeBrincoConcat'] ?? entity.nomeBrincoConcat;
    entity.idGrupoAnimal = data['idGrupoAnimal'] ?? entity.idGrupoAnimal;
    entity.idStatusAnimal = data['idStatusAnimal'] ?? entity.idStatusAnimal;
    entity.totalInseminacoes =
        data['totalInseminacoes'] ?? entity.totalInseminacoes;
    entity.totalPartos = data['totalPartos'] ?? entity.totalPartos;

    entity.markAsModified();
    box.put(entity);

    return pushUpdate(entity);
  }

  /// Remove um animal (soft delete) localmente e sincroniza (ou enfileira).
  Future<Result<void>> delete(AnimalEntity entity) => pushDelete(entity);
}
