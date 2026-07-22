import 'package:objectbox/objectbox.dart';

import 'syncable_entity.dart';

/// Entidade Financeiro para armazenamento local (relatório financeiro mensal
/// da propriedade).
///
/// ⚠️ Este schema foi REESCRITO para espelhar o `FinanceiroRecord` — o que a
/// tela realmente grava. A versão anterior modelava um relatório de custos
/// detalhado que nunca foi implementado (`custo_racao`, `custo_mao_de_obra`,
/// `mes`/`ano`, ...) e usava `snake_case`, enquanto o app grava `camelCase`.
/// Nenhuma chave batia, então `fromFirestore` produzia um registro zerado —
/// motivo pelo qual a tela nunca pôde ser migrada para o ObjectBox.
///
/// Os documentos vivem em
/// `tecnico/{idTecnico}/propriedades/{idPropriedade}/financeiro/{id}`, ou seja
/// `parentPath` é o caminho da PROPRIEDADE.
@Entity()
class FinanceiroEntity implements SyncableEntity {
  @override
  @Id()
  int id = 0;

  @override
  @Unique()
  String? firestoreId;

  /// Caminho da propriedade dona do relatório.
  @override
  String? parentPath;

  /// Referências do Firestore guardadas como caminho (mesma convenção do
  /// `AnimalEntity`, que não persiste `DocumentReference` direto).
  String? uidPropriedadePath;
  String? uidTecnicoPath;

  /// Data do relatório no formato `dd/MM/yyyy` (é string no Firestore).
  String? dtRelatorio;

  /// Produção
  int vacasLactacao;
  int litrosLeiteMes;
  int litrosLeitePorDia;

  /// Valores — string no Firestore (vêm formatados do formulário).
  String? precoRecebidoPorLitro;
  String? despesasNoMes;
  String? faturamentoLiquido;
  String? mediaProducaoVaca;
  String? custoLitroLeite;
  String? totalRecebidoMes;

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

  FinanceiroEntity({
    this.firestoreId,
    this.parentPath,
    this.uidPropriedadePath,
    this.uidTecnicoPath,
    this.dtRelatorio,
    this.vacasLactacao = 0,
    this.litrosLeiteMes = 0,
    this.litrosLeitePorDia = 0,
    this.precoRecebidoPorLitro,
    this.despesasNoMes,
    this.faturamentoLiquido,
    this.mediaProducaoVaca,
    this.custoLitroLeite,
    this.totalRecebidoMes,
    this.lastModified,
    this.lastSynced,
    this.needsSync = false,
    this.isDeleted = false,
  });

  factory FinanceiroEntity.fromFirestore(
    Map<String, dynamic> data,
    String docId, {
    String? parentPath,
  }) {
    // `uidPropriedade`/`uidTecnico` chegam como DocumentReference; guardamos o
    // caminho. `dynamic` para não acoplar o entity ao cloud_firestore.
    String? caminho(dynamic ref) {
      if (ref == null) return null;
      if (ref is String) return ref;
      try {
        return (ref as dynamic).path as String?;
      } catch (_) {
        return null;
      }
    }

    return FinanceiroEntity(
      firestoreId: docId,
      parentPath: parentPath,
      uidPropriedadePath: caminho(data['uidPropriedade']),
      uidTecnicoPath: caminho(data['uidTecnico']),
      dtRelatorio: data['dtRelatorio'] as String?,
      vacasLactacao: (data['vacasLactacao'] as num?)?.toInt() ?? 0,
      litrosLeiteMes: (data['litrosLeiteMes'] as num?)?.toInt() ?? 0,
      litrosLeitePorDia: (data['litrosLeitePorDia'] as num?)?.toInt() ?? 0,
      precoRecebidoPorLitro: data['precoRecebidoPorLitro'] as String?,
      despesasNoMes: data['despesasNoMes'] as String?,
      faturamentoLiquido: data['faturamentoLiquido'] as String?,
      mediaProducaoVaca: data['mediaProducaoVaca'] as String?,
      custoLitroLeite: data['custoLitroLeite'] as String?,
      totalRecebidoMes: data['totalRecebidoMes'] as String?,
      lastSynced: DateTime.now(),
      needsSync: false,
    );
  }

  /// Payload do documento. As referências são reidratadas pelo repositório de
  /// sync (que tem acesso ao FirebaseFirestore); aqui vão só os campos planos.
  @override
  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'dtRelatorio': dtRelatorio,
      'vacasLactacao': vacasLactacao,
      'litrosLeiteMes': litrosLeiteMes,
      'litrosLeitePorDia': litrosLeitePorDia,
      'precoRecebidoPorLitro': precoRecebidoPorLitro,
      'despesasNoMes': despesasNoMes,
      'faturamentoLiquido': faturamentoLiquido,
      'mediaProducaoVaca': mediaProducaoVaca,
      'custoLitroLeite': custoLitroLeite,
      'totalRecebidoMes': totalRecebidoMes,
    };
  }

  @override
  void markAsModified([String? userId]) {
    lastModified = DateTime.now();
    needsSync = true;
  }
}
