import 'package:objectbox/objectbox.dart';

/// Entidade para controle de sincronização
/// Armazena metadados sobre o estado da sincronização
@Entity()
class SyncMetadataEntity {
  @Id()
  int id = 0;

  /// Nome da coleção que está sendo sincronizada
  @Unique()
  String? collectionName;

  /// Timestamp da última sincronização completa
  @Property(type: PropertyType.date)
  DateTime? lastFullSync;

  /// Timestamp da última sincronização incremental
  @Property(type: PropertyType.date)
  DateTime? lastIncrementalSync;

  /// Indica se a sincronização inicial foi concluída
  bool initialSyncComplete;

  /// Número de registros na coleção
  int recordCount;

  /// Versão do schema local
  int schemaVersion;

  SyncMetadataEntity({
    this.collectionName,
    this.lastFullSync,
    this.lastIncrementalSync,
    this.initialSyncComplete = false,
    this.recordCount = 0,
    this.schemaVersion = 1,
  });
}

/// Entidade para fila de operações pendentes
/// Armazena operações que precisam ser enviadas ao Firestore
@Entity()
class PendingOperationEntity {
  @Id()
  int id = 0;

  /// Tipo de operação: CREATE, UPDATE, DELETE
  String? operationType;

  /// Nome da coleção/entidade
  String? collectionName;

  /// ID do documento no Firestore (se existir)
  String? firestoreId;

  /// Path completo do documento no Firestore
  String? documentPath;

  /// Dados da operação em JSON
  String? dataJson;

  /// Timestamp de quando a operação foi criada
  @Property(type: PropertyType.date)
  DateTime? createdAt;

  /// Número de tentativas de sincronização
  int retryCount;

  /// Última mensagem de erro (se houver)
  String? lastError;

  /// Prioridade da operação (1 = alta, 5 = baixa)
  int priority;

  PendingOperationEntity({
    this.operationType,
    this.collectionName,
    this.firestoreId,
    this.documentPath,
    this.dataJson,
    this.createdAt,
    this.retryCount = 0,
    this.lastError,
    this.priority = 3,
  });
}
