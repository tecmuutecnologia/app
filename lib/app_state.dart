import 'package:flutter/material.dart';
import 'flutter_flow/request_manager.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _animaisProdutoresOffline = prefs
              .getStringList('ff_animaisProdutoresOffline')
              ?.map((x) {
                try {
                  return AnimaisProdutoresStruct.fromSerializableMap(
                      jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _animaisProdutoresOffline;
    });
    _safeInit(() {
      _animaisProdutoresEditados = prefs
              .getStringList('ff_animaisProdutoresEditados')
              ?.map((x) {
                try {
                  return AnimaisProdutoresStruct.fromSerializableMap(
                      jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _animaisProdutoresEditados;
    });
    _safeInit(() {
      _acoesOffline = prefs
              .getStringList('ff_acoesOffline')
              ?.map((x) {
                try {
                  return AcoesStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _acoesOffline;
    });
    _safeInit(() {
      _acoesPreferidas =
          prefs.getStringList('ff_acoesPreferidas') ?? _acoesPreferidas;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  double _despesasNoMes = 0.0;
  double get despesasNoMes => _despesasNoMes;
  set despesasNoMes(double value) {
    _despesasNoMes = value;
  }

  double _precoRecebidoLitro = 0.0;
  double get precoRecebidoLitro => _precoRecebidoLitro;
  set precoRecebidoLitro(double value) {
    _precoRecebidoLitro = value;
  }

  List<AnimaisProdutoresStruct> _animaisProdutoresOffline = [];
  List<AnimaisProdutoresStruct> get animaisProdutoresOffline =>
      _animaisProdutoresOffline;
  set animaisProdutoresOffline(List<AnimaisProdutoresStruct> value) {
    _animaisProdutoresOffline = value;
    prefs.setStringList('ff_animaisProdutoresOffline',
        value.map((x) => x.serialize()).toList());
  }

  void addToAnimaisProdutoresOffline(AnimaisProdutoresStruct value) {
    animaisProdutoresOffline.add(value);
    prefs.setStringList('ff_animaisProdutoresOffline',
        _animaisProdutoresOffline.map((x) => x.serialize()).toList());
  }

  void removeFromAnimaisProdutoresOffline(AnimaisProdutoresStruct value) {
    animaisProdutoresOffline.remove(value);
    prefs.setStringList('ff_animaisProdutoresOffline',
        _animaisProdutoresOffline.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromAnimaisProdutoresOffline(int index) {
    animaisProdutoresOffline.removeAt(index);
    prefs.setStringList('ff_animaisProdutoresOffline',
        _animaisProdutoresOffline.map((x) => x.serialize()).toList());
  }

  void updateAnimaisProdutoresOfflineAtIndex(
    int index,
    AnimaisProdutoresStruct Function(AnimaisProdutoresStruct) updateFn,
  ) {
    animaisProdutoresOffline[index] =
        updateFn(_animaisProdutoresOffline[index]);
    prefs.setStringList('ff_animaisProdutoresOffline',
        _animaisProdutoresOffline.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInAnimaisProdutoresOffline(
      int index, AnimaisProdutoresStruct value) {
    animaisProdutoresOffline.insert(index, value);
    prefs.setStringList('ff_animaisProdutoresOffline',
        _animaisProdutoresOffline.map((x) => x.serialize()).toList());
  }

  List<AnimaisProdutoresStruct> _animaisProdutoresEditados = [];
  List<AnimaisProdutoresStruct> get animaisProdutoresEditados =>
      _animaisProdutoresEditados;
  set animaisProdutoresEditados(List<AnimaisProdutoresStruct> value) {
    _animaisProdutoresEditados = value;
    prefs.setStringList('ff_animaisProdutoresEditados',
        value.map((x) => x.serialize()).toList());
  }

  void addToAnimaisProdutoresEditados(AnimaisProdutoresStruct value) {
    animaisProdutoresEditados.add(value);
    prefs.setStringList('ff_animaisProdutoresEditados',
        _animaisProdutoresEditados.map((x) => x.serialize()).toList());
  }

  void removeFromAnimaisProdutoresEditados(AnimaisProdutoresStruct value) {
    animaisProdutoresEditados.remove(value);
    prefs.setStringList('ff_animaisProdutoresEditados',
        _animaisProdutoresEditados.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromAnimaisProdutoresEditados(int index) {
    animaisProdutoresEditados.removeAt(index);
    prefs.setStringList('ff_animaisProdutoresEditados',
        _animaisProdutoresEditados.map((x) => x.serialize()).toList());
  }

  void updateAnimaisProdutoresEditadosAtIndex(
    int index,
    AnimaisProdutoresStruct Function(AnimaisProdutoresStruct) updateFn,
  ) {
    animaisProdutoresEditados[index] =
        updateFn(_animaisProdutoresEditados[index]);
    prefs.setStringList('ff_animaisProdutoresEditados',
        _animaisProdutoresEditados.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInAnimaisProdutoresEditados(
      int index, AnimaisProdutoresStruct value) {
    animaisProdutoresEditados.insert(index, value);
    prefs.setStringList('ff_animaisProdutoresEditados',
        _animaisProdutoresEditados.map((x) => x.serialize()).toList());
  }

  List<AcoesStruct> _acoesOffline = [];
  List<AcoesStruct> get acoesOffline => _acoesOffline;
  set acoesOffline(List<AcoesStruct> value) {
    _acoesOffline = value;
    prefs.setStringList(
        'ff_acoesOffline', value.map((x) => x.serialize()).toList());
  }

  void addToAcoesOffline(AcoesStruct value) {
    acoesOffline.add(value);
    prefs.setStringList(
        'ff_acoesOffline', _acoesOffline.map((x) => x.serialize()).toList());
  }

  void removeFromAcoesOffline(AcoesStruct value) {
    acoesOffline.remove(value);
    prefs.setStringList(
        'ff_acoesOffline', _acoesOffline.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromAcoesOffline(int index) {
    acoesOffline.removeAt(index);
    prefs.setStringList(
        'ff_acoesOffline', _acoesOffline.map((x) => x.serialize()).toList());
  }

  void updateAcoesOfflineAtIndex(
    int index,
    AcoesStruct Function(AcoesStruct) updateFn,
  ) {
    acoesOffline[index] = updateFn(_acoesOffline[index]);
    prefs.setStringList(
        'ff_acoesOffline', _acoesOffline.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInAcoesOffline(int index, AcoesStruct value) {
    acoesOffline.insert(index, value);
    prefs.setStringList(
        'ff_acoesOffline', _acoesOffline.map((x) => x.serialize()).toList());
  }

  List<String> _acoesPreferidas = [];
  List<String> get acoesPreferidas => _acoesPreferidas;
  set acoesPreferidas(List<String> value) {
    _acoesPreferidas = value;
    prefs.setStringList('ff_acoesPreferidas', value);
  }

  void addToAcoesPreferidas(String value) {
    acoesPreferidas.add(value);
    prefs.setStringList('ff_acoesPreferidas', _acoesPreferidas);
  }

  void removeFromAcoesPreferidas(String value) {
    acoesPreferidas.remove(value);
    prefs.setStringList('ff_acoesPreferidas', _acoesPreferidas);
  }

  bool isAcaoPreferida(String acao) {
    return _acoesPreferidas.contains(acao);
  }

  final _allAnimaisProdutorManager =
      StreamRequestManager<List<AnimaisProdutoresRecord>>();
  Stream<List<AnimaisProdutoresRecord>> allAnimaisProdutor({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<AnimaisProdutoresRecord>> Function() requestFn,
  }) =>
      _allAnimaisProdutorManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearAllAnimaisProdutorCache() => _allAnimaisProdutorManager.clear();
  void clearAllAnimaisProdutorCacheKey(String? uniqueKey) =>
      _allAnimaisProdutorManager.clearRequest(uniqueKey);

  final _statusAnimaisGeralManager =
      StreamRequestManager<List<StatusAnimaisRecord>>();
  Stream<List<StatusAnimaisRecord>> statusAnimaisGeral({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<StatusAnimaisRecord>> Function() requestFn,
  }) =>
      _statusAnimaisGeralManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearStatusAnimaisGeralCache() => _statusAnimaisGeralManager.clear();
  void clearStatusAnimaisGeralCacheKey(String? uniqueKey) =>
      _statusAnimaisGeralManager.clearRequest(uniqueKey);

  final _racasGeralManager = StreamRequestManager<List<RacasRecord>>();
  Stream<List<RacasRecord>> racasGeral({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<RacasRecord>> Function() requestFn,
  }) =>
      _racasGeralManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearRacasGeralCache() => _racasGeralManager.clear();
  void clearRacasGeralCacheKey(String? uniqueKey) =>
      _racasGeralManager.clearRequest(uniqueKey);

  final _gruposGeralManager = StreamRequestManager<List<GrupoRecord>>();
  Stream<List<GrupoRecord>> gruposGeral({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<GrupoRecord>> Function() requestFn,
  }) =>
      _gruposGeralManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearGruposGeralCache() => _gruposGeralManager.clear();
  void clearGruposGeralCacheKey(String? uniqueKey) =>
      _gruposGeralManager.clearRequest(uniqueKey);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}
