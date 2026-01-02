import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/tecnico/propriedade/dignostico_gestacao/confirma_pp/confirma_pp_widget.dart';
import '/pages/tecnico/propriedade/dignostico_gestacao/dg_mais/dg_mais_widget.dart';
import '/pages/tecnico/propriedade/dignostico_gestacao/dg_menos/dg_menos_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'diagnosticogestacao_bkp_offline_model.dart';
export 'diagnosticogestacao_bkp_offline_model.dart';

class DiagnosticogestacaoBkpOfflineWidget extends StatefulWidget {
  const DiagnosticogestacaoBkpOfflineWidget({
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

  static String routeName = 'diagnosticogestacaoBkpOffline';
  static String routePath = '/diagnosticogestacaoBkpOffline';

  @override
  State<DiagnosticogestacaoBkpOfflineWidget> createState() =>
      _DiagnosticogestacaoBkpOfflineWidgetState();
}

class _DiagnosticogestacaoBkpOfflineWidgetState
    extends State<DiagnosticogestacaoBkpOfflineWidget> {
  late DiagnosticogestacaoBkpOfflineModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DiagnosticogestacaoBkpOfflineModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        body: StreamBuilder<List<AnimaisProdutoresRecord>>(
          stream: queryAnimaisProdutoresRecord(
            parent: widget.uidTecnico,
            queryBuilder: (animaisProdutoresRecord) => animaisProdutoresRecord
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
            List<AnimaisProdutoresRecord> listViewAnimaisProdutoresRecordList =
                snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: listViewAnimaisProdutoresRecordList.length,
              itemBuilder: (context, listViewIndex) {
                final listViewAnimaisProdutoresRecord =
                    listViewAnimaisProdutoresRecordList[listViewIndex];
                return Visibility(
                  visible: valueOrDefault<bool>(
                    (listViewAnimaisProdutoresRecord
                                    .dtUltimaInseminacao !=
                                '') &&
                        ((listViewAnimaisProdutoresRecord.grupoAnimal ==
                                'Vacas') ||
                            (listViewAnimaisProdutoresRecord.grupoAnimal ==
                                'Novilhas')) &&
                        ((listViewAnimaisProdutoresRecord.status ==
                                'Inseminada') ||
                            (listViewAnimaisProdutoresRecord.status ==
                                'Inseminada PP')) &&
                        (functions.converterStringParaData(
                                listViewAnimaisProdutoresRecord
                                    .dtUltimaInseminacao,
                                widget.diasDg!) <=
                            functions.obterDataAtual()),
                    true,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
                      child: Container(
                        width: double.infinity,
                        height: 180.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
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
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
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
                                  'uidAnimaisProdutores': serializeParam(
                                    listViewAnimaisProdutoresRecord.reference,
                                    ParamType.DocumentReference,
                                  ),
                                  'grupoPredominante': serializeParam(
                                    listViewAnimaisProdutoresRecord.grupoAnimal,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: () {
                                      if (listViewAnimaisProdutoresRecord
                                              .grupoAnimal ==
                                          'Vacas') {
                                        return Color(0xFF048508);
                                      } else if (listViewAnimaisProdutoresRecord
                                              .grupoAnimal ==
                                          'Novilhas') {
                                        return Color(0xFFFF0076);
                                      } else {
                                        return Color(0x00000000);
                                      }
                                    }(),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Text(
                                    () {
                                      if (listViewAnimaisProdutoresRecord
                                              .grupoAnimal ==
                                          'Vacas') {
                                        return 'VAC';
                                      } else if (listViewAnimaisProdutoresRecord
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
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                          color: Colors.white,
                                          fontSize: 13.0,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10.0, 0.0, 0.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            () {
                                              if ((listViewAnimaisProdutoresRecord
                                                              .nomeAnimal !=
                                                          '') &&
                                                  (listViewAnimaisProdutoresRecord
                                                          .brincoAnimal !=
                                                      null) &&
                                                  (listViewAnimaisProdutoresRecord
                                                          .brincoAnimal !=
                                                      -1)) {
                                                return '${listViewAnimaisProdutoresRecord.nomeAnimal} - ${listViewAnimaisProdutoresRecord.brincoAnimal.toString()}';
                                              } else if (listViewAnimaisProdutoresRecord
                                                          .nomeAnimal !=
                                                      '') {
                                                return listViewAnimaisProdutoresRecord
                                                    .nomeAnimal;
                                              } else {
                                                return listViewAnimaisProdutoresRecord
                                                    .brincoAnimal
                                                    .toString();
                                              }
                                            }(),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                  font: GoogleFonts.readexPro(
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
                                            'Touro: ${listViewAnimaisProdutoresRecord.nomeTouroUltimaInseminacao}',
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.readexPro(
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
                                            'Inseminada em: ${listViewAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.readexPro(
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
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 4.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: ((listViewAnimaisProdutoresRecord
                                                                  .status !=
                                                              'Inseminada PP') &&
                                                          (listViewAnimaisProdutoresRecord
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
                                                            enableDrag: false,
                                                            context: context,
                                                            builder: (context) {
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
                                                                child: Padding(
                                                                  padding: MediaQuery
                                                                      .viewInsetsOf(
                                                                          context),
                                                                  child:
                                                                      DgMaisWidget(
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
                                                                        listViewAnimaisProdutoresRecord
                                                                            .reference,
                                                                    grupoPredominante:
                                                                        listViewAnimaisProdutoresRecord
                                                                            .grupoAnimal,
                                                                    nomeAnimal:
                                                                        listViewAnimaisProdutoresRecord
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
                                                  text: 'DG +',
                                                  icon: Icon(
                                                    Icons.check_circle,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 80.0,
                                                    height: 40.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF048508),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
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
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        5.0, 0.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
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
                                                          child: Padding(
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
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              uidAnimaisProdutores:
                                                                  listViewAnimaisProdutoresRecord
                                                                      .reference,
                                                              grupoPredominante:
                                                                  listViewAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                              nomeAnimal:
                                                                  listViewAnimaisProdutoresRecord
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
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'PP',
                                                  icon: Icon(
                                                    Icons.notifications,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 80.0,
                                                    height: 40.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF1A03E9),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 4.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        5.0, 4.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
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
                                                          child: Padding(
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
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              uidAnimaisProdutores:
                                                                  listViewAnimaisProdutoresRecord
                                                                      .reference,
                                                              grupoPredominante:
                                                                  listViewAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                              nomeAnimal:
                                                                  listViewAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'DG -',
                                                  icon: Icon(
                                                    Icons.cancel_rounded,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 80.0,
                                                    height: 40.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFFAE0303),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if ((listViewAnimaisProdutoresRecord
                                                              .dtUltimoPP !=
                                                          '') &&
                                                  functions
                                                      .verificaDataIgualAtualString(
                                                          listViewAnimaisProdutoresRecord
                                                              .dtUltimoPP))
                                                FlutterFlowIconButton(
                                                  borderColor:
                                                      Colors.transparent,
                                                  borderRadius: 0.0,
                                                  borderWidth: 0.0,
                                                  buttonSize: 40.0,
                                                  icon: Icon(
                                                    Icons.check_circle,
                                                    color: Color(0xFF048508),
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
      ),
    );
  }
}
