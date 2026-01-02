import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GrupoRecord extends FirestoreRecord {
  GrupoRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  bool hasDescricao() => _descricao != null;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  bool hasId() => _id != null;

  void _initializeFields() {
    _descricao = snapshotData['descricao'] as String?;
    _id = castToType<int>(snapshotData['id']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('grupo');

  static Stream<GrupoRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => GrupoRecord.fromSnapshot(s));

  static Future<GrupoRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => GrupoRecord.fromSnapshot(s));

  static GrupoRecord fromSnapshot(DocumentSnapshot snapshot) => GrupoRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static GrupoRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      GrupoRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'GrupoRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is GrupoRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createGrupoRecordData({
  String? descricao,
  int? id,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'descricao': descricao,
      'id': id,
    }.withoutNulls,
  );

  return firestoreData;
}

class GrupoRecordDocumentEquality implements Equality<GrupoRecord> {
  const GrupoRecordDocumentEquality();

  @override
  bool equals(GrupoRecord? e1, GrupoRecord? e2) {
    return e1?.descricao == e2?.descricao && e1?.id == e2?.id;
  }

  @override
  int hash(GrupoRecord? e) => const ListEquality().hash([e?.descricao, e?.id]);

  @override
  bool isValidKey(Object? o) => o is GrupoRecord;
}
