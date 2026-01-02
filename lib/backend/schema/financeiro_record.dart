import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FinanceiroRecord extends FirestoreRecord {
  FinanceiroRecord._(
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

  // "dtRelatorio" field.
  String? _dtRelatorio;
  String get dtRelatorio => _dtRelatorio ?? '';
  bool hasDtRelatorio() => _dtRelatorio != null;

  // "vacasLactacao" field.
  int? _vacasLactacao;
  int get vacasLactacao => _vacasLactacao ?? 0;
  bool hasVacasLactacao() => _vacasLactacao != null;

  // "litrosLeiteMes" field.
  int? _litrosLeiteMes;
  int get litrosLeiteMes => _litrosLeiteMes ?? 0;
  bool hasLitrosLeiteMes() => _litrosLeiteMes != null;

  // "litrosLeitePorDia" field.
  int? _litrosLeitePorDia;
  int get litrosLeitePorDia => _litrosLeitePorDia ?? 0;
  bool hasLitrosLeitePorDia() => _litrosLeitePorDia != null;

  // "precoRecebidoPorLitro" field.
  String? _precoRecebidoPorLitro;
  String get precoRecebidoPorLitro => _precoRecebidoPorLitro ?? '';
  bool hasPrecoRecebidoPorLitro() => _precoRecebidoPorLitro != null;

  // "despesasNoMes" field.
  String? _despesasNoMes;
  String get despesasNoMes => _despesasNoMes ?? '';
  bool hasDespesasNoMes() => _despesasNoMes != null;

  // "faturamentoLiquido" field.
  String? _faturamentoLiquido;
  String get faturamentoLiquido => _faturamentoLiquido ?? '';
  bool hasFaturamentoLiquido() => _faturamentoLiquido != null;

  // "mediaProducaoVaca" field.
  String? _mediaProducaoVaca;
  String get mediaProducaoVaca => _mediaProducaoVaca ?? '';
  bool hasMediaProducaoVaca() => _mediaProducaoVaca != null;

  // "custoLitroLeite" field.
  String? _custoLitroLeite;
  String get custoLitroLeite => _custoLitroLeite ?? '';
  bool hasCustoLitroLeite() => _custoLitroLeite != null;

  // "totalRecebidoMes" field.
  String? _totalRecebidoMes;
  String get totalRecebidoMes => _totalRecebidoMes ?? '';
  bool hasTotalRecebidoMes() => _totalRecebidoMes != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _uidPropriedade = snapshotData['uidPropriedade'] as DocumentReference?;
    _uidTecnico = snapshotData['uidTecnico'] as DocumentReference?;
    _dtRelatorio = snapshotData['dtRelatorio'] as String?;
    _vacasLactacao = castToType<int>(snapshotData['vacasLactacao']);
    _litrosLeiteMes = castToType<int>(snapshotData['litrosLeiteMes']);
    _litrosLeitePorDia = castToType<int>(snapshotData['litrosLeitePorDia']);
    _precoRecebidoPorLitro = snapshotData['precoRecebidoPorLitro'] as String?;
    _despesasNoMes = snapshotData['despesasNoMes'] as String?;
    _faturamentoLiquido = snapshotData['faturamentoLiquido'] as String?;
    _mediaProducaoVaca = snapshotData['mediaProducaoVaca'] as String?;
    _custoLitroLeite = snapshotData['custoLitroLeite'] as String?;
    _totalRecebidoMes = snapshotData['totalRecebidoMes'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('financeiro')
          : FirebaseFirestore.instance.collectionGroup('financeiro');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('financeiro').doc(id);

  static Stream<FinanceiroRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => FinanceiroRecord.fromSnapshot(s));

  static Future<FinanceiroRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => FinanceiroRecord.fromSnapshot(s));

  static FinanceiroRecord fromSnapshot(DocumentSnapshot snapshot) =>
      FinanceiroRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static FinanceiroRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      FinanceiroRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'FinanceiroRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is FinanceiroRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createFinanceiroRecordData({
  DocumentReference? uidPropriedade,
  DocumentReference? uidTecnico,
  String? dtRelatorio,
  int? vacasLactacao,
  int? litrosLeiteMes,
  int? litrosLeitePorDia,
  String? precoRecebidoPorLitro,
  String? despesasNoMes,
  String? faturamentoLiquido,
  String? mediaProducaoVaca,
  String? custoLitroLeite,
  String? totalRecebidoMes,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'uidPropriedade': uidPropriedade,
      'uidTecnico': uidTecnico,
      'dtRelatorio': dtRelatorio,
      'vacasLactacao': vacasLactacao,
      'litrosLeiteMes': litrosLeiteMes,
      'litrosLeitePorDia': litrosLeitePorDia,
      'precoRecebidoPorLitro': precoRecebidoPorLitro,
      'despesasNoMes': despesasNoMes,
      'faturamentoLiquido': faturamentoLiquido,
      'mediaProducaoVaca': mediaProducaoVaca,
      'custoLitroLeite': custoLitroLeite,
      'totalRecebidoMes': totalRecebidoMes,
    }.withoutNulls,
  );

  return firestoreData;
}

class FinanceiroRecordDocumentEquality implements Equality<FinanceiroRecord> {
  const FinanceiroRecordDocumentEquality();

  @override
  bool equals(FinanceiroRecord? e1, FinanceiroRecord? e2) {
    return e1?.uidPropriedade == e2?.uidPropriedade &&
        e1?.uidTecnico == e2?.uidTecnico &&
        e1?.dtRelatorio == e2?.dtRelatorio &&
        e1?.vacasLactacao == e2?.vacasLactacao &&
        e1?.litrosLeiteMes == e2?.litrosLeiteMes &&
        e1?.litrosLeitePorDia == e2?.litrosLeitePorDia &&
        e1?.precoRecebidoPorLitro == e2?.precoRecebidoPorLitro &&
        e1?.despesasNoMes == e2?.despesasNoMes &&
        e1?.faturamentoLiquido == e2?.faturamentoLiquido &&
        e1?.mediaProducaoVaca == e2?.mediaProducaoVaca &&
        e1?.custoLitroLeite == e2?.custoLitroLeite &&
        e1?.totalRecebidoMes == e2?.totalRecebidoMes;
  }

  @override
  int hash(FinanceiroRecord? e) => const ListEquality().hash([
        e?.uidPropriedade,
        e?.uidTecnico,
        e?.dtRelatorio,
        e?.vacasLactacao,
        e?.litrosLeiteMes,
        e?.litrosLeitePorDia,
        e?.precoRecebidoPorLitro,
        e?.despesasNoMes,
        e?.faturamentoLiquido,
        e?.mediaProducaoVaca,
        e?.custoLitroLeite,
        e?.totalRecebidoMes
      ]);

  @override
  bool isValidKey(Object? o) => o is FinanceiroRecord;
}
