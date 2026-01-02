// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class PlanosTecnicosStruct extends FFFirebaseStruct {
  PlanosTecnicosStruct({
    String? nome,
    String? descricao,
    int? limiteAnimais,
    int? limitePropriedade,
    double? preco,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _nome = nome,
        _descricao = descricao,
        _limiteAnimais = limiteAnimais,
        _limitePropriedade = limitePropriedade,
        _preco = preco,
        super(firestoreUtilData);

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  set descricao(String? val) => _descricao = val;

  bool hasDescricao() => _descricao != null;

  // "limiteAnimais" field.
  int? _limiteAnimais;
  int get limiteAnimais => _limiteAnimais ?? 0;
  set limiteAnimais(int? val) => _limiteAnimais = val;

  void incrementLimiteAnimais(int amount) =>
      limiteAnimais = limiteAnimais + amount;

  bool hasLimiteAnimais() => _limiteAnimais != null;

  // "limitePropriedade" field.
  int? _limitePropriedade;
  int get limitePropriedade => _limitePropriedade ?? 0;
  set limitePropriedade(int? val) => _limitePropriedade = val;

  void incrementLimitePropriedade(int amount) =>
      limitePropriedade = limitePropriedade + amount;

  bool hasLimitePropriedade() => _limitePropriedade != null;

  // "preco" field.
  double? _preco;
  double get preco => _preco ?? 0.0;
  set preco(double? val) => _preco = val;

  void incrementPreco(double amount) => preco = preco + amount;

  bool hasPreco() => _preco != null;

  static PlanosTecnicosStruct fromMap(Map<String, dynamic> data) =>
      PlanosTecnicosStruct(
        nome: data['nome'] as String?,
        descricao: data['descricao'] as String?,
        limiteAnimais: castToType<int>(data['limiteAnimais']),
        limitePropriedade: castToType<int>(data['limitePropriedade']),
        preco: castToType<double>(data['preco']),
      );

  static PlanosTecnicosStruct? maybeFromMap(dynamic data) => data is Map
      ? PlanosTecnicosStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'descricao': _descricao,
        'limiteAnimais': _limiteAnimais,
        'limitePropriedade': _limitePropriedade,
        'preco': _preco,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'descricao': serializeParam(
          _descricao,
          ParamType.String,
        ),
        'limiteAnimais': serializeParam(
          _limiteAnimais,
          ParamType.int,
        ),
        'limitePropriedade': serializeParam(
          _limitePropriedade,
          ParamType.int,
        ),
        'preco': serializeParam(
          _preco,
          ParamType.double,
        ),
      }.withoutNulls;

  static PlanosTecnicosStruct fromSerializableMap(Map<String, dynamic> data) =>
      PlanosTecnicosStruct(
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        descricao: deserializeParam(
          data['descricao'],
          ParamType.String,
          false,
        ),
        limiteAnimais: deserializeParam(
          data['limiteAnimais'],
          ParamType.int,
          false,
        ),
        limitePropriedade: deserializeParam(
          data['limitePropriedade'],
          ParamType.int,
          false,
        ),
        preco: deserializeParam(
          data['preco'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'PlanosTecnicosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PlanosTecnicosStruct &&
        nome == other.nome &&
        descricao == other.descricao &&
        limiteAnimais == other.limiteAnimais &&
        limitePropriedade == other.limitePropriedade &&
        preco == other.preco;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([nome, descricao, limiteAnimais, limitePropriedade, preco]);
}

PlanosTecnicosStruct createPlanosTecnicosStruct({
  String? nome,
  String? descricao,
  int? limiteAnimais,
  int? limitePropriedade,
  double? preco,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PlanosTecnicosStruct(
      nome: nome,
      descricao: descricao,
      limiteAnimais: limiteAnimais,
      limitePropriedade: limitePropriedade,
      preco: preco,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PlanosTecnicosStruct? updatePlanosTecnicosStruct(
  PlanosTecnicosStruct? planosTecnicos, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    planosTecnicos
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPlanosTecnicosStructData(
  Map<String, dynamic> firestoreData,
  PlanosTecnicosStruct? planosTecnicos,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (planosTecnicos == null) {
    return;
  }
  if (planosTecnicos.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && planosTecnicos.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final planosTecnicosData =
      getPlanosTecnicosFirestoreData(planosTecnicos, forFieldValue);
  final nestedData =
      planosTecnicosData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = planosTecnicos.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPlanosTecnicosFirestoreData(
  PlanosTecnicosStruct? planosTecnicos, [
  bool forFieldValue = false,
]) {
  if (planosTecnicos == null) {
    return {};
  }
  final firestoreData = mapToFirestore(planosTecnicos.toMap());

  // Add any Firestore field values
  planosTecnicos.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPlanosTecnicosListFirestoreData(
  List<PlanosTecnicosStruct>? planosTecnicoss,
) =>
    planosTecnicoss
        ?.map((e) => getPlanosTecnicosFirestoreData(e, true))
        .toList() ??
    [];
