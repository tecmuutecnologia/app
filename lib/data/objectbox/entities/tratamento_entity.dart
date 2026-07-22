import 'package:objectbox/objectbox.dart';

import 'syncable_entity.dart';

/// Entidade Tratamento para armazenamento local.
///
/// ⚠️ Schema REESCRITO para bater com o `TratamentosRecord` — o que o app
/// grava. A versão anterior lia `snake_case` (`uid_animal`, `dt_tratamento`,
/// ...) e modelava campos de bula (medicamento, posologia, lote) que o
/// formulário nunca preenche, então nada casava e a tabela ficava vazia.
///
/// Documentos vivem em
/// `tecnico/{t}/propriedades/{p}/tratamentos/{id}`; o vínculo com a visita é o
/// CAMPO `uidResumoDaVisita`, não a hierarquia.
@Entity()
class TratamentoEntity implements SyncableEntity {
  @override
  @Id()
  int id = 0;

  @override
  @Unique()
  String? firestoreId;

  /// Caminho da propriedade dona do tratamento.
  @override
  String? parentPath;

  /// Referências guardadas como caminho (convenção do `AnimalEntity`).
  String? uidTratamentosPath;
  String? uidAnimalPath;
  String? uidResumoDaVisitaPath;
  String? uidAcaoLancadaPath;

  String? tipoAcao;
  String? observacaoAcao;
  String? nomeAnimal;
  String? dtAcaoTratamento;
  String? grupoAnimal;
  String? brincoAnimal;
  int brincoAnimalOrder;

  @Property(type: PropertyType.date)
  DateTime? compararDtUltimaInseminacao;

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
    this.uidTratamentosPath,
    this.uidAnimalPath,
    this.uidResumoDaVisitaPath,
    this.uidAcaoLancadaPath,
    this.tipoAcao,
    this.observacaoAcao,
    this.nomeAnimal,
    this.dtAcaoTratamento,
    this.grupoAnimal,
    this.brincoAnimal,
    this.brincoAnimalOrder = 0,
    this.compararDtUltimaInseminacao,
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
    String? caminho(dynamic r) {
      if (r == null) return null;
      if (r is String) return r;
      try {
        return (r as dynamic).path as String?;
      } catch (_) {
        return null;
      }
    }

    DateTime? quando(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      try {
        return (v as dynamic).toDate() as DateTime?;
      } catch (_) {
        return null;
      }
    }

    return TratamentoEntity(
      firestoreId: docId,
      parentPath: parentPath,
      uidTratamentosPath: caminho(data['uidTratamentos']),
      uidAnimalPath: caminho(data['uidAnimal']),
      uidResumoDaVisitaPath: caminho(data['uidResumoDaVisita']),
      uidAcaoLancadaPath: caminho(data['uidAcaoLancada']),
      tipoAcao: data['tipoAcao'] as String?,
      observacaoAcao: data['observacaoAcao'] as String?,
      nomeAnimal: data['nomeAnimal'] as String?,
      dtAcaoTratamento: data['dtAcaoTratamento'] as String?,
      grupoAnimal: data['grupoAnimal'] as String?,
      brincoAnimal: data['brincoAnimal'] as String?,
      brincoAnimalOrder: (data['brincoAnimalOrder'] as num?)?.toInt() ?? 0,
      compararDtUltimaInseminacao: quando(data['compararDtUltimaInseminacao']),
      lastSynced: DateTime.now(),
      needsSync: false,
    );
  }

  /// Campos planos; referências e Timestamps são reanexados pelo repositório.
  @override
  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'tipoAcao': tipoAcao,
      'observacaoAcao': observacaoAcao,
      'nomeAnimal': nomeAnimal,
      'dtAcaoTratamento': dtAcaoTratamento,
      'grupoAnimal': grupoAnimal,
      'brincoAnimal': brincoAnimal,
      'brincoAnimalOrder': brincoAnimalOrder,
    };
  }

  @override
  void markAsModified([String? userId]) {
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
  /// Data no formato `dd/MM/yyyy`.
  ///
  /// ⚠️ Chamava-se `dtAcao` e era `DateTime`. O ObjectBox NÃO permite trocar o
  /// tipo de uma propriedade existente ("Existing Property dtAcao (Date) is
  /// not compatible with the new type String"), então foi renomeada: a antiga
  /// é aposentada e esta nasce como propriedade nova. A chave no Firestore
  /// continua `dtAcao`.
  String? dtAcaoFormatada;
  String? nomeAnimal;
  String? brincoAnimal;

  /// Campos previstos para o módulo sanitário, ainda não capturados pelo
  /// formulário. Mantidos (nullable) para não perder a modelagem.
  String? medicamento;
  String? posologia;
  String? lote;
  String? laboratorio;
  String? resultado;
  String? dtCarenciaFormatada;

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
    this.dtAcaoFormatada,
    this.nomeAnimal,
    this.brincoAnimal,
    this.medicamento,
    this.posologia,
    this.lote,
    this.laboratorio,
    this.resultado,
    this.dtCarenciaFormatada,
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
      dtAcaoFormatada: data['dtAcao'] as String?,
      nomeAnimal: data['nomeAnimal'] as String?,
      brincoAnimal: data['brincoAnimal'] as String?,
      medicamento: data['medicamento'] as String?,
      posologia: data['posologia'] as String?,
      lote: data['lote'] as String?,
      laboratorio: data['laboratorio'] as String?,
      resultado: data['resultado'] as String?,
      dtCarenciaFormatada: data['dtCarencia'] as String?,
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
      'dtAcao': dtAcaoFormatada,
      'nomeAnimal': nomeAnimal,
      'brincoAnimal': brincoAnimal,
    };
    if (medicamento != null) data['medicamento'] = medicamento;
    if (posologia != null) data['posologia'] = posologia;
    if (lote != null) data['lote'] = lote;
    if (laboratorio != null) data['laboratorio'] = laboratorio;
    if (resultado != null) data['resultado'] = resultado;
    if (dtCarenciaFormatada != null) {
      data['dtCarencia'] = dtCarenciaFormatada;
    }
    return data;
  }

  @override
  void markAsModified([String? userId]) {
    lastModified = DateTime.now();
    needsSync = true;
  }
}
