import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AssinaturaAtivaProdutorRecord extends FirestoreRecord {
  AssinaturaAtivaProdutorRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "tipoPlano" field.
  String? _tipoPlano;
  String get tipoPlano => _tipoPlano ?? '';
  bool hasTipoPlano() => _tipoPlano != null;

  // "dtAssinatura" field.
  DateTime? _dtAssinatura;
  DateTime? get dtAssinatura => _dtAssinatura;
  bool hasDtAssinatura() => _dtAssinatura != null;

  // "dtExpiracao" field.
  String? _dtExpiracao;
  String get dtExpiracao => _dtExpiracao ?? '';
  bool hasDtExpiracao() => _dtExpiracao != null;

  // "idAssinaturaProdutor" field.
  DocumentReference? _idAssinaturaProdutor;
  DocumentReference? get idAssinaturaProdutor => _idAssinaturaProdutor;
  bool hasIdAssinaturaProdutor() => _idAssinaturaProdutor != null;

  // "nomePlano" field.
  String? _nomePlano;
  String get nomePlano => _nomePlano ?? '';
  bool hasNomePlano() => _nomePlano != null;

  void _initializeFields() {
    _tipoPlano = snapshotData['tipoPlano'] as String?;
    _dtAssinatura = snapshotData['dtAssinatura'] as DateTime?;
    _dtExpiracao = snapshotData['dtExpiracao'] as String?;
    _idAssinaturaProdutor =
        snapshotData['idAssinaturaProdutor'] as DocumentReference?;
    _nomePlano = snapshotData['nomePlano'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('assinatura-ativa-produtor');

  static Stream<AssinaturaAtivaProdutorRecord> getDocument(
          DocumentReference ref) =>
      ref.snapshots().map((s) => AssinaturaAtivaProdutorRecord.fromSnapshot(s));

  static Future<AssinaturaAtivaProdutorRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => AssinaturaAtivaProdutorRecord.fromSnapshot(s));

  static AssinaturaAtivaProdutorRecord fromSnapshot(
          DocumentSnapshot snapshot) =>
      AssinaturaAtivaProdutorRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AssinaturaAtivaProdutorRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AssinaturaAtivaProdutorRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AssinaturaAtivaProdutorRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AssinaturaAtivaProdutorRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAssinaturaAtivaProdutorRecordData({
  String? tipoPlano,
  DateTime? dtAssinatura,
  String? dtExpiracao,
  DocumentReference? idAssinaturaProdutor,
  String? nomePlano,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'tipoPlano': tipoPlano,
      'dtAssinatura': dtAssinatura,
      'dtExpiracao': dtExpiracao,
      'idAssinaturaProdutor': idAssinaturaProdutor,
      'nomePlano': nomePlano,
    }.withoutNulls,
  );

  return firestoreData;
}

class AssinaturaAtivaProdutorRecordDocumentEquality
    implements Equality<AssinaturaAtivaProdutorRecord> {
  const AssinaturaAtivaProdutorRecordDocumentEquality();

  @override
  bool equals(
      AssinaturaAtivaProdutorRecord? e1, AssinaturaAtivaProdutorRecord? e2) {
    return e1?.tipoPlano == e2?.tipoPlano &&
        e1?.dtAssinatura == e2?.dtAssinatura &&
        e1?.dtExpiracao == e2?.dtExpiracao &&
        e1?.idAssinaturaProdutor == e2?.idAssinaturaProdutor &&
        e1?.nomePlano == e2?.nomePlano;
  }

  @override
  int hash(AssinaturaAtivaProdutorRecord? e) => const ListEquality().hash([
        e?.tipoPlano,
        e?.dtAssinatura,
        e?.dtExpiracao,
        e?.idAssinaturaProdutor,
        e?.nomePlano
      ]);

  @override
  bool isValidKey(Object? o) => o is AssinaturaAtivaProdutorRecord;
}
