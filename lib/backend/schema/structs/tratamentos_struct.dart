// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class TratamentosStruct extends FFFirebaseStruct {
  TratamentosStruct({
    DocumentReference? uidAnimal,
    String? tipoAcao,
    String? observacaoAcao,
    String? brincoAnimal,
    String? nomeAnimal,
    String? grupoAnimal,
    DocumentReference? uidPropriedade,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _uidAnimal = uidAnimal,
        _tipoAcao = tipoAcao,
        _observacaoAcao = observacaoAcao,
        _brincoAnimal = brincoAnimal,
        _nomeAnimal = nomeAnimal,
        _grupoAnimal = grupoAnimal,
        _uidPropriedade = uidPropriedade,
        super(firestoreUtilData);

  // "uidAnimal" field.
  DocumentReference? _uidAnimal;
  DocumentReference? get uidAnimal => _uidAnimal;
  set uidAnimal(DocumentReference? val) => _uidAnimal = val;

  bool hasUidAnimal() => _uidAnimal != null;

  // "tipoAcao" field.
  String? _tipoAcao;
  String get tipoAcao => _tipoAcao ?? '';
  set tipoAcao(String? val) => _tipoAcao = val;

  bool hasTipoAcao() => _tipoAcao != null;

  // "observacaoAcao" field.
  String? _observacaoAcao;
  String get observacaoAcao => _observacaoAcao ?? '';
  set observacaoAcao(String? val) => _observacaoAcao = val;

  bool hasObservacaoAcao() => _observacaoAcao != null;

  // "brincoAnimal" field.
  String? _brincoAnimal;
  String get brincoAnimal => _brincoAnimal ?? '';
  set brincoAnimal(String? val) => _brincoAnimal = val;

  bool hasBrincoAnimal() => _brincoAnimal != null;

  // "nomeAnimal" field.
  String? _nomeAnimal;
  String get nomeAnimal => _nomeAnimal ?? '';
  set nomeAnimal(String? val) => _nomeAnimal = val;

  bool hasNomeAnimal() => _nomeAnimal != null;

  // "grupoAnimal" field.
  String? _grupoAnimal;
  String get grupoAnimal => _grupoAnimal ?? '';
  set grupoAnimal(String? val) => _grupoAnimal = val;

  bool hasGrupoAnimal() => _grupoAnimal != null;

  // "uidPropriedade" field.
  DocumentReference? _uidPropriedade;
  DocumentReference? get uidPropriedade => _uidPropriedade;
  set uidPropriedade(DocumentReference? val) => _uidPropriedade = val;

  bool hasUidPropriedade() => _uidPropriedade != null;

  static TratamentosStruct fromMap(Map<String, dynamic> data) =>
      TratamentosStruct(
        uidAnimal: data['uidAnimal'] as DocumentReference?,
        tipoAcao: data['tipoAcao'] as String?,
        observacaoAcao: data['observacaoAcao'] as String?,
        brincoAnimal: data['brincoAnimal'] as String?,
        nomeAnimal: data['nomeAnimal'] as String?,
        grupoAnimal: data['grupoAnimal'] as String?,
        uidPropriedade: data['uidPropriedade'] as DocumentReference?,
      );

  static TratamentosStruct? maybeFromMap(dynamic data) => data is Map
      ? TratamentosStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'uidAnimal': _uidAnimal,
        'tipoAcao': _tipoAcao,
        'observacaoAcao': _observacaoAcao,
        'brincoAnimal': _brincoAnimal,
        'nomeAnimal': _nomeAnimal,
        'grupoAnimal': _grupoAnimal,
        'uidPropriedade': _uidPropriedade,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'uidAnimal': serializeParam(
          _uidAnimal,
          ParamType.DocumentReference,
        ),
        'tipoAcao': serializeParam(
          _tipoAcao,
          ParamType.String,
        ),
        'observacaoAcao': serializeParam(
          _observacaoAcao,
          ParamType.String,
        ),
        'brincoAnimal': serializeParam(
          _brincoAnimal,
          ParamType.String,
        ),
        'nomeAnimal': serializeParam(
          _nomeAnimal,
          ParamType.String,
        ),
        'grupoAnimal': serializeParam(
          _grupoAnimal,
          ParamType.String,
        ),
        'uidPropriedade': serializeParam(
          _uidPropriedade,
          ParamType.DocumentReference,
        ),
      }.withoutNulls;

  static TratamentosStruct fromSerializableMap(Map<String, dynamic> data) =>
      TratamentosStruct(
        uidAnimal: deserializeParam(
          data['uidAnimal'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['tecnico', 'animaisProdutores'],
        ),
        tipoAcao: deserializeParam(
          data['tipoAcao'],
          ParamType.String,
          false,
        ),
        observacaoAcao: deserializeParam(
          data['observacaoAcao'],
          ParamType.String,
          false,
        ),
        brincoAnimal: deserializeParam(
          data['brincoAnimal'],
          ParamType.String,
          false,
        ),
        nomeAnimal: deserializeParam(
          data['nomeAnimal'],
          ParamType.String,
          false,
        ),
        grupoAnimal: deserializeParam(
          data['grupoAnimal'],
          ParamType.String,
          false,
        ),
        uidPropriedade: deserializeParam(
          data['uidPropriedade'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['tecnico', 'propriedades'],
        ),
      );

  @override
  String toString() => 'TratamentosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TratamentosStruct &&
        uidAnimal == other.uidAnimal &&
        tipoAcao == other.tipoAcao &&
        observacaoAcao == other.observacaoAcao &&
        brincoAnimal == other.brincoAnimal &&
        nomeAnimal == other.nomeAnimal &&
        grupoAnimal == other.grupoAnimal &&
        uidPropriedade == other.uidPropriedade;
  }

  @override
  int get hashCode => const ListEquality().hash([
        uidAnimal,
        tipoAcao,
        observacaoAcao,
        brincoAnimal,
        nomeAnimal,
        grupoAnimal,
        uidPropriedade
      ]);
}

TratamentosStruct createTratamentosStruct({
  DocumentReference? uidAnimal,
  String? tipoAcao,
  String? observacaoAcao,
  String? brincoAnimal,
  String? nomeAnimal,
  String? grupoAnimal,
  DocumentReference? uidPropriedade,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    TratamentosStruct(
      uidAnimal: uidAnimal,
      tipoAcao: tipoAcao,
      observacaoAcao: observacaoAcao,
      brincoAnimal: brincoAnimal,
      nomeAnimal: nomeAnimal,
      grupoAnimal: grupoAnimal,
      uidPropriedade: uidPropriedade,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

TratamentosStruct? updateTratamentosStruct(
  TratamentosStruct? tratamentos, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    tratamentos
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addTratamentosStructData(
  Map<String, dynamic> firestoreData,
  TratamentosStruct? tratamentos,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (tratamentos == null) {
    return;
  }
  if (tratamentos.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && tratamentos.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final tratamentosData =
      getTratamentosFirestoreData(tratamentos, forFieldValue);
  final nestedData =
      tratamentosData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = tratamentos.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getTratamentosFirestoreData(
  TratamentosStruct? tratamentos, [
  bool forFieldValue = false,
]) {
  if (tratamentos == null) {
    return {};
  }
  final firestoreData = mapToFirestore(tratamentos.toMap());

  // Add any Firestore field values
  tratamentos.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getTratamentosListFirestoreData(
  List<TratamentosStruct>? tratamentoss,
) =>
    tratamentoss?.map((e) => getTratamentosFirestoreData(e, true)).toList() ??
    [];
