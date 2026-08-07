import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/app/router/nav.dart';
import 'package:tecmuu/core/auth/base_auth_user_provider.dart';
import 'package:tecmuu/features/sincronizacao/domain/sync_state.dart';
import 'package:tecmuu/features/sincronizacao/presentation/pages/sync_page.dart';

/// Reproduz o mecanismo relatado: a tela de sincronizacao "pisca" e o app cai
/// no dashboard sem a sincronizacao terminar.
///
/// Usa a classe de rota real (`FFRoute`) com paginas de mentira, para isolar o
/// comportamento do roteador do conteudo das telas.
class _UsuarioFake extends BaseAuthUser {
  _UsuarioFake({required this.loggedIn, this.uidFake});

  @override
  final bool loggedIn;
  final String? uidFake;

  @override
  bool get emailVerified => true;

  @override
  AuthUserInfo get authUserInfo => AuthUserInfo(uid: uidFake);

  @override
  Future? delete() => null;
  @override
  Future? updateEmail(String email) => null;
  @override
  Future? updatePassword(String newPassword) => null;
  @override
  Future? sendEmailVerification() => null;
}

/// Papel da `WelcomePage`.
class _PaginaInicial extends StatelessWidget {
  const _PaginaInicial();
  @override
  Widget build(BuildContext context) => const Scaffold(body: Text('inicial'));
}

/// Papel de uma pagina que decide destino e navega sozinha — o que a rota
/// `/` fazia quando havia sessao.
class _PaginaQueRedireciona extends StatefulWidget {
  const _PaginaQueRedireciona();
  @override
  State<_PaginaQueRedireciona> createState() => _PaginaQueRedirecionaState();
}

class _PaginaQueRedirecionaState extends State<_PaginaQueRedireciona> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.goNamed('destino');
    });
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Text('verificando'));
}

class _PaginaSync extends StatelessWidget {
  const _PaginaSync();
  @override
  Widget build(BuildContext context) => const Scaffold(body: Text('sync'));
}

class _PaginaDestino extends StatelessWidget {
  const _PaginaDestino();
  @override
  Widget build(BuildContext context) => const Scaffold(body: Text('destino'));
}

void main() {
  late AppStateNotifier notifier;

  setUp(() {
    notifier = AppStateNotifier.instance;
    notifier.showSplashImage = false;
    notifier.clearRedirectLocation();
    // Estado de app aberto e deslogado: usuario resolvido (nao e mais splash),
    // porem sem sessao.
    notifier.user = _UsuarioFake(loggedIn: false);
    notifier.initialUser = notifier.user;
  });

  GoRouter montarRouter() => GoRouter(
        initialLocation: '/',
        refreshListenable: notifier,
        routes: [
          FFRoute(
            name: 'raiz',
            path: '/',
            builder: (context, _) => notifier.loggedIn
                ? const _PaginaQueRedireciona()
                : const _PaginaInicial(),
          ),
          // Rota real da sincronizacao com pagina de mentira: o que esta sob
          // teste e a navegacao, nao o conteudo da tela.
          FFRoute(
            name: SyncPage.routeName,
            path: SyncPage.routePath,
            builder: (context, _) => const _PaginaSync(),
          ),
          FFRoute(
            name: 'destino',
            path: '/destino',
            builder: (context, _) => const _PaginaDestino(),
          ),
        ].map((r) => r.toRoute(notifier)).toList(),
      );

  testWidgets(
      'abrir a sincronizacao ja autenticado nao deixa a pagina raiz sequestrar '
      'a navegacao', (tester) async {
    final router = montarRouter();
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
    expect(find.text('inicial'), findsOneWidget);

    // Login: o evento de auth chega com a notificacao suprimida
    // (`prepareAuthEvent`), exatamente como no botao Entrar.
    notifier.updateNotifyOnAuthChange(false);
    notifier.update(_UsuarioFake(loggedIn: true, uidFake: 'tec-1'));

    SyncPage.abrir(
      tester.element(find.text('inicial')),
      papel: SyncPapel.tecnico,
    );
    await tester.pumpAndSettle();

    expect(Uri.parse(router.getCurrentLocation()).path, SyncPage.routePath,
        reason: 'a sincronizacao tem de segurar a tela ate o usuario sair');
    expect(find.byType(_PaginaQueRedireciona, skipOffstage: false), findsNothing,
        reason: 'a raiz nao pode continuar montada embaixo da pilha: '
            'autenticada, ela vira a tela que navega sozinha');
  });

  testWidgets('a rota `/` redireciona pelo destino de abertura, sem montar '
      'pagina nenhuma', (tester) async {
    notifier.updateNotifyOnAuthChange(false);
    notifier.update(_UsuarioFake(loggedIn: true, uidFake: 'tec-1'));

    final router = GoRouter(
      initialLocation: '/',
      refreshListenable: notifier,
      routes: [
        FFRoute(
          name: 'raiz',
          path: '/',
          // Mesma forma usada em `createRouter`: a decisao e do roteador, nao
          // de uma tela que navega sozinha depois de montar.
          redirect: (context, state) => destinoDeAbertura(
            logado: notifier.loggedIn,
            destinoGuardado: '/destino',
          ),
          builder: (context, _) => const _PaginaInicial(),
        ),
        FFRoute(
          name: 'destino',
          path: '/destino',
          builder: (context, _) => const _PaginaDestino(),
        ),
      ].map((r) => r.toRoute(notifier)).toList(),
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(router.getCurrentLocation(), '/destino');
    expect(find.byType(_PaginaInicial, skipOffstage: false), findsNothing,
        reason: 'o redirect resolve antes de construir a pagina da raiz');
  });
}
