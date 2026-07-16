import 'package:objectbox/objectbox.dart';

import 'syncable_entity.dart';

/// Entidade Propriedades para armazenamento local com ObjectBox
/// Sincroniza com a subcoleção 'propriedades' do Firestore
@Entity()
class PropriedadeEntity implements SyncableEntity {
  @override
  @Id()
  int id = 0;

  /// ID do documento no Firestore (usado para sincronização)
  @override
  @Unique()
  String? firestoreId;

  /// Path do documento pai: o TÉCNICO (`tecnico/{firestoreId}`). O documento
  /// real no Firestore é `tecnico/{id}/propriedades/{id}` — é esse o path que
  /// toda a UI usa para criar, ler e editar propriedades.
  @override
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

  /// `true` quando há um produtor vinculado (`uidPersonProdutor` presente) — ou
  /// seja, a conta do produtor já foi criada/ativada. `false` = propriedade
  /// pendente de ativação (pode já existir no Firestore, mas sem produtor).
  /// Derivado de `uidPersonProdutor` no `fromFirestore`/`updateFromFirestore`,
  /// então é consistente localmente e após download.
  bool contaCriada;

  @override
  bool isDeleted;

  @Property(type: PropertyType.date)
  DateTime? deletedAt;

  /// Campos de controle de sincronização
  @override
  @Property(type: PropertyType.date)
  DateTime? lastModified;

  @override
  @Property(type: PropertyType.date)
  DateTime? lastSynced;

  @override
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
    this.contaCriada = false,
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
      // Pendente/ativa é derivado do vínculo com o produtor: uma propriedade
      // pode existir no Firestore sem produtor (sincronizada mas não ativada).
      contaCriada: data['uidPersonProdutor'] != null,
      isDeleted: data['isDeleted'] as bool? ?? false,
      deletedAt: data['deletedAt'] != null
          ? (data['deletedAt'] as dynamic).toDate()
          : null,
      lastModified: DateTime.now(),
      lastSynced: DateTime.now(),
      needsSync: false,
    );
  }

  @override
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
    // Pendente/ativa segue o vínculo com o produtor.
    contaCriada = uidPersonProdutorPath != null;
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

  @override
  void markAsModified() {
    lastModified = DateTime.now();
    needsSync = true;
  }
}
