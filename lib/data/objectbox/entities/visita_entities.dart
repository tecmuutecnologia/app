import 'package:objectbox/objectbox.dart';

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

  /// Caminho da propriedade dona da recomendação.
  @override
  String? parentPath;

  /// Vínculo com a visita: CAMPO, não hierarquia.
  String? uidResumoDaVisitaPath;

  String? tituloRecomendacao;
  String? descricaoRecomendacao;

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
    this.uidResumoDaVisitaPath,
    this.tituloRecomendacao,
    this.descricaoRecomendacao,
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
    String? caminho(dynamic r) {
      if (r == null) return null;
      if (r is String) return r;
      try {
        return (r as dynamic).path as String?;
      } catch (_) {
        return null;
      }
    }

    return RecomendacaoEntity(
      firestoreId: docId,
      parentPath: parentPath,
      uidResumoDaVisitaPath: caminho(data['uidResumoDaVisita']),
      tituloRecomendacao: data['tituloRecomendacao'] as String?,
      descricaoRecomendacao: data['descricaoRecomendacao'] as String?,
      lastSynced: DateTime.now(),
      needsSync: false,
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'tituloRecomendacao': tituloRecomendacao,
      'descricaoRecomendacao': descricaoRecomendacao,
    };
  }

  @override
  void markAsModified([String? userId]) {
    lastModified = DateTime.now();
    needsSync = true;
  }
}
