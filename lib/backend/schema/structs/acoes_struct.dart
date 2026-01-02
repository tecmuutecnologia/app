// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class AcoesStruct extends FFFirebaseStruct {
  AcoesStruct({
    DocumentReference? uidAnimalAnimaisProdutores,
    String? nomeAnimal,
    String? acao,
    String? obsVisita,
    String? touroInseminacao,
    String? dataVisita,
    String? dataPartoPrevisto,
    String? dataSecPrevista,
    String? dataPrePartoPrevista,
    DateTime? dataDaAcao,
    String? dtPP,
    String? dtDgMais,
    String? dtDgMenos,
    String? dtAborto,
    DocumentReference? uidPropriedade,
    int? itemAtIndex,
    String? uidAnimalOffline,
    String? brincoAnimal,
    String? grupoAnimal,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _uidAnimalAnimaisProdutores = uidAnimalAnimaisProdutores,
        _nomeAnimal = nomeAnimal,
        _acao = acao,
        _obsVisita = obsVisita,
        _touroInseminacao = touroInseminacao,
        _dataVisita = dataVisita,
        _dataPartoPrevisto = dataPartoPrevisto,
        _dataSecPrevista = dataSecPrevista,
        _dataPrePartoPrevista = dataPrePartoPrevista,
        _dataDaAcao = dataDaAcao,
        _dtPP = dtPP,
        _dtDgMais = dtDgMais,
        _dtDgMenos = dtDgMenos,
        _dtAborto = dtAborto,
        _uidPropriedade = uidPropriedade,
        _itemAtIndex = itemAtIndex,
        _uidAnimalOffline = uidAnimalOffline,
        _brincoAnimal = brincoAnimal,
        _grupoAnimal = grupoAnimal,
        super(firestoreUtilData);

  // "uidAnimalAnimaisProdutores" field.
  DocumentReference? _uidAnimalAnimaisProdutores;
  DocumentReference? get uidAnimalAnimaisProdutores =>
      _uidAnimalAnimaisProdutores;
  set uidAnimalAnimaisProdutores(DocumentReference? val) =>
      _uidAnimalAnimaisProdutores = val;

  bool hasUidAnimalAnimaisProdutores() => _uidAnimalAnimaisProdutores != null;

  // "nomeAnimal" field.
  String? _nomeAnimal;
  String get nomeAnimal => _nomeAnimal ?? '';
  set nomeAnimal(String? val) => _nomeAnimal = val;

  bool hasNomeAnimal() => _nomeAnimal != null;

  // "acao" field.
  String? _acao;
  String get acao => _acao ?? '';
  set acao(String? val) => _acao = val;

  bool hasAcao() => _acao != null;

  // "obsVisita" field.
  String? _obsVisita;
  String get obsVisita => _obsVisita ?? '';
  set obsVisita(String? val) => _obsVisita = val;

  bool hasObsVisita() => _obsVisita != null;

  // "touroInseminacao" field.
  String? _touroInseminacao;
  String get touroInseminacao => _touroInseminacao ?? '';
  set touroInseminacao(String? val) => _touroInseminacao = val;

  bool hasTouroInseminacao() => _touroInseminacao != null;

  // "dataVisita" field.
  String? _dataVisita;
  String get dataVisita => _dataVisita ?? '';
  set dataVisita(String? val) => _dataVisita = val;

  bool hasDataVisita() => _dataVisita != null;

  // "dataPartoPrevisto" field.
  String? _dataPartoPrevisto;
  String get dataPartoPrevisto => _dataPartoPrevisto ?? '';
  set dataPartoPrevisto(String? val) => _dataPartoPrevisto = val;

  bool hasDataPartoPrevisto() => _dataPartoPrevisto != null;

  // "dataSecPrevista" field.
  String? _dataSecPrevista;
  String get dataSecPrevista => _dataSecPrevista ?? '';
  set dataSecPrevista(String? val) => _dataSecPrevista = val;

  bool hasDataSecPrevista() => _dataSecPrevista != null;

  // "dataPrePartoPrevista" field.
  String? _dataPrePartoPrevista;
  String get dataPrePartoPrevista => _dataPrePartoPrevista ?? '';
  set dataPrePartoPrevista(String? val) => _dataPrePartoPrevista = val;

  bool hasDataPrePartoPrevista() => _dataPrePartoPrevista != null;

  // "dataDaAcao" field.
  DateTime? _dataDaAcao;
  DateTime? get dataDaAcao => _dataDaAcao;
  set dataDaAcao(DateTime? val) => _dataDaAcao = val;

  bool hasDataDaAcao() => _dataDaAcao != null;

  // "dtPP" field.
  String? _dtPP;
  String get dtPP => _dtPP ?? '';
  set dtPP(String? val) => _dtPP = val;

  bool hasDtPP() => _dtPP != null;

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

  // "uidPropriedade" field.
  DocumentReference? _uidPropriedade;
  DocumentReference? get uidPropriedade => _uidPropriedade;
  set uidPropriedade(DocumentReference? val) => _uidPropriedade = val;

  bool hasUidPropriedade() => _uidPropriedade != null;

  // "itemAtIndex" field.
  int? _itemAtIndex;
  int get itemAtIndex => _itemAtIndex ?? 0;
  set itemAtIndex(int? val) => _itemAtIndex = val;

  void incrementItemAtIndex(int amount) => itemAtIndex = itemAtIndex + amount;

  bool hasItemAtIndex() => _itemAtIndex != null;

  // "uidAnimalOffline" field.
  String? _uidAnimalOffline;
  String get uidAnimalOffline => _uidAnimalOffline ?? '';
  set uidAnimalOffline(String? val) => _uidAnimalOffline = val;

  bool hasUidAnimalOffline() => _uidAnimalOffline != null;

  // "brincoAnimal" field.
  String? _brincoAnimal;
  String get brincoAnimal => _brincoAnimal ?? '';
  set brincoAnimal(String? val) => _brincoAnimal = val;

  bool hasBrincoAnimal() => _brincoAnimal != null;

  // "grupoAnimal" field.
  String? _grupoAnimal;
  String get grupoAnimal => _grupoAnimal ?? '';
  set grupoAnimal(String? val) => _grupoAnimal = val;

  bool hasGrupoAnimal() => _grupoAnimal != null;

  static AcoesStruct fromMap(Map<String, dynamic> data) => AcoesStruct(
        uidAnimalAnimaisProdutores:
            data['uidAnimalAnimaisProdutores'] as DocumentReference?,
        nomeAnimal: data['nomeAnimal'] as String?,
        acao: data['acao'] as String?,
        obsVisita: data['obsVisita'] as String?,
        touroInseminacao: data['touroInseminacao'] as String?,
        dataVisita: data['dataVisita'] as String?,
        dataPartoPrevisto: data['dataPartoPrevisto'] as String?,
        dataSecPrevista: data['dataSecPrevista'] as String?,
        dataPrePartoPrevista: data['dataPrePartoPrevista'] as String?,
        dataDaAcao: data['dataDaAcao'] as DateTime?,
        dtPP: data['dtPP'] as String?,
        dtDgMais: data['dtDgMais'] as String?,
        dtDgMenos: data['dtDgMenos'] as String?,
        dtAborto: data['dtAborto'] as String?,
        uidPropriedade: data['uidPropriedade'] as DocumentReference?,
        itemAtIndex: castToType<int>(data['itemAtIndex']),
        uidAnimalOffline: data['uidAnimalOffline'] as String?,
        brincoAnimal: data['brincoAnimal'] as String?,
        grupoAnimal: data['grupoAnimal'] as String?,
      );

  static AcoesStruct? maybeFromMap(dynamic data) =>
      data is Map ? AcoesStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'uidAnimalAnimaisProdutores': _uidAnimalAnimaisProdutores,
        'nomeAnimal': _nomeAnimal,
        'acao': _acao,
        'obsVisita': _obsVisita,
        'touroInseminacao': _touroInseminacao,
        'dataVisita': _dataVisita,
        'dataPartoPrevisto': _dataPartoPrevisto,
        'dataSecPrevista': _dataSecPrevista,
        'dataPrePartoPrevista': _dataPrePartoPrevista,
        'dataDaAcao': _dataDaAcao,
        'dtPP': _dtPP,
        'dtDgMais': _dtDgMais,
        'dtDgMenos': _dtDgMenos,
        'dtAborto': _dtAborto,
        'uidPropriedade': _uidPropriedade,
        'itemAtIndex': _itemAtIndex,
        'uidAnimalOffline': _uidAnimalOffline,
        'brincoAnimal': _brincoAnimal,
        'grupoAnimal': _grupoAnimal,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'uidAnimalAnimaisProdutores': serializeParam(
          _uidAnimalAnimaisProdutores,
          ParamType.DocumentReference,
        ),
        'nomeAnimal': serializeParam(
          _nomeAnimal,
          ParamType.String,
        ),
        'acao': serializeParam(
          _acao,
          ParamType.String,
        ),
        'obsVisita': serializeParam(
          _obsVisita,
          ParamType.String,
        ),
        'touroInseminacao': serializeParam(
          _touroInseminacao,
          ParamType.String,
        ),
        'dataVisita': serializeParam(
          _dataVisita,
          ParamType.String,
        ),
        'dataPartoPrevisto': serializeParam(
          _dataPartoPrevisto,
          ParamType.String,
        ),
        'dataSecPrevista': serializeParam(
          _dataSecPrevista,
          ParamType.String,
        ),
        'dataPrePartoPrevista': serializeParam(
          _dataPrePartoPrevista,
          ParamType.String,
        ),
        'dataDaAcao': serializeParam(
          _dataDaAcao,
          ParamType.DateTime,
        ),
        'dtPP': serializeParam(
          _dtPP,
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
        'uidPropriedade': serializeParam(
          _uidPropriedade,
          ParamType.DocumentReference,
        ),
        'itemAtIndex': serializeParam(
          _itemAtIndex,
          ParamType.int,
        ),
        'uidAnimalOffline': serializeParam(
          _uidAnimalOffline,
          ParamType.String,
        ),
        'brincoAnimal': serializeParam(
          _brincoAnimal,
          ParamType.String,
        ),
        'grupoAnimal': serializeParam(
          _grupoAnimal,
          ParamType.String,
        ),
      }.withoutNulls;

  static AcoesStruct fromSerializableMap(Map<String, dynamic> data) =>
      AcoesStruct(
        uidAnimalAnimaisProdutores: deserializeParam(
          data['uidAnimalAnimaisProdutores'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['tecnico', 'animaisProdutores'],
        ),
        nomeAnimal: deserializeParam(
          data['nomeAnimal'],
          ParamType.String,
          false,
        ),
        acao: deserializeParam(
          data['acao'],
          ParamType.String,
          false,
        ),
        obsVisita: deserializeParam(
          data['obsVisita'],
          ParamType.String,
          false,
        ),
        touroInseminacao: deserializeParam(
          data['touroInseminacao'],
          ParamType.String,
          false,
        ),
        dataVisita: deserializeParam(
          data['dataVisita'],
          ParamType.String,
          false,
        ),
        dataPartoPrevisto: deserializeParam(
          data['dataPartoPrevisto'],
          ParamType.String,
          false,
        ),
        dataSecPrevista: deserializeParam(
          data['dataSecPrevista'],
          ParamType.String,
          false,
        ),
        dataPrePartoPrevista: deserializeParam(
          data['dataPrePartoPrevista'],
          ParamType.String,
          false,
        ),
        dataDaAcao: deserializeParam(
          data['dataDaAcao'],
          ParamType.DateTime,
          false,
        ),
        dtPP: deserializeParam(
          data['dtPP'],
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
        uidPropriedade: deserializeParam(
          data['uidPropriedade'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['tecnico', 'propriedades'],
        ),
        itemAtIndex: deserializeParam(
          data['itemAtIndex'],
          ParamType.int,
          false,
        ),
        uidAnimalOffline: deserializeParam(
          data['uidAnimalOffline'],
          ParamType.String,
          false,
        ),
        brincoAnimal: deserializeParam(
          data['brincoAnimal'],
          ParamType.String,
          false,
        ),
        grupoAnimal: deserializeParam(
          data['grupoAnimal'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AcoesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AcoesStruct &&
        uidAnimalAnimaisProdutores == other.uidAnimalAnimaisProdutores &&
        nomeAnimal == other.nomeAnimal &&
        acao == other.acao &&
        obsVisita == other.obsVisita &&
        touroInseminacao == other.touroInseminacao &&
        dataVisita == other.dataVisita &&
        dataPartoPrevisto == other.dataPartoPrevisto &&
        dataSecPrevista == other.dataSecPrevista &&
        dataPrePartoPrevista == other.dataPrePartoPrevista &&
        dataDaAcao == other.dataDaAcao &&
        dtPP == other.dtPP &&
        dtDgMais == other.dtDgMais &&
        dtDgMenos == other.dtDgMenos &&
        dtAborto == other.dtAborto &&
        uidPropriedade == other.uidPropriedade &&
        itemAtIndex == other.itemAtIndex &&
        uidAnimalOffline == other.uidAnimalOffline &&
        brincoAnimal == other.brincoAnimal &&
        grupoAnimal == other.grupoAnimal;
  }

  @override
  int get hashCode => const ListEquality().hash([
        uidAnimalAnimaisProdutores,
        nomeAnimal,
        acao,
        obsVisita,
        touroInseminacao,
        dataVisita,
        dataPartoPrevisto,
        dataSecPrevista,
        dataPrePartoPrevista,
        dataDaAcao,
        dtPP,
        dtDgMais,
        dtDgMenos,
        dtAborto,
        uidPropriedade,
        itemAtIndex,
        uidAnimalOffline,
        brincoAnimal,
        grupoAnimal
      ]);
}

AcoesStruct createAcoesStruct({
  DocumentReference? uidAnimalAnimaisProdutores,
  String? nomeAnimal,
  String? acao,
  String? obsVisita,
  String? touroInseminacao,
  String? dataVisita,
  String? dataPartoPrevisto,
  String? dataSecPrevista,
  String? dataPrePartoPrevista,
  DateTime? dataDaAcao,
  String? dtPP,
  String? dtDgMais,
  String? dtDgMenos,
  String? dtAborto,
  DocumentReference? uidPropriedade,
  int? itemAtIndex,
  String? uidAnimalOffline,
  String? brincoAnimal,
  String? grupoAnimal,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AcoesStruct(
      uidAnimalAnimaisProdutores: uidAnimalAnimaisProdutores,
      nomeAnimal: nomeAnimal,
      acao: acao,
      obsVisita: obsVisita,
      touroInseminacao: touroInseminacao,
      dataVisita: dataVisita,
      dataPartoPrevisto: dataPartoPrevisto,
      dataSecPrevista: dataSecPrevista,
      dataPrePartoPrevista: dataPrePartoPrevista,
      dataDaAcao: dataDaAcao,
      dtPP: dtPP,
      dtDgMais: dtDgMais,
      dtDgMenos: dtDgMenos,
      dtAborto: dtAborto,
      uidPropriedade: uidPropriedade,
      itemAtIndex: itemAtIndex,
      uidAnimalOffline: uidAnimalOffline,
      brincoAnimal: brincoAnimal,
      grupoAnimal: grupoAnimal,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AcoesStruct? updateAcoesStruct(
  AcoesStruct? acoes, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    acoes
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAcoesStructData(
  Map<String, dynamic> firestoreData,
  AcoesStruct? acoes,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (acoes == null) {
    return;
  }
  if (acoes.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && acoes.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final acoesData = getAcoesFirestoreData(acoes, forFieldValue);
  final nestedData = acoesData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = acoes.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAcoesFirestoreData(
  AcoesStruct? acoes, [
  bool forFieldValue = false,
]) {
  if (acoes == null) {
    return {};
  }
  final firestoreData = mapToFirestore(acoes.toMap());

  // Add any Firestore field values
  acoes.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAcoesListFirestoreData(
  List<AcoesStruct>? acoess,
) =>
    acoess?.map((e) => getAcoesFirestoreData(e, true)).toList() ?? [];
