import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/pages/tecnico/propriedade/dignostico_gestacao/confirma_pp/confirma_pp_widget.dart';
import '/pages/tecnico/propriedade/dignostico_gestacao/confirma_pp_existente_offline/confirma_pp_existente_offline_widget.dart';
import '/pages/tecnico/propriedade/dignostico_gestacao/confirma_pp_offline/confirma_pp_offline_widget.dart';
import '/pages/tecnico/propriedade/dignostico_gestacao/dg_mais/dg_mais_widget.dart';
import '/pages/tecnico/propriedade/dignostico_gestacao/dg_mais_existente_offline/dg_mais_existente_offline_widget.dart';
import '/pages/tecnico/propriedade/dignostico_gestacao/dg_mais_offline/dg_mais_offline_widget.dart';
import '/pages/tecnico/propriedade/dignostico_gestacao/dg_menos/dg_menos_widget.dart';
import '/pages/tecnico/propriedade/dignostico_gestacao/dg_menos_existente_offline/dg_menos_existente_offline_widget.dart';
import '/pages/tecnico/propriedade/dignostico_gestacao/dg_menos_offline/dg_menos_offline_widget.dart';
import '/pages/tecnico/propriedade/sincronizacao/alerta_sem_internet/alerta_sem_internet_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'diagnosticogestacao_model.dart';
export 'diagnosticogestacao_model.dart';

