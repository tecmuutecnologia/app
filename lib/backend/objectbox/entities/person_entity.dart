import 'package:objectbox/objectbox.dart';

/// Entidade Person para armazenamento local com ObjectBox
/// Sincroniza com a coleção 'person' do Firestore
@Entity()
class PersonEntity {
  @Id()
  int id = 0;

  /// ID do documento no Firestore (usado para sincronização)
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

  /// Campos de controle de sincronização
  @Property(type: PropertyType.date)
  DateTime? lastModified;

  @Property(type: PropertyType.date)
  DateTime? lastSynced;

  /// Indica se o registro foi modificado localmente e precisa ser sincronizado
  bool needsSync;

  /// Indica se o registro foi deletado localmente (soft delete)
  bool isDeleted;

  PersonEntity({
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
    this.lastModified,
    this.lastSynced,
    this.needsSync = false,
    this.isDeleted = false,
  });

  /// Converte dados do Firestore para entidade ObjectBox
  factory PersonEntity.fromFirestore(Map<String, dynamic> data, String docId) {
    return PersonEntity(
      firestoreId: docId,
      dtNascimento: data['dtNascimento'] as String?,
      cpf: data['cpf'] as String?,
      uid: data['uid'] as String?,
      endereco: data['endereco'] as String?,
      cidade: data['cidade'] as String?,
      bairro: data['bairro'] as String?,
      email: data['email'] as String?,
      createdTime: data['created_time'] != null
          ? (data['created_time'] as dynamic).toDate()
          : null,
      displayName: data['display_name'] as String?,
      photoUrl: data['photo_url'] as String?,
      phoneNumber: data['phone_number'] as String?,
      empresa: data['empresa'] as String?,
      tipo: data['tipo'] as String?,
      lastModified: DateTime.now(),
      lastSynced: DateTime.now(),
      needsSync: false,
      isDeleted: false,
    );
  }

  /// Converte entidade ObjectBox para dados do Firestore
  Map<String, dynamic> toFirestore() {
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

  /// Atualiza campos a partir de dados do Firestore
  void updateFromFirestore(Map<String, dynamic> data) {
    dtNascimento = data['dtNascimento'] as String? ?? dtNascimento;
    cpf = data['cpf'] as String? ?? cpf;
    uid = data['uid'] as String? ?? uid;
    endereco = data['endereco'] as String? ?? endereco;
    cidade = data['cidade'] as String? ?? cidade;
    bairro = data['bairro'] as String? ?? bairro;
    email = data['email'] as String? ?? email;
    if (data['created_time'] != null) {
      createdTime = (data['created_time'] as dynamic).toDate();
    }
    displayName = data['display_name'] as String? ?? displayName;
    photoUrl = data['photo_url'] as String? ?? photoUrl;
    phoneNumber = data['phone_number'] as String? ?? phoneNumber;
    empresa = data['empresa'] as String? ?? empresa;
    tipo = data['tipo'] as String? ?? tipo;
    lastSynced = DateTime.now();
    needsSync = false;
  }

  /// Marca o registro como modificado localmente
  void markAsModified() {
    lastModified = DateTime.now();
    needsSync = true;
  }
}
