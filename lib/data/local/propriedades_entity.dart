import 'package:objectbox/objectbox.dart';

/// Entidade local do ObjectBox para Propriedades
/// Corresponde ao PropriedadesRecord do Firestore
@Entity()
class PropriedadesEntity {
  @Id()
  int id = 0;

  @Unique()
  String? firestoreId;

  // Parent reference (técnico)
  String? parentReference;

  // Referência ao produtor (armazenamos o path do DocumentReference)
  String? uidPersonProdutor;

  String? email;
  String? displayName;
  String? cpf;
  String? endereco;
  String? cidade;
  String? phoneNumber;
  String? diasParaDg;

  // Campos de controle
  @Property(type: PropertyType.date)
  DateTime? lastSyncedAt;

  bool needsSync = false;
  bool isDeleted = false;

  PropriedadesEntity({
    this.id = 0,
    this.firestoreId,
    this.parentReference,
    this.uidPersonProdutor,
    this.email,
    this.displayName,
    this.cpf,
    this.endereco,
    this.cidade,
    this.phoneNumber,
    this.diasParaDg,
    this.lastSyncedAt,
    this.needsSync = false,
    this.isDeleted = false,
  });

  factory PropriedadesEntity.fromFirestore({
    required String firestoreId,
    required Map<String, dynamic> data,
    String? parentReference,
  }) {
    return PropriedadesEntity(
      firestoreId: firestoreId,
      parentReference: parentReference,
      uidPersonProdutor: data['uidPersonProdutor']?.toString(),
      email: data['email'] as String?,
      displayName: data['display_name'] as String?,
      cpf: data['cpf'] as String?,
      endereco: data['endereco'] as String?,
      cidade: data['cidade'] as String?,
      phoneNumber: data['phone_number'] as String?,
      diasParaDg: data['diasParaDg'] as String?,
      lastSyncedAt: DateTime.now(),
      needsSync: false,
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'uidPersonProdutor': uidPersonProdutor,
      'email': email,
      'display_name': displayName,
      'cpf': cpf,
      'endereco': endereco,
      'cidade': cidade,
      'phone_number': phoneNumber,
      'diasParaDg': diasParaDg,
    };
  }

  void markForSync() => needsSync = true;

  void markAsSynced() {
    needsSync = false;
    lastSyncedAt = DateTime.now();
  }
}
