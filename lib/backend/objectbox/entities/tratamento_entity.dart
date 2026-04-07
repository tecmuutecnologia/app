import 'package:objectbox/objectbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Entidade Tratamento para armazenamento local
/// Representa tratamentos realizados em animais
@Entity()
class TratamentoEntity {
  @Id()
  int id = 0;

  @Unique()
  String? firestoreId;

  /// Path do documento pai para subcoleções
  String? parentPath;

  String? uidAnimal;
  String? tipoAcao;
  String? nomeAnimal;
  String? uidPropriedade;
  String? nomePropriedade;
  String? posologia;
  String? medicamento;
  String? lote;
  String? laboratorio;
  String? acao;
  String? resultado;
  String? obs;
  String? createdBy;
  String? lastModifiedBy;

  @Property(type: PropertyType.date)
  DateTime? dtTratamento;

  @Property(type: PropertyType.date)
  DateTime? dtCarencia;

  @Property(type: PropertyType.date)
  DateTime? createdAt;

  @Property(type: PropertyType.date)
  DateTime? lastModified;

  @Property(type: PropertyType.date)
  DateTime? lastSynced;

  bool needsSync;

  TratamentoEntity({
    this.firestoreId,
    this.parentPath,
    this.uidAnimal,
    this.tipoAcao,
    this.nomeAnimal,
    this.uidPropriedade,
    this.nomePropriedade,
    this.posologia,
    this.medicamento,
    this.lote,
    this.laboratorio,
    this.acao,
    this.resultado,
    this.obs,
    this.dtTratamento,
    this.dtCarencia,
    this.createdBy,
    this.createdAt,
    this.lastModifiedBy,
    this.lastModified,
    this.lastSynced,
    this.needsSync = false,
  });

  factory TratamentoEntity.fromFirestore(
    Map<String, dynamic> data,
    String docId, {
    String? parentPath,
  }) {
    return TratamentoEntity(
      firestoreId: docId,
      parentPath: parentPath,
      uidAnimal: data['uid_animal'] as String?,
      tipoAcao: data['tipo_acao'] as String?,
      nomeAnimal: data['nome_animal'] as String?,
      uidPropriedade: data['uid_propriedade'] as String?,
      nomePropriedade: data['nome_propriedade'] as String?,
      posologia: data['posologia'] as String?,
      medicamento: data['medicamento'] as String?,
      lote: data['lote'] as String?,
      laboratorio: data['laboratorio'] as String?,
      acao: data['acao'] as String?,
      resultado: data['resultado'] as String?,
      obs: data['obs'] as String?,
      dtTratamento: (data['dt_tratamento'] as Timestamp?)?.toDate(),
      dtCarencia: (data['dt_carencia'] as Timestamp?)?.toDate(),
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

    if (uidAnimal != null) data['uid_animal'] = uidAnimal;
    if (tipoAcao != null) data['tipo_acao'] = tipoAcao;
    if (nomeAnimal != null) data['nome_animal'] = nomeAnimal;
    if (uidPropriedade != null) data['uid_propriedade'] = uidPropriedade;
    if (nomePropriedade != null) data['nome_propriedade'] = nomePropriedade;
    if (posologia != null) data['posologia'] = posologia;
    if (medicamento != null) data['medicamento'] = medicamento;
    if (lote != null) data['lote'] = lote;
    if (laboratorio != null) data['laboratorio'] = laboratorio;
    if (acao != null) data['acao'] = acao;
    if (resultado != null) data['resultado'] = resultado;
    if (obs != null) data['obs'] = obs;
    if (dtTratamento != null)
      data['dt_tratamento'] = Timestamp.fromDate(dtTratamento!);
    if (dtCarencia != null)
      data['dt_carencia'] = Timestamp.fromDate(dtCarencia!);
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

/// Entidade AcaoSanitario para armazenamento local
/// Representa ações sanitárias realizadas
@Entity()
class AcaoSanitarioEntity {
  @Id()
  int id = 0;

  @Unique()
  String? firestoreId;

  String? parentPath;

  String? uidAnimal;
  String? tipoAcao;
  String? nomeAnimal;
  String? uidPropriedade;
  String? nomePropriedade;
  String? acao;
  String? posologia;
  String? medicamento;
  String? lote;
  String? laboratorio;
  String? resultado;
  String? obs;
  String? createdBy;
  String? lastModifiedBy;

  @Property(type: PropertyType.date)
  DateTime? dtAcao;

  @Property(type: PropertyType.date)
  DateTime? dtCarencia;

  @Property(type: PropertyType.date)
  DateTime? createdAt;

  @Property(type: PropertyType.date)
  DateTime? lastModified;

  @Property(type: PropertyType.date)
  DateTime? lastSynced;

  bool needsSync;

  AcaoSanitarioEntity({
    this.firestoreId,
    this.parentPath,
    this.uidAnimal,
    this.tipoAcao,
    this.nomeAnimal,
    this.uidPropriedade,
    this.nomePropriedade,
    this.acao,
    this.posologia,
    this.medicamento,
    this.lote,
    this.laboratorio,
    this.resultado,
    this.obs,
    this.dtAcao,
    this.dtCarencia,
    this.createdBy,
    this.createdAt,
    this.lastModifiedBy,
    this.lastModified,
    this.lastSynced,
    this.needsSync = false,
  });

  factory AcaoSanitarioEntity.fromFirestore(
    Map<String, dynamic> data,
    String docId, {
    String? parentPath,
  }) {
    return AcaoSanitarioEntity(
      firestoreId: docId,
      parentPath: parentPath,
      uidAnimal: data['uid_animal'] as String?,
      tipoAcao: data['tipo_acao'] as String?,
      nomeAnimal: data['nome_animal'] as String?,
      uidPropriedade: data['uid_propriedade'] as String?,
      nomePropriedade: data['nome_propriedade'] =
          data['nome_propriedade'] as String?,
      acao: data['acao'] as String?,
      posologia: data['posologia'] as String?,
      medicamento: data['medicamento'] as String?,
      lote: data['lote'] as String?,
      laboratorio: data['laboratorio'] as String?,
      resultado: data['resultado'] as String?,
      obs: data['obs'] as String?,
      dtAcao: (data['dt_acao'] as Timestamp?)?.toDate(),
      dtCarencia: (data['dt_carencia'] as Timestamp?)?.toDate(),
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

    if (uidAnimal != null) data['uid_animal'] = uidAnimal;
    if (tipoAcao != null) data['tipo_acao'] = tipoAcao;
    if (nomeAnimal != null) data['nome_animal'] = nomeAnimal;
    if (uidPropriedade != null) data['uid_propriedade'] = uidPropriedade;
    if (nomePropriedade != null) data['nome_propriedade'] = nomePropriedade;
    if (acao != null) data['acao'] = acao;
    if (posologia != null) data['posologia'] = posologia;
    if (medicamento != null) data['medicamento'] = medicamento;
    if (lote != null) data['lote'] = lote;
    if (laboratorio != null) data['laboratorio'] = laboratorio;
    if (resultado != null) data['resultado'] = resultado;
    if (obs != null) data['obs'] = obs;
    if (dtAcao != null) data['dt_acao'] = Timestamp.fromDate(dtAcao!);
    if (dtCarencia != null)
      data['dt_carencia'] = Timestamp.fromDate(dtCarencia!);
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
