import 'package:objectbox/objectbox.dart';

/// Entidade para fila de operações pendentes.
///
/// Armazena operações (CREATE/UPDATE/DELETE) que precisam ser enviadas ao
/// Firestore quando houver conectividade. Cada operação carrega o path do
/// documento, o payload serializado e metadados de retry.
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
