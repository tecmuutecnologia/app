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
      _contador = prefs.getInt('ff_contador') ?? _contador;
    });
    _safeInit(() {
      _acoesExistentes = prefs
              .getStringList('ff_acoesExistentes')
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
          _acoesExistentes;
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
      _acoesSanitarioExistentes = prefs
              .getStringList('ff_acoesSanitarioExistentes')
              ?.map((x) {
                try {
                  return AcoesSanitarioStruct.fromSerializableMap(
                      jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _acoesSanitarioExistentes;
    });
    _safeInit(() {
      _acoesSanitarioOffline = prefs
              .getStringList('ff_acoesSanitarioOffline')
              ?.map((x) {
                try {
                  return AcoesSanitarioStruct.fromSerializableMap(
                      jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _acoesSanitarioOffline;
    });
    _safeInit(() {
      _animaisApagadosExistentesOffline = prefs
              .getStringList('ff_animaisApagadosExistentesOffline')
              ?.map((x) {
                try {
                  return AnimaisApagadosExistentesOfflineStruct
                      .fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _animaisApagadosExistentesOffline;
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

  int _contador = -1;
  int get contador => _contador;
  set contador(int value) {
    _contador = value;
    prefs.setInt('ff_contador', value);
  }

  List<AcoesStruct> _acoesExistentes = [];
  List<AcoesStruct> get acoesExistentes => _acoesExistentes;
  set acoesExistentes(List<AcoesStruct> value) {
    _acoesExistentes = value;
    prefs.setStringList(
        'ff_acoesExistentes', value.map((x) => x.serialize()).toList());
  }

  void addToAcoesExistentes(AcoesStruct value) {
    acoesExistentes.add(value);
    prefs.setStringList('ff_acoesExistentes',
        _acoesExistentes.map((x) => x.serialize()).toList());
  }

  void removeFromAcoesExistentes(AcoesStruct value) {
    acoesExistentes.remove(value);
    prefs.setStringList('ff_acoesExistentes',
        _acoesExistentes.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromAcoesExistentes(int index) {
    acoesExistentes.removeAt(index);
    prefs.setStringList('ff_acoesExistentes',
        _acoesExistentes.map((x) => x.serialize()).toList());
  }

  void updateAcoesExistentesAtIndex(
    int index,
    AcoesStruct Function(AcoesStruct) updateFn,
  ) {
    acoesExistentes[index] = updateFn(_acoesExistentes[index]);
    prefs.setStringList('ff_acoesExistentes',
        _acoesExistentes.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInAcoesExistentes(int index, AcoesStruct value) {
    acoesExistentes.insert(index, value);
    prefs.setStringList('ff_acoesExistentes',
        _acoesExistentes.map((x) => x.serialize()).toList());
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

  List<AcoesSanitarioStruct> _acoesSanitarioExistentes = [];
  List<AcoesSanitarioStruct> get acoesSanitarioExistentes =>
      _acoesSanitarioExistentes;
  set acoesSanitarioExistentes(List<AcoesSanitarioStruct> value) {
    _acoesSanitarioExistentes = value;
    prefs.setStringList('ff_acoesSanitarioExistentes',
        value.map((x) => x.serialize()).toList());
  }

  void addToAcoesSanitarioExistentes(AcoesSanitarioStruct value) {
    acoesSanitarioExistentes.add(value);
    prefs.setStringList('ff_acoesSanitarioExistentes',
        _acoesSanitarioExistentes.map((x) => x.serialize()).toList());
  }

  void removeFromAcoesSanitarioExistentes(AcoesSanitarioStruct value) {
    acoesSanitarioExistentes.remove(value);
    prefs.setStringList('ff_acoesSanitarioExistentes',
        _acoesSanitarioExistentes.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromAcoesSanitarioExistentes(int index) {
    acoesSanitarioExistentes.removeAt(index);
    prefs.setStringList('ff_acoesSanitarioExistentes',
        _acoesSanitarioExistentes.map((x) => x.serialize()).toList());
  }

  void updateAcoesSanitarioExistentesAtIndex(
    int index,
    AcoesSanitarioStruct Function(AcoesSanitarioStruct) updateFn,
  ) {
    acoesSanitarioExistentes[index] =
        updateFn(_acoesSanitarioExistentes[index]);
    prefs.setStringList('ff_acoesSanitarioExistentes',
        _acoesSanitarioExistentes.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInAcoesSanitarioExistentes(
      int index, AcoesSanitarioStruct value) {
    acoesSanitarioExistentes.insert(index, value);
    prefs.setStringList('ff_acoesSanitarioExistentes',
        _acoesSanitarioExistentes.map((x) => x.serialize()).toList());
  }

  List<AcoesSanitarioStruct> _acoesSanitarioOffline = [];
  List<AcoesSanitarioStruct> get acoesSanitarioOffline =>
      _acoesSanitarioOffline;
  set acoesSanitarioOffline(List<AcoesSanitarioStruct> value) {
    _acoesSanitarioOffline = value;
    prefs.setStringList(
        'ff_acoesSanitarioOffline', value.map((x) => x.serialize()).toList());
  }

  void addToAcoesSanitarioOffline(AcoesSanitarioStruct value) {
    acoesSanitarioOffline.add(value);
    prefs.setStringList('ff_acoesSanitarioOffline',
        _acoesSanitarioOffline.map((x) => x.serialize()).toList());
  }

  void removeFromAcoesSanitarioOffline(AcoesSanitarioStruct value) {
    acoesSanitarioOffline.remove(value);
    prefs.setStringList('ff_acoesSanitarioOffline',
        _acoesSanitarioOffline.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromAcoesSanitarioOffline(int index) {
    acoesSanitarioOffline.removeAt(index);
    prefs.setStringList('ff_acoesSanitarioOffline',
        _acoesSanitarioOffline.map((x) => x.serialize()).toList());
  }

  void updateAcoesSanitarioOfflineAtIndex(
    int index,
    AcoesSanitarioStruct Function(AcoesSanitarioStruct) updateFn,
  ) {
    acoesSanitarioOffline[index] = updateFn(_acoesSanitarioOffline[index]);
    prefs.setStringList('ff_acoesSanitarioOffline',
        _acoesSanitarioOffline.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInAcoesSanitarioOffline(
      int index, AcoesSanitarioStruct value) {
    acoesSanitarioOffline.insert(index, value);
    prefs.setStringList('ff_acoesSanitarioOffline',
        _acoesSanitarioOffline.map((x) => x.serialize()).toList());
  }

  int _verificadorIgualdade = 0;
  int get verificadorIgualdade => _verificadorIgualdade;
  set verificadorIgualdade(int value) {
    _verificadorIgualdade = value;
  }

  List<AnimaisApagadosExistentesOfflineStruct>
      _animaisApagadosExistentesOffline = [];
  List<AnimaisApagadosExistentesOfflineStruct>
      get animaisApagadosExistentesOffline => _animaisApagadosExistentesOffline;
  set animaisApagadosExistentesOffline(
      List<AnimaisApagadosExistentesOfflineStruct> value) {
    _animaisApagadosExistentesOffline = value;
    prefs.setStringList('ff_animaisApagadosExistentesOffline',
        value.map((x) => x.serialize()).toList());
  }

  void addToAnimaisApagadosExistentesOffline(
      AnimaisApagadosExistentesOfflineStruct value) {
    animaisApagadosExistentesOffline.add(value);
    prefs.setStringList('ff_animaisApagadosExistentesOffline',
        _animaisApagadosExistentesOffline.map((x) => x.serialize()).toList());
  }

  void removeFromAnimaisApagadosExistentesOffline(
      AnimaisApagadosExistentesOfflineStruct value) {
    animaisApagadosExistentesOffline.remove(value);
    prefs.setStringList('ff_animaisApagadosExistentesOffline',
        _animaisApagadosExistentesOffline.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromAnimaisApagadosExistentesOffline(int index) {
    animaisApagadosExistentesOffline.removeAt(index);
    prefs.setStringList('ff_animaisApagadosExistentesOffline',
        _animaisApagadosExistentesOffline.map((x) => x.serialize()).toList());
  }

  void updateAnimaisApagadosExistentesOfflineAtIndex(
    int index,
    AnimaisApagadosExistentesOfflineStruct Function(
            AnimaisApagadosExistentesOfflineStruct)
        updateFn,
  ) {
    animaisApagadosExistentesOffline[index] =
        updateFn(_animaisApagadosExistentesOffline[index]);
    prefs.setStringList('ff_animaisApagadosExistentesOffline',
        _animaisApagadosExistentesOffline.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInAnimaisApagadosExistentesOffline(
      int index, AnimaisApagadosExistentesOfflineStruct value) {
    animaisApagadosExistentesOffline.insert(index, value);
    prefs.setStringList('ff_animaisApagadosExistentesOffline',
        _animaisApagadosExistentesOffline.map((x) => x.serialize()).toList());
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
