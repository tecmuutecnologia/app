import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AssinaturaAtivaTecnicoRecord extends FirestoreRecord {
  AssinaturaAtivaTecnicoRecord._(
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
  DateTime? _dtExpiracao;
  DateTime? get dtExpiracao => _dtExpiracao;
  bool hasDtExpiracao() => _dtExpiracao != null;

  // "idAssinaturaTecnico" field.
  DocumentReference? _idAssinaturaTecnico;
  DocumentReference? get idAssinaturaTecnico => _idAssinaturaTecnico;
  bool hasIdAssinaturaTecnico() => _idAssinaturaTecnico != null;

  // "nomePlano" field.
  String? _nomePlano;
  String get nomePlano => _nomePlano ?? '';
  bool hasNomePlano() => _nomePlano != null;

  void _initializeFields() {
    _tipoPlano = snapshotData['tipoPlano'] as String?;
    _dtAssinatura = snapshotData['dtAssinatura'] as DateTime?;
    _dtExpiracao = snapshotData['dtExpiracao'] as DateTime?;
    _idAssinaturaTecnico =
        snapshotData['idAssinaturaTecnico'] as DocumentReference?;
    _nomePlano = snapshotData['nomePlano'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('assinatura-ativa-tecnico');

  static Stream<AssinaturaAtivaTecnicoRecord> getDocument(
          DocumentReference ref) =>
      ref.snapshots().map((s) => AssinaturaAtivaTecnicoRecord.fromSnapshot(s));

  static Future<AssinaturaAtivaTecnicoRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => AssinaturaAtivaTecnicoRecord.fromSnapshot(s));

  static AssinaturaAtivaTecnicoRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AssinaturaAtivaTecnicoRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AssinaturaAtivaTecnicoRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AssinaturaAtivaTecnicoRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AssinaturaAtivaTecnicoRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AssinaturaAtivaTecnicoRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAssinaturaAtivaTecnicoRecordData({
  String? tipoPlano,
  DateTime? dtAssinatura,
  DateTime? dtExpiracao,
  DocumentReference? idAssinaturaTecnico,
  String? nomePlano,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'tipoPlano': tipoPlano,
      'dtAssinatura': dtAssinatura,
      'dtExpiracao': dtExpiracao,
      'idAssinaturaTecnico': idAssinaturaTecnico,
      'nomePlano': nomePlano,
    }.withoutNulls,
  );

  return firestoreData;
}

class AssinaturaAtivaTecnicoRecordDocumentEquality
    implements Equality<AssinaturaAtivaTecnicoRecord> {
  const AssinaturaAtivaTecnicoRecordDocumentEquality();

  @override
  bool equals(
      AssinaturaAtivaTecnicoRecord? e1, AssinaturaAtivaTecnicoRecord? e2) {
    return e1?.tipoPlano == e2?.tipoPlano &&
        e1?.dtAssinatura == e2?.dtAssinatura &&
        e1?.dtExpiracao == e2?.dtExpiracao &&
        e1?.idAssinaturaTecnico == e2?.idAssinaturaTecnico &&
        e1?.nomePlano == e2?.nomePlano;
  }

  @override
  int hash(AssinaturaAtivaTecnicoRecord? e) => const ListEquality().hash([
        e?.tipoPlano,
        e?.dtAssinatura,
        e?.dtExpiracao,
        e?.idAssinaturaTecnico,
        e?.nomePlano
      ]);

  @override
  bool isValidKey(Object? o) => o is AssinaturaAtivaTecnicoRecord;
}
