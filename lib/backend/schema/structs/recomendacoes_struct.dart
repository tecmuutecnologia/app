// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class RecomendacoesStruct extends FFFirebaseStruct {
  RecomendacoesStruct({
    String? tituloRecomendacao,
    String? descricaoRecomendacao,
    DocumentReference? uidAnimalProdutores,
    DocumentReference? uidPropriedade,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _tituloRecomendacao = tituloRecomendacao,
        _descricaoRecomendacao = descricaoRecomendacao,
        _uidAnimalProdutores = uidAnimalProdutores,
        _uidPropriedade = uidPropriedade,
        super(firestoreUtilData);

  // "tituloRecomendacao" field.
  String? _tituloRecomendacao;
  String get tituloRecomendacao => _tituloRecomendacao ?? '';
  set tituloRecomendacao(String? val) => _tituloRecomendacao = val;

  bool hasTituloRecomendacao() => _tituloRecomendacao != null;

  // "descricaoRecomendacao" field.
  String? _descricaoRecomendacao;
  String get descricaoRecomendacao => _descricaoRecomendacao ?? '';
  set descricaoRecomendacao(String? val) => _descricaoRecomendacao = val;

  bool hasDescricaoRecomendacao() => _descricaoRecomendacao != null;

  // "uidAnimalProdutores" field.
  DocumentReference? _uidAnimalProdutores;
  DocumentReference? get uidAnimalProdutores => _uidAnimalProdutores;
  set uidAnimalProdutores(DocumentReference? val) => _uidAnimalProdutores = val;

  bool hasUidAnimalProdutores() => _uidAnimalProdutores != null;

  // "uidPropriedade" field.
  DocumentReference? _uidPropriedade;
  DocumentReference? get uidPropriedade => _uidPropriedade;
  set uidPropriedade(DocumentReference? val) => _uidPropriedade = val;

  bool hasUidPropriedade() => _uidPropriedade != null;

  static RecomendacoesStruct fromMap(Map<String, dynamic> data) =>
      RecomendacoesStruct(
        tituloRecomendacao: data['tituloRecomendacao'] as String?,
        descricaoRecomendacao: data['descricaoRecomendacao'] as String?,
        uidAnimalProdutores: data['uidAnimalProdutores'] as DocumentReference?,
        uidPropriedade: data['uidPropriedade'] as DocumentReference?,
      );

  static RecomendacoesStruct? maybeFromMap(dynamic data) => data is Map
      ? RecomendacoesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'tituloRecomendacao': _tituloRecomendacao,
        'descricaoRecomendacao': _descricaoRecomendacao,
        'uidAnimalProdutores': _uidAnimalProdutores,
        'uidPropriedade': _uidPropriedade,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'tituloRecomendacao': serializeParam(
          _tituloRecomendacao,
          ParamType.String,
        ),
        'descricaoRecomendacao': serializeParam(
          _descricaoRecomendacao,
          ParamType.String,
        ),
        'uidAnimalProdutores': serializeParam(
          _uidAnimalProdutores,
          ParamType.DocumentReference,
        ),
        'uidPropriedade': serializeParam(
          _uidPropriedade,
          ParamType.DocumentReference,
        ),
      }.withoutNulls;

  static RecomendacoesStruct fromSerializableMap(Map<String, dynamic> data) =>
      RecomendacoesStruct(
        tituloRecomendacao: deserializeParam(
          data['tituloRecomendacao'],
          ParamType.String,
          false,
        ),
        descricaoRecomendacao: deserializeParam(
          data['descricaoRecomendacao'],
          ParamType.String,
          false,
        ),
        uidAnimalProdutores: deserializeParam(
          data['uidAnimalProdutores'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['tecnico', 'animaisProdutores'],
        ),
        uidPropriedade: deserializeParam(
          data['uidPropriedade'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['tecnico', 'propriedades'],
        ),
      );

  @override
  String toString() => 'RecomendacoesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RecomendacoesStruct &&
        tituloRecomendacao == other.tituloRecomendacao &&
        descricaoRecomendacao == other.descricaoRecomendacao &&
        uidAnimalProdutores == other.uidAnimalProdutores &&
        uidPropriedade == other.uidPropriedade;
  }

  @override
  int get hashCode => const ListEquality().hash([
        tituloRecomendacao,
        descricaoRecomendacao,
        uidAnimalProdutores,
        uidPropriedade
      ]);
}

RecomendacoesStruct createRecomendacoesStruct({
  String? tituloRecomendacao,
  String? descricaoRecomendacao,
  DocumentReference? uidAnimalProdutores,
  DocumentReference? uidPropriedade,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    RecomendacoesStruct(
      tituloRecomendacao: tituloRecomendacao,
      descricaoRecomendacao: descricaoRecomendacao,
      uidAnimalProdutores: uidAnimalProdutores,
      uidPropriedade: uidPropriedade,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

RecomendacoesStruct? updateRecomendacoesStruct(
  RecomendacoesStruct? recomendacoes, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    recomendacoes
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addRecomendacoesStructData(
  Map<String, dynamic> firestoreData,
  RecomendacoesStruct? recomendacoes,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (recomendacoes == null) {
    return;
  }
  if (recomendacoes.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && recomendacoes.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final recomendacoesData =
      getRecomendacoesFirestoreData(recomendacoes, forFieldValue);
  final nestedData =
      recomendacoesData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = recomendacoes.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getRecomendacoesFirestoreData(
  RecomendacoesStruct? recomendacoes, [
  bool forFieldValue = false,
]) {
  if (recomendacoes == null) {
    return {};
  }
  final firestoreData = mapToFirestore(recomendacoes.toMap());

  // Add any Firestore field values
  recomendacoes.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getRecomendacoesListFirestoreData(
  List<RecomendacoesStruct>? recomendacoess,
) =>
    recomendacoess
        ?.map((e) => getRecomendacoesFirestoreData(e, true))
        .toList() ??
    [];
