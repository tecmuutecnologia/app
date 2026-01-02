// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class AcoesSanitarioStruct extends FFFirebaseStruct {
  AcoesSanitarioStruct({
    DocumentReference? uidAnimalAnimaisProdutores,
    DocumentReference? uidPersonProdutor,
    String? obsVisita,
    String? tipoAcao,
    String? acao,
    DocumentReference? uidPropriedade,
    String? dtAcao,
    String? nomeAnimal,
    String? brincoAnimal,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _uidAnimalAnimaisProdutores = uidAnimalAnimaisProdutores,
        _uidPersonProdutor = uidPersonProdutor,
        _obsVisita = obsVisita,
        _tipoAcao = tipoAcao,
        _acao = acao,
        _uidPropriedade = uidPropriedade,
        _dtAcao = dtAcao,
        _nomeAnimal = nomeAnimal,
        _brincoAnimal = brincoAnimal,
        super(firestoreUtilData);

  // "uidAnimalAnimaisProdutores" field.
  DocumentReference? _uidAnimalAnimaisProdutores;
  DocumentReference? get uidAnimalAnimaisProdutores =>
      _uidAnimalAnimaisProdutores;
  set uidAnimalAnimaisProdutores(DocumentReference? val) =>
      _uidAnimalAnimaisProdutores = val;

  bool hasUidAnimalAnimaisProdutores() => _uidAnimalAnimaisProdutores != null;

  // "uidPersonProdutor" field.
  DocumentReference? _uidPersonProdutor;
  DocumentReference? get uidPersonProdutor => _uidPersonProdutor;
  set uidPersonProdutor(DocumentReference? val) => _uidPersonProdutor = val;

  bool hasUidPersonProdutor() => _uidPersonProdutor != null;

  // "obsVisita" field.
  String? _obsVisita;
  String get obsVisita => _obsVisita ?? '';
  set obsVisita(String? val) => _obsVisita = val;

  bool hasObsVisita() => _obsVisita != null;

  // "tipoAcao" field.
  String? _tipoAcao;
  String get tipoAcao => _tipoAcao ?? '';
  set tipoAcao(String? val) => _tipoAcao = val;

  bool hasTipoAcao() => _tipoAcao != null;

  // "acao" field.
  String? _acao;
  String get acao => _acao ?? '';
  set acao(String? val) => _acao = val;

  bool hasAcao() => _acao != null;

  // "uidPropriedade" field.
  DocumentReference? _uidPropriedade;
  DocumentReference? get uidPropriedade => _uidPropriedade;
  set uidPropriedade(DocumentReference? val) => _uidPropriedade = val;

  bool hasUidPropriedade() => _uidPropriedade != null;

  // "dtAcao" field.
  String? _dtAcao;
  String get dtAcao => _dtAcao ?? '';
  set dtAcao(String? val) => _dtAcao = val;

  bool hasDtAcao() => _dtAcao != null;

  // "nomeAnimal" field.
  String? _nomeAnimal;
  String get nomeAnimal => _nomeAnimal ?? '';
  set nomeAnimal(String? val) => _nomeAnimal = val;

  bool hasNomeAnimal() => _nomeAnimal != null;

  // "brincoAnimal" field.
  String? _brincoAnimal;
  String get brincoAnimal => _brincoAnimal ?? '';
  set brincoAnimal(String? val) => _brincoAnimal = val;

  bool hasBrincoAnimal() => _brincoAnimal != null;

  static AcoesSanitarioStruct fromMap(Map<String, dynamic> data) =>
      AcoesSanitarioStruct(
        uidAnimalAnimaisProdutores:
            data['uidAnimalAnimaisProdutores'] as DocumentReference?,
        uidPersonProdutor: data['uidPersonProdutor'] as DocumentReference?,
        obsVisita: data['obsVisita'] as String?,
        tipoAcao: data['tipoAcao'] as String?,
        acao: data['acao'] as String?,
        uidPropriedade: data['uidPropriedade'] as DocumentReference?,
        dtAcao: data['dtAcao'] as String?,
        nomeAnimal: data['nomeAnimal'] as String?,
        brincoAnimal: data['brincoAnimal'] as String?,
      );

  static AcoesSanitarioStruct? maybeFromMap(dynamic data) => data is Map
      ? AcoesSanitarioStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'uidAnimalAnimaisProdutores': _uidAnimalAnimaisProdutores,
        'uidPersonProdutor': _uidPersonProdutor,
        'obsVisita': _obsVisita,
        'tipoAcao': _tipoAcao,
        'acao': _acao,
        'uidPropriedade': _uidPropriedade,
        'dtAcao': _dtAcao,
        'nomeAnimal': _nomeAnimal,
        'brincoAnimal': _brincoAnimal,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'uidAnimalAnimaisProdutores': serializeParam(
          _uidAnimalAnimaisProdutores,
          ParamType.DocumentReference,
        ),
        'uidPersonProdutor': serializeParam(
          _uidPersonProdutor,
          ParamType.DocumentReference,
        ),
        'obsVisita': serializeParam(
          _obsVisita,
          ParamType.String,
        ),
        'tipoAcao': serializeParam(
          _tipoAcao,
          ParamType.String,
        ),
        'acao': serializeParam(
          _acao,
          ParamType.String,
        ),
        'uidPropriedade': serializeParam(
          _uidPropriedade,
          ParamType.DocumentReference,
        ),
        'dtAcao': serializeParam(
          _dtAcao,
          ParamType.String,
        ),
        'nomeAnimal': serializeParam(
          _nomeAnimal,
          ParamType.String,
        ),
        'brincoAnimal': serializeParam(
          _brincoAnimal,
          ParamType.String,
        ),
      }.withoutNulls;

  static AcoesSanitarioStruct fromSerializableMap(Map<String, dynamic> data) =>
      AcoesSanitarioStruct(
        uidAnimalAnimaisProdutores: deserializeParam(
          data['uidAnimalAnimaisProdutores'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['tecnico', 'animaisProdutores'],
        ),
        uidPersonProdutor: deserializeParam(
          data['uidPersonProdutor'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['person'],
        ),
        obsVisita: deserializeParam(
          data['obsVisita'],
          ParamType.String,
          false,
        ),
        tipoAcao: deserializeParam(
          data['tipoAcao'],
          ParamType.String,
          false,
        ),
        acao: deserializeParam(
          data['acao'],
          ParamType.String,
          false,
        ),
        uidPropriedade: deserializeParam(
          data['uidPropriedade'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['tecnico', 'propriedades'],
        ),
        dtAcao: deserializeParam(
          data['dtAcao'],
          ParamType.String,
          false,
        ),
        nomeAnimal: deserializeParam(
          data['nomeAnimal'],
          ParamType.String,
          false,
        ),
        brincoAnimal: deserializeParam(
          data['brincoAnimal'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AcoesSanitarioStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AcoesSanitarioStruct &&
        uidAnimalAnimaisProdutores == other.uidAnimalAnimaisProdutores &&
        uidPersonProdutor == other.uidPersonProdutor &&
        obsVisita == other.obsVisita &&
        tipoAcao == other.tipoAcao &&
        acao == other.acao &&
        uidPropriedade == other.uidPropriedade &&
        dtAcao == other.dtAcao &&
        nomeAnimal == other.nomeAnimal &&
        brincoAnimal == other.brincoAnimal;
  }

  @override
  int get hashCode => const ListEquality().hash([
        uidAnimalAnimaisProdutores,
        uidPersonProdutor,
        obsVisita,
        tipoAcao,
        acao,
        uidPropriedade,
        dtAcao,
        nomeAnimal,
        brincoAnimal
      ]);
}

AcoesSanitarioStruct createAcoesSanitarioStruct({
  DocumentReference? uidAnimalAnimaisProdutores,
  DocumentReference? uidPersonProdutor,
  String? obsVisita,
  String? tipoAcao,
  String? acao,
  DocumentReference? uidPropriedade,
  String? dtAcao,
  String? nomeAnimal,
  String? brincoAnimal,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AcoesSanitarioStruct(
      uidAnimalAnimaisProdutores: uidAnimalAnimaisProdutores,
      uidPersonProdutor: uidPersonProdutor,
      obsVisita: obsVisita,
      tipoAcao: tipoAcao,
      acao: acao,
      uidPropriedade: uidPropriedade,
      dtAcao: dtAcao,
      nomeAnimal: nomeAnimal,
      brincoAnimal: brincoAnimal,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AcoesSanitarioStruct? updateAcoesSanitarioStruct(
  AcoesSanitarioStruct? acoesSanitario, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    acoesSanitario
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAcoesSanitarioStructData(
  Map<String, dynamic> firestoreData,
  AcoesSanitarioStruct? acoesSanitario,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (acoesSanitario == null) {
    return;
  }
  if (acoesSanitario.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && acoesSanitario.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final acoesSanitarioData =
      getAcoesSanitarioFirestoreData(acoesSanitario, forFieldValue);
  final nestedData =
      acoesSanitarioData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = acoesSanitario.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAcoesSanitarioFirestoreData(
  AcoesSanitarioStruct? acoesSanitario, [
  bool forFieldValue = false,
]) {
  if (acoesSanitario == null) {
    return {};
  }
  final firestoreData = mapToFirestore(acoesSanitario.toMap());

  // Add any Firestore field values
  acoesSanitario.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAcoesSanitarioListFirestoreData(
  List<AcoesSanitarioStruct>? acoesSanitarios,
) =>
    acoesSanitarios
        ?.map((e) => getAcoesSanitarioFirestoreData(e, true))
        .toList() ??
    [];
