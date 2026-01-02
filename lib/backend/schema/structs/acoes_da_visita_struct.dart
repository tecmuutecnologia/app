// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class AcoesDaVisitaStruct extends FFFirebaseStruct {
  AcoesDaVisitaStruct({
    String? acao,
    String? dtAcao,
    DateTime? dtVisita,
    String? dtPP,
    String? dtInseminacao,
    String? tourtoInseminacao,
    String? dtPartoPrevisto,
    String? dtSecPrevista,
    String? dtPrePartoPrevista,
    String? dtDgMais,
    String? dtDgMenos,
    String? dtAborto,
    String? dtSecagem,
    String? tratamento,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _acao = acao,
        _dtAcao = dtAcao,
        _dtVisita = dtVisita,
        _dtPP = dtPP,
        _dtInseminacao = dtInseminacao,
        _tourtoInseminacao = tourtoInseminacao,
        _dtPartoPrevisto = dtPartoPrevisto,
        _dtSecPrevista = dtSecPrevista,
        _dtPrePartoPrevista = dtPrePartoPrevista,
        _dtDgMais = dtDgMais,
        _dtDgMenos = dtDgMenos,
        _dtAborto = dtAborto,
        _dtSecagem = dtSecagem,
        _tratamento = tratamento,
        super(firestoreUtilData);

  // "acao" field.
  String? _acao;
  String get acao => _acao ?? '';
  set acao(String? val) => _acao = val;

  bool hasAcao() => _acao != null;

  // "dtAcao" field.
  String? _dtAcao;
  String get dtAcao => _dtAcao ?? '';
  set dtAcao(String? val) => _dtAcao = val;

  bool hasDtAcao() => _dtAcao != null;

  // "dtVisita" field.
  DateTime? _dtVisita;
  DateTime? get dtVisita => _dtVisita;
  set dtVisita(DateTime? val) => _dtVisita = val;

  bool hasDtVisita() => _dtVisita != null;

  // "dtPP" field.
  String? _dtPP;
  String get dtPP => _dtPP ?? '';
  set dtPP(String? val) => _dtPP = val;

  bool hasDtPP() => _dtPP != null;

  // "dtInseminacao" field.
  String? _dtInseminacao;
  String get dtInseminacao => _dtInseminacao ?? '';
  set dtInseminacao(String? val) => _dtInseminacao = val;

  bool hasDtInseminacao() => _dtInseminacao != null;

  // "tourtoInseminacao" field.
  String? _tourtoInseminacao;
  String get tourtoInseminacao => _tourtoInseminacao ?? '';
  set tourtoInseminacao(String? val) => _tourtoInseminacao = val;

  bool hasTourtoInseminacao() => _tourtoInseminacao != null;

  // "dtPartoPrevisto" field.
  String? _dtPartoPrevisto;
  String get dtPartoPrevisto => _dtPartoPrevisto ?? '';
  set dtPartoPrevisto(String? val) => _dtPartoPrevisto = val;

  bool hasDtPartoPrevisto() => _dtPartoPrevisto != null;

  // "dtSecPrevista" field.
  String? _dtSecPrevista;
  String get dtSecPrevista => _dtSecPrevista ?? '';
  set dtSecPrevista(String? val) => _dtSecPrevista = val;

  bool hasDtSecPrevista() => _dtSecPrevista != null;

  // "dtPrePartoPrevista" field.
  String? _dtPrePartoPrevista;
  String get dtPrePartoPrevista => _dtPrePartoPrevista ?? '';
  set dtPrePartoPrevista(String? val) => _dtPrePartoPrevista = val;

  bool hasDtPrePartoPrevista() => _dtPrePartoPrevista != null;

  // "dtDgMais" field.
  String? _dtDgMais;
  String get dtDgMais => _dtDgMais ?? '';
  set dtDgMais(String? val) => _dtDgMais = val;

  bool hasDtDgMais() => _dtDgMais != null;

  // "dtDgMenos" field.
  String? _dtDgMenos;
  String get dtDgMenos => _dtDgMenos ?? '';
  set dtDgMenos(String? val) => _dtDgMenos = val;

  bool hasDtDgMenos() => _dtDgMenos != null;

  // "dtAborto" field.
  String? _dtAborto;
  String get dtAborto => _dtAborto ?? '';
  set dtAborto(String? val) => _dtAborto = val;

  bool hasDtAborto() => _dtAborto != null;

  // "dtSecagem" field.
  String? _dtSecagem;
  String get dtSecagem => _dtSecagem ?? '';
  set dtSecagem(String? val) => _dtSecagem = val;

  bool hasDtSecagem() => _dtSecagem != null;

  // "tratamento" field.
  String? _tratamento;
  String get tratamento => _tratamento ?? '';
  set tratamento(String? val) => _tratamento = val;

  bool hasTratamento() => _tratamento != null;

  static AcoesDaVisitaStruct fromMap(Map<String, dynamic> data) =>
      AcoesDaVisitaStruct(
        acao: data['acao'] as String?,
        dtAcao: data['dtAcao'] as String?,
        dtVisita: data['dtVisita'] as DateTime?,
        dtPP: data['dtPP'] as String?,
        dtInseminacao: data['dtInseminacao'] as String?,
        tourtoInseminacao: data['tourtoInseminacao'] as String?,
        dtPartoPrevisto: data['dtPartoPrevisto'] as String?,
        dtSecPrevista: data['dtSecPrevista'] as String?,
        dtPrePartoPrevista: data['dtPrePartoPrevista'] as String?,
        dtDgMais: data['dtDgMais'] as String?,
        dtDgMenos: data['dtDgMenos'] as String?,
        dtAborto: data['dtAborto'] as String?,
        dtSecagem: data['dtSecagem'] as String?,
        tratamento: data['tratamento'] as String?,
      );

  static AcoesDaVisitaStruct? maybeFromMap(dynamic data) => data is Map
      ? AcoesDaVisitaStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'acao': _acao,
        'dtAcao': _dtAcao,
        'dtVisita': _dtVisita,
        'dtPP': _dtPP,
        'dtInseminacao': _dtInseminacao,
        'tourtoInseminacao': _tourtoInseminacao,
        'dtPartoPrevisto': _dtPartoPrevisto,
        'dtSecPrevista': _dtSecPrevista,
        'dtPrePartoPrevista': _dtPrePartoPrevista,
        'dtDgMais': _dtDgMais,
        'dtDgMenos': _dtDgMenos,
        'dtAborto': _dtAborto,
        'dtSecagem': _dtSecagem,
        'tratamento': _tratamento,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'acao': serializeParam(
          _acao,
          ParamType.String,
        ),
        'dtAcao': serializeParam(
          _dtAcao,
          ParamType.String,
        ),
        'dtVisita': serializeParam(
          _dtVisita,
          ParamType.DateTime,
        ),
        'dtPP': serializeParam(
          _dtPP,
          ParamType.String,
        ),
        'dtInseminacao': serializeParam(
          _dtInseminacao,
          ParamType.String,
        ),
        'tourtoInseminacao': serializeParam(
          _tourtoInseminacao,
          ParamType.String,
        ),
        'dtPartoPrevisto': serializeParam(
          _dtPartoPrevisto,
          ParamType.String,
        ),
        'dtSecPrevista': serializeParam(
          _dtSecPrevista,
          ParamType.String,
        ),
        'dtPrePartoPrevista': serializeParam(
          _dtPrePartoPrevista,
          ParamType.String,
        ),
        'dtDgMais': serializeParam(
          _dtDgMais,
          ParamType.String,
        ),
        'dtDgMenos': serializeParam(
          _dtDgMenos,
          ParamType.String,
        ),
        'dtAborto': serializeParam(
          _dtAborto,
          ParamType.String,
        ),
        'dtSecagem': serializeParam(
          _dtSecagem,
          ParamType.String,
        ),
        'tratamento': serializeParam(
          _tratamento,
          ParamType.String,
        ),
      }.withoutNulls;

  static AcoesDaVisitaStruct fromSerializableMap(Map<String, dynamic> data) =>
      AcoesDaVisitaStruct(
        acao: deserializeParam(
          data['acao'],
          ParamType.String,
          false,
        ),
        dtAcao: deserializeParam(
          data['dtAcao'],
          ParamType.String,
          false,
        ),
        dtVisita: deserializeParam(
          data['dtVisita'],
          ParamType.DateTime,
          false,
        ),
        dtPP: deserializeParam(
          data['dtPP'],
          ParamType.String,
          false,
        ),
        dtInseminacao: deserializeParam(
          data['dtInseminacao'],
          ParamType.String,
          false,
        ),
        tourtoInseminacao: deserializeParam(
          data['tourtoInseminacao'],
          ParamType.String,
          false,
        ),
        dtPartoPrevisto: deserializeParam(
          data['dtPartoPrevisto'],
          ParamType.String,
          false,
        ),
        dtSecPrevista: deserializeParam(
          data['dtSecPrevista'],
          ParamType.String,
          false,
        ),
        dtPrePartoPrevista: deserializeParam(
          data['dtPrePartoPrevista'],
          ParamType.String,
          false,
        ),
        dtDgMais: deserializeParam(
          data['dtDgMais'],
          ParamType.String,
          false,
        ),
        dtDgMenos: deserializeParam(
          data['dtDgMenos'],
          ParamType.String,
          false,
        ),
        dtAborto: deserializeParam(
          data['dtAborto'],
          ParamType.String,
          false,
        ),
        dtSecagem: deserializeParam(
          data['dtSecagem'],
          ParamType.String,
          false,
        ),
        tratamento: deserializeParam(
          data['tratamento'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AcoesDaVisitaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AcoesDaVisitaStruct &&
        acao == other.acao &&
        dtAcao == other.dtAcao &&
        dtVisita == other.dtVisita &&
        dtPP == other.dtPP &&
        dtInseminacao == other.dtInseminacao &&
        tourtoInseminacao == other.tourtoInseminacao &&
        dtPartoPrevisto == other.dtPartoPrevisto &&
        dtSecPrevista == other.dtSecPrevista &&
        dtPrePartoPrevista == other.dtPrePartoPrevista &&
        dtDgMais == other.dtDgMais &&
        dtDgMenos == other.dtDgMenos &&
        dtAborto == other.dtAborto &&
        dtSecagem == other.dtSecagem &&
        tratamento == other.tratamento;
  }

  @override
  int get hashCode => const ListEquality().hash([
        acao,
        dtAcao,
        dtVisita,
        dtPP,
        dtInseminacao,
        tourtoInseminacao,
        dtPartoPrevisto,
        dtSecPrevista,
        dtPrePartoPrevista,
        dtDgMais,
        dtDgMenos,
        dtAborto,
        dtSecagem,
        tratamento
      ]);
}

AcoesDaVisitaStruct createAcoesDaVisitaStruct({
  String? acao,
  String? dtAcao,
  DateTime? dtVisita,
  String? dtPP,
  String? dtInseminacao,
  String? tourtoInseminacao,
  String? dtPartoPrevisto,
  String? dtSecPrevista,
  String? dtPrePartoPrevista,
  String? dtDgMais,
  String? dtDgMenos,
  String? dtAborto,
  String? dtSecagem,
  String? tratamento,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AcoesDaVisitaStruct(
      acao: acao,
      dtAcao: dtAcao,
      dtVisita: dtVisita,
      dtPP: dtPP,
      dtInseminacao: dtInseminacao,
      tourtoInseminacao: tourtoInseminacao,
      dtPartoPrevisto: dtPartoPrevisto,
      dtSecPrevista: dtSecPrevista,
      dtPrePartoPrevista: dtPrePartoPrevista,
      dtDgMais: dtDgMais,
      dtDgMenos: dtDgMenos,
      dtAborto: dtAborto,
      dtSecagem: dtSecagem,
      tratamento: tratamento,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AcoesDaVisitaStruct? updateAcoesDaVisitaStruct(
  AcoesDaVisitaStruct? acoesDaVisita, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    acoesDaVisita
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAcoesDaVisitaStructData(
  Map<String, dynamic> firestoreData,
  AcoesDaVisitaStruct? acoesDaVisita,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (acoesDaVisita == null) {
    return;
  }
  if (acoesDaVisita.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && acoesDaVisita.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final acoesDaVisitaData =
      getAcoesDaVisitaFirestoreData(acoesDaVisita, forFieldValue);
  final nestedData =
      acoesDaVisitaData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = acoesDaVisita.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAcoesDaVisitaFirestoreData(
  AcoesDaVisitaStruct? acoesDaVisita, [
  bool forFieldValue = false,
]) {
  if (acoesDaVisita == null) {
    return {};
  }
  final firestoreData = mapToFirestore(acoesDaVisita.toMap());

  // Add any Firestore field values
  acoesDaVisita.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAcoesDaVisitaListFirestoreData(
  List<AcoesDaVisitaStruct>? acoesDaVisitas,
) =>
    acoesDaVisitas
        ?.map((e) => getAcoesDaVisitaFirestoreData(e, true))
        .toList() ??
    [];
