import 'package:objectbox/objectbox.dart';

/// Entidade Propriedades para armazenamento local com ObjectBox
/// Sincroniza com a subcoleção 'propriedades' do Firestore
@Entity()
class PropriedadeEntity {
  @Id()
  int id = 0;

  /// ID do documento no Firestore (usado para sincronização)
  @Unique()
  String? firestoreId;

  /// Path do documento pai (produtor)
  String? parentPath;

  /// Referência ao person produtor (path do documento Firestore)
  String? uidPersonProdutorPath;

  String? email;
  String? displayName;
  String? cpf;
  String? endereco;
  String? cidade;
  String? phoneNumber;
  String? diasParaDg;
  bool isDeleted;

  @Property(type: PropertyType.date)
  DateTime? deletedAt;

  /// Campos de controle de sincronização
  @Property(type: PropertyType.date)
  DateTime? lastModified;

  @Property(type: PropertyType.date)
  DateTime? lastSynced;

  bool needsSync;

  PropriedadeEntity({
    this.firestoreId,
    this.parentPath,
    this.uidPersonProdutorPath,
    this.email,
    this.displayName,
    this.cpf,
    this.endereco,
    this.cidade,
    this.phoneNumber,
    this.diasParaDg,
    this.isDeleted = false,
    this.deletedAt,
    this.lastModified,
    this.lastSynced,
    this.needsSync = false,
  });

  factory PropriedadeEntity.fromFirestore(
    Map<String, dynamic> data,
    String docId,
    String parentPath,
  ) {
    return PropriedadeEntity(
      firestoreId: docId,
      parentPath: parentPath,
      uidPersonProdutorPath: data['uidPersonProdutor']?.path,
      email: data['email'] as String?,
      displayName: data['display_name'] as String?,
      cpf: data['cpf'] as String?,
      endereco: data['endereco'] as String?,
      cidade: data['cidade'] as String?,
      phoneNumber: data['phone_number'] as String?,
      diasParaDg: data['diasParaDg'] as String?,
      isDeleted: data['isDeleted'] as bool? ?? false,
      deletedAt: data['deletedAt'] != null
          ? (data['deletedAt'] as dynamic).toDate()
          : null,
      lastModified: DateTime.now(),
      lastSynced: DateTime.now(),
      needsSync: false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'display_name': displayName,
      'cpf': cpf,
      'endereco': endereco,
      'cidade': cidade,
      'phone_number': phoneNumber,
      'diasParaDg': diasParaDg,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt,
    };
  }

  void updateFromFirestore(Map<String, dynamic> data) {
    uidPersonProdutorPath =
        data['uidPersonProdutor']?.path ?? uidPersonProdutorPath;
    email = data['email'] as String? ?? email;
    displayName = data['display_name'] as String? ?? displayName;
    cpf = data['cpf'] as String? ?? cpf;
    endereco = data['endereco'] as String? ?? endereco;
    cidade = data['cidade'] as String? ?? cidade;
    phoneNumber = data['phone_number'] as String? ?? phoneNumber;
    diasParaDg = data['diasParaDg'] as String? ?? diasParaDg;
    isDeleted = data['isDeleted'] as bool? ?? isDeleted;
    if (data['deletedAt'] != null) {
      deletedAt = (data['deletedAt'] as dynamic).toDate();
    }
    lastSynced = DateTime.now();
    needsSync = false;
  }

  void markAsModified() {
    lastModified = DateTime.now();
    needsSync = true;
  }
}
