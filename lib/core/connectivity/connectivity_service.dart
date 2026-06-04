import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Sonda a interface de rede (Wi-Fi/dados/none). Injetável para testes.
typedef ConnectivityProbe = Future<ConnectivityResult> Function();

/// Confirma acesso real à internet (não apenas interface ativa). Injetável.
typedef InternetAccessProbe = Future<bool> Function();

/// Fonte ÚNICA de verdade para o estado de conectividade do app.
///
/// Antes da refatoração, o projeto verificava conexão de três formas
/// independentes e inconsistentes:
/// - `connectivity_plus` (apenas detecta a interface: Wi-Fi/dados/none);
/// - `internet_connection_checker_plus` (confirma acesso real à internet);
/// - flags manuais espalhadas (ex.: `FFAppState().verificaInternet`).
///
/// Este serviço combina as duas bibliotecas: a interface (`connectivity_plus`)
/// dispara as mudanças e o acesso real (`internet_connection_checker_plus`)
/// confirma se há internet de fato — evitando falsos positivos quando há Wi-Fi
/// sem saída para a internet. Expõe um único `Stream<bool>` reativo e um
/// `checkConnection()` pontual.
///
/// Toda a entrada via plugin é injetável, então a lógica de decisão é testável
/// sem depender de hardware/rede real (ver `connectivity_service_test.dart`).
class ConnectivityService {
  ConnectivityService({
    ConnectivityProbe? probeConnectivity,
    InternetAccessProbe? probeInternetAccess,
    Stream<ConnectivityResult>? connectivityChanges,
  })  : _probeConnectivity =
            probeConnectivity ?? Connectivity().checkConnectivity,
        _probeInternetAccess =
            probeInternetAccess ?? _defaultInternetAccessProbe,
        _connectivityChanges =
            connectivityChanges ?? Connectivity().onConnectivityChanged;

  final ConnectivityProbe _probeConnectivity;
  final InternetAccessProbe _probeInternetAccess;
  final Stream<ConnectivityResult> _connectivityChanges;

  static Future<bool> _defaultInternetAccessProbe() =>
      InternetConnectionCheckerPlus().hasConnection;

  /// Instância padrão compartilhada (singleton de aplicação).
  static final ConnectivityService instance = ConnectivityService();

  final StreamController<bool> _statusController =
      StreamController<bool>.broadcast();
  StreamSubscription<ConnectivityResult>? _subscription;

  bool _isOnline = true;
  bool _started = false;
  bool _hasEmitted = false;

  /// Último estado conhecido. `true` por padrão até a primeira verificação,
  /// para não bloquear o app no startup.
  bool get isOnline => _isOnline;

  /// Emite `true`/`false` a cada transição de estado de conectividade.
  Stream<bool> get onStatusChange => _statusController.stream;

  /// Inicia a escuta de mudanças de conectividade. Idempotente.
  Future<void> start() async {
    if (_started) return;
    _started = true;

    _setOnline(await checkConnection());

    _subscription = _connectivityChanges.listen((result) async {
      final online = result == ConnectivityResult.none
          ? false
          : await _probeInternetAccess();
      _setOnline(online);
    });
  }

  /// Verificação pontual: há internet de fato AGORA?
  ///
  /// Curto-circuita em `false` se não há interface de rede (rápido, sem I/O);
  /// caso contrário confirma o acesso real à internet.
  Future<bool> checkConnection() async {
    final result = await _probeConnectivity();
    if (result == ConnectivityResult.none) return false;
    return _probeInternetAccess();
  }

  void _setOnline(bool value) {
    // Sempre emite a primeira leitura (estado inicial); depois, só em transições.
    if (_hasEmitted && value == _isOnline) return;
    _isOnline = value;
    _hasEmitted = true;
    if (!_statusController.isClosed) {
      _statusController.add(value);
    }
  }

  /// Libera recursos. Após o dispose o serviço não deve ser reutilizado.
  Future<void> dispose() async {
    await _subscription?.cancel();
    await _statusController.close();
  }
}
