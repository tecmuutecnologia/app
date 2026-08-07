import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/data/backend.dart';
import '/data/schema/structs/index.dart';

import '/core/auth/base_auth_user_provider.dart';
import 'destino_inicial.dart';

import '/core/ui/flutter_flow_util.dart';

import '/features/animais/presentation/pages/cadastrar_novo_animal_page.dart';
import '/features/animais/presentation/pages/editar_animal_page.dart';
import '/features/animais/presentation/pages/lista_animais_page.dart';
import '/features/auth/presentation/pages/create_account_technician_page.dart';
import '/features/auth/presentation/pages/login_technician_page.dart';
import '/features/sincronizacao/domain/sync_state.dart';
import '/features/sincronizacao/presentation/pages/sync_page.dart';
import '/features/calendario_sanitario/presentation/pages/calendario_sanitario_page.dart';
import '/features/dashboard/presentation/pages/dashboard_tecnico_page.dart';
import '/features/diagnostico_gestacao/presentation/pages/diagnosticogestacao_page.dart';
import '/features/exame_ginecologico/presentation/pages/exame_ginecologico_page.dart';
import '/features/financeiro/presentation/pages/editar_relatorio_financeiro_page.dart';
import '/features/financeiro/presentation/pages/novo_relatorio_financeiro_page.dart';
import '/features/financeiro/presentation/pages/relatorio_financeiro_page.dart';
import '/features/inseminacoes/presentation/pages/lista_inseminacoes_page.dart';
import '/features/onboarding/presentation/pages/tutorial_page.dart';
import '/features/onboarding/presentation/pages/welcome_page.dart';
import '/features/perfil/presentation/pages/apagar_conta_page.dart';
import '/features/perfil/presentation/pages/completar_perfil_tecnico_page.dart';
import '/features/perfil/presentation/pages/profile_tecnico_page.dart';
import '/features/plano/presentation/pages/subscription_plan_tecnico_page.dart';
import '/features/prenhas/presentation/pages/animais_prenhas_page.dart';
import '/features/produtor/presentation/pages/inicio_propriedade_produtor_page.dart';
import '/features/produtor/presentation/pages/login_produtor_page.dart';
import '/features/prontuario/presentation/pages/pron_abortos_page.dart';
import '/features/prontuario/presentation/pages/pron_acoes_page.dart';
import '/features/prontuario/presentation/pages/pron_cios_page.dart';
import '/features/prontuario/presentation/pages/pron_diag_gestacao_page.dart';
import '/features/prontuario/presentation/pages/pron_inseminacoes_page.dart';
import '/features/prontuario/presentation/pages/prontuario_animal_page.dart';
import '/features/propriedades/presentation/pages/editar_propriedade_page.dart';
import '/features/propriedades/presentation/pages/inicio_propriedade_page.dart';
import '/features/propriedades/presentation/pages/lista_propriedade_page.dart';
import '/features/propriedades/presentation/pages/nova_propriedade_page.dart';
import '/features/propriedades/presentation/pages/propriedades_excluidas_page.dart';
import '/features/receituario/presentation/pages/receituarios_lista_page.dart';
import '/features/receituario/presentation/pages/resumo_visita_atual_page.dart';
import '/features/recria/presentation/pages/recriacao_page.dart';
import '/features/relatorios/presentation/pages/indices_zootecnicos_page.dart';
import '/features/relatorios/presentation/pages/listacompleta_page.dart';
import '/features/relatorios/presentation/pages/resumo_rebanho_page.dart';
import '/features/secas/presentation/pages/secas_page.dart';
import '/features/sincronizacao/presentation/pages/importacao_animais_page.dart';

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

