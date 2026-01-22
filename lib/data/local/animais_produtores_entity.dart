import 'package:objectbox/objectbox.dart';

/// Entidade local do ObjectBox para AnimaisProdutores
/// Corresponde ao AnimaisProdutoresRecord do Firestore
@Entity()
class AnimaisProdutoresEntity {
  @Id()
  int id = 0;

  @Unique()
  String? firestoreId;

  // Parent reference (propriedade) - tecnico/xxx/propriedades/yyy
  String? parentReference;

  // Referência à propriedade (armazenamos o path do DocumentReference)
  String? uidTecnicoPropriedade;

  String? nomeAnimal;
  String? racaAnimal;
  String? pesoAnimal;
  String? dtNascimento;
  String? touro;
  String? vaca;
  String? status;
  String? grupoAnimal;
  String? dtUltimaInseminacao;
  String? dtUltimoParto;
  bool? liberaInseminacao;
  String? dtPartoPrevisto;
  String? dtSecPrevista;
  String? dtPrePartoPrevista;
  String? dtPP;
  String? dtDgMais;
  String? dtDgMenos;
  String? dtAborto;
  String? dtSecagem;
  String? dtUltimoPP;
  String? nomeTouroUltimaInseminacao;
  int? totalInseminacoes;
  int? totalPartos;
  String? dtPreParto;
  String? motivoDescarteAnimal;
  String? dtDescarteAnimal;
  String? dtUltimaAcao;

  @Property(type: PropertyType.date)
  DateTime? compararDtUltimaInseminacao;

  String? nomeBrincoConcat;
  int? idGrupoAnimal;
  String? dtUltimoPartoContingencia;
  int? idStatusAnimal;

  @Property(type: PropertyType.date)
  DateTime? dtInducaoLactacao;

  @Property(type: PropertyType.date)
  DateTime? dtDesmame;

  int? brincoAnimal;
  int? brincoAnimalOrder;

  // Campos de controle
  @Property(type: PropertyType.date)
  DateTime? lastSyncedAt;

  bool needsSync = false;
  bool isDeleted = false;

  AnimaisProdutoresEntity({
    this.id = 0,
    this.firestoreId,
    this.parentReference,
    this.uidTecnicoPropriedade,
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
    this.liberaInseminacao,
    this.dtPartoPrevisto,
    this.dtSecPrevista,
    this.dtPrePartoPrevista,
    this.dtPP,
    this.dtDgMais,
    this.dtDgMenos,
    this.dtAborto,
    this.dtSecagem,
    this.dtUltimoPP,
    this.nomeTouroUltimaInseminacao,
    this.totalInseminacoes,
    this.totalPartos,
    this.dtPreParto,
    this.motivoDescarteAnimal,
    this.dtDescarteAnimal,
    this.dtUltimaAcao,
    this.compararDtUltimaInseminacao,
    this.nomeBrincoConcat,
    this.idGrupoAnimal,
    this.dtUltimoPartoContingencia,
    this.idStatusAnimal,
    this.dtInducaoLactacao,
    this.dtDesmame,
    this.brincoAnimal,
    this.brincoAnimalOrder,
    this.lastSyncedAt,
    this.needsSync = false,
    this.isDeleted = false,
  });

  factory AnimaisProdutoresEntity.fromFirestore({
    required String firestoreId,
    required Map<String, dynamic> data,
    String? parentReference,
  }) {
    return AnimaisProdutoresEntity(
      firestoreId: firestoreId,
      parentReference: parentReference,
      uidTecnicoPropriedade: data['uidTecnicoPropriedade']?.toString(),
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
      liberaInseminacao: data['liberaInseminacao'] as bool?,
      dtPartoPrevisto: data['dtPartoPrevisto'] as String?,
      dtSecPrevista: data['dtSecPrevista'] as String?,
      dtPrePartoPrevista: data['dtPrePartoPrevista'] as String?,
      dtPP: data['dtPP'] as String?,
      dtDgMais: data['dtDgMais'] as String?,
      dtDgMenos: data['dtDgMenos'] as String?,
      dtAborto: data['dtAborto'] as String?,
      dtSecagem: data['dtSecagem'] as String?,
      dtUltimoPP: data['dtUltimoPP'] as String?,
      nomeTouroUltimaInseminacao: data['nomeTouroUltimaInseminacao'] as String?,
      totalInseminacoes: data['totalInseminacoes'] as int?,
      totalPartos: data['totalPartos'] as int?,
      dtPreParto: data['dtPreParto'] as String?,
      motivoDescarteAnimal: data['motivoDescarteAnimal'] as String?,
      dtDescarteAnimal: data['dtDescarteAnimal'] as String?,
      dtUltimaAcao: data['dtUltimaAcao'] as String?,
      compararDtUltimaInseminacao:
          data['compararDtUltimaInseminacao'] as DateTime?,
      nomeBrincoConcat: data['nomeBrincoConcat'] as String?,
      idGrupoAnimal: data['idGrupoAnimal'] as int?,
      dtUltimoPartoContingencia: data['dtUltimoPartoContingencia'] as String?,
      idStatusAnimal: data['idStatusAnimal'] as int?,
      dtInducaoLactacao: data['dtInducaoLactacao'] as DateTime?,
      dtDesmame: data['dtDesmame'] as DateTime?,
      brincoAnimal: data['brincoAnimal'] as int?,
      brincoAnimalOrder: data['brincoAnimalOrder'] as int?,
      lastSyncedAt: DateTime.now(),
      needsSync: false,
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'uidTecnicoPropriedade': uidTecnicoPropriedade,
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
      'liberaInseminacao': liberaInseminacao,
      'dtPartoPrevisto': dtPartoPrevisto,
      'dtSecPrevista': dtSecPrevista,
      'dtPrePartoPrevista': dtPrePartoPrevista,
      'dtPP': dtPP,
      'dtDgMais': dtDgMais,
      'dtDgMenos': dtDgMenos,
      'dtAborto': dtAborto,
      'dtSecagem': dtSecagem,
      'dtUltimoPP': dtUltimoPP,
      'nomeTouroUltimaInseminacao': nomeTouroUltimaInseminacao,
      'totalInseminacoes': totalInseminacoes,
      'totalPartos': totalPartos,
      'dtPreParto': dtPreParto,
      'motivoDescarteAnimal': motivoDescarteAnimal,
      'dtDescarteAnimal': dtDescarteAnimal,
      'dtUltimaAcao': dtUltimaAcao,
      'compararDtUltimaInseminacao': compararDtUltimaInseminacao,
      'nomeBrincoConcat': nomeBrincoConcat,
      'idGrupoAnimal': idGrupoAnimal,
      'dtUltimoPartoContingencia': dtUltimoPartoContingencia,
      'idStatusAnimal': idStatusAnimal,
      'dtInducaoLactacao': dtInducaoLactacao,
      'dtDesmame': dtDesmame,
      'brincoAnimal': brincoAnimal,
      'brincoAnimalOrder': brincoAnimalOrder,
    };
  }

  void markForSync() => needsSync = true;

  void markAsSynced() {
    needsSync = false;
    lastSyncedAt = DateTime.now();
  }
}
