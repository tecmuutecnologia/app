import 'package:objectbox/objectbox.dart';

/// Entidade local do ObjectBox para Person
/// Corresponde ao PersonRecord do Firestore
@Entity()
class PersonEntity {
  @Id()
  int id = 0; // ID local do ObjectBox (auto-incrementado)

  // ID do Firestore para sincronização
  @Unique()
  String? firestoreId;

  String? dtNascimento;
  String? cpf;
  String? uid;
  String? endereco;
  String? cidade;
  String? bairro;
  String? email;

  @Property(type: PropertyType.date)
  DateTime? createdTime;

  String? displayName;
  String? photoUrl;
  String? phoneNumber;
  String? empresa;
  String? tipo;

  // Campos de controle de sincronização
  @Property(type: PropertyType.date)
  DateTime? lastSyncedAt;

  bool needsSync = false; // Se tem alterações pendentes para sincronizar

  bool isDeleted = false; // Soft delete para sincronização

  PersonEntity({
    this.id = 0,
    this.firestoreId,
    this.dtNascimento,
    this.cpf,
    this.uid,
    this.endereco,
    this.cidade,
    this.bairro,
    this.email,
    this.createdTime,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.empresa,
    this.tipo,
    this.lastSyncedAt,
    this.needsSync = false,
    this.isDeleted = false,
  });

  /// Cria uma entidade a partir de dados do Firestore
  factory PersonEntity.fromFirestore({
    required String firestoreId,
    required Map<String, dynamic> data,
  }) {
    return PersonEntity(
      firestoreId: firestoreId,
      dtNascimento: data['dtNascimento'] as String?,
      cpf: data['cpf'] as String?,
      uid: data['uid'] as String?,
      endereco: data['endereco'] as String?,
      cidade: data['cidade'] as String?,
      bairro: data['bairro'] as String?,
      email: data['email'] as String?,
      createdTime: data['created_time'] as DateTime?,
      displayName: data['display_name'] as String?,
      photoUrl: data['photo_url'] as String?,
      phoneNumber: data['phone_number'] as String?,
      empresa: data['empresa'] as String?,
      tipo: data['tipo'] as String?,
      lastSyncedAt: DateTime.now(),
      needsSync: false,
    );
  }

  /// Converte para Map para enviar ao Firestore
  Map<String, dynamic> toFirestoreMap() {
    return {
      'dtNascimento': dtNascimento,
      'cpf': cpf,
      'uid': uid,
      'endereco': endereco,
      'cidade': cidade,
      'bairro': bairro,
      'email': email,
      'created_time': createdTime,
      'display_name': displayName,
      'photo_url': photoUrl,
      'phone_number': phoneNumber,
      'empresa': empresa,
      'tipo': tipo,
    };
  }

  /// Marca como necessitando sincronização
  void markForSync() {
    needsSync = true;
  }

  /// Marca como sincronizado
  void markAsSynced() {
    needsSync = false;
    lastSyncedAt = DateTime.now();
  }
}
