import 'dart:async';

import 'package:tecmuu/data/objectbox/widgets/objectbox_debug_menu.dart';

import '/core/connectivity/connectivity_service.dart';
import '/core/auth/firebase_auth/auth_util.dart';
import '/core/ui/flutter_flow_animations.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';
import '/core/ui/flutter_flow_util.dart';
import '/features/animais/application/animais_providers.dart';
import '/data/objectbox/entities/index.dart';
import '/data/objectbox/remote_sync_listeners_service.dart';
import '/features/onboarding/presentation/pages/welcome_page.dart';
import '/features/propriedades/application/firestore_refs.dart';
import '/features/propriedades/application/propriedades_providers.dart';
import '/features/propriedades/presentation/pages/lista_propriedade_page.dart';
import '/features/perfil/presentation/pages/profile_tecnico_page.dart';
import '/features/plano/presentation/pages/subscription_plan_tecnico_page.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// Widgets refatorados
import '../widgets/widgets.dart';

/// Dashboard principal do técnico.
///
/// Componentes utilizados:
/// - [DashboardHeader]: Header com estatísticas rápidas
/// - [DashboardStatCard]: Cards de estatísticas
/// - [PropriedadesProgressCard]: Card com progresso circular
/// - [DashboardActionButton]: Botão de ação principal
/// - [DashboardSecondaryActionCard]: Card de ação secundária
class DashboardTecnicoPage extends ConsumerStatefulWidget {
  const DashboardTecnicoPage({super.key});

  static String routeName = 'dashboardTecnico';
  static String routePath = '/dashboardTecnico';

  @override
  ConsumerState<DashboardTecnicoPage> createState() =>
      _DashboardTecnicoPageState();
}

