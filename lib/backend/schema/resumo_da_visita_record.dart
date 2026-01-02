import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ResumoDaVisitaRecord extends FirestoreRecord {
  ResumoDaVisitaRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "uidPropriedade" field.
  DocumentReference? _uidPropriedade;
  DocumentReference? get uidPropriedade => _uidPropriedade;
  bool hasUidPropriedade() => _uidPropriedade != null;

  // "uidTecnico" field.
  DocumentReference? _uidTecnico;
  DocumentReference? get uidTecnico => _uidTecnico;
  bool hasUidTecnico() => _uidTecnico != null;

  // "dtVisita" field.
  DateTime? _dtVisita;
  DateTime? get dtVisita => _dtVisita;
  bool hasDtVisita() => _dtVisita != null;

  // "uidResumoDaVisita" field.
  DocumentReference? _uidResumoDaVisita;
  DocumentReference? get uidResumoDaVisita => _uidResumoDaVisita;
  bool hasUidResumoDaVisita() => _uidResumoDaVisita != null;

  // "dtVisitaFormatado" field.
  String? _dtVisitaFormatado;
  String get dtVisitaFormatado => _dtVisitaFormatado ?? '';
  bool hasDtVisitaFormatado() => _dtVisitaFormatado != null;

  // "dtAssinatura" field.
  DateTime? _dtAssinatura;
  DateTime? get dtAssinatura => _dtAssinatura;
  bool hasDtAssinatura() => _dtAssinatura != null;

  // "dtAssinaturaFormatado" field.
  String? _dtAssinaturaFormatado;
  String get dtAssinaturaFormatado => _dtAssinaturaFormatado ?? '';
  bool hasDtAssinaturaFormatado() => _dtAssinaturaFormatado != null;

  // "assinaturaProdutor" field.
  String? _assinaturaProdutor;
  String get assinaturaProdutor => _assinaturaProdutor ?? '';
  bool hasAssinaturaProdutor() => _assinaturaProdutor != null;

  // "obsGeralVisita" field.
  String? _obsGeralVisita;
  String get obsGeralVisita => _obsGeralVisita ?? '';
  bool hasObsGeralVisita() => _obsGeralVisita != null;

  // "assinaturaTecnico" field.
  String? _assinaturaTecnico;
  String get assinaturaTecnico => _assinaturaTecnico ?? '';
  bool hasAssinaturaTecnico() => _assinaturaTecnico != null;

  void _initializeFields() {
    _uidPropriedade = snapshotData['uidPropriedade'] as DocumentReference?;
    _uidTecnico = snapshotData['uidTecnico'] as DocumentReference?;
    _dtVisita = snapshotData['dtVisita'] as DateTime?;
    _uidResumoDaVisita =
        snapshotData['uidResumoDaVisita'] as DocumentReference?;
    _dtVisitaFormatado = snapshotData['dtVisitaFormatado'] as String?;
    _dtAssinatura = snapshotData['dtAssinatura'] as DateTime?;
    _dtAssinaturaFormatado = snapshotData['dtAssinaturaFormatado'] as String?;
    _assinaturaProdutor = snapshotData['assinaturaProdutor'] as String?;
    _obsGeralVisita = snapshotData['obsGeralVisita'] as String?;
    _assinaturaTecnico = snapshotData['assinaturaTecnico'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('resumo_da_visita');

  static Stream<ResumoDaVisitaRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ResumoDaVisitaRecord.fromSnapshot(s));

  static Future<ResumoDaVisitaRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ResumoDaVisitaRecord.fromSnapshot(s));

  static ResumoDaVisitaRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ResumoDaVisitaRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ResumoDaVisitaRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ResumoDaVisitaRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ResumoDaVisitaRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ResumoDaVisitaRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createResumoDaVisitaRecordData({
  DocumentReference? uidPropriedade,
  DocumentReference? uidTecnico,
  DateTime? dtVisita,
  DocumentReference? uidResumoDaVisita,
  String? dtVisitaFormatado,
  DateTime? dtAssinatura,
  String? dtAssinaturaFormatado,
  String? assinaturaProdutor,
  String? obsGeralVisita,
  String? assinaturaTecnico,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'uidPropriedade': uidPropriedade,
      'uidTecnico': uidTecnico,
      'dtVisita': dtVisita,
      'uidResumoDaVisita': uidResumoDaVisita,
      'dtVisitaFormatado': dtVisitaFormatado,
      'dtAssinatura': dtAssinatura,
      'dtAssinaturaFormatado': dtAssinaturaFormatado,
      'assinaturaProdutor': assinaturaProdutor,
      'obsGeralVisita': obsGeralVisita,
      'assinaturaTecnico': assinaturaTecnico,
    }.withoutNulls,
  );

  return firestoreData;
}

class ResumoDaVisitaRecordDocumentEquality
    implements Equality<ResumoDaVisitaRecord> {
  const ResumoDaVisitaRecordDocumentEquality();

  @override
  bool equals(ResumoDaVisitaRecord? e1, ResumoDaVisitaRecord? e2) {
    return e1?.uidPropriedade == e2?.uidPropriedade &&
        e1?.uidTecnico == e2?.uidTecnico &&
        e1?.dtVisita == e2?.dtVisita &&
        e1?.uidResumoDaVisita == e2?.uidResumoDaVisita &&
        e1?.dtVisitaFormatado == e2?.dtVisitaFormatado &&
        e1?.dtAssinatura == e2?.dtAssinatura &&
        e1?.dtAssinaturaFormatado == e2?.dtAssinaturaFormatado &&
        e1?.assinaturaProdutor == e2?.assinaturaProdutor &&
        e1?.obsGeralVisita == e2?.obsGeralVisita &&
        e1?.assinaturaTecnico == e2?.assinaturaTecnico;
  }

  @override
  int hash(ResumoDaVisitaRecord? e) => const ListEquality().hash([
        e?.uidPropriedade,
        e?.uidTecnico,
        e?.dtVisita,
        e?.uidResumoDaVisita,
        e?.dtVisitaFormatado,
        e?.dtAssinatura,
        e?.dtAssinaturaFormatado,
        e?.assinaturaProdutor,
        e?.obsGeralVisita,
        e?.assinaturaTecnico
      ]);

  @override
  bool isValidKey(Object? o) => o is ResumoDaVisitaRecord;
}
