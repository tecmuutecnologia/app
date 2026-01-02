import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/tecnico/propriedade/animals/descarte_animal/descarte_animal_widget.dart';
import '/pages/tecnico/propriedade/exame_ginecologico/nova_acao_exame_ginecologico/nova_acao_exame_ginecologico_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'exame_ginecologico_bkp_offline_model.dart';
export 'exame_ginecologico_bkp_offline_model.dart';

class ExameGinecologicoBkpOfflineWidget extends StatefulWidget {
  const ExameGinecologicoBkpOfflineWidget({
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

  static String routeName = 'exameGinecologicoBkpOffline';
  static String routePath = '/exameGinecologicoBkpOffline';

  @override
  State<ExameGinecologicoBkpOfflineWidget> createState() =>
      _ExameGinecologicoBkpOfflineWidgetState();
}

class _ExameGinecologicoBkpOfflineWidgetState
    extends State<ExameGinecologicoBkpOfflineWidget> {
  late ExameGinecologicoBkpOfflineModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ExameGinecologicoBkpOfflineModel());

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
                        'Exame ginecológico',
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
                .where(
                  'status',
                  isEqualTo: 'Vazia',
                )
                .orderBy('nomeAnimal')
                .orderBy('brincoAnimalOrder'),
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
                  visible: ((listViewAnimaisProdutoresRecord.grupoAnimal ==
                              'Novilhas') ||
                          (listViewAnimaisProdutoresRecord.grupoAnimal ==
                              'Vacas')) &&
                      (listViewAnimaisProdutoresRecord.dtInducaoLactacao ==
                          null),
                  child: Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
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
                        onLongPress: () async {
                          await showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
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
                                  child: DescarteAnimalWidget(
                                    uidPropriedade: widget.uidPropriedade!,
                                    nomePropriedade: widget.nomePropriedade!,
                                    uidTecnico: widget.uidTecnico!,
                                    emailPropriedade: widget.emailPropriedade!,
                                    uidAnimaisProdutores:
                                        listViewAnimaisProdutoresRecord
                                            .reference,
                                    grupoPredominante:
                                        listViewAnimaisProdutoresRecord
                                            .grupoAnimal,
                                    nomeAnimal: listViewAnimaisProdutoresRecord
                                        .nomeAnimal,
                                    visitaPresencial: widget.visitaPresencial!,
                                    diasDg: widget.diasDg!,
                                  ),
                                ),
                              );
                            },
                          ).then((value) => safeSetState(() {}));
                        },
                        child: Container(
                          width: double.infinity,
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
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: GridView(
                                    padding: EdgeInsets.zero,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 0.0,
                                      mainAxisSpacing: 0.0,
                                      childAspectRatio: 2.0,
                                    ),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
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
                                              style: FlutterFlowTheme.of(
                                                      context)
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
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            listViewAnimaisProdutoresRecord
                                                            .nomeAnimal !=
                                                        ''
                                                ? listViewAnimaisProdutoresRecord
                                                    .nomeAnimal
                                                : listViewAnimaisProdutoresRecord
                                                    .brincoAnimal
                                                    .toString(),
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
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FFButtonWidget(
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
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              NovaAcaoExameGinecologicoWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
                                                                    .emailPropriedade!,
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            diasDg:
                                                                widget.diasDg!,
                                                            uidAnimaisProdutores:
                                                                listViewAnimaisProdutoresRecord
                                                                    .reference,
                                                            nomeAnimal:
                                                                listViewAnimaisProdutoresRecord
                                                                    .nomeAnimal,
                                                            brincoAnimal:
                                                                listViewAnimaisProdutoresRecord
                                                                    .brincoAnimal
                                                                    .toString(),
                                                            grupoAnimal:
                                                                listViewAnimaisProdutoresRecord
                                                                    .grupoAnimal,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Ação',
                                                icon: Icon(
                                                  Icons.add_alert,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 70.0,
                                                  height: 40.0,
                                                  padding: EdgeInsets.all(0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFF1A03E9),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
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
                                              if ((listViewAnimaisProdutoresRecord
                                                              .dtUltimaAcao !=
                                                          '') &&
                                                  (functions.verificaDataAcaoDataAtual(
                                                          listViewAnimaisProdutoresRecord
                                                              .dtUltimaAcao) ==
                                                      true))
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          5.0, 0.0, 0.0, 0.0),
                                                  child: Icon(
                                                    Icons.check_circle,
                                                    color: Color(0xFF048508),
                                                    size: 30.0,
                                                  ),
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
