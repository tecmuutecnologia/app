import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/pages/tecnico/propriedade/prenhas/registro_aborto/registro_aborto_widget.dart';
import '/pages/tecnico/propriedade/prenhas/registro_aborto_existente_offline/registro_aborto_existente_offline_widget.dart';
import '/pages/tecnico/propriedade/prenhas/registro_aborto_offline/registro_aborto_offline_widget.dart';
import '/pages/tecnico/propriedade/secas/registrar_parto/registrar_parto_widget.dart';
import '/pages/tecnico/propriedade/secas/registrar_parto_existente_offline/registrar_parto_existente_offline_widget.dart';
import '/pages/tecnico/propriedade/secas/registrar_parto_induzido/registrar_parto_induzido_widget.dart';
import '/pages/tecnico/propriedade/secas/registrar_parto_induzido_existente_offline/registrar_parto_induzido_existente_offline_widget.dart';
import '/pages/tecnico/propriedade/secas/registrar_parto_induzido_offline/registrar_parto_induzido_offline_widget.dart';
import '/pages/tecnico/propriedade/secas/registrar_parto_offline/registrar_parto_offline_widget.dart';
import '/pages/tecnico/propriedade/secas/registrar_pre_parto/registrar_pre_parto_widget.dart';
import '/pages/tecnico/propriedade/secas/registrar_pre_parto_existente_offline/registrar_pre_parto_existente_offline_widget.dart';
import '/pages/tecnico/propriedade/secas/registrar_pre_parto_offline/registrar_pre_parto_offline_widget.dart';
import '/pages/tecnico/propriedade/sincronizacao/alerta_sem_internet/alerta_sem_internet_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'secas_model.dart';
export 'secas_model.dart';