/// Para onde a rota `/` manda quem abre o app. `null` = fica na tela inicial.
///
/// Antes isto era a `VerificaTipoLoginPage`: uma tela que descobria o destino
/// com duas consultas ao Firestore a cada abertura. O destino agora e gravado
/// no fim da sincronizacao, entao abrir o app e instantaneo e funciona offline.
String? destinoDeAbertura({
  required bool logado,
  required String? destinoGuardado,
}) {
  if (!logado) return null;
  // `/` guardado nunca: redirecionar a rota para ela mesma e laco infinito.
  if (destinoGuardado == null || destinoGuardado == '/') {
    // Instalacao que ainda nao sincronizou (ou sessao anterior a este
    // mecanismo): a sincronizacao resolve. Sem `papel` na rota, ela descobre
    // sozinha de quem e a sessao.
    return SyncPage.routePath;
  }
  return destinoGuardado;
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      // Rota inexistente (deep link velho, URL digitada na web): a tela
      // inicial e o unico destino que serve tanto para quem tem sessao quanto
      // para quem nao tem.
      errorBuilder: (context, state) => WelcomePage(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          redirect: (context, state) => destinoDeAbertura(
            logado: appStateNotifier.loggedIn,
            destinoGuardado: DestinoInicial.valor,
          ),
          builder: (context, _) => WelcomePage(),
        ),
        FFRoute(
          name: WelcomePage.routeName,
          path: WelcomePage.routePath,
          builder: (context, params) => WelcomePage(),
        ),
        FFRoute(
          name: LoginTechnicianPage.routeName,
          path: LoginTechnicianPage.routePath,
          builder: (context, params) => LoginTechnicianPage(),
        ),
        FFRoute(
          name: CreateAccountTechnicianPage.routeName,
          path: CreateAccountTechnicianPage.routePath,
          builder: (context, params) => CreateAccountTechnicianPage(),
        ),
        FFRoute(
          name: DashboardTecnicoPage.routeName,
          path: DashboardTecnicoPage.routePath,
          requireAuth: true,
          builder: (context, params) => DashboardTecnicoPage(),
        ),
        FFRoute(
          name: ListaPropriedadePage.routeName,
          path: ListaPropriedadePage.routePath,
          builder: (context, params) => ListaPropriedadePage(
            visitaPresencial: params.getParam(
              'visitaPresencial',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: NovaPropriedadePage.routeName,
          path: NovaPropriedadePage.routePath,
          builder: (context, params) => NovaPropriedadePage(
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
          name: InicioPropriedadePage.routeName,
          path: InicioPropriedadePage.routePath,
          builder: (context, params) => InicioPropriedadePage(
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
            propriedadePendenteId: params.getParam(
              'propriedadePendenteId',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: EditarPropriedadePage.routeName,
          path: EditarPropriedadePage.routePath,
          builder: (context, params) => EditarPropriedadePage(
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
            propriedadePendenteId: params.getParam(
              'propriedadePendenteId',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: PropriedadesExcluiasPage.routeName,
          path: PropriedadesExcluiasPage.routePath,
          builder: (context, params) => PropriedadesExcluiasPage(
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
          ),
        ),
        FFRoute(
          name: CadastrarNovoAnimalPage.routeName,
          path: CadastrarNovoAnimalPage.routePath,
          builder: (context, params) => CadastrarNovoAnimalPage(
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
          name: ListaAnimaisPage.routeName,
          path: ListaAnimaisPage.routePath,
          builder: (context, params) => ListaAnimaisPage(
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
          name: ListaInseminacoesPage.routeName,
          path: ListaInseminacoesPage.routePath,
          builder: (context, params) => ListaInseminacoesPage(
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
          name: ExameGinecologicoPage.routeName,
          path: ExameGinecologicoPage.routePath,
          builder: (context, params) => ExameGinecologicoPage(
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
          name: AnimaisPrenhasPage.routeName,
          path: AnimaisPrenhasPage.routePath,
          builder: (context, params) => AnimaisPrenhasPage(
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
          name: SecasPage.routeName,
          path: SecasPage.routePath,
          builder: (context, params) => SecasPage(
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
          name: SyncPage.routeName,
          path: SyncPage.routePath,
          builder: (context, params) {
            // Sem o parametro (abertura do app pela `/`), o papel fica nulo e
            // o gateway descobre de quem e a sessao.
            final papel = params.getParam('papel', ParamType.String);
            return SyncPage(
              papel: papel == null
                  ? null
                  : (papel == 'produtor'
                      ? SyncPapel.produtor
                      : SyncPapel.tecnico),
            );
          },
        ),
        FFRoute(
          name: ReceituariosListaPage.routeName,
          path: ReceituariosListaPage.routePath,
          builder: (context, params) => ReceituariosListaPage(
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
          name: ResumoVisitaAtualPage.routeName,
          path: ResumoVisitaAtualPage.routePath,
          builder: (context, params) => ResumoVisitaAtualPage(
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
          name: ResumoRebanhoPage.routeName,
          path: ResumoRebanhoPage.routePath,
          builder: (context, params) => ResumoRebanhoPage(
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
          name: IndicesZootecnicosPage.routeName,
          path: IndicesZootecnicosPage.routePath,
          builder: (context, params) => IndicesZootecnicosPage(
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
          name: CompletarPerfilTecnicoPage.routeName,
          path: CompletarPerfilTecnicoPage.routePath,
          builder: (context, params) => CompletarPerfilTecnicoPage(),
        ),
        FFRoute(
          name: LoginProdutorPage.routeName,
          path: LoginProdutorPage.routePath,
          builder: (context, params) => LoginProdutorPage(),
        ),
        FFRoute(
          name: TutorialPage.routeName,
          path: TutorialPage.routePath,
          builder: (context, params) => TutorialPage(),
        ),
        FFRoute(
          name: ProfileTecnicoPage.routeName,
          path: ProfileTecnicoPage.routePath,
          builder: (context, params) => ProfileTecnicoPage(),
        ),
        FFRoute(
          name: SubscriptionPlanTecnicoPage.routeName,
          path: SubscriptionPlanTecnicoPage.routePath,
          builder: (context, params) => SubscriptionPlanTecnicoPage(
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
          name: ProntuarioAnimalPage.routeName,
          path: ProntuarioAnimalPage.routePath,
          builder: (context, params) => ProntuarioAnimalPage(
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
          name: EditarAnimalPage.routeName,
          path: EditarAnimalPage.routePath,
          builder: (context, params) => EditarAnimalPage(
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
          name: PronInseminacoesPage.routeName,
          path: PronInseminacoesPage.routePath,
          builder: (context, params) => PronInseminacoesPage(
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
          name: PronAcoesPage.routeName,
          path: PronAcoesPage.routePath,
          builder: (context, params) => PronAcoesPage(
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
          name: PronAbortosPage.routeName,
          path: PronAbortosPage.routePath,
          builder: (context, params) => PronAbortosPage(
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
          name: PronDiagGestacaoPage.routeName,
          path: PronDiagGestacaoPage.routePath,
          builder: (context, params) => PronDiagGestacaoPage(
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
          name: PronCiosPage.routeName,
          path: PronCiosPage.routePath,
          builder: (context, params) => PronCiosPage(
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
          name: DiagnosticogestacaoPage.routeName,
          path: DiagnosticogestacaoPage.routePath,
          builder: (context, params) => DiagnosticogestacaoPage(
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
          name: CalendarioSanitarioPage.routeName,
          path: CalendarioSanitarioPage.routePath,
          builder: (context, params) => CalendarioSanitarioPage(
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
          name: RelatorioFinanceiroPage.routeName,
          path: RelatorioFinanceiroPage.routePath,
          builder: (context, params) => RelatorioFinanceiroPage(
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
          name: NovoRelatorioFinanceiroPage.routeName,
          path: NovoRelatorioFinanceiroPage.routePath,
          builder: (context, params) => NovoRelatorioFinanceiroPage(
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
          name: ListacompletaPage.routeName,
          path: ListacompletaPage.routePath,
          builder: (context, params) => ListacompletaPage(
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
          name: ApagarContaPage.routeName,
          path: ApagarContaPage.routePath,
          builder: (context, params) => ApagarContaPage(),
        ),
        FFRoute(
          name: EditarRelatorioFinanceiroPage.routeName,
          path: EditarRelatorioFinanceiroPage.routePath,
          builder: (context, params) => EditarRelatorioFinanceiroPage(
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
            financeiroLocalId: params.getParam(
              'financeiroLocalId',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: RecriacaoPage.routeName,
          path: RecriacaoPage.routePath,
          builder: (context, params) => RecriacaoPage(
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
          name: ImportacaoAnimaisPage.routeName,
          path: ImportacaoAnimaisPage.routePath,
          builder: (context, params) => ImportacaoAnimaisPage(
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
          name: InicioPropriedadeProdutorPage.routeName,
          path: InicioPropriedadeProdutorPage.routePath,
          builder: (context, params) => InicioPropriedadeProdutorPage(
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
    this.redirect,
  });

  final String name;
  final String path;
  final bool requireAuth;

  /// Decisao de destino da propria rota, avaliada depois das guardas de
  /// autenticacao. Devolver `null` mantem a rota.
  final String? Function(BuildContext, GoRouterState)? redirect;
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
          return this.redirect?.call(context, state);
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
    // 5 segundos era o default herdado do FlutterFlow. Nenhuma das telas que
    // pedem transicao informa `duration`, entao todas herdavam um fade de
    // cinco segundos — era o que fazia a ida do "Sou Técnico" para o login
    // parecer travamento. 250ms e a faixa de transicao de tela do Material.
    this.duration = const Duration(milliseconds: 250),
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
