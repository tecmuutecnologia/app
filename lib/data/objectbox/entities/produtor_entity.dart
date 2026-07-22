import 'package:objectbox/objectbox.dart';

import 'syncable_entity.dart';

/// Entidade Produtor para armazenamento local com ObjectBox
/// Sincroniza com a coleção 'produtor' do Firestore
@Entity()
class ProdutorEntity implements SyncableEntity {
  @override
  @Id()
  int id = 0;

  /// ID do documento no Firestore (usado para sincronização)
  @override
  @Unique()
  String? firestoreId;

  /// Coleção de topo: não tem documento pai (getter computado, não persistido).
  @override
  String? get parentPath => null;

  bool liberado;

  /// Referência ao técnico (path do documento Firestore)
  String? uidTecnicoPath;

  /// Referência ao person (path do documento Firestore)
  String? uidPersonPath;

  /// Campos de controle de sincronização
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

  ProdutorEntity({
    this.firestoreId,
    this.liberado = false,
    this.uidTecnicoPath,
    this.uidPersonPath,
    this.lastModified,
    this.lastSynced,
    this.needsSync = false,
    this.isDeleted = false,
  });

  factory ProdutorEntity.fromFirestore(
      Map<String, dynamic> data, String docId) {
    return ProdutorEntity(
      firestoreId: docId,
      liberado: data['liberado'] as bool? ?? false,
      uidTecnicoPath: data['uidTecnico']?.path,
      uidPersonPath: data['uidPerson']?.path,
      lastModified: DateTime.now(),
      lastSynced: DateTime.now(),
      needsSync: false,
      isDeleted: false,
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'liberado': liberado,
      // Nota: DocumentReferences precisam ser convertidos manualmente
      // ao enviar para o Firestore
    };
  }

  void updateFromFirestore(Map<String, dynamic> data) {
    liberado = data['liberado'] as bool? ?? liberado;
    uidTecnicoPath = data['uidTecnico']?.path ?? uidTecnicoPath;
    uidPersonPath = data['uidPerson']?.path ?? uidPersonPath;
    lastSynced = DateTime.now();
    needsSync = false;
  }

  @override
  void markAsModified() {
    lastModified = DateTime.now();
    needsSync = true;
  }
}
