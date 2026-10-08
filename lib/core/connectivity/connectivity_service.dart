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
/// - flags manuais espalhadas no `FFAppState` (já removidas).
///
/// Separação de responsabilidades (evita o falso "sem conexão" que aparecia
/// ESTANDO online — a sonda real falha quando os hosts de checagem estão
/// bloqueados/lentos na rede do usuário):
/// - **Status para a UI** (`onStatusChange`/`isOnline`): reflete a INTERFACE de
///   rede (`connectivity_plus`). Se há Wi-Fi/dados, a UI NÃO mostra "offline".
/// - **`checkConnection()`**: confirma o acesso REAL à internet (sonda profunda),
///   para o motor de sync decidir se tenta o push agora. Falha de sonda não
///   deve pintar a UI de offline — por isso ela não alimenta o status.
///
/// Toda a entrada via plugin é injetável, então a lógica de decisão é testável
/// sem depender de hardware/rede real (ver `connectivity_service_test.dart`).
class ConnectivityService {
  ConnectivityService({
    ConnectivityProbe? probeConnectivity,
    InternetAccessProbe? probeInternetAccess,
    Stream<ConnectivityResult>? connectivityChanges,
    Duration recheckInterval = const Duration(seconds: 10),
  })  : _recheckInterval = recheckInterval,
        _probeConnectivity =
            probeConnectivity ?? Connectivity().checkConnectivity,
        _probeInternetAccess =
            probeInternetAccess ?? _defaultInternetAccessProbe,
        _connectivityChanges =
            connectivityChanges ?? Connectivity().onConnectivityChanged;

  final ConnectivityProbe _probeConnectivity;
  final InternetAccessProbe _probeInternetAccess;
  final Stream<ConnectivityResult> _connectivityChanges;
  final Duration _recheckInterval;

  static Future<bool> _defaultInternetAccessProbe() =>
      InternetConnectionCheckerPlus().hasConnection;

  /// Instância padrão compartilhada (singleton de aplicação).
  static final ConnectivityService instance = ConnectivityService();

  final StreamController<bool> _statusController =
      StreamController<bool>.broadcast();
  StreamSubscription<ConnectivityResult>? _subscription;
  Timer? _recheckTimer;

  bool _isOnline = true;
  bool _started = false;
  bool _hasEmitted = false;

  /// Último estado conhecido. `true` por padrão até a primeira verificação,
  /// para não bloquear o app no startup.
  bool get isOnline => _isOnline;

  /// Emite `true`/`false` a cada transição de estado de conectividade.
  Stream<bool> get onStatusChange => _statusController.stream;

  /// Inicia a escuta de mudanças de conectividade. Idempotente.
  ///
  /// O status (banner/UI) reflete a INTERFACE de rede — não a sonda profunda —
  /// para nunca reportar "offline" quando há rede (a sonda real pode falhar por
  /// hosts bloqueados mesmo havendo internet).
  ///
  /// Além do stream, um re-check periódico reconcilia o estado. O
  /// `connectivity_plus` perde a transição de VOLTA em certas condições
  /// (conhecido no simulador iOS — plus_plugins#479 — e observado em device).
  /// Como o app inteiro pendura o estado de rede aqui, um evento perdido
  /// congelava o banner em "offline" e, junto, o push do motor de sync — que é
  /// gated no mesmo estado — até o app reiniciar. O stream continua sendo o
  /// caminho rápido; o timer é a rede de segurança.
  Future<void> start() async {
    if (_started) return;
    _started = true;

    _setOnline(await _interfaceOnline());

    _subscription = _connectivityChanges.listen((result) {
      _setOnline(result != ConnectivityResult.none);
    });

    _recheckTimer = Timer.periodic(_recheckInterval, (_) => recheck());
  }

  /// Reconcilia o estado com a interface de rede AGORA, sem esperar evento.
  ///
  /// Chamado pelo timer interno e pela volta do app ao primeiro plano (quem
  /// observa o ciclo de vida é o `app.dart`, que já tem o binding). `_setOnline`
  /// deduplica, então re-check no mesmo estado não emite nada.
  Future<void> recheck() async {
    if (await _interfaceOnline()) {
      _setOnline(true);
      return;
    }

    // A interface diz que não há rede — mas ela sozinha não basta, porque é
    // exatamente ela que trava: medido no simulador iOS, `connectivity_plus`
    // devolve `none` por mais de 2 minutos DEPOIS de o Wi-Fi voltar, no stream
    // e na sonda pontual juntas (plus_plugins#479). Perguntar de novo para a
    // fonte travada nunca destravaria o app.
    //
    // A sonda profunda só pode MELHORAR o veredito aqui: sem ela este ramo
    // seria offline incondicional. Por isso ela não fere a regra da classe de
    // nunca pintar a UI de offline — ela nunca é o motivo de ficarmos offline,
    // só o motivo de sairmos.
    //
    // Consultada SEMPRE que a interface diz `none`, não apenas quando já
    // estamos offline: restringir ao estado offline fazia o estado oscilar,
    // porque no tick seguinte ao escape a interface (ainda travada) derrubava
    // tudo de volta.
    _setOnline(await _probeInternetAccess());
  }

  /// Há interface de rede ativa (Wi-Fi/dados)? Base do status para a UI.
  Future<bool> _interfaceOnline() async =>
      (await _probeConnectivity()) != ConnectivityResult.none;

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
    _recheckTimer?.cancel();
    _recheckTimer = null;
    await _subscription?.cancel();
    await _statusController.close();
  }
}
