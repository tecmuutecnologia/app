import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AssinaturaProdutorRecord extends FirestoreRecord {
  AssinaturaProdutorRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "idPlano" field.
  DocumentReference? _idPlano;
  DocumentReference? get idPlano => _idPlano;
  bool hasIdPlano() => _idPlano != null;

  // "dtAssinatura" field.
  DateTime? _dtAssinatura;
  DateTime? get dtAssinatura => _dtAssinatura;
  bool hasDtAssinatura() => _dtAssinatura != null;

  // "tipoPlano" field.
  String? _tipoPlano;
  String get tipoPlano => _tipoPlano ?? '';
  bool hasTipoPlano() => _tipoPlano != null;

  // "dtExpiracao" field.
  String? _dtExpiracao;
  String get dtExpiracao => _dtExpiracao ?? '';
  bool hasDtExpiracao() => _dtExpiracao != null;

  // "idProdutor" field.
  DocumentReference? _idProdutor;
  DocumentReference? get idProdutor => _idProdutor;
  bool hasIdProdutor() => _idProdutor != null;

  void _initializeFields() {
    _idPlano = snapshotData['idPlano'] as DocumentReference?;
    _dtAssinatura = snapshotData['dtAssinatura'] as DateTime?;
    _tipoPlano = snapshotData['tipoPlano'] as String?;
    _dtExpiracao = snapshotData['dtExpiracao'] as String?;
    _idProdutor = snapshotData['idProdutor'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('assinatura-produtor');

  static Stream<AssinaturaProdutorRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AssinaturaProdutorRecord.fromSnapshot(s));

  static Future<AssinaturaProdutorRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => AssinaturaProdutorRecord.fromSnapshot(s));

  static AssinaturaProdutorRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AssinaturaProdutorRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AssinaturaProdutorRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AssinaturaProdutorRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AssinaturaProdutorRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AssinaturaProdutorRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAssinaturaProdutorRecordData({
  DocumentReference? idPlano,
  DateTime? dtAssinatura,
  String? tipoPlano,
  String? dtExpiracao,
  DocumentReference? idProdutor,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'idPlano': idPlano,
      'dtAssinatura': dtAssinatura,
      'tipoPlano': tipoPlano,
      'dtExpiracao': dtExpiracao,
      'idProdutor': idProdutor,
    }.withoutNulls,
  );

  return firestoreData;
}

class AssinaturaProdutorRecordDocumentEquality
    implements Equality<AssinaturaProdutorRecord> {
  const AssinaturaProdutorRecordDocumentEquality();

  @override
  bool equals(AssinaturaProdutorRecord? e1, AssinaturaProdutorRecord? e2) {
    return e1?.idPlano == e2?.idPlano &&
        e1?.dtAssinatura == e2?.dtAssinatura &&
        e1?.tipoPlano == e2?.tipoPlano &&
        e1?.dtExpiracao == e2?.dtExpiracao &&
        e1?.idProdutor == e2?.idProdutor;
  }

  @override
  int hash(AssinaturaProdutorRecord? e) => const ListEquality().hash([
        e?.idPlano,
        e?.dtAssinatura,
        e?.tipoPlano,
        e?.dtExpiracao,
        e?.idProdutor
      ]);

  @override
  bool isValidKey(Object? o) => o is AssinaturaProdutorRecord;
}
