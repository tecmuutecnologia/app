import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

import '/backend/firebase/firebase_config.dart';
import '/backend/objectbox/index.dart';
import '/backend/stripe/payment_manager.dart';
import '/core/connectivity/connectivity_service.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import 'app.dart';

/// Bootstrap da aplicação: inicializa Firebase/ObjectBox/conectividade/tema/
/// Stripe e sobe o `runApp`. Antes era o corpo de `main()` em `main.dart`.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  // garante que animais criados offline pelo mecanismo antigo (array persistido
  // `animaisProdutoresOffline`) não fiquem presos nem sejam descartados,
  // independente do caminho de login. Pré-requisito para remover as telas
  // variantes `_offline`. Complementa a drenagem do sync_technician.
  if (!kIsWeb && ObjectBoxService.isInitialized) {
    final legado = appState.animaisProdutoresOffline;
    if (legado.isNotEmpty) {
      unawaited(migrarAnimaisOfflineLegado(legado)
          .then((_) => appState.animaisProdutoresOffline = []));
    }
  }

  await initializeStripe();
  if (!kIsWeb) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }

  // ProviderScope habilita a injeção via Riverpod (camada offline-first),
  // coexistindo com o ChangeNotifierProvider/FFAppState durante a migração.
  runApp(ProviderScope(
    child: ChangeNotifierProvider(
      create: (context) => appState,
      child: const MyApp(),
    ),
  ));
}
