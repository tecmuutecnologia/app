import 'package:objectbox/objectbox.dart';

import 'syncable_entity.dart';

/// Entidade AnimaisProdutores para armazenamento local com ObjectBox
/// Sincroniza com a subcoleção 'animaisProdutores' do Firestore
@Entity()
class AnimalEntity implements SyncableEntity {
  @override
  @Id()
  int id = 0;

  /// ID do documento no Firestore (usado para sincronização)
  @override
  @Unique()
  String? firestoreId;

  /// Path do documento pai (propriedade)
  @override
  String? parentPath;

  /// Referência ao técnico/propriedade (path do documento Firestore)
  String? uidTecnicoPropriedadePath;

  // Dados básicos do animal
  String? nomeAnimal;
  String? racaAnimal;
  String? pesoAnimal;
  String? dtNascimento;
  String? touro;
  String? vaca;
  String? status;
  String? grupoAnimal;

  // Datas importantes
  String? dtUltimaInseminacao;
  String? dtUltimoParto;
  String? dtPartoPrevisto;
  String? dtSecPrevista;
  String? dtPrePartoPrevista;
  String? dtPP;
  String? dtDgMais;
  String? dtDgMenos;
  String? dtAborto;
  String? dtSecagem;
  String? dtUltimoPP;
  String? dtPreParto;
  String? dtDescarteAnimal;
  String? dtUltimaAcao;
  String? dtUltimoPartoContingencia;

  // Outros campos
  bool liberaInseminacao;
  String? nomeTouroUltimaInseminacao;
  int totalInseminacoes;
  int totalPartos;
  String? motivoDescarteAnimal;
  String? nomeBrincoConcat;
  int idGrupoAnimal;
  int idStatusAnimal;
  int brincoAnimal;
  int brincoAnimalOrder;

  @Property(type: PropertyType.date)
  DateTime? compararDtUltimaInseminacao;

  @Property(type: PropertyType.date)
  DateTime? dtInducaoLactacao;

  @Property(type: PropertyType.date)
  DateTime? dtDesmame;

  /// Campos de controle de sincronização
  @override
  @Property(type: PropertyType.date)
  DateTime? lastModified;

  @override
  @Property(type: PropertyType.date)
  DateTime? lastSynced;

  @override
  bool needsSync;
  @override
  bool isDeleted;

  AnimalEntity({
    this.firestoreId,
    this.parentPath,
    this.uidTecnicoPropriedadePath,
    this.nomeAnimal,
    this.racaAnimal,
    this.pesoAnimal,
    this.dtNascimento,
    this.touro,
    this.vaca,
    this.status,
    this.grupoAnimal,
    this.dtUltimaInseminacao,
    this.dtUltimoParto,
    this.dtPartoPrevisto,
    this.dtSecPrevista,
    this.dtPrePartoPrevista,
    this.dtPP,
    this.dtDgMais,
    this.dtDgMenos,
    this.dtAborto,
    this.dtSecagem,
    this.dtUltimoPP,
    this.dtPreParto,
    this.dtDescarteAnimal,
    this.dtUltimaAcao,
    this.dtUltimoPartoContingencia,
    this.liberaInseminacao = false,
    this.nomeTouroUltimaInseminacao,
    this.totalInseminacoes = 0,
    this.totalPartos = 0,
    this.motivoDescarteAnimal,
    this.nomeBrincoConcat,
    this.idGrupoAnimal = 0,
    this.idStatusAnimal = 0,
    this.brincoAnimal = 0,
    this.brincoAnimalOrder = 0,
    this.compararDtUltimaInseminacao,
    this.dtInducaoLactacao,
    this.dtDesmame,
    this.lastModified,
    this.lastSynced,
    this.needsSync = false,
    this.isDeleted = false,
  });

