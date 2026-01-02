// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class AnimaisProdutoresStruct extends FFFirebaseStruct {
  AnimaisProdutoresStruct({
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
    DocumentReference? uidAnimal,
    String? uidAnimalOffline,
    int? itemUidIndexAtual,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _uidTecnicoPropriedade = uidTecnicoPropriedade,
        _nomeAnimal = nomeAnimal,
        _racaAnimal = racaAnimal,
        _pesoAnimal = pesoAnimal,
        _dtNascimento = dtNascimento,
        _touro = touro,
        _vaca = vaca,
        _status = status,
        _grupoAnimal = grupoAnimal,
        _dtUltimaInseminacao = dtUltimaInseminacao,
        _dtUltimoParto = dtUltimoParto,
        _liberaInseminacao = liberaInseminacao,
        _dtPartoPrevisto = dtPartoPrevisto,
        _dtSecPrevista = dtSecPrevista,
        _dtPrePartoPrevista = dtPrePartoPrevista,
        _dtPP = dtPP,
        _dtDgMais = dtDgMais,
        _dtDgMenos = dtDgMenos,
        _dtAborto = dtAborto,
        _dtSecagem = dtSecagem,
        _dtUltimoPP = dtUltimoPP,
        _nomeTouroUltimaInseminacao = nomeTouroUltimaInseminacao,
        _totalInseminacoes = totalInseminacoes,
        _totalPartos = totalPartos,
        _dtPreParto = dtPreParto,
        _motivoDescarteAnimal = motivoDescarteAnimal,
        _dtDescarteAnimal = dtDescarteAnimal,
        _dtUltimaAcao = dtUltimaAcao,
        _compararDtUltimaInseminacao = compararDtUltimaInseminacao,
        _nomeBrincoConcat = nomeBrincoConcat,
        _idGrupoAnimal = idGrupoAnimal,
        _dtUltimoPartoContingencia = dtUltimoPartoContingencia,
        _idStatusAnimal = idStatusAnimal,
        _dtInducaoLactacao = dtInducaoLactacao,
        _dtDesmame = dtDesmame,
        _brincoAnimal = brincoAnimal,
        _brincoAnimalOrder = brincoAnimalOrder,
        _uidAnimal = uidAnimal,
        _uidAnimalOffline = uidAnimalOffline,
        _itemUidIndexAtual = itemUidIndexAtual,
        super(firestoreUtilData);

  // "uidTecnicoPropriedade" field.
  DocumentReference? _uidTecnicoPropriedade;
  DocumentReference? get uidTecnicoPropriedade => _uidTecnicoPropriedade;
  set uidTecnicoPropriedade(DocumentReference? val) =>
      _uidTecnicoPropriedade = val;

  bool hasUidTecnicoPropriedade() => _uidTecnicoPropriedade != null;

  // "nomeAnimal" field.
  String? _nomeAnimal;
  String get nomeAnimal => _nomeAnimal ?? '';
  set nomeAnimal(String? val) => _nomeAnimal = val;

  bool hasNomeAnimal() => _nomeAnimal != null;

  // "racaAnimal" field.
  String? _racaAnimal;
  String get racaAnimal => _racaAnimal ?? '';
  set racaAnimal(String? val) => _racaAnimal = val;

  bool hasRacaAnimal() => _racaAnimal != null;

  // "pesoAnimal" field.
  String? _pesoAnimal;
  String get pesoAnimal => _pesoAnimal ?? '';
  set pesoAnimal(String? val) => _pesoAnimal = val;

  bool hasPesoAnimal() => _pesoAnimal != null;

  // "dtNascimento" field.
  String? _dtNascimento;
  String get dtNascimento => _dtNascimento ?? '';
  set dtNascimento(String? val) => _dtNascimento = val;

  bool hasDtNascimento() => _dtNascimento != null;

  // "touro" field.
  String? _touro;
  String get touro => _touro ?? '';
  set touro(String? val) => _touro = val;

  bool hasTouro() => _touro != null;

  // "vaca" field.
  String? _vaca;
  String get vaca => _vaca ?? '';
  set vaca(String? val) => _vaca = val;

  bool hasVaca() => _vaca != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "grupoAnimal" field.
  String? _grupoAnimal;
  String get grupoAnimal => _grupoAnimal ?? '';
  set grupoAnimal(String? val) => _grupoAnimal = val;

  bool hasGrupoAnimal() => _grupoAnimal != null;

  // "dtUltimaInseminacao" field.
  String? _dtUltimaInseminacao;
  String get dtUltimaInseminacao => _dtUltimaInseminacao ?? '';
  set dtUltimaInseminacao(String? val) => _dtUltimaInseminacao = val;

  bool hasDtUltimaInseminacao() => _dtUltimaInseminacao != null;

  // "dtUltimoParto" field.
  String? _dtUltimoParto;
  String get dtUltimoParto => _dtUltimoParto ?? '';
  set dtUltimoParto(String? val) => _dtUltimoParto = val;

  bool hasDtUltimoParto() => _dtUltimoParto != null;

  // "liberaInseminacao" field.
  bool? _liberaInseminacao;
  bool get liberaInseminacao => _liberaInseminacao ?? false;
  set liberaInseminacao(bool? val) => _liberaInseminacao = val;

  bool hasLiberaInseminacao() => _liberaInseminacao != null;

  // "dtPartoPrevisto" field.
  String? _dtPartoPrevisto;
  String get dtPartoPrevisto => _dtPartoPrevisto ?? '';
  set dtPartoPrevisto(String? val) => _dtPartoPrevisto = val;

  bool hasDtPartoPrevisto() => _dtPartoPrevisto != null;

  // "dtSecPrevista" field.
  String? _dtSecPrevista;
  String get dtSecPrevista => _dtSecPrevista ?? '';
  set dtSecPrevista(String? val) => _dtSecPrevista = val;

  bool hasDtSecPrevista() => _dtSecPrevista != null;

  // "dtPrePartoPrevista" field.
  String? _dtPrePartoPrevista;
  String get dtPrePartoPrevista => _dtPrePartoPrevista ?? '';
  set dtPrePartoPrevista(String? val) => _dtPrePartoPrevista = val;

  bool hasDtPrePartoPrevista() => _dtPrePartoPrevista != null;

  // "dtPP" field.
  String? _dtPP;
  String get dtPP => _dtPP ?? '';
  set dtPP(String? val) => _dtPP = val;

  bool hasDtPP() => _dtPP != null;

  // "dtDgMais" field.
  String? _dtDgMais;
  String get dtDgMais => _dtDgMais ?? '';
  set dtDgMais(String? val) => _dtDgMais = val;

  bool hasDtDgMais() => _dtDgMais != null;

  // "dtDgMenos" field.
  String? _dtDgMenos;
  String get dtDgMenos => _dtDgMenos ?? '';
  set dtDgMenos(String? val) => _dtDgMenos = val;

  bool hasDtDgMenos() => _dtDgMenos != null;

  // "dtAborto" field.
  String? _dtAborto;
  String get dtAborto => _dtAborto ?? '';
  set dtAborto(String? val) => _dtAborto = val;

  bool hasDtAborto() => _dtAborto != null;

  // "dtSecagem" field.
  String? _dtSecagem;
  String get dtSecagem => _dtSecagem ?? '';
  set dtSecagem(String? val) => _dtSecagem = val;

  bool hasDtSecagem() => _dtSecagem != null;

  // "dtUltimoPP" field.
  String? _dtUltimoPP;
  String get dtUltimoPP => _dtUltimoPP ?? '';
  set dtUltimoPP(String? val) => _dtUltimoPP = val;

  bool hasDtUltimoPP() => _dtUltimoPP != null;

  // "nomeTouroUltimaInseminacao" field.
  String? _nomeTouroUltimaInseminacao;
  String get nomeTouroUltimaInseminacao => _nomeTouroUltimaInseminacao ?? '';
  set nomeTouroUltimaInseminacao(String? val) =>
      _nomeTouroUltimaInseminacao = val;

  bool hasNomeTouroUltimaInseminacao() => _nomeTouroUltimaInseminacao != null;

  // "totalInseminacoes" field.
  int? _totalInseminacoes;
  int get totalInseminacoes => _totalInseminacoes ?? 0;
  set totalInseminacoes(int? val) => _totalInseminacoes = val;

  void incrementTotalInseminacoes(int amount) =>
      totalInseminacoes = totalInseminacoes + amount;

  bool hasTotalInseminacoes() => _totalInseminacoes != null;

  // "totalPartos" field.
  int? _totalPartos;
  int get totalPartos => _totalPartos ?? 0;
  set totalPartos(int? val) => _totalPartos = val;

  void incrementTotalPartos(int amount) => totalPartos = totalPartos + amount;

  bool hasTotalPartos() => _totalPartos != null;

  // "dtPreParto" field.
  String? _dtPreParto;
  String get dtPreParto => _dtPreParto ?? '';
  set dtPreParto(String? val) => _dtPreParto = val;

  bool hasDtPreParto() => _dtPreParto != null;

  // "motivoDescarteAnimal" field.
  String? _motivoDescarteAnimal;
  String get motivoDescarteAnimal => _motivoDescarteAnimal ?? '';
  set motivoDescarteAnimal(String? val) => _motivoDescarteAnimal = val;

  bool hasMotivoDescarteAnimal() => _motivoDescarteAnimal != null;

  // "dtDescarteAnimal" field.
  String? _dtDescarteAnimal;
  String get dtDescarteAnimal => _dtDescarteAnimal ?? '';
  set dtDescarteAnimal(String? val) => _dtDescarteAnimal = val;

  bool hasDtDescarteAnimal() => _dtDescarteAnimal != null;

  // "dtUltimaAcao" field.
  String? _dtUltimaAcao;
  String get dtUltimaAcao => _dtUltimaAcao ?? '';
  set dtUltimaAcao(String? val) => _dtUltimaAcao = val;

  bool hasDtUltimaAcao() => _dtUltimaAcao != null;

  // "compararDtUltimaInseminacao" field.
  DateTime? _compararDtUltimaInseminacao;
  DateTime get compararDtUltimaInseminacao =>
      _compararDtUltimaInseminacao ??
      DateTime.fromMicrosecondsSinceEpoch(2556064800000000);
  set compararDtUltimaInseminacao(DateTime? val) =>
      _compararDtUltimaInseminacao = val;

  bool hasCompararDtUltimaInseminacao() => _compararDtUltimaInseminacao != null;

  // "nomeBrincoConcat" field.
  String? _nomeBrincoConcat;
  String get nomeBrincoConcat => _nomeBrincoConcat ?? '';
  set nomeBrincoConcat(String? val) => _nomeBrincoConcat = val;

  bool hasNomeBrincoConcat() => _nomeBrincoConcat != null;

  // "idGrupoAnimal" field.
  int? _idGrupoAnimal;
  int get idGrupoAnimal => _idGrupoAnimal ?? 0;
  set idGrupoAnimal(int? val) => _idGrupoAnimal = val;

  void incrementIdGrupoAnimal(int amount) =>
      idGrupoAnimal = idGrupoAnimal + amount;

  bool hasIdGrupoAnimal() => _idGrupoAnimal != null;

  // "dtUltimoPartoContingencia" field.
  String? _dtUltimoPartoContingencia;
  String get dtUltimoPartoContingencia => _dtUltimoPartoContingencia ?? '';
  set dtUltimoPartoContingencia(String? val) =>
      _dtUltimoPartoContingencia = val;

  bool hasDtUltimoPartoContingencia() => _dtUltimoPartoContingencia != null;

  // "idStatusAnimal" field.
  int? _idStatusAnimal;
  int get idStatusAnimal => _idStatusAnimal ?? 0;
  set idStatusAnimal(int? val) => _idStatusAnimal = val;

  void incrementIdStatusAnimal(int amount) =>
      idStatusAnimal = idStatusAnimal + amount;

  bool hasIdStatusAnimal() => _idStatusAnimal != null;

  // "dtInducaoLactacao" field.
  DateTime? _dtInducaoLactacao;
  DateTime? get dtInducaoLactacao => _dtInducaoLactacao;
  set dtInducaoLactacao(DateTime? val) => _dtInducaoLactacao = val;

  bool hasDtInducaoLactacao() => _dtInducaoLactacao != null;

  // "dtDesmame" field.
  DateTime? _dtDesmame;
  DateTime? get dtDesmame => _dtDesmame;
  set dtDesmame(DateTime? val) => _dtDesmame = val;

  bool hasDtDesmame() => _dtDesmame != null;

  // "brincoAnimal" field.
  int? _brincoAnimal;
  int get brincoAnimal => _brincoAnimal ?? 0;
  set brincoAnimal(int? val) => _brincoAnimal = val;

  void incrementBrincoAnimal(int amount) =>
      brincoAnimal = brincoAnimal + amount;

  bool hasBrincoAnimal() => _brincoAnimal != null;

  // "brincoAnimalOrder" field.
  int? _brincoAnimalOrder;
  int get brincoAnimalOrder => _brincoAnimalOrder ?? 0;
  set brincoAnimalOrder(int? val) => _brincoAnimalOrder = val;

  void incrementBrincoAnimalOrder(int amount) =>
      brincoAnimalOrder = brincoAnimalOrder + amount;

  bool hasBrincoAnimalOrder() => _brincoAnimalOrder != null;

  // "uidAnimal" field.
  DocumentReference? _uidAnimal;
  DocumentReference? get uidAnimal => _uidAnimal;
  set uidAnimal(DocumentReference? val) => _uidAnimal = val;

  bool hasUidAnimal() => _uidAnimal != null;

  // "uidAnimalOffline" field.
  String? _uidAnimalOffline;
  String get uidAnimalOffline => _uidAnimalOffline ?? '';
  set uidAnimalOffline(String? val) => _uidAnimalOffline = val;

  bool hasUidAnimalOffline() => _uidAnimalOffline != null;

  // "itemUidIndexAtual" field.
  int? _itemUidIndexAtual;
  int get itemUidIndexAtual => _itemUidIndexAtual ?? 0;
  set itemUidIndexAtual(int? val) => _itemUidIndexAtual = val;

  void incrementItemUidIndexAtual(int amount) =>
      itemUidIndexAtual = itemUidIndexAtual + amount;

  bool hasItemUidIndexAtual() => _itemUidIndexAtual != null;

  static AnimaisProdutoresStruct fromMap(Map<String, dynamic> data) =>
      AnimaisProdutoresStruct(
        uidTecnicoPropriedade:
            data['uidTecnicoPropriedade'] as DocumentReference?,
        nomeAnimal: data['nomeAnimal'] as String?,
        racaAnimal: data['racaAnimal'] as String?,
        pesoAnimal: data['pesoAnimal'] as String?,
        dtNascimento: data['dtNascimento'] as String?,
        touro: data['touro'] as String?,
        vaca: data['vaca'] as String?,
        status: data['status'] as String?,
        grupoAnimal: data['grupoAnimal'] as String?,
        dtUltimaInseminacao: data['dtUltimaInseminacao'] as String?,
        dtUltimoParto: data['dtUltimoParto'] as String?,
        liberaInseminacao: data['liberaInseminacao'] as bool?,
        dtPartoPrevisto: data['dtPartoPrevisto'] as String?,
        dtSecPrevista: data['dtSecPrevista'] as String?,
        dtPrePartoPrevista: data['dtPrePartoPrevista'] as String?,
        dtPP: data['dtPP'] as String?,
        dtDgMais: data['dtDgMais'] as String?,
        dtDgMenos: data['dtDgMenos'] as String?,
        dtAborto: data['dtAborto'] as String?,
        dtSecagem: data['dtSecagem'] as String?,
        dtUltimoPP: data['dtUltimoPP'] as String?,
        nomeTouroUltimaInseminacao:
            data['nomeTouroUltimaInseminacao'] as String?,
        totalInseminacoes: castToType<int>(data['totalInseminacoes']),
        totalPartos: castToType<int>(data['totalPartos']),
        dtPreParto: data['dtPreParto'] as String?,
        motivoDescarteAnimal: data['motivoDescarteAnimal'] as String?,
        dtDescarteAnimal: data['dtDescarteAnimal'] as String?,
        dtUltimaAcao: data['dtUltimaAcao'] as String?,
        compararDtUltimaInseminacao:
            data['compararDtUltimaInseminacao'] as DateTime?,
        nomeBrincoConcat: data['nomeBrincoConcat'] as String?,
        idGrupoAnimal: castToType<int>(data['idGrupoAnimal']),
        dtUltimoPartoContingencia: data['dtUltimoPartoContingencia'] as String?,
        idStatusAnimal: castToType<int>(data['idStatusAnimal']),
        dtInducaoLactacao: data['dtInducaoLactacao'] as DateTime?,
        dtDesmame: data['dtDesmame'] as DateTime?,
        brincoAnimal: castToType<int>(data['brincoAnimal']),
        brincoAnimalOrder: castToType<int>(data['brincoAnimalOrder']),
        uidAnimal: data['uidAnimal'] as DocumentReference?,
        uidAnimalOffline: data['uidAnimalOffline'] as String?,
        itemUidIndexAtual: castToType<int>(data['itemUidIndexAtual']),
      );

  static AnimaisProdutoresStruct? maybeFromMap(dynamic data) => data is Map
      ? AnimaisProdutoresStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'uidTecnicoPropriedade': _uidTecnicoPropriedade,
        'nomeAnimal': _nomeAnimal,
        'racaAnimal': _racaAnimal,
        'pesoAnimal': _pesoAnimal,
        'dtNascimento': _dtNascimento,
        'touro': _touro,
        'vaca': _vaca,
        'status': _status,
        'grupoAnimal': _grupoAnimal,
        'dtUltimaInseminacao': _dtUltimaInseminacao,
        'dtUltimoParto': _dtUltimoParto,
        'liberaInseminacao': _liberaInseminacao,
        'dtPartoPrevisto': _dtPartoPrevisto,
        'dtSecPrevista': _dtSecPrevista,
        'dtPrePartoPrevista': _dtPrePartoPrevista,
        'dtPP': _dtPP,
        'dtDgMais': _dtDgMais,
        'dtDgMenos': _dtDgMenos,
        'dtAborto': _dtAborto,
        'dtSecagem': _dtSecagem,
        'dtUltimoPP': _dtUltimoPP,
        'nomeTouroUltimaInseminacao': _nomeTouroUltimaInseminacao,
        'totalInseminacoes': _totalInseminacoes,
        'totalPartos': _totalPartos,
        'dtPreParto': _dtPreParto,
        'motivoDescarteAnimal': _motivoDescarteAnimal,
        'dtDescarteAnimal': _dtDescarteAnimal,
        'dtUltimaAcao': _dtUltimaAcao,
        'compararDtUltimaInseminacao': _compararDtUltimaInseminacao,
        'nomeBrincoConcat': _nomeBrincoConcat,
        'idGrupoAnimal': _idGrupoAnimal,
        'dtUltimoPartoContingencia': _dtUltimoPartoContingencia,
        'idStatusAnimal': _idStatusAnimal,
        'dtInducaoLactacao': _dtInducaoLactacao,
        'dtDesmame': _dtDesmame,
        'brincoAnimal': _brincoAnimal,
        'brincoAnimalOrder': _brincoAnimalOrder,
        'uidAnimal': _uidAnimal,
        'uidAnimalOffline': _uidAnimalOffline,
        'itemUidIndexAtual': _itemUidIndexAtual,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'uidTecnicoPropriedade': serializeParam(
          _uidTecnicoPropriedade,
          ParamType.DocumentReference,
        ),
        'nomeAnimal': serializeParam(
          _nomeAnimal,
          ParamType.String,
        ),
        'racaAnimal': serializeParam(
          _racaAnimal,
          ParamType.String,
        ),
        'pesoAnimal': serializeParam(
          _pesoAnimal,
          ParamType.String,
        ),
        'dtNascimento': serializeParam(
          _dtNascimento,
          ParamType.String,
        ),
        'touro': serializeParam(
          _touro,
          ParamType.String,
        ),
        'vaca': serializeParam(
          _vaca,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'grupoAnimal': serializeParam(
          _grupoAnimal,
          ParamType.String,
        ),
        'dtUltimaInseminacao': serializeParam(
          _dtUltimaInseminacao,
          ParamType.String,
        ),
        'dtUltimoParto': serializeParam(
          _dtUltimoParto,
          ParamType.String,
        ),
        'liberaInseminacao': serializeParam(
          _liberaInseminacao,
          ParamType.bool,
        ),
        'dtPartoPrevisto': serializeParam(
          _dtPartoPrevisto,
          ParamType.String,
        ),
        'dtSecPrevista': serializeParam(
          _dtSecPrevista,
          ParamType.String,
        ),
        'dtPrePartoPrevista': serializeParam(
          _dtPrePartoPrevista,
          ParamType.String,
        ),
        'dtPP': serializeParam(
          _dtPP,
          ParamType.String,
        ),
        'dtDgMais': serializeParam(
          _dtDgMais,
          ParamType.String,
        ),
        'dtDgMenos': serializeParam(
          _dtDgMenos,
          ParamType.String,
        ),
        'dtAborto': serializeParam(
          _dtAborto,
          ParamType.String,
        ),
        'dtSecagem': serializeParam(
          _dtSecagem,
          ParamType.String,
        ),
        'dtUltimoPP': serializeParam(
          _dtUltimoPP,
          ParamType.String,
        ),
        'nomeTouroUltimaInseminacao': serializeParam(
          _nomeTouroUltimaInseminacao,
          ParamType.String,
        ),
        'totalInseminacoes': serializeParam(
          _totalInseminacoes,
          ParamType.int,
        ),
        'totalPartos': serializeParam(
          _totalPartos,
          ParamType.int,
        ),
        'dtPreParto': serializeParam(
          _dtPreParto,
          ParamType.String,
        ),
        'motivoDescarteAnimal': serializeParam(
          _motivoDescarteAnimal,
          ParamType.String,
        ),
        'dtDescarteAnimal': serializeParam(
          _dtDescarteAnimal,
          ParamType.String,
        ),
        'dtUltimaAcao': serializeParam(
          _dtUltimaAcao,
          ParamType.String,
        ),
        'compararDtUltimaInseminacao': serializeParam(
          _compararDtUltimaInseminacao,
          ParamType.DateTime,
        ),
        'nomeBrincoConcat': serializeParam(
          _nomeBrincoConcat,
          ParamType.String,
        ),
        'idGrupoAnimal': serializeParam(
          _idGrupoAnimal,
          ParamType.int,
        ),
        'dtUltimoPartoContingencia': serializeParam(
          _dtUltimoPartoContingencia,
          ParamType.String,
        ),
        'idStatusAnimal': serializeParam(
          _idStatusAnimal,
          ParamType.int,
        ),
        'dtInducaoLactacao': serializeParam(
          _dtInducaoLactacao,
          ParamType.DateTime,
        ),
        'dtDesmame': serializeParam(
          _dtDesmame,
          ParamType.DateTime,
        ),
        'brincoAnimal': serializeParam(
          _brincoAnimal,
          ParamType.int,
        ),
        'brincoAnimalOrder': serializeParam(
          _brincoAnimalOrder,
          ParamType.int,
        ),
        'uidAnimal': serializeParam(
          _uidAnimal,
          ParamType.DocumentReference,
        ),
        'uidAnimalOffline': serializeParam(
          _uidAnimalOffline,
          ParamType.String,
        ),
        'itemUidIndexAtual': serializeParam(
          _itemUidIndexAtual,
          ParamType.int,
        ),
      }.withoutNulls;

  static AnimaisProdutoresStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      AnimaisProdutoresStruct(
        uidTecnicoPropriedade: deserializeParam(
          data['uidTecnicoPropriedade'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['tecnico', 'propriedades'],
        ),
        nomeAnimal: deserializeParam(
          data['nomeAnimal'],
          ParamType.String,
          false,
        ),
        racaAnimal: deserializeParam(
          data['racaAnimal'],
          ParamType.String,
          false,
        ),
        pesoAnimal: deserializeParam(
          data['pesoAnimal'],
          ParamType.String,
          false,
        ),
        dtNascimento: deserializeParam(
          data['dtNascimento'],
          ParamType.String,
          false,
        ),
        touro: deserializeParam(
          data['touro'],
          ParamType.String,
          false,
        ),
        vaca: deserializeParam(
          data['vaca'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        grupoAnimal: deserializeParam(
          data['grupoAnimal'],
          ParamType.String,
          false,
        ),
        dtUltimaInseminacao: deserializeParam(
          data['dtUltimaInseminacao'],
          ParamType.String,
          false,
        ),
        dtUltimoParto: deserializeParam(
          data['dtUltimoParto'],
          ParamType.String,
          false,
        ),
        liberaInseminacao: deserializeParam(
          data['liberaInseminacao'],
          ParamType.bool,
          false,
        ),
        dtPartoPrevisto: deserializeParam(
          data['dtPartoPrevisto'],
          ParamType.String,
          false,
        ),
        dtSecPrevista: deserializeParam(
          data['dtSecPrevista'],
          ParamType.String,
          false,
        ),
        dtPrePartoPrevista: deserializeParam(
          data['dtPrePartoPrevista'],
          ParamType.String,
          false,
        ),
        dtPP: deserializeParam(
          data['dtPP'],
          ParamType.String,
          false,
        ),
        dtDgMais: deserializeParam(
          data['dtDgMais'],
          ParamType.String,
          false,
        ),
        dtDgMenos: deserializeParam(
          data['dtDgMenos'],
          ParamType.String,
          false,
        ),
        dtAborto: deserializeParam(
          data['dtAborto'],
          ParamType.String,
          false,
        ),
        dtSecagem: deserializeParam(
          data['dtSecagem'],
          ParamType.String,
          false,
        ),
        dtUltimoPP: deserializeParam(
          data['dtUltimoPP'],
          ParamType.String,
          false,
        ),
        nomeTouroUltimaInseminacao: deserializeParam(
          data['nomeTouroUltimaInseminacao'],
          ParamType.String,
          false,
        ),
        totalInseminacoes: deserializeParam(
          data['totalInseminacoes'],
          ParamType.int,
          false,
        ),
        totalPartos: deserializeParam(
          data['totalPartos'],
          ParamType.int,
          false,
        ),
        dtPreParto: deserializeParam(
          data['dtPreParto'],
          ParamType.String,
          false,
        ),
        motivoDescarteAnimal: deserializeParam(
          data['motivoDescarteAnimal'],
          ParamType.String,
          false,
        ),
        dtDescarteAnimal: deserializeParam(
          data['dtDescarteAnimal'],
          ParamType.String,
          false,
        ),
        dtUltimaAcao: deserializeParam(
          data['dtUltimaAcao'],
          ParamType.String,
          false,
        ),
        compararDtUltimaInseminacao: deserializeParam(
          data['compararDtUltimaInseminacao'],
          ParamType.DateTime,
          false,
        ),
        nomeBrincoConcat: deserializeParam(
          data['nomeBrincoConcat'],
          ParamType.String,
          false,
        ),
        idGrupoAnimal: deserializeParam(
          data['idGrupoAnimal'],
          ParamType.int,
          false,
        ),
        dtUltimoPartoContingencia: deserializeParam(
          data['dtUltimoPartoContingencia'],
          ParamType.String,
          false,
        ),
        idStatusAnimal: deserializeParam(
          data['idStatusAnimal'],
          ParamType.int,
          false,
        ),
        dtInducaoLactacao: deserializeParam(
          data['dtInducaoLactacao'],
          ParamType.DateTime,
          false,
        ),
        dtDesmame: deserializeParam(
          data['dtDesmame'],
          ParamType.DateTime,
          false,
        ),
        brincoAnimal: deserializeParam(
          data['brincoAnimal'],
          ParamType.int,
          false,
        ),
        brincoAnimalOrder: deserializeParam(
          data['brincoAnimalOrder'],
          ParamType.int,
          false,
        ),
        uidAnimal: deserializeParam(
          data['uidAnimal'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['tecnico', 'animaisProdutores'],
        ),
        uidAnimalOffline: deserializeParam(
          data['uidAnimalOffline'],
          ParamType.String,
          false,
        ),
        itemUidIndexAtual: deserializeParam(
          data['itemUidIndexAtual'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'AnimaisProdutoresStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AnimaisProdutoresStruct &&
        uidTecnicoPropriedade == other.uidTecnicoPropriedade &&
        nomeAnimal == other.nomeAnimal &&
        racaAnimal == other.racaAnimal &&
        pesoAnimal == other.pesoAnimal &&
        dtNascimento == other.dtNascimento &&
        touro == other.touro &&
        vaca == other.vaca &&
        status == other.status &&
        grupoAnimal == other.grupoAnimal &&
        dtUltimaInseminacao == other.dtUltimaInseminacao &&
        dtUltimoParto == other.dtUltimoParto &&
        liberaInseminacao == other.liberaInseminacao &&
        dtPartoPrevisto == other.dtPartoPrevisto &&
        dtSecPrevista == other.dtSecPrevista &&
        dtPrePartoPrevista == other.dtPrePartoPrevista &&
        dtPP == other.dtPP &&
        dtDgMais == other.dtDgMais &&
        dtDgMenos == other.dtDgMenos &&
        dtAborto == other.dtAborto &&
        dtSecagem == other.dtSecagem &&
        dtUltimoPP == other.dtUltimoPP &&
        nomeTouroUltimaInseminacao == other.nomeTouroUltimaInseminacao &&
        totalInseminacoes == other.totalInseminacoes &&
        totalPartos == other.totalPartos &&
        dtPreParto == other.dtPreParto &&
        motivoDescarteAnimal == other.motivoDescarteAnimal &&
        dtDescarteAnimal == other.dtDescarteAnimal &&
        dtUltimaAcao == other.dtUltimaAcao &&
        compararDtUltimaInseminacao == other.compararDtUltimaInseminacao &&
        nomeBrincoConcat == other.nomeBrincoConcat &&
        idGrupoAnimal == other.idGrupoAnimal &&
        dtUltimoPartoContingencia == other.dtUltimoPartoContingencia &&
        idStatusAnimal == other.idStatusAnimal &&
        dtInducaoLactacao == other.dtInducaoLactacao &&
        dtDesmame == other.dtDesmame &&
        brincoAnimal == other.brincoAnimal &&
        brincoAnimalOrder == other.brincoAnimalOrder &&
        uidAnimal == other.uidAnimal &&
        uidAnimalOffline == other.uidAnimalOffline &&
        itemUidIndexAtual == other.itemUidIndexAtual;
  }

  @override
  int get hashCode => const ListEquality().hash([
        uidTecnicoPropriedade,
        nomeAnimal,
        racaAnimal,
        pesoAnimal,
        dtNascimento,
        touro,
        vaca,
        status,
        grupoAnimal,
        dtUltimaInseminacao,
        dtUltimoParto,
        liberaInseminacao,
        dtPartoPrevisto,
        dtSecPrevista,
        dtPrePartoPrevista,
        dtPP,
        dtDgMais,
        dtDgMenos,
        dtAborto,
        dtSecagem,
        dtUltimoPP,
        nomeTouroUltimaInseminacao,
        totalInseminacoes,
        totalPartos,
        dtPreParto,
        motivoDescarteAnimal,
        dtDescarteAnimal,
        dtUltimaAcao,
        compararDtUltimaInseminacao,
        nomeBrincoConcat,
        idGrupoAnimal,
        dtUltimoPartoContingencia,
        idStatusAnimal,
        dtInducaoLactacao,
        dtDesmame,
        brincoAnimal,
        brincoAnimalOrder,
        uidAnimal,
        uidAnimalOffline,
        itemUidIndexAtual
      ]);
}

AnimaisProdutoresStruct createAnimaisProdutoresStruct({
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
  DocumentReference? uidAnimal,
  String? uidAnimalOffline,
  int? itemUidIndexAtual,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AnimaisProdutoresStruct(
      uidTecnicoPropriedade: uidTecnicoPropriedade,
      nomeAnimal: nomeAnimal,
      racaAnimal: racaAnimal,
      pesoAnimal: pesoAnimal,
      dtNascimento: dtNascimento,
      touro: touro,
      vaca: vaca,
      status: status,
      grupoAnimal: grupoAnimal,
      dtUltimaInseminacao: dtUltimaInseminacao,
      dtUltimoParto: dtUltimoParto,
      liberaInseminacao: liberaInseminacao,
      dtPartoPrevisto: dtPartoPrevisto,
      dtSecPrevista: dtSecPrevista,
      dtPrePartoPrevista: dtPrePartoPrevista,
      dtPP: dtPP,
      dtDgMais: dtDgMais,
      dtDgMenos: dtDgMenos,
      dtAborto: dtAborto,
      dtSecagem: dtSecagem,
      dtUltimoPP: dtUltimoPP,
      nomeTouroUltimaInseminacao: nomeTouroUltimaInseminacao,
      totalInseminacoes: totalInseminacoes,
      totalPartos: totalPartos,
      dtPreParto: dtPreParto,
      motivoDescarteAnimal: motivoDescarteAnimal,
      dtDescarteAnimal: dtDescarteAnimal,
      dtUltimaAcao: dtUltimaAcao,
      compararDtUltimaInseminacao: compararDtUltimaInseminacao,
      nomeBrincoConcat: nomeBrincoConcat,
      idGrupoAnimal: idGrupoAnimal,
      dtUltimoPartoContingencia: dtUltimoPartoContingencia,
      idStatusAnimal: idStatusAnimal,
      dtInducaoLactacao: dtInducaoLactacao,
      dtDesmame: dtDesmame,
      brincoAnimal: brincoAnimal,
      brincoAnimalOrder: brincoAnimalOrder,
      uidAnimal: uidAnimal,
      uidAnimalOffline: uidAnimalOffline,
      itemUidIndexAtual: itemUidIndexAtual,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AnimaisProdutoresStruct? updateAnimaisProdutoresStruct(
  AnimaisProdutoresStruct? animaisProdutores, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    animaisProdutores
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAnimaisProdutoresStructData(
  Map<String, dynamic> firestoreData,
  AnimaisProdutoresStruct? animaisProdutores,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (animaisProdutores == null) {
    return;
  }
  if (animaisProdutores.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && animaisProdutores.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final animaisProdutoresData =
      getAnimaisProdutoresFirestoreData(animaisProdutores, forFieldValue);
  final nestedData =
      animaisProdutoresData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = animaisProdutores.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAnimaisProdutoresFirestoreData(
  AnimaisProdutoresStruct? animaisProdutores, [
  bool forFieldValue = false,
]) {
  if (animaisProdutores == null) {
    return {};
  }
  final firestoreData = mapToFirestore(animaisProdutores.toMap());

  // Add any Firestore field values
  animaisProdutores.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAnimaisProdutoresListFirestoreData(
  List<AnimaisProdutoresStruct>? animaisProdutoress,
) =>
    animaisProdutoress
        ?.map((e) => getAnimaisProdutoresFirestoreData(e, true))
        .toList() ??
    [];
