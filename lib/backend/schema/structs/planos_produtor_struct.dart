// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class PlanosProdutorStruct extends FFFirebaseStruct {
  PlanosProdutorStruct({
    String? nome,
    String? descricao,
    String? preco,
    int? limiteAnimais,
    double? precotest,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _nome = nome,
        _descricao = descricao,
        _preco = preco,
        _limiteAnimais = limiteAnimais,
        _precotest = precotest,
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

  // "preco" field.
  String? _preco;
  String get preco => _preco ?? '';
  set preco(String? val) => _preco = val;

  bool hasPreco() => _preco != null;

  // "limiteAnimais" field.
  int? _limiteAnimais;
  int get limiteAnimais => _limiteAnimais ?? 0;
  set limiteAnimais(int? val) => _limiteAnimais = val;

  void incrementLimiteAnimais(int amount) =>
      limiteAnimais = limiteAnimais + amount;

  bool hasLimiteAnimais() => _limiteAnimais != null;

  // "precotest" field.
  double? _precotest;
  double get precotest => _precotest ?? 0.0;
  set precotest(double? val) => _precotest = val;

  void incrementPrecotest(double amount) => precotest = precotest + amount;

  bool hasPrecotest() => _precotest != null;

  static PlanosProdutorStruct fromMap(Map<String, dynamic> data) =>
      PlanosProdutorStruct(
        nome: data['nome'] as String?,
        descricao: data['descricao'] as String?,
        preco: data['preco'] as String?,
        limiteAnimais: castToType<int>(data['limiteAnimais']),
        precotest: castToType<double>(data['precotest']),
      );

  static PlanosProdutorStruct? maybeFromMap(dynamic data) => data is Map
      ? PlanosProdutorStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'descricao': _descricao,
        'preco': _preco,
        'limiteAnimais': _limiteAnimais,
        'precotest': _precotest,
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
        'preco': serializeParam(
          _preco,
          ParamType.String,
        ),
        'limiteAnimais': serializeParam(
          _limiteAnimais,
          ParamType.int,
        ),
        'precotest': serializeParam(
          _precotest,
          ParamType.double,
        ),
      }.withoutNulls;

  static PlanosProdutorStruct fromSerializableMap(Map<String, dynamic> data) =>
      PlanosProdutorStruct(
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
        preco: deserializeParam(
          data['preco'],
          ParamType.String,
          false,
        ),
        limiteAnimais: deserializeParam(
          data['limiteAnimais'],
          ParamType.int,
          false,
        ),
        precotest: deserializeParam(
          data['precotest'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'PlanosProdutorStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PlanosProdutorStruct &&
        nome == other.nome &&
        descricao == other.descricao &&
        preco == other.preco &&
        limiteAnimais == other.limiteAnimais &&
        precotest == other.precotest;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([nome, descricao, preco, limiteAnimais, precotest]);
}

PlanosProdutorStruct createPlanosProdutorStruct({
  String? nome,
  String? descricao,
  String? preco,
  int? limiteAnimais,
  double? precotest,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PlanosProdutorStruct(
      nome: nome,
      descricao: descricao,
      preco: preco,
      limiteAnimais: limiteAnimais,
      precotest: precotest,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PlanosProdutorStruct? updatePlanosProdutorStruct(
  PlanosProdutorStruct? planosProdutor, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    planosProdutor
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPlanosProdutorStructData(
  Map<String, dynamic> firestoreData,
  PlanosProdutorStruct? planosProdutor,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (planosProdutor == null) {
    return;
  }
  if (planosProdutor.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && planosProdutor.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final planosProdutorData =
      getPlanosProdutorFirestoreData(planosProdutor, forFieldValue);
  final nestedData =
      planosProdutorData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = planosProdutor.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPlanosProdutorFirestoreData(
  PlanosProdutorStruct? planosProdutor, [
  bool forFieldValue = false,
]) {
  if (planosProdutor == null) {
    return {};
  }
  final firestoreData = mapToFirestore(planosProdutor.toMap());

  // Add any Firestore field values
  planosProdutor.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPlanosProdutorListFirestoreData(
  List<PlanosProdutorStruct>? planosProdutors,
) =>
    planosProdutors
        ?.map((e) => getPlanosProdutorFirestoreData(e, true))
        .toList() ??
    [];
