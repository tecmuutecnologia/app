import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProdutorRecord extends FirestoreRecord {
  ProdutorRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "liberado" field.
  bool? _liberado;
  bool get liberado => _liberado ?? false;
  bool hasLiberado() => _liberado != null;

  // "uidTecnico" field.
  DocumentReference? _uidTecnico;
  DocumentReference? get uidTecnico => _uidTecnico;
  bool hasUidTecnico() => _uidTecnico != null;

  // "uidPerson" field.
  DocumentReference? _uidPerson;
  DocumentReference? get uidPerson => _uidPerson;
  bool hasUidPerson() => _uidPerson != null;

  void _initializeFields() {
    _liberado = snapshotData['liberado'] as bool?;
    _uidTecnico = snapshotData['uidTecnico'] as DocumentReference?;
    _uidPerson = snapshotData['uidPerson'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('produtor');

  static Stream<ProdutorRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ProdutorRecord.fromSnapshot(s));

  static Future<ProdutorRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ProdutorRecord.fromSnapshot(s));

  static ProdutorRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ProdutorRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ProdutorRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ProdutorRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ProdutorRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ProdutorRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createProdutorRecordData({
  bool? liberado,
  DocumentReference? uidTecnico,
  DocumentReference? uidPerson,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'liberado': liberado,
      'uidTecnico': uidTecnico,
      'uidPerson': uidPerson,
    }.withoutNulls,
  );

  return firestoreData;
}

class ProdutorRecordDocumentEquality implements Equality<ProdutorRecord> {
  const ProdutorRecordDocumentEquality();

  @override
  bool equals(ProdutorRecord? e1, ProdutorRecord? e2) {
    return e1?.liberado == e2?.liberado &&
        e1?.uidTecnico == e2?.uidTecnico &&
        e1?.uidPerson == e2?.uidPerson;
  }

  @override
  int hash(ProdutorRecord? e) =>
      const ListEquality().hash([e?.liberado, e?.uidTecnico, e?.uidPerson]);

  @override
  bool isValidKey(Object? o) => o is ProdutorRecord;
}
