import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_repository.dart';
import '../connectivity/connectivity_service.dart';
import '../../backend/objectbox/index.dart';

/// Injeção de dependência (Riverpod) da camada offline-first.
///
/// Ponto único onde a UI obtém serviços e repositórios, em vez de instanciá-los
/// direto ou ler do god object `FFAppState`. Coexiste com o `package:provider`
/// existente durante a migração incremental.
///
/// Nota: os repositórios dependem de `ObjectBoxService` inicializado (feito no
/// `main()` em plataformas nativas). São providers preguiçosos — só constroem
/// quando lidos por uma tela já migrada.

// ---------------------------------------------------------------------------
// Serviços
// ---------------------------------------------------------------------------

/// Fonte única de conectividade.
final connectivityServiceProvider = Provider<ConnectivityService>(
  (ref) => ConnectivityService.instance,
);

/// Estado online/offline reativo (`true` = há internet real).
final isOnlineProvider = StreamProvider<bool>(
  (ref) => ref.watch(connectivityServiceProvider).onStatusChange,
);

/// Estado da sincronização (idle/syncing/completed/error/offline).
final syncStatusProvider = StreamProvider<SyncStatus>((ref) {
  if (!OfflineFirstSyncService.isInitialized) {
    return const Stream<SyncStatus>.empty();
  }
  return OfflineFirstSyncService.instance.statusStream;
});

// ---------------------------------------------------------------------------
// Autenticação (fonte de verdade reativa p/ a camada nova)
// ---------------------------------------------------------------------------

/// Leitura centralizada do estado de auth, em vez dos getters globais mutáveis.
final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository());

/// Usuário autenticado, reativo (emite a cada login/logout). Telas novas devem
/// observar este provider em vez de ler `currentUserUid`/`currentUser` globais.
final currentUserProvider = StreamProvider<User?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges(),
);

// ---------------------------------------------------------------------------
// Repositórios (subcoleção)
// ---------------------------------------------------------------------------

final animalRepositoryProvider =
    Provider<AnimalRepository>((ref) => AnimalRepository());

final acaoRepositoryProvider =
    Provider<AcaoRepository>((ref) => AcaoRepository());

final acaoDaVisitaRepositoryProvider =
    Provider<AcaoDaVisitaRepository>((ref) => AcaoDaVisitaRepository());

final propriedadeRepositoryProvider =
    Provider<PropriedadeRepository>((ref) => PropriedadeRepository());

final tratamentoRepositoryProvider =
    Provider<TratamentoRepository>((ref) => TratamentoRepository());

final acaoSanitarioRepositoryProvider =
    Provider<AcaoSanitarioRepository>((ref) => AcaoSanitarioRepository());

final financeiroRepositoryProvider =
    Provider<FinanceiroRepository>((ref) => FinanceiroRepository());

final resumoVisitaRepositoryProvider =
    Provider<ResumoVisitaRepository>((ref) => ResumoVisitaRepository());

final recomendacaoRepositoryProvider =
    Provider<RecomendacaoRepository>((ref) => RecomendacaoRepository());

// ---------------------------------------------------------------------------
// Repositórios (coleção de topo)
// ---------------------------------------------------------------------------

final personRepositoryProvider =
    Provider<PersonRepository>((ref) => PersonRepository());

final tecnicoRepositoryProvider =
    Provider<TecnicoRepository>((ref) => TecnicoRepository());

final produtorRepositoryProvider =
    Provider<ProdutorRepository>((ref) => ProdutorRepository());
