import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AssinaturaTecnicoRecord extends FirestoreRecord {
  AssinaturaTecnicoRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "idTecnico" field.
  DocumentReference? _idTecnico;
  DocumentReference? get idTecnico => _idTecnico;
  bool hasIdTecnico() => _idTecnico != null;

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
  DateTime? _dtExpiracao;
  DateTime? get dtExpiracao => _dtExpiracao;
  bool hasDtExpiracao() => _dtExpiracao != null;

  void _initializeFields() {
    _idTecnico = snapshotData['idTecnico'] as DocumentReference?;
    _idPlano = snapshotData['idPlano'] as DocumentReference?;
    _dtAssinatura = snapshotData['dtAssinatura'] as DateTime?;
    _tipoPlano = snapshotData['tipoPlano'] as String?;
    _dtExpiracao = snapshotData['dtExpiracao'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('assinatura-tecnico');

  static Stream<AssinaturaTecnicoRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AssinaturaTecnicoRecord.fromSnapshot(s));

  static Future<AssinaturaTecnicoRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => AssinaturaTecnicoRecord.fromSnapshot(s));

  static AssinaturaTecnicoRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AssinaturaTecnicoRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AssinaturaTecnicoRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AssinaturaTecnicoRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AssinaturaTecnicoRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AssinaturaTecnicoRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAssinaturaTecnicoRecordData({
  DocumentReference? idTecnico,
  DocumentReference? idPlano,
  DateTime? dtAssinatura,
  String? tipoPlano,
  DateTime? dtExpiracao,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'idTecnico': idTecnico,
      'idPlano': idPlano,
      'dtAssinatura': dtAssinatura,
      'tipoPlano': tipoPlano,
      'dtExpiracao': dtExpiracao,
    }.withoutNulls,
  );

  return firestoreData;
}

class AssinaturaTecnicoRecordDocumentEquality
    implements Equality<AssinaturaTecnicoRecord> {
  const AssinaturaTecnicoRecordDocumentEquality();

  @override
  bool equals(AssinaturaTecnicoRecord? e1, AssinaturaTecnicoRecord? e2) {
    return e1?.idTecnico == e2?.idTecnico &&
        e1?.idPlano == e2?.idPlano &&
        e1?.dtAssinatura == e2?.dtAssinatura &&
        e1?.tipoPlano == e2?.tipoPlano &&
        e1?.dtExpiracao == e2?.dtExpiracao;
  }

  @override
  int hash(AssinaturaTecnicoRecord? e) => const ListEquality().hash([
        e?.idTecnico,
        e?.idPlano,
        e?.dtAssinatura,
        e?.tipoPlano,
        e?.dtExpiracao
      ]);

  @override
  bool isValidKey(Object? o) => o is AssinaturaTecnicoRecord;
}
