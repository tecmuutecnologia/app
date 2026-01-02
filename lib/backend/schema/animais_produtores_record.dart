import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AnimaisProdutoresRecord extends FirestoreRecord {
  AnimaisProdutoresRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "uidTecnicoPropriedade" field.
  DocumentReference? _uidTecnicoPropriedade;
  DocumentReference? get uidTecnicoPropriedade => _uidTecnicoPropriedade;
  bool hasUidTecnicoPropriedade() => _uidTecnicoPropriedade != null;

  // "nomeAnimal" field.
  String? _nomeAnimal;
  String get nomeAnimal => _nomeAnimal ?? '';
  bool hasNomeAnimal() => _nomeAnimal != null;

  // "racaAnimal" field.
  String? _racaAnimal;
  String get racaAnimal => _racaAnimal ?? '';
  bool hasRacaAnimal() => _racaAnimal != null;

  // "pesoAnimal" field.
  String? _pesoAnimal;
  String get pesoAnimal => _pesoAnimal ?? '';
  bool hasPesoAnimal() => _pesoAnimal != null;

  // "dtNascimento" field.
  String? _dtNascimento;
  String get dtNascimento => _dtNascimento ?? '';
  bool hasDtNascimento() => _dtNascimento != null;

  // "touro" field.
  String? _touro;
  String get touro => _touro ?? '';
  bool hasTouro() => _touro != null;

  // "vaca" field.
  String? _vaca;
  String get vaca => _vaca ?? '';
  bool hasVaca() => _vaca != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "grupoAnimal" field.
  String? _grupoAnimal;
  String get grupoAnimal => _grupoAnimal ?? '';
  bool hasGrupoAnimal() => _grupoAnimal != null;

  // "dtUltimaInseminacao" field.
  String? _dtUltimaInseminacao;
  String get dtUltimaInseminacao => _dtUltimaInseminacao ?? '';
  bool hasDtUltimaInseminacao() => _dtUltimaInseminacao != null;

  // "dtUltimoParto" field.
  String? _dtUltimoParto;
  String get dtUltimoParto => _dtUltimoParto ?? '';
  bool hasDtUltimoParto() => _dtUltimoParto != null;

  // "liberaInseminacao" field.
  bool? _liberaInseminacao;
  bool get liberaInseminacao => _liberaInseminacao ?? false;
  bool hasLiberaInseminacao() => _liberaInseminacao != null;

  // "dtPartoPrevisto" field.
  String? _dtPartoPrevisto;
  String get dtPartoPrevisto => _dtPartoPrevisto ?? '';
  bool hasDtPartoPrevisto() => _dtPartoPrevisto != null;

  // "dtSecPrevista" field.
  String? _dtSecPrevista;
  String get dtSecPrevista => _dtSecPrevista ?? '';
  bool hasDtSecPrevista() => _dtSecPrevista != null;

  // "dtPrePartoPrevista" field.
  String? _dtPrePartoPrevista;
  String get dtPrePartoPrevista => _dtPrePartoPrevista ?? '';
  bool hasDtPrePartoPrevista() => _dtPrePartoPrevista != null;

  // "dtPP" field.
  String? _dtPP;
  String get dtPP => _dtPP ?? '';
  bool hasDtPP() => _dtPP != null;

  // "dtDgMais" field.
  String? _dtDgMais;
  String get dtDgMais => _dtDgMais ?? '';
  bool hasDtDgMais() => _dtDgMais != null;

  // "dtDgMenos" field.
  String? _dtDgMenos;
  String get dtDgMenos => _dtDgMenos ?? '';
  bool hasDtDgMenos() => _dtDgMenos != null;

  // "dtAborto" field.
  String? _dtAborto;
  String get dtAborto => _dtAborto ?? '';
  bool hasDtAborto() => _dtAborto != null;

  // "dtSecagem" field.
  String? _dtSecagem;
  String get dtSecagem => _dtSecagem ?? '';
  bool hasDtSecagem() => _dtSecagem != null;

  // "dtUltimoPP" field.
  String? _dtUltimoPP;
  String get dtUltimoPP => _dtUltimoPP ?? '';
  bool hasDtUltimoPP() => _dtUltimoPP != null;

  // "nomeTouroUltimaInseminacao" field.
  String? _nomeTouroUltimaInseminacao;
  String get nomeTouroUltimaInseminacao => _nomeTouroUltimaInseminacao ?? '';
  bool hasNomeTouroUltimaInseminacao() => _nomeTouroUltimaInseminacao != null;

  // "totalInseminacoes" field.
  int? _totalInseminacoes;
  int get totalInseminacoes => _totalInseminacoes ?? 0;
  bool hasTotalInseminacoes() => _totalInseminacoes != null;

  // "totalPartos" field.
  int? _totalPartos;
  int get totalPartos => _totalPartos ?? 0;
  bool hasTotalPartos() => _totalPartos != null;

  // "dtPreParto" field.
  String? _dtPreParto;
  String get dtPreParto => _dtPreParto ?? '';
  bool hasDtPreParto() => _dtPreParto != null;

  // "motivoDescarteAnimal" field.
  String? _motivoDescarteAnimal;
  String get motivoDescarteAnimal => _motivoDescarteAnimal ?? '';
  bool hasMotivoDescarteAnimal() => _motivoDescarteAnimal != null;

  // "dtDescarteAnimal" field.
  String? _dtDescarteAnimal;
  String get dtDescarteAnimal => _dtDescarteAnimal ?? '';
  bool hasDtDescarteAnimal() => _dtDescarteAnimal != null;

  // "dtUltimaAcao" field.
  String? _dtUltimaAcao;
  String get dtUltimaAcao => _dtUltimaAcao ?? '';
  bool hasDtUltimaAcao() => _dtUltimaAcao != null;

  // "compararDtUltimaInseminacao" field.
  DateTime? _compararDtUltimaInseminacao;
  DateTime? get compararDtUltimaInseminacao => _compararDtUltimaInseminacao;
  bool hasCompararDtUltimaInseminacao() => _compararDtUltimaInseminacao != null;

  // "nomeBrincoConcat" field.
  String? _nomeBrincoConcat;
  String get nomeBrincoConcat => _nomeBrincoConcat ?? '';
  bool hasNomeBrincoConcat() => _nomeBrincoConcat != null;

  // "idGrupoAnimal" field.
  int? _idGrupoAnimal;
  int get idGrupoAnimal => _idGrupoAnimal ?? 0;
  bool hasIdGrupoAnimal() => _idGrupoAnimal != null;

  // "dtUltimoPartoContingencia" field.
  String? _dtUltimoPartoContingencia;
  String get dtUltimoPartoContingencia => _dtUltimoPartoContingencia ?? '';
  bool hasDtUltimoPartoContingencia() => _dtUltimoPartoContingencia != null;

  // "idStatusAnimal" field.
  int? _idStatusAnimal;
  int get idStatusAnimal => _idStatusAnimal ?? 0;
  bool hasIdStatusAnimal() => _idStatusAnimal != null;

  // "dtInducaoLactacao" field.
  DateTime? _dtInducaoLactacao;
  DateTime? get dtInducaoLactacao => _dtInducaoLactacao;
  bool hasDtInducaoLactacao() => _dtInducaoLactacao != null;

  // "dtDesmame" field.
  DateTime? _dtDesmame;
  DateTime? get dtDesmame => _dtDesmame;
  bool hasDtDesmame() => _dtDesmame != null;

  // "brincoAnimal" field.
  int? _brincoAnimal;
  int get brincoAnimal => _brincoAnimal ?? 0;
  bool hasBrincoAnimal() => _brincoAnimal != null;

  // "brincoAnimalOrder" field.
  int? _brincoAnimalOrder;
  int get brincoAnimalOrder => _brincoAnimalOrder ?? 0;
  bool hasBrincoAnimalOrder() => _brincoAnimalOrder != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _uidTecnicoPropriedade =
        snapshotData['uidTecnicoPropriedade'] as DocumentReference?;
    _nomeAnimal = snapshotData['nomeAnimal'] as String?;
    _racaAnimal = snapshotData['racaAnimal'] as String?;
    _pesoAnimal = snapshotData['pesoAnimal'] as String?;
    _dtNascimento = snapshotData['dtNascimento'] as String?;
    _touro = snapshotData['touro'] as String?;
    _vaca = snapshotData['vaca'] as String?;
    _status = snapshotData['status'] as String?;
    _grupoAnimal = snapshotData['grupoAnimal'] as String?;
    _dtUltimaInseminacao = snapshotData['dtUltimaInseminacao'] as String?;
    _dtUltimoParto = snapshotData['dtUltimoParto'] as String?;
    _liberaInseminacao = snapshotData['liberaInseminacao'] as bool?;
    _dtPartoPrevisto = snapshotData['dtPartoPrevisto'] as String?;
    _dtSecPrevista = snapshotData['dtSecPrevista'] as String?;
    _dtPrePartoPrevista = snapshotData['dtPrePartoPrevista'] as String?;
    _dtPP = snapshotData['dtPP'] as String?;
    _dtDgMais = snapshotData['dtDgMais'] as String?;
    _dtDgMenos = snapshotData['dtDgMenos'] as String?;
    _dtAborto = snapshotData['dtAborto'] as String?;
    _dtSecagem = snapshotData['dtSecagem'] as String?;
    _dtUltimoPP = snapshotData['dtUltimoPP'] as String?;
    _nomeTouroUltimaInseminacao =
        snapshotData['nomeTouroUltimaInseminacao'] as String?;
    _totalInseminacoes = castToType<int>(snapshotData['totalInseminacoes']);
    _totalPartos = castToType<int>(snapshotData['totalPartos']);
    _dtPreParto = snapshotData['dtPreParto'] as String?;
    _motivoDescarteAnimal = snapshotData['motivoDescarteAnimal'] as String?;
    _dtDescarteAnimal = snapshotData['dtDescarteAnimal'] as String?;
    _dtUltimaAcao = snapshotData['dtUltimaAcao'] as String?;
    _compararDtUltimaInseminacao =
        snapshotData['compararDtUltimaInseminacao'] as DateTime?;
    _nomeBrincoConcat = snapshotData['nomeBrincoConcat'] as String?;
    _idGrupoAnimal = castToType<int>(snapshotData['idGrupoAnimal']);
    _dtUltimoPartoContingencia =
        snapshotData['dtUltimoPartoContingencia'] as String?;
    _idStatusAnimal = castToType<int>(snapshotData['idStatusAnimal']);
    _dtInducaoLactacao = snapshotData['dtInducaoLactacao'] as DateTime?;
    _dtDesmame = snapshotData['dtDesmame'] as DateTime?;
    _brincoAnimal = castToType<int>(snapshotData['brincoAnimal']);
    _brincoAnimalOrder = castToType<int>(snapshotData['brincoAnimalOrder']);
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('animaisProdutores')
          : FirebaseFirestore.instance.collectionGroup('animaisProdutores');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('animaisProdutores').doc(id);

  static Stream<AnimaisProdutoresRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AnimaisProdutoresRecord.fromSnapshot(s));

  static Future<AnimaisProdutoresRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => AnimaisProdutoresRecord.fromSnapshot(s));

  static AnimaisProdutoresRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AnimaisProdutoresRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AnimaisProdutoresRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AnimaisProdutoresRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AnimaisProdutoresRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AnimaisProdutoresRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAnimaisProdutoresRecordData({
  DocumentReference? uidTecnicoPropriedade,
  String? nomeAnimal,
  String? racaAnimal,
  String? pesoAnimal,
  String? dtNascimento,
  String? touro,
  String? vaca,
  String? status,
  String? grupoAnimal,
  String? dtUltimaInseminacao,
  String? dtUltimoParto,
  bool? liberaInseminacao,
  String? dtPartoPrevisto,
  String? dtSecPrevista,
  String? dtPrePartoPrevista,
  String? dtPP,
  String? dtDgMais,
  String? dtDgMenos,
  String? dtAborto,
  String? dtSecagem,
  String? dtUltimoPP,
  String? nomeTouroUltimaInseminacao,
  int? totalInseminacoes,
  int? totalPartos,
  String? dtPreParto,
  String? motivoDescarteAnimal,
  String? dtDescarteAnimal,
  String? dtUltimaAcao,
  DateTime? compararDtUltimaInseminacao,
  String? nomeBrincoConcat,
  int? idGrupoAnimal,
  String? dtUltimoPartoContingencia,
  int? idStatusAnimal,
  DateTime? dtInducaoLactacao,
  DateTime? dtDesmame,
  int? brincoAnimal,
  int? brincoAnimalOrder,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'uidTecnicoPropriedade': uidTecnicoPropriedade,
      'nomeAnimal': nomeAnimal,
      'racaAnimal': racaAnimal,
      'pesoAnimal': pesoAnimal,
      'dtNascimento': dtNascimento,
      'touro': touro,
      'vaca': vaca,
      'status': status,
      'grupoAnimal': grupoAnimal,
      'dtUltimaInseminacao': dtUltimaInseminacao,
      'dtUltimoParto': dtUltimoParto,
      'liberaInseminacao': liberaInseminacao,
      'dtPartoPrevisto': dtPartoPrevisto,
      'dtSecPrevista': dtSecPrevista,
      'dtPrePartoPrevista': dtPrePartoPrevista,
      'dtPP': dtPP,
      'dtDgMais': dtDgMais,
      'dtDgMenos': dtDgMenos,
      'dtAborto': dtAborto,
      'dtSecagem': dtSecagem,
      'dtUltimoPP': dtUltimoPP,
      'nomeTouroUltimaInseminacao': nomeTouroUltimaInseminacao,
      'totalInseminacoes': totalInseminacoes,
      'totalPartos': totalPartos,
      'dtPreParto': dtPreParto,
      'motivoDescarteAnimal': motivoDescarteAnimal,
      'dtDescarteAnimal': dtDescarteAnimal,
      'dtUltimaAcao': dtUltimaAcao,
      'compararDtUltimaInseminacao': compararDtUltimaInseminacao,
      'nomeBrincoConcat': nomeBrincoConcat,
      'idGrupoAnimal': idGrupoAnimal,
      'dtUltimoPartoContingencia': dtUltimoPartoContingencia,
      'idStatusAnimal': idStatusAnimal,
      'dtInducaoLactacao': dtInducaoLactacao,
      'dtDesmame': dtDesmame,
      'brincoAnimal': brincoAnimal,
      'brincoAnimalOrder': brincoAnimalOrder,
    }.withoutNulls,
  );

  return firestoreData;
}

