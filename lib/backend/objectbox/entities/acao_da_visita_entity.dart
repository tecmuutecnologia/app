import 'package:objectbox/objectbox.dart';

/// Entidade AcaoDaVisita para armazenamento local com ObjectBox
/// Sincroniza com a subcoleção 'acoes_da_visita' do Firestore
@Entity()
class AcaoDaVisitaEntity {
  @Id()
  int id = 0;

  @Unique()
  String? firestoreId;

  String? parentPath;

  String? acao;
  String? dtAcao;
  String? dtPP;
  String? dtInseminacao;
  String? tourtoInseminacao;
  String? dtPartoPrevisto;
  String? dtSecPrevista;
  String? dtPrePartoPrevista;
  String? dtDgMais;
  String? dtDgMenos;
  String? dtAborto;
  String? dtSecagem;
  String? tratamento;

  @Property(type: PropertyType.date)
  DateTime? dtVisita;

  @Property(type: PropertyType.date)
  DateTime? lastModified;

  @Property(type: PropertyType.date)
  DateTime? lastSynced;

  bool needsSync;
  bool isDeleted;

  AcaoDaVisitaEntity({
    this.firestoreId,
    this.parentPath,
    this.acao,
    this.dtAcao,
    this.dtPP,
    this.dtInseminacao,
    this.tourtoInseminacao,
    this.dtPartoPrevisto,
    this.dtSecPrevista,
    this.dtPrePartoPrevista,
    this.dtDgMais,
    this.dtDgMenos,
    this.dtAborto,
    this.dtSecagem,
    this.tratamento,
    this.dtVisita,
    this.lastModified,
    this.lastSynced,
    this.needsSync = false,
    this.isDeleted = false,
  });

  factory AcaoDaVisitaEntity.fromFirestore(
    Map<String, dynamic> data,
    String docId,
    String parentPath,
  ) {
    return AcaoDaVisitaEntity(
      firestoreId: docId,
      parentPath: parentPath,
      acao: data['acao'] as String?,
      dtAcao: data['dtAcao'] as String?,
      dtPP: data['dtPP'] as String?,
      dtInseminacao: data['dtInseminacao'] as String?,
      tourtoInseminacao: data['tourtoInseminacao'] as String?,
      dtPartoPrevisto: data['dtPartoPrevisto'] as String?,
      dtSecPrevista: data['dtSecPrevista'] as String?,
      dtPrePartoPrevista: data['dtPrePartoPrevista'] as String?,
      dtDgMais: data['dtDgMais'] as String?,
      dtDgMenos: data['dtDgMenos'] as String?,
      dtAborto: data['dtAborto'] as String?,
      dtSecagem: data['dtSecagem'] as String?,
      tratamento: data['tratamento'] as String?,
      dtVisita: data['dtVisita'] != null
          ? (data['dtVisita'] as dynamic).toDate()
          : null,
      lastModified: DateTime.now(),
      lastSynced: DateTime.now(),
      needsSync: false,
      isDeleted: false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'acao': acao,
      'dtAcao': dtAcao,
      'dtPP': dtPP,
      'dtInseminacao': dtInseminacao,
      'tourtoInseminacao': tourtoInseminacao,
      'dtPartoPrevisto': dtPartoPrevisto,
      'dtSecPrevista': dtSecPrevista,
      'dtPrePartoPrevista': dtPrePartoPrevista,
      'dtDgMais': dtDgMais,
      'dtDgMenos': dtDgMenos,
      'dtAborto': dtAborto,
      'dtSecagem': dtSecagem,
      'tratamento': tratamento,
      'dtVisita': dtVisita,
    };
  }

  void markAsModified() {
    lastModified = DateTime.now();
    needsSync = true;
  }
}
