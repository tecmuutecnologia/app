import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/connectivity/connectivity_service.dart';
import '/core/di/providers.dart';
import '/core/auth/firebase_auth/auth_util.dart';
import '/core/auth/firebase_auth/firebase_user_provider.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/internationalization.dart';
import '/features/shared/widgets/sync_status_banner.dart';

/// Raiz da aplicação (`MaterialApp.router`), antes em `main.dart`.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class MyAppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale? _locale;

  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  late StreamSubscription<BaseAuthUser> _userStreamSubscription;
  late StreamSubscription _jwtTokenStreamSubscription;

  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  late Stream<BaseAuthUser> userStream;

  @override
  void initState() {
    super.initState();
    // Voltar do segundo plano é o momento clássico de a rede ter mudado sem o
    // app receber o evento (dormiu no Wi-Fi, acordou no 4G). O re-check
    // reconcilia na hora, sem esperar o timer do serviço.
    WidgetsBinding.instance.addObserver(this);
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    userStream = tecmuuFirebaseUserStream();
    _userStreamSubscription = userStream.listen((user) {
      _appStateNotifier.update(user);
    });

    _jwtTokenStreamSubscription = jwtTokenStream.listen((_) {});

    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  void setLocale(String language) {
    safeSetState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(ConnectivityService.instance.recheck());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _userStreamSubscription.cancel();
    _jwtTokenStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Gerencie seu Rebanho com o Tecmuu - Online e Offline',
      scrollBehavior: MyAppScrollBehavior(),
      localizationsDelegates: [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('pt'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
      // Notificação passiva de conectividade app-wide: quando ONLINE o banner
      // tem altura ZERO e nenhum inset (não desloca nada — sem o vão em branco
      // no topo que aparecia antes). Quando OFFLINE, mostra um aviso fino no
      // topo, com SafeArea próprio. A sincronização ao reconectar é automática
      // (OfflineFirstSyncService), então não há botão de sincronizar.
      builder: (context, child) => Consumer(
        builder: (context, ref, _) {
          final online = ref.watch(isOnlineProvider).valueOrNull ?? true;
          return _comBanner(context, child, mostrandoBanner: !online);
        },
      ),
    );
  }

  /// Empilha o banner de conectividade acima do conteúdo do app.
  ///
  /// Quando o banner aparece, ele consome o inset da status bar no SafeArea
  /// dele — mas o `MediaQuery` que desce para o conteúdo ainda anunciava esse
  /// inset, e a AppBar de cada tela o aplicava DE NOVO. O resultado era uma
  /// faixa vazia da altura da status bar entre o banner e o título, que fazia
  /// a tela inteira parecer empurrada para baixo. Consumido o inset uma vez,
  /// removê-lo do filho é o que mantém o deslocamento igual à altura real do
  /// banner.
  Widget _comBanner(
    BuildContext context,
    Widget? child, {
    required bool mostrandoBanner,
  }) {
    final conteudo = child ?? const SizedBox.shrink();

    return Column(
        children: [
          const SyncStatusBanner(),
          // `bottom: true` isola o conteúdo da barra de navegação do sistema.
          //
          // Com o target em API 36 o app é edge-to-edge à força, e só 18 das
          // 43 telas tinham SafeArea próprio — o resto ficaria com conteúdo
          // sob a barra. O topo NÃO é protegido de propósito: a AppBar já
          // aplica o inset do status bar sozinha, e um SafeArea superior aqui
          // criaria uma faixa vazia acima dela.
          //
          // SafeArea aninhado é idempotente: nas telas que já têm o seu, o
          // interno vê padding zero e não duplica o espaçamento.
          Expanded(
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              child: mostrandoBanner
                  ? MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: conteudo,
                    )
                  : conteudo,
            ),
          ),
        ],
    );
  }
}
