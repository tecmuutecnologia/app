import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CidadesRecord extends FirestoreRecord {
  CidadesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  bool hasNome() => _nome != null;

  // "nomeuf" field.
  String? _nomeuf;
  String get nomeuf => _nomeuf ?? '';
  bool hasNomeuf() => _nomeuf != null;

  void _initializeFields() {
    _nome = snapshotData['nome'] as String?;
    _nomeuf = snapshotData['nomeuf'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('cidades');

  static Stream<CidadesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CidadesRecord.fromSnapshot(s));

  static Future<CidadesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CidadesRecord.fromSnapshot(s));

  static CidadesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CidadesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CidadesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CidadesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CidadesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CidadesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCidadesRecordData({
  String? nome,
  String? nomeuf,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nome': nome,
      'nomeuf': nomeuf,
    }.withoutNulls,
  );

  return firestoreData;
}

class CidadesRecordDocumentEquality implements Equality<CidadesRecord> {
  const CidadesRecordDocumentEquality();

  @override
  bool equals(CidadesRecord? e1, CidadesRecord? e2) {
    return e1?.nome == e2?.nome && e1?.nomeuf == e2?.nomeuf;
  }

  @override
  int hash(CidadesRecord? e) => const ListEquality().hash([e?.nome, e?.nomeuf]);

  @override
  bool isValidKey(Object? o) => o is CidadesRecord;
}
