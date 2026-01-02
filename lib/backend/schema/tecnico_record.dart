import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TecnicoRecord extends FirestoreRecord {
  TecnicoRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "uidPerson" field.
  String? _uidPerson;
  String get uidPerson => _uidPerson ?? '';
  bool hasUidPerson() => _uidPerson != null;

  // "liberado" field.
  bool? _liberado;
  bool get liberado => _liberado ?? false;
  bool hasLiberado() => _liberado != null;

  // "limiteProdutoresContratado" field.
  int? _limiteProdutoresContratado;
  int get limiteProdutoresContratado => _limiteProdutoresContratado ?? 0;
  bool hasLimiteProdutoresContratado() => _limiteProdutoresContratado != null;

  // "quantidadeProdutoresCadastrados" field.
  int? _quantidadeProdutoresCadastrados;
  int get quantidadeProdutoresCadastrados =>
      _quantidadeProdutoresCadastrados ?? 0;
  bool hasQuantidadeProdutoresCadastrados() =>
      _quantidadeProdutoresCadastrados != null;

  // "restanteLimiteProdutores" field.
  int? _restanteLimiteProdutores;
  int get restanteLimiteProdutores => _restanteLimiteProdutores ?? 0;
  bool hasRestanteLimiteProdutores() => _restanteLimiteProdutores != null;

  // "limiteAnimaisContratado" field.
  int? _limiteAnimaisContratado;
  int get limiteAnimaisContratado => _limiteAnimaisContratado ?? 0;
  bool hasLimiteAnimaisContratado() => _limiteAnimaisContratado != null;

  // "quantidadeAnimaisCadastrados" field.
  int? _quantidadeAnimaisCadastrados;
  int get quantidadeAnimaisCadastrados => _quantidadeAnimaisCadastrados ?? 0;
  bool hasQuantidadeAnimaisCadastrados() =>
      _quantidadeAnimaisCadastrados != null;

  // "restanteLimiteAnimais" field.
  int? _restanteLimiteAnimais;
  int get restanteLimiteAnimais => _restanteLimiteAnimais ?? 0;
  bool hasRestanteLimiteAnimais() => _restanteLimiteAnimais != null;

  void _initializeFields() {
    _uidPerson = snapshotData['uidPerson'] as String?;
    _liberado = snapshotData['liberado'] as bool?;
    _limiteProdutoresContratado =
        castToType<int>(snapshotData['limiteProdutoresContratado']);
    _quantidadeProdutoresCadastrados =
        castToType<int>(snapshotData['quantidadeProdutoresCadastrados']);
    _restanteLimiteProdutores =
        castToType<int>(snapshotData['restanteLimiteProdutores']);
    _limiteAnimaisContratado =
        castToType<int>(snapshotData['limiteAnimaisContratado']);
    _quantidadeAnimaisCadastrados =
        castToType<int>(snapshotData['quantidadeAnimaisCadastrados']);
    _restanteLimiteAnimais =
        castToType<int>(snapshotData['restanteLimiteAnimais']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('tecnico');

  static Stream<TecnicoRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TecnicoRecord.fromSnapshot(s));

  static Future<TecnicoRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TecnicoRecord.fromSnapshot(s));

  static TecnicoRecord fromSnapshot(DocumentSnapshot snapshot) =>
      TecnicoRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TecnicoRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      TecnicoRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TecnicoRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TecnicoRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTecnicoRecordData({
  String? uidPerson,
  bool? liberado,
  int? limiteProdutoresContratado,
  int? quantidadeProdutoresCadastrados,
  int? restanteLimiteProdutores,
  int? limiteAnimaisContratado,
  int? quantidadeAnimaisCadastrados,
  int? restanteLimiteAnimais,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'uidPerson': uidPerson,
      'liberado': liberado,
      'limiteProdutoresContratado': limiteProdutoresContratado,
      'quantidadeProdutoresCadastrados': quantidadeProdutoresCadastrados,
      'restanteLimiteProdutores': restanteLimiteProdutores,
      'limiteAnimaisContratado': limiteAnimaisContratado,
      'quantidadeAnimaisCadastrados': quantidadeAnimaisCadastrados,
      'restanteLimiteAnimais': restanteLimiteAnimais,
    }.withoutNulls,
  );

  return firestoreData;
}

class TecnicoRecordDocumentEquality implements Equality<TecnicoRecord> {
  const TecnicoRecordDocumentEquality();

  @override
  bool equals(TecnicoRecord? e1, TecnicoRecord? e2) {
    return e1?.uidPerson == e2?.uidPerson &&
        e1?.liberado == e2?.liberado &&
        e1?.limiteProdutoresContratado == e2?.limiteProdutoresContratado &&
        e1?.quantidadeProdutoresCadastrados ==
            e2?.quantidadeProdutoresCadastrados &&
        e1?.restanteLimiteProdutores == e2?.restanteLimiteProdutores &&
        e1?.limiteAnimaisContratado == e2?.limiteAnimaisContratado &&
        e1?.quantidadeAnimaisCadastrados == e2?.quantidadeAnimaisCadastrados &&
        e1?.restanteLimiteAnimais == e2?.restanteLimiteAnimais;
  }

  @override
  int hash(TecnicoRecord? e) => const ListEquality().hash([
        e?.uidPerson,
        e?.liberado,
        e?.limiteProdutoresContratado,
        e?.quantidadeProdutoresCadastrados,
        e?.restanteLimiteProdutores,
        e?.limiteAnimaisContratado,
        e?.quantidadeAnimaisCadastrados,
        e?.restanteLimiteAnimais
      ]);

  @override
  bool isValidKey(Object? o) => o is TecnicoRecord;
}
