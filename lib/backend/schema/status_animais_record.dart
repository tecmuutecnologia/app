import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StatusAnimaisRecord extends FirestoreRecord {
  StatusAnimaisRecord._(
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
      FirebaseFirestore.instance.collection('status_animais');

  static Stream<StatusAnimaisRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => StatusAnimaisRecord.fromSnapshot(s));

  static Future<StatusAnimaisRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => StatusAnimaisRecord.fromSnapshot(s));

  static StatusAnimaisRecord fromSnapshot(DocumentSnapshot snapshot) =>
      StatusAnimaisRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static StatusAnimaisRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      StatusAnimaisRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'StatusAnimaisRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is StatusAnimaisRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createStatusAnimaisRecordData({
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

class StatusAnimaisRecordDocumentEquality
    implements Equality<StatusAnimaisRecord> {
  const StatusAnimaisRecordDocumentEquality();

  @override
  bool equals(StatusAnimaisRecord? e1, StatusAnimaisRecord? e2) {
    return e1?.id == e2?.id && e1?.descricao == e2?.descricao;
  }

  @override
  int hash(StatusAnimaisRecord? e) =>
      const ListEquality().hash([e?.id, e?.descricao]);

  @override
  bool isValidKey(Object? o) => o is StatusAnimaisRecord;
}
