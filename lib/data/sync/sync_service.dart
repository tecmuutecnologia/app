import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../repositories/person_repository.dart';
import '../repositories/animais_produtores_repository.dart';
import '../repositories/propriedades_repository.dart';
import '../repositories/tecnico_repository.dart';
import '../repositories/produtor_repository.dart';

/// Serviço de sincronização em background
///
/// Gerencia a sincronização automática entre ObjectBox e Firestore
/// - Sincroniza periodicamente quando há conexão
/// - Monitora mudanças de conectividade
/// - Sincroniza automaticamente quando a conexão é restaurada
class SyncService {
  static SyncService? _instance;

  final PersonRepository _personRepository = PersonRepository();
  final AnimaisProdutoresRepository _animaisRepository =
      AnimaisProdutoresRepository();
  final PropriedadesRepository _propriedadesRepository =
      PropriedadesRepository();
  final TecnicoRepository _tecnicoRepository = TecnicoRepository();
  final ProdutorRepository _produtorRepository = ProdutorRepository();

  Timer? _syncTimer;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _isOnline = false;
  bool _isSyncing = false;

  // Intervalo de sincronização (5 minutos)
  final Duration syncInterval = const Duration(minutes: 5);

  SyncService._();

  /// Obtém a instância singleton
  static SyncService get instance {
    _instance ??= SyncService._();
    return _instance!;
  }

  /// Inicializa o serviço de sincronização
  Future<void> init() async {
    print('Inicializando SyncService...');

    // Verifica conectividade inicial
    final connectivityResult = await Connectivity().checkConnectivity();
    _isOnline = connectivityResult != ConnectivityResult.none;

    // Monitora mudanças de conectividade
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);

    // Inicia timer de sincronização periódica
    _startSyncTimer();

    // Faz primeira sincronização se estiver online
    if (_isOnline) {
      await syncNow();
    }
  }

  /// Callback quando a conectividade muda
  void _onConnectivityChanged(ConnectivityResult result) {
    final wasOffline = !_isOnline;
    _isOnline = result != ConnectivityResult.none;

    print('Conectividade mudou: $_isOnline');

    // Se estava offline e agora está online, sincroniza
    if (wasOffline && _isOnline) {
      print('Conexão restaurada, sincronizando...');
      syncNow();
    }
  }

  /// Inicia o timer de sincronização periódica
  void _startSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(syncInterval, (timer) {
      if (_isOnline && !_isSyncing) {
        syncNow();
      }
    });
  }

  /// Sincroniza agora (pode ser chamado manualmente)
  Future<void> syncNow() async {
    if (_isSyncing) {
      print('Sincronização já em andamento, ignorando...');
      return;
    }

    if (!_isOnline) {
      print('Offline, pulando sincronização');
      return;
    }

    _isSyncing = true;
    print('Iniciando sincronização...');

    try {
      // Sincroniza cada repositório
      await _personRepository.fullSync();
      await _tecnicoRepository.fullSync();
      await _produtorRepository.fullSync();
      await _propriedadesRepository.fullSync();
      await _animaisRepository.fullSync();

      print('Sincronização concluída com sucesso');
    } catch (e) {
      print('Erro durante sincronização: $e');
    } finally {
      _isSyncing = false;
    }
  }

  /// Para o serviço de sincronização
  void stop() {
    print('Parando SyncService...');
    _syncTimer?.cancel();
    _connectivitySubscription?.cancel();
    _syncTimer = null;
    _connectivitySubscription = null;
  }

  /// Reinicia o serviço
  Future<void> restart() async {
    stop();
    await init();
  }

  /// Verifica se está sincronizando
  bool get isSyncing => _isSyncing;

  /// Verifica se está online
  bool get isOnline => _isOnline;
}
