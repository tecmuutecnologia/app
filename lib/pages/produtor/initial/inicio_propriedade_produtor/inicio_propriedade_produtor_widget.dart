import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'inicio_propriedade_produtor_model.dart';
export 'inicio_propriedade_produtor_model.dart';

// Importa os widgets refatorados
import 'widgets/widgets.dart';

/// Widget principal da página de início da propriedade do produtor.
///
/// Esta versão refatorada utiliza componentes separados para:
/// - [PropriedadeMenuGrid]: Grid com todos os itens de menu
/// - [MenuItemCard]: Card de menu simples
/// - [MenuItemCardWithBadge]: Card de menu com badge de contagem
/// - [SyncStatusBar]: Barra de status de sincronização
/// - [PropriedadeNavigationParams]: Parâmetros de navegação reutilizáveis
class InicioPropriedadeProdutorWidget extends StatefulWidget {
  const InicioPropriedadeProdutorWidget({
    super.key,
    required this.nomePropriedade,
    required this.uidPropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.diasDg,
  });

  final String? nomePropriedade;
  final DocumentReference? uidPropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? diasDg;

  static String routeName = 'inicioPropriedadeProdutor';
  static String routePath = '/inicioPropriedadeProdutor';

  @override
  State<InicioPropriedadeProdutorWidget> createState() =>
      _InicioPropriedadeProdutorWidgetState();
}

