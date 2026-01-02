// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class TipoAcoesStruct extends FFFirebaseStruct {
  TipoAcoesStruct({
    String? descricao,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _descricao = descricao,
        super(firestoreUtilData);

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  set descricao(String? val) => _descricao = val;

  bool hasDescricao() => _descricao != null;

  static TipoAcoesStruct fromMap(Map<String, dynamic> data) => TipoAcoesStruct(
        descricao: data['descricao'] as String?,
      );

  static TipoAcoesStruct? maybeFromMap(dynamic data) => data is Map
      ? TipoAcoesStruct.fromMap(data.cast<String, dynamic>())
      : null;

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

  static TipoAcoesStruct fromSerializableMap(Map<String, dynamic> data) =>
      TipoAcoesStruct(
        descricao: deserializeParam(
          data['descricao'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'TipoAcoesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TipoAcoesStruct && descricao == other.descricao;
  }

  @override
  int get hashCode => const ListEquality().hash([descricao]);
}

TipoAcoesStruct createTipoAcoesStruct({
  String? descricao,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    TipoAcoesStruct(
      descricao: descricao,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

TipoAcoesStruct? updateTipoAcoesStruct(
  TipoAcoesStruct? tipoAcoes, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    tipoAcoes
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addTipoAcoesStructData(
  Map<String, dynamic> firestoreData,
  TipoAcoesStruct? tipoAcoes,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (tipoAcoes == null) {
    return;
  }
  if (tipoAcoes.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && tipoAcoes.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final tipoAcoesData = getTipoAcoesFirestoreData(tipoAcoes, forFieldValue);
  final nestedData = tipoAcoesData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = tipoAcoes.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getTipoAcoesFirestoreData(
  TipoAcoesStruct? tipoAcoes, [
  bool forFieldValue = false,
]) {
  if (tipoAcoes == null) {
    return {};
  }
  final firestoreData = mapToFirestore(tipoAcoes.toMap());

  // Add any Firestore field values
  tipoAcoes.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getTipoAcoesListFirestoreData(
  List<TipoAcoesStruct>? tipoAcoess,
) =>
    tipoAcoess?.map((e) => getTipoAcoesFirestoreData(e, true)).toList() ?? [];
