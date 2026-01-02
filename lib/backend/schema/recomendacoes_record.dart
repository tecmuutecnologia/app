import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RecomendacoesRecord extends FirestoreRecord {
  RecomendacoesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "tituloRecomendacao" field.
  String? _tituloRecomendacao;
  String get tituloRecomendacao => _tituloRecomendacao ?? '';
  bool hasTituloRecomendacao() => _tituloRecomendacao != null;

  // "descricaoRecomendacao" field.
  String? _descricaoRecomendacao;
  String get descricaoRecomendacao => _descricaoRecomendacao ?? '';
  bool hasDescricaoRecomendacao() => _descricaoRecomendacao != null;

  // "uidResumoDaVisita" field.
  DocumentReference? _uidResumoDaVisita;
  DocumentReference? get uidResumoDaVisita => _uidResumoDaVisita;
  bool hasUidResumoDaVisita() => _uidResumoDaVisita != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _tituloRecomendacao = snapshotData['tituloRecomendacao'] as String?;
    _descricaoRecomendacao = snapshotData['descricaoRecomendacao'] as String?;
    _uidResumoDaVisita =
        snapshotData['uidResumoDaVisita'] as DocumentReference?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('recomendacoes')
          : FirebaseFirestore.instance.collectionGroup('recomendacoes');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('recomendacoes').doc(id);

  static Stream<RecomendacoesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RecomendacoesRecord.fromSnapshot(s));

  static Future<RecomendacoesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RecomendacoesRecord.fromSnapshot(s));

  static RecomendacoesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RecomendacoesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RecomendacoesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RecomendacoesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RecomendacoesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RecomendacoesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRecomendacoesRecordData({
  String? tituloRecomendacao,
  String? descricaoRecomendacao,
  DocumentReference? uidResumoDaVisita,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'tituloRecomendacao': tituloRecomendacao,
      'descricaoRecomendacao': descricaoRecomendacao,
      'uidResumoDaVisita': uidResumoDaVisita,
    }.withoutNulls,
  );

  return firestoreData;
}

class RecomendacoesRecordDocumentEquality
    implements Equality<RecomendacoesRecord> {
  const RecomendacoesRecordDocumentEquality();

  @override
  bool equals(RecomendacoesRecord? e1, RecomendacoesRecord? e2) {
    return e1?.tituloRecomendacao == e2?.tituloRecomendacao &&
        e1?.descricaoRecomendacao == e2?.descricaoRecomendacao &&
        e1?.uidResumoDaVisita == e2?.uidResumoDaVisita;
  }

  @override
  int hash(RecomendacoesRecord? e) => const ListEquality().hash(
      [e?.tituloRecomendacao, e?.descricaoRecomendacao, e?.uidResumoDaVisita]);

  @override
  bool isValidKey(Object? o) => o is RecomendacoesRecord;
}