class SecasWidget extends StatefulWidget {
  const SecasWidget({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.diasDg,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? diasDg;

  static String routeName = 'secas';
  static String routePath = '/secas';

  @override
  State<SecasWidget> createState() => _SecasWidgetState();
}

class _SecasWidgetState extends State<SecasWidget>
    with TickerProviderStateMixin {
  late SecasModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SecasModel());

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
        startImmediately: false,
      );
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 4,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            backgroundColor: Color(0xFFF75E38),
            automaticallyImplyLeading: false,
            actions: [],
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                        child: FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 30.0,
                          borderWidth: 1.0,
                          buttonSize: 50.0,
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          onPressed: () async {
                            context.pushNamed(
                              InicioPropriedadeWidget.routeName,
                              queryParameters: {
                                'nomePropriedade': serializeParam(
                                  widget.nomePropriedade,
                                  ParamType.String,
                                ),
                                'uidPropriedade': serializeParam(
                                  widget.uidPropriedade,
                                  ParamType.DocumentReference,
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
                        ),
                      ),
                      Text(
                        'Animais em secagem',
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              font: GoogleFonts.outfit(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .fontStyle,
                              ),
                              color: Colors.white,
                              fontSize: 22.0,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .fontStyle,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              centerTitle: true,
              expandedTitleScale: 1.0,
            ),
            elevation: 0.0,
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment(-1.0, 0),
                    child: FlutterFlowButtonTabBar(
                      useToggleButtonStyle: false,
                      isScrollable: true,
                      labelStyle:
                          FlutterFlowTheme.of(context).titleMedium.override(
                                font: GoogleFonts.readexPro(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .fontStyle,
                              ),
                      unselectedLabelStyle: TextStyle(),
                      labelColor: Colors.white,
                      unselectedLabelColor:
                          FlutterFlowTheme.of(context).secondaryText,
                      backgroundColor: Color(0xFFF75E38),
                      unselectedBackgroundColor: Color(0xFFC5C5C5),
                      borderColor: Color(0xFFEC3B5B),
                      borderWidth: 2.0,
                      borderRadius: 12.0,
                      elevation: 0.0,
                      labelPadding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      buttonMargin:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 16.0, 0.0),
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      tabs: [
                        Tab(
                          text: 'Vacas secas',
                        ),
                        Tab(
                          text: 'Pré Parto',
                        ),
                        Tab(
                          text: 'Indução Lactação',
                        ),
                        Tab(
                          text: 'Descarte',
                        ),
                      ],
                      controller: _model.tabBarController,
                      onTap: (i) async {
                        [
                          () async {},
                          () async {},
                          () async {},
                          () async {}
                        ][i]();
                      },
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _model.tabBarController,
                      children: [
                        SingleChildScrollView(
                          primary: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (_model.respostaNet ?? true)
                                StreamBuilder<List<AnimaisProdutoresRecord>>(
                                  stream: queryAnimaisProdutoresRecord(
                                    parent: widget.uidTecnico,
                                    queryBuilder: (animaisProdutoresRecord) =>
                                        animaisProdutoresRecord
                                            .where(
                                              'uidTecnicoPropriedade',
                                              isEqualTo: widget.uidPropriedade,
                                            )
                                            .where(
                                              'status',
                                              isEqualTo: 'Seca',
                                            )
                                            .where(
                                              'grupoAnimal',
                                              isEqualTo: 'Vacas',
                                            )
                                            .orderBy(
                                                'compararDtUltimaInseminacao'),
                                  ),
                                  builder: (context, snapshot) {
                                    // Customize what your widget looks like when it's loading.
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: SizedBox(
                                          width: 50.0,
                                          height: 50.0,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Color(0xFFF75E38),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    List<AnimaisProdutoresRecord>
                                        listViewOnlineAnimaisProdutoresRecordList =
                                        snapshot.data!;

                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          listViewOnlineAnimaisProdutoresRecordList
                                              .length,
                                      itemBuilder:
                                          (context, listViewOnlineIndex) {
                                        final listViewOnlineAnimaisProdutoresRecord =
                                            listViewOnlineAnimaisProdutoresRecordList[
                                                listViewOnlineIndex];
                                        return Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 8.0, 16.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                ProntuarioAnimalWidget
                                                    .routeName,
                                                queryParameters: {
                                                  'uidPropriedade':
                                                      serializeParam(
                                                    widget.uidPropriedade,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'nomePropriedade':
                                                      serializeParam(
                                                    widget.nomePropriedade,
                                                    ParamType.String,
                                                  ),
                                                  'uidTecnico': serializeParam(
                                                    widget.uidTecnico,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'emailPropriedade':
                                                      serializeParam(
                                                    widget.emailPropriedade,
                                                    ParamType.String,
                                                  ),
                                                  'uidAnimaisProdutores':
                                                      serializeParam(
                                                    listViewOnlineAnimaisProdutoresRecord
                                                        .reference,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'grupoPredominante':
                                                      serializeParam(
                                                    listViewOnlineAnimaisProdutoresRecord
                                                        .grupoAnimal,
                                                    ParamType.String,
                                                  ),
                                                  'visitaPresencial':
                                                      serializeParam(
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
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: ListView(
                                                padding: EdgeInsets.zero,
                                                primary: false,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                children: [
                                                  InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      context.pushNamed(
                                                        ProntuarioAnimalWidget
                                                            .routeName,
                                                        queryParameters: {
                                                          'uidPropriedade':
                                                              serializeParam(
                                                            widget
                                                                .uidPropriedade,
                                                            ParamType
                                                                .DocumentReference,
                                                          ),
                                                          'nomePropriedade':
                                                              serializeParam(
                                                            widget
                                                                .nomePropriedade,
                                                            ParamType.String,
                                                          ),
                                                          'uidTecnico':
                                                              serializeParam(
                                                            widget.uidTecnico,
                                                            ParamType
                                                                .DocumentReference,
                                                          ),
                                                          'emailPropriedade':
                                                              serializeParam(
                                                            widget
                                                                .emailPropriedade,
                                                            ParamType.String,
                                                          ),
                                                          'uidAnimaisProdutores':
                                                              serializeParam(
                                                            listViewOnlineAnimaisProdutoresRecord
                                                                .reference,
                                                            ParamType
                                                                .DocumentReference,
                                                          ),
                                                          'grupoPredominante':
                                                              serializeParam(
                                                            listViewOnlineAnimaisProdutoresRecord
                                                                .grupoAnimal,
                                                            ParamType.String,
                                                          ),
                                                          'visitaPresencial':
                                                              serializeParam(
                                                            widget
                                                                .visitaPresencial,
                                                            ParamType.bool,
                                                          ),
                                                          'diasDg':
                                                              serializeParam(
                                                            widget.diasDg,
                                                            ParamType.String,
                                                          ),
                                                        }.withoutNulls,
                                                      );
                                                    },
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          10.0),
                                                              child: Container(
                                                                width: 44.0,
                                                                height: 44.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: () {
                                                                    if (listViewOnlineAnimaisProdutoresRecord
                                                                            .grupoAnimal ==
                                                                        'Vacas') {
                                                                      return Color(
                                                                          0xFF048508);
                                                                    } else if (listViewOnlineAnimaisProdutoresRecord
                                                                            .grupoAnimal ==
                                                                        'Novilhas') {
                                                                      return Color(
                                                                          0xFFFF0076);
                                                                    } else {
                                                                      return Color(
                                                                          0x00000000);
                                                                    }
                                                                  }(),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                child: Text(
                                                                  () {
                                                                    if (listViewOnlineAnimaisProdutoresRecord
                                                                            .grupoAnimal ==
                                                                        'Vacas') {
                                                                      return 'VAC';
                                                                    } else if (listViewOnlineAnimaisProdutoresRecord
                                                                            .grupoAnimal ==
                                                                        'Novilhas') {
                                                                      return 'NOV';
                                                                    } else {
                                                                      return 'N/C';
                                                                    }
                                                                  }(),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            13.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              listViewOnlineAnimaisProdutoresRecord
                                                                              .nomeAnimal !=
                                                                          ''
                                                                  ? listViewOnlineAnimaisProdutoresRecord
                                                                      .nomeAnimal
                                                                  : listViewOnlineAnimaisProdutoresRecord
                                                                      .brincoAnimal
                                                                      .toString(),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLarge
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Inseminada em: ${listViewOnlineAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Pré parto prev.: ${listViewOnlineAnimaisProdutoresRecord.dtPrePartoPrevista}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Parto previsto: ${listViewOnlineAnimaisProdutoresRecord.dtPartoPrevisto}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 15.0,
                                                                0.0, 15.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      10.0,
                                                                      0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child:
                                                                    FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    await showModalBottomSheet(
                                                                      isScrollControlled:
                                                                          true,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      enableDrag:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            FocusScope.of(context).unfocus();
                                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                MediaQuery.viewInsetsOf(context),
                                                                            child:
                                                                                RegistroAbortoWidget(
                                                                              uidPropriedade: widget.uidPropriedade!,
                                                                              nomePropriedade: widget.nomePropriedade!,
                                                                              uidTecnico: widget.uidTecnico!,
                                                                              emailPropriedade: widget.emailPropriedade!,
                                                                              visitaPresencial: widget.visitaPresencial!,
                                                                              diasDg: widget.diasDg!,
                                                                              uidAnimaisProdutores: listViewOnlineAnimaisProdutoresRecord.reference,
                                                                              nomeAnimal: listViewOnlineAnimaisProdutoresRecord.nomeAnimal,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).then((value) =>
                                                                        safeSetState(
                                                                            () {}));
                                                                  },
                                                                  text:
                                                                      'Aborto',
                                                                  icon: Icon(
                                                                    Icons
                                                                        .cancel_sharp,
                                                                    size: 15.0,
                                                                  ),
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width:
                                                                        100.0,
                                                                    height:
                                                                        40.0,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: Color(
                                                                        0xFFAE0303),
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        3.0,
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      10.0,
                                                                      0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child:
                                                                    FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    await showModalBottomSheet(
                                                                      isScrollControlled:
                                                                          true,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      enableDrag:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            FocusScope.of(context).unfocus();
                                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                MediaQuery.viewInsetsOf(context),
                                                                            child:
                                                                                RegistrarPartoWidget(
                                                                              uidPropriedade: widget.uidPropriedade!,
                                                                              nomePropriedade: widget.nomePropriedade!,
                                                                              uidTecnico: widget.uidTecnico!,
                                                                              emailPropriedade: widget.emailPropriedade!,
                                                                              visitaPresencial: widget.visitaPresencial!,
                                                                              diasDg: widget.diasDg!,
                                                                              uidAnimaisProdutores: listViewOnlineAnimaisProdutoresRecord.reference,
                                                                              nomeVacaAtual: listViewOnlineAnimaisProdutoresRecord.nomeAnimal,
                                                                              nomeTourtoUltimaInseminacao: listViewOnlineAnimaisProdutoresRecord.nomeTouroUltimaInseminacao,
                                                                              brincoVacaAtual: listViewOnlineAnimaisProdutoresRecord.brincoAnimal.toString(),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).then((value) =>
                                                                        safeSetState(
                                                                            () {}));
                                                                  },
                                                                  text: 'Parto',
                                                                  icon: Icon(
                                                                    Icons
                                                                        .add_alert,
                                                                    size: 15.0,
                                                                  ),
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width:
                                                                        100.0,
                                                                    height:
                                                                        40.0,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: Color(
                                                                        0xFF048508),
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        3.0,
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child:
                                                                  FFButtonWidget(
                                                                onPressed:
                                                                    () async {
                                                                  await showModalBottomSheet(
                                                                    isScrollControlled:
                                                                        true,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    enableDrag:
                                                                        false,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          FocusScope.of(context)
                                                                              .unfocus();
                                                                          FocusManager
                                                                              .instance
                                                                              .primaryFocus
                                                                              ?.unfocus();
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              MediaQuery.viewInsetsOf(context),
                                                                          child:
                                                                              RegistrarPrePartoWidget(
                                                                            uidPropriedade:
                                                                                widget.uidPropriedade!,
                                                                            nomePropriedade:
                                                                                widget.nomePropriedade!,
                                                                            uidTecnico:
                                                                                widget.uidTecnico!,
                                                                            emailPropriedade:
                                                                                widget.emailPropriedade!,
                                                                            visitaPresencial:
                                                                                widget.visitaPresencial!,
                                                                            diasDg:
                                                                                widget.diasDg!,
                                                                            uidAnimaisProdutores:
                                                                                listViewOnlineAnimaisProdutoresRecord.reference,
                                                                            nomeAnimal:
                                                                                listViewOnlineAnimaisProdutoresRecord.nomeAnimal,
                                                                            brincoAnimal:
                                                                                listViewOnlineAnimaisProdutoresRecord.brincoAnimalOrder.toString(),
                                                                            grupoAnimal:
                                                                                listViewOnlineAnimaisProdutoresRecord.grupoAnimal,
                                                                            dtPrePartoPrevista:
                                                                                functions.converteDataStringDate(listViewOnlineAnimaisProdutoresRecord.dtPrePartoPrevista),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      safeSetState(
                                                                          () {}));
                                                                },
                                                                text:
                                                                    'Pré-parto',
                                                                icon: Icon(
                                                                  Icons.check,
                                                                  size: 15.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  width: 100.0,
                                                                  height: 40.0,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0.0),
                                                                  iconPadding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  color: Color(
                                                                      0xFF1A03E9),
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                  elevation:
                                                                      3.0,
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 1.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
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
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              if (!_model.respostaNet!)
                                Builder(
                                  builder: (context) {
                                    final vacasExistenteOffline = FFAppState()
                                        .animaisProdutoresExistentes
                                        .map((e) => e)
                                        .toList()
                                        .sortedList(
                                            keyOf: (e) =>
                                                e.compararDtUltimaInseminacao,
                                            desc: false)
                                        .toList();

                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: vacasExistenteOffline.length,
                                      itemBuilder: (context,
                                          vacasExistenteOfflineIndex) {
                                        final vacasExistenteOfflineItem =
                                            vacasExistenteOffline[
                                                vacasExistenteOfflineIndex];
                                        return Visibility(
                                          visible: (vacasExistenteOfflineItem
                                                      .uidTecnicoPropriedade ==
                                                  widget.uidPropriedade) &&
                                              (vacasExistenteOfflineItem
                                                      .grupoAnimal ==
                                                  'Vacas') &&
                                              (vacasExistenteOfflineItem
                                                      .status ==
                                                  'Seca') &&
                                              (dateTimeFormat(
                                                    "d/M/y",
                                                    vacasExistenteOfflineItem
                                                        .compararDtUltimaInseminacao,
                                                    locale: FFLocalizations.of(
                                                            context)
                                                        .languageCode,
                                                  ) !=
                                                  '31/12/2050'),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 8.0, 16.0, 0.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {},
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: ListView(
                                                  padding: EdgeInsets.zero,
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  children: [
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {},
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10.0),
                                                                child:
                                                                    Container(
                                                                  width: 44.0,
                                                                  height: 44.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: () {
                                                                      if (vacasExistenteOfflineItem
                                                                              .grupoAnimal ==
                                                                          'Vacas') {
                                                                        return Color(
                                                                            0xFF048508);
                                                                      } else if (vacasExistenteOfflineItem
                                                                              .grupoAnimal ==
                                                                          'Novilhas') {
                                                                        return Color(
                                                                            0xFFFF0076);
                                                                      } else {
                                                                        return Color(
                                                                            0x00000000);
                                                                      }
                                                                    }(),
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.0,
                                                                          0.0),
                                                                  child: Text(
                                                                    () {
                                                                      if (vacasExistenteOfflineItem
                                                                              .grupoAnimal ==
                                                                          'Vacas') {
                                                                        return 'VAC';
                                                                      } else if (vacasExistenteOfflineItem
                                                                              .grupoAnimal ==
                                                                          'Novilhas') {
                                                                        return 'NOV';
                                                                      } else {
                                                                        return 'N/C';
                                                                      }
                                                                    }(),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              13.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                () {
                                                                  if ((vacasExistenteOfflineItem.nomeAnimal !=
                                                                              '') &&
                                                                      (vacasExistenteOfflineItem
                                                                              .brincoAnimal !=
                                                                          null) &&
                                                                      (vacasExistenteOfflineItem
                                                                              .brincoAnimal !=
                                                                          -1)) {
                                                                    return '${vacasExistenteOfflineItem.nomeAnimal} - ${vacasExistenteOfflineItem.brincoAnimal.toString()}';
                                                                  } else if (vacasExistenteOfflineItem
                                                                              .nomeAnimal !=
                                                                          '') {
                                                                    return vacasExistenteOfflineItem
                                                                        .nomeAnimal;
                                                                  } else {
                                                                    return vacasExistenteOfflineItem
                                                                        .brincoAnimal
                                                                        .toString();
                                                                  }
                                                                }(),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  'Inseminada em: ${vacasExistenteOfflineItem.dtUltimaInseminacao}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  'Pré parto prev.: ${vacasExistenteOfflineItem.dtPrePartoPrevista}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  'Parto previsto: ${vacasExistenteOfflineItem.dtPartoPrevisto}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  15.0,
                                                                  0.0,
                                                                  15.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        10.0,
                                                                        0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      await showModalBottomSheet(
                                                                        isScrollControlled:
                                                                            true,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        enableDrag:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              FocusScope.of(context).unfocus();
                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: MediaQuery.viewInsetsOf(context),
                                                                              child: RegistroAbortoExistenteOfflineWidget(
                                                                                uidPropriedade: widget.uidPropriedade!,
                                                                                nomePropriedade: widget.nomePropriedade!,
                                                                                uidTecnico: widget.uidTecnico!,
                                                                                emailPropriedade: widget.emailPropriedade!,
                                                                                visitaPresencial: widget.visitaPresencial!,
                                                                                diasDg: widget.diasDg!,
                                                                                uidAnimaisProdutores: vacasExistenteOfflineItem.uidAnimal!,
                                                                                nomeAnimal: vacasExistenteOfflineItem.nomeAnimal,
                                                                                itemUidIndex: vacasExistenteOfflineItem.itemUidIndexAtual,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ).then((value) =>
                                                                          safeSetState(
                                                                              () {}));
                                                                    },
                                                                    text:
                                                                        'Aborto',
                                                                    icon: Icon(
                                                                      Icons
                                                                          .cancel_sharp,
                                                                      size:
                                                                          15.0,
                                                                    ),
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width:
                                                                          100.0,
                                                                      height:
                                                                          40.0,
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              0.0),
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: Color(
                                                                          0xFFAE0303),
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.readexPro(
                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                            ),
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                      elevation:
                                                                          3.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        10.0,
                                                                        0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      await showModalBottomSheet(
                                                                        isScrollControlled:
                                                                            true,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        enableDrag:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              FocusScope.of(context).unfocus();
                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: MediaQuery.viewInsetsOf(context),
                                                                              child: RegistrarPartoExistenteOfflineWidget(
                                                                                uidPropriedade: widget.uidPropriedade!,
                                                                                nomePropriedade: widget.nomePropriedade!,
                                                                                uidTecnico: widget.uidTecnico!,
                                                                                emailPropriedade: widget.emailPropriedade!,
                                                                                visitaPresencial: widget.visitaPresencial!,
                                                                                diasDg: widget.diasDg!,
                                                                                uidAnimaisProdutores: vacasExistenteOfflineItem.uidAnimal!,
                                                                                nomeVacaAtual: vacasExistenteOfflineItem.nomeAnimal,
                                                                                nomeTourtoUltimaInseminacao: vacasExistenteOfflineItem.nomeTouroUltimaInseminacao,
                                                                                brincoVacaAtual: vacasExistenteOfflineItem.brincoAnimal.toString(),
                                                                                itemUidIndex: vacasExistenteOfflineItem.itemUidIndexAtual,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ).then((value) =>
                                                                          safeSetState(
                                                                              () {}));
                                                                    },
                                                                    text:
                                                                        'Parto',
                                                                    icon: Icon(
                                                                      Icons
                                                                          .add_alert,
                                                                      size:
                                                                          15.0,
                                                                    ),
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width:
                                                                          100.0,
                                                                      height:
                                                                          40.0,
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              0.0),
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: Color(
                                                                          0xFF048508),
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.readexPro(
                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                            ),
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                      elevation:
                                                                          3.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child:
                                                                    FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    await showModalBottomSheet(
                                                                      isScrollControlled:
                                                                          true,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      enableDrag:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            FocusScope.of(context).unfocus();
                                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                MediaQuery.viewInsetsOf(context),
                                                                            child:
                                                                                RegistrarPrePartoExistenteOfflineWidget(
                                                                              uidPropriedade: widget.uidPropriedade!,
                                                                              nomePropriedade: widget.nomePropriedade!,
                                                                              uidTecnico: widget.uidTecnico!,
                                                                              emailPropriedade: widget.emailPropriedade!,
                                                                              visitaPresencial: widget.visitaPresencial!,
                                                                              diasDg: widget.diasDg!,
                                                                              uidAnimaisProdutores: vacasExistenteOfflineItem.uidAnimal!,
                                                                              nomeAnimal: vacasExistenteOfflineItem.nomeAnimal,
                                                                              brincoAnimal: vacasExistenteOfflineItem.brincoAnimal.toString(),
                                                                              grupoAnimal: vacasExistenteOfflineItem.grupoAnimal,
                                                                              dtPrePartoPrevista: functions.converteDataStringDate(vacasExistenteOfflineItem.dtPrePartoPrevista),
                                                                              itemUidIndex: vacasExistenteOfflineItem.itemUidIndexAtual,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).then((value) =>
                                                                        safeSetState(
                                                                            () {}));
                                                                  },
                                                                  text:
                                                                      'Pré-parto',
                                                                  icon: Icon(
                                                                    Icons.check,
                                                                    size: 15.0,
                                                                  ),
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width:
                                                                        100.0,
                                                                    height:
                                                                        40.0,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: Color(
                                                                        0xFF1A03E9),
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        3.0,
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
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
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              if (!_model.respostaNet!)
                                Builder(
                                  builder: (context) {
                                    final vacasSecasOffline = FFAppState()
                                        .animaisProdutoresOffline
                                        .map((e) => e)
                                        .toList()
                                        .sortedList(
                                            keyOf: (e) =>
                                                e.compararDtUltimaInseminacao,
                                            desc: false)
                                        .toList();

                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: vacasSecasOffline.length,
                                      itemBuilder:
                                          (context, vacasSecasOfflineIndex) {
                                        final vacasSecasOfflineItem =
                                            vacasSecasOffline[
                                                vacasSecasOfflineIndex];
                                        return Visibility(
                                          visible: (vacasSecasOfflineItem
                                                      .uidTecnicoPropriedade ==
                                                  widget.uidPropriedade) &&
                                              (vacasSecasOfflineItem
                                                      .grupoAnimal ==
                                                  'Vacas') &&
                                              (vacasSecasOfflineItem.status ==
                                                  'Seca') &&
                                              (dateTimeFormat(
                                                    "d/M/y",
                                                    vacasSecasOfflineItem
                                                        .compararDtUltimaInseminacao,
                                                    locale: FFLocalizations.of(
                                                            context)
                                                        .languageCode,
                                                  ) !=
                                                  '31/12/2050'),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 8.0, 16.0, 0.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {},
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: ListView(
                                                  padding: EdgeInsets.zero,
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  children: [
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {},
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10.0),
                                                                child:
                                                                    Container(
                                                                  width: 44.0,
                                                                  height: 44.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: () {
                                                                      if (vacasSecasOfflineItem
                                                                              .grupoAnimal ==
                                                                          'Vacas') {
                                                                        return Color(
                                                                            0xFF048508);
                                                                      } else if (vacasSecasOfflineItem
                                                                              .grupoAnimal ==
                                                                          'Novilhas') {
                                                                        return Color(
                                                                            0xFFFF0076);
                                                                      } else {
                                                                        return Color(
                                                                            0x00000000);
                                                                      }
                                                                    }(),
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.0,
                                                                          0.0),
                                                                  child: Text(
                                                                    () {
                                                                      if (vacasSecasOfflineItem
                                                                              .grupoAnimal ==
                                                                          'Vacas') {
                                                                        return 'VAC';
                                                                      } else if (vacasSecasOfflineItem
                                                                              .grupoAnimal ==
                                                                          'Novilhas') {
                                                                        return 'NOV';
                                                                      } else {
                                                                        return 'N/C';
                                                                      }
                                                                    }(),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              13.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                () {
                                                                  if ((vacasSecasOfflineItem.nomeAnimal !=
                                                                              '') &&
                                                                      (vacasSecasOfflineItem
                                                                              .brincoAnimal !=
                                                                          null) &&
                                                                      (vacasSecasOfflineItem
                                                                              .brincoAnimal !=
                                                                          -1)) {
                                                                    return '${vacasSecasOfflineItem.nomeAnimal} - ${vacasSecasOfflineItem.brincoAnimal.toString()}';
                                                                  } else if (vacasSecasOfflineItem
                                                                              .nomeAnimal !=
                                                                          '') {
                                                                    return vacasSecasOfflineItem
                                                                        .nomeAnimal;
                                                                  } else {
                                                                    return vacasSecasOfflineItem
                                                                        .brincoAnimal
                                                                        .toString();
                                                                  }
                                                                }(),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  'Inseminada em: ${vacasSecasOfflineItem.dtUltimaInseminacao}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  'Pré parto prev.: ${vacasSecasOfflineItem.dtPrePartoPrevista}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  'Parto previsto: ${vacasSecasOfflineItem.dtPartoPrevisto}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  15.0,
                                                                  0.0,
                                                                  15.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        10.0,
                                                                        0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      await showModalBottomSheet(
                                                                        isScrollControlled:
                                                                            true,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        enableDrag:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              FocusScope.of(context).unfocus();
                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: MediaQuery.viewInsetsOf(context),
                                                                              child: RegistroAbortoOfflineWidget(
                                                                                uidPropriedade: widget.uidPropriedade!,
                                                                                nomePropriedade: widget.nomePropriedade!,
                                                                                uidTecnico: widget.uidTecnico!,
                                                                                emailPropriedade: widget.emailPropriedade!,
                                                                                visitaPresencial: widget.visitaPresencial!,
                                                                                diasDg: widget.diasDg!,
                                                                                nomeAnimal: vacasSecasOfflineItem.nomeAnimal,
                                                                                itemUidIndex: vacasSecasOfflineItem.itemUidIndexAtual,
                                                                                uidAnimalOffline: vacasSecasOfflineItem.uidAnimalOffline,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ).then((value) =>
                                                                          safeSetState(
                                                                              () {}));
                                                                    },
                                                                    text:
                                                                        'Aborto',
                                                                    icon: Icon(
                                                                      Icons
                                                                          .cancel_sharp,
                                                                      size:
                                                                          15.0,
                                                                    ),
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width:
                                                                          100.0,
                                                                      height:
                                                                          40.0,
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              0.0),
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: Color(
                                                                          0xFFAE0303),
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.readexPro(
                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                            ),
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                      elevation:
                                                                          3.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        10.0,
                                                                        0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      await showModalBottomSheet(
                                                                        isScrollControlled:
                                                                            true,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        enableDrag:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              FocusScope.of(context).unfocus();
                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: MediaQuery.viewInsetsOf(context),
                                                                              child: RegistrarPartoOfflineWidget(
                                                                                uidPropriedade: widget.uidPropriedade!,
                                                                                nomePropriedade: widget.nomePropriedade!,
                                                                                uidTecnico: widget.uidTecnico!,
                                                                                emailPropriedade: widget.emailPropriedade!,
                                                                                visitaPresencial: widget.visitaPresencial!,
                                                                                diasDg: widget.diasDg!,
                                                                                nomeVacaAtual: vacasSecasOfflineItem.nomeAnimal,
                                                                                nomeTourtoUltimaInseminacao: vacasSecasOfflineItem.nomeTouroUltimaInseminacao,
                                                                                brincoVacaAtual: vacasSecasOfflineItem.brincoAnimal.toString(),
                                                                                uidAnimalOffline: vacasSecasOfflineItem.uidAnimalOffline,
                                                                                itemUidIndex: vacasSecasOfflineItem.itemUidIndexAtual,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ).then((value) =>
                                                                          safeSetState(
                                                                              () {}));
                                                                    },
                                                                    text:
                                                                        'Parto',
                                                                    icon: Icon(
                                                                      Icons
                                                                          .add_alert,
                                                                      size:
                                                                          15.0,
                                                                    ),
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width:
                                                                          100.0,
                                                                      height:
                                                                          40.0,
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              0.0),
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: Color(
                                                                          0xFF048508),
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.readexPro(
                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                            ),
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                      elevation:
                                                                          3.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child:
                                                                    FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    await showModalBottomSheet(
                                                                      isScrollControlled:
                                                                          true,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      enableDrag:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            FocusScope.of(context).unfocus();
                                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                MediaQuery.viewInsetsOf(context),
                                                                            child:
                                                                                RegistrarPrePartoOfflineWidget(
                                                                              uidPropriedade: widget.uidPropriedade!,
                                                                              nomePropriedade: widget.nomePropriedade!,
                                                                              uidTecnico: widget.uidTecnico!,
                                                                              emailPropriedade: widget.emailPropriedade!,
                                                                              visitaPresencial: widget.visitaPresencial!,
                                                                              diasDg: widget.diasDg!,
                                                                              nomeAnimal: vacasSecasOfflineItem.nomeAnimal,
                                                                              brincoAnimal: vacasSecasOfflineItem.brincoAnimal.toString(),
                                                                              grupoAnimal: vacasSecasOfflineItem.grupoAnimal,
                                                                              dtPrePartoPrevista: functions.converteDataStringDate(vacasSecasOfflineItem.dtPrePartoPrevista),
                                                                              itemUidIndex: vacasSecasOfflineItem.itemUidIndexAtual,
                                                                              uidAnimalOffline: vacasSecasOfflineItem.uidAnimalOffline,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).then((value) =>
                                                                        safeSetState(
                                                                            () {}));
                                                                  },
                                                                  text:
                                                                      'Pré-parto',
                                                                  icon: Icon(
                                                                    Icons.check,
                                                                    size: 15.0,
                                                                  ),
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width:
                                                                        100.0,
                                                                    height:
                                                                        40.0,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: Color(
                                                                        0xFF1A03E9),
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        3.0,
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
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
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          primary: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (_model.respostaNet ?? true)
                                StreamBuilder<List<AnimaisProdutoresRecord>>(
                                  stream: queryAnimaisProdutoresRecord(
                                    parent: widget.uidTecnico,
                                    queryBuilder: (animaisProdutoresRecord) =>
                                        animaisProdutoresRecord
                                            .where(
                                              'uidTecnicoPropriedade',
                                              isEqualTo: widget.uidPropriedade,
                                            )
                                            .where(
                                              'status',
                                              isEqualTo: 'Pré Parto',
                                            )
                                            .orderBy(
                                                'compararDtUltimaInseminacao'),
                                  ),
                                  builder: (context, snapshot) {
                                    // Customize what your widget looks like when it's loading.
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: SizedBox(
                                          width: 50.0,
                                          height: 50.0,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Color(0xFFF75E38),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    List<AnimaisProdutoresRecord>
                                        listViewOnlineAnimaisProdutoresRecordList =
                                        snapshot.data!;

                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          listViewOnlineAnimaisProdutoresRecordList
                                              .length,
                                      itemBuilder:
                                          (context, listViewOnlineIndex) {
                                        final listViewOnlineAnimaisProdutoresRecord =
                                            listViewOnlineAnimaisProdutoresRecordList[
                                                listViewOnlineIndex];
                                        return Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 8.0, 16.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                ProntuarioAnimalWidget
                                                    .routeName,
                                                queryParameters: {
                                                  'uidPropriedade':
                                                      serializeParam(
                                                    widget.uidPropriedade,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'nomePropriedade':
                                                      serializeParam(
                                                    widget.nomePropriedade,
                                                    ParamType.String,
                                                  ),
                                                  'uidTecnico': serializeParam(
                                                    widget.uidTecnico,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'emailPropriedade':
                                                      serializeParam(
                                                    widget.emailPropriedade,
                                                    ParamType.String,
                                                  ),
                                                  'uidAnimaisProdutores':
                                                      serializeParam(
                                                    listViewOnlineAnimaisProdutoresRecord
                                                        .reference,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'grupoPredominante':
                                                      serializeParam(
                                                    listViewOnlineAnimaisProdutoresRecord
                                                        .grupoAnimal,
                                                    ParamType.String,
                                                  ),
                                                  'visitaPresencial':
                                                      serializeParam(
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
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 10.0, 0.0, 10.0),
                                                child: ListView(
                                                  padding: EdgeInsets.zero,
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          10.0),
                                                              child: Container(
                                                                width: 44.0,
                                                                height: 44.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: () {
                                                                    if (listViewOnlineAnimaisProdutoresRecord
                                                                            .grupoAnimal ==
                                                                        'Vacas') {
                                                                      return Color(
                                                                          0xFF048508);
                                                                    } else if (listViewOnlineAnimaisProdutoresRecord
                                                                            .grupoAnimal ==
                                                                        'Novilhas') {
                                                                      return Color(
                                                                          0xFFFF0076);
                                                                    } else {
                                                                      return Color(
                                                                          0x00000000);
                                                                    }
                                                                  }(),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                child: Text(
                                                                  () {
                                                                    if (listViewOnlineAnimaisProdutoresRecord
                                                                            .grupoAnimal ==
                                                                        'Vacas') {
                                                                      return 'VAC';
                                                                    } else if (listViewOnlineAnimaisProdutoresRecord
                                                                            .grupoAnimal ==
                                                                        'Novilhas') {
                                                                      return 'NOV';
                                                                    } else {
                                                                      return 'N/C';
                                                                    }
                                                                  }(),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            13.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              listViewOnlineAnimaisProdutoresRecord
                                                                              .nomeAnimal !=
                                                                          ''
                                                                  ? listViewOnlineAnimaisProdutoresRecord
                                                                      .nomeAnimal
                                                                  : listViewOnlineAnimaisProdutoresRecord
                                                                      .brincoAnimal
                                                                      .toString(),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLarge
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Inseminada em: ${listViewOnlineAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Pré parto prev.: ${listViewOnlineAnimaisProdutoresRecord.dtPrePartoPrevista}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Parto previsto: ${listViewOnlineAnimaisProdutoresRecord.dtPartoPrevisto}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  5.0,
                                                                  0.0,
                                                                  15.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        10.0,
                                                                        0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      await showModalBottomSheet(
                                                                        isScrollControlled:
                                                                            true,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        enableDrag:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              FocusScope.of(context).unfocus();
                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: MediaQuery.viewInsetsOf(context),
                                                                              child: RegistroAbortoWidget(
                                                                                uidPropriedade: widget.uidPropriedade!,
                                                                                nomePropriedade: widget.nomePropriedade!,
                                                                                uidTecnico: widget.uidTecnico!,
                                                                                emailPropriedade: widget.emailPropriedade!,
                                                                                visitaPresencial: widget.visitaPresencial!,
                                                                                diasDg: widget.diasDg!,
                                                                                uidAnimaisProdutores: listViewOnlineAnimaisProdutoresRecord.reference,
                                                                                nomeAnimal: listViewOnlineAnimaisProdutoresRecord.nomeAnimal,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ).then((value) =>
                                                                          safeSetState(
                                                                              () {}));
                                                                    },
                                                                    text:
                                                                        'Aborto',
                                                                    icon: Icon(
                                                                      Icons
                                                                          .cancel_sharp,
                                                                      size:
                                                                          15.0,
                                                                    ),
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width:
                                                                          100.0,
                                                                      height:
                                                                          40.0,
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              0.0),
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: Color(
                                                                          0xFFAE0303),
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.readexPro(
                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                            ),
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                      elevation:
                                                                          3.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        10.0,
                                                                        0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [],
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child:
                                                                    FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    await showModalBottomSheet(
                                                                      isScrollControlled:
                                                                          true,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      enableDrag:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            FocusScope.of(context).unfocus();
                                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                MediaQuery.viewInsetsOf(context),
                                                                            child:
                                                                                RegistrarPartoWidget(
                                                                              uidPropriedade: widget.uidPropriedade!,
                                                                              nomePropriedade: widget.nomePropriedade!,
                                                                              uidTecnico: widget.uidTecnico!,
                                                                              emailPropriedade: widget.emailPropriedade!,
                                                                              visitaPresencial: widget.visitaPresencial!,
                                                                              diasDg: widget.diasDg!,
                                                                              uidAnimaisProdutores: listViewOnlineAnimaisProdutoresRecord.reference,
                                                                              nomeVacaAtual: listViewOnlineAnimaisProdutoresRecord.nomeAnimal,
                                                                              nomeTourtoUltimaInseminacao: listViewOnlineAnimaisProdutoresRecord.nomeTouroUltimaInseminacao,
                                                                              brincoVacaAtual: listViewOnlineAnimaisProdutoresRecord.brincoAnimal.toString(),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).then((value) =>
                                                                        safeSetState(
                                                                            () {}));
                                                                  },
                                                                  text: 'Parto',
                                                                  icon: Icon(
                                                                    Icons
                                                                        .add_alert,
                                                                    size: 15.0,
                                                                  ),
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width:
                                                                        100.0,
                                                                    height:
                                                                        40.0,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: Color(
                                                                        0xFF12BE24),
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        3.0,
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
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
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              if (!_model.respostaNet!)
                                Builder(
                                  builder: (context) {
                                    final animaisExistentesOffline = FFAppState()
                                        .animaisProdutoresExistentes
                                        .map((e) => e)
                                        .toList()
                                        .sortedList(
                                            keyOf: (e) =>
                                                e.compararDtUltimaInseminacao,
                                            desc: false)
                                        .toList();

                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          animaisExistentesOffline.length,
                                      itemBuilder: (context,
                                          animaisExistentesOfflineIndex) {
                                        final animaisExistentesOfflineItem =
                                            animaisExistentesOffline[
                                                animaisExistentesOfflineIndex];
                                        return Visibility(
                                          visible: (animaisExistentesOfflineItem
                                                      .uidTecnicoPropriedade ==
                                                  widget.uidPropriedade) &&
                                              (animaisExistentesOfflineItem
                                                      .status ==
                                                  'Pré Parto') &&
                                              (dateTimeFormat(
                                                    "d/M/y",
                                                    animaisExistentesOfflineItem
                                                        .compararDtUltimaInseminacao,
                                                    locale: FFLocalizations.of(
                                                            context)
                                                        .languageCode,
                                                  ) !=
                                                  '31/12/2050'),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 8.0, 16.0, 0.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                context.pushNamed(
                                                  ProntuarioAnimalWidget
                                                      .routeName,
                                                  queryParameters: {
                                                    'uidPropriedade':
                                                        serializeParam(
                                                      widget.uidPropriedade,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                    'nomePropriedade':
                                                        serializeParam(
                                                      widget.nomePropriedade,
                                                      ParamType.String,
                                                    ),
                                                    'uidTecnico':
                                                        serializeParam(
                                                      widget.uidTecnico,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                    'emailPropriedade':
                                                        serializeParam(
                                                      widget.emailPropriedade,
                                                      ParamType.String,
                                                    ),
                                                    'uidAnimaisProdutores':
                                                        serializeParam(
                                                      animaisExistentesOfflineItem
                                                          .uidAnimal,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                    'grupoPredominante':
                                                        serializeParam(
                                                      animaisExistentesOfflineItem
                                                          .grupoAnimal,
                                                      ParamType.String,
                                                    ),
                                                    'visitaPresencial':
                                                        serializeParam(
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
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 10.0, 0.0, 10.0),
                                                  child: ListView(
                                                    padding: EdgeInsets.zero,
                                                    primary: false,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10.0),
                                                                child:
                                                                    Container(
                                                                  width: 44.0,
                                                                  height: 44.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: () {
                                                                      if (animaisExistentesOfflineItem
                                                                              .grupoAnimal ==
                                                                          'Vacas') {
                                                                        return Color(
                                                                            0xFF048508);
                                                                      } else if (animaisExistentesOfflineItem
                                                                              .grupoAnimal ==
                                                                          'Novilhas') {
                                                                        return Color(
                                                                            0xFFFF0076);
                                                                      } else {
                                                                        return Color(
                                                                            0x00000000);
                                                                      }
                                                                    }(),
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.0,
                                                                          0.0),
                                                                  child: Text(
                                                                    () {
                                                                      if (animaisExistentesOfflineItem
                                                                              .grupoAnimal ==
                                                                          'Vacas') {
                                                                        return 'VAC';
                                                                      } else if (animaisExistentesOfflineItem
                                                                              .grupoAnimal ==
                                                                          'Novilhas') {
                                                                        return 'NOV';
                                                                      } else {
                                                                        return 'N/C';
                                                                      }
                                                                    }(),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              13.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                () {
                                                                  if ((animaisExistentesOfflineItem.nomeAnimal !=
                                                                              '') &&
                                                                      (animaisExistentesOfflineItem
                                                                              .brincoAnimal !=
                                                                          null) &&
                                                                      (animaisExistentesOfflineItem
                                                                              .brincoAnimal !=
                                                                          -1)) {
                                                                    return '${animaisExistentesOfflineItem.nomeAnimal} - ${animaisExistentesOfflineItem.brincoAnimal.toString()}';
                                                                  } else if (animaisExistentesOfflineItem
                                                                              .nomeAnimal !=
                                                                          '') {
                                                                    return animaisExistentesOfflineItem
                                                                        .nomeAnimal;
                                                                  } else {
                                                                    return animaisExistentesOfflineItem
                                                                        .brincoAnimal
                                                                        .toString();
                                                                  }
                                                                }(),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  'Inseminada em: ${animaisExistentesOfflineItem.dtUltimaInseminacao}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  'Pré parto prev.: ${animaisExistentesOfflineItem.dtPrePartoPrevista}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  'Parto previsto: ${animaisExistentesOfflineItem.dtPartoPrevisto}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    5.0,
                                                                    0.0,
                                                                    15.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          10.0,
                                                                          0.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child:
                                                                        FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        await showModalBottomSheet(
                                                                          isScrollControlled:
                                                                              true,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          enableDrag:
                                                                              false,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return GestureDetector(
                                                                              onTap: () {
                                                                                FocusScope.of(context).unfocus();
                                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                                              },
                                                                              child: Padding(
                                                                                padding: MediaQuery.viewInsetsOf(context),
                                                                                child: RegistroAbortoExistenteOfflineWidget(
                                                                                  uidPropriedade: widget.uidPropriedade!,
                                                                                  nomePropriedade: widget.nomePropriedade!,
                                                                                  uidTecnico: widget.uidTecnico!,
                                                                                  emailPropriedade: widget.emailPropriedade!,
                                                                                  visitaPresencial: widget.visitaPresencial!,
                                                                                  diasDg: widget.diasDg!,
                                                                                  uidAnimaisProdutores: animaisExistentesOfflineItem.uidAnimal!,
                                                                                  nomeAnimal: animaisExistentesOfflineItem.nomeAnimal,
                                                                                  itemUidIndex: animaisExistentesOfflineItem.itemUidIndexAtual,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ).then((value) =>
                                                                            safeSetState(() {}));
                                                                      },
                                                                      text:
                                                                          'Aborto',
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .cancel_sharp,
                                                                        size:
                                                                            15.0,
                                                                      ),
                                                                      options:
                                                                          FFButtonOptions(
                                                                        width:
                                                                            100.0,
                                                                        height:
                                                                            40.0,
                                                                        padding:
                                                                            EdgeInsets.all(0.0),
                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        color: Color(
                                                                            0xFFAE0303),
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .override(
                                                                              font: GoogleFonts.readexPro(
                                                                                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                              ),
                                                                              color: Colors.white,
                                                                              fontSize: 12.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                            ),
                                                                        elevation:
                                                                            3.0,
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Colors.transparent,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          10.0,
                                                                          0.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [],
                                                              ),
                                                            ),
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      await showModalBottomSheet(
                                                                        isScrollControlled:
                                                                            true,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        enableDrag:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              FocusScope.of(context).unfocus();
                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: MediaQuery.viewInsetsOf(context),
                                                                              child: RegistrarPartoExistenteOfflineWidget(
                                                                                uidPropriedade: widget.uidPropriedade!,
                                                                                nomePropriedade: widget.nomePropriedade!,
                                                                                uidTecnico: widget.uidTecnico!,
                                                                                emailPropriedade: widget.emailPropriedade!,
                                                                                visitaPresencial: widget.visitaPresencial!,
                                                                                diasDg: widget.diasDg!,
                                                                                uidAnimaisProdutores: animaisExistentesOfflineItem.uidAnimal!,
                                                                                nomeVacaAtual: animaisExistentesOfflineItem.nomeAnimal,
                                                                                nomeTourtoUltimaInseminacao: animaisExistentesOfflineItem.nomeTouroUltimaInseminacao,
                                                                                brincoVacaAtual: animaisExistentesOfflineItem.brincoAnimal.toString(),
                                                                                itemUidIndex: animaisExistentesOfflineItem.itemUidIndexAtual,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ).then((value) =>
                                                                          safeSetState(
                                                                              () {}));
                                                                    },
                                                                    text:
                                                                        'Parto',
                                                                    icon: Icon(
                                                                      Icons
                                                                          .add_alert,
                                                                      size:
                                                                          15.0,
                                                                    ),
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width:
                                                                          100.0,
                                                                      height:
                                                                          40.0,
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              0.0),
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: Color(
                                                                          0xFF12BE24),
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.readexPro(
                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                            ),
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                      elevation:
                                                                          3.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
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
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              if (!_model.respostaNet!)
                                Builder(
                                  builder: (context) {
                                    final animaisProdutoresOffline = FFAppState()
                                        .animaisProdutoresOffline
                                        .map((e) => e)
                                        .toList()
                                        .sortedList(
                                            keyOf: (e) =>
                                                e.compararDtUltimaInseminacao,
                                            desc: false)
                                        .toList();

                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          animaisProdutoresOffline.length,
                                      itemBuilder: (context,
                                          animaisProdutoresOfflineIndex) {
                                        final animaisProdutoresOfflineItem =
                                            animaisProdutoresOffline[
                                                animaisProdutoresOfflineIndex];
                                        return Visibility(
                                          visible: (animaisProdutoresOfflineItem
                                                      .uidTecnicoPropriedade ==
                                                  widget.uidPropriedade) &&
                                              (animaisProdutoresOfflineItem
                                                      .status ==
                                                  'Pré Parto') &&
                                              (dateTimeFormat(
                                                    "d/M/y",
                                                    animaisProdutoresOfflineItem
                                                        .compararDtUltimaInseminacao,
                                                    locale: FFLocalizations.of(
                                                            context)
                                                        .languageCode,
                                                  ) !=
                                                  '31/12/2050'),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 8.0, 16.0, 0.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                context.pushNamed(
                                                  ProntuarioAnimalWidget
                                                      .routeName,
                                                  queryParameters: {
                                                    'uidPropriedade':
                                                        serializeParam(
                                                      widget.uidPropriedade,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                    'nomePropriedade':
                                                        serializeParam(
                                                      widget.nomePropriedade,
                                                      ParamType.String,
                                                    ),
                                                    'uidTecnico':
                                                        serializeParam(
                                                      widget.uidTecnico,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                    'emailPropriedade':
                                                        serializeParam(
                                                      widget.emailPropriedade,
                                                      ParamType.String,
                                                    ),
                                                    'uidAnimaisProdutores':
                                                        serializeParam(
                                                      animaisProdutoresOfflineItem
                                                          .uidAnimal,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                    'grupoPredominante':
                                                        serializeParam(
                                                      animaisProdutoresOfflineItem
                                                          .grupoAnimal,
                                                      ParamType.String,
                                                    ),
                                                    'visitaPresencial':
                                                        serializeParam(
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
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 10.0, 0.0, 10.0),
                                                  child: ListView(
                                                    padding: EdgeInsets.zero,
                                                    primary: false,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10.0),
                                                                child:
                                                                    Container(
                                                                  width: 44.0,
                                                                  height: 44.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: () {
                                                                      if (animaisProdutoresOfflineItem
                                                                              .grupoAnimal ==
                                                                          'Vacas') {
                                                                        return Color(
                                                                            0xFF048508);
                                                                      } else if (animaisProdutoresOfflineItem
                                                                              .grupoAnimal ==
                                                                          'Novilhas') {
                                                                        return Color(
                                                                            0xFFFF0076);
                                                                      } else {
                                                                        return Color(
                                                                            0x00000000);
                                                                      }
                                                                    }(),
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.0,
                                                                          0.0),
                                                                  child: Text(
                                                                    () {
                                                                      if (animaisProdutoresOfflineItem
                                                                              .grupoAnimal ==
                                                                          'Vacas') {
                                                                        return 'VAC';
                                                                      } else if (animaisProdutoresOfflineItem
                                                                              .grupoAnimal ==
                                                                          'Novilhas') {
                                                                        return 'NOV';
                                                                      } else {
                                                                        return 'N/C';
                                                                      }
                                                                    }(),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              13.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                () {
                                                                  if ((animaisProdutoresOfflineItem.nomeAnimal !=
                                                                              '') &&
                                                                      (animaisProdutoresOfflineItem
                                                                              .brincoAnimal !=
                                                                          null) &&
                                                                      (animaisProdutoresOfflineItem
                                                                              .brincoAnimal !=
                                                                          -1)) {
                                                                    return '${animaisProdutoresOfflineItem.nomeAnimal} - ${animaisProdutoresOfflineItem.brincoAnimal.toString()}';
                                                                  } else if (animaisProdutoresOfflineItem
                                                                              .nomeAnimal !=
                                                                          '') {
                                                                    return animaisProdutoresOfflineItem
                                                                        .nomeAnimal;
                                                                  } else {
                                                                    return animaisProdutoresOfflineItem
                                                                        .brincoAnimal
                                                                        .toString();
                                                                  }
                                                                }(),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  'Inseminada em: ${animaisProdutoresOfflineItem.dtUltimaInseminacao}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  'Pré parto prev.: ${animaisProdutoresOfflineItem.dtPrePartoPrevista}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  'Parto previsto: ${animaisProdutoresOfflineItem.dtPartoPrevisto}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    5.0,
                                                                    0.0,
                                                                    15.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          10.0,
                                                                          0.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child:
                                                                        FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        await showModalBottomSheet(
                                                                          isScrollControlled:
                                                                              true,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          enableDrag:
                                                                              false,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return GestureDetector(
                                                                              onTap: () {
                                                                                FocusScope.of(context).unfocus();
                                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                                              },
                                                                              child: Padding(
                                                                                padding: MediaQuery.viewInsetsOf(context),
                                                                                child: RegistroAbortoOfflineWidget(
                                                                                  uidPropriedade: widget.uidPropriedade!,
                                                                                  nomePropriedade: widget.nomePropriedade!,
                                                                                  uidTecnico: widget.uidTecnico!,
                                                                                  emailPropriedade: widget.emailPropriedade!,
                                                                                  visitaPresencial: widget.visitaPresencial!,
                                                                                  diasDg: widget.diasDg!,
                                                                                  nomeAnimal: animaisProdutoresOfflineItem.nomeAnimal,
                                                                                  itemUidIndex: animaisProdutoresOfflineItem.itemUidIndexAtual,
                                                                                  uidAnimalOffline: animaisProdutoresOfflineItem.uidAnimalOffline,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ).then((value) =>
                                                                            safeSetState(() {}));
                                                                      },
                                                                      text:
                                                                          'Aborto',
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .cancel_sharp,
                                                                        size:
                                                                            15.0,
                                                                      ),
                                                                      options:
                                                                          FFButtonOptions(
                                                                        width:
                                                                            100.0,
                                                                        height:
                                                                            40.0,
                                                                        padding:
                                                                            EdgeInsets.all(0.0),
                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        color: Color(
                                                                            0xFFAE0303),
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .override(
                                                                              font: GoogleFonts.readexPro(
                                                                                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                              ),
                                                                              color: Colors.white,
                                                                              fontSize: 12.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                            ),
                                                                        elevation:
                                                                            3.0,
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Colors.transparent,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          10.0,
                                                                          0.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [],
                                                              ),
                                                            ),
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      await showModalBottomSheet(
                                                                        isScrollControlled:
                                                                            true,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        enableDrag:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              FocusScope.of(context).unfocus();
                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: MediaQuery.viewInsetsOf(context),
                                                                              child: RegistrarPartoOfflineWidget(
                                                                                uidPropriedade: widget.uidPropriedade!,
                                                                                nomePropriedade: widget.nomePropriedade!,
                                                                                uidTecnico: widget.uidTecnico!,
                                                                                emailPropriedade: widget.emailPropriedade!,
                                                                                visitaPresencial: widget.visitaPresencial!,
                                                                                diasDg: widget.diasDg!,
                                                                                nomeVacaAtual: animaisProdutoresOfflineItem.nomeAnimal,
                                                                                nomeTourtoUltimaInseminacao: animaisProdutoresOfflineItem.nomeTouroUltimaInseminacao,
                                                                                brincoVacaAtual: animaisProdutoresOfflineItem.brincoAnimal.toString(),
                                                                                uidAnimalOffline: animaisProdutoresOfflineItem.uidAnimalOffline,
                                                                                itemUidIndex: animaisProdutoresOfflineItem.itemUidIndexAtual,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ).then((value) =>
                                                                          safeSetState(
                                                                              () {}));
                                                                    },
                                                                    text:
                                                                        'Parto',
                                                                    icon: Icon(
                                                                      Icons
                                                                          .add_alert,
                                                                      size:
                                                                          15.0,
                                                                    ),
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width:
                                                                          100.0,
                                                                      height:
                                                                          40.0,
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              0.0),
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: Color(
                                                                          0xFF12BE24),
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.readexPro(
                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                            ),
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                      elevation:
                                                                          3.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
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
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          primary: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (_model.respostaNet ?? true)
                                StreamBuilder<List<AnimaisProdutoresRecord>>(
                                  stream: queryAnimaisProdutoresRecord(
                                    parent: widget.uidTecnico,
                                    queryBuilder: (animaisProdutoresRecord) =>
                                        animaisProdutoresRecord
                                            .where(
                                              'uidTecnicoPropriedade',
                                              isEqualTo: widget.uidPropriedade,
                                            )
                                            .where(
                                              'status',
                                              isEqualTo: 'Vazia',
                                            ),
                                  ),
                                  builder: (context, snapshot) {
                                    // Customize what your widget looks like when it's loading.
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: SizedBox(
                                          width: 50.0,
                                          height: 50.0,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Color(0xFFF75E38),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    List<AnimaisProdutoresRecord>
                                        listViewOnlineAnimaisProdutoresRecordList =
                                        snapshot.data!;

                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          listViewOnlineAnimaisProdutoresRecordList
                                              .length,
                                      itemBuilder:
                                          (context, listViewOnlineIndex) {
                                        final listViewOnlineAnimaisProdutoresRecord =
                                            listViewOnlineAnimaisProdutoresRecordList[
                                                listViewOnlineIndex];
                                        return Visibility(
                                          visible:
                                              listViewOnlineAnimaisProdutoresRecord
                                                      .dtInducaoLactacao !=
                                                  null,
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 8.0, 16.0, 0.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                context.pushNamed(
                                                  ProntuarioAnimalWidget
                                                      .routeName,
                                                  queryParameters: {
                                                    'uidPropriedade':
                                                        serializeParam(
                                                      widget.uidPropriedade,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                    'nomePropriedade':
                                                        serializeParam(
                                                      widget.nomePropriedade,
                                                      ParamType.String,
                                                    ),
                                                    'uidTecnico':
                                                        serializeParam(
                                                      widget.uidTecnico,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                    'emailPropriedade':
                                                        serializeParam(
                                                      widget.emailPropriedade,
                                                      ParamType.String,
                                                    ),
                                                    'uidAnimaisProdutores':
                                                        serializeParam(
                                                      listViewOnlineAnimaisProdutoresRecord
                                                          .reference,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                    'grupoPredominante':
                                                        serializeParam(
                                                      listViewOnlineAnimaisProdutoresRecord
                                                          .grupoAnimal,
                                                      ParamType.String,
                                                    ),
                                                    'visitaPresencial':
                                                        serializeParam(
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
                                              child: Container(
                                                width: double.infinity,
                                                height: 100.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: ListView(
                                                  padding: EdgeInsets.zero,
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          10.0),
                                                              child: Container(
                                                                width: 44.0,
                                                                height: 44.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: () {
                                                                    if (listViewOnlineAnimaisProdutoresRecord
                                                                            .grupoAnimal ==
                                                                        'Vacas') {
                                                                      return Color(
                                                                          0xFF048508);
                                                                    } else if (listViewOnlineAnimaisProdutoresRecord
                                                                            .grupoAnimal ==
                                                                        'Novilhas') {
                                                                      return Color(
                                                                          0xFFFF0076);
                                                                    } else {
                                                                      return Color(
                                                                          0x00000000);
                                                                    }
                                                                  }(),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                child: Text(
                                                                  () {
                                                                    if (listViewOnlineAnimaisProdutoresRecord
                                                                            .grupoAnimal ==
                                                                        'Vacas') {
                                                                      return 'VAC';
                                                                    } else if (listViewOnlineAnimaisProdutoresRecord
                                                                            .grupoAnimal ==
                                                                        'Novilhas') {
                                                                      return 'NOV';
                                                                    } else {
                                                                      return 'N/C';
                                                                    }
                                                                  }(),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            13.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      5.0,
                                                                      0.0,
                                                                      5.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                listViewOnlineAnimaisProdutoresRecord.nomeAnimal !=
                                                                            ''
                                                                    ? listViewOnlineAnimaisProdutoresRecord
                                                                        .nomeAnimal
                                                                    : listViewOnlineAnimaisProdutoresRecord
                                                                        .brincoAnimal
                                                                        .toString(),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .fontStyle,
                                                                      ),
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              Text(
                                                                'Indução lactação: ${listViewOnlineAnimaisProdutoresRecord.dtPartoPrevisto}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              FFButtonWidget(
                                                                onPressed:
                                                                    () async {
                                                                  await showModalBottomSheet(
                                                                    isScrollControlled:
                                                                        true,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    enableDrag:
                                                                        false,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          FocusScope.of(context)
                                                                              .unfocus();
                                                                          FocusManager
                                                                              .instance
                                                                              .primaryFocus
                                                                              ?.unfocus();
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              MediaQuery.viewInsetsOf(context),
                                                                          child:
                                                                              RegistrarPartoInduzidoWidget(
                                                                            uidPropriedade:
                                                                                widget.uidPropriedade!,
                                                                            nomePropriedade:
                                                                                widget.nomePropriedade!,
                                                                            uidTecnico:
                                                                                widget.uidTecnico!,
                                                                            emailPropriedade:
                                                                                widget.emailPropriedade!,
                                                                            visitaPresencial:
                                                                                widget.visitaPresencial!,
                                                                            diasDg:
                                                                                widget.diasDg!,
                                                                            uidAnimaisProdutores:
                                                                                listViewOnlineAnimaisProdutoresRecord.reference,
                                                                            nomeAnimal: listViewOnlineAnimaisProdutoresRecord.nomeAnimal != ''
                                                                                ? listViewOnlineAnimaisProdutoresRecord.nomeAnimal
                                                                                : listViewOnlineAnimaisProdutoresRecord.brincoAnimal.toString(),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      safeSetState(
                                                                          () {}));
                                                                },
                                                                text:
                                                                    'Induzir lactação',
                                                                icon: Icon(
                                                                  Icons
                                                                      .add_alert,
                                                                  size: 15.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  width: 140.0,
                                                                  height: 40.0,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0.0),
                                                                  iconPadding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  color: Color(
                                                                      0xFF12BE24),
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            10.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                  elevation:
                                                                      3.0,
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 1.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              if (!_model.respostaNet!)
                                Builder(
                                  builder: (context) {
                                    final animaisExistenteOffline = FFAppState()
                                        .animaisProdutoresExistentes
                                        .toList();

                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: animaisExistenteOffline.length,
                                      itemBuilder: (context,
                                          animaisExistenteOfflineIndex) {
                                        final animaisExistenteOfflineItem =
                                            animaisExistenteOffline[
                                                animaisExistenteOfflineIndex];
                                        return Visibility(
                                          visible: (animaisExistenteOfflineItem
                                                      .uidTecnicoPropriedade ==
                                                  widget.uidPropriedade) &&
                                              (animaisExistenteOfflineItem
                                                      .status ==
                                                  'Vazia') &&
                                              (animaisExistenteOfflineItem
                                                      .dtInducaoLactacao !=
                                                  null),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 8.0, 16.0, 0.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                context.pushNamed(
                                                  ProntuarioAnimalWidget
                                                      .routeName,
                                                  queryParameters: {
                                                    'uidPropriedade':
                                                        serializeParam(
                                                      widget.uidPropriedade,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                    'nomePropriedade':
                                                        serializeParam(
                                                      widget.nomePropriedade,
                                                      ParamType.String,
                                                    ),
                                                    'uidTecnico':
                                                        serializeParam(
                                                      widget.uidTecnico,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                    'emailPropriedade':
                                                        serializeParam(
                                                      widget.emailPropriedade,
                                                      ParamType.String,
                                                    ),
                                                    'uidAnimaisProdutores':
                                                        serializeParam(
                                                      animaisExistenteOfflineItem
                                                          .uidAnimal,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                    'grupoPredominante':
                                                        serializeParam(
                                                      animaisExistenteOfflineItem
                                                          .grupoAnimal,
                                                      ParamType.String,
                                                    ),
                                                    'visitaPresencial':
                                                        serializeParam(
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
                                              child: Container(
                                                width: double.infinity,
                                                height: 100.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: ListView(
                                                  padding: EdgeInsets.zero,
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          10.0),
                                                              child: Container(
                                                                width: 44.0,
                                                                height: 44.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: () {
                                                                    if (animaisExistenteOfflineItem
                                                                            .grupoAnimal ==
                                                                        'Vacas') {
                                                                      return Color(
                                                                          0xFF048508);
                                                                    } else if (animaisExistenteOfflineItem
                                                                            .grupoAnimal ==
                                                                        'Novilhas') {
                                                                      return Color(
                                                                          0xFFFF0076);
                                                                    } else {
                                                                      return Color(
                                                                          0x00000000);
                                                                    }
                                                                  }(),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                child: Text(
                                                                  () {
                                                                    if (animaisExistenteOfflineItem
                                                                            .grupoAnimal ==
                                                                        'Vacas') {
                                                                      return 'VAC';
                                                                    } else if (animaisExistenteOfflineItem
                                                                            .grupoAnimal ==
                                                                        'Novilhas') {
                                                                      return 'NOV';
                                                                    } else {
                                                                      return 'N/C';
                                                                    }
                                                                  }(),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            13.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      10.0,
                                                                      0.0,
                                                                      10.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                () {
                                                                  if ((animaisExistenteOfflineItem.nomeAnimal !=
                                                                              '') &&
                                                                      (animaisExistenteOfflineItem
                                                                              .brincoAnimal !=
                                                                          null) &&
                                                                      (animaisExistenteOfflineItem
                                                                              .brincoAnimal !=
                                                                          -1)) {
                                                                    return '${animaisExistenteOfflineItem.nomeAnimal} - ${animaisExistenteOfflineItem.brincoAnimal.toString()}';
                                                                  } else if (animaisExistenteOfflineItem
                                                                              .nomeAnimal !=
                                                                          '') {
                                                                    return animaisExistenteOfflineItem
                                                                        .nomeAnimal;
                                                                  } else {
                                                                    return animaisExistenteOfflineItem
                                                                        .brincoAnimal
                                                                        .toString();
                                                                  }
                                                                }(),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .fontStyle,
                                                                      ),
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  'Indução lactação: ${animaisExistenteOfflineItem.dtInducaoLactacao?.toString()}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        fontSize:
                                                                            13.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                              FFButtonWidget(
                                                                onPressed:
                                                                    () async {
                                                                  await showModalBottomSheet(
                                                                    isScrollControlled:
                                                                        true,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    enableDrag:
                                                                        false,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          FocusScope.of(context)
                                                                              .unfocus();
                                                                          FocusManager
                                                                              .instance
                                                                              .primaryFocus
                                                                              ?.unfocus();
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              MediaQuery.viewInsetsOf(context),
                                                                          child:
                                                                              RegistrarPartoInduzidoExistenteOfflineWidget(
                                                                            uidPropriedade:
                                                                                widget.uidPropriedade!,
                                                                            nomePropriedade:
                                                                                widget.nomePropriedade!,
                                                                            uidTecnico:
                                                                                widget.uidTecnico!,
                                                                            emailPropriedade:
                                                                                widget.emailPropriedade!,
                                                                            visitaPresencial:
                                                                                widget.visitaPresencial!,
                                                                            diasDg:
                                                                                widget.diasDg!,
                                                                            uidAnimaisProdutores:
                                                                                animaisExistenteOfflineItem.uidAnimal!,
                                                                            nomeAnimal:
                                                                                animaisExistenteOfflineItem.nomeAnimal,
                                                                            itemUidIndex:
                                                                                animaisExistenteOfflineIndex,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      safeSetState(
                                                                          () {}));
                                                                },
                                                                text:
                                                                    'Induzir lactação',
                                                                icon: Icon(
                                                                  Icons
                                                                      .add_alert,
                                                                  size: 15.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  width: 140.0,
                                                                  height: 40.0,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0.0),
                                                                  iconPadding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  color: Color(
                                                                      0xFF12BE24),
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            10.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                  elevation:
                                                                      3.0,
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 1.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              if (!_model.respostaNet!)
                                Builder(
                                  builder: (context) {
                                    final animaisProdutoresOfflineInducao =
                                        FFAppState()
                                            .animaisProdutoresOffline
                                            .toList();

                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: animaisProdutoresOfflineInducao
                                          .length,
                                      itemBuilder: (context,
                                          animaisProdutoresOfflineInducaoIndex) {
                                        final animaisProdutoresOfflineInducaoItem =
                                            animaisProdutoresOfflineInducao[
                                                animaisProdutoresOfflineInducaoIndex];
                                        return Visibility(
                                          visible: (animaisProdutoresOfflineInducaoItem
                                                      .uidTecnicoPropriedade ==
                                                  widget.uidPropriedade) &&
                                              (animaisProdutoresOfflineInducaoItem
                                                      .status ==
                                                  'Vazia') &&
                                              (animaisProdutoresOfflineInducaoItem
                                                      .dtInducaoLactacao !=
                                                  null),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 8.0, 16.0, 0.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {},
                                              child: Container(
                                                width: double.infinity,
                                                height: 100.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: ListView(
                                                  padding: EdgeInsets.zero,
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          10.0),
                                                              child: Container(
                                                                width: 44.0,
                                                                height: 44.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: () {
                                                                    if (animaisProdutoresOfflineInducaoItem
                                                                            .grupoAnimal ==
                                                                        'Vacas') {
                                                                      return Color(
                                                                          0xFF048508);
                                                                    } else if (animaisProdutoresOfflineInducaoItem
                                                                            .grupoAnimal ==
                                                                        'Novilhas') {
                                                                      return Color(
                                                                          0xFFFF0076);
                                                                    } else {
                                                                      return Color(
                                                                          0x00000000);
                                                                    }
                                                                  }(),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                child: Text(
                                                                  () {
                                                                    if (animaisProdutoresOfflineInducaoItem
                                                                            .grupoAnimal ==
                                                                        'Vacas') {
                                                                      return 'VAC';
                                                                    } else if (animaisProdutoresOfflineInducaoItem
                                                                            .grupoAnimal ==
                                                                        'Novilhas') {
                                                                      return 'NOV';
                                                                    } else {
                                                                      return 'N/C';
                                                                    }
                                                                  }(),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            13.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      10.0,
                                                                      0.0,
                                                                      10.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                () {
                                                                  if ((animaisProdutoresOfflineInducaoItem.nomeAnimal !=
                                                                              '') &&
                                                                      (animaisProdutoresOfflineInducaoItem
                                                                              .brincoAnimal !=
                                                                          null) &&
                                                                      (animaisProdutoresOfflineInducaoItem
                                                                              .brincoAnimal !=
                                                                          -1)) {
                                                                    return '${animaisProdutoresOfflineInducaoItem.nomeAnimal} - ${animaisProdutoresOfflineInducaoItem.brincoAnimal.toString()}';
                                                                  } else if (animaisProdutoresOfflineInducaoItem
                                                                              .nomeAnimal !=
                                                                          '') {
                                                                    return animaisProdutoresOfflineInducaoItem
                                                                        .nomeAnimal;
                                                                  } else {
                                                                    return animaisProdutoresOfflineInducaoItem
                                                                        .brincoAnimal
                                                                        .toString();
                                                                  }
                                                                }(),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .fontStyle,
                                                                      ),
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              Text(
                                                                'Indução lactação: ${animaisProdutoresOfflineInducaoItem.dtInducaoLactacao?.toString()}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              FFButtonWidget(
                                                                onPressed:
                                                                    () async {
                                                                  await showModalBottomSheet(
                                                                    isScrollControlled:
                                                                        true,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    enableDrag:
                                                                        false,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          FocusScope.of(context)
                                                                              .unfocus();
                                                                          FocusManager
                                                                              .instance
                                                                              .primaryFocus
                                                                              ?.unfocus();
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              MediaQuery.viewInsetsOf(context),
                                                                          child:
                                                                              RegistrarPartoInduzidoOfflineWidget(
                                                                            uidPropriedade:
                                                                                widget.uidPropriedade!,
                                                                            nomePropriedade:
                                                                                widget.nomePropriedade!,
                                                                            uidTecnico:
                                                                                widget.uidTecnico!,
                                                                            emailPropriedade:
                                                                                widget.emailPropriedade!,
                                                                            visitaPresencial:
                                                                                widget.visitaPresencial!,
                                                                            diasDg:
                                                                                widget.diasDg!,
                                                                            nomeAnimal:
                                                                                animaisProdutoresOfflineInducaoItem.nomeAnimal,
                                                                            itemUidIndex:
                                                                                animaisProdutoresOfflineInducaoIndex,
                                                                            uidAnimalOffline:
                                                                                animaisProdutoresOfflineInducaoItem.uidAnimalOffline,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      safeSetState(
                                                                          () {}));
                                                                },
                                                                text:
                                                                    'Induzir lactação',
                                                                icon: Icon(
                                                                  Icons
                                                                      .add_alert,
                                                                  size: 15.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  width: 140.0,
                                                                  height: 40.0,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0.0),
                                                                  iconPadding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  color: Color(
                                                                      0xFF12BE24),
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                  elevation:
                                                                      3.0,
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 1.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          primary: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (_model.respostaNet ?? true)
                                StreamBuilder<List<AnimaisProdutoresRecord>>(
                                  stream: queryAnimaisProdutoresRecord(
                                    parent: widget.uidTecnico,
                                    queryBuilder: (animaisProdutoresRecord) =>
                                        animaisProdutoresRecord
                                            .where(
                                              'uidTecnicoPropriedade',
                                              isEqualTo: widget.uidPropriedade,
                                            )
                                            .where(
                                              'status',
                                              isEqualTo: 'Descarte',
                                            ),
                                  ),
                                  builder: (context, snapshot) {
                                    // Customize what your widget looks like when it's loading.
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: SizedBox(
                                          width: 50.0,
                                          height: 50.0,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Color(0xFFF75E38),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    List<AnimaisProdutoresRecord>
                                        listViewOnlineAnimaisProdutoresRecordList =
                                        snapshot.data!;

                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          listViewOnlineAnimaisProdutoresRecordList
                                              .length,
                                      itemBuilder:
                                          (context, listViewOnlineIndex) {
                                        final listViewOnlineAnimaisProdutoresRecord =
                                            listViewOnlineAnimaisProdutoresRecordList[
                                                listViewOnlineIndex];
                                        return Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 8.0, 16.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                ProntuarioAnimalWidget
                                                    .routeName,
                                                queryParameters: {
                                                  'uidPropriedade':
                                                      serializeParam(
                                                    widget.uidPropriedade,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'nomePropriedade':
                                                      serializeParam(
                                                    widget.nomePropriedade,
                                                    ParamType.String,
                                                  ),
                                                  'uidTecnico': serializeParam(
                                                    widget.uidTecnico,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'emailPropriedade':
                                                      serializeParam(
                                                    widget.emailPropriedade,
                                                    ParamType.String,
                                                  ),
                                                  'uidAnimaisProdutores':
                                                      serializeParam(
                                                    listViewOnlineAnimaisProdutoresRecord
                                                        .reference,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'grupoPredominante':
                                                      serializeParam(
                                                    listViewOnlineAnimaisProdutoresRecord
                                                        .grupoAnimal,
                                                    ParamType.String,
                                                  ),
                                                  'visitaPresencial':
                                                      serializeParam(
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
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: ListView(
                                                padding: EdgeInsets.zero,
                                                primary: false,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: Container(
                                                              width: 44.0,
                                                              height: 44.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: () {
                                                                  if (listViewOnlineAnimaisProdutoresRecord
                                                                          .grupoAnimal ==
                                                                      'Vacas') {
                                                                    return Color(
                                                                        0xFF048508);
                                                                  } else if (listViewOnlineAnimaisProdutoresRecord
                                                                          .grupoAnimal ==
                                                                      'Novilhas') {
                                                                    return Color(
                                                                        0xFFFF0076);
                                                                  } else {
                                                                    return Color(
                                                                        0x00000000);
                                                                  }
                                                                }(),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              child: Text(
                                                                () {
                                                                  if (listViewOnlineAnimaisProdutoresRecord
                                                                          .grupoAnimal ==
                                                                      'Vacas') {
                                                                    return 'VAC';
                                                                  } else if (listViewOnlineAnimaisProdutoresRecord
                                                                          .grupoAnimal ==
                                                                      'Novilhas') {
                                                                    return 'NOV';
                                                                  } else {
                                                                    return 'N/C';
                                                                  }
                                                                }(),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            listViewOnlineAnimaisProdutoresRecord
                                                                            .nomeAnimal !=
                                                                        ''
                                                                ? listViewOnlineAnimaisProdutoresRecord
                                                                    .nomeAnimal
                                                                : listViewOnlineAnimaisProdutoresRecord
                                                                    .brincoAnimal
                                                                    .toString(),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyLarge
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        4.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              'Data do descarte: ${listViewOnlineAnimaisProdutoresRecord.dtDescarteAnimal}',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        4.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              'Motivo: ${listViewOnlineAnimaisProdutoresRecord.motivoDescarteAnimal}',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 15.0,
                                                                0.0, 15.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      10.0,
                                                                      0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child:
                                                                    FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    var confirmDialogResponse =
                                                                        await showDialog<bool>(
                                                                              context: context,
                                                                              builder: (alertDialogContext) {
                                                                                return AlertDialog(
                                                                                  title: Text('Deseja realmente restaurar  o animal?'),
                                                                                  content: Text('Ele voltará para a lista do rebanho com o status vazia.'),
                                                                                  actions: [
                                                                                    TextButton(
                                                                                      onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                      child: Text('Cancelar'),
                                                                                    ),
                                                                                    TextButton(
                                                                                      onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                      child: Text('Confirmar'),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            ) ??
                                                                            false;
                                                                    if (confirmDialogResponse) {
                                                                      await listViewOnlineAnimaisProdutoresRecord
                                                                          .reference
                                                                          .update(
                                                                              createAnimaisProdutoresRecordData(
                                                                        status:
                                                                            'Vazia',
                                                                      ));
                                                                      return;
                                                                    } else {
                                                                      return;
                                                                    }
                                                                  },
                                                                  text:
                                                                      'Restaurar',
                                                                  icon: Icon(
                                                                    Icons
                                                                        .restore,
                                                                    size: 15.0,
                                                                  ),
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width:
                                                                        100.0,
                                                                    height:
                                                                        40.0,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: Color(
                                                                        0xFF12BE24),
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        3.0,
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      10.0,
                                                                      0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [],
                                                          ),
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child:
                                                                  FFButtonWidget(
                                                                onPressed:
                                                                    () async {
                                                                  var confirmDialogResponse =
                                                                      await showDialog<
                                                                              bool>(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (alertDialogContext) {
                                                                              return AlertDialog(
                                                                                title: Text('Deseja realmente apagar o animal?'),
                                                                                content: Text('Essa ação é irreversível.'),
                                                                                actions: [
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                    child: Text('Cancelar'),
                                                                                  ),
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                    child: Text('Confirmar'),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          ) ??
                                                                          false;
                                                                  if (confirmDialogResponse) {
                                                                    await listViewOnlineAnimaisProdutoresRecord
                                                                        .reference
                                                                        .delete();
                                                                    return;
                                                                  } else {
                                                                    return;
                                                                  }
                                                                },
                                                                text:
                                                                    'Eliminar',
                                                                icon: Icon(
                                                                  Icons.clear,
                                                                  size: 15.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  width: 100.0,
                                                                  height: 40.0,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0.0),
                                                                  iconPadding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  color: Color(
                                                                      0xFFAE0303),
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                  elevation:
                                                                      3.0,
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 1.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
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
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              if (!_model.respostaNet!)
                                Builder(
                                  builder: (context) {
                                    final animaisExistentesOfflineDescarte =
                                        FFAppState()
                                            .animaisProdutoresExistentes
                                            .toList();

                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          animaisExistentesOfflineDescarte
                                              .length,
                                      itemBuilder: (context,
                                          animaisExistentesOfflineDescarteIndex) {
                                        final animaisExistentesOfflineDescarteItem =
                                            animaisExistentesOfflineDescarte[
                                                animaisExistentesOfflineDescarteIndex];
                                        return Visibility(
                                          visible: (animaisExistentesOfflineDescarteItem
                                                      .uidTecnicoPropriedade ==
                                                  widget.uidPropriedade) &&
                                              (animaisExistentesOfflineDescarteItem
                                                      .status ==
                                                  'Descarte'),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 8.0, 16.0, 0.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                context.pushNamed(
                                                  ProntuarioAnimalWidget
                                                      .routeName,
                                                  queryParameters: {
                                                    'uidPropriedade':
                                                        serializeParam(
                                                      widget.uidPropriedade,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                    'nomePropriedade':
                                                        serializeParam(
                                                      widget.nomePropriedade,
                                                      ParamType.String,
                                                    ),
                                                    'uidTecnico':
                                                        serializeParam(
                                                      widget.uidTecnico,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                    'emailPropriedade':
                                                        serializeParam(
                                                      widget.emailPropriedade,
                                                      ParamType.String,
                                                    ),
                                                    'uidAnimaisProdutores':
                                                        serializeParam(
                                                      animaisExistentesOfflineDescarteItem
                                                          .uidAnimal,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                    'grupoPredominante':
                                                        serializeParam(
                                                      animaisExistentesOfflineDescarteItem
                                                          .grupoAnimal,
                                                      ParamType.String,
                                                    ),
                                                    'visitaPresencial':
                                                        serializeParam(
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
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: ListView(
                                                  padding: EdgeInsets.zero,
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          10.0),
                                                              child: Container(
                                                                width: 44.0,
                                                                height: 44.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: () {
                                                                    if (animaisExistentesOfflineDescarteItem
                                                                            .grupoAnimal ==
                                                                        'Vacas') {
                                                                      return Color(
                                                                          0xFF048508);
                                                                    } else if (animaisExistentesOfflineDescarteItem
                                                                            .grupoAnimal ==
                                                                        'Novilhas') {
                                                                      return Color(
                                                                          0xFFFF0076);
                                                                    } else {
                                                                      return Color(
                                                                          0x00000000);
                                                                    }
                                                                  }(),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                child: Text(
                                                                  () {
                                                                    if (animaisExistentesOfflineDescarteItem
                                                                            .grupoAnimal ==
                                                                        'Vacas') {
                                                                      return 'VAC';
                                                                    } else if (animaisExistentesOfflineDescarteItem
                                                                            .grupoAnimal ==
                                                                        'Novilhas') {
                                                                      return 'NOV';
                                                                    } else {
                                                                      return 'N/C';
                                                                    }
                                                                  }(),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            13.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              () {
                                                                if ((animaisExistentesOfflineDescarteItem.nomeAnimal !=
                                                                            '') &&
                                                                    (animaisExistentesOfflineDescarteItem
                                                                            .brincoAnimal !=
                                                                        null) &&
                                                                    (animaisExistentesOfflineDescarteItem
                                                                            .brincoAnimal !=
                                                                        -1)) {
                                                                  return '${animaisExistentesOfflineDescarteItem.nomeAnimal} - ${animaisExistentesOfflineDescarteItem.brincoAnimal.toString()}';
                                                                } else if (animaisExistentesOfflineDescarteItem
                                                                            .nomeAnimal !=
                                                                        '') {
                                                                  return animaisExistentesOfflineDescarteItem
                                                                      .nomeAnimal;
                                                                } else {
                                                                  return animaisExistentesOfflineDescarteItem
                                                                      .brincoAnimal
                                                                      .toString();
                                                                }
                                                              }(),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLarge
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Data do descarte: ${animaisExistentesOfflineDescarteItem.dtDescarteAnimal}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Motivo: ${animaisExistentesOfflineDescarteItem.motivoDescarteAnimal}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  15.0,
                                                                  0.0,
                                                                  15.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        10.0,
                                                                        0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      var confirmDialogResponse = await showDialog<
                                                                              bool>(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (alertDialogContext) {
                                                                              return AlertDialog(
                                                                                title: Text('Deseja realmente restaurar  o animal?'),
                                                                                content: Text('Ele voltará para a lista do rebanho com o status vazia.'),
                                                                                actions: [
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                    child: Text('Cancelar'),
                                                                                  ),
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                    child: Text('Confirmar'),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          ) ??
                                                                          false;
                                                                      if (confirmDialogResponse) {
                                                                        FFAppState()
                                                                            .updateAnimaisProdutoresExistentesAtIndex(
                                                                          animaisExistentesOfflineDescarteIndex,
                                                                          (e) => e
                                                                            ..status =
                                                                                'Vazia',
                                                                        );
                                                                        safeSetState(
                                                                            () {});
                                                                        FFAppState()
                                                                            .addToAnimaisProdutoresEditados(AnimaisProdutoresStruct(
                                                                          uidTecnicoPropriedade: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.uidTecnicoPropriedade,
                                                                          nomeAnimal: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.nomeAnimal,
                                                                          racaAnimal: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.racaAnimal,
                                                                          pesoAnimal: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.pesoAnimal,
                                                                          dtNascimento: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.dtNascimento,
                                                                          touro: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.touro,
                                                                          vaca: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.vaca,
                                                                          status:
                                                                              'Vazia',
                                                                          grupoAnimal: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.grupoAnimal,
                                                                          dtUltimaInseminacao: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.dtUltimaInseminacao,
                                                                          dtUltimoParto: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.dtUltimoParto,
                                                                          liberaInseminacao: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.liberaInseminacao,
                                                                          dtPartoPrevisto: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.dtPartoPrevisto,
                                                                          dtSecPrevista: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.dtSecPrevista,
                                                                          dtPrePartoPrevista: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.dtPrePartoPrevista,
                                                                          dtPP: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.dtPP,
                                                                          dtDgMais: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.dtDgMais,
                                                                          dtDgMenos: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.dtDgMenos,
                                                                          dtAborto: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.dtAborto,
                                                                          dtSecagem: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.dtSecagem,
                                                                          dtUltimoPP: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.dtUltimoPP,
                                                                          nomeTouroUltimaInseminacao: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.nomeTouroUltimaInseminacao,
                                                                          totalInseminacoes: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.totalInseminacoes,
                                                                          totalPartos: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.totalPartos,
                                                                          dtPreParto: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.dtPreParto,
                                                                          motivoDescarteAnimal: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.motivoDescarteAnimal,
                                                                          dtDescarteAnimal: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.dtDescarteAnimal,
                                                                          dtUltimaAcao: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.dtUltimaAcao,
                                                                          compararDtUltimaInseminacao: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.compararDtUltimaInseminacao,
                                                                          nomeBrincoConcat: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.nomeBrincoConcat,
                                                                          idGrupoAnimal: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.idGrupoAnimal,
                                                                          dtUltimoPartoContingencia: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.dtUltimoPartoContingencia,
                                                                          idStatusAnimal: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.idStatusAnimal,
                                                                          dtInducaoLactacao: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.dtInducaoLactacao,
                                                                          dtDesmame: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.dtDesmame,
                                                                          brincoAnimal: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.brincoAnimal,
                                                                          brincoAnimalOrder: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.brincoAnimalOrder,
                                                                          uidAnimal: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.uidAnimal,
                                                                          uidAnimalOffline: FFAppState()
                                                                              .animaisProdutoresExistentes
                                                                              .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                              ?.uidAnimalOffline,
                                                                        ));
                                                                        safeSetState(
                                                                            () {});
                                                                        Navigator.pop(
                                                                            context);
                                                                        return;
                                                                      } else {
                                                                        Navigator.pop(
                                                                            context);
                                                                      }
                                                                    },
                                                                    text:
                                                                        'Restaurar',
                                                                    icon: Icon(
                                                                      Icons
                                                                          .restore,
                                                                      size:
                                                                          15.0,
                                                                    ),
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width:
                                                                          100.0,
                                                                      height:
                                                                          40.0,
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              0.0),
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: Color(
                                                                          0xFF12BE24),
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.readexPro(
                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                            ),
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                      elevation:
                                                                          3.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        10.0,
                                                                        0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [],
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child:
                                                                    FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    var confirmDialogResponse =
                                                                        await showDialog<bool>(
                                                                              context: context,
                                                                              builder: (alertDialogContext) {
                                                                                return AlertDialog(
                                                                                  title: Text('Deseja realmente apagar o animal?'),
                                                                                  content: Text('Essa ação é irreversível.'),
                                                                                  actions: [
                                                                                    TextButton(
                                                                                      onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                      child: Text('Cancelar'),
                                                                                    ),
                                                                                    TextButton(
                                                                                      onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                      child: Text('Confirmar'),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            ) ??
                                                                            false;
                                                                    if (confirmDialogResponse) {
                                                                      FFAppState()
                                                                          .addToAnimaisApagadosExistentesOffline(
                                                                              AnimaisApagadosExistentesOfflineStruct(
                                                                        uidAnimal:
                                                                            animaisExistentesOfflineDescarteItem.uidAnimal,
                                                                        uidTecnicoPropriedade:
                                                                            widget.uidPropriedade,
                                                                      ));
                                                                      safeSetState(
                                                                          () {});
                                                                      FFAppState()
                                                                          .removeAtIndexFromAnimaisProdutoresExistentes(
                                                                              animaisExistentesOfflineDescarteIndex);
                                                                      safeSetState(
                                                                          () {});
                                                                      Navigator.pop(
                                                                          context);
                                                                      return;
                                                                    } else {
                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  },
                                                                  text:
                                                                      'Eliminar',
                                                                  icon: Icon(
                                                                    Icons.clear,
                                                                    size: 15.0,
                                                                  ),
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width:
                                                                        100.0,
                                                                    height:
                                                                        40.0,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: Color(
                                                                        0xFFAE0303),
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        3.0,
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
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
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              if (!_model.respostaNet!)
                                Builder(
                                  builder: (context) {
                                    final animaisProdutoresOfflineDescarte =
                                        FFAppState()
                                            .animaisProdutoresOffline
                                            .toList();

                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          animaisProdutoresOfflineDescarte
                                              .length,
                                      itemBuilder: (context,
                                          animaisProdutoresOfflineDescarteIndex) {
                                        final animaisProdutoresOfflineDescarteItem =
                                            animaisProdutoresOfflineDescarte[
                                                animaisProdutoresOfflineDescarteIndex];
                                        return Visibility(
                                          visible: (animaisProdutoresOfflineDescarteItem
                                                      .uidTecnicoPropriedade ==
                                                  widget.uidPropriedade) &&
                                              (animaisProdutoresOfflineDescarteItem
                                                      .status ==
                                                  'Descarte'),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 8.0, 16.0, 0.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {},
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: ListView(
                                                  padding: EdgeInsets.zero,
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          10.0),
                                                              child: Container(
                                                                width: 44.0,
                                                                height: 44.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: () {
                                                                    if (animaisProdutoresOfflineDescarteItem
                                                                            .grupoAnimal ==
                                                                        'Vacas') {
                                                                      return Color(
                                                                          0xFF048508);
                                                                    } else if (animaisProdutoresOfflineDescarteItem
                                                                            .grupoAnimal ==
                                                                        'Novilhas') {
                                                                      return Color(
                                                                          0xFFFF0076);
                                                                    } else {
                                                                      return Color(
                                                                          0x00000000);
                                                                    }
                                                                  }(),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                child: Text(
                                                                  () {
                                                                    if (animaisProdutoresOfflineDescarteItem
                                                                            .grupoAnimal ==
                                                                        'Vacas') {
                                                                      return 'VAC';
                                                                    } else if (animaisProdutoresOfflineDescarteItem
                                                                            .grupoAnimal ==
                                                                        'Novilhas') {
                                                                      return 'NOV';
                                                                    } else {
                                                                      return 'N/C';
                                                                    }
                                                                  }(),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            13.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              () {
                                                                if ((animaisProdutoresOfflineDescarteItem.nomeAnimal !=
                                                                            '') &&
                                                                    (animaisProdutoresOfflineDescarteItem
                                                                            .brincoAnimal !=
                                                                        null) &&
                                                                    (animaisProdutoresOfflineDescarteItem
                                                                            .brincoAnimal !=
                                                                        -1)) {
                                                                  return '${animaisProdutoresOfflineDescarteItem.nomeAnimal} - ${animaisProdutoresOfflineDescarteItem.brincoAnimal.toString()}';
                                                                } else if (animaisProdutoresOfflineDescarteItem
                                                                            .nomeAnimal !=
                                                                        '') {
                                                                  return animaisProdutoresOfflineDescarteItem
                                                                      .nomeAnimal;
                                                                } else {
                                                                  return animaisProdutoresOfflineDescarteItem
                                                                      .brincoAnimal
                                                                      .toString();
                                                                }
                                                              }(),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLarge
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Data do descarte: ${animaisProdutoresOfflineDescarteItem.dtDescarteAnimal}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Motivo: ${animaisProdutoresOfflineDescarteItem.motivoDescarteAnimal}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  15.0,
                                                                  0.0,
                                                                  15.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        10.0,
                                                                        0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      var confirmDialogResponse = await showDialog<
                                                                              bool>(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (alertDialogContext) {
                                                                              return AlertDialog(
                                                                                title: Text('Deseja realmente restaurar  o animal?'),
                                                                                content: Text('Ele voltará para a lista do rebanho com o status vazia.'),
                                                                                actions: [
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                    child: Text('Cancelar'),
                                                                                  ),
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                    child: Text('Confirmar'),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          ) ??
                                                                          false;
                                                                      if (confirmDialogResponse) {
                                                                        FFAppState()
                                                                            .updateAnimaisProdutoresOfflineAtIndex(
                                                                          animaisProdutoresOfflineDescarteIndex,
                                                                          (e) => e
                                                                            ..status =
                                                                                'Vazia',
                                                                        );
                                                                        safeSetState(
                                                                            () {});
                                                                        Navigator.pop(
                                                                            context);
                                                                        return;
                                                                      } else {
                                                                        Navigator.pop(
                                                                            context);
                                                                      }
                                                                    },
                                                                    text:
                                                                        'Restaurar',
                                                                    icon: Icon(
                                                                      Icons
                                                                          .restore,
                                                                      size:
                                                                          15.0,
                                                                    ),
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width:
                                                                          100.0,
                                                                      height:
                                                                          40.0,
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              0.0),
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: Color(
                                                                          0xFF12BE24),
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.readexPro(
                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                            ),
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                      elevation:
                                                                          3.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        10.0,
                                                                        0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [],
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child:
                                                                    FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    var confirmDialogResponse =
                                                                        await showDialog<bool>(
                                                                              context: context,
                                                                              builder: (alertDialogContext) {
                                                                                return AlertDialog(
                                                                                  title: Text('Deseja realmente apagar o animal?'),
                                                                                  content: Text('Essa ação é irreversível.'),
                                                                                  actions: [
                                                                                    TextButton(
                                                                                      onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                      child: Text('Cancelar'),
                                                                                    ),
                                                                                    TextButton(
                                                                                      onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                      child: Text('Confirmar'),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            ) ??
                                                                            false;
                                                                    if (confirmDialogResponse) {
                                                                      FFAppState()
                                                                          .removeAtIndexFromAnimaisProdutoresOffline(
                                                                              animaisProdutoresOfflineDescarteIndex);
                                                                      safeSetState(
                                                                          () {});
                                                                      Navigator.pop(
                                                                          context);
                                                                      return;
                                                                    } else {
                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  },
                                                                  text:
                                                                      'Eliminar',
                                                                  icon: Icon(
                                                                    Icons.clear,
                                                                    size: 15.0,
                                                                  ),
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width:
                                                                        100.0,
                                                                    height:
                                                                        40.0,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: Color(
                                                                        0xFFAE0303),
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        3.0,
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
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
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
