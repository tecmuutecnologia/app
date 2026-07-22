import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

class _MyAppState extends State<MyApp> {
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
  void dispose() {
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
      builder: (context, child) => Column(
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
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