class AnimaisProdutoresRecordDocumentEquality
    implements Equality<AnimaisProdutoresRecord> {
  const AnimaisProdutoresRecordDocumentEquality();

  @override
  bool equals(AnimaisProdutoresRecord? e1, AnimaisProdutoresRecord? e2) {
    return e1?.uidTecnicoPropriedade == e2?.uidTecnicoPropriedade &&
        e1?.nomeAnimal == e2?.nomeAnimal &&
        e1?.racaAnimal == e2?.racaAnimal &&
        e1?.pesoAnimal == e2?.pesoAnimal &&
        e1?.dtNascimento == e2?.dtNascimento &&
        e1?.touro == e2?.touro &&
        e1?.vaca == e2?.vaca &&
        e1?.status == e2?.status &&
        e1?.grupoAnimal == e2?.grupoAnimal &&
        e1?.dtUltimaInseminacao == e2?.dtUltimaInseminacao &&
        e1?.dtUltimoParto == e2?.dtUltimoParto &&
        e1?.liberaInseminacao == e2?.liberaInseminacao &&
        e1?.dtPartoPrevisto == e2?.dtPartoPrevisto &&
        e1?.dtSecPrevista == e2?.dtSecPrevista &&
        e1?.dtPrePartoPrevista == e2?.dtPrePartoPrevista &&
        e1?.dtPP == e2?.dtPP &&
        e1?.dtDgMais == e2?.dtDgMais &&
        e1?.dtDgMenos == e2?.dtDgMenos &&
        e1?.dtAborto == e2?.dtAborto &&
        e1?.dtSecagem == e2?.dtSecagem &&
        e1?.dtUltimoPP == e2?.dtUltimoPP &&
        e1?.nomeTouroUltimaInseminacao == e2?.nomeTouroUltimaInseminacao &&
        e1?.totalInseminacoes == e2?.totalInseminacoes &&
        e1?.totalPartos == e2?.totalPartos &&
        e1?.dtPreParto == e2?.dtPreParto &&
        e1?.motivoDescarteAnimal == e2?.motivoDescarteAnimal &&
        e1?.dtDescarteAnimal == e2?.dtDescarteAnimal &&
        e1?.dtUltimaAcao == e2?.dtUltimaAcao &&
        e1?.compararDtUltimaInseminacao == e2?.compararDtUltimaInseminacao &&
        e1?.nomeBrincoConcat == e2?.nomeBrincoConcat &&
        e1?.idGrupoAnimal == e2?.idGrupoAnimal &&
        e1?.dtUltimoPartoContingencia == e2?.dtUltimoPartoContingencia &&
        e1?.idStatusAnimal == e2?.idStatusAnimal &&
        e1?.dtInducaoLactacao == e2?.dtInducaoLactacao &&
        e1?.dtDesmame == e2?.dtDesmame &&
        e1?.brincoAnimal == e2?.brincoAnimal &&
        e1?.brincoAnimalOrder == e2?.brincoAnimalOrder;
  }

  @override
  int hash(AnimaisProdutoresRecord? e) => const ListEquality().hash([
        e?.uidTecnicoPropriedade,
        e?.nomeAnimal,
        e?.racaAnimal,
        e?.pesoAnimal,
        e?.dtNascimento,
        e?.touro,
        e?.vaca,
        e?.status,
        e?.grupoAnimal,
        e?.dtUltimaInseminacao,
        e?.dtUltimoParto,
        e?.liberaInseminacao,
        e?.dtPartoPrevisto,
        e?.dtSecPrevista,
        e?.dtPrePartoPrevista,
        e?.dtPP,
        e?.dtDgMais,
        e?.dtDgMenos,
        e?.dtAborto,
        e?.dtSecagem,
        e?.dtUltimoPP,
        e?.nomeTouroUltimaInseminacao,
        e?.totalInseminacoes,
        e?.totalPartos,
        e?.dtPreParto,
        e?.motivoDescarteAnimal,
        e?.dtDescarteAnimal,
        e?.dtUltimaAcao,
        e?.compararDtUltimaInseminacao,
        e?.nomeBrincoConcat,
        e?.idGrupoAnimal,
        e?.dtUltimoPartoContingencia,
        e?.idStatusAnimal,
        e?.dtInducaoLactacao,
        e?.dtDesmame,
        e?.brincoAnimal,
        e?.brincoAnimalOrder
      ]);

  @override
  bool isValidKey(Object? o) => o is AnimaisProdutoresRecord;
}
