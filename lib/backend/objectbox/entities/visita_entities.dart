import 'package:objectbox/objectbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Entidade ResumoVisita para armazenamento local
/// Representa o resumo de uma visita técnica
@Entity()
class ResumoVisitaEntity {
  @Id()
  int id = 0;

  @Unique()
  String? firestoreId;

  String? parentPath;

  String? uidVisita;
  String? uidPropriedade;
  String? nomePropriedade;
  String? uidTecnico;
  String? nomeTecnico;
  String? uidProdutor;
  String? nomeProdutor;

  String? resumo;
  String? observacoes;
  String? proximosPassos;

  /// Assinaturas em base64
  String? assinaturaTecnico;
  String? assinaturaProdutor;

  /// Status da visita
  String? status;

  @Property(type: PropertyType.date)
  DateTime? dtVisita;

  @Property(type: PropertyType.date)
  DateTime? dtInicio;

  @Property(type: PropertyType.date)
  DateTime? dtFim;

  String? createdBy;
  String? lastModifiedBy;

  @Property(type: PropertyType.date)
  DateTime? createdAt;

  @Property(type: PropertyType.date)
  DateTime? lastModified;

  @Property(type: PropertyType.date)
  DateTime? lastSynced;

  bool needsSync;

  ResumoVisitaEntity({
    this.firestoreId,
    this.parentPath,
    this.uidVisita,
    this.uidPropriedade,
    this.nomePropriedade,
    this.uidTecnico,
    this.nomeTecnico,
    this.uidProdutor,
    this.nomeProdutor,
    this.resumo,
    this.observacoes,
    this.proximosPassos,
    this.assinaturaTecnico,
    this.assinaturaProdutor,
    this.status,
    this.dtVisita,
    this.dtInicio,
    this.dtFim,
    this.createdBy,
    this.createdAt,
    this.lastModifiedBy,
    this.lastModified,
    this.lastSynced,
    this.needsSync = false,
  });

  factory ResumoVisitaEntity.fromFirestore(
    Map<String, dynamic> data,
    String docId, {
    String? parentPath,
  }) {
    return ResumoVisitaEntity(
      firestoreId: docId,
      parentPath: parentPath,
      uidVisita: data['uid_visita'] as String?,
      uidPropriedade: data['uid_propriedade'] as String?,
      nomePropriedade: data['nome_propriedade'] as String?,
      uidTecnico: data['uid_tecnico'] as String?,
      nomeTecnico: data['nome_tecnico'] as String?,
      uidProdutor: data['uid_produtor'] as String?,
      nomeProdutor: data['nome_produtor'] as String?,
      resumo: data['resumo'] as String?,
      observacoes: data['observacoes'] as String?,
      proximosPassos: data['proximos_passos'] as String?,
      assinaturaTecnico: data['assinatura_tecnico'] as String?,
      assinaturaProdutor: data['assinatura_produtor'] as String?,
      status: data['status'] as String?,
      dtVisita: (data['dt_visita'] as Timestamp?)?.toDate(),
      dtInicio: (data['dt_inicio'] as Timestamp?)?.toDate(),
      dtFim: (data['dt_fim'] as Timestamp?)?.toDate(),
      createdBy: data['created_by'] as String?,
      createdAt: (data['created_at'] as Timestamp?)?.toDate(),
      lastModifiedBy: data['last_modified_by'] as String?,
      lastModified: (data['last_modified'] as Timestamp?)?.toDate(),
      lastSynced: DateTime.now(),
      needsSync: false,
    );
  }

  Map<String, dynamic> toFirestore() {
    final data = <String, dynamic>{};

    if (uidVisita != null) data['uid_visita'] = uidVisita;
    if (uidPropriedade != null) data['uid_propriedade'] = uidPropriedade;
    if (nomePropriedade != null) data['nome_propriedade'] = nomePropriedade;
    if (uidTecnico != null) data['uid_tecnico'] = uidTecnico;
    if (nomeTecnico != null) data['nome_tecnico'] = nomeTecnico;
    if (uidProdutor != null) data['uid_produtor'] = uidProdutor;
    if (nomeProdutor != null) data['nome_produtor'] = nomeProdutor;
    if (resumo != null) data['resumo'] = resumo;
    if (observacoes != null) data['observacoes'] = observacoes;
    if (proximosPassos != null) data['proximos_passos'] = proximosPassos;
    if (assinaturaTecnico != null)
      data['assinatura_tecnico'] = assinaturaTecnico;
    if (assinaturaProdutor != null)
      data['assinatura_produtor'] = assinaturaProdutor;
    if (status != null) data['status'] = status;
    if (dtVisita != null) data['dt_visita'] = Timestamp.fromDate(dtVisita!);
    if (dtInicio != null) data['dt_inicio'] = Timestamp.fromDate(dtInicio!);
    if (dtFim != null) data['dt_fim'] = Timestamp.fromDate(dtFim!);
    if (createdBy != null) data['created_by'] = createdBy;
    if (createdAt != null) data['created_at'] = Timestamp.fromDate(createdAt!);
    if (lastModifiedBy != null) data['last_modified_by'] = lastModifiedBy;
    if (lastModified != null)
      data['last_modified'] = Timestamp.fromDate(lastModified!);

    return data;
  }

