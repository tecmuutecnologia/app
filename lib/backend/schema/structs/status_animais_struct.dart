// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class StatusAnimaisStruct extends FFFirebaseStruct {
  StatusAnimaisStruct({
    int? id,
    String? descricao,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _descricao = descricao,
        super(firestoreUtilData);

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  set descricao(String? val) => _descricao = val;

  bool hasDescricao() => _descricao != null;

  static StatusAnimaisStruct fromMap(Map<String, dynamic> data) =>
      StatusAnimaisStruct(
        id: castToType<int>(data['id']),
        descricao: data['descricao'] as String?,
      );

  static StatusAnimaisStruct? maybeFromMap(dynamic data) => data is Map
      ? StatusAnimaisStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'descricao': _descricao,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'descricao': serializeParam(
          _descricao,
          ParamType.String,
        ),
      }.withoutNulls;

  static StatusAnimaisStruct fromSerializableMap(Map<String, dynamic> data) =>
      StatusAnimaisStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        descricao: deserializeParam(
          data['descricao'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'StatusAnimaisStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is StatusAnimaisStruct &&
        id == other.id &&
        descricao == other.descricao;
  }

  @override
  int get hashCode => const ListEquality().hash([id, descricao]);
}

StatusAnimaisStruct createStatusAnimaisStruct({
  int? id,
  String? descricao,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    StatusAnimaisStruct(
      id: id,
      descricao: descricao,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

StatusAnimaisStruct? updateStatusAnimaisStruct(
  StatusAnimaisStruct? statusAnimais, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    statusAnimais
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addStatusAnimaisStructData(
  Map<String, dynamic> firestoreData,
  StatusAnimaisStruct? statusAnimais,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (statusAnimais == null) {
    return;
  }
  if (statusAnimais.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && statusAnimais.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final statusAnimaisData =
      getStatusAnimaisFirestoreData(statusAnimais, forFieldValue);
  final nestedData =
      statusAnimaisData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = statusAnimais.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getStatusAnimaisFirestoreData(
  StatusAnimaisStruct? statusAnimais, [
  bool forFieldValue = false,
]) {
  if (statusAnimais == null) {
    return {};
  }
  final firestoreData = mapToFirestore(statusAnimais.toMap());

  // Add any Firestore field values
  statusAnimais.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getStatusAnimaisListFirestoreData(
  List<StatusAnimaisStruct>? statusAnimaiss,
) =>
    statusAnimaiss
        ?.map((e) => getStatusAnimaisFirestoreData(e, true))
        .toList() ??
    [];
