import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CalendarioSanitarioRecord extends FirestoreRecord {
  CalendarioSanitarioRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  bool hasDescricao() => _descricao != null;

  // "tipo" field.
  String? _tipo;
  String get tipo => _tipo ?? '';
  bool hasTipo() => _tipo != null;

  void _initializeFields() {
    _descricao = snapshotData['descricao'] as String?;
    _tipo = snapshotData['tipo'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('calendario_sanitario');

  static Stream<CalendarioSanitarioRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CalendarioSanitarioRecord.fromSnapshot(s));

  static Future<CalendarioSanitarioRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => CalendarioSanitarioRecord.fromSnapshot(s));

  static CalendarioSanitarioRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CalendarioSanitarioRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CalendarioSanitarioRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CalendarioSanitarioRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CalendarioSanitarioRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CalendarioSanitarioRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCalendarioSanitarioRecordData({
  String? descricao,
  String? tipo,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'descricao': descricao,
      'tipo': tipo,
    }.withoutNulls,
  );

  return firestoreData;
}

class CalendarioSanitarioRecordDocumentEquality
    implements Equality<CalendarioSanitarioRecord> {
  const CalendarioSanitarioRecordDocumentEquality();

  @override
  bool equals(CalendarioSanitarioRecord? e1, CalendarioSanitarioRecord? e2) {
    return e1?.descricao == e2?.descricao && e1?.tipo == e2?.tipo;
  }

  @override
  int hash(CalendarioSanitarioRecord? e) =>
      const ListEquality().hash([e?.descricao, e?.tipo]);

  @override
  bool isValidKey(Object? o) => o is CalendarioSanitarioRecord;
}
