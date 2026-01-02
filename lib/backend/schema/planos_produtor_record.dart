import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PlanosProdutorRecord extends FirestoreRecord {
  PlanosProdutorRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  bool hasNome() => _nome != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  bool hasDescricao() => _descricao != null;

  // "preco" field.
  String? _preco;
  String get preco => _preco ?? '';
  bool hasPreco() => _preco != null;

  // "limiteAnimais" field.
  int? _limiteAnimais;
  int get limiteAnimais => _limiteAnimais ?? 0;
  bool hasLimiteAnimais() => _limiteAnimais != null;

  // "precotest" field.
  double? _precotest;
  double get precotest => _precotest ?? 0.0;
  bool hasPrecotest() => _precotest != null;

  void _initializeFields() {
    _nome = snapshotData['nome'] as String?;
    _descricao = snapshotData['descricao'] as String?;
    _preco = snapshotData['preco'] as String?;
    _limiteAnimais = castToType<int>(snapshotData['limiteAnimais']);
    _precotest = castToType<double>(snapshotData['precotest']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('planos-produtor');

  static Stream<PlanosProdutorRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PlanosProdutorRecord.fromSnapshot(s));

  static Future<PlanosProdutorRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PlanosProdutorRecord.fromSnapshot(s));

  static PlanosProdutorRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PlanosProdutorRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PlanosProdutorRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PlanosProdutorRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PlanosProdutorRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PlanosProdutorRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPlanosProdutorRecordData({
  String? nome,
  String? descricao,
  String? preco,
  int? limiteAnimais,
  double? precotest,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'limiteAnimais': limiteAnimais,
      'precotest': precotest,
    }.withoutNulls,
  );

  return firestoreData;
}

class PlanosProdutorRecordDocumentEquality
    implements Equality<PlanosProdutorRecord> {
  const PlanosProdutorRecordDocumentEquality();

  @override
  bool equals(PlanosProdutorRecord? e1, PlanosProdutorRecord? e2) {
    return e1?.nome == e2?.nome &&
        e1?.descricao == e2?.descricao &&
        e1?.preco == e2?.preco &&
        e1?.limiteAnimais == e2?.limiteAnimais &&
        e1?.precotest == e2?.precotest;
  }

  @override
  int hash(PlanosProdutorRecord? e) => const ListEquality()
      .hash([e?.nome, e?.descricao, e?.preco, e?.limiteAnimais, e?.precotest]);

  @override
  bool isValidKey(Object? o) => o is PlanosProdutorRecord;
}
