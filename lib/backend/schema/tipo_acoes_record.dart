import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TipoAcoesRecord extends FirestoreRecord {
  TipoAcoesRecord._(
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
      FirebaseFirestore.instance.collection('tipo_acoes');

  static Stream<TipoAcoesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TipoAcoesRecord.fromSnapshot(s));

  static Future<TipoAcoesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TipoAcoesRecord.fromSnapshot(s));

  static TipoAcoesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      TipoAcoesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TipoAcoesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      TipoAcoesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TipoAcoesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TipoAcoesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTipoAcoesRecordData({
  String? descricao,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'descricao': descricao,
    }.withoutNulls,
  );

  return firestoreData;
}

class TipoAcoesRecordDocumentEquality implements Equality<TipoAcoesRecord> {
  const TipoAcoesRecordDocumentEquality();

  @override
  bool equals(TipoAcoesRecord? e1, TipoAcoesRecord? e2) {
    return e1?.descricao == e2?.descricao;
  }

  @override
  int hash(TipoAcoesRecord? e) => const ListEquality().hash([e?.descricao]);

  @override
  bool isValidKey(Object? o) => o is TipoAcoesRecord;
}
