// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class GrupoStruct extends FFFirebaseStruct {
  GrupoStruct({
    String? descricao,
    int? id,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _descricao = descricao,
        _id = id,
        super(firestoreUtilData);

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  set descricao(String? val) => _descricao = val;

  bool hasDescricao() => _descricao != null;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  static GrupoStruct fromMap(Map<String, dynamic> data) => GrupoStruct(
        descricao: data['descricao'] as String?,
        id: castToType<int>(data['id']),
      );

  static GrupoStruct? maybeFromMap(dynamic data) =>
      data is Map ? GrupoStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'descricao': _descricao,
        'id': _id,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'descricao': serializeParam(
          _descricao,
          ParamType.String,
        ),
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
      }.withoutNulls;

  static GrupoStruct fromSerializableMap(Map<String, dynamic> data) =>
      GrupoStruct(
        descricao: deserializeParam(
          data['descricao'],
          ParamType.String,
          false,
        ),
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'GrupoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is GrupoStruct &&
        descricao == other.descricao &&
        id == other.id;
  }

  @override
  int get hashCode => const ListEquality().hash([descricao, id]);
}

GrupoStruct createGrupoStruct({
  String? descricao,
  int? id,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    GrupoStruct(
      descricao: descricao,
      id: id,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

GrupoStruct? updateGrupoStruct(
  GrupoStruct? grupo, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    grupo
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addGrupoStructData(
  Map<String, dynamic> firestoreData,
  GrupoStruct? grupo,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (grupo == null) {
    return;
  }
  if (grupo.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && grupo.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final grupoData = getGrupoFirestoreData(grupo, forFieldValue);
  final nestedData = grupoData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = grupo.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getGrupoFirestoreData(
  GrupoStruct? grupo, [
  bool forFieldValue = false,
]) {
  if (grupo == null) {
    return {};
  }
  final firestoreData = mapToFirestore(grupo.toMap());

  // Add any Firestore field values
  grupo.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getGrupoListFirestoreData(
  List<GrupoStruct>? grupos,
) =>
    grupos?.map((e) => getGrupoFirestoreData(e, true)).toList() ?? [];
