import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StatusProdutivoRecord extends FirestoreRecord {
  StatusProdutivoRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  bool hasId() => _id != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  bool hasDescricao() => _descricao != null;

  void _initializeFields() {
    _id = castToType<int>(snapshotData['id']);
    _descricao = snapshotData['descricao'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('status_produtivo');

  static Stream<StatusProdutivoRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => StatusProdutivoRecord.fromSnapshot(s));

  static Future<StatusProdutivoRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => StatusProdutivoRecord.fromSnapshot(s));

  static StatusProdutivoRecord fromSnapshot(DocumentSnapshot snapshot) =>
      StatusProdutivoRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static StatusProdutivoRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      StatusProdutivoRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'StatusProdutivoRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is StatusProdutivoRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createStatusProdutivoRecordData({
  int? id,
  String? descricao,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'id': id,
      'descricao': descricao,
    }.withoutNulls,
  );

  return firestoreData;
}

class StatusProdutivoRecordDocumentEquality
    implements Equality<StatusProdutivoRecord> {
  const StatusProdutivoRecordDocumentEquality();

  @override
  bool equals(StatusProdutivoRecord? e1, StatusProdutivoRecord? e2) {
    return e1?.id == e2?.id && e1?.descricao == e2?.descricao;
  }

  @override
  int hash(StatusProdutivoRecord? e) =>
      const ListEquality().hash([e?.id, e?.descricao]);

  @override
  bool isValidKey(Object? o) => o is StatusProdutivoRecord;
}
