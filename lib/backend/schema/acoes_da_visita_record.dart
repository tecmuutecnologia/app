import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AcoesDaVisitaRecord extends FirestoreRecord {
  AcoesDaVisitaRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "acao" field.
  String? _acao;
  String get acao => _acao ?? '';
  bool hasAcao() => _acao != null;

  // "dtAcao" field.
  String? _dtAcao;
  String get dtAcao => _dtAcao ?? '';
  bool hasDtAcao() => _dtAcao != null;

  // "dtVisita" field.
  DateTime? _dtVisita;
  DateTime? get dtVisita => _dtVisita;
  bool hasDtVisita() => _dtVisita != null;

  // "dtPP" field.
  String? _dtPP;
  String get dtPP => _dtPP ?? '';
  bool hasDtPP() => _dtPP != null;

  // "dtInseminacao" field.
  String? _dtInseminacao;
  String get dtInseminacao => _dtInseminacao ?? '';
  bool hasDtInseminacao() => _dtInseminacao != null;

  // "tourtoInseminacao" field.
  String? _tourtoInseminacao;
  String get tourtoInseminacao => _tourtoInseminacao ?? '';
  bool hasTourtoInseminacao() => _tourtoInseminacao != null;

  // "dtPartoPrevisto" field.
  String? _dtPartoPrevisto;
  String get dtPartoPrevisto => _dtPartoPrevisto ?? '';
  bool hasDtPartoPrevisto() => _dtPartoPrevisto != null;

  // "dtSecPrevista" field.
  String? _dtSecPrevista;
  String get dtSecPrevista => _dtSecPrevista ?? '';
  bool hasDtSecPrevista() => _dtSecPrevista != null;

  // "dtPrePartoPrevista" field.
  String? _dtPrePartoPrevista;
  String get dtPrePartoPrevista => _dtPrePartoPrevista ?? '';
  bool hasDtPrePartoPrevista() => _dtPrePartoPrevista != null;

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

  // "dtSecagem" field.
  String? _dtSecagem;
  String get dtSecagem => _dtSecagem ?? '';
  bool hasDtSecagem() => _dtSecagem != null;

  // "tratamento" field.
  String? _tratamento;
  String get tratamento => _tratamento ?? '';
  bool hasTratamento() => _tratamento != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _acao = snapshotData['acao'] as String?;
    _dtAcao = snapshotData['dtAcao'] as String?;
    _dtVisita = snapshotData['dtVisita'] as DateTime?;
    _dtPP = snapshotData['dtPP'] as String?;
    _dtInseminacao = snapshotData['dtInseminacao'] as String?;
    _tourtoInseminacao = snapshotData['tourtoInseminacao'] as String?;
    _dtPartoPrevisto = snapshotData['dtPartoPrevisto'] as String?;
    _dtSecPrevista = snapshotData['dtSecPrevista'] as String?;
    _dtPrePartoPrevista = snapshotData['dtPrePartoPrevista'] as String?;
    _dtDgMais = snapshotData['dtDgMais'] as String?;
    _dtDgMenos = snapshotData['dtDgMenos'] as String?;
    _dtAborto = snapshotData['dtAborto'] as String?;
    _dtSecagem = snapshotData['dtSecagem'] as String?;
    _tratamento = snapshotData['tratamento'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('acoes_da_visita')
          : FirebaseFirestore.instance.collectionGroup('acoes_da_visita');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('acoes_da_visita').doc(id);

  static Stream<AcoesDaVisitaRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AcoesDaVisitaRecord.fromSnapshot(s));

  static Future<AcoesDaVisitaRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AcoesDaVisitaRecord.fromSnapshot(s));

  static AcoesDaVisitaRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AcoesDaVisitaRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AcoesDaVisitaRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AcoesDaVisitaRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AcoesDaVisitaRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AcoesDaVisitaRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAcoesDaVisitaRecordData({
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
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'acao': acao,
      'dtAcao': dtAcao,
      'dtVisita': dtVisita,
      'dtPP': dtPP,
      'dtInseminacao': dtInseminacao,
      'tourtoInseminacao': tourtoInseminacao,
      'dtPartoPrevisto': dtPartoPrevisto,
      'dtSecPrevista': dtSecPrevista,
      'dtPrePartoPrevista': dtPrePartoPrevista,
      'dtDgMais': dtDgMais,
      'dtDgMenos': dtDgMenos,
      'dtAborto': dtAborto,
      'dtSecagem': dtSecagem,
      'tratamento': tratamento,
    }.withoutNulls,
  );

  return firestoreData;
}

class AcoesDaVisitaRecordDocumentEquality
    implements Equality<AcoesDaVisitaRecord> {
  const AcoesDaVisitaRecordDocumentEquality();

  @override
  bool equals(AcoesDaVisitaRecord? e1, AcoesDaVisitaRecord? e2) {
    return e1?.acao == e2?.acao &&
        e1?.dtAcao == e2?.dtAcao &&
        e1?.dtVisita == e2?.dtVisita &&
        e1?.dtPP == e2?.dtPP &&
        e1?.dtInseminacao == e2?.dtInseminacao &&
        e1?.tourtoInseminacao == e2?.tourtoInseminacao &&
        e1?.dtPartoPrevisto == e2?.dtPartoPrevisto &&
        e1?.dtSecPrevista == e2?.dtSecPrevista &&
        e1?.dtPrePartoPrevista == e2?.dtPrePartoPrevista &&
        e1?.dtDgMais == e2?.dtDgMais &&
        e1?.dtDgMenos == e2?.dtDgMenos &&
        e1?.dtAborto == e2?.dtAborto &&
        e1?.dtSecagem == e2?.dtSecagem &&
        e1?.tratamento == e2?.tratamento;
  }

  @override
  int hash(AcoesDaVisitaRecord? e) => const ListEquality().hash([
        e?.acao,
        e?.dtAcao,
        e?.dtVisita,
        e?.dtPP,
        e?.dtInseminacao,
        e?.tourtoInseminacao,
        e?.dtPartoPrevisto,
        e?.dtSecPrevista,
        e?.dtPrePartoPrevista,
        e?.dtDgMais,
        e?.dtDgMenos,
        e?.dtAborto,
        e?.dtSecagem,
        e?.tratamento
      ]);

  @override
  bool isValidKey(Object? o) => o is AcoesDaVisitaRecord;
}
