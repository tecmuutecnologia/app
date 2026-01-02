// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class AnimaisApagadosExistentesOfflineStruct extends FFFirebaseStruct {
  AnimaisApagadosExistentesOfflineStruct({
    DocumentReference? uidAnimal,
    DocumentReference? uidTecnicoPropriedade,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _uidAnimal = uidAnimal,
        _uidTecnicoPropriedade = uidTecnicoPropriedade,
        super(firestoreUtilData);

  // "uidAnimal" field.
  DocumentReference? _uidAnimal;
  DocumentReference? get uidAnimal => _uidAnimal;
  set uidAnimal(DocumentReference? val) => _uidAnimal = val;

  bool hasUidAnimal() => _uidAnimal != null;

  // "uidTecnicoPropriedade" field.
  DocumentReference? _uidTecnicoPropriedade;
  DocumentReference? get uidTecnicoPropriedade => _uidTecnicoPropriedade;
  set uidTecnicoPropriedade(DocumentReference? val) =>
      _uidTecnicoPropriedade = val;

  bool hasUidTecnicoPropriedade() => _uidTecnicoPropriedade != null;

  static AnimaisApagadosExistentesOfflineStruct fromMap(
          Map<String, dynamic> data) =>
      AnimaisApagadosExistentesOfflineStruct(
        uidAnimal: data['uidAnimal'] as DocumentReference?,
        uidTecnicoPropriedade:
            data['uidTecnicoPropriedade'] as DocumentReference?,
      );

  static AnimaisApagadosExistentesOfflineStruct? maybeFromMap(dynamic data) =>
      data is Map
          ? AnimaisApagadosExistentesOfflineStruct.fromMap(
              data.cast<String, dynamic>())
          : null;

  Map<String, dynamic> toMap() => {
        'uidAnimal': _uidAnimal,
        'uidTecnicoPropriedade': _uidTecnicoPropriedade,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'uidAnimal': serializeParam(
          _uidAnimal,
          ParamType.DocumentReference,
        ),
        'uidTecnicoPropriedade': serializeParam(
          _uidTecnicoPropriedade,
          ParamType.DocumentReference,
        ),
      }.withoutNulls;

  static AnimaisApagadosExistentesOfflineStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      AnimaisApagadosExistentesOfflineStruct(
        uidAnimal: deserializeParam(
          data['uidAnimal'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['tecnico', 'animaisProdutores'],
        ),
        uidTecnicoPropriedade: deserializeParam(
          data['uidTecnicoPropriedade'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['tecnico', 'propriedades'],
        ),
      );

  @override
  String toString() => 'AnimaisApagadosExistentesOfflineStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AnimaisApagadosExistentesOfflineStruct &&
        uidAnimal == other.uidAnimal &&
        uidTecnicoPropriedade == other.uidTecnicoPropriedade;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([uidAnimal, uidTecnicoPropriedade]);
}

AnimaisApagadosExistentesOfflineStruct
    createAnimaisApagadosExistentesOfflineStruct({
  DocumentReference? uidAnimal,
  DocumentReference? uidTecnicoPropriedade,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
        AnimaisApagadosExistentesOfflineStruct(
          uidAnimal: uidAnimal,
          uidTecnicoPropriedade: uidTecnicoPropriedade,
          firestoreUtilData: FirestoreUtilData(
            clearUnsetFields: clearUnsetFields,
            create: create,
            delete: delete,
            fieldValues: fieldValues,
          ),
        );

AnimaisApagadosExistentesOfflineStruct?
    updateAnimaisApagadosExistentesOfflineStruct(
  AnimaisApagadosExistentesOfflineStruct? animaisApagadosExistentesOffline, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
        animaisApagadosExistentesOffline
          ?..firestoreUtilData = FirestoreUtilData(
            clearUnsetFields: clearUnsetFields,
            create: create,
          );

void addAnimaisApagadosExistentesOfflineStructData(
  Map<String, dynamic> firestoreData,
  AnimaisApagadosExistentesOfflineStruct? animaisApagadosExistentesOffline,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (animaisApagadosExistentesOffline == null) {
    return;
  }
  if (animaisApagadosExistentesOffline.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      animaisApagadosExistentesOffline.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final animaisApagadosExistentesOfflineData =
      getAnimaisApagadosExistentesOfflineFirestoreData(
          animaisApagadosExistentesOffline, forFieldValue);
  final nestedData = animaisApagadosExistentesOfflineData
      .map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      animaisApagadosExistentesOffline.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAnimaisApagadosExistentesOfflineFirestoreData(
  AnimaisApagadosExistentesOfflineStruct? animaisApagadosExistentesOffline, [
  bool forFieldValue = false,
]) {
  if (animaisApagadosExistentesOffline == null) {
    return {};
  }
  final firestoreData =
      mapToFirestore(animaisApagadosExistentesOffline.toMap());

  // Add any Firestore field values
  animaisApagadosExistentesOffline.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAnimaisApagadosExistentesOfflineListFirestoreData(
  List<AnimaisApagadosExistentesOfflineStruct>?
      animaisApagadosExistentesOfflines,
) =>
    animaisApagadosExistentesOfflines
        ?.map((e) => getAnimaisApagadosExistentesOfflineFirestoreData(e, true))
        .toList() ??
    [];
