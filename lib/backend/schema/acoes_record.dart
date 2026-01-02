import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AcoesRecord extends FirestoreRecord {
  AcoesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "uidAnimalAnimaisProdutores" field.
  DocumentReference? _uidAnimalAnimaisProdutores;
  DocumentReference? get uidAnimalAnimaisProdutores =>
      _uidAnimalAnimaisProdutores;
  bool hasUidAnimalAnimaisProdutores() => _uidAnimalAnimaisProdutores != null;

  // "nomeAnimal" field.
  String? _nomeAnimal;
  String get nomeAnimal => _nomeAnimal ?? '';
  bool hasNomeAnimal() => _nomeAnimal != null;

  // "acao" field.
  String? _acao;
  String get acao => _acao ?? '';
  bool hasAcao() => _acao != null;

  // "obsVisita" field.
  String? _obsVisita;
  String get obsVisita => _obsVisita ?? '';
  bool hasObsVisita() => _obsVisita != null;

  // "touroInseminacao" field.
  String? _touroInseminacao;
  String get touroInseminacao => _touroInseminacao ?? '';
  bool hasTouroInseminacao() => _touroInseminacao != null;

  // "dataVisita" field.
  String? _dataVisita;
  String get dataVisita => _dataVisita ?? '';
  bool hasDataVisita() => _dataVisita != null;

  // "dataPartoPrevisto" field.
  String? _dataPartoPrevisto;
  String get dataPartoPrevisto => _dataPartoPrevisto ?? '';
  bool hasDataPartoPrevisto() => _dataPartoPrevisto != null;

  // "dataSecPrevista" field.
  String? _dataSecPrevista;
  String get dataSecPrevista => _dataSecPrevista ?? '';
  bool hasDataSecPrevista() => _dataSecPrevista != null;

  // "dataPrePartoPrevista" field.
  String? _dataPrePartoPrevista;
  String get dataPrePartoPrevista => _dataPrePartoPrevista ?? '';
  bool hasDataPrePartoPrevista() => _dataPrePartoPrevista != null;

  // "dataDaAcao" field.
  DateTime? _dataDaAcao;
  DateTime? get dataDaAcao => _dataDaAcao;
  bool hasDataDaAcao() => _dataDaAcao != null;

  // "dtPP" field.
  String? _dtPP;
  String get dtPP => _dtPP ?? '';
  bool hasDtPP() => _dtPP != null;

  // "dtDgMais" field.
  String? _dtDgMais;
  String get dtDgMais => _dtDgMais ?? '';
  bool hasDtDgMais() => _dtDgMais != null;

  // "dtDgMenos" field.
  String? _dtDgMenos;
  String get dtDgMenos => _dtDgMenos ?? '';
  bool hasDtDgMenos() => _dtDgMenos != null;

  // "dtAborto" field.
  String? _dtAborto;
  String get dtAborto => _dtAborto ?? '';
  bool hasDtAborto() => _dtAborto != null;

  // "uidPropriedade" field.
  DocumentReference? _uidPropriedade;
  DocumentReference? get uidPropriedade => _uidPropriedade;
  bool hasUidPropriedade() => _uidPropriedade != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _uidAnimalAnimaisProdutores =
        snapshotData['uidAnimalAnimaisProdutores'] as DocumentReference?;
    _nomeAnimal = snapshotData['nomeAnimal'] as String?;
    _acao = snapshotData['acao'] as String?;
    _obsVisita = snapshotData['obsVisita'] as String?;
    _touroInseminacao = snapshotData['touroInseminacao'] as String?;
    _dataVisita = snapshotData['dataVisita'] as String?;
    _dataPartoPrevisto = snapshotData['dataPartoPrevisto'] as String?;
    _dataSecPrevista = snapshotData['dataSecPrevista'] as String?;
    _dataPrePartoPrevista = snapshotData['dataPrePartoPrevista'] as String?;
    _dataDaAcao = snapshotData['dataDaAcao'] as DateTime?;
    _dtPP = snapshotData['dtPP'] as String?;
    _dtDgMais = snapshotData['dtDgMais'] as String?;
    _dtDgMenos = snapshotData['dtDgMenos'] as String?;
    _dtAborto = snapshotData['dtAborto'] as String?;
    _uidPropriedade = snapshotData['uidPropriedade'] as DocumentReference?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('acoes')
          : FirebaseFirestore.instance.collectionGroup('acoes');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('acoes').doc(id);

  static Stream<AcoesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AcoesRecord.fromSnapshot(s));

  static Future<AcoesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AcoesRecord.fromSnapshot(s));

  static AcoesRecord fromSnapshot(DocumentSnapshot snapshot) => AcoesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AcoesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AcoesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AcoesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AcoesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAcoesRecordData({
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
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'uidAnimalAnimaisProdutores': uidAnimalAnimaisProdutores,
      'nomeAnimal': nomeAnimal,
      'acao': acao,
      'obsVisita': obsVisita,
      'touroInseminacao': touroInseminacao,
      'dataVisita': dataVisita,
      'dataPartoPrevisto': dataPartoPrevisto,
      'dataSecPrevista': dataSecPrevista,
      'dataPrePartoPrevista': dataPrePartoPrevista,
      'dataDaAcao': dataDaAcao,
      'dtPP': dtPP,
      'dtDgMais': dtDgMais,
      'dtDgMenos': dtDgMenos,
      'dtAborto': dtAborto,
      'uidPropriedade': uidPropriedade,
    }.withoutNulls,
  );

  return firestoreData;
}

class AcoesRecordDocumentEquality implements Equality<AcoesRecord> {
  const AcoesRecordDocumentEquality();

  @override
  bool equals(AcoesRecord? e1, AcoesRecord? e2) {
    return e1?.uidAnimalAnimaisProdutores == e2?.uidAnimalAnimaisProdutores &&
        e1?.nomeAnimal == e2?.nomeAnimal &&
        e1?.acao == e2?.acao &&
        e1?.obsVisita == e2?.obsVisita &&
        e1?.touroInseminacao == e2?.touroInseminacao &&
        e1?.dataVisita == e2?.dataVisita &&
        e1?.dataPartoPrevisto == e2?.dataPartoPrevisto &&
        e1?.dataSecPrevista == e2?.dataSecPrevista &&
        e1?.dataPrePartoPrevista == e2?.dataPrePartoPrevista &&
        e1?.dataDaAcao == e2?.dataDaAcao &&
        e1?.dtPP == e2?.dtPP &&
        e1?.dtDgMais == e2?.dtDgMais &&
        e1?.dtDgMenos == e2?.dtDgMenos &&
        e1?.dtAborto == e2?.dtAborto &&
        e1?.uidPropriedade == e2?.uidPropriedade;
  }

  @override
  int hash(AcoesRecord? e) => const ListEquality().hash([
        e?.uidAnimalAnimaisProdutores,
        e?.nomeAnimal,
        e?.acao,
        e?.obsVisita,
        e?.touroInseminacao,
        e?.dataVisita,
        e?.dataPartoPrevisto,
        e?.dataSecPrevista,
        e?.dataPrePartoPrevista,
        e?.dataDaAcao,
        e?.dtPP,
        e?.dtDgMais,
        e?.dtDgMenos,
        e?.dtAborto,
        e?.uidPropriedade
      ]);

  @override
  bool isValidKey(Object? o) => o is AcoesRecord;
}
