import '/core/auth/firebase_auth/auth_util.dart';
import '/data/backend.dart';
import '/core/ui/flutter_flow_animations.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';
import '/core/ui/menu_acao_card.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/instant_timer.dart';
import '/core/ui/request_manager.dart';
import '/core/services/index.dart' as actions;
import '/features/propriedades/presentation/pages/editar_propriedade_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Importa os widgets refatorados
import '../widgets/widgets.dart';

/// Widget principal da página de início da propriedade do produtor.
///
/// Esta versão refatorada utiliza componentes separados para:
/// - [PropriedadeMenuGrid]: Grid com todos os itens de menu
/// - [SyncStatusBar]: Barra de status de sincronização
/// - [PropriedadeNavigationParams]: Parâmetros de navegação reutilizáveis
class InicioPropriedadeProdutorPage extends StatefulWidget {
  const InicioPropriedadeProdutorPage({
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
  State<InicioPropriedadeProdutorPage> createState() =>
      _InicioPropriedadeProdutorPageState();
}

class _InicioPropriedadeProdutorPageState
    extends State<InicioPropriedadeProdutorPage> with TickerProviderStateMixin {
  InstantTimer? _instantTimer;
  bool? _respostaNet = true;

  final _cacheAnimaisListaCompletaManager =
      StreamRequestManager<List<AnimaisProdutoresRecord>>();
  Stream<List<AnimaisProdutoresRecord>> _cacheAnimaisListaCompleta({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<AnimaisProdutoresRecord>> Function() requestFn,
  }) =>
      _cacheAnimaisListaCompletaManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};

  /// Parâmetros de navegação encapsulados para reutilização
  late final PropriedadeNavigationParams _navigationParams;

  @override
  void initState() {
    super.initState();

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
      _instantTimer = InstantTimer.periodic(
        duration: const Duration(seconds: 5),
        callback: (timer) async {
          _respostaNet = await actions.checkInternetConnection();
          safeSetState(() {});

          if (_respostaNet!) {
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
    _instantTimer?.cancel();
    _cacheAnimaisListaCompletaManager.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return StreamBuilder<List<AnimaisProdutoresRecord>>(
      stream: _cacheAnimaisListaCompleta(
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
            backgroundColor: AppTokens.canvas(context),
            appBar: _buildAppBar(),
            body: SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MenuAcaoCabecalho(),
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
      backgroundColor: AppTokens.canvas(context),
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
      backgroundColor:
          _respostaNet! ? const Color(0xFFF75E38) : const Color(0xFFF2886E),
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
      EditarPropriedadePage.routeName,
      queryParameters: {
        ..._navigationParams.toQueryParameters(),
        'emailTecnico': serializeParam(
          currentUserEmail,
          ParamType.String,
        ),
      },
    );
  }

  /// Constrói o grid de menu com padding.
  Widget _buildMenuGridPadding(
      List<AnimaisProdutoresRecord> animaisRecordList) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 16.0),
      child: PropriedadeMenuGrid(
        animaisRecordList: animaisRecordList,
        navigationParams: _navigationParams,
        isOnline: _respostaNet ?? true,
        animationsMap: animationsMap,
      ),
    );
  }

  /// Constrói a seção de status de sincronização.
  Widget _buildSyncStatusSection() {
    final isOnline = _respostaNet ?? true;

    // Sem internet: banner passivo. Animais criados offline vão direto ao
    // ObjectBox e sincronizam ao reconectar — sem fila/contagem no FFAppState.
    if (!isOnline) {
      return SyncStatusBar(
        isOnline: false,
        offlineAnimaisCount: 0,
        editedAnimaisCount: 0,
        offlineActionsCount: 0,
        uidTecnico: widget.uidTecnico,
        uidPropriedade: widget.uidPropriedade,
      );
    }

    return const SizedBox.shrink();
  }

  /// Constrói a seção quando sincronização é necessária.
}
