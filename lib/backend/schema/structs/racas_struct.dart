// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class RacasStruct extends FFFirebaseStruct {
  RacasStruct({
    String? descricao,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _descricao = descricao,
        super(firestoreUtilData);

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  set descricao(String? val) => _descricao = val;

  bool hasDescricao() => _descricao != null;

  static RacasStruct fromMap(Map<String, dynamic> data) => RacasStruct(
        descricao: data['descricao'] as String?,
      );

  static RacasStruct? maybeFromMap(dynamic data) =>
      data is Map ? RacasStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'descricao': _descricao,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'descricao': serializeParam(
          _descricao,
          ParamType.String,
        ),
      }.withoutNulls;

  static RacasStruct fromSerializableMap(Map<String, dynamic> data) =>
      RacasStruct(
        descricao: deserializeParam(
          data['descricao'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'RacasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RacasStruct && descricao == other.descricao;
  }

  @override
  int get hashCode => const ListEquality().hash([descricao]);
}

RacasStruct createRacasStruct({
  String? descricao,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    RacasStruct(
      descricao: descricao,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

RacasStruct? updateRacasStruct(
  RacasStruct? racas, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    racas
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addRacasStructData(
  Map<String, dynamic> firestoreData,
  RacasStruct? racas,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (racas == null) {
    return;
  }
  if (racas.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && racas.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final racasData = getRacasFirestoreData(racas, forFieldValue);
  final nestedData = racasData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = racas.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getRacasFirestoreData(
  RacasStruct? racas, [
  bool forFieldValue = false,
]) {
  if (racas == null) {
    return {};
  }
  final firestoreData = mapToFirestore(racas.toMap());

  // Add any Firestore field values
  racas.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getRacasListFirestoreData(
  List<RacasStruct>? racass,
) =>
    racass?.map((e) => getRacasFirestoreData(e, true)).toList() ?? [];
