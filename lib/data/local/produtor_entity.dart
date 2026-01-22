import 'package:objectbox/objectbox.dart';

/// Entidade local do ObjectBox para Produtor
/// Corresponde ao ProdutorRecord do Firestore
@Entity()
class ProdutorEntity {
  @Id()
  int id = 0;

  @Unique()
  String? firestoreId;

  bool? liberado;

  // Referências (armazenamos o path dos DocumentReference)
  String? uidTecnico;
  String? uidPerson;

  // Campos de controle
  @Property(type: PropertyType.date)
  DateTime? lastSyncedAt;

  bool needsSync = false;
  bool isDeleted = false;

  ProdutorEntity({
    this.id = 0,
    this.firestoreId,
    this.liberado,
    this.uidTecnico,
    this.uidPerson,
    this.lastSyncedAt,
    this.needsSync = false,
    this.isDeleted = false,
  });

  factory ProdutorEntity.fromFirestore({
    required String firestoreId,
    required Map<String, dynamic> data,
  }) {
    return ProdutorEntity(
      firestoreId: firestoreId,
      liberado: data['liberado'] as bool?,
      uidTecnico: data['uidTecnico']?.toString(),
      uidPerson: data['uidPerson']?.toString(),
      lastSyncedAt: DateTime.now(),
      needsSync: false,
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'liberado': liberado,
      'uidTecnico': uidTecnico,
      'uidPerson': uidPerson,
    };
  }

  void markForSync() => needsSync = true;

  void markAsSynced() {
    needsSync = false;
    lastSyncedAt = DateTime.now();
  }
}
