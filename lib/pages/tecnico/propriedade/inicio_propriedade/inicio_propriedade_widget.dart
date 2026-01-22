import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/pages/tecnico/propriedade/sincronizacao/alerta_sem_internet/alerta_sem_internet_widget.dart';
import '/pages/tecnico/propriedade/sincronizacao/sincronizar/sincronizar_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'inicio_propriedade_model.dart';
export 'inicio_propriedade_model.dart';

class InicioPropriedadeWidget extends StatefulWidget {
  const InicioPropriedadeWidget({
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

  static String routeName = 'inicioPropriedade';
  static String routePath = '/inicioPropriedade';

  @override
  State<InicioPropriedadeWidget> createState() =>
      _InicioPropriedadeWidgetState();
}

class _InicioPropriedadeWidgetState extends State<InicioPropriedadeWidget>
    with TickerProviderStateMixin {
  late InicioPropriedadeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InicioPropriedadeModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.instantTimer = InstantTimer.periodic(
        duration: Duration(seconds: 5),
        callback: (timer) async {
          _model.respostaNet = await actions.checkInternetConnection();

          safeSetState(() {});
          if (_model.respostaNet!) {
            FFAppState().verificaInternet = -1;
            safeSetState(() {});
          } else {
            if (FFAppState().verificaInternet == -1) {
              FFAppState().verificaInternet = 0;
              safeSetState(() {});
              _model.instantTimer?.cancel();
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
                      child: AlertaSemInternetWidget(),
                    ),
                  );
                },
              ).then((value) => safeSetState(() {}));

              return;
            }
          }
        },
        startImmediately: true,
      );
    });

    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
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
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
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
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation3': AnimationInfo(
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
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation4': AnimationInfo(
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
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation5': AnimationInfo(
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
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation6': AnimationInfo(
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
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation7': AnimationInfo(
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
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation8': AnimationInfo(
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
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation9': AnimationInfo(
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
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation10': AnimationInfo(
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
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation11': AnimationInfo(
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
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation12': AnimationInfo(
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
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation13': AnimationInfo(
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
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation14': AnimationInfo(
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
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation15': AnimationInfo(
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
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation16': AnimationInfo(
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
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
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
              .where(
                'uidTecnicoPropriedade',
                isEqualTo: widget.uidPropriedade,
              )
              .orderBy('nomeAnimal')
              .orderBy('brincoAnimalOrder'),
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFF75E38),
                  ),
                ),
              ),
            ),
          );
        }
        List<AnimaisProdutoresRecord>
            inicioPropriedadeAnimaisProdutoresRecordList = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            appBar: AppBar(
              backgroundColor:
                  _model.respostaNet! ? Color(0xFFF75E38) : Color(0xFFF2886E),
              automaticallyImplyLeading: false,
              title: Text(
                widget.nomePropriedade!,
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      font: GoogleFonts.outfit(
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontStyle,
                      ),
                      color: Colors.white,
                      letterSpacing: 0.0,
                      fontWeight: FlutterFlowTheme.of(context)
                          .headlineMedium
                          .fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                    ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                  child: FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30.0,
                    borderWidth: 1.0,
                    buttonSize: 60.0,
                    icon: Icon(
                      Icons.account_circle_outlined,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () async {
                      context.pushNamed(
                        EditarPropriedadeWidget.routeName,
                        queryParameters: {
                          'uidPropriedade': serializeParam(
                            widget.uidPropriedade,
                            ParamType.DocumentReference,
                          ),
                          'nomePropriedade': serializeParam(
                            widget.nomePropriedade,
                            ParamType.String,
                          ),
                          'uidTecnico': serializeParam(
                            widget.uidTecnico,
                            ParamType.DocumentReference,
                          ),
                          'emailPropriedade': serializeParam(
                            widget.emailPropriedade,
                            ParamType.String,
                          ),
                          'visitaPresencial': serializeParam(
                            widget.visitaPresencial,
                            ParamType.bool,
                          ),
                          'emailTecnico': serializeParam(
                            currentUserEmail,
                            ParamType.String,
                          ),
                        }.withoutNulls,
                      );
                    },
                  ),
                ),
              ],
              centerTitle: false,
              elevation: 0.0,
            ),
            body: SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(24.0, 25.0, 0.0, 0.0),
                      child: Text(
                        'Menu de Ações',
                        textAlign: TextAlign.start,
                        style:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 12.0, 16.0, 12.0),
                      child: GridView(
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 1.0,
                        ),
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.3,
                            height: 120.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(
                                color: Color(0xFFEC3B5B),
                              ),
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(
                                    DashboardTecnicoWidget.routeName);

                                FFAppState().clearAllAnimaisProdutorCache();
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.home,
                                    color: Color(0xFFEC3B5B),
                                    size: 22.0,
                                  ),
                                  Text(
                                    'Início',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          color: Color(0xFF14181B),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation1']!),
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.3,
                            height: 120.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(
                                color: Color(0xFFEC3B5B),
                              ),
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(
                                  ListaPropriedadeWidget.routeName,
                                  queryParameters: {
                                    'visitaPresencial': serializeParam(
                                      false,
                                      ParamType.bool,
                                    ),
                                  }.withoutNulls,
                                );

                                FFAppState().clearAllAnimaisProdutorCache();
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.supervisor_account_rounded,
                                    color: Color(0xFFEC3B5B),
                                    size: 32.0,
                                  ),
                                  Text(
                                    'Trocar Produtor',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          color: Color(0xFF14181B),
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation2']!),
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.3,
                            height: 120.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(
                                color: Color(0xFFEC3B5B),
                              ),
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                if (_model.respostaNet!) {
                                  if ((FFAppState()
                                              .animaisProdutoresOffline
                                              .length ==
                                          0) &&
                                      (FFAppState()
                                              .animaisProdutoresEditados
                                              .length ==
                                          0) &&
                                      (FFAppState().acoesOffline.length == 0)) {
                                    context.pushNamed(
                                      ListaAnimaisWidget.routeName,
                                      queryParameters: {
                                        'uidPropriedade': serializeParam(
                                          widget.uidPropriedade,
                                          ParamType.DocumentReference,
                                        ),
                                        'nomePropriedade': serializeParam(
                                          widget.nomePropriedade,
                                          ParamType.String,
                                        ),
                                        'uidTecnico': serializeParam(
                                          widget.uidTecnico,
                                          ParamType.DocumentReference,
                                        ),
                                        'emailPropriedade': serializeParam(
                                          widget.emailPropriedade,
                                          ParamType.String,
                                        ),
                                        'visitaPresencial': serializeParam(
                                          widget.visitaPresencial,
                                          ParamType.bool,
                                        ),
                                        'diasDg': serializeParam(
                                          widget.diasDg,
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                    );

                                    return;
                                  } else {
                                    await showDialog(
                                      context: context,
                                      builder: (alertDialogContext) {
                                        return AlertDialog(
                                          title: Text(
                                              'Sincronize os dados primeiro!'),
                                          content: Text(
                                              'Sincronize offline com o online.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  alertDialogContext),
                                              child: Text('Ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    return;
                                  }
                                } else {
                                  context.pushNamed(
                                    ListaAnimaisWidget.routeName,
                                    queryParameters: {
                                      'uidPropriedade': serializeParam(
                                        widget.uidPropriedade,
                                        ParamType.DocumentReference,
                                      ),
                                      'nomePropriedade': serializeParam(
                                        widget.nomePropriedade,
                                        ParamType.String,
                                      ),
                                      'uidTecnico': serializeParam(
                                        widget.uidTecnico,
                                        ParamType.DocumentReference,
                                      ),
                                      'emailPropriedade': serializeParam(
                                        widget.emailPropriedade,
                                        ParamType.String,
                                      ),
                                      'visitaPresencial': serializeParam(
                                        widget.visitaPresencial,
                                        ParamType.bool,
                                      ),
                                      'diasDg': serializeParam(
                                        widget.diasDg,
                                        ParamType.String,
                                      ),
                                    }.withoutNulls,
                                  );

                                  return;
                                }
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.format_list_numbered,
                                    color: Color(0xFFEC3B5B),
                                    size: 24.0,
                                  ),
                                  Text(
                                    'Animais',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation3']!),
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.3,
                            height: 120.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(
                                color: Color(0xFFEC3B5B),
                              ),
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(
                                  ListaInseminacoesWidget.routeName,
                                  queryParameters: {
                                    'uidPropriedade': serializeParam(
                                      widget.uidPropriedade,
                                      ParamType.DocumentReference,
                                    ),
                                    'nomePropriedade': serializeParam(
                                      widget.nomePropriedade,
                                      ParamType.String,
                                    ),
                                    'uidTecnico': serializeParam(
                                      widget.uidTecnico,
                                      ParamType.DocumentReference,
                                    ),
                                    'emailPropriedade': serializeParam(
                                      widget.emailPropriedade,
                                      ParamType.String,
                                    ),
                                    'visitaPresencial': serializeParam(
                                      widget.visitaPresencial,
                                      ParamType.bool,
                                    ),
                                    'diasDg': serializeParam(
                                      widget.diasDg,
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(1.0, -1.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  1.0, -1.0),
                                              child: Card(
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                elevation: 4.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          5.0, 5.0, 5.0, 5.0),
                                                  child: Text(
                                                    _model.respostaNet!
                                                        ? inicioPropriedadeAnimaisProdutoresRecordList
                                                            .where((e) =>
                                                                ((e.grupoAnimal == 'Vacas') ||
                                                                    (e.grupoAnimal ==
                                                                        'Novilhas')) &&
                                                                ((e.status ==
                                                                        'Vazia') ||
                                                                    (e.status ==
                                                                        'Inseminada') ||
                                                                    (e.status ==
                                                                        'Inseminada PP')))
                                                            .toList()
                                                            .length
                                                            .toString()
                                                        : (inicioPropriedadeAnimaisProdutoresRecordList
                                                                    .where((e) =>
                                                                        ((e.grupoAnimal == 'Vacas') || (e.grupoAnimal == 'Novilhas')) &&
                                                                        ((e.status == 'Vazia') ||
                                                                            (e.status ==
                                                                                'Inseminada') ||
                                                                            (e.status ==
                                                                                'Inseminada PP')))
                                                                    .toList()
                                                                    .length +
                                                                FFAppState()
                                                                    .animaisProdutoresOffline
                                                                    .where((e) =>
                                                                        (e.uidTecnicoPropriedade == widget.uidPropriedade) && ((e.grupoAnimal == 'Vacas') || (e.grupoAnimal == 'Novilhas')) && ((e.status == 'Vazia') || (e.status == 'Inseminada') || (e.status == 'Inseminada PP')))
                                                                    .toList()
                                                                    .length)
                                                            .toString(),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color:
                                                              Color(0xFFEC3B5B),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0.0, -1.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.vaccines,
                                              color: Color(0xFFEC3B5B),
                                              size: 22.0,
                                            ),
                                            Text(
                                              'Inseminações',
                                              textAlign: TextAlign.center,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .labelMedium
                                                  .override(
                                                    font: GoogleFonts.readexPro(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation4']!),
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.3,
                            height: 120.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(
                                color: Color(0xFFEC3B5B),
                              ),
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(
                                  DiagnosticogestacaoWidget.routeName,
                                  queryParameters: {
                                    'uidPropriedade': serializeParam(
                                      widget.uidPropriedade,
                                      ParamType.DocumentReference,
                                    ),
                                    'nomePropriedade': serializeParam(
                                      widget.nomePropriedade,
                                      ParamType.String,
                                    ),
                                    'uidTecnico': serializeParam(
                                      widget.uidTecnico,
                                      ParamType.DocumentReference,
                                    ),
                                    'emailPropriedade': serializeParam(
                                      widget.emailPropriedade,
                                      ParamType.String,
                                    ),
                                    'visitaPresencial': serializeParam(
                                      widget.visitaPresencial,
                                      ParamType.bool,
                                    ),
                                    'diasDg': serializeParam(
                                      widget.diasDg,
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(1.0, -1.0),
                                        child: Card(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          elevation: 4.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    5.0, 5.0, 5.0, 5.0),
                                            child: Text(
                                              inicioPropriedadeAnimaisProdutoresRecordList
                                                  .where((e) =>
                                                      valueOrDefault<bool>(
                                                        (e.dtUltimaInseminacao !=
                                                                    '') &&
                                                            ((e.grupoAnimal ==
                                                                    'Vacas') ||
                                                                (e.grupoAnimal ==
                                                                    'Novilhas')) &&
                                                            ((e.status ==
                                                                    'Inseminada') ||
                                                                (e.status ==
                                                                    'Inseminada PP')) &&
                                                            (functions.converterStringParaData(
                                                                    e
                                                                        .dtUltimaInseminacao,
                                                                    widget
                                                                        .diasDg!) <=
                                                                functions
                                                                    .obterDataAtual()),
                                                        true,
                                                      ))
                                                  .toList()
                                                  .length
                                                  .toString(),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.readexPro(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: Color(0xFFEC3B5B),
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.medical_information_outlined,
                                            color: Color(0xFFEC3B5B),
                                            size: 32.0,
                                          ),
                                          Text(
                                            'Diagnóstico\nGestação',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.readexPro(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation5']!),
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.3,
                            height: 120.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(
                                color: Color(0xFFEC3B5B),
                              ),
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(
                                  AnimaisPrenhasWidget.routeName,
                                  queryParameters: {
                                    'uidPropriedade': serializeParam(
                                      widget.uidPropriedade,
                                      ParamType.DocumentReference,
                                    ),
                                    'nomePropriedade': serializeParam(
                                      widget.nomePropriedade,
                                      ParamType.String,
                                    ),
                                    'uidTecnico': serializeParam(
                                      widget.uidTecnico,
                                      ParamType.DocumentReference,
                                    ),
                                    'emailPropriedade': serializeParam(
                                      widget.emailPropriedade,
                                      ParamType.String,
                                    ),
                                    'visitaPresencial': serializeParam(
                                      widget.visitaPresencial,
                                      ParamType.bool,
                                    ),
                                    'diasDg': serializeParam(
                                      widget.diasDg,
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(1.0, -1.0),
                                        child: Card(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          elevation: 4.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    5.0, 5.0, 5.0, 5.0),
                                            child: StreamBuilder<
                                                List<AnimaisProdutoresRecord>>(
                                              stream:
                                                  queryAnimaisProdutoresRecord(
                                                parent: widget.uidTecnico,
                                                queryBuilder:
                                                    (animaisProdutoresRecord) =>
                                                        animaisProdutoresRecord
                                                            .where(
                                                  'uidTecnicoPropriedade',
                                                  isEqualTo:
                                                      widget.uidPropriedade,
                                                ),
                                              ),
                                              builder: (context, snapshot) {
                                                // Customize what your widget looks like when it's loading.
                                                if (!snapshot.hasData) {
                                                  return Center(
                                                    child: SizedBox(
                                                      width: 50.0,
                                                      height: 50.0,
                                                      child:
                                                          CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(
                                                          Color(0xFFF75E38),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                List<AnimaisProdutoresRecord>
                                                    textAnimaisProdutoresRecordList =
                                                    snapshot.data!;

                                                return Text(
                                                  _model.respostaNet!
                                                      ? inicioPropriedadeAnimaisProdutoresRecordList
                                                          .where((e) =>
                                                              (e
                                                                      .status ==
                                                                  'Prenha') &&
                                                              (e.grupoAnimal ==
                                                                  'Vacas'))
                                                          .toList()
                                                          .length
                                                          .toString()
                                                      : (FFAppState()
                                                                  .animaisProdutoresExistentes
                                                                  .where((e) =>
                                                                      (e.uidTecnicoPropriedade ==
                                                                          widget
                                                                              .uidPropriedade) &&
                                                                      (e.grupoAnimal ==
                                                                          'Vacas') &&
                                                                      (e.status ==
                                                                          'Prenha'))
                                                                  .toList()
                                                                  .length +
                                                              FFAppState()
                                                                  .animaisProdutoresOffline
                                                                  .where((e) =>
                                                                      (e.uidTecnicoPropriedade ==
                                                                          widget
                                                                              .uidPropriedade) &&
                                                                      (e.grupoAnimal ==
                                                                          'Vacas') &&
                                                                      (e.status ==
                                                                          'Prenha'))
                                                                  .toList()
                                                                  .length)
                                                          .toString(),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            Color(0xFFEC3B5B),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.monitor_heart_outlined,
                                            color: Color(0xFFEC3B5B),
                                            size: 32.0,
                                          ),
                                          Text(
                                            'Vacas Prenhas',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.readexPro(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFF14181B),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation6']!),
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.3,
                            height: 120.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(
                                color: Color(0xFFEC3B5B),
                              ),
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(
                                  SecasWidget.routeName,
                                  queryParameters: {
                                    'uidPropriedade': serializeParam(
                                      widget.uidPropriedade,
                                      ParamType.DocumentReference,
                                    ),
                                    'nomePropriedade': serializeParam(
                                      widget.nomePropriedade,
                                      ParamType.String,
                                    ),
                                    'uidTecnico': serializeParam(
                                      widget.uidTecnico,
                                      ParamType.DocumentReference,
                                    ),
                                    'emailPropriedade': serializeParam(
                                      widget.emailPropriedade,
                                      ParamType.String,
                                    ),
                                    'visitaPresencial': serializeParam(
                                      widget.visitaPresencial,
                                      ParamType.bool,
                                    ),
                                    'diasDg': serializeParam(
                                      widget.diasDg,
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(1.0, -1.0),
                                        child: Card(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          elevation: 4.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    5.0, 5.0, 5.0, 5.0),
                                            child: Text(
                                              inicioPropriedadeAnimaisProdutoresRecordList
                                                  .where((e) =>
                                                      ((e.grupoAnimal ==
                                                              'Vacas') &&
                                                          (e.status ==
                                                              'Seca')) ||
                                                      (e.status ==
                                                          'Pré Parto') ||
                                                      (e.status ==
                                                          'Descarte') ||
                                                      ((e.status == 'Vazia') &&
                                                          (e.dtInducaoLactacao !=
                                                              null)))
                                                  .toList()
                                                  .length
                                                  .toString(),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.readexPro(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: Color(0xFFEC3B5B),
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.alarm_add_sharp,
                                            color: Color(0xFFEC3B5B),
                                            size: 32.0,
                                          ),
                                          Text(
                                            'Secas',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.readexPro(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFF14181B),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation7']!),
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.3,
                            height: 120.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(
                                color: Color(0xFFEC3B5B),
                              ),
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(
                                  ExameGinecologicoWidget.routeName,
                                  queryParameters: {
                                    'uidPropriedade': serializeParam(
                                      widget.uidPropriedade,
                                      ParamType.DocumentReference,
                                    ),
                                    'nomePropriedade': serializeParam(
                                      widget.nomePropriedade,
                                      ParamType.String,
                                    ),
                                    'uidTecnico': serializeParam(
                                      widget.uidTecnico,
                                      ParamType.DocumentReference,
                                    ),
                                    'emailPropriedade': serializeParam(
                                      widget.emailPropriedade,
                                      ParamType.String,
                                    ),
                                    'visitaPresencial': serializeParam(
                                      widget.visitaPresencial,
                                      ParamType.bool,
                                    ),
                                    'diasDg': serializeParam(
                                      widget.diasDg,
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(1.0, -1.0),
                                        child: Card(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          elevation: 4.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    5.0, 5.0, 5.0, 5.0),
                                            child: Text(
                                              _model.respostaNet!
                                                  ? inicioPropriedadeAnimaisProdutoresRecordList
                                                      .where((e) =>
                                                          (e.status == 'Vazia') &&
                                                          ((e.grupoAnimal == 'Novilhas') ||
                                                              (e.grupoAnimal ==
                                                                  'Vacas')) &&
                                                          (e.dtInducaoLactacao ==
                                                              null))
                                                      .toList()
                                                      .length
                                                      .toString()
                                                  : (inicioPropriedadeAnimaisProdutoresRecordList
                                                              .where((e) =>
                                                                  (e.status == 'Vazia') &&
                                                                  ((e.grupoAnimal == 'Novilhas') ||
                                                                      (e.grupoAnimal ==
                                                                          'Vacas')) &&
                                                                  (e.dtInducaoLactacao ==
                                                                      null))
                                                              .toList()
                                                              .length +
                                                          FFAppState()
                                                              .animaisProdutoresOffline
                                                              .where((e) =>
                                                                  (e.uidTecnicoPropriedade == widget.uidPropriedade) &&
                                                                  ((e.grupoAnimal == 'Vacas') ||
                                                                      (e.grupoAnimal == 'Novilhas')) &&
                                                                  (e.status == 'Vazia') &&
                                                                  (e.dtInducaoLactacao == null))
                                                              .toList()
                                                              .length)
                                                      .toString(),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.readexPro(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: Color(0xFFEC3B5B),
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.medical_services,
                                            color: Color(0xFFEC3B5B),
                                            size: 32.0,
                                          ),
                                          Text(
                                            'Exame\nGinecológico',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.readexPro(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFF14181B),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation8']!),
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.3,
                            height: 120.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(
                                color: Color(0xFFEC3B5B),
                              ),
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(
                                  RecriacaoWidget.routeName,
                                  queryParameters: {
                                    'uidPropriedade': serializeParam(
                                      widget.uidPropriedade,
                                      ParamType.DocumentReference,
                                    ),
                                    'nomePropriedade': serializeParam(
                                      widget.nomePropriedade,
                                      ParamType.String,
                                    ),
                                    'uidTecnico': serializeParam(
                                      widget.uidTecnico,
                                      ParamType.DocumentReference,
                                    ),
                                    'emailPropriedade': serializeParam(
                                      widget.emailPropriedade,
                                      ParamType.String,
                                    ),
                                    'visitaPresencial': serializeParam(
                                      widget.visitaPresencial,
                                      ParamType.bool,
                                    ),
                                    'diasDg': serializeParam(
                                      widget.diasDg,
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(1.0, -1.0),
                                        child: Card(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          elevation: 4.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    5.0, 5.0, 5.0, 5.0),
                                            child: Text(
                                              _model.respostaNet!
                                                  ? inicioPropriedadeAnimaisProdutoresRecordList
                                                      .where((e) =>
                                                          (((e.grupoAnimal == 'Touros') && (e.liberaInseminacao == false)) ||
                                                              ((e.grupoAnimal ==
                                                                      'Novilhas') &&
                                                                  (e.dtInducaoLactacao ==
                                                                      null)) ||
                                                              (e.grupoAnimal ==
                                                                  'Bezerras') ||
                                                              (e.grupoAnimal ==
                                                                  'Bezerros')) &&
                                                          ((e.status != 'Descarte') &&
                                                              (e.status !=
                                                                  'Pré Parto')))
                                                      .toList()
                                                      .length
                                                      .toString()
                                                  : (inicioPropriedadeAnimaisProdutoresRecordList.where((e) => (((e.grupoAnimal == 'Touros') && (e.liberaInseminacao == false)) || ((e.grupoAnimal == 'Novilhas') && (e.dtInducaoLactacao == null)) || (e.grupoAnimal == 'Bezerras') || (e.grupoAnimal == 'Bezerros')) && ((e.status != 'Descarte') && (e.status != 'Pré Parto'))).toList().length +
                                                          FFAppState()
                                                              .animaisProdutoresOffline
                                                              .where((e) =>
                                                                  (e.uidTecnicoPropriedade == widget.uidPropriedade) &&
                                                                  (((e.grupoAnimal == 'Touros') && (e.liberaInseminacao == false)) ||
                                                                      ((e.grupoAnimal == 'Novilhas') && (e.dtInducaoLactacao == null)) ||
                                                                      (e.grupoAnimal == 'Bezerras') ||
                                                                      (e.grupoAnimal == 'Bezerros')) &&
                                                                  ((e.status != 'Descarte') && (e.status != 'Pré Parto')))
                                                              .toList()
                                                              .length)
                                                      .toString(),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.readexPro(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: Color(0xFFEC3B5B),
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.compare_arrows_sharp,
                                            color: Color(0xFFEC3B5B),
                                            size: 32.0,
                                          ),
                                          Text(
                                            'Recria',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.readexPro(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation9']!),
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.3,
                            height: 120.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(
                                color: Color(0xFFEC3B5B),
                              ),
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(
                                  ListacompletaWidget.routeName,
                                  queryParameters: {
                                    'uidPropriedade': serializeParam(
                                      widget.uidPropriedade,
                                      ParamType.DocumentReference,
                                    ),
                                    'nomePropriedade': serializeParam(
                                      widget.nomePropriedade,
                                      ParamType.String,
                                    ),
                                    'uidTecnico': serializeParam(
                                      widget.uidTecnico,
                                      ParamType.DocumentReference,
                                    ),
                                    'emailPropriedade': serializeParam(
                                      widget.emailPropriedade,
                                      ParamType.String,
                                    ),
                                    'visitaPresencial': serializeParam(
                                      widget.visitaPresencial,
                                      ParamType.bool,
                                    ),
                                    'diasDg': serializeParam(
                                      widget.diasDg,
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(1.0, -1.0),
                                        child: Card(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          elevation: 4.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    5.0, 5.0, 5.0, 5.0),
                                            child: Text(
                                              inicioPropriedadeAnimaisProdutoresRecordList
                                                  .where((e) =>
                                                      ((e.grupoAnimal ==
                                                              'Novilhas') ||
                                                          (e.grupoAnimal ==
                                                              'Vacas')) &&
                                                      (e.status != 'Descarte'))
                                                  .toList()
                                                  .length
                                                  .toString(),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.readexPro(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: Color(0xFFEC3B5B),
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.list_alt_sharp,
                                            color: Color(0xFFEC3B5B),
                                            size: 32.0,
                                          ),
                                          Text(
                                            'Lista completa',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.readexPro(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFF14181B),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation10']!),
                          if (_model.respostaNet ?? true)
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.3,
                              height: 120.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                borderRadius: BorderRadius.circular(24.0),
                                border: Border.all(
                                  color: Color(0xFFEC3B5B),
                                ),
                              ),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pushNamed(
                                    ReceituariosListaWidget.routeName,
                                    queryParameters: {
                                      'uidPropriedade': serializeParam(
                                        widget.uidPropriedade,
                                        ParamType.DocumentReference,
                                      ),
                                      'nomePropriedade': serializeParam(
                                        widget.nomePropriedade,
                                        ParamType.String,
                                      ),
                                      'uidTecnico': serializeParam(
                                        widget.uidTecnico,
                                        ParamType.DocumentReference,
                                      ),
                                      'emailPropriedade': serializeParam(
                                        widget.emailPropriedade,
                                        ParamType.String,
                                      ),
                                      'visitaPresencial': serializeParam(
                                        widget.visitaPresencial,
                                        ParamType.bool,
                                      ),
                                      'diasDg': serializeParam(
                                        widget.diasDg,
                                        ParamType.String,
                                      ),
                                    }.withoutNulls,
                                  );
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.summarize,
                                      color: Color(0xFFEC3B5B),
                                      size: 30.0,
                                    ),
                                    Text(
                                      'Receituário',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFF14181B),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animateOnPageLoad(animationsMap[
                                'containerOnPageLoadAnimation11']!),
                          if (_model.respostaNet ?? true)
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.3,
                              height: 120.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                borderRadius: BorderRadius.circular(24.0),
                                border: Border.all(
                                  color: Color(0xFFEC3B5B),
                                ),
                              ),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pushNamed(
                                    ResumoRebanhoWidget.routeName,
                                    queryParameters: {
                                      'uidPropriedade': serializeParam(
                                        widget.uidPropriedade,
                                        ParamType.DocumentReference,
                                      ),
                                      'nomePropriedade': serializeParam(
                                        widget.nomePropriedade,
                                        ParamType.String,
                                      ),
                                      'uidTecnico': serializeParam(
                                        widget.uidTecnico,
                                        ParamType.DocumentReference,
                                      ),
                                      'emailPropriedade': serializeParam(
                                        widget.emailPropriedade,
                                        ParamType.String,
                                      ),
                                      'visitaPresencial': serializeParam(
                                        widget.visitaPresencial,
                                        ParamType.bool,
                                      ),
                                      'diasDg': serializeParam(
                                        widget.diasDg,
                                        ParamType.String,
                                      ),
                                    }.withoutNulls,
                                  );
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.summarize_outlined,
                                      color: Color(0xFFEC3B5B),
                                      size: 30.0,
                                    ),
                                    Text(
                                      'Resumo Rebanho',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFF14181B),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animateOnPageLoad(animationsMap[
                                'containerOnPageLoadAnimation12']!),
                          if (_model.respostaNet ?? true)
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.3,
                              height: 120.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                borderRadius: BorderRadius.circular(24.0),
                                border: Border.all(
                                  color: Color(0xFFEC3B5B),
                                ),
                              ),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pushNamed(
                                    CalendarioSanitarioWidget.routeName,
                                    queryParameters: {
                                      'uidPropriedade': serializeParam(
                                        widget.uidPropriedade,
                                        ParamType.DocumentReference,
                                      ),
                                      'nomePropriedade': serializeParam(
                                        widget.nomePropriedade,
                                        ParamType.String,
                                      ),
                                      'uidTecnico': serializeParam(
                                        widget.uidTecnico,
                                        ParamType.DocumentReference,
                                      ),
                                      'emailPropriedade': serializeParam(
                                        widget.emailPropriedade,
                                        ParamType.String,
                                      ),
                                      'visitaPresencial': serializeParam(
                                        widget.visitaPresencial,
                                        ParamType.bool,
                                      ),
                                      'diasDg': serializeParam(
                                        widget.diasDg,
                                        ParamType.String,
                                      ),
                                    }.withoutNulls,
                                  );
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: Color(0xFFEC3B5B),
                                      size: 28.0,
                                    ),
                                    Text(
                                      'Calendário Sanitário',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFF14181B),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animateOnPageLoad(animationsMap[
                                'containerOnPageLoadAnimation13']!),
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.3,
                            height: 120.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(
                                color: Color(0xFFEC3B5B),
                              ),
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(
                                  IndicesZootecnicosWidget.routeName,
                                  queryParameters: {
                                    'uidPropriedade': serializeParam(
                                      widget.uidPropriedade,
                                      ParamType.DocumentReference,
                                    ),
                                    'nomePropriedade': serializeParam(
                                      widget.nomePropriedade,
                                      ParamType.String,
                                    ),
                                    'uidTecnico': serializeParam(
                                      widget.uidTecnico,
                                      ParamType.DocumentReference,
                                    ),
                                    'emailPropriedade': serializeParam(
                                      widget.emailPropriedade,
                                      ParamType.String,
                                    ),
                                    'visitaPresencial': serializeParam(
                                      widget.visitaPresencial,
                                      ParamType.bool,
                                    ),
                                    'diasDg': serializeParam(
                                      widget.diasDg,
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.folder_copy_outlined,
                                    color: Color(0xFFEC3B5B),
                                    size: 30.0,
                                  ),
                                  Text(
                                    'Indíces Zootécnicos',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          color: Color(0xFF14181B),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation14']!),
                          if (_model.respostaNet ?? true)
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.3,
                              height: 120.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                borderRadius: BorderRadius.circular(24.0),
                                border: Border.all(
                                  color: Color(0xFFEC3B5B),
                                ),
                              ),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pushNamed(
                                    RelatorioFinanceiroWidget.routeName,
                                    queryParameters: {
                                      'uidPropriedade': serializeParam(
                                        widget.uidPropriedade,
                                        ParamType.DocumentReference,
                                      ),
                                      'nomePropriedade': serializeParam(
                                        widget.nomePropriedade,
                                        ParamType.String,
                                      ),
                                      'uidTecnico': serializeParam(
                                        widget.uidTecnico,
                                        ParamType.DocumentReference,
                                      ),
                                      'emailPropriedade': serializeParam(
                                        widget.emailPropriedade,
                                        ParamType.String,
                                      ),
                                      'visitaPresencial': serializeParam(
                                        widget.visitaPresencial,
                                        ParamType.bool,
                                      ),
                                      'diasDg': serializeParam(
                                        widget.diasDg,
                                        ParamType.String,
                                      ),
                                    }.withoutNulls,
                                  );
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.attach_money_sharp,
                                      color: Color(0xFFEC3B5B),
                                      size: 30.0,
                                    ),
                                    Text(
                                      'Financeiro',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFF14181B),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animateOnPageLoad(animationsMap[
                                'containerOnPageLoadAnimation15']!),
                          if (responsiveVisibility(
                            context: context,
                            phone: false,
                            tablet: false,
                            tabletLandscape: false,
                            desktop: false,
                          ))
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.3,
                              height: 120.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                borderRadius: BorderRadius.circular(24.0),
                                border: Border.all(
                                  color: Color(0xFFEC3B5B),
                                ),
                              ),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {},
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.fileImport,
                                      color: Color(0xFFEC3B5B),
                                      size: 22.0,
                                    ),
                                    Text(
                                      'Importar animais',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFF14181B),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animateOnPageLoad(animationsMap[
                                'containerOnPageLoadAnimation16']!),
                        ],
                      ),
                    ),
                    if (!valueOrDefault<bool>(
                      _model.respostaNet,
                      true,
                    ))
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wifi_off,
                              color: Color(0xFFD50000),
                              size: 24.0,
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Sem internet! Depois sincronize os dados.',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.readexPro(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFFD50000),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (valueOrDefault<bool>(
                          _model.respostaNet,
                          false,
                        ) &&
                        ((FFAppState().animaisProdutoresOffline.length != 0) ||
                            (FFAppState().animaisProdutoresOffline.length !=
                                0) ||
                            (FFAppState().animaisProdutoresEditados.length !=
                                0) ||
                            (FFAppState().acoesOffline.length != 0)))
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
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
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Você tem ${FFAppState().animaisProdutoresOffline.length.toString()} novos animais cadastrados, ${FFAppState().animaisProdutoresEditados.where((e) => e.uidTecnicoPropriedade == widget.uidPropriedade).toList().length.toString()} animais modificados e ${FFAppState().acoesOffline.length.toString()} novas ações feitas. Deseja sincronizá-los agora?',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.readexPro(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFFD50000),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ),
                            Builder(
                              builder: (context) => FFButtonWidget(
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (dialogContext) {
                                      return Dialog(
                                        elevation: 0,
                                        insetPadding: EdgeInsets.zero,
                                        backgroundColor: Colors.transparent,
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0)
                                                .resolve(
                                                    Directionality.of(context)),
                                        child: GestureDetector(
                                          onTap: () {
                                            FocusScope.of(dialogContext)
                                                .unfocus();
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                          child: SincronizarWidget(
                                            uidTecnico: widget.uidTecnico,
                                            uidPropriedade:
                                                widget.uidPropriedade,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                text: 'Sincronizar agora',
                                icon: Icon(
                                  Icons.sync,
                                  size: 15.0,
                                ),
                                options: FFButtonOptions(
                                  height: 40.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).secondary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                  elevation: 3.0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 5.0, 0.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  var confirmDialogResponse =
                                      await showDialog<bool>(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Deseja realmente ignorar ações?'),
                                                content: Text(
                                                    'Essa ação apaga todas as ações feitas offline.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext,
                                                            false),
                                                    child: Text('Cancelar'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext,
                                                            true),
                                                    child: Text('Confirmar'),
                                                  ),
                                                ],
                                              );
                                            },
                                          ) ??
                                          false;
                                  if (confirmDialogResponse) {
                                    FFAppState().animaisProdutoresOffline = [];
                                    FFAppState().animaisProdutoresEditados = [];
                                    FFAppState().acoesOffline = [];
                                    safeSetState(() {});
                                    return;
                                  } else {
                                    return;
                                  }
                                },
                                text: 'Ignorar e apagar',
                                icon: Icon(
                                  Icons.sync,
                                  size: 15.0,
                                ),
                                options: FFButtonOptions(
                                  height: 40.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: Color(0xFFD50000),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                  elevation: 3.0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
