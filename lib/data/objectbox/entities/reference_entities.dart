import 'package:objectbox/objectbox.dart';

/// Entidade Grupo para armazenamento local
/// Tabela de referência - sincroniza com coleção 'grupo'
@Entity()
class GrupoEntity {
  @Id()
  int id = 0;

  @Unique()
  String? firestoreId;

  String? descricao;
  int grupoId;

  @Property(type: PropertyType.date)
  DateTime? lastSynced;

  GrupoEntity({
    this.firestoreId,
    this.descricao,
    this.grupoId = 0,
    this.lastSynced,
  });

  factory GrupoEntity.fromFirestore(Map<String, dynamic> data, String docId) {
    return GrupoEntity(
      firestoreId: docId,
      descricao: data['descricao'] as String?,
      grupoId: (data['id'] as num?)?.toInt() ?? 0,
      lastSynced: DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'descricao': descricao,
      'id': grupoId,
    };
  }
}

/// Entidade Raca para armazenamento local
/// Tabela de referência - sincroniza com coleção 'racas'
@Entity()
class RacaEntity {
  @Id()
  int id = 0;

  @Unique()
  String? firestoreId;

  String? descricao;

  @Property(type: PropertyType.date)
  DateTime? lastSynced;

  RacaEntity({
    this.firestoreId,
    this.descricao,
    this.lastSynced,
  });

  factory RacaEntity.fromFirestore(Map<String, dynamic> data, String docId) {
    return RacaEntity(
      firestoreId: docId,
      descricao: data['descricao'] as String?,
      lastSynced: DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'descricao': descricao};
  }
}

/// Entidade StatusAnimal para armazenamento local
/// Tabela de referência - sincroniza com coleção 'status_animais'
@Entity()
class StatusAnimalEntity {
  @Id()
  int id = 0;

  @Unique()
  String? firestoreId;

  int statusId;
  String? descricao;

  @Property(type: PropertyType.date)
  DateTime? lastSynced;

  StatusAnimalEntity({
    this.firestoreId,
    this.statusId = 0,
    this.descricao,
    this.lastSynced,
  });

  factory StatusAnimalEntity.fromFirestore(
      Map<String, dynamic> data, String docId) {
    return StatusAnimalEntity(
      firestoreId: docId,
      statusId: (data['id'] as num?)?.toInt() ?? 0,
      descricao: data['descricao'] as String?,
      lastSynced: DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': statusId,
      'descricao': descricao,
    };
  }
}

/// Entidade StatusProdutivo para armazenamento local
/// Tabela de referência - sincroniza com coleção 'status_produtivo'
@Entity()
class StatusProdutivoEntity {
  @Id()
  int id = 0;

  @Unique()
  String? firestoreId;

  int statusId;
  String? descricao;

  @Property(type: PropertyType.date)
  DateTime? lastSynced;

  StatusProdutivoEntity({
    this.firestoreId,
    this.statusId = 0,
    this.descricao,
    this.lastSynced,
  });

  factory StatusProdutivoEntity.fromFirestore(
      Map<String, dynamic> data, String docId) {
    return StatusProdutivoEntity(
      firestoreId: docId,
      statusId: (data['id'] as num?)?.toInt() ?? 0,
      descricao: data['descricao'] as String?,
      lastSynced: DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': statusId,
      'descricao': descricao,
    };
  }
}

/// Entidade TipoAcao para armazenamento local
/// Tabela de referência - sincroniza com coleção 'tipo_acoes'
@Entity()
class TipoAcaoEntity {
  @Id()
  int id = 0;

  @Unique()
  String? firestoreId;

  String? descricao;

  @Property(type: PropertyType.date)
  DateTime? lastSynced;

  TipoAcaoEntity({
    this.firestoreId,
    this.descricao,
    this.lastSynced,
  });

  factory TipoAcaoEntity.fromFirestore(
      Map<String, dynamic> data, String docId) {
    return TipoAcaoEntity(
      firestoreId: docId,
      descricao: data['descricao'] as String?,
      lastSynced: DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'descricao': descricao};
  }
}

/// Entidade CalendarioSanitario para armazenamento local
/// Tabela de referência - sincroniza com coleção 'calendario_sanitario'
@Entity()
class CalendarioSanitarioEntity {
  @Id()
  int id = 0;

  @Unique()
  String? firestoreId;

  String? descricao;
  String? tipo;

  @Property(type: PropertyType.date)
  DateTime? lastSynced;

  CalendarioSanitarioEntity({
    this.firestoreId,
    this.descricao,
    this.tipo,
    this.lastSynced,
  });

  factory CalendarioSanitarioEntity.fromFirestore(
      Map<String, dynamic> data, String docId) {
    return CalendarioSanitarioEntity(
      firestoreId: docId,
      descricao: data['descricao'] as String?,
      tipo: data['tipo'] as String?,
      lastSynced: DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'descricao': descricao,
      'tipo': tipo,
    };
  }
}

/// Entidade Cidade para armazenamento local
/// Tabela de referência - sincroniza com coleção 'cidades'
@Entity()
class CidadeEntity {
  @Id()
  int id = 0;

  @Unique()
  String? firestoreId;

  String? nome;
  String? nomeuf;

  @Property(type: PropertyType.date)
  DateTime? lastSynced;

  CidadeEntity({
    this.firestoreId,
    this.nome,
    this.nomeuf,
    this.lastSynced,
  });

  factory CidadeEntity.fromFirestore(Map<String, dynamic> data, String docId) {
    return CidadeEntity(
      firestoreId: docId,
      nome: data['nome'] as String?,
      nomeuf: data['nomeuf'] as String?,
      lastSynced: DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'nomeuf': nomeuf,
    };
  }
}
