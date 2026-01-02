import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PlanosTecnicosRecord extends FirestoreRecord {
  PlanosTecnicosRecord._(
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

  // "limiteAnimais" field.
  int? _limiteAnimais;
  int get limiteAnimais => _limiteAnimais ?? 0;
  bool hasLimiteAnimais() => _limiteAnimais != null;

  // "limitePropriedade" field.
  int? _limitePropriedade;
  int get limitePropriedade => _limitePropriedade ?? 0;
  bool hasLimitePropriedade() => _limitePropriedade != null;

  // "preco" field.
  double? _preco;
  double get preco => _preco ?? 0.0;
  bool hasPreco() => _preco != null;

  void _initializeFields() {
    _nome = snapshotData['nome'] as String?;
    _descricao = snapshotData['descricao'] as String?;
    _limiteAnimais = castToType<int>(snapshotData['limiteAnimais']);
    _limitePropriedade = castToType<int>(snapshotData['limitePropriedade']);
    _preco = castToType<double>(snapshotData['preco']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('planos-tecnicos');

  static Stream<PlanosTecnicosRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PlanosTecnicosRecord.fromSnapshot(s));

  static Future<PlanosTecnicosRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PlanosTecnicosRecord.fromSnapshot(s));

  static PlanosTecnicosRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PlanosTecnicosRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PlanosTecnicosRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PlanosTecnicosRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PlanosTecnicosRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PlanosTecnicosRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPlanosTecnicosRecordData({
  String? nome,
  String? descricao,
  int? limiteAnimais,
  int? limitePropriedade,
  double? preco,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nome': nome,
      'descricao': descricao,
      'limiteAnimais': limiteAnimais,
      'limitePropriedade': limitePropriedade,
      'preco': preco,
    }.withoutNulls,
  );

  return firestoreData;
}

class PlanosTecnicosRecordDocumentEquality
    implements Equality<PlanosTecnicosRecord> {
  const PlanosTecnicosRecordDocumentEquality();

  @override
  bool equals(PlanosTecnicosRecord? e1, PlanosTecnicosRecord? e2) {
    return e1?.nome == e2?.nome &&
        e1?.descricao == e2?.descricao &&
        e1?.limiteAnimais == e2?.limiteAnimais &&
        e1?.limitePropriedade == e2?.limitePropriedade &&
        e1?.preco == e2?.preco;
  }

  @override
  int hash(PlanosTecnicosRecord? e) => const ListEquality().hash([
        e?.nome,
        e?.descricao,
        e?.limiteAnimais,
        e?.limitePropriedade,
        e?.preco
      ]);

  @override
  bool isValidKey(Object? o) => o is PlanosTecnicosRecord;
}