  void markAsModified(String userId) {
    lastModifiedBy = userId;
    lastModified = DateTime.now();
    needsSync = true;
  }
}

/// Entidade Recomendacao para armazenamento local
/// Representa recomendações feitas durante visitas
@Entity()
class RecomendacaoEntity {
  @Id()
  int id = 0;

  @Unique()
  String? firestoreId;

  String? parentPath;

  String? uidVisita;
  String? uidPropriedade;
  String? tituloRecomendacao;
  String? descricaoRecomendacao;
  String? categoria;
  String? prioridade;
  String? status;

  @Property(type: PropertyType.date)
  DateTime? dtRecomendacao;

  @Property(type: PropertyType.date)
  DateTime? dtPrazo;

  @Property(type: PropertyType.date)
  DateTime? dtConclusao;

  String? createdBy;
  String? lastModifiedBy;

  @Property(type: PropertyType.date)
  DateTime? createdAt;

  @Property(type: PropertyType.date)
  DateTime? lastModified;

  @Property(type: PropertyType.date)
  DateTime? lastSynced;

  bool needsSync;

  RecomendacaoEntity({
    this.firestoreId,
    this.parentPath,
    this.uidVisita,
    this.uidPropriedade,
    this.tituloRecomendacao,
    this.descricaoRecomendacao,
    this.categoria,
    this.prioridade,
    this.status,
    this.dtRecomendacao,
    this.dtPrazo,
    this.dtConclusao,
    this.createdBy,
    this.createdAt,
    this.lastModifiedBy,
    this.lastModified,
    this.lastSynced,
    this.needsSync = false,
  });

  factory RecomendacaoEntity.fromFirestore(
    Map<String, dynamic> data,
    String docId, {
    String? parentPath,
  }) {
    return RecomendacaoEntity(
      firestoreId: docId,
      parentPath: parentPath,
      uidVisita: data['uid_visita'] as String?,
      uidPropriedade: data['uid_propriedade'] as String?,
      tituloRecomendacao: data['titulo_recomendacao'] as String?,
      descricaoRecomendacao: data['descricao_recomendacao'] as String?,
      categoria: data['categoria'] as String?,
      prioridade: data['prioridade'] as String?,
      status: data['status'] as String?,
      dtRecomendacao: (data['dt_recomendacao'] as Timestamp?)?.toDate(),
      dtPrazo: (data['dt_prazo'] as Timestamp?)?.toDate(),
      dtConclusao: (data['dt_conclusao'] as Timestamp?)?.toDate(),
      createdBy: data['created_by'] as String?,
      createdAt: (data['created_at'] as Timestamp?)?.toDate(),
      lastModifiedBy: data['last_modified_by'] as String?,
      lastModified: (data['last_modified'] as Timestamp?)?.toDate(),
      lastSynced: DateTime.now(),
      needsSync: false,
    );
  }

  Map<String, dynamic> toFirestore() {
    final data = <String, dynamic>{};

    if (uidVisita != null) data['uid_visita'] = uidVisita;
    if (uidPropriedade != null) data['uid_propriedade'] = uidPropriedade;
    if (tituloRecomendacao != null)
      data['titulo_recomendacao'] = tituloRecomendacao;
    if (descricaoRecomendacao != null)
      data['descricao_recomendacao'] = descricaoRecomendacao;
    if (categoria != null) data['categoria'] = categoria;
    if (prioridade != null) data['prioridade'] = prioridade;
    if (status != null) data['status'] = status;
    if (dtRecomendacao != null)
      data['dt_recomendacao'] = Timestamp.fromDate(dtRecomendacao!);
    if (dtPrazo != null) data['dt_prazo'] = Timestamp.fromDate(dtPrazo!);
    if (dtConclusao != null)
      data['dt_conclusao'] = Timestamp.fromDate(dtConclusao!);
    if (createdBy != null) data['created_by'] = createdBy;
    if (createdAt != null) data['created_at'] = Timestamp.fromDate(createdAt!);
    if (lastModifiedBy != null) data['last_modified_by'] = lastModifiedBy;
    if (lastModified != null)
      data['last_modified'] = Timestamp.fromDate(lastModified!);

    return data;
  }

  void markAsModified(String userId) {
    lastModifiedBy = userId;
    lastModified = DateTime.now();
    needsSync = true;
  }
}
