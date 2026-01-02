// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class ResumoDaVisitaStruct extends FFFirebaseStruct {
  ResumoDaVisitaStruct({
    DocumentReference? uidPropriedade,
    DocumentReference? uidTecnico,
    DateTime? dtVisita,
    DocumentReference? uidResumoDaVisita,
    String? dtVisitaFormatado,
    DateTime? dtAssinatura,
    String? dtAssinaturaFormatado,
    String? assinaturaProdutor,
    String? obsGeralVisita,
    String? assinaturaTecnico,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _uidPropriedade = uidPropriedade,
        _uidTecnico = uidTecnico,
        _dtVisita = dtVisita,
        _uidResumoDaVisita = uidResumoDaVisita,
        _dtVisitaFormatado = dtVisitaFormatado,
        _dtAssinatura = dtAssinatura,
        _dtAssinaturaFormatado = dtAssinaturaFormatado,
        _assinaturaProdutor = assinaturaProdutor,
        _obsGeralVisita = obsGeralVisita,
        _assinaturaTecnico = assinaturaTecnico,
        super(firestoreUtilData);

  // "uidPropriedade" field.
  DocumentReference? _uidPropriedade;
  DocumentReference? get uidPropriedade => _uidPropriedade;
  set uidPropriedade(DocumentReference? val) => _uidPropriedade = val;

  bool hasUidPropriedade() => _uidPropriedade != null;

  // "uidTecnico" field.
  DocumentReference? _uidTecnico;
  DocumentReference? get uidTecnico => _uidTecnico;
  set uidTecnico(DocumentReference? val) => _uidTecnico = val;

  bool hasUidTecnico() => _uidTecnico != null;

  // "dtVisita" field.
  DateTime? _dtVisita;
  DateTime? get dtVisita => _dtVisita;
  set dtVisita(DateTime? val) => _dtVisita = val;

  bool hasDtVisita() => _dtVisita != null;

  // "uidResumoDaVisita" field.
  DocumentReference? _uidResumoDaVisita;
  DocumentReference? get uidResumoDaVisita => _uidResumoDaVisita;
  set uidResumoDaVisita(DocumentReference? val) => _uidResumoDaVisita = val;

  bool hasUidResumoDaVisita() => _uidResumoDaVisita != null;

  // "dtVisitaFormatado" field.
  String? _dtVisitaFormatado;
  String get dtVisitaFormatado => _dtVisitaFormatado ?? '';
  set dtVisitaFormatado(String? val) => _dtVisitaFormatado = val;

  bool hasDtVisitaFormatado() => _dtVisitaFormatado != null;

  // "dtAssinatura" field.
  DateTime? _dtAssinatura;
  DateTime? get dtAssinatura => _dtAssinatura;
  set dtAssinatura(DateTime? val) => _dtAssinatura = val;

  bool hasDtAssinatura() => _dtAssinatura != null;

  // "dtAssinaturaFormatado" field.
  String? _dtAssinaturaFormatado;
  String get dtAssinaturaFormatado => _dtAssinaturaFormatado ?? '';
  set dtAssinaturaFormatado(String? val) => _dtAssinaturaFormatado = val;

  bool hasDtAssinaturaFormatado() => _dtAssinaturaFormatado != null;

  // "assinaturaProdutor" field.
  String? _assinaturaProdutor;
  String get assinaturaProdutor => _assinaturaProdutor ?? '';
  set assinaturaProdutor(String? val) => _assinaturaProdutor = val;

  bool hasAssinaturaProdutor() => _assinaturaProdutor != null;

  // "obsGeralVisita" field.
  String? _obsGeralVisita;
  String get obsGeralVisita => _obsGeralVisita ?? '';
  set obsGeralVisita(String? val) => _obsGeralVisita = val;

  bool hasObsGeralVisita() => _obsGeralVisita != null;

  // "assinaturaTecnico" field.
  String? _assinaturaTecnico;
  String get assinaturaTecnico => _assinaturaTecnico ?? '';
  set assinaturaTecnico(String? val) => _assinaturaTecnico = val;

  bool hasAssinaturaTecnico() => _assinaturaTecnico != null;

  static ResumoDaVisitaStruct fromMap(Map<String, dynamic> data) =>
      ResumoDaVisitaStruct(
        uidPropriedade: data['uidPropriedade'] as DocumentReference?,
        uidTecnico: data['uidTecnico'] as DocumentReference?,
        dtVisita: data['dtVisita'] as DateTime?,
        uidResumoDaVisita: data['uidResumoDaVisita'] as DocumentReference?,
        dtVisitaFormatado: data['dtVisitaFormatado'] as String?,
        dtAssinatura: data['dtAssinatura'] as DateTime?,
        dtAssinaturaFormatado: data['dtAssinaturaFormatado'] as String?,
        assinaturaProdutor: data['assinaturaProdutor'] as String?,
        obsGeralVisita: data['obsGeralVisita'] as String?,
        assinaturaTecnico: data['assinaturaTecnico'] as String?,
      );

  static ResumoDaVisitaStruct? maybeFromMap(dynamic data) => data is Map
      ? ResumoDaVisitaStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'uidPropriedade': _uidPropriedade,
        'uidTecnico': _uidTecnico,
        'dtVisita': _dtVisita,
        'uidResumoDaVisita': _uidResumoDaVisita,
        'dtVisitaFormatado': _dtVisitaFormatado,
        'dtAssinatura': _dtAssinatura,
        'dtAssinaturaFormatado': _dtAssinaturaFormatado,
        'assinaturaProdutor': _assinaturaProdutor,
        'obsGeralVisita': _obsGeralVisita,
        'assinaturaTecnico': _assinaturaTecnico,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'uidPropriedade': serializeParam(
          _uidPropriedade,
          ParamType.DocumentReference,
        ),
        'uidTecnico': serializeParam(
          _uidTecnico,
          ParamType.DocumentReference,
        ),
        'dtVisita': serializeParam(
          _dtVisita,
          ParamType.DateTime,
        ),
        'uidResumoDaVisita': serializeParam(
          _uidResumoDaVisita,
          ParamType.DocumentReference,
        ),
        'dtVisitaFormatado': serializeParam(
          _dtVisitaFormatado,
          ParamType.String,
        ),
        'dtAssinatura': serializeParam(
          _dtAssinatura,
          ParamType.DateTime,
        ),
        'dtAssinaturaFormatado': serializeParam(
          _dtAssinaturaFormatado,
          ParamType.String,
        ),
        'assinaturaProdutor': serializeParam(
          _assinaturaProdutor,
          ParamType.String,
        ),
        'obsGeralVisita': serializeParam(
          _obsGeralVisita,
          ParamType.String,
        ),
        'assinaturaTecnico': serializeParam(
          _assinaturaTecnico,
          ParamType.String,
        ),
      }.withoutNulls;

  static ResumoDaVisitaStruct fromSerializableMap(Map<String, dynamic> data) =>
      ResumoDaVisitaStruct(
        uidPropriedade: deserializeParam(
          data['uidPropriedade'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['tecnico', 'propriedades'],
        ),
        uidTecnico: deserializeParam(
          data['uidTecnico'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['tecnico'],
        ),
        dtVisita: deserializeParam(
          data['dtVisita'],
          ParamType.DateTime,
          false,
        ),
        uidResumoDaVisita: deserializeParam(
          data['uidResumoDaVisita'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['resumo_da_visita'],
        ),
        dtVisitaFormatado: deserializeParam(
          data['dtVisitaFormatado'],
          ParamType.String,
          false,
        ),
        dtAssinatura: deserializeParam(
          data['dtAssinatura'],
          ParamType.DateTime,
          false,
        ),
        dtAssinaturaFormatado: deserializeParam(
          data['dtAssinaturaFormatado'],
          ParamType.String,
          false,
        ),
        assinaturaProdutor: deserializeParam(
          data['assinaturaProdutor'],
          ParamType.String,
          false,
        ),
        obsGeralVisita: deserializeParam(
          data['obsGeralVisita'],
          ParamType.String,
          false,
        ),
        assinaturaTecnico: deserializeParam(
          data['assinaturaTecnico'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ResumoDaVisitaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ResumoDaVisitaStruct &&
        uidPropriedade == other.uidPropriedade &&
        uidTecnico == other.uidTecnico &&
        dtVisita == other.dtVisita &&
        uidResumoDaVisita == other.uidResumoDaVisita &&
        dtVisitaFormatado == other.dtVisitaFormatado &&
        dtAssinatura == other.dtAssinatura &&
        dtAssinaturaFormatado == other.dtAssinaturaFormatado &&
        assinaturaProdutor == other.assinaturaProdutor &&
        obsGeralVisita == other.obsGeralVisita &&
        assinaturaTecnico == other.assinaturaTecnico;
  }

  @override
  int get hashCode => const ListEquality().hash([
        uidPropriedade,
        uidTecnico,
        dtVisita,
        uidResumoDaVisita,
        dtVisitaFormatado,
        dtAssinatura,
        dtAssinaturaFormatado,
        assinaturaProdutor,
        obsGeralVisita,
        assinaturaTecnico
      ]);
}

ResumoDaVisitaStruct createResumoDaVisitaStruct({
  DocumentReference? uidPropriedade,
  DocumentReference? uidTecnico,
  DateTime? dtVisita,
  DocumentReference? uidResumoDaVisita,
  String? dtVisitaFormatado,
  DateTime? dtAssinatura,
  String? dtAssinaturaFormatado,
  String? assinaturaProdutor,
  String? obsGeralVisita,
  String? assinaturaTecnico,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ResumoDaVisitaStruct(
      uidPropriedade: uidPropriedade,
      uidTecnico: uidTecnico,
      dtVisita: dtVisita,
      uidResumoDaVisita: uidResumoDaVisita,
      dtVisitaFormatado: dtVisitaFormatado,
      dtAssinatura: dtAssinatura,
      dtAssinaturaFormatado: dtAssinaturaFormatado,
      assinaturaProdutor: assinaturaProdutor,
      obsGeralVisita: obsGeralVisita,
      assinaturaTecnico: assinaturaTecnico,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ResumoDaVisitaStruct? updateResumoDaVisitaStruct(
  ResumoDaVisitaStruct? resumoDaVisita, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    resumoDaVisita
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addResumoDaVisitaStructData(
  Map<String, dynamic> firestoreData,
  ResumoDaVisitaStruct? resumoDaVisita,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (resumoDaVisita == null) {
    return;
  }
  if (resumoDaVisita.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && resumoDaVisita.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final resumoDaVisitaData =
      getResumoDaVisitaFirestoreData(resumoDaVisita, forFieldValue);
  final nestedData =
      resumoDaVisitaData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = resumoDaVisita.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getResumoDaVisitaFirestoreData(
  ResumoDaVisitaStruct? resumoDaVisita, [
  bool forFieldValue = false,
]) {
  if (resumoDaVisita == null) {
    return {};
  }
  final firestoreData = mapToFirestore(resumoDaVisita.toMap());

  // Add any Firestore field values
  resumoDaVisita.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getResumoDaVisitaListFirestoreData(
  List<ResumoDaVisitaStruct>? resumoDaVisitas,
) =>
    resumoDaVisitas
        ?.map((e) => getResumoDaVisitaFirestoreData(e, true))
        .toList() ??
    [];
