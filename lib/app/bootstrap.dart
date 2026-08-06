import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

import '/data/firebase/firebase_config.dart';
import '/data/objectbox/index.dart';
import '/data/stripe/payment_manager.dart';
import '/core/connectivity/connectivity_service.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/features/sincronizacao/data/offline_first_sync_gateway.dart';
import '/features/sincronizacao/domain/sync_gateway.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import 'app.dart';

/// Bootstrap da aplicação: inicializa Firebase/ObjectBox/conectividade/tema/
/// Stripe e sobe o `runApp`. Antes era o corpo de `main()` em `main.dart`.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Edge-to-edge declarado explicitamente. A partir do Android 16 (API 36) o
  // sistema IGNORA `windowOptOutEdgeToEdgeEnforcement`, então o app desenha
  // atrás das barras querendo ou não — melhor assumir e deixá-las
  // transparentes do que receber o comportamento por acidente, com barras
  // opacas cobrindo conteúdo.
  if (!kIsWeb) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ));
  }

  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await initFirebase();

  // Inicializa ObjectBox para armazenamento offline-first (apenas em plataformas nativas)
  if (!kIsWeb) {
    await ObjectBoxAuthHelper.initializeOfflineFirst();
  }

  // Começa a observar a conectividade (alimenta isOnlineProvider/SyncStatusBanner).
  unawaited(ConnectivityService.instance.start());

  await FlutterFlowTheme.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  // Migração legado->ObjectBox a cada startup (idempotente, não-bloqueante):
  // resgata animais criados offline pelo mecanismo antigo (array persistido em
  // prefs `ff_animaisProdutoresOffline`) para o ObjectBox e remove a chave.
  // Autônoma do FFAppState (o campo foi removido); no-op se a chave não existe.
  if (!kIsWeb && ObjectBoxService.isInitialized) {
    unawaited(migrarAnimaisOfflineLegadoDePrefs());
  }

  await initializeStripe();
  if (!kIsWeb) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }

  // ProviderScope habilita a injeção via Riverpod (camada offline-first),
  // coexistindo com o ChangeNotifierProvider/FFAppState durante a migração.
  runApp(ProviderScope(
    overrides: [
      syncGatewayProvider.overrideWithValue(OfflineFirstSyncGateway()),
    ],
    child: ChangeNotifierProvider(
      create: (context) => appState,
      child: const MyApp(),
    ),
  ));
}