class DiagnosticogestacaoWidget extends StatefulWidget {
  const DiagnosticogestacaoWidget({
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

  static String routeName = 'diagnosticogestacao';
  static String routePath = '/diagnosticogestacao';

  @override
  State<DiagnosticogestacaoWidget> createState() =>
      _DiagnosticogestacaoWidgetState();
}

class _DiagnosticogestacaoWidgetState extends State<DiagnosticogestacaoWidget> {
  late DiagnosticogestacaoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DiagnosticogestacaoModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.instantTimer = InstantTimer.periodic(
        duration: Duration(milliseconds: 300),
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
            backgroundColor:
                (_model.respostaNet ?? true) ? Color(0xFFF75E38) : Color(0xFFF2886E),
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
                        'Diagnóstico de gestação',
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
        body: SingleChildScrollView(
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (_model.respostaNet == true)
                StreamBuilder<List<AnimaisProdutoresRecord>>(
                  stream: queryAnimaisProdutoresRecord(
                    parent: widget.uidTecnico,
                    queryBuilder: (animaisProdutoresRecord) =>
                        animaisProdutoresRecord
                            .where(
                              'uidTecnicoPropriedade',
                              isEqualTo: widget.uidPropriedade,
                            )
                            .orderBy('nomeAnimal')
                            .orderBy('brincoAnimal'),
                  ),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
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
                          listViewOnlineAnimaisProdutoresRecordList.length,
                      itemBuilder: (context, listViewOnlineIndex) {
                        final listViewOnlineAnimaisProdutoresRecord =
                            listViewOnlineAnimaisProdutoresRecordList[
                                listViewOnlineIndex];
                        return Visibility(
                          visible: valueOrDefault<bool>(
                            (listViewOnlineAnimaisProdutoresRecord
                                            .dtUltimaInseminacao !=
                                        '') &&
                                ((listViewOnlineAnimaisProdutoresRecord
                                            .grupoAnimal ==
                                        'Vacas') ||
                                    (listViewOnlineAnimaisProdutoresRecord
                                            .grupoAnimal ==
                                        'Novilhas')) &&
                                ((listViewOnlineAnimaisProdutoresRecord.status ==
                                        'Inseminada') ||
                                    (listViewOnlineAnimaisProdutoresRecord
                                            .status ==
                                        'Inseminada PP')) &&
                                (functions.converterStringParaData(
                                        listViewOnlineAnimaisProdutoresRecord
                                            .dtUltimaInseminacao,
                                        widget.diasDg!) <=
                                    functions.obterDataAtual()),
                            true,
                          ),
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 1.0),
                              child: Container(
                                width: double.infinity,
                                height: 180.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 0.0,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      offset: Offset(
                                        0.0,
                                        1.0,
                                      ),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(0.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 12.0, 16.0, 12.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed(
                                        ProntuarioAnimalWidget.routeName,
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
                                          'uidAnimaisProdutores':
                                              serializeParam(
                                            listViewOnlineAnimaisProdutoresRecord
                                                .reference,
                                            ParamType.DocumentReference,
                                          ),
                                          'grupoPredominante': serializeParam(
                                            listViewOnlineAnimaisProdutoresRecord
                                                .grupoAnimal,
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
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            color: () {
                                              if (listViewOnlineAnimaisProdutoresRecord
                                                      .grupoAnimal ==
                                                  'Vacas') {
                                                return Color(0xFF048508);
                                              } else if (listViewOnlineAnimaisProdutoresRecord
                                                      .grupoAnimal ==
                                                  'Novilhas') {
                                                return Color(0xFFFF0076);
                                              } else {
                                                return Color(0x00000000);
                                              }
                                            }(),
                                            shape: BoxShape.circle,
                                          ),
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
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
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  font: GoogleFonts.readexPro(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontStyle,
                                                  ),
                                                  color: Colors.white,
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 0.0, 0.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    () {
                                                      if ((listViewOnlineAnimaisProdutoresRecord
                                                                      .nomeAnimal !=
                                                                  '') &&
                                                          (listViewOnlineAnimaisProdutoresRecord
                                                                  .brincoAnimal !=
                                                              null) &&
                                                          (listViewOnlineAnimaisProdutoresRecord
                                                                  .brincoAnimal !=
                                                              -1)) {
                                                        return '${listViewOnlineAnimaisProdutoresRecord.nomeAnimal} - ${listViewOnlineAnimaisProdutoresRecord.brincoAnimal.toString()}';
                                                      } else if (listViewOnlineAnimaisProdutoresRecord
                                                                  .nomeAnimal !=
                                                              '') {
                                                        return listViewOnlineAnimaisProdutoresRecord
                                                            .nomeAnimal;
                                                      } else {
                                                        return listViewOnlineAnimaisProdutoresRecord
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
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'Touro: ${listViewOnlineAnimaisProdutoresRecord.nomeTouroUltimaInseminacao}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'Inseminada em: ${listViewOnlineAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
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
                                                        child: FFButtonWidget(
                                                          onPressed: ((listViewOnlineAnimaisProdutoresRecord
                                                                          .status !=
                                                                      'Inseminada PP') &&
                                                                  (listViewOnlineAnimaisProdutoresRecord
                                                                              .dtPP ==
                                                                          ''))
                                                              ? null
                                                              : () async {
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
                                                                              DgMaisWidget(
                                                                            uidPropriedade:
                                                                                widget.uidPropriedade!,
                                                                            nomePropriedade:
                                                                                widget.nomePropriedade!,
                                                                            uidTecnico:
                                                                                widget.uidTecnico!,
                                                                            emailPropriedade:
                                                                                widget.emailPropriedade!,
                                                                            uidAnimaisProdutores:
                                                                                listViewOnlineAnimaisProdutoresRecord.reference,
                                                                            grupoPredominante:
                                                                                listViewOnlineAnimaisProdutoresRecord.grupoAnimal,
                                                                            nomeAnimal:
                                                                                listViewOnlineAnimaisProdutoresRecord.nomeAnimal,
                                                                            visitaPresencial:
                                                                                widget.visitaPresencial!,
                                                                            diasDg:
                                                                                widget.diasDg!,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      safeSetState(
                                                                          () {}));
                                                                },
                                                          text: 'DG +',
                                                          icon: Icon(
                                                            Icons.check_circle,
                                                            size: 15.0,
                                                          ),
                                                          options:
                                                              FFButtonOptions(
                                                            width: 80.0,
                                                            height: 40.0,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0.0),
                                                            iconPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            color: Color(
                                                                0xFF048508),
                                                            textStyle:
                                                                FlutterFlowTheme.of(
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
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontStyle,
                                                                    ),
                                                            elevation: 3.0,
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
                                                            disabledColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: FFButtonWidget(
                                                          onPressed: () async {
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              enableDrag: false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                    FocusManager
                                                                        .instance
                                                                        .primaryFocus
                                                                        ?.unfocus();
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: MediaQuery
                                                                        .viewInsetsOf(
                                                                            context),
                                                                    child:
                                                                        ConfirmaPpWidget(
                                                                      uidPropriedade:
                                                                          widget
                                                                              .uidPropriedade!,
                                                                      nomePropriedade:
                                                                          widget
                                                                              .nomePropriedade!,
                                                                      uidTecnico:
                                                                          widget
                                                                              .uidTecnico!,
                                                                      emailPropriedade:
                                                                          widget
                                                                              .emailPropriedade!,
                                                                      uidAnimaisProdutores:
                                                                          listViewOnlineAnimaisProdutoresRecord
                                                                              .reference,
                                                                      grupoPredominante:
                                                                          listViewOnlineAnimaisProdutoresRecord
                                                                              .grupoAnimal,
                                                                      nomeAnimal:
                                                                          listViewOnlineAnimaisProdutoresRecord
                                                                              .nomeAnimal,
                                                                      visitaPresencial:
                                                                          widget
                                                                              .visitaPresencial!,
                                                                      diasDg: widget
                                                                          .diasDg!,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                safeSetState(
                                                                    () {}));
                                                          },
                                                          text: 'PP',
                                                          icon: Icon(
                                                            Icons.notifications,
                                                            size: 15.0,
                                                          ),
                                                          options:
                                                              FFButtonOptions(
                                                            width: 80.0,
                                                            height: 40.0,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0.0),
                                                            iconPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            color: Color(
                                                                0xFF1A03E9),
                                                            textStyle:
                                                                FlutterFlowTheme.of(
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
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontStyle,
                                                                    ),
                                                            elevation: 4.0,
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
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    4.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: FFButtonWidget(
                                                          onPressed: () async {
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              enableDrag: false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                    FocusManager
                                                                        .instance
                                                                        .primaryFocus
                                                                        ?.unfocus();
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: MediaQuery
                                                                        .viewInsetsOf(
                                                                            context),
                                                                    child:
                                                                        DgMenosWidget(
                                                                      uidPropriedade:
                                                                          widget
                                                                              .uidPropriedade!,
                                                                      nomePropriedade:
                                                                          widget
                                                                              .nomePropriedade!,
                                                                      uidTecnico:
                                                                          widget
                                                                              .uidTecnico!,
                                                                      emailPropriedade:
                                                                          widget
                                                                              .emailPropriedade!,
                                                                      uidAnimaisProdutores:
                                                                          listViewOnlineAnimaisProdutoresRecord
                                                                              .reference,
                                                                      grupoPredominante:
                                                                          listViewOnlineAnimaisProdutoresRecord
                                                                              .grupoAnimal,
                                                                      nomeAnimal:
                                                                          listViewOnlineAnimaisProdutoresRecord
                                                                              .nomeAnimal,
                                                                      visitaPresencial:
                                                                          widget
                                                                              .visitaPresencial!,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                safeSetState(
                                                                    () {}));
                                                          },
                                                          text: 'DG -',
                                                          icon: Icon(
                                                            Icons
                                                                .cancel_rounded,
                                                            size: 15.0,
                                                          ),
                                                          options:
                                                              FFButtonOptions(
                                                            width: 80.0,
                                                            height: 40.0,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0.0),
                                                            iconPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            color: Color(
                                                                0xFFAE0303),
                                                            textStyle:
                                                                FlutterFlowTheme.of(
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
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontStyle,
                                                                    ),
                                                            elevation: 3.0,
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
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      if ((listViewOnlineAnimaisProdutoresRecord
                                                                      .dtUltimoPP !=
                                                                  '') &&
                                                          functions.verificaDataIgualAtualString(
                                                              listViewOnlineAnimaisProdutoresRecord
                                                                  .dtUltimoPP))
                                                        FlutterFlowIconButton(
                                                          borderColor: Colors
                                                              .transparent,
                                                          borderRadius: 0.0,
                                                          borderWidth: 0.0,
                                                          buttonSize: 40.0,
                                                          icon: Icon(
                                                            Icons.check_circle,
                                                            color: Color(
                                                                0xFF048508),
                                                            size: 30.0,
                                                          ),
                                                          onPressed: () {
                                                            print(
                                                                'IconButton pressed ...');
                                                          },
                                                        ),
                                                    ],
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
                          ),
                        );
                      },
                    );
                  },
                ),
              if (_model.respostaNet == false)
                Builder(
                  builder: (context) {
                    final animaisExistentes =
                        FFAppState().animaisProdutoresExistentes.toList();

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: animaisExistentes.length,
                      itemBuilder: (context, animaisExistentesIndex) {
                        final animaisExistentesItem =
                            animaisExistentes[animaisExistentesIndex];
                        return Visibility(
                          visible: valueOrDefault<bool>(
                            (animaisExistentesItem.uidTecnicoPropriedade ==
                                    widget.uidPropriedade) &&
                                (animaisExistentesItem.dtUltimaInseminacao !=
                                        '') &&
                                ((animaisExistentesItem.grupoAnimal ==
                                        'Vacas') ||
                                    (animaisExistentesItem.grupoAnimal ==
                                        'Novilhas')) &&
                                ((animaisExistentesItem.status ==
                                        'Inseminada') ||
                                    (animaisExistentesItem.status ==
                                        'Inseminada PP')) &&
                                (functions.converterStringParaData(
                                        animaisExistentesItem
                                            .dtUltimaInseminacao,
                                        widget.diasDg!) <=
                                    functions.obterDataAtual()),
                            true,
                          ),
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 1.0),
                              child: Container(
                                width: double.infinity,
                                height: 180.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 0.0,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      offset: Offset(
                                        0.0,
                                        1.0,
                                      ),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(0.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 12.0, 16.0, 12.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed(
                                        ProntuarioAnimalWidget.routeName,
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
                                          'uidAnimaisProdutores':
                                              serializeParam(
                                            animaisExistentesItem.uidAnimal,
                                            ParamType.DocumentReference,
                                          ),
                                          'grupoPredominante': serializeParam(
                                            animaisExistentesItem.grupoAnimal,
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
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            color: () {
                                              if (animaisExistentesItem
                                                      .grupoAnimal ==
                                                  'Vacas') {
                                                return Color(0xFF048508);
                                              } else if (animaisExistentesItem
                                                      .grupoAnimal ==
                                                  'Novilhas') {
                                                return Color(0xFFFF0076);
                                              } else {
                                                return Color(0x00000000);
                                              }
                                            }(),
                                            shape: BoxShape.circle,
                                          ),
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Text(
                                            () {
                                              if (animaisExistentesItem
                                                      .grupoAnimal ==
                                                  'Vacas') {
                                                return 'VAC';
                                              } else if (animaisExistentesItem
                                                      .grupoAnimal ==
                                                  'Novilhas') {
                                                return 'NOV';
                                              } else {
                                                return 'N/C';
                                              }
                                            }(),
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  font: GoogleFonts.readexPro(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontStyle,
                                                  ),
                                                  color: Colors.white,
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 0.0, 0.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    () {
                                                      if ((animaisExistentesItem
                                                                      .nomeAnimal !=
                                                                  '') &&
                                                          (animaisExistentesItem
                                                                  .brincoAnimal !=
                                                              null) &&
                                                          (animaisExistentesItem
                                                                  .brincoAnimal !=
                                                              -1)) {
                                                        return '${animaisExistentesItem.nomeAnimal} - ${animaisExistentesItem.brincoAnimal.toString()}';
                                                      } else if (animaisExistentesItem
                                                                  .nomeAnimal !=
                                                              '') {
                                                        return animaisExistentesItem
                                                            .nomeAnimal;
                                                      } else {
                                                        return animaisExistentesItem
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
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'Touro: ${animaisExistentesItem.nomeTouroUltimaInseminacao}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'Inseminada em: ${animaisExistentesItem.dtUltimaInseminacao}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
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
                                                        child: FFButtonWidget(
                                                          onPressed: ((animaisExistentesItem
                                                                          .status !=
                                                                      'Inseminada PP') &&
                                                                  (animaisExistentesItem
                                                                              .dtPP ==
                                                                          ''))
                                                              ? null
                                                              : () async {
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
                                                                              DgMaisExistenteOfflineWidget(
                                                                            uidPropriedade:
                                                                                widget.uidPropriedade!,
                                                                            nomePropriedade:
                                                                                widget.nomePropriedade!,
                                                                            uidTecnico:
                                                                                widget.uidTecnico!,
                                                                            emailPropriedade:
                                                                                widget.emailPropriedade!,
                                                                            uidAnimaisProdutores:
                                                                                animaisExistentesItem.uidAnimal!,
                                                                            grupoPredominante:
                                                                                animaisExistentesItem.grupoAnimal,
                                                                            nomeAnimal:
                                                                                animaisExistentesItem.nomeAnimal,
                                                                            visitaPresencial:
                                                                                widget.visitaPresencial!,
                                                                            diasDg:
                                                                                widget.diasDg!,
                                                                            itemUidIndex:
                                                                                animaisExistentesIndex,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      safeSetState(
                                                                          () {}));
                                                                },
                                                          text: 'DG +',
                                                          icon: Icon(
                                                            Icons.check_circle,
                                                            size: 15.0,
                                                          ),
                                                          options:
                                                              FFButtonOptions(
                                                            width: 80.0,
                                                            height: 40.0,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0.0),
                                                            iconPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            color: Color(
                                                                0xFF048508),
                                                            textStyle:
                                                                FlutterFlowTheme.of(
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
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontStyle,
                                                                    ),
                                                            elevation: 3.0,
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
                                                            disabledColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: FFButtonWidget(
                                                          onPressed: () async {
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              enableDrag: false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                    FocusManager
                                                                        .instance
                                                                        .primaryFocus
                                                                        ?.unfocus();
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: MediaQuery
                                                                        .viewInsetsOf(
                                                                            context),
                                                                    child:
                                                                        ConfirmaPpExistenteOfflineWidget(
                                                                      uidPropriedade:
                                                                          widget
                                                                              .uidPropriedade!,
                                                                      nomePropriedade:
                                                                          widget
                                                                              .nomePropriedade!,
                                                                      uidTecnico:
                                                                          widget
                                                                              .uidTecnico!,
                                                                      emailPropriedade:
                                                                          widget
                                                                              .emailPropriedade!,
                                                                      uidAnimaisProdutores:
                                                                          animaisExistentesItem
                                                                              .uidAnimal!,
                                                                      grupoPredominante:
                                                                          animaisExistentesItem
                                                                              .grupoAnimal,
                                                                      nomeAnimal:
                                                                          animaisExistentesItem
                                                                              .nomeAnimal,
                                                                      visitaPresencial:
                                                                          widget
                                                                              .visitaPresencial!,
                                                                      diasDg: widget
                                                                          .diasDg!,
                                                                      itemUidIndex:
                                                                          animaisExistentesIndex,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                safeSetState(
                                                                    () {}));
                                                          },
                                                          text: 'PP',
                                                          icon: Icon(
                                                            Icons.notifications,
                                                            size: 15.0,
                                                          ),
                                                          options:
                                                              FFButtonOptions(
                                                            width: 80.0,
                                                            height: 40.0,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0.0),
                                                            iconPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            color: Color(
                                                                0xFF1A03E9),
                                                            textStyle:
                                                                FlutterFlowTheme.of(
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
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontStyle,
                                                                    ),
                                                            elevation: 4.0,
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
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    4.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: FFButtonWidget(
                                                          onPressed: () async {
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              enableDrag: false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                    FocusManager
                                                                        .instance
                                                                        .primaryFocus
                                                                        ?.unfocus();
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: MediaQuery
                                                                        .viewInsetsOf(
                                                                            context),
                                                                    child:
                                                                        DgMenosExistenteOfflineWidget(
                                                                      uidPropriedade:
                                                                          widget
                                                                              .uidPropriedade!,
                                                                      nomePropriedade:
                                                                          widget
                                                                              .nomePropriedade!,
                                                                      uidTecnico:
                                                                          widget
                                                                              .uidTecnico!,
                                                                      emailPropriedade:
                                                                          widget
                                                                              .emailPropriedade!,
                                                                      uidAnimaisProdutores:
                                                                          animaisExistentesItem
                                                                              .uidAnimal!,
                                                                      grupoPredominante:
                                                                          animaisExistentesItem
                                                                              .grupoAnimal,
                                                                      nomeAnimal:
                                                                          animaisExistentesItem
                                                                              .nomeAnimal,
                                                                      visitaPresencial:
                                                                          widget
                                                                              .visitaPresencial!,
                                                                      itemUidIndex:
                                                                          animaisExistentesIndex,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                safeSetState(
                                                                    () {}));
                                                          },
                                                          text: 'DG -',
                                                          icon: Icon(
                                                            Icons
                                                                .cancel_rounded,
                                                            size: 15.0,
                                                          ),
                                                          options:
                                                              FFButtonOptions(
                                                            width: 80.0,
                                                            height: 40.0,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0.0),
                                                            iconPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            color: Color(
                                                                0xFFAE0303),
                                                            textStyle:
                                                                FlutterFlowTheme.of(
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
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontStyle,
                                                                    ),
                                                            elevation: 3.0,
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
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      if ((animaisExistentesItem
                                                                      .dtUltimoPP !=
                                                                  '') &&
                                                          functions.verificaDataIgualAtualString(
                                                              animaisExistentesItem
                                                                  .dtUltimoPP))
                                                        FlutterFlowIconButton(
                                                          borderColor: Colors
                                                              .transparent,
                                                          borderRadius: 0.0,
                                                          borderWidth: 0.0,
                                                          buttonSize: 40.0,
                                                          icon: Icon(
                                                            Icons.check_circle,
                                                            color: Color(
                                                                0xFF048508),
                                                            size: 30.0,
                                                          ),
                                                          onPressed: () {
                                                            print(
                                                                'IconButton pressed ...');
                                                          },
                                                        ),
                                                    ],
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
                          ),
                        );
                      },
                    );
                  },
                ),
              if (_model.respostaNet == false)
                Builder(
                  builder: (context) {
                    final listAnimaisOffline =
                        FFAppState().animaisProdutoresOffline.toList();

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: listAnimaisOffline.length,
                      itemBuilder: (context, listAnimaisOfflineIndex) {
                        final listAnimaisOfflineItem =
                            listAnimaisOffline[listAnimaisOfflineIndex];
                        return Visibility(
                          visible: valueOrDefault<bool>(
                            (listAnimaisOfflineItem.uidTecnicoPropriedade ==
                                    widget.uidPropriedade) &&
                                (listAnimaisOfflineItem
                                            .dtUltimaInseminacao !=
                                        '') &&
                                ((listAnimaisOfflineItem.grupoAnimal ==
                                        'Vacas') ||
                                    (listAnimaisOfflineItem.grupoAnimal ==
                                        'Novilhas')) &&
                                ((listAnimaisOfflineItem.status ==
                                        'Inseminada') ||
                                    (listAnimaisOfflineItem.status ==
                                        'Inseminada PP')) &&
                                (functions.converterStringParaData(
                                        listAnimaisOfflineItem
                                            .dtUltimaInseminacao,
                                        widget.diasDg!) <=
                                    functions.obterDataAtual()),
                            true,
                          ),
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 1.0),
                              child: Container(
                                width: double.infinity,
                                height: 180.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFDE6E6),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 0.0,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      offset: Offset(
                                        0.0,
                                        1.0,
                                      ),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(0.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 12.0, 16.0, 12.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {},
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            color: () {
                                              if (listAnimaisOfflineItem
                                                      .grupoAnimal ==
                                                  'Vacas') {
                                                return Color(0xFF048508);
                                              } else if (listAnimaisOfflineItem
                                                      .grupoAnimal ==
                                                  'Novilhas') {
                                                return Color(0xFFFF0076);
                                              } else {
                                                return Color(0x00000000);
                                              }
                                            }(),
                                            shape: BoxShape.circle,
                                          ),
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Text(
                                            () {
                                              if (listAnimaisOfflineItem
                                                      .grupoAnimal ==
                                                  'Vacas') {
                                                return 'VAC';
                                              } else if (listAnimaisOfflineItem
                                                      .grupoAnimal ==
                                                  'Novilhas') {
                                                return 'NOV';
                                              } else {
                                                return 'N/C';
                                              }
                                            }(),
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  font: GoogleFonts.readexPro(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontStyle,
                                                  ),
                                                  color: Colors.white,
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 0.0, 0.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    () {
                                                      if ((listAnimaisOfflineItem
                                                                      .nomeAnimal !=
                                                                  '') &&
                                                          (listAnimaisOfflineItem
                                                                  .brincoAnimal !=
                                                              null) &&
                                                          (listAnimaisOfflineItem
                                                                  .brincoAnimal !=
                                                              -1)) {
                                                        return '${listAnimaisOfflineItem.nomeAnimal} - ${listAnimaisOfflineItem.brincoAnimal.toString()}';
                                                      } else if (listAnimaisOfflineItem
                                                                  .nomeAnimal !=
                                                              '') {
                                                        return listAnimaisOfflineItem
                                                            .nomeAnimal;
                                                      } else {
                                                        return listAnimaisOfflineItem
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
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'Touro: ${listAnimaisOfflineItem.touro}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'Inseminada em: ${listAnimaisOfflineItem.dtUltimaInseminacao}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
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
                                                        child: FFButtonWidget(
                                                          onPressed: ((listAnimaisOfflineItem
                                                                          .status !=
                                                                      'Inseminada PP') &&
                                                                  (listAnimaisOfflineItem
                                                                              .dtPP ==
                                                                          ''))
                                                              ? null
                                                              : () async {
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
                                                                              DgMaisOfflineWidget(
                                                                            uidPropriedade:
                                                                                widget.uidPropriedade!,
                                                                            nomePropriedade:
                                                                                widget.nomePropriedade!,
                                                                            uidTecnico:
                                                                                widget.uidTecnico!,
                                                                            emailPropriedade:
                                                                                widget.emailPropriedade!,
                                                                            grupoPredominante:
                                                                                listAnimaisOfflineItem.grupoAnimal,
                                                                            nomeAnimal:
                                                                                listAnimaisOfflineItem.nomeAnimal,
                                                                            visitaPresencial:
                                                                                widget.visitaPresencial!,
                                                                            diasDg:
                                                                                widget.diasDg!,
                                                                            itemUidIndex:
                                                                                listAnimaisOfflineIndex,
                                                                            uidAnimalOffline:
                                                                                listAnimaisOfflineItem.uidAnimalOffline,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      safeSetState(
                                                                          () {}));
                                                                },
                                                          text: 'DG +',
                                                          icon: Icon(
                                                            Icons.check_circle,
                                                            size: 15.0,
                                                          ),
                                                          options:
                                                              FFButtonOptions(
                                                            width: 80.0,
                                                            height: 40.0,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0.0),
                                                            iconPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            color: Color(
                                                                0xFF048508),
                                                            textStyle:
                                                                FlutterFlowTheme.of(
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
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontStyle,
                                                                    ),
                                                            elevation: 3.0,
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
                                                            disabledColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: FFButtonWidget(
                                                          onPressed: () async {
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              enableDrag: false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                    FocusManager
                                                                        .instance
                                                                        .primaryFocus
                                                                        ?.unfocus();
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: MediaQuery
                                                                        .viewInsetsOf(
                                                                            context),
                                                                    child:
                                                                        ConfirmaPpOfflineWidget(
                                                                      uidPropriedade:
                                                                          widget
                                                                              .uidPropriedade!,
                                                                      nomePropriedade:
                                                                          widget
                                                                              .nomePropriedade!,
                                                                      uidTecnico:
                                                                          widget
                                                                              .uidTecnico!,
                                                                      emailPropriedade:
                                                                          widget
                                                                              .emailPropriedade!,
                                                                      grupoPredominante:
                                                                          listAnimaisOfflineItem
                                                                              .grupoAnimal,
                                                                      nomeAnimal:
                                                                          listAnimaisOfflineItem
                                                                              .nomeAnimal,
                                                                      visitaPresencial:
                                                                          widget
                                                                              .visitaPresencial!,
                                                                      diasDg: widget
                                                                          .diasDg!,
                                                                      itemUidIndex:
                                                                          listAnimaisOfflineIndex,
                                                                      uidAnimalOffline:
                                                                          listAnimaisOfflineItem
                                                                              .uidAnimalOffline,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                safeSetState(
                                                                    () {}));
                                                          },
                                                          text: 'PP',
                                                          icon: Icon(
                                                            Icons.notifications,
                                                            size: 15.0,
                                                          ),
                                                          options:
                                                              FFButtonOptions(
                                                            width: 80.0,
                                                            height: 40.0,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0.0),
                                                            iconPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            color: Color(
                                                                0xFF1A03E9),
                                                            textStyle:
                                                                FlutterFlowTheme.of(
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
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontStyle,
                                                                    ),
                                                            elevation: 4.0,
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
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    4.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: FFButtonWidget(
                                                          onPressed: () async {
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              enableDrag: false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                    FocusManager
                                                                        .instance
                                                                        .primaryFocus
                                                                        ?.unfocus();
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: MediaQuery
                                                                        .viewInsetsOf(
                                                                            context),
                                                                    child:
                                                                        DgMenosOfflineWidget(
                                                                      uidPropriedade:
                                                                          widget
                                                                              .uidPropriedade!,
                                                                      nomePropriedade:
                                                                          widget
                                                                              .nomePropriedade!,
                                                                      uidTecnico:
                                                                          widget
                                                                              .uidTecnico!,
                                                                      emailPropriedade:
                                                                          widget
                                                                              .emailPropriedade!,
                                                                      grupoPredominante:
                                                                          listAnimaisOfflineItem
                                                                              .grupoAnimal,
                                                                      nomeAnimal:
                                                                          listAnimaisOfflineItem
                                                                              .nomeAnimal,
                                                                      visitaPresencial:
                                                                          widget
                                                                              .visitaPresencial!,
                                                                      itemUidIndex:
                                                                          listAnimaisOfflineIndex,
                                                                      uidAnimalOffline:
                                                                          listAnimaisOfflineItem
                                                                              .uidAnimalOffline,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                safeSetState(
                                                                    () {}));
                                                          },
                                                          text: 'DG -',
                                                          icon: Icon(
                                                            Icons
                                                                .cancel_rounded,
                                                            size: 15.0,
                                                          ),
                                                          options:
                                                              FFButtonOptions(
                                                            width: 80.0,
                                                            height: 40.0,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0.0),
                                                            iconPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            color: Color(
                                                                0xFFAE0303),
                                                            textStyle:
                                                                FlutterFlowTheme.of(
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
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontStyle,
                                                                    ),
                                                            elevation: 3.0,
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
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      if ((listAnimaisOfflineItem
                                                                      .dtUltimoPP !=
                                                                  '') &&
                                                          functions.verificaDataIgualAtualString(
                                                              listAnimaisOfflineItem
                                                                  .dtUltimoPP))
                                                        FlutterFlowIconButton(
                                                          borderColor: Colors
                                                              .transparent,
                                                          borderRadius: 0.0,
                                                          borderWidth: 0.0,
                                                          buttonSize: 40.0,
                                                          icon: Icon(
                                                            Icons.check_circle,
                                                            color: Color(
                                                                0xFF048508),
                                                            size: 30.0,
                                                          ),
                                                          onPressed: () {
                                                            print(
                                                                'IconButton pressed ...');
                                                          },
                                                        ),
                                                    ],
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
                          ),
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
