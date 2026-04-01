import 'package:objectbox/objectbox.dart';

/// Entidade Produtor para armazenamento local com ObjectBox
/// Sincroniza com a coleção 'produtor' do Firestore
@Entity()
class ProdutorEntity {
  @Id()
  int id = 0;

  /// ID do documento no Firestore (usado para sincronização)
  @Unique()
  String? firestoreId;

  bool liberado;

  /// Referência ao técnico (path do documento Firestore)
  String? uidTecnicoPath;

  /// Referência ao person (path do documento Firestore)
  String? uidPersonPath;

  /// Campos de controle de sincronização
  @Property(type: PropertyType.date)
  DateTime? lastModified;

  @Property(type: PropertyType.date)
  DateTime? lastSynced;

  bool needsSync;
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

  void markAsModified() {
    lastModified = DateTime.now();
    needsSync = true;
  }
}
