import 'package:objectbox/objectbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'syncable_entity.dart';

/// Entidade ResumoVisita para armazenamento local
/// Representa o resumo de uma visita técnica
@Entity()
class ResumoVisitaEntity implements SyncableEntity {
  @override
  @Id()
  int id = 0;

  @override
  @Unique()
  String? firestoreId;

  /// `resumo_da_visita` é uma coleção TOP-LEVEL no Firestore, então não há
  /// documento pai. Mantido pelo contrato do SyncableEntity e usado como
  /// prefixo pelo serviço de sync.
  @override
  String? parentPath;

  /// Campos gravados pelo app (ver `createResumoDaVisitaRecordData`).
  /// Referências viram caminho, como no `AnimalEntity`.
  String? uidPropriedadePath;
  String? uidTecnicoPath;
  String? uidResumoDaVisitaPath;

  @Property(type: PropertyType.date)
  DateTime? dtVisita;
  String? dtVisitaFormatado;

  @Property(type: PropertyType.date)
  DateTime? dtAssinatura;
  String? dtAssinaturaFormatado;

  String? assinaturaProdutor;
  String? assinaturaTecnico;
  String? obsGeralVisita;

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

  ResumoVisitaEntity({
    this.firestoreId,
    this.parentPath,
    this.uidPropriedadePath,
    this.uidTecnicoPath,
    this.uidResumoDaVisitaPath,
    this.dtVisita,
    this.dtVisitaFormatado,
    this.dtAssinatura,
    this.dtAssinaturaFormatado,
    this.assinaturaProdutor,
    this.assinaturaTecnico,
    this.obsGeralVisita,
    this.lastModified,
    this.lastSynced,
    this.needsSync = false,
    this.isDeleted = false,
  });

  factory ResumoVisitaEntity.fromFirestore(
    Map<String, dynamic> data,
    String docId, {
    String? parentPath,
  }) {
    String? caminho(dynamic ref) {
      if (ref == null) return null;
      if (ref is String) return ref;
      try {
        return (ref as dynamic).path as String?;
      } catch (_) {
        return null;
      }
    }

    DateTime? data_(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      try {
        return (v as dynamic).toDate() as DateTime?;
      } catch (_) {
        return null;
      }
    }

    return ResumoVisitaEntity(
      firestoreId: docId,
      parentPath: parentPath,
      uidPropriedadePath: caminho(data['uidPropriedade']),
      uidTecnicoPath: caminho(data['uidTecnico']),
      uidResumoDaVisitaPath: caminho(data['uidResumoDaVisita']),
      dtVisita: data_(data['dtVisita']),
      dtVisitaFormatado: data['dtVisitaFormatado'] as String?,
      dtAssinatura: data_(data['dtAssinatura']),
      dtAssinaturaFormatado: data['dtAssinaturaFormatado'] as String?,
      assinaturaProdutor: data['assinaturaProdutor'] as String?,
      assinaturaTecnico: data['assinaturaTecnico'] as String?,
      obsGeralVisita: data['obsGeralVisita'] as String?,
      lastSynced: DateTime.now(),
      needsSync: false,
    );
  }

  /// Campos planos. As referências e Timestamps são reanexados pelo
  /// repositório de sync, que tem acesso ao FirebaseFirestore.
  @override
  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'dtVisitaFormatado': dtVisitaFormatado,
      'dtAssinaturaFormatado': dtAssinaturaFormatado,
      'assinaturaProdutor': assinaturaProdutor,
      'assinaturaTecnico': assinaturaTecnico,
      'obsGeralVisita': obsGeralVisita,
    };
  }

  @override
  void markAsModified([String? userId]) {
    lastModified = DateTime.now();
    needsSync = true;
  }
}

/// Entidade Recomendacao para armazenamento local
/// Representa recomendações feitas durante visitas
@Entity()
class RecomendacaoEntity implements SyncableEntity {
  @override
  @Id()
  int id = 0;

  @override
  @Unique()
  String? firestoreId;

  @override
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
    this.isDeleted = false,
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

  @override
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

  @override
  void markAsModified([String? userId]) {
    if (userId != null) lastModifiedBy = userId;
    lastModified = DateTime.now();
    needsSync = true;
  }
}
