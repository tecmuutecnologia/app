import 'package:objectbox/objectbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'syncable_entity.dart';

/// Entidade Tratamento para armazenamento local
/// Representa tratamentos realizados em animais
@Entity()
class TratamentoEntity implements SyncableEntity {
  @override
  @Id()
  int id = 0;

  @override
  @Unique()
  String? firestoreId;

  /// Path do documento pai para subcoleções
  @override
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
    this.isDeleted = false,
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

  @override
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

  @override
  void markAsModified([String? userId]) {
    if (userId != null) lastModifiedBy = userId;
    lastModified = DateTime.now();
    needsSync = true;
  }
}

/// Entidade AcaoSanitario para armazenamento local (ação do calendário
/// sanitário).
///
/// ⚠️ Schema REESCRITO para bater com o `AcoesSanitarioRecord` — o que o app
/// realmente grava. A versão anterior lia chaves em `snake_case`
/// (`uid_animal`, `tipo_acao`, ...) enquanto o app grava `camelCase`, e
/// esperava a coleção sob o ANIMAL. Nada casava, então a tabela local ficava
/// vazia e a tela nunca pôde sair do Firestore.
///
/// Documentos vivem em
/// `tecnico/{idTecnico}/propriedades/{idPropriedade}/acoesSanitario/{id}`;
/// `parentPath` é o caminho da PROPRIEDADE e o animal é um campo.
@Entity()
class AcaoSanitarioEntity implements SyncableEntity {
  @override
  @Id()
  int id = 0;

  @override
  @Unique()
  String? firestoreId;

  /// Caminho da propriedade dona da ação.
  @override
  String? parentPath;

  /// Campos gravados pelo app (ver `createAcoesSanitarioRecordData`).
  /// Referências viram caminho, como no `AnimalEntity`.
  String? uidAnimalAnimaisProdutoresPath;
  String? uidPersonProdutorPath;
  String? uidPropriedadePath;
  String? tipoAcao;
  String? acao;
  String? obsVisita;

  /// Data no formato `dd/MM/yyyy` (é string no Firestore).
  String? dtAcao;
  String? nomeAnimal;
  String? brincoAnimal;

  /// Campos previstos para o módulo sanitário, ainda não capturados pelo
  /// formulário. Mantidos (nullable) para não perder a modelagem.
  String? medicamento;
  String? posologia;
  String? lote;
  String? laboratorio;
  String? resultado;
  String? dtCarencia;

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

  AcaoSanitarioEntity({
    this.firestoreId,
    this.parentPath,
    this.uidAnimalAnimaisProdutoresPath,
    this.uidPersonProdutorPath,
    this.uidPropriedadePath,
    this.tipoAcao,
    this.acao,
    this.obsVisita,
    this.dtAcao,
    this.nomeAnimal,
    this.brincoAnimal,
    this.medicamento,
    this.posologia,
    this.lote,
    this.laboratorio,
    this.resultado,
    this.dtCarencia,
    this.lastModified,
    this.lastSynced,
    this.needsSync = false,
    this.isDeleted = false,
  });

  factory AcaoSanitarioEntity.fromFirestore(
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

    return AcaoSanitarioEntity(
      firestoreId: docId,
      parentPath: parentPath,
      uidAnimalAnimaisProdutoresPath:
          caminho(data['uidAnimalAnimaisProdutores']),
      uidPersonProdutorPath: caminho(data['uidPersonProdutor']),
      uidPropriedadePath: caminho(data['uidPropriedade']),
      tipoAcao: data['tipoAcao'] as String?,
      acao: data['acao'] as String?,
      obsVisita: data['obsVisita'] as String?,
      dtAcao: data['dtAcao'] as String?,
      nomeAnimal: data['nomeAnimal'] as String?,
      brincoAnimal: data['brincoAnimal'] as String?,
      medicamento: data['medicamento'] as String?,
      posologia: data['posologia'] as String?,
      lote: data['lote'] as String?,
      laboratorio: data['laboratorio'] as String?,
      resultado: data['resultado'] as String?,
      dtCarencia: data['dtCarencia'] as String?,
      lastSynced: DateTime.now(),
      needsSync: false,
    );
  }

  /// Campos planos. As referências são reanexadas pelo serviço de sync, que
  /// tem acesso ao FirebaseFirestore.
  @override
  Map<String, dynamic> toFirestore() {
    final data = <String, dynamic>{
      'tipoAcao': tipoAcao,
      'acao': acao,
      'obsVisita': obsVisita,
      'dtAcao': dtAcao,
      'nomeAnimal': nomeAnimal,
      'brincoAnimal': brincoAnimal,
    };
    if (medicamento != null) data['medicamento'] = medicamento;
    if (posologia != null) data['posologia'] = posologia;
    if (lote != null) data['lote'] = lote;
    if (laboratorio != null) data['laboratorio'] = laboratorio;
    if (resultado != null) data['resultado'] = resultado;
    if (dtCarencia != null) data['dtCarencia'] = dtCarencia;
    return data;
  }

  @override
  void markAsModified([String? userId]) {
    lastModified = DateTime.now();
    needsSync = true;
  }
}