import 'package:objectbox/objectbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Entidade Financeiro para armazenamento local
/// Representa dados financeiros da propriedade
@Entity()
class FinanceiroEntity {
  @Id()
  int id = 0;

  @Unique()
  String? firestoreId;

  String? parentPath;

  /// Dados de produção
  int vacasLactacao;
  int vacasSecas;
  int litrosLeiteMes;
  double precoLitroLeite;

  /// Valores de entrada
  double valorLeiteTotal;
  double outrasReceitas;

  /// Valores de saída/custos
  double custoRacao;
  double custoMaoDeObra;
  double custoMedicamentos;
  double custoInsumos;
  double custoManutencao;
  double outrosCustos;

  /// Indicadores calculados
  double custoTotal;
  double lucroLiquido;
  double custoLitro;

  /// Período de referência
  int mes;
  int ano;

  String? uidPropriedade;
  String? createdBy;
  String? lastModifiedBy;

  @Property(type: PropertyType.date)
  DateTime? createdAt;

  @Property(type: PropertyType.date)
  DateTime? lastModified;

  @Property(type: PropertyType.date)
  DateTime? lastSynced;

  bool needsSync;

  FinanceiroEntity({
    this.firestoreId,
    this.parentPath,
    this.vacasLactacao = 0,
    this.vacasSecas = 0,
    this.litrosLeiteMes = 0,
    this.precoLitroLeite = 0.0,
    this.valorLeiteTotal = 0.0,
    this.outrasReceitas = 0.0,
    this.custoRacao = 0.0,
    this.custoMaoDeObra = 0.0,
    this.custoMedicamentos = 0.0,
    this.custoInsumos = 0.0,
    this.custoManutencao = 0.0,
    this.outrosCustos = 0.0,
    this.custoTotal = 0.0,
    this.lucroLiquido = 0.0,
    this.custoLitro = 0.0,
    this.mes = 0,
    this.ano = 0,
    this.uidPropriedade,
    this.createdBy,
    this.createdAt,
    this.lastModifiedBy,
    this.lastModified,
    this.lastSynced,
    this.needsSync = false,
  });

  factory FinanceiroEntity.fromFirestore(
    Map<String, dynamic> data,
    String docId, {
    String? parentPath,
  }) {
    return FinanceiroEntity(
      firestoreId: docId,
      parentPath: parentPath,
      vacasLactacao: (data['vacas_lactacao'] as num?)?.toInt() ?? 0,
      vacasSecas: (data['vacas_secas'] as num?)?.toInt() ?? 0,
      litrosLeiteMes: (data['litros_leite_mes'] as num?)?.toInt() ?? 0,
      precoLitroLeite: (data['preco_litro_leite'] as num?)?.toDouble() ?? 0.0,
      valorLeiteTotal: (data['valor_leite_total'] as num?)?.toDouble() ?? 0.0,
      outrasReceitas: (data['outras_receitas'] as num?)?.toDouble() ?? 0.0,
      custoRacao: (data['custo_racao'] as num?)?.toDouble() ?? 0.0,
      custoMaoDeObra: (data['custo_mao_de_obra'] as num?)?.toDouble() ?? 0.0,
      custoMedicamentos:
          (data['custo_medicamentos'] as num?)?.toDouble() ?? 0.0,
      custoInsumos: (data['custo_insumos'] as num?)?.toDouble() ?? 0.0,
      custoManutencao: (data['custo_manutencao'] as num?)?.toDouble() ?? 0.0,
      outrosCustos: (data['outros_custos'] as num?)?.toDouble() ?? 0.0,
      custoTotal: (data['custo_total'] as num?)?.toDouble() ?? 0.0,
      lucroLiquido: (data['lucro_liquido'] as num?)?.toDouble() ?? 0.0,
      custoLitro: (data['custo_litro'] as num?)?.toDouble() ?? 0.0,
      mes: (data['mes'] as num?)?.toInt() ?? 0,
      ano: (data['ano'] as num?)?.toInt() ?? 0,
      uidPropriedade: data['uid_propriedade'] as String?,
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

    data['vacas_lactacao'] = vacasLactacao;
    data['vacas_secas'] = vacasSecas;
    data['litros_leite_mes'] = litrosLeiteMes;
    data['preco_litro_leite'] = precoLitroLeite;
    data['valor_leite_total'] = valorLeiteTotal;
    data['outras_receitas'] = outrasReceitas;
    data['custo_racao'] = custoRacao;
    data['custo_mao_de_obra'] = custoMaoDeObra;
    data['custo_medicamentos'] = custoMedicamentos;
    data['custo_insumos'] = custoInsumos;
    data['custo_manutencao'] = custoManutencao;
    data['outros_custos'] = outrosCustos;
    data['custo_total'] = custoTotal;
    data['lucro_liquido'] = lucroLiquido;
    data['custo_litro'] = custoLitro;
    data['mes'] = mes;
    data['ano'] = ano;
    if (uidPropriedade != null) data['uid_propriedade'] = uidPropriedade;
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
