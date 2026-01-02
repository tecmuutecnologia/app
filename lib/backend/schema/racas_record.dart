import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RacasRecord extends FirestoreRecord {
  RacasRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  bool hasDescricao() => _descricao != null;

  void _initializeFields() {
    _descricao = snapshotData['descricao'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('racas');

  static Stream<RacasRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RacasRecord.fromSnapshot(s));

  static Future<RacasRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RacasRecord.fromSnapshot(s));

  static RacasRecord fromSnapshot(DocumentSnapshot snapshot) => RacasRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RacasRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RacasRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RacasRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RacasRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRacasRecordData({
  String? descricao,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'descricao': descricao,
    }.withoutNulls,
  );

  return firestoreData;
}

class RacasRecordDocumentEquality implements Equality<RacasRecord> {
  const RacasRecordDocumentEquality();

  @override
  bool equals(RacasRecord? e1, RacasRecord? e2) {
    return e1?.descricao == e2?.descricao;
  }

  @override
  int hash(RacasRecord? e) => const ListEquality().hash([e?.descricao]);

  @override
  bool isValidKey(Object? o) => o is RacasRecord;
}
