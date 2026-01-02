import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EmpresasRecord extends FirestoreRecord {
  EmpresasRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  bool hasNome() => _nome != null;

  // "razaoSocial" field.
  String? _razaoSocial;
  String get razaoSocial => _razaoSocial ?? '';
  bool hasRazaoSocial() => _razaoSocial != null;

  // "cnpj" field.
  String? _cnpj;
  String get cnpj => _cnpj ?? '';
  bool hasCnpj() => _cnpj != null;

  void _initializeFields() {
    _nome = snapshotData['nome'] as String?;
    _razaoSocial = snapshotData['razaoSocial'] as String?;
    _cnpj = snapshotData['cnpj'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('empresas');

  static Stream<EmpresasRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => EmpresasRecord.fromSnapshot(s));

  static Future<EmpresasRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => EmpresasRecord.fromSnapshot(s));

  static EmpresasRecord fromSnapshot(DocumentSnapshot snapshot) =>
      EmpresasRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static EmpresasRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      EmpresasRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'EmpresasRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is EmpresasRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createEmpresasRecordData({
  String? nome,
  String? razaoSocial,
  String? cnpj,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nome': nome,
      'razaoSocial': razaoSocial,
      'cnpj': cnpj,
    }.withoutNulls,
  );

  return firestoreData;
}

class EmpresasRecordDocumentEquality implements Equality<EmpresasRecord> {
  const EmpresasRecordDocumentEquality();

  @override
  bool equals(EmpresasRecord? e1, EmpresasRecord? e2) {
    return e1?.nome == e2?.nome &&
        e1?.razaoSocial == e2?.razaoSocial &&
        e1?.cnpj == e2?.cnpj;
  }

  @override
  int hash(EmpresasRecord? e) =>
      const ListEquality().hash([e?.nome, e?.razaoSocial, e?.cnpj]);

  @override
  bool isValidKey(Object? o) => o is EmpresasRecord;
}