  factory AnimalEntity.fromFirestore(
    Map<String, dynamic> data,
    String docId,
    String parentPath,
  ) {
    return AnimalEntity(
      firestoreId: docId,
      parentPath: parentPath,
      uidTecnicoPropriedadePath: data['uidTecnicoPropriedade']?.path,
      nomeAnimal: data['nomeAnimal'] as String?,
      racaAnimal: data['racaAnimal'] as String?,
      pesoAnimal: data['pesoAnimal'] as String?,
      dtNascimento: data['dtNascimento'] as String?,
      touro: data['touro'] as String?,
      vaca: data['vaca'] as String?,
      status: data['status'] as String?,
      grupoAnimal: data['grupoAnimal'] as String?,
      dtUltimaInseminacao: data['dtUltimaInseminacao'] as String?,
      dtUltimoParto: data['dtUltimoParto'] as String?,
      dtPartoPrevisto: data['dtPartoPrevisto'] as String?,
      dtSecPrevista: data['dtSecPrevista'] as String?,
      dtPrePartoPrevista: data['dtPrePartoPrevista'] as String?,
      dtPP: data['dtPP'] as String?,
      dtDgMais: data['dtDgMais'] as String?,
      dtDgMenos: data['dtDgMenos'] as String?,
      dtAborto: data['dtAborto'] as String?,
      dtSecagem: data['dtSecagem'] as String?,
      dtUltimoPP: data['dtUltimoPP'] as String?,
      dtPreParto: data['dtPreParto'] as String?,
      dtDescarteAnimal: data['dtDescarteAnimal'] as String?,
      dtUltimaAcao: data['dtUltimaAcao'] as String?,
      dtUltimoPartoContingencia: data['dtUltimoPartoContingencia'] as String?,
      liberaInseminacao: data['liberaInseminacao'] as bool? ?? false,
      nomeTouroUltimaInseminacao: data['nomeTouroUltimaInseminacao'] as String?,
      totalInseminacoes: (data['totalInseminacoes'] as num?)?.toInt() ?? 0,
      totalPartos: (data['totalPartos'] as num?)?.toInt() ?? 0,
      motivoDescarteAnimal: data['motivoDescarteAnimal'] as String?,
      nomeBrincoConcat: data['nomeBrincoConcat'] as String?,
      idGrupoAnimal: (data['idGrupoAnimal'] as num?)?.toInt() ?? 0,
      idStatusAnimal: (data['idStatusAnimal'] as num?)?.toInt() ?? 0,
      brincoAnimal: (data['brincoAnimal'] as num?)?.toInt() ?? 0,
      brincoAnimalOrder: (data['brincoAnimalOrder'] as num?)?.toInt() ?? 0,
      compararDtUltimaInseminacao: data['compararDtUltimaInseminacao'] != null
          ? (data['compararDtUltimaInseminacao'] as dynamic).toDate()
          : null,
      dtInducaoLactacao: data['dtInducaoLactacao'] != null
          ? (data['dtInducaoLactacao'] as dynamic).toDate()
          : null,
      dtDesmame: data['dtDesmame'] != null
          ? (data['dtDesmame'] as dynamic).toDate()
          : null,
      lastModified: DateTime.now(),
      lastSynced: DateTime.now(),
      needsSync: false,
      isDeleted: false,
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'nomeAnimal': nomeAnimal,
      'racaAnimal': racaAnimal,
      'pesoAnimal': pesoAnimal,
      'dtNascimento': dtNascimento,
      'touro': touro,
      'vaca': vaca,
      'status': status,
      'grupoAnimal': grupoAnimal,
      'dtUltimaInseminacao': dtUltimaInseminacao,
      'dtUltimoParto': dtUltimoParto,
      'dtPartoPrevisto': dtPartoPrevisto,
      'dtSecPrevista': dtSecPrevista,
      'dtPrePartoPrevista': dtPrePartoPrevista,
      'dtPP': dtPP,
      'dtDgMais': dtDgMais,
      'dtDgMenos': dtDgMenos,
      'dtAborto': dtAborto,
      'dtSecagem': dtSecagem,
      'dtUltimoPP': dtUltimoPP,
      'dtPreParto': dtPreParto,
      'dtDescarteAnimal': dtDescarteAnimal,
      'dtUltimaAcao': dtUltimaAcao,
      'dtUltimoPartoContingencia': dtUltimoPartoContingencia,
      'liberaInseminacao': liberaInseminacao,
      'nomeTouroUltimaInseminacao': nomeTouroUltimaInseminacao,
      'totalInseminacoes': totalInseminacoes,
      'totalPartos': totalPartos,
      'motivoDescarteAnimal': motivoDescarteAnimal,
      'nomeBrincoConcat': nomeBrincoConcat,
      'idGrupoAnimal': idGrupoAnimal,
      'idStatusAnimal': idStatusAnimal,
      'brincoAnimal': brincoAnimal,
      'brincoAnimalOrder': brincoAnimalOrder,
      'compararDtUltimaInseminacao': compararDtUltimaInseminacao,
      'dtInducaoLactacao': dtInducaoLactacao,
      'dtDesmame': dtDesmame,
    };
  }

