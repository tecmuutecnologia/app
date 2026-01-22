import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';

import '/auth/base_auth_user_provider.dart';

import '/flutter_flow/flutter_flow_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) => appStateNotifier.loggedIn
          ? VerificaTipoLoginWidget()
          : WelcomeWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.loggedIn
              ? VerificaTipoLoginWidget()
              : WelcomeWidget(),
        ),
        FFRoute(
          name: WelcomeWidget.routeName,
          path: WelcomeWidget.routePath,
          builder: (context, params) => WelcomeWidget(),
        ),
        FFRoute(
          name: LoginTechnicianWidget.routeName,
          path: LoginTechnicianWidget.routePath,
          builder: (context, params) => LoginTechnicianWidget(),
        ),
        FFRoute(
          name: CreateAccountTechnicianWidget.routeName,
          path: CreateAccountTechnicianWidget.routePath,
          builder: (context, params) => CreateAccountTechnicianWidget(),
        ),
        FFRoute(
          name: DashboardTecnicoWidget.routeName,
          path: DashboardTecnicoWidget.routePath,
          requireAuth: true,
          builder: (context, params) => DashboardTecnicoWidget(),
        ),
        FFRoute(
          name: ListaPropriedadeWidget.routeName,
          path: ListaPropriedadeWidget.routePath,
          builder: (context, params) => ListaPropriedadeWidget(
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: NovaPropriedadeWidget.routeName,
          path: NovaPropriedadeWidget.routePath,
          builder: (context, params) => NovaPropriedadeWidget(
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            email: params.getParam(
              'email',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: InicioPropriedadeWidget.routeName,
          path: InicioPropriedadeWidget.routePath,
          builder: (context, params) => InicioPropriedadeWidget(
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: EditarPropriedadeWidget.routeName,
          path: EditarPropriedadeWidget.routePath,
          builder: (context, params) => EditarPropriedadeWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            emailTecnico: params.getParam(
              'emailTecnico',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: CadastrarNovoAnimalWidget.routeName,
          path: CadastrarNovoAnimalWidget.routePath,
          builder: (context, params) => CadastrarNovoAnimalWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            grupoPredominante: params.getParam(
              'grupoPredominante',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            initialTabSelect: params.getParam(
              'initialTabSelect',
              ParamType.int,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ListaAnimaisWidget.routeName,
          path: ListaAnimaisWidget.routePath,
          builder: (context, params) => ListaAnimaisWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            tabBarOpenSelected: params.getParam(
              'tabBarOpenSelected',
              ParamType.int,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            initialTabSelect: params.getParam(
              'initialTabSelect',
              ParamType.int,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ListaInseminacoesWidget.routeName,
          path: ListaInseminacoesWidget.routePath,
          builder: (context, params) => ListaInseminacoesWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ExameGinecologicoWidget.routeName,
          path: ExameGinecologicoWidget.routePath,
          builder: (context, params) => ExameGinecologicoWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: AnimaisPrenhasWidget.routeName,
          path: AnimaisPrenhasWidget.routePath,
          builder: (context, params) => AnimaisPrenhasWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: SecasWidget.routeName,
          path: SecasWidget.routePath,
          builder: (context, params) => SecasWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: SyncTechnicianWidget.routeName,
          path: SyncTechnicianWidget.routePath,
          builder: (context, params) => SyncTechnicianWidget(),
        ),
        FFRoute(
          name: ReceituariosListaWidget.routeName,
          path: ReceituariosListaWidget.routePath,
          builder: (context, params) => ReceituariosListaWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ResumoVisitaAtualWidget.routeName,
          path: ResumoVisitaAtualWidget.routePath,
          builder: (context, params) => ResumoVisitaAtualWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            uidResumoVisita: params.getParam(
              'uidResumoVisita',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['resumo_da_visita'],
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ResumoRebanhoWidget.routeName,
          path: ResumoRebanhoWidget.routePath,
          builder: (context, params) => ResumoRebanhoWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
            empresaTecnico: params.getParam(
              'empresaTecnico',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: IndicesZootecnicosWidget.routeName,
          path: IndicesZootecnicosWidget.routePath,
          builder: (context, params) => IndicesZootecnicosWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: CompletarPerfilTecnicoWidget.routeName,
          path: CompletarPerfilTecnicoWidget.routePath,
          builder: (context, params) => CompletarPerfilTecnicoWidget(),
        ),
        FFRoute(
          name: LoginProdutorWidget.routeName,
          path: LoginProdutorWidget.routePath,
          builder: (context, params) => LoginProdutorWidget(),
        ),
        FFRoute(
          name: TutorialWidget.routeName,
          path: TutorialWidget.routePath,
          builder: (context, params) => TutorialWidget(),
        ),
        FFRoute(
          name: ProfileTecnicoWidget.routeName,
          path: ProfileTecnicoWidget.routePath,
          builder: (context, params) => ProfileTecnicoWidget(),
        ),
        FFRoute(
          name: SubscriptionPlanTecnicoWidget.routeName,
          path: SubscriptionPlanTecnicoWidget.routePath,
          builder: (context, params) => SubscriptionPlanTecnicoWidget(
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            email: params.getParam(
              'email',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ProntuarioAnimalWidget.routeName,
          path: ProntuarioAnimalWidget.routePath,
          builder: (context, params) => ProntuarioAnimalWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            uidAnimaisProdutores: params.getParam(
              'uidAnimaisProdutores',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'animaisProdutores'],
            ),
            grupoPredominante: params.getParam(
              'grupoPredominante',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: EditarAnimalWidget.routeName,
          path: EditarAnimalWidget.routePath,
          builder: (context, params) => EditarAnimalWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            grupoPredominante: params.getParam(
              'grupoPredominante',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            initialTabSelect: params.getParam(
              'initialTabSelect',
              ParamType.int,
            ),
            uidAnimal: params.getParam(
              'uidAnimal',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'animaisProdutores'],
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: PronInseminacoesWidget.routeName,
          path: PronInseminacoesWidget.routePath,
          builder: (context, params) => PronInseminacoesWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            uidAnimaisProdutores: params.getParam(
              'uidAnimaisProdutores',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'animaisProdutores'],
            ),
            grupoPredominante: params.getParam(
              'grupoPredominante',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: PronAcoesWidget.routeName,
          path: PronAcoesWidget.routePath,
          builder: (context, params) => PronAcoesWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            uidAnimaisProdutores: params.getParam(
              'uidAnimaisProdutores',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'animaisProdutores'],
            ),
            grupoPredominante: params.getParam(
              'grupoPredominante',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: PronAbortosWidget.routeName,
          path: PronAbortosWidget.routePath,
          builder: (context, params) => PronAbortosWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            uidAnimaisProdutores: params.getParam(
              'uidAnimaisProdutores',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'animaisProdutores'],
            ),
            grupoPredominante: params.getParam(
              'grupoPredominante',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: PronDiagGestacaoWidget.routeName,
          path: PronDiagGestacaoWidget.routePath,
          builder: (context, params) => PronDiagGestacaoWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            uidAnimaisProdutores: params.getParam(
              'uidAnimaisProdutores',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'animaisProdutores'],
            ),
            grupoPredominante: params.getParam(
              'grupoPredominante',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: PronCiosWidget.routeName,
          path: PronCiosWidget.routePath,
          builder: (context, params) => PronCiosWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            uidAnimaisProdutores: params.getParam(
              'uidAnimaisProdutores',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'animaisProdutores'],
            ),
            grupoPredominante: params.getParam(
              'grupoPredominante',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: DiagnosticogestacaoWidget.routeName,
          path: DiagnosticogestacaoWidget.routePath,
          builder: (context, params) => DiagnosticogestacaoWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: CalendarioSanitarioWidget.routeName,
          path: CalendarioSanitarioWidget.routePath,
          builder: (context, params) => CalendarioSanitarioWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: RelatorioFinanceiroWidget.routeName,
          path: RelatorioFinanceiroWidget.routePath,
          builder: (context, params) => RelatorioFinanceiroWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: NovoRelatorioFinanceiroWidget.routeName,
          path: NovoRelatorioFinanceiroWidget.routePath,
          builder: (context, params) => NovoRelatorioFinanceiroWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ListacompletaWidget.routeName,
          path: ListacompletaWidget.routePath,
          builder: (context, params) => ListacompletaWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ApagarContaWidget.routeName,
          path: ApagarContaWidget.routePath,
          builder: (context, params) => ApagarContaWidget(),
        ),
        FFRoute(
          name: EditarRelatorioFinanceiroWidget.routeName,
          path: EditarRelatorioFinanceiroWidget.routePath,
          builder: (context, params) => EditarRelatorioFinanceiroWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
            uidFinanceiro: params.getParam(
              'uidFinanceiro',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'financeiro'],
            ),
          ),
        ),
        FFRoute(
          name: RecriacaoWidget.routeName,
          path: RecriacaoWidget.routePath,
          builder: (context, params) => RecriacaoWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: RecriacaoCopyWidget.routeName,
          path: RecriacaoCopyWidget.routePath,
          builder: (context, params) => RecriacaoCopyWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: SecasCopyWidget.routeName,
          path: SecasCopyWidget.routePath,
          builder: (context, params) => SecasCopyWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: RecriacaoCopy2Widget.routeName,
          path: RecriacaoCopy2Widget.routePath,
          builder: (context, params) => RecriacaoCopy2Widget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: CalendarioSanitarioCopyWidget.routeName,
          path: CalendarioSanitarioCopyWidget.routePath,
          builder: (context, params) => CalendarioSanitarioCopyWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: CalendarioSanitarioCopy2Widget.routeName,
          path: CalendarioSanitarioCopy2Widget.routePath,
          builder: (context, params) => CalendarioSanitarioCopy2Widget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ListacompletaCopyWidget.routeName,
          path: ListacompletaCopyWidget.routePath,
          builder: (context, params) => ListacompletaCopyWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: CadastrarNovoAnimalCopyWidget.routeName,
          path: CadastrarNovoAnimalCopyWidget.routePath,
          builder: (context, params) => CadastrarNovoAnimalCopyWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            grupoPredominante: params.getParam(
              'grupoPredominante',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            initialTabSelect: params.getParam(
              'initialTabSelect',
              ParamType.int,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ListaAnimaisCopyWidget.routeName,
          path: ListaAnimaisCopyWidget.routePath,
          builder: (context, params) => ListaAnimaisCopyWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            tabBarOpenSelected: params.getParam(
              'tabBarOpenSelected',
              ParamType.int,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            initialTabSelect: params.getParam(
              'initialTabSelect',
              ParamType.int,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ListaInseminacoesAntesOfflineWidget.routeName,
          path: ListaInseminacoesAntesOfflineWidget.routePath,
          builder: (context, params) => ListaInseminacoesAntesOfflineWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ExameGinecologicoBkpOfflineWidget.routeName,
          path: ExameGinecologicoBkpOfflineWidget.routePath,
          builder: (context, params) => ExameGinecologicoBkpOfflineWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: DiagnosticogestacaoBkpOfflineWidget.routeName,
          path: DiagnosticogestacaoBkpOfflineWidget.routePath,
          builder: (context, params) => DiagnosticogestacaoBkpOfflineWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: AnimaisPrenhasBkpOfflineWidget.routeName,
          path: AnimaisPrenhasBkpOfflineWidget.routePath,
          builder: (context, params) => AnimaisPrenhasBkpOfflineWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: RecriacaoCopy3Widget.routeName,
          path: RecriacaoCopy3Widget.routePath,
          builder: (context, params) => RecriacaoCopy3Widget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ProntuarioAnimalOfflineWidget.routeName,
          path: ProntuarioAnimalOfflineWidget.routePath,
          builder: (context, params) => ProntuarioAnimalOfflineWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            grupoPredominante: params.getParam(
              'grupoPredominante',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
            itemUidIndex: params.getParam(
              'itemUidIndex',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: ListaAnimaisCopy2Widget.routeName,
          path: ListaAnimaisCopy2Widget.routePath,
          builder: (context, params) => ListaAnimaisCopy2Widget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            tabBarOpenSelected: params.getParam(
              'tabBarOpenSelected',
              ParamType.int,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            initialTabSelect: params.getParam(
              'initialTabSelect',
              ParamType.int,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: DiagnosticogestacaoModo1OffWidget.routeName,
          path: DiagnosticogestacaoModo1OffWidget.routePath,
          builder: (context, params) => DiagnosticogestacaoModo1OffWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: AcoesFalhadasbkpWidget.routeName,
          path: AcoesFalhadasbkpWidget.routePath,
          builder: (context, params) => AcoesFalhadasbkpWidget(),
        ),
        FFRoute(
          name: AcoesFalhadasWidget.routeName,
          path: AcoesFalhadasWidget.routePath,
          builder: (context, params) => AcoesFalhadasWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
          ),
        ),
        FFRoute(
          name: ImportacaoAnimaisWidget.routeName,
          path: ImportacaoAnimaisWidget.routePath,
          builder: (context, params) => ImportacaoAnimaisWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ListacompletaNewBkpWidget.routeName,
          path: ListacompletaNewBkpWidget.routePath,
          builder: (context, params) => ListacompletaNewBkpWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ListacompletaBkpUltimoWidget.routeName,
          path: ListacompletaBkpUltimoWidget.routePath,
          builder: (context, params) => ListacompletaBkpUltimoWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ListaInseminacoesBkpDezWidget.routeName,
          path: ListaInseminacoesBkpDezWidget.routePath,
          builder: (context, params) => ListaInseminacoesBkpDezWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: AnimaisPrenhasBkpRecenteWidget.routeName,
          path: AnimaisPrenhasBkpRecenteWidget.routePath,
          builder: (context, params) => AnimaisPrenhasBkpRecenteWidget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: InicioPropriedadeProdutorWidget.routeName,
          path: InicioPropriedadeProdutorWidget.routePath,
          builder: (context, params) => InicioPropriedadeProdutorWidget(
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: VerificaTipoLoginWidget.routeName,
          path: VerificaTipoLoginWidget.routePath,
          builder: (context, params) => VerificaTipoLoginWidget(),
        ),
        FFRoute(
          name: ListaAnimaisCopy3Widget.routeName,
          path: ListaAnimaisCopy3Widget.routePath,
          builder: (context, params) => ListaAnimaisCopy3Widget(
            uidPropriedade: params.getParam(
              'uidPropriedade',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico', 'propriedades'],
            ),
            nomePropriedade: params.getParam(
              'nomePropriedade',
              ParamType.String,
            ),
            uidTecnico: params.getParam(
              'uidTecnico',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['tecnico'],
            ),
            emailPropriedade: params.getParam(
              'emailPropriedade',
              ParamType.String,
            ),
            tabBarOpenSelected: params.getParam(
              'tabBarOpenSelected',
              ParamType.int,
            ),
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
            initialTabSelect: params.getParam(
              'initialTabSelect',
              ParamType.int,
            ),
            diasDg: params.getParam(
              'diasDg',
              ParamType.String,
            ),
          ),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    List<String>? collectionNamePath,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      collectionNamePath: collectionNamePath,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/welcome';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? Container(
                  color: Colors.transparent,
                  child: Image.asset(
                    'assets/images/splash.fw.png',
                    fit: BoxFit.cover,
                  ),
                )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(seconds: 5),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
