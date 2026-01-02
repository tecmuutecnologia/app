import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TratamentosRecord extends FirestoreRecord {
  TratamentosRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "uidTratamentos" field.
  DocumentReference? _uidTratamentos;
  DocumentReference? get uidTratamentos => _uidTratamentos;
  bool hasUidTratamentos() => _uidTratamentos != null;

  // "uidAnimal" field.
  DocumentReference? _uidAnimal;
  DocumentReference? get uidAnimal => _uidAnimal;
  bool hasUidAnimal() => _uidAnimal != null;

  // "tipoAcao" field.
  String? _tipoAcao;
  String get tipoAcao => _tipoAcao ?? '';
  bool hasTipoAcao() => _tipoAcao != null;

  // "uidResumoDaVisita" field.
  DocumentReference? _uidResumoDaVisita;
  DocumentReference? get uidResumoDaVisita => _uidResumoDaVisita;
  bool hasUidResumoDaVisita() => _uidResumoDaVisita != null;

  // "observacaoAcao" field.
  String? _observacaoAcao;
  String get observacaoAcao => _observacaoAcao ?? '';
  bool hasObservacaoAcao() => _observacaoAcao != null;

  // "nomeAnimal" field.
  String? _nomeAnimal;
  String get nomeAnimal => _nomeAnimal ?? '';
  bool hasNomeAnimal() => _nomeAnimal != null;

  // "dtAcaoTratamento" field.
  String? _dtAcaoTratamento;
  String get dtAcaoTratamento => _dtAcaoTratamento ?? '';
  bool hasDtAcaoTratamento() => _dtAcaoTratamento != null;

  // "grupoAnimal" field.
  String? _grupoAnimal;
  String get grupoAnimal => _grupoAnimal ?? '';
  bool hasGrupoAnimal() => _grupoAnimal != null;

  // "uidAcaoLancada" field.
  DocumentReference? _uidAcaoLancada;
  DocumentReference? get uidAcaoLancada => _uidAcaoLancada;
  bool hasUidAcaoLancada() => _uidAcaoLancada != null;

  // "brincoAnimal" field.
  String? _brincoAnimal;
  String get brincoAnimal => _brincoAnimal ?? '';
  bool hasBrincoAnimal() => _brincoAnimal != null;

  // "brincoAnimalOrder" field.
  int? _brincoAnimalOrder;
  int get brincoAnimalOrder => _brincoAnimalOrder ?? 0;
  bool hasBrincoAnimalOrder() => _brincoAnimalOrder != null;

  // "compararDtUltimaInseminacao" field.
  DateTime? _compararDtUltimaInseminacao;
  DateTime? get compararDtUltimaInseminacao => _compararDtUltimaInseminacao;
  bool hasCompararDtUltimaInseminacao() => _compararDtUltimaInseminacao != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _uidTratamentos = snapshotData['uidTratamentos'] as DocumentReference?;
    _uidAnimal = snapshotData['uidAnimal'] as DocumentReference?;
    _tipoAcao = snapshotData['tipoAcao'] as String?;
    _uidResumoDaVisita =
        snapshotData['uidResumoDaVisita'] as DocumentReference?;
    _observacaoAcao = snapshotData['observacaoAcao'] as String?;
    _nomeAnimal = snapshotData['nomeAnimal'] as String?;
    _dtAcaoTratamento = snapshotData['dtAcaoTratamento'] as String?;
    _grupoAnimal = snapshotData['grupoAnimal'] as String?;
    _uidAcaoLancada = snapshotData['uidAcaoLancada'] as DocumentReference?;
    _brincoAnimal = snapshotData['brincoAnimal'] as String?;
    _brincoAnimalOrder = castToType<int>(snapshotData['brincoAnimalOrder']);
    _compararDtUltimaInseminacao =
        snapshotData['compararDtUltimaInseminacao'] as DateTime?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('tratamentos')
          : FirebaseFirestore.instance.collectionGroup('tratamentos');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('tratamentos').doc(id);

  static Stream<TratamentosRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TratamentosRecord.fromSnapshot(s));

  static Future<TratamentosRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TratamentosRecord.fromSnapshot(s));

  static TratamentosRecord fromSnapshot(DocumentSnapshot snapshot) =>
      TratamentosRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TratamentosRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      TratamentosRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TratamentosRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TratamentosRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTratamentosRecordData({
  DocumentReference? uidTratamentos,
  DocumentReference? uidAnimal,
  String? tipoAcao,
  DocumentReference? uidResumoDaVisita,
  String? observacaoAcao,
  String? nomeAnimal,
  String? dtAcaoTratamento,
  String? grupoAnimal,
  DocumentReference? uidAcaoLancada,
  String? brincoAnimal,
  int? brincoAnimalOrder,
  DateTime? compararDtUltimaInseminacao,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'uidTratamentos': uidTratamentos,
      'uidAnimal': uidAnimal,
      'tipoAcao': tipoAcao,
      'uidResumoDaVisita': uidResumoDaVisita,
      'observacaoAcao': observacaoAcao,
      'nomeAnimal': nomeAnimal,
      'dtAcaoTratamento': dtAcaoTratamento,
      'grupoAnimal': grupoAnimal,
      'uidAcaoLancada': uidAcaoLancada,
      'brincoAnimal': brincoAnimal,
      'brincoAnimalOrder': brincoAnimalOrder,
      'compararDtUltimaInseminacao': compararDtUltimaInseminacao,
    }.withoutNulls,
  );

  return firestoreData;
}

class TratamentosRecordDocumentEquality implements Equality<TratamentosRecord> {
  const TratamentosRecordDocumentEquality();

  @override
  bool equals(TratamentosRecord? e1, TratamentosRecord? e2) {
    return e1?.uidTratamentos == e2?.uidTratamentos &&
        e1?.uidAnimal == e2?.uidAnimal &&
        e1?.tipoAcao == e2?.tipoAcao &&
        e1?.uidResumoDaVisita == e2?.uidResumoDaVisita &&
        e1?.observacaoAcao == e2?.observacaoAcao &&
        e1?.nomeAnimal == e2?.nomeAnimal &&
        e1?.dtAcaoTratamento == e2?.dtAcaoTratamento &&
        e1?.grupoAnimal == e2?.grupoAnimal &&
        e1?.uidAcaoLancada == e2?.uidAcaoLancada &&
        e1?.brincoAnimal == e2?.brincoAnimal &&
        e1?.brincoAnimalOrder == e2?.brincoAnimalOrder &&
        e1?.compararDtUltimaInseminacao == e2?.compararDtUltimaInseminacao;
  }

  @override
  int hash(TratamentosRecord? e) => const ListEquality().hash([
        e?.uidTratamentos,
        e?.uidAnimal,
        e?.tipoAcao,
        e?.uidResumoDaVisita,
        e?.observacaoAcao,
        e?.nomeAnimal,
        e?.dtAcaoTratamento,
        e?.grupoAnimal,
        e?.uidAcaoLancada,
        e?.brincoAnimal,
        e?.brincoAnimalOrder,
        e?.compararDtUltimaInseminacao
      ]);

  @override
  bool isValidKey(Object? o) => o is TratamentosRecord;
}
