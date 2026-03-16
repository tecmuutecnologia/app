import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/pages/tecnico/propriedade/sincronizacao/alerta_sem_internet/alerta_sem_internet_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dashboard_tecnico_model.dart';
export 'dashboard_tecnico_model.dart';

// Widgets refatorados
import 'widgets/widgets.dart';

/// Dashboard principal do técnico.
///
/// Componentes utilizados:
/// - [DashboardHeader]: Header com estatísticas rápidas
/// - [DashboardStatCard]: Cards de estatísticas
/// - [PropriedadesProgressCard]: Card com progresso circular
/// - [DashboardActionButton]: Botão de ação principal
/// - [DashboardSecondaryActionCard]: Card de ação secundária
class DashboardTecnicoWidget extends StatefulWidget {
  const DashboardTecnicoWidget({super.key});

  static String routeName = 'dashboardTecnico';
  static String routePath = '/dashboardTecnico';

  @override
  State<DashboardTecnicoWidget> createState() => _DashboardTecnicoWidgetState();
}

class _DashboardTecnicoWidgetState extends State<DashboardTecnicoWidget>
    with TickerProviderStateMixin {
  late DashboardTecnicoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DashboardTecnicoModel());

    _setupInternetCheckTimer();
    _setupAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  /// Configura o timer de verificação de internet.
  void _setupInternetCheckTimer() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.instantTimer = InstantTimer.periodic(
        duration: const Duration(milliseconds: 3000),
        callback: (timer) async {
          _model.respostaNet = await actions.checkInternetConnection();
          if (!_model.respostaNet!) {
            if (FFAppState().verificaInternet == -1) {
              FFAppState().verificaInternet = 0;
              safeSetState(() {});
              await _showNoInternetAlert();
              _model.instantTimer?.cancel();
              return;
            }
          }
        },
        startImmediately: false,
      );
    });
  }

  /// Exibe alerta de sem internet.
  Future<void> _showNoInternetAlert() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: const AlertaSemInternetWidget(),
          ),
        );
      },
    ).then((value) => safeSetState(() {}));
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
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TecnicoRecord>>(
      stream: queryTecnicoRecord(
        queryBuilder: (tecnicoRecord) => tecnicoRecord.where(
          'uidPerson',
          isEqualTo: currentUserUid,
        ),
        singleRecord: true,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildLoadingScaffold();
        }

        if (snapshot.data!.isEmpty) {
          return Container();
        }

        final tecnicoRecord = snapshot.data!.first;

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
          _model.respostaNet! ? const Color(0xFFF75E38) : const Color(0xFFF2886E),
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
              context.pushNamed(ProfileTecnicoWidget.routeName);
            },
          ),
        ),
      ],
      centerTitle: false,
      elevation: 0.0,
    );
  }

  /// Seção do header com estatísticas.
  Widget _buildHeaderSection(TecnicoRecord tecnicoRecord) {
    return DashboardHeader(
      email: currentUserEmail,
      isOnline: _model.respostaNet!,
      child: _buildStatsList(tecnicoRecord),
    );
  }

  /// Lista horizontal de estatísticas.
  Widget _buildStatsList(TecnicoRecord tecnicoRecord) {
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
          ),
        ),
      ],
    );
  }

  /// Card de estatística de propriedades.
  Widget _buildPropriedadesStatCard(TecnicoRecord tecnicoRecord) {
    return StreamBuilder<List<PropriedadesRecord>>(
      stream: queryPropriedadesRecord(parent: tecnicoRecord.reference),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const DashboardStatCardWithStream(
            valueWidget: AppLoadingIndicator(size: 30.0),
            label: 'Propriedades',
          );
        }

        return DashboardStatCard(
          value: snapshot.data!.length.toString(),
          label: 'Propriedades',
        );
      },
    );
  }

  /// Card de estatística de animais ativos.
  Widget _buildAnimaisAtivosStatCard(TecnicoRecord tecnicoRecord) {
    return StreamBuilder<List<AnimaisProdutoresRecord>>(
      stream: queryAnimaisProdutoresRecord(parent: tecnicoRecord.reference),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const DashboardStatCardWithStream(
            valueWidget: AppLoadingIndicator(size: 30.0),
            label: 'Animais ativos',
          );
        }

        final animaisAtivos = snapshot.data!
            .where((e) => (e.status != 'Descarte') && (e.grupoAnimal != 'Sêmens'))
            .toList()
            .length;

        return DashboardStatCard(
          value: animaisAtivos.toString(),
          label: 'Animais ativos',
        );
      },
    );
  }

  /// Seção de progresso das propriedades.
  Widget _buildProgressSection(TecnicoRecord tecnicoRecord) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 20.0, 16.0, 0.0),
      child: StreamBuilder<List<PropriedadesRecord>>(
        stream: queryPropriedadesRecord(parent: tecnicoRecord.reference),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const AppLoadingIndicator();
          }

          return PropriedadesProgressCard(
            currentCount: snapshot.data!.length,
            limitCount: tecnicoRecord.limiteProdutoresContratado,
          );
        },
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation4']!);
  }

  /// Seção de ações do dashboard.
  Widget _buildActionsSection(TecnicoRecord tecnicoRecord) {
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
          ListaPropriedadeWidget.routeName,
          queryParameters: {
            'visitaPresencial': serializeParam(true, ParamType.bool),
          }.withoutNulls,
        );
      },
    );
  }

  /// Seção de mudar plano.
  Widget _buildMudarPlanoSection(TecnicoRecord tecnicoRecord) {
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
                SubscriptionPlanTecnicoWidget.routeName,
                queryParameters: {
                  'uidTecnico': serializeParam(
                    tecnicoRecord.reference,
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