class _InicioPropriedadeProdutorWidgetState
    extends State<InicioPropriedadeProdutorWidget>
    with TickerProviderStateMixin {
  late InicioPropriedadeProdutorModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};

  /// Parâmetros de navegação encapsulados para reutilização
  late final PropriedadeNavigationParams _navigationParams;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InicioPropriedadeProdutorModel());

    // Inicializa parâmetros de navegação
    _navigationParams = PropriedadeNavigationParams(
      uidPropriedade: widget.uidPropriedade,
      nomePropriedade: widget.nomePropriedade,
      uidTecnico: widget.uidTecnico,
      emailPropriedade: widget.emailPropriedade,
      visitaPresencial: widget.visitaPresencial,
      diasDg: widget.diasDg,
    );

    // Configura o timer de verificação de internet
    _setupInternetCheckTimer();

    // Configura animações
    _setupAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  /// Configura o timer periódico para verificar conexão com internet.
  void _setupInternetCheckTimer() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.instantTimer = InstantTimer.periodic(
        duration: const Duration(seconds: 5),
        callback: (timer) async {
          _model.respostaNet = await actions.checkInternetConnection();
          safeSetState(() {});

          if (_model.respostaNet!) {
            safeSetState(() {});
          } else {
            // Offline: notificação passiva via SyncStatusBanner (app-wide);
            // sem modal bloqueante. O respostaNet acima já atualiza a UI.
          }
        },
        startImmediately: false,
      );
    });
  }

  /// Configura as animações dos containers.
  void _setupAnimations() {
    // Cria 14 animações idênticas para os containers
    for (int i = 1; i <= 14; i++) {
      animationsMap['containerOnPageLoadAnimation$i'] =
          _createContainerAnimation();
    }

    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  /// Cria uma animação padrão de container (fade + move).
  AnimationInfo _createContainerAnimation() {
    return AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effectsBuilder: () => [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.0.ms,
          duration: 600.0.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.0.ms,
          duration: 600.0.ms,
          begin: const Offset(0.0, 90.0),
          end: const Offset(0.0, 0.0),
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
    context.watch<FFAppState>();

    return StreamBuilder<List<AnimaisProdutoresRecord>>(
      stream: _model.cacheAnimaisListaCompleta(
        requestFn: () => queryAnimaisProdutoresRecord(
          parent: widget.uidTecnico,
          queryBuilder: (animaisProdutoresRecord) => animaisProdutoresRecord
              .where('uidTecnicoPropriedade', isEqualTo: widget.uidPropriedade)
              .orderBy('nomeAnimal')
              .orderBy('brincoAnimalOrder'),
        ),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildLoadingScaffold();
        }

        final animaisRecordList = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            appBar: _buildAppBar(),
            body: SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMenuTitle(context),
                    _buildMenuGridPadding(animaisRecordList),
                    _buildSyncStatusSection(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Constrói o Scaffold de loading.
  Widget _buildLoadingScaffold() {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: const Center(
        child: SizedBox(
          width: 50.0,
          height: 50.0,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF75E38)),
          ),
        ),
      ),
    );
  }

  /// Constrói a AppBar.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _model.respostaNet!
          ? const Color(0xFFF75E38)
          : const Color(0xFFF2886E),
      automaticallyImplyLeading: false,
      title: Text(
        widget.nomePropriedade!,
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
            onPressed: _navigateToEditarPropriedade,
          ),
        ),
      ],
      centerTitle: false,
      elevation: 0.0,
    );
  }

  /// Navega para a tela de editar propriedade.
  void _navigateToEditarPropriedade() {
    context.pushNamed(
      EditarPropriedadeWidget.routeName,
      queryParameters: {
        ..._navigationParams.toQueryParameters(),
        'emailTecnico': serializeParam(
          currentUserEmail,
          ParamType.String,
        ),
      },
    );
  }

  /// Constrói o título do menu.
  Widget _buildMenuTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 25.0, 0.0, 0.0),
      child: Text(
        'Menu de Ações',
        textAlign: TextAlign.start,
        style: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FontWeight.w600,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
      ),
    );
  }

  /// Constrói o grid de menu com padding.
  Widget _buildMenuGridPadding(
      List<AnimaisProdutoresRecord> animaisRecordList) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: PropriedadeMenuGrid(
        animaisRecordList: animaisRecordList,
        navigationParams: _navigationParams,
        isOnline: _model.respostaNet ?? true,
        animationsMap: animationsMap,
      ),
    );
  }

  /// Constrói a seção de status de sincronização.
  Widget _buildSyncStatusSection() {
    final appState = FFAppState();
    final isOnline = _model.respostaNet ?? true;

    // Sem internet
    if (!isOnline) {
      return SyncStatusBar(
        isOnline: false,
        offlineAnimaisCount: appState.animaisProdutoresOffline.length,
        editedAnimaisCount: appState.animaisProdutoresEditados
            .where((e) => e.uidTecnicoPropriedade == widget.uidPropriedade)
            .toList()
            .length,
        offlineActionsCount: appState.acoesOffline.length,
        uidTecnico: widget.uidTecnico,
        uidPropriedade: widget.uidPropriedade,
      );
    }

    // Com internet e tem dados para sincronizar
    if (appState.animaisProdutoresOffline.isNotEmpty ||
        appState.animaisProdutoresEditados.isNotEmpty ||
        appState.acoesOffline.isNotEmpty) {
      return _buildSyncRequiredSection(appState);
    }

    return const SizedBox.shrink();
  }

  /// Constrói a seção quando sincronização é necessária.
  Widget _buildSyncRequiredSection(FFAppState appState) {
    return Opacity(
      opacity: 0.0,
      child: Container(
        width: MediaQuery.sizeOf(context).width * 1.0,
        height: 150.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
        ),
        child: Wrap(
          spacing: 0.0,
          runSpacing: 0.0,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.start,
          direction: Axis.horizontal,
          runAlignment: WrapAlignment.start,
          verticalDirection: VerticalDirection.down,
          clipBehavior: Clip.none,
          children: [
            _buildSyncMessage(appState),
            _buildSyncNowButton(),
            _buildIgnoreAndDeleteButton(appState),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncMessage(FFAppState appState) {
    final editedCount = appState.animaisProdutoresEditados
        .where((e) => e.uidTecnicoPropriedade == widget.uidPropriedade)
        .toList()
        .length;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
      child: Text(
        'Você tem ${appState.animaisProdutoresOffline.length} novos animais cadastrados, '
        '$editedCount animais modificados e '
        '${appState.acoesOffline.length} novas ações feitas. '
        'Deseja sincronizá-los agora?',
        textAlign: TextAlign.center,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FontWeight.bold,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              color: const Color(0xFFD50000),
              letterSpacing: 0.0,
              fontWeight: FontWeight.bold,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
      ),
    );
  }

  Widget _buildSyncNowButton() {
    return const SizedBox.shrink();
  }

  Widget _buildIgnoreAndDeleteButton(FFAppState appState) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
      child: FFButtonWidget(
        onPressed: () async {
          final confirmDialogResponse = await showDialog<bool>(
                context: context,
                builder: (alertDialogContext) {
                  return AlertDialog(
                    title: const Text('Deseja realmente ignorar ações?'),
                    content: const Text(
                        'Essa ação apaga todas as ações feitas offline.'),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(alertDialogContext, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(alertDialogContext, true),
                        child: const Text('Confirmar'),
                      ),
                    ],
                  );
                },
              ) ??
              false;

          if (confirmDialogResponse) {
            appState.animaisProdutoresOffline = [];
            appState.animaisProdutoresEditados = [];
            appState.acoesOffline = [];
            safeSetState(() {});
          }
        },
        text: 'Ignorar e apagar',
        icon: const Icon(Icons.sync, size: 15.0),
        options: FFButtonOptions(
          height: 40.0,
          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
          iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          color: const Color(0xFFD50000),
          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).titleSmall.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                ),
                color: Colors.white,
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
              ),
          elevation: 3.0,
          borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
