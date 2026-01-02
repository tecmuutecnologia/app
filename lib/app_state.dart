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
      _grupo = prefs
              .getStringList('ff_grupo')
              ?.map((x) {
                try {
                  return GrupoStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _grupo;
    });
    _safeInit(() {
      _racas = prefs
              .getStringList('ff_racas')
              ?.map((x) {
                try {
                  return RacasStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _racas;
    });
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
      _animaisProdutoresExistentes = prefs
              .getStringList('ff_animaisProdutoresExistentes')
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
          _animaisProdutoresExistentes;
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
      _verificaInternet =
          prefs.getInt('ff_verificaInternet') ?? _verificaInternet;
    });
    _safeInit(() {
      _resumoDaVisita = prefs
              .getStringList('ff_resumoDaVisita')
              ?.map((x) {
                try {
                  return ResumoDaVisitaStruct.fromSerializableMap(
                      jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _resumoDaVisita;
    });
    _safeInit(() {
      _acoesDaVisita = prefs
              .getStringList('ff_acoesDaVisita')
              ?.map((x) {
                try {
                  return AcoesDaVisitaStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _acoesDaVisita;
    });
    _safeInit(() {
      _tratamentos = prefs
              .getStringList('ff_tratamentos')
              ?.map((x) {
                try {
                  return TratamentosStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _tratamentos;
    });
    _safeInit(() {
      _recomendacoes = prefs
              .getStringList('ff_recomendacoes')
              ?.map((x) {
                try {
                  return RecomendacoesStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _recomendacoes;
    });
    _safeInit(() {
      _contador2 = prefs.getInt('ff_contador2') ?? _contador2;
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
      _tipoAcoes = prefs
              .getStringList('ff_tipoAcoes')
              ?.map((x) {
                try {
                  return TipoAcoesStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _tipoAcoes;
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

  bool _grupoAnimalVacas = true;
  bool get grupoAnimalVacas => _grupoAnimalVacas;
  set grupoAnimalVacas(bool value) {
    _grupoAnimalVacas = value;
  }

  bool _grupoAnimalNovilhas = true;
  bool get grupoAnimalNovilhas => _grupoAnimalNovilhas;
  set grupoAnimalNovilhas(bool value) {
    _grupoAnimalNovilhas = value;
  }

  List<String> _statusExtras = ['Indução de Lactação', 'Descarte'];
  List<String> get statusExtras => _statusExtras;
  set statusExtras(List<String> value) {
    _statusExtras = value;
  }

  void addToStatusExtras(String value) {
    statusExtras.add(value);
  }

  void removeFromStatusExtras(String value) {
    statusExtras.remove(value);
  }

  void removeAtIndexFromStatusExtras(int index) {
    statusExtras.removeAt(index);
  }

  void updateStatusExtrasAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    statusExtras[index] = updateFn(_statusExtras[index]);
  }

  void insertAtIndexInStatusExtras(int index, String value) {
    statusExtras.insert(index, value);
  }

  bool _mostrarListaCompleta = true;
  bool get mostrarListaCompleta => _mostrarListaCompleta;
  set mostrarListaCompleta(bool value) {
    _mostrarListaCompleta = value;
  }

  List<GrupoStruct> _grupo = [
    GrupoStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Touros\",\"id\":\"1\"}')),
    GrupoStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Bezerros\",\"id\":\"2\"}')),
    GrupoStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Semêns\",\"id\":\"6\"}')),
    GrupoStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Bezerras\",\"id\":\"3\"}')),
    GrupoStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Novilhas\",\"id\":\"4\"}')),
    GrupoStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Vacas\",\"id\":\"5\"}'))
  ];
  List<GrupoStruct> get grupo => _grupo;
  set grupo(List<GrupoStruct> value) {
    _grupo = value;
    prefs.setStringList('ff_grupo', value.map((x) => x.serialize()).toList());
  }

  void addToGrupo(GrupoStruct value) {
    grupo.add(value);
    prefs.setStringList('ff_grupo', _grupo.map((x) => x.serialize()).toList());
  }

  void removeFromGrupo(GrupoStruct value) {
    grupo.remove(value);
    prefs.setStringList('ff_grupo', _grupo.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromGrupo(int index) {
    grupo.removeAt(index);
    prefs.setStringList('ff_grupo', _grupo.map((x) => x.serialize()).toList());
  }

  void updateGrupoAtIndex(
    int index,
    GrupoStruct Function(GrupoStruct) updateFn,
  ) {
    grupo[index] = updateFn(_grupo[index]);
    prefs.setStringList('ff_grupo', _grupo.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInGrupo(int index, GrupoStruct value) {
    grupo.insert(index, value);
    prefs.setStringList('ff_grupo', _grupo.map((x) => x.serialize()).toList());
  }

  List<RacasStruct> _racas = [
    RacasStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Aberdeen Angus\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Ayrshire\"}')),
    RacasStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Romagnola\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Gelbvieh\"}')),
    RacasStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Holandesa\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Guernsey\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Tabapuã\"}')),
    RacasStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Belmont Red\"}')),
    RacasStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Charolesa\"}')),
    RacasStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Shorthorn\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Chianina\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Canchim\"}')),
    RacasStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Nelore Mocho\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Limousin\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Brahvieh\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Sindi\"}')),
    RacasStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Belted Galloway\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Barzona\"}')),
    RacasStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Brahaman Africano\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Galloway\"}')),
    RacasStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Simental-Pardo\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Salers\"}')),
    RacasStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Simmental\"}')),
    RacasStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Marchigiana\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Brahman\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Hereford\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Wagyu\"}')),
    RacasStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Indubrasil\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Devon\"}')),
    RacasStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Texas Longhorn\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Highland\"}')),
    RacasStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Santa Gertrudis\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Dexter\"}')),
    RacasStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Murray Grey\"}')),
    RacasStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Red Angus\"}')),
    RacasStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Piedmontese\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Nelore\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Bonsmara\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Kerry\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Jersey\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Zebu\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Normando\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Tuli\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Gir\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Caracu\"}')),
    RacasStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Maine-Anjou\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Senepol\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Angus\"}')),
    RacasStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Pardo-Suíço\"}')),
    RacasStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Brangus\"}'))
  ];
  List<RacasStruct> get racas => _racas;
  set racas(List<RacasStruct> value) {
    _racas = value;
    prefs.setStringList('ff_racas', value.map((x) => x.serialize()).toList());
  }

  void addToRacas(RacasStruct value) {
    racas.add(value);
    prefs.setStringList('ff_racas', _racas.map((x) => x.serialize()).toList());
  }

  void removeFromRacas(RacasStruct value) {
    racas.remove(value);
    prefs.setStringList('ff_racas', _racas.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromRacas(int index) {
    racas.removeAt(index);
    prefs.setStringList('ff_racas', _racas.map((x) => x.serialize()).toList());
  }

  void updateRacasAtIndex(
    int index,
    RacasStruct Function(RacasStruct) updateFn,
  ) {
    racas[index] = updateFn(_racas[index]);
    prefs.setStringList('ff_racas', _racas.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInRacas(int index, RacasStruct value) {
    racas.insert(index, value);
    prefs.setStringList('ff_racas', _racas.map((x) => x.serialize()).toList());
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

  List<AnimaisProdutoresStruct> _animaisProdutoresExistentes = [];
  List<AnimaisProdutoresStruct> get animaisProdutoresExistentes =>
      _animaisProdutoresExistentes;
  set animaisProdutoresExistentes(List<AnimaisProdutoresStruct> value) {
    _animaisProdutoresExistentes = value;
    prefs.setStringList('ff_animaisProdutoresExistentes',
        value.map((x) => x.serialize()).toList());
  }

  void addToAnimaisProdutoresExistentes(AnimaisProdutoresStruct value) {
    animaisProdutoresExistentes.add(value);
    prefs.setStringList('ff_animaisProdutoresExistentes',
        _animaisProdutoresExistentes.map((x) => x.serialize()).toList());
  }

  void removeFromAnimaisProdutoresExistentes(AnimaisProdutoresStruct value) {
    animaisProdutoresExistentes.remove(value);
    prefs.setStringList('ff_animaisProdutoresExistentes',
        _animaisProdutoresExistentes.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromAnimaisProdutoresExistentes(int index) {
    animaisProdutoresExistentes.removeAt(index);
    prefs.setStringList('ff_animaisProdutoresExistentes',
        _animaisProdutoresExistentes.map((x) => x.serialize()).toList());
  }

  void updateAnimaisProdutoresExistentesAtIndex(
    int index,
    AnimaisProdutoresStruct Function(AnimaisProdutoresStruct) updateFn,
  ) {
    animaisProdutoresExistentes[index] =
        updateFn(_animaisProdutoresExistentes[index]);
    prefs.setStringList('ff_animaisProdutoresExistentes',
        _animaisProdutoresExistentes.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInAnimaisProdutoresExistentes(
      int index, AnimaisProdutoresStruct value) {
    animaisProdutoresExistentes.insert(index, value);
    prefs.setStringList('ff_animaisProdutoresExistentes',
        _animaisProdutoresExistentes.map((x) => x.serialize()).toList());
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

  int _verificaInternet = -1;
  int get verificaInternet => _verificaInternet;
  set verificaInternet(int value) {
    _verificaInternet = value;
    prefs.setInt('ff_verificaInternet', value);
  }

  List<ResumoDaVisitaStruct> _resumoDaVisita = [];
  List<ResumoDaVisitaStruct> get resumoDaVisita => _resumoDaVisita;
  set resumoDaVisita(List<ResumoDaVisitaStruct> value) {
    _resumoDaVisita = value;
    prefs.setStringList(
        'ff_resumoDaVisita', value.map((x) => x.serialize()).toList());
  }

  void addToResumoDaVisita(ResumoDaVisitaStruct value) {
    resumoDaVisita.add(value);
    prefs.setStringList('ff_resumoDaVisita',
        _resumoDaVisita.map((x) => x.serialize()).toList());
  }

  void removeFromResumoDaVisita(ResumoDaVisitaStruct value) {
    resumoDaVisita.remove(value);
    prefs.setStringList('ff_resumoDaVisita',
        _resumoDaVisita.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromResumoDaVisita(int index) {
    resumoDaVisita.removeAt(index);
    prefs.setStringList('ff_resumoDaVisita',
        _resumoDaVisita.map((x) => x.serialize()).toList());
  }

  void updateResumoDaVisitaAtIndex(
    int index,
    ResumoDaVisitaStruct Function(ResumoDaVisitaStruct) updateFn,
  ) {
    resumoDaVisita[index] = updateFn(_resumoDaVisita[index]);
    prefs.setStringList('ff_resumoDaVisita',
        _resumoDaVisita.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInResumoDaVisita(int index, ResumoDaVisitaStruct value) {
    resumoDaVisita.insert(index, value);
    prefs.setStringList('ff_resumoDaVisita',
        _resumoDaVisita.map((x) => x.serialize()).toList());
  }

  List<AcoesDaVisitaStruct> _acoesDaVisita = [];
  List<AcoesDaVisitaStruct> get acoesDaVisita => _acoesDaVisita;
  set acoesDaVisita(List<AcoesDaVisitaStruct> value) {
    _acoesDaVisita = value;
    prefs.setStringList(
        'ff_acoesDaVisita', value.map((x) => x.serialize()).toList());
  }

  void addToAcoesDaVisita(AcoesDaVisitaStruct value) {
    acoesDaVisita.add(value);
    prefs.setStringList(
        'ff_acoesDaVisita', _acoesDaVisita.map((x) => x.serialize()).toList());
  }

  void removeFromAcoesDaVisita(AcoesDaVisitaStruct value) {
    acoesDaVisita.remove(value);
    prefs.setStringList(
        'ff_acoesDaVisita', _acoesDaVisita.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromAcoesDaVisita(int index) {
    acoesDaVisita.removeAt(index);
    prefs.setStringList(
        'ff_acoesDaVisita', _acoesDaVisita.map((x) => x.serialize()).toList());
  }

  void updateAcoesDaVisitaAtIndex(
    int index,
    AcoesDaVisitaStruct Function(AcoesDaVisitaStruct) updateFn,
  ) {
    acoesDaVisita[index] = updateFn(_acoesDaVisita[index]);
    prefs.setStringList(
        'ff_acoesDaVisita', _acoesDaVisita.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInAcoesDaVisita(int index, AcoesDaVisitaStruct value) {
    acoesDaVisita.insert(index, value);
    prefs.setStringList(
        'ff_acoesDaVisita', _acoesDaVisita.map((x) => x.serialize()).toList());
  }

  List<TratamentosStruct> _tratamentos = [];
  List<TratamentosStruct> get tratamentos => _tratamentos;
  set tratamentos(List<TratamentosStruct> value) {
    _tratamentos = value;
    prefs.setStringList(
        'ff_tratamentos', value.map((x) => x.serialize()).toList());
  }

  void addToTratamentos(TratamentosStruct value) {
    tratamentos.add(value);
    prefs.setStringList(
        'ff_tratamentos', _tratamentos.map((x) => x.serialize()).toList());
  }

  void removeFromTratamentos(TratamentosStruct value) {
    tratamentos.remove(value);
    prefs.setStringList(
        'ff_tratamentos', _tratamentos.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromTratamentos(int index) {
    tratamentos.removeAt(index);
    prefs.setStringList(
        'ff_tratamentos', _tratamentos.map((x) => x.serialize()).toList());
  }

  void updateTratamentosAtIndex(
    int index,
    TratamentosStruct Function(TratamentosStruct) updateFn,
  ) {
    tratamentos[index] = updateFn(_tratamentos[index]);
    prefs.setStringList(
        'ff_tratamentos', _tratamentos.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInTratamentos(int index, TratamentosStruct value) {
    tratamentos.insert(index, value);
    prefs.setStringList(
        'ff_tratamentos', _tratamentos.map((x) => x.serialize()).toList());
  }

  List<RecomendacoesStruct> _recomendacoes = [];
  List<RecomendacoesStruct> get recomendacoes => _recomendacoes;
  set recomendacoes(List<RecomendacoesStruct> value) {
    _recomendacoes = value;
    prefs.setStringList(
        'ff_recomendacoes', value.map((x) => x.serialize()).toList());
  }

  void addToRecomendacoes(RecomendacoesStruct value) {
    recomendacoes.add(value);
    prefs.setStringList(
        'ff_recomendacoes', _recomendacoes.map((x) => x.serialize()).toList());
  }

  void removeFromRecomendacoes(RecomendacoesStruct value) {
    recomendacoes.remove(value);
    prefs.setStringList(
        'ff_recomendacoes', _recomendacoes.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromRecomendacoes(int index) {
    recomendacoes.removeAt(index);
    prefs.setStringList(
        'ff_recomendacoes', _recomendacoes.map((x) => x.serialize()).toList());
  }

  void updateRecomendacoesAtIndex(
    int index,
    RecomendacoesStruct Function(RecomendacoesStruct) updateFn,
  ) {
    recomendacoes[index] = updateFn(_recomendacoes[index]);
    prefs.setStringList(
        'ff_recomendacoes', _recomendacoes.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInRecomendacoes(int index, RecomendacoesStruct value) {
    recomendacoes.insert(index, value);
    prefs.setStringList(
        'ff_recomendacoes', _recomendacoes.map((x) => x.serialize()).toList());
  }

  int _contador2 = -1;
  int get contador2 => _contador2;
  set contador2(int value) {
    _contador2 = value;
    prefs.setInt('ff_contador2', value);
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

  List<TipoAcoesStruct> _tipoAcoes = [
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Aborto\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Anestro\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Ausência de Muco\"}')),
    TipoAcoesStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"CG I\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"CG II\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"CG III\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"CG IV\"}')),
    TipoAcoesStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Cio\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Cisto Folicular\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Cisto Luteinico\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Cl cavitário\"}')),
    TipoAcoesStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Cloe\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Endometrite\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Feto mumificado\"}')),
    TipoAcoesStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"Fl-\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Hemorragia de Metaestro\"}')),
    TipoAcoesStruct.fromSerializableMap(jsonDecode('{\"descricao\":\"IATF\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Indução de Lactação\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Inseminação\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Liberada\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Lóquio\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Metrite\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Muco Turvo\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Mucometra\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Outros\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Piometra\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Reabsorção Embrionária\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Retenção de Placenta\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Secagem\"}')),
    TipoAcoesStruct.fromSerializableMap(
        jsonDecode('{\"descricao\":\"Prostaglandina\"}'))
  ];
  List<TipoAcoesStruct> get tipoAcoes => _tipoAcoes;
  set tipoAcoes(List<TipoAcoesStruct> value) {
    _tipoAcoes = value;
    prefs.setStringList(
        'ff_tipoAcoes', value.map((x) => x.serialize()).toList());
  }

  void addToTipoAcoes(TipoAcoesStruct value) {
    tipoAcoes.add(value);
    prefs.setStringList(
        'ff_tipoAcoes', _tipoAcoes.map((x) => x.serialize()).toList());
  }

  void removeFromTipoAcoes(TipoAcoesStruct value) {
    tipoAcoes.remove(value);
    prefs.setStringList(
        'ff_tipoAcoes', _tipoAcoes.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromTipoAcoes(int index) {
    tipoAcoes.removeAt(index);
    prefs.setStringList(
        'ff_tipoAcoes', _tipoAcoes.map((x) => x.serialize()).toList());
  }

  void updateTipoAcoesAtIndex(
    int index,
    TipoAcoesStruct Function(TipoAcoesStruct) updateFn,
  ) {
    tipoAcoes[index] = updateFn(_tipoAcoes[index]);
    prefs.setStringList(
        'ff_tipoAcoes', _tipoAcoes.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInTipoAcoes(int index, TipoAcoesStruct value) {
    tipoAcoes.insert(index, value);
    prefs.setStringList(
        'ff_tipoAcoes', _tipoAcoes.map((x) => x.serialize()).toList());
  }

  bool _ordenacaoQuery = false;
  bool get ordenacaoQuery => _ordenacaoQuery;
  set ordenacaoQuery(bool value) {
    _ordenacaoQuery = value;
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

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
