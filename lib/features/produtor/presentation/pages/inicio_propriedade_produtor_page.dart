import 'dart:async';

import '/core/connectivity/connectivity_service.dart';
import '/core/auth/firebase_auth/auth_util.dart';
import '/data/backend.dart';
import '/core/ui/flutter_flow_animations.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/menu_acao_card.dart';
import '/core/ui/flutter_flow_util.dart';
import '/data/objectbox/entities/animal_entity.dart';
import '/features/animais/application/animais_providers.dart';
import '/features/propriedades/presentation/pages/editar_propriedade_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// Importa os widgets refatorados
import '../widgets/widgets.dart';

/// Widget principal da página de início da propriedade do produtor.
///
/// Esta versão refatorada utiliza componentes separados para:
/// - [PropriedadeMenuGrid]: Grid com todos os itens de menu
/// - [SyncStatusBar]: Barra de status de sincronização
/// - [PropriedadeNavigationParams]: Parâmetros de navegação reutilizáveis
class InicioPropriedadeProdutorPage extends ConsumerStatefulWidget {
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
  ConsumerState<InicioPropriedadeProdutorPage> createState() =>
      _InicioPropriedadeProdutorPageState();
}

class _InicioPropriedadeProdutorPageState
    extends ConsumerState<InicioPropriedadeProdutorPage>
    with TickerProviderStateMixin {
  StreamSubscription<bool>? _conectividadeSub;
  bool? _respostaNet = true;

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
    _conectividadeSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Animais lidos do ObjectBox (offline-first), filtrados pela propriedade —
    // a mesma fonte que a home do TÉCNICO já usa. Antes era um StreamBuilder do
    // Firestore: como toda escrita (DG+, cadastro) vai primeiro ao ObjectBox e
    // só chega ao Firestore pelo motor de sync, que é gated em conectividade,
    // offline esta lista congelava e os contadores do menu mostravam números
    // velhos. A ordenação do Firestore (nome/brinco) não faz falta: a lista
    // alimenta apenas os badges.
    final animaisAsync = ref
        .watch(animaisByPropriedadeProvider(widget.uidPropriedade?.path ?? ''));

    return animaisAsync.when(
      loading: () => _buildLoadingScaffold(),
      error: (_, __) => Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: const Center(child: Text('Erro ao carregar os animais.')),
      ),
      data: (animaisRecordList) {
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
  Widget _buildMenuGridPadding(List<AnimalEntity> animaisRecordList) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 16.0),
      child: PropriedadeMenuGrid(
        animaisRecordList: animaisRecordList,
        navigationParams: _navigationParams,
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
