// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class CidadesStruct extends FFFirebaseStruct {
  CidadesStruct({
    String? nome,
    String? nomeuf,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _nome = nome,
        _nomeuf = nomeuf,
        super(firestoreUtilData);

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "nomeuf" field.
  String? _nomeuf;
  String get nomeuf => _nomeuf ?? '';
  set nomeuf(String? val) => _nomeuf = val;

  bool hasNomeuf() => _nomeuf != null;

  static CidadesStruct fromMap(Map<String, dynamic> data) => CidadesStruct(
        nome: data['nome'] as String?,
        nomeuf: data['nomeuf'] as String?,
      );

  static CidadesStruct? maybeFromMap(dynamic data) =>
      data is Map ? CidadesStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'nomeuf': _nomeuf,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'nomeuf': serializeParam(
          _nomeuf,
          ParamType.String,
        ),
      }.withoutNulls;

  static CidadesStruct fromSerializableMap(Map<String, dynamic> data) =>
      CidadesStruct(
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        nomeuf: deserializeParam(
          data['nomeuf'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CidadesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CidadesStruct &&
        nome == other.nome &&
        nomeuf == other.nomeuf;
  }

  @override
  int get hashCode => const ListEquality().hash([nome, nomeuf]);
}

CidadesStruct createCidadesStruct({
  String? nome,
  String? nomeuf,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CidadesStruct(
      nome: nome,
      nomeuf: nomeuf,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CidadesStruct? updateCidadesStruct(
  CidadesStruct? cidades, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    cidades
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCidadesStructData(
  Map<String, dynamic> firestoreData,
  CidadesStruct? cidades,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (cidades == null) {
    return;
  }
  if (cidades.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && cidades.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final cidadesData = getCidadesFirestoreData(cidades, forFieldValue);
  final nestedData = cidadesData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = cidades.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCidadesFirestoreData(
  CidadesStruct? cidades, [
  bool forFieldValue = false,
]) {
  if (cidades == null) {
    return {};
  }
  final firestoreData = mapToFirestore(cidades.toMap());

  // Add any Firestore field values
  cidades.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCidadesListFirestoreData(
  List<CidadesStruct>? cidadess,
) =>
    cidadess?.map((e) => getCidadesFirestoreData(e, true)).toList() ?? [];
