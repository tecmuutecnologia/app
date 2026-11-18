import 'package:objectbox/objectbox.dart';

import 'syncable_entity.dart';

/// Venda de um animal — receita da propriedade, mostrada na aba Vendas do
/// Financeiro.
///
/// É um registro PRÓPRIO, separado do animal, para que a receita continue no
/// Financeiro mesmo se o animal for removido permanentemente. Por isso guarda
/// uma CÓPIA de nome/brinco/grupo do momento da venda.
///
/// Os documentos vivem em
/// `tecnico/{idTecnico}/propriedades/{idPropriedade}/vendasAnimais/{id}`, ou
/// seja `parentPath` é o caminho da PROPRIEDADE (mesma convenção do
/// `FinanceiroEntity`). Desfazer a venda = soft delete deste registro.
@Entity()
class VendaAnimalEntity implements SyncableEntity {
  @override
  @Id()
  int id = 0;

  @override
  @Unique()
  String? firestoreId;

  /// Caminho da propriedade dona da venda.
  @override
  String? parentPath;

  String? uidPropriedadePath;
  String? uidTecnicoPath;

  /// firestoreId do animal vendido (pode não existir mais).
  String? animalId;
  String? nomeAnimal;
  int brincoAnimal;
  String? grupoAnimal;

  /// Data da venda, `dd/MM/yyyy` (mesmo formato das demais datas do app).
  String? dtVenda;

  /// Valor da venda em reais.
  double valorVenda;

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

  VendaAnimalEntity({
    this.firestoreId,
    this.parentPath,
    this.uidPropriedadePath,
    this.uidTecnicoPath,
    this.animalId,
    this.nomeAnimal,
    this.brincoAnimal = 0,
    this.grupoAnimal,
    this.dtVenda,
    this.valorVenda = 0,
    this.lastModified,
    this.lastSynced,
    this.needsSync = false,
    this.isDeleted = false,
  });

  factory VendaAnimalEntity.fromFirestore(
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

    return VendaAnimalEntity(
      firestoreId: docId,
      parentPath: parentPath,
      uidPropriedadePath: caminho(data['uidPropriedade']),
      uidTecnicoPath: caminho(data['uidTecnico']),
      animalId: data['animalId'] as String?,
      nomeAnimal: data['nomeAnimal'] as String?,
      brincoAnimal: (data['brincoAnimal'] as num?)?.toInt() ?? 0,
      grupoAnimal: data['grupoAnimal'] as String?,
      dtVenda: data['dtVenda'] as String?,
      valorVenda: (data['valorVenda'] as num?)?.toDouble() ?? 0,
      lastSynced: DateTime.now(),
      needsSync: false,
    );
  }

  /// Campos planos; as referências são reanexadas pelo repositório.
  @override
  Map<String, dynamic> toFirestore() => <String, dynamic>{
        'animalId': animalId,
        'nomeAnimal': nomeAnimal,
        'brincoAnimal': brincoAnimal,
        'grupoAnimal': grupoAnimal,
        'dtVenda': dtVenda,
        'valorVenda': valorVenda,
      };

  @override
  void markAsModified([String? userId]) {
    lastModified = DateTime.now();
    needsSync = true;
  }
}
