import 'package:objectbox/objectbox.dart';

/// Entidade local do ObjectBox para Tecnico
/// Corresponde ao TecnicoRecord do Firestore
@Entity()
class TecnicoEntity {
  @Id()
  int id = 0;

  @Unique()
  String? firestoreId;

  String? uidPerson;
  bool? liberado;
  int? limiteProdutoresContratado;
  int? quantidadeProdutoresCadastrados;
  int? restanteLimiteProdutores;
  int? limiteAnimaisContratado;
  int? quantidadeAnimaisCadastrados;
  int? restanteLimiteAnimais;

  // Campos de controle
  @Property(type: PropertyType.date)
  DateTime? lastSyncedAt;

  bool needsSync = false;
  bool isDeleted = false;

  TecnicoEntity({
    this.id = 0,
    this.firestoreId,
    this.uidPerson,
    this.liberado,
    this.limiteProdutoresContratado,
    this.quantidadeProdutoresCadastrados,
    this.restanteLimiteProdutores,
    this.limiteAnimaisContratado,
    this.quantidadeAnimaisCadastrados,
    this.restanteLimiteAnimais,
    this.lastSyncedAt,
    this.needsSync = false,
    this.isDeleted = false,
  });

  factory TecnicoEntity.fromFirestore({
    required String firestoreId,
    required Map<String, dynamic> data,
  }) {
    return TecnicoEntity(
      firestoreId: firestoreId,
      uidPerson: data['uidPerson'] as String?,
      liberado: data['liberado'] as bool?,
      limiteProdutoresContratado: data['limiteProdutoresContratado'] as int?,
      quantidadeProdutoresCadastrados:
          data['quantidadeProdutoresCadastrados'] as int?,
      restanteLimiteProdutores: data['restanteLimiteProdutores'] as int?,
      limiteAnimaisContratado: data['limiteAnimaisContratado'] as int?,
      quantidadeAnimaisCadastrados:
          data['quantidadeAnimaisCadastrados'] as int?,
      restanteLimiteAnimais: data['restanteLimiteAnimais'] as int?,
      lastSyncedAt: DateTime.now(),
      needsSync: false,
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'uidPerson': uidPerson,
      'liberado': liberado,
      'limiteProdutoresContratado': limiteProdutoresContratado,
      'quantidadeProdutoresCadastrados': quantidadeProdutoresCadastrados,
      'restanteLimiteProdutores': restanteLimiteProdutores,
      'limiteAnimaisContratado': limiteAnimaisContratado,
      'quantidadeAnimaisCadastrados': quantidadeAnimaisCadastrados,
      'restanteLimiteAnimais': restanteLimiteAnimais,
    };
  }

  void markForSync() => needsSync = true;

  void markAsSynced() {
    needsSync = false;
    lastSyncedAt = DateTime.now();
  }
}
