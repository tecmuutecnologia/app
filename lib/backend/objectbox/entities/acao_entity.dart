import 'package:objectbox/objectbox.dart';

/// Entidade Acao para armazenamento local com ObjectBox
/// Sincroniza com a subcoleção 'acoes' do Firestore
@Entity()
class AcaoEntity {
  @Id()
  int id = 0;

  /// ID do documento no Firestore
  @Unique()
  String? firestoreId;

  /// Path do documento pai
  String? parentPath;

  /// Referência ao animal (path)
  String? uidAnimalAnimaisProdutoresPath;

  String? nomeAnimal;
  String? acao;
  String? obsVisita;
  String? touroInseminacao;
  String? dataVisita;
  String? dataPartoPrevisto;
  String? dataSecPrevista;
  String? dataPrePartoPrevista;
  String? dtPP;
  String? dtDgMais;
  String? dtDgMenos;
  String? dtAborto;
  String? uidPropriedadePath;

  @Property(type: PropertyType.date)
  DateTime? dataDaAcao;

  /// Campos de controle de sincronização
  @Property(type: PropertyType.date)
  DateTime? lastModified;

  @Property(type: PropertyType.date)
  DateTime? lastSynced;

  bool needsSync;
  bool isDeleted;

  AcaoEntity({
    this.firestoreId,
    this.parentPath,
    this.uidAnimalAnimaisProdutoresPath,
    this.nomeAnimal,
    this.acao,
    this.obsVisita,
    this.touroInseminacao,
    this.dataVisita,
    this.dataPartoPrevisto,
    this.dataSecPrevista,
    this.dataPrePartoPrevista,
    this.dtPP,
    this.dtDgMais,
    this.dtDgMenos,
    this.dtAborto,
    this.uidPropriedadePath,
    this.dataDaAcao,
    this.lastModified,
    this.lastSynced,
    this.needsSync = false,
    this.isDeleted = false,
  });

  factory AcaoEntity.fromFirestore(
    Map<String, dynamic> data,
    String docId,
    String parentPath,
  ) {
    return AcaoEntity(
      firestoreId: docId,
      parentPath: parentPath,
      uidAnimalAnimaisProdutoresPath: data['uidAnimalAnimaisProdutores']?.path,
      nomeAnimal: data['nomeAnimal'] as String?,
      acao: data['acao'] as String?,
      obsVisita: data['obsVisita'] as String?,
      touroInseminacao: data['touroInseminacao'] as String?,
      dataVisita: data['dataVisita'] as String?,
      dataPartoPrevisto: data['dataPartoPrevisto'] as String?,
      dataSecPrevista: data['dataSecPrevista'] as String?,
      dataPrePartoPrevista: data['dataPrePartoPrevista'] as String?,
      dtPP: data['dtPP'] as String?,
      dtDgMais: data['dtDgMais'] as String?,
      dtDgMenos: data['dtDgMenos'] as String?,
      dtAborto: data['dtAborto'] as String?,
      uidPropriedadePath: data['uidPropriedade']?.path,
      dataDaAcao: data['dataDaAcao'] != null
          ? (data['dataDaAcao'] as dynamic).toDate()
          : null,
      lastModified: DateTime.now(),
      lastSynced: DateTime.now(),
      needsSync: false,
      isDeleted: false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nomeAnimal': nomeAnimal,
      'acao': acao,
      'obsVisita': obsVisita,
      'touroInseminacao': touroInseminacao,
      'dataVisita': dataVisita,
      'dataPartoPrevisto': dataPartoPrevisto,
      'dataSecPrevista': dataSecPrevista,
      'dataPrePartoPrevista': dataPrePartoPrevista,
      'dtPP': dtPP,
      'dtDgMais': dtDgMais,
      'dtDgMenos': dtDgMenos,
      'dtAborto': dtAborto,
      'dataDaAcao': dataDaAcao,
    };
  }

  void markAsModified() {
    lastModified = DateTime.now();
    needsSync = true;
  }
}
