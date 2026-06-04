import 'package:objectbox/objectbox.dart';

import 'syncable_entity.dart';

/// Entidade Tecnico para armazenamento local com ObjectBox
/// Sincroniza com a coleção 'tecnico' do Firestore
@Entity()
class TecnicoEntity implements SyncableEntity {
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

  String? uidPerson;
  bool liberado;
  int limiteProdutoresContratado;
  int quantidadeProdutoresCadastrados;
  int restanteLimiteProdutores;
  int limiteAnimaisContratado;
  int quantidadeAnimaisCadastrados;
  int restanteLimiteAnimais;

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

  TecnicoEntity({
    this.firestoreId,
    this.uidPerson,
    this.liberado = false,
    this.limiteProdutoresContratado = 0,
    this.quantidadeProdutoresCadastrados = 0,
    this.restanteLimiteProdutores = 0,
    this.limiteAnimaisContratado = 0,
    this.quantidadeAnimaisCadastrados = 0,
    this.restanteLimiteAnimais = 0,
    this.lastModified,
    this.lastSynced,
    this.needsSync = false,
    this.isDeleted = false,
  });

  factory TecnicoEntity.fromFirestore(Map<String, dynamic> data, String docId) {
    return TecnicoEntity(
      firestoreId: docId,
      uidPerson: data['uidPerson'] as String?,
      liberado: data['liberado'] as bool? ?? false,
      limiteProdutoresContratado:
          (data['limiteProdutoresContratado'] as num?)?.toInt() ?? 0,
      quantidadeProdutoresCadastrados:
          (data['quantidadeProdutoresCadastrados'] as num?)?.toInt() ?? 0,
      restanteLimiteProdutores:
          (data['restanteLimiteProdutores'] as num?)?.toInt() ?? 0,
      limiteAnimaisContratado:
          (data['limiteAnimaisContratado'] as num?)?.toInt() ?? 0,
      quantidadeAnimaisCadastrados:
          (data['quantidadeAnimaisCadastrados'] as num?)?.toInt() ?? 0,
      restanteLimiteAnimais:
          (data['restanteLimiteAnimais'] as num?)?.toInt() ?? 0,
      lastModified: DateTime.now(),
      lastSynced: DateTime.now(),
      needsSync: false,
      isDeleted: false,
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'uidPerson': uidPerson,
      'liberado': liberado,
      'limiteProdutoresContratado': limiteProdutoresContratado,
      'quantidadeProdutoresCadastrados': quantidadeProdutoresCadastrados,
      'restanteLimiteProdutores': restanteLimiteProdutores,
      'limiteAnimaisContratado': limiteAnimaisContratado,
      'quantidadeAnimaisCadastrados': quantidadeAnimaisCadastrados,
      'restanteLimiteAnimais': restanteLimiteAnimais,
    };
  }

  void updateFromFirestore(Map<String, dynamic> data) {
    uidPerson = data['uidPerson'] as String? ?? uidPerson;
    liberado = data['liberado'] as bool? ?? liberado;
    limiteProdutoresContratado =
        (data['limiteProdutoresContratado'] as num?)?.toInt() ??
            limiteProdutoresContratado;
    quantidadeProdutoresCadastrados =
        (data['quantidadeProdutoresCadastrados'] as num?)?.toInt() ??
            quantidadeProdutoresCadastrados;
    restanteLimiteProdutores =
        (data['restanteLimiteProdutores'] as num?)?.toInt() ??
            restanteLimiteProdutores;
    limiteAnimaisContratado =
        (data['limiteAnimaisContratado'] as num?)?.toInt() ??
            limiteAnimaisContratado;
    quantidadeAnimaisCadastrados =
        (data['quantidadeAnimaisCadastrados'] as num?)?.toInt() ??
            quantidadeAnimaisCadastrados;
    restanteLimiteAnimais = (data['restanteLimiteAnimais'] as num?)?.toInt() ??
        restanteLimiteAnimais;
    lastSynced = DateTime.now();
    needsSync = false;
  }

  @override
  void markAsModified() {
    lastModified = DateTime.now();
    needsSync = true;
  }
}
