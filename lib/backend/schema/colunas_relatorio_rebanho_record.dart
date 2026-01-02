import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ColunasRelatorioRebanhoRecord extends FirestoreRecord {
  ColunasRelatorioRebanhoRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  bool hasDescricao() => _descricao != null;

  // "liberado" field.
  bool? _liberado;
  bool get liberado => _liberado ?? false;
  bool hasLiberado() => _liberado != null;

  void _initializeFields() {
    _descricao = snapshotData['descricao'] as String?;
    _liberado = snapshotData['liberado'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('colunas_relatorio_rebanho');

  static Stream<ColunasRelatorioRebanhoRecord> getDocument(
          DocumentReference ref) =>
      ref.snapshots().map((s) => ColunasRelatorioRebanhoRecord.fromSnapshot(s));

  static Future<ColunasRelatorioRebanhoRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => ColunasRelatorioRebanhoRecord.fromSnapshot(s));

  static ColunasRelatorioRebanhoRecord fromSnapshot(
          DocumentSnapshot snapshot) =>
      ColunasRelatorioRebanhoRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ColunasRelatorioRebanhoRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ColunasRelatorioRebanhoRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ColunasRelatorioRebanhoRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ColunasRelatorioRebanhoRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createColunasRelatorioRebanhoRecordData({
  String? descricao,
  bool? liberado,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'descricao': descricao,
      'liberado': liberado,
    }.withoutNulls,
  );

  return firestoreData;
}

class ColunasRelatorioRebanhoRecordDocumentEquality
    implements Equality<ColunasRelatorioRebanhoRecord> {
  const ColunasRelatorioRebanhoRecordDocumentEquality();

  @override
  bool equals(
      ColunasRelatorioRebanhoRecord? e1, ColunasRelatorioRebanhoRecord? e2) {
    return e1?.descricao == e2?.descricao && e1?.liberado == e2?.liberado;
  }

  @override
  int hash(ColunasRelatorioRebanhoRecord? e) =>
      const ListEquality().hash([e?.descricao, e?.liberado]);

  @override
  bool isValidKey(Object? o) => o is ColunasRelatorioRebanhoRecord;
}
