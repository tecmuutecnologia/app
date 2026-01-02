import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AcoesSanitarioRecord extends FirestoreRecord {
  AcoesSanitarioRecord._(
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

  // "uidPersonProdutor" field.
  DocumentReference? _uidPersonProdutor;
  DocumentReference? get uidPersonProdutor => _uidPersonProdutor;
  bool hasUidPersonProdutor() => _uidPersonProdutor != null;

  // "obsVisita" field.
  String? _obsVisita;
  String get obsVisita => _obsVisita ?? '';
  bool hasObsVisita() => _obsVisita != null;

  // "tipoAcao" field.
  String? _tipoAcao;
  String get tipoAcao => _tipoAcao ?? '';
  bool hasTipoAcao() => _tipoAcao != null;

  // "acao" field.
  String? _acao;
  String get acao => _acao ?? '';
  bool hasAcao() => _acao != null;

  // "uidPropriedade" field.
  DocumentReference? _uidPropriedade;
  DocumentReference? get uidPropriedade => _uidPropriedade;
  bool hasUidPropriedade() => _uidPropriedade != null;

  // "dtAcao" field.
  String? _dtAcao;
  String get dtAcao => _dtAcao ?? '';
  bool hasDtAcao() => _dtAcao != null;

  // "nomeAnimal" field.
  String? _nomeAnimal;
  String get nomeAnimal => _nomeAnimal ?? '';
  bool hasNomeAnimal() => _nomeAnimal != null;

  // "brincoAnimal" field.
  String? _brincoAnimal;
  String get brincoAnimal => _brincoAnimal ?? '';
  bool hasBrincoAnimal() => _brincoAnimal != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _uidAnimalAnimaisProdutores =
        snapshotData['uidAnimalAnimaisProdutores'] as DocumentReference?;
    _uidPersonProdutor =
        snapshotData['uidPersonProdutor'] as DocumentReference?;
    _obsVisita = snapshotData['obsVisita'] as String?;
    _tipoAcao = snapshotData['tipoAcao'] as String?;
    _acao = snapshotData['acao'] as String?;
    _uidPropriedade = snapshotData['uidPropriedade'] as DocumentReference?;
    _dtAcao = snapshotData['dtAcao'] as String?;
    _nomeAnimal = snapshotData['nomeAnimal'] as String?;
    _brincoAnimal = snapshotData['brincoAnimal'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('acoesSanitario')
          : FirebaseFirestore.instance.collectionGroup('acoesSanitario');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('acoesSanitario').doc(id);

  static Stream<AcoesSanitarioRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AcoesSanitarioRecord.fromSnapshot(s));

  static Future<AcoesSanitarioRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AcoesSanitarioRecord.fromSnapshot(s));

  static AcoesSanitarioRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AcoesSanitarioRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AcoesSanitarioRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AcoesSanitarioRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AcoesSanitarioRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AcoesSanitarioRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAcoesSanitarioRecordData({
  DocumentReference? uidAnimalAnimaisProdutores,
  DocumentReference? uidPersonProdutor,
  String? obsVisita,
  String? tipoAcao,
  String? acao,
  DocumentReference? uidPropriedade,
  String? dtAcao,
  String? nomeAnimal,
  String? brincoAnimal,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'uidAnimalAnimaisProdutores': uidAnimalAnimaisProdutores,
      'uidPersonProdutor': uidPersonProdutor,
      'obsVisita': obsVisita,
      'tipoAcao': tipoAcao,
      'acao': acao,
      'uidPropriedade': uidPropriedade,
      'dtAcao': dtAcao,
      'nomeAnimal': nomeAnimal,
      'brincoAnimal': brincoAnimal,
    }.withoutNulls,
  );

  return firestoreData;
}

class AcoesSanitarioRecordDocumentEquality
    implements Equality<AcoesSanitarioRecord> {
  const AcoesSanitarioRecordDocumentEquality();

  @override
  bool equals(AcoesSanitarioRecord? e1, AcoesSanitarioRecord? e2) {
    return e1?.uidAnimalAnimaisProdutores == e2?.uidAnimalAnimaisProdutores &&
        e1?.uidPersonProdutor == e2?.uidPersonProdutor &&
        e1?.obsVisita == e2?.obsVisita &&
        e1?.tipoAcao == e2?.tipoAcao &&
        e1?.acao == e2?.acao &&
        e1?.uidPropriedade == e2?.uidPropriedade &&
        e1?.dtAcao == e2?.dtAcao &&
        e1?.nomeAnimal == e2?.nomeAnimal &&
        e1?.brincoAnimal == e2?.brincoAnimal;
  }

  @override
  int hash(AcoesSanitarioRecord? e) => const ListEquality().hash([
        e?.uidAnimalAnimaisProdutores,
        e?.uidPersonProdutor,
        e?.obsVisita,
        e?.tipoAcao,
        e?.acao,
        e?.uidPropriedade,
        e?.dtAcao,
        e?.nomeAnimal,
        e?.brincoAnimal
      ]);

  @override
  bool isValidKey(Object? o) => o is AcoesSanitarioRecord;
}