  void updateFromFirestore(Map<String, dynamic> data) {
    uidTecnicoPropriedadePath =
        data['uidTecnicoPropriedade']?.path ?? uidTecnicoPropriedadePath;
    nomeAnimal = data['nomeAnimal'] as String? ?? nomeAnimal;
    racaAnimal = data['racaAnimal'] as String? ?? racaAnimal;
    pesoAnimal = data['pesoAnimal'] as String? ?? pesoAnimal;
    dtNascimento = data['dtNascimento'] as String? ?? dtNascimento;
    touro = data['touro'] as String? ?? touro;
    vaca = data['vaca'] as String? ?? vaca;
    status = data['status'] as String? ?? status;
    grupoAnimal = data['grupoAnimal'] as String? ?? grupoAnimal;
    dtUltimaInseminacao =
        data['dtUltimaInseminacao'] as String? ?? dtUltimaInseminacao;
    dtUltimoParto = data['dtUltimoParto'] as String? ?? dtUltimoParto;
    dtPartoPrevisto = data['dtPartoPrevisto'] as String? ?? dtPartoPrevisto;
    dtSecPrevista = data['dtSecPrevista'] as String? ?? dtSecPrevista;
    dtPrePartoPrevista =
        data['dtPrePartoPrevista'] as String? ?? dtPrePartoPrevista;
    dtPP = data['dtPP'] as String? ?? dtPP;
    dtDgMais = data['dtDgMais'] as String? ?? dtDgMais;
    dtDgMenos = data['dtDgMenos'] as String? ?? dtDgMenos;
    dtAborto = data['dtAborto'] as String? ?? dtAborto;
    dtSecagem = data['dtSecagem'] as String? ?? dtSecagem;
    dtUltimoPP = data['dtUltimoPP'] as String? ?? dtUltimoPP;
    dtPreParto = data['dtPreParto'] as String? ?? dtPreParto;
    dtDescarteAnimal = data['dtDescarteAnimal'] as String? ?? dtDescarteAnimal;
    dtUltimaAcao = data['dtUltimaAcao'] as String? ?? dtUltimaAcao;
    dtUltimoPartoContingencia = data['dtUltimoPartoContingencia'] as String? ??
        dtUltimoPartoContingencia;
    liberaInseminacao = data['liberaInseminacao'] as bool? ?? liberaInseminacao;
    nomeTouroUltimaInseminacao =
        data['nomeTouroUltimaInseminacao'] as String? ??
            nomeTouroUltimaInseminacao;
    totalInseminacoes =
        (data['totalInseminacoes'] as num?)?.toInt() ?? totalInseminacoes;
    totalPartos = (data['totalPartos'] as num?)?.toInt() ?? totalPartos;
    motivoDescarteAnimal =
        data['motivoDescarteAnimal'] as String? ?? motivoDescarteAnimal;
    nomeBrincoConcat = data['nomeBrincoConcat'] as String? ?? nomeBrincoConcat;
    idGrupoAnimal = (data['idGrupoAnimal'] as num?)?.toInt() ?? idGrupoAnimal;
    idStatusAnimal =
        (data['idStatusAnimal'] as num?)?.toInt() ?? idStatusAnimal;
    brincoAnimal = (data['brincoAnimal'] as num?)?.toInt() ?? brincoAnimal;
    brincoAnimalOrder =
        (data['brincoAnimalOrder'] as num?)?.toInt() ?? brincoAnimalOrder;
    if (data['compararDtUltimaInseminacao'] != null) {
      compararDtUltimaInseminacao =
          (data['compararDtUltimaInseminacao'] as dynamic).toDate();
    }
    if (data['dtInducaoLactacao'] != null) {
      dtInducaoLactacao = (data['dtInducaoLactacao'] as dynamic).toDate();
    }
    if (data['dtDesmame'] != null) {
      dtDesmame = (data['dtDesmame'] as dynamic).toDate();
    }
    lastSynced = DateTime.now();
    needsSync = false;
  }

  @override
  void markAsModified() {
    lastModified = DateTime.now();
    needsSync = true;
  }
}