class _DashboardTecnicoPageState extends ConsumerState<DashboardTecnicoPage>
    with TickerProviderStateMixin {
  StreamSubscription<bool>? _conectividadeSub;
  bool? _respostaNet = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();

    _setupInternetCheckTimer();
    _setupAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  /// Configura o timer de verificação de internet.
  void _setupInternetCheckTimer() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // Conectividade por transicao real, nao por polling: antes era um
      // timer periodico de 5s cujo callback chamava safeSetState
      // incondicionalmente, reconstruindo a arvore inteira houvesse mudanca
      // ou nao. O valor alimenta um unico lugar: a cor de um botao.
      _respostaNet = ConnectivityService.instance.isOnline;
      _conectividadeSub =
          ConnectivityService.instance.onStatusChange.listen((online) {
        if (mounted) safeSetState(() => _respostaNet = online);
      });
    });
  }

  /// Configura as animações da página.
  void _setupAnimations() {
    animationsMap.addAll({
      'containerOnPageLoadAnimation4': _createContainerAnimation(),
      'containerOnPageLoadAnimation5': _createContainerAnimation(),
    });

    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  AnimationInfo _createContainerAnimation() {
    return AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effectsBuilder: () => [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.0.ms,
          duration: 300.0.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.0.ms,
          duration: 300.0.ms,
          begin: const Offset(0.0, 20.0),
          end: const Offset(0.0, 0.0),
        ),
        TiltEffect(
          curve: Curves.easeInOut,
          delay: 0.0.ms,
          duration: 300.0.ms,
          begin: const Offset(0.698, 0),
          end: const Offset(0, 0),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _conectividadeSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Técnico lido do ObjectBox (offline-first), não mais do Firestore.
    final tecnicoAsync = ref.watch(tecnicoLogadoProvider);

    return tecnicoAsync.when(
      loading: () => _buildLoadingScaffold(),
      error: (_, __) => _buildLoadingScaffold(),
      data: (tecnicoRecord) {
        if (tecnicoRecord == null) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: SafeArea(
              child: TecnicoAusenteView(onSair: _sairDaConta),
            ),
          );
        }

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: _buildAppBar(),
            body: SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _buildHeaderSection(tecnicoRecord),
                    _buildProgressSection(tecnicoRecord),
                    _buildActionsSection(tecnicoRecord),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Sai da conta pelo mesmo caminho do botao de logout do perfil.
  ///
  /// E o unico caminho que recupera um cache sem o tecnico: o logout apaga as
  /// marcas de sincronizacao, e o login seguinte volta a fazer o download
  /// completo.
  Future<void> _sairDaConta() async {
    // Para os listeners remotos (evita escutar dados do tecnico anterior
    // apos a troca de conta).
    if (RemoteSyncListenersService.isInitialized) {
      RemoteSyncListenersService.instance.dispose();
    }
    GoRouter.of(context).prepareAuthEvent();
    await authManager.signOut();
    if (!mounted) return;
    GoRouter.of(context).clearRedirectLocation();
    context.goNamedAuth(WelcomePage.routeName, context.mounted);
  }

  /// Scaffold de loading.
  Widget _buildLoadingScaffold() {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: const AppLoadingIndicator(),
    );
  }

  /// AppBar do dashboard.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor:
          _respostaNet! ? const Color(0xFFF75E38) : const Color(0xFFF2886E),
      automaticallyImplyLeading: false,
      title: Text(
        currentUserDisplayName,
        style: FlutterFlowTheme.of(context).headlineMedium.override(
              font: GoogleFonts.outfit(
                fontWeight:
                    FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                fontStyle:
                    FlutterFlowTheme.of(context).headlineMedium.fontStyle,
              ),
              color: Colors.white,
              letterSpacing: 0.0,
              fontWeight:
                  FlutterFlowTheme.of(context).headlineMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
            ),
      ),
      actions: [
        // Botão Debug (apenas em debug mode)
        if (kDebugMode)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
            child: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 60.0,
              icon: const Icon(
                Icons.bug_report_outlined,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ObjectBoxDebugMenu(),
                  ),
                );
              },
            ),
          ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
          child: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              context.pushNamed(ProfileTecnicoPage.routeName);
            },
          ),
        ),
      ],
      centerTitle: false,
      elevation: 0.0,
    );
  }

  /// Seção do header com estatísticas.
  Widget _buildHeaderSection(TecnicoEntity tecnicoRecord) {
    return DashboardHeader(
      email: currentUserEmail,
      isOnline: _respostaNet!,
      child: _buildStatsList(tecnicoRecord),
    );
  }

  /// Lista horizontal de estatísticas.
  Widget _buildStatsList(TecnicoEntity tecnicoRecord) {
    return ListView(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: [
        // Card: Propriedades
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 8.0),
          child: _buildPropriedadesStatCard(tecnicoRecord),
        ),
        // Card: Animais ativos
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 8.0),
          child: _buildAnimaisAtivosStatCard(tecnicoRecord),
        ),
        // Card: Total de registros
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 8.0),
          child: DashboardStatCard(
            value: tecnicoRecord.quantidadeAnimaisCadastrados.toString(),
            label: 'Total de registros',
            icon: Icons.inventory_2_rounded,
            accent: AppTokens.brand,
          ),
        ),
      ],
    );
  }

  /// Card de estatística de propriedades.
  Widget _buildPropriedadesStatCard(TecnicoEntity tecnicoRecord) {
    // Conta as propriedades ATIVAS (o stream antigo do Firestore não filtrava
    // `isDeleted`, então incluía as da lixeira).
    final propriedades = ref
            .watch(propriedadesAtivasProvider(
                'tecnico/${tecnicoRecord.firestoreId}'))
            .valueOrNull ??
        const <PropriedadeEntity>[];

    return DashboardStatCard(
      value: propriedades.length.toString(),
      label: 'Propriedades',
      icon: Icons.home_work_rounded,
      accent: AppTokens.brand,
    );
  }

  /// Card de estatística de animais ativos.
  Widget _buildAnimaisAtivosStatCard(TecnicoEntity tecnicoRecord) {
    // Lido do ObjectBox: antes era um snapshots() do Firestore com limit 500,
    // um stream ao vivo de ate 500 documentos para exibir um numero.
    final contagem = ref.watch(animaisAtivosCountProvider);
    return contagem.when(
      loading: () => const DashboardStatCardWithStream(
        valueWidget: AppLoadingIndicator(size: 30.0),
        label: 'Animais ativos',
        icon: Icons.pets_rounded,
        accent: AppTokens.secondary,
      ),
      error: (_, __) => const DashboardStatCard(
        value: '—',
        label: 'Animais ativos',
        icon: Icons.pets_rounded,
        accent: AppTokens.secondary,
      ),
      data: (n) => DashboardStatCard(
        value: n.toString(),
        label: 'Animais ativos',
        icon: Icons.pets_rounded,
        accent: AppTokens.secondary,
      ),
    );
  }

  /// Seção de progresso das propriedades.
  Widget _buildProgressSection(TecnicoEntity tecnicoRecord) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 20.0, 16.0, 0.0),
      child: PropriedadesProgressCard(
        currentCount: ref
                .watch(propriedadesAtivasProvider(
                    'tecnico/${tecnicoRecord.firestoreId}'))
                .valueOrNull
                ?.length ??
            0,
        limitCount: tecnicoRecord.limiteProdutoresContratado,
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation4']!);
  }

  /// Seção de ações do dashboard.
  Widget _buildActionsSection(TecnicoEntity tecnicoRecord) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildVisitaText(),
            _buildVisitaButton(),
            _buildMudarPlanoSection(tecnicoRecord),
          ],
        ),
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation5']!);
  }

  /// Texto de instruções para visita.
  Widget _buildVisitaText() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 10.0),
      child: Text(
        'Inicie uma visita a uma propriedade.',
        textAlign: TextAlign.center,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FontWeight.normal,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              fontSize: 16.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.normal,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
      ),
    );
  }

  /// Botão de iniciar visita.
  Widget _buildVisitaButton() {
    return DashboardActionButton(
      text: 'Iniciar visita propriedade',
      onPressed: () {
        context.pushNamed(
          ListaPropriedadePage.routeName,
          queryParameters: {
            'visitaPresencial': serializeParam(true, ParamType.bool),
          }.withoutNulls,
        );
      },
    );
  }

  /// Seção de mudar plano.
  Widget _buildMudarPlanoSection(TecnicoEntity tecnicoRecord) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DashboardSecondaryActionCard(
            title: 'Mudar',
            buttonText: 'Atualizar',
            onPressed: () {
              context.pushNamed(
                SubscriptionPlanTecnicoPage.routeName,
                queryParameters: {
                  'uidTecnico': serializeParam(
                    tecnicoRecord.docRef,
                    ParamType.DocumentReference,
                  ),
                  'email': serializeParam(
                    currentUserEmail,
                    ParamType.String,
                  ),
                }.withoutNulls,
              );
            },
          ),
        ],
      ),
    );
  }
}
