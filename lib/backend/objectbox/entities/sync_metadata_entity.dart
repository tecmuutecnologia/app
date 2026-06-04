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
