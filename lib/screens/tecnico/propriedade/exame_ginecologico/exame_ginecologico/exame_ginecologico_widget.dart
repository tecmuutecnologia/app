import '/backend/backend.dart';
import '/components/ui/flutter_flow_icon_button.dart';
import 'package:tecmuu/utils/flutter_flow_theme.dart';
import '/components/ui/flutter_flow_util.dart';
import '/components/ui/flutter_flow_widgets.dart';
import '/utils/instant_timer.dart';
import '/screens/tecnico/propriedade/animals/descarte_animal/descarte_animal_widget.dart';
import '/screens/tecnico/propriedade/exame_ginecologico/nova_acao_exame_ginecologico/nova_acao_exame_ginecologico_widget.dart';
import '/screens/tecnico/propriedade/exame_ginecologico/nova_acao_exame_ginecologico_existente_offline/nova_acao_exame_ginecologico_existente_offline_widget.dart';
import '/screens/tecnico/propriedade/exame_ginecologico/nova_acao_exame_ginecologico_offline/nova_acao_exame_ginecologico_offline_widget.dart';
import '/screens/tecnico/propriedade/sincronizacao/alerta_sem_internet/alerta_sem_internet_widget.dart';
import '/helpers/index.dart' as actions;
import '/helpers/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'exame_ginecologico_model.dart';
export 'exame_ginecologico_model.dart';

class ExameGinecologicoWidget extends StatefulWidget {
  const ExameGinecologicoWidget({
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

  static String routeName = 'exameGinecologico';
  static String routePath = '/exameGinecologico';

  @override
  State<ExameGinecologicoWidget> createState() =>
      _ExameGinecologicoWidgetState();
}

class _ExameGinecologicoWidgetState extends State<ExameGinecologicoWidget> {
  late ExameGinecologicoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ExameGinecologicoModel());

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
                _model.respostaNet! ? Color(0xFFF75E38) : Color(0xFFF2886E),
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
        body: SingleChildScrollView(
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
                          visible: ((listViewOnlineAnimaisProdutoresRecord
                                          .grupoAnimal ==
                                      'Novilhas') ||
                                  (listViewOnlineAnimaisProdutoresRecord
                                          .grupoAnimal ==
                                      'Vacas')) &&
                              (listViewOnlineAnimaisProdutoresRecord
                                      .dtInducaoLactacao ==
                                  null),
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 1.0),
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
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        child: Padding(
                                          padding:
                                              MediaQuery.viewInsetsOf(context),
                                          child: DescarteAnimalWidget(
                                            uidPropriedade:
                                                widget.uidPropriedade!,
                                            nomePropriedade:
                                                widget.nomePropriedade!,
                                            uidTecnico: widget.uidTecnico!,
                                            emailPropriedade:
                                                widget.emailPropriedade!,
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
                                                widget.visitaPresencial!,
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
                                        16.0, 5.0, 16.0, 5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                            primary: false,
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
                                                      shape: BoxShape.circle,
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
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .titleMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
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
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      FFButtonWidget(
                                                        onPressed: () async {
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
                                                                      NovaAcaoExameGinecologicoWidget(
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
                                                                    visitaPresencial:
                                                                        widget
                                                                            .visitaPresencial!,
                                                                    diasDg: widget
                                                                        .diasDg!,
                                                                    uidAnimaisProdutores:
                                                                        listViewOnlineAnimaisProdutoresRecord
                                                                            .reference,
                                                                    nomeAnimal:
                                                                        listViewOnlineAnimaisProdutoresRecord
                                                                            .nomeAnimal,
                                                                    brincoAnimal:
                                                                        listViewOnlineAnimaisProdutoresRecord
                                                                            .brincoAnimal
                                                                            .toString(),
                                                                    grupoAnimal:
                                                                        listViewOnlineAnimaisProdutoresRecord
                                                                            .grupoAnimal,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ).then((value) =>
                                                              safeSetState(
                                                                  () {}));
                                                        },
                                                        text: 'Ação',
                                                        icon: Icon(
                                                          Icons.add_alert,
                                                          size: 15.0,
                                                        ),
                                                        options:
                                                            FFButtonOptions(
                                                          width: 70.0,
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
                                                          color:
                                                              Color(0xFF1A03E9),
                                                          textStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
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
                                                      if ((listViewOnlineAnimaisProdutoresRecord
                                                                      .dtUltimaAcao !=
                                                                  '') &&
                                                          (functions.verificaDataAcaoDataAtual(
                                                                  listViewOnlineAnimaisProdutoresRecord
                                                                      .dtUltimaAcao) ==
                                                              true))
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      5.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Icon(
                                                            Icons.check_circle,
                                                            color: Color(
                                                                0xFF048508),
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
              if (!_model.respostaNet!)
                Builder(
                  builder: (context) {
                    final listOfflineExistente =
                        FFAppState().animaisProdutoresExistentes.toList();

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: listOfflineExistente.length,
                      itemBuilder: (context, listOfflineExistenteIndex) {
                        final listOfflineExistenteItem =
                            listOfflineExistente[listOfflineExistenteIndex];
                        return Visibility(
                          visible: (listOfflineExistenteItem
                                      .uidTecnicoPropriedade ==
                                  widget.uidPropriedade) &&
                              (listOfflineExistenteItem.status == 'Vazia') &&
                              ((listOfflineExistenteItem.grupoAnimal ==
                                      'Novilhas') ||
                                  (listOfflineExistenteItem.grupoAnimal ==
                                      'Vacas')) &&
                              (listOfflineExistenteItem.dtInducaoLactacao ==
                                  null),
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 1.0),
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
                                        listOfflineExistenteItem.uidAnimal,
                                        ParamType.DocumentReference,
                                      ),
                                      'grupoPredominante': serializeParam(
                                        listOfflineExistenteItem.grupoAnimal,
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
                                onLongPress: () async {},
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
                                        16.0, 5.0, 16.0, 5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                            primary: false,
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
                                                        if (listOfflineExistenteItem
                                                                .grupoAnimal ==
                                                            'Vacas') {
                                                          return Color(
                                                              0xFF048508);
                                                        } else if (listOfflineExistenteItem
                                                                .grupoAnimal ==
                                                            'Novilhas') {
                                                          return Color(
                                                              0xFFFF0076);
                                                        } else {
                                                          return Color(
                                                              0x00000000);
                                                        }
                                                      }(),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Text(
                                                      () {
                                                        if (listOfflineExistenteItem
                                                                .grupoAnimal ==
                                                            'Vacas') {
                                                          return 'VAC';
                                                        } else if (listOfflineExistenteItem
                                                                .grupoAnimal ==
                                                            'Novilhas') {
                                                          return 'NOV';
                                                        } else {
                                                          return 'N/C';
                                                        }
                                                      }(),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .titleMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
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
                                                    () {
                                                      if ((listOfflineExistenteItem
                                                                      .nomeAnimal !=
                                                                  '') &&
                                                          (listOfflineExistenteItem
                                                                  .brincoAnimal !=
                                                              null) &&
                                                          (listOfflineExistenteItem
                                                                  .brincoAnimal !=
                                                              -1)) {
                                                        return '${listOfflineExistenteItem.nomeAnimal} - ${listOfflineExistenteItem.brincoAnimal.toString()}';
                                                      } else if (listOfflineExistenteItem
                                                                  .nomeAnimal !=
                                                              '') {
                                                        return listOfflineExistenteItem
                                                            .nomeAnimal;
                                                      } else {
                                                        return listOfflineExistenteItem
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
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      FFButtonWidget(
                                                        onPressed: () async {
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
                                                                      NovaAcaoExameGinecologicoExistenteOfflineWidget(
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
                                                                    visitaPresencial:
                                                                        widget
                                                                            .visitaPresencial!,
                                                                    diasDg: widget
                                                                        .diasDg!,
                                                                    uidAnimaisProdutores:
                                                                        listOfflineExistenteItem
                                                                            .uidAnimal!,
                                                                    nomeAnimal:
                                                                        listOfflineExistenteItem
                                                                            .nomeAnimal,
                                                                    brincoAnimal:
                                                                        listOfflineExistenteItem
                                                                            .brincoAnimal
                                                                            .toString(),
                                                                    grupoAnimal:
                                                                        listOfflineExistenteItem
                                                                            .grupoAnimal,
                                                                    itemUidIndex:
                                                                        listOfflineExistenteIndex,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ).then((value) =>
                                                              safeSetState(
                                                                  () {}));
                                                        },
                                                        text: 'Ação',
                                                        icon: Icon(
                                                          Icons.add_alert,
                                                          size: 15.0,
                                                        ),
                                                        options:
                                                            FFButtonOptions(
                                                          width: 70.0,
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
                                                          color:
                                                              Color(0xFF1A03E9),
                                                          textStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
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
                                                      if ((listOfflineExistenteItem
                                                                      .dtUltimaAcao !=
                                                                  '') &&
                                                          (functions.verificaDataAcaoDataAtual(
                                                                  listOfflineExistenteItem
                                                                      .dtUltimaAcao) ==
                                                              true))
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      5.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Icon(
                                                            Icons.check_circle,
                                                            color: Color(
                                                                0xFF048508),
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
              if (!_model.respostaNet!)
                Builder(
                  builder: (context) {
                    final listViewOffline =
                        FFAppState().animaisProdutoresOffline.toList();

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: listViewOffline.length,
                      itemBuilder: (context, listViewOfflineIndex) {
                        final listViewOfflineItem =
                            listViewOffline[listViewOfflineIndex];
                        return Visibility(
                          visible: (listViewOfflineItem.uidTecnicoPropriedade ==
                                  widget.uidPropriedade) &&
                              (listViewOfflineItem.status == 'Vazia') &&
                              ((listViewOfflineItem.grupoAnimal ==
                                      'Novilhas') ||
                                  (listViewOfflineItem.grupoAnimal ==
                                      'Vacas')) &&
                              (listViewOfflineItem.dtInducaoLactacao == null),
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 1.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pushNamed(
                                    ProntuarioAnimalOfflineWidget.routeName,
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
                                      'grupoPredominante': serializeParam(
                                        listViewOfflineItem.grupoAnimal,
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
                                      'itemUidIndex': serializeParam(
                                        listViewOfflineIndex,
                                        ParamType.int,
                                      ),
                                    }.withoutNulls,
                                  );
                                },
                                onLongPress: () async {},
                                child: Container(
                                  width: double.infinity,
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
                                        16.0, 5.0, 16.0, 5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                            primary: false,
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
                                                        if (listViewOfflineItem
                                                                .grupoAnimal ==
                                                            'Vacas') {
                                                          return Color(
                                                              0xFF048508);
                                                        } else if (listViewOfflineItem
                                                                .grupoAnimal ==
                                                            'Novilhas') {
                                                          return Color(
                                                              0xFFFF0076);
                                                        } else {
                                                          return Color(
                                                              0x00000000);
                                                        }
                                                      }(),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Text(
                                                      () {
                                                        if (listViewOfflineItem
                                                                .grupoAnimal ==
                                                            'Vacas') {
                                                          return 'VAC';
                                                        } else if (listViewOfflineItem
                                                                .grupoAnimal ==
                                                            'Novilhas') {
                                                          return 'NOV';
                                                        } else {
                                                          return 'N/C';
                                                        }
                                                      }(),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .titleMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
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
                                                    () {
                                                      if ((listViewOfflineItem
                                                                      .nomeAnimal !=
                                                                  '') &&
                                                          (listViewOfflineItem
                                                                  .brincoAnimal !=
                                                              null) &&
                                                          (listViewOfflineItem
                                                                  .brincoAnimal !=
                                                              -1) &&
                                                          (listViewOfflineItem
                                                                  .nomeAnimal !=
                                                              'False')) {
                                                        return '${listViewOfflineItem.nomeAnimal} - ${listViewOfflineItem.brincoAnimal.toString()}';
                                                      } else if ((listViewOfflineItem
                                                                      .nomeAnimal !=
                                                                  '') &&
                                                          (listViewOfflineItem
                                                                  .nomeAnimal !=
                                                              'False')) {
                                                        return listViewOfflineItem
                                                            .nomeAnimal;
                                                      } else {
                                                        return listViewOfflineItem
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
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      FFButtonWidget(
                                                        onPressed: () async {
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
                                                                      NovaAcaoExameGinecologicoOfflineWidget(
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
                                                                    visitaPresencial:
                                                                        widget
                                                                            .visitaPresencial!,
                                                                    diasDg: widget
                                                                        .diasDg!,
                                                                    nomeAnimal:
                                                                        listViewOfflineItem
                                                                            .nomeAnimal,
                                                                    brincoAnimal:
                                                                        listViewOfflineItem
                                                                            .brincoAnimal
                                                                            .toString(),
                                                                    grupoAnimal:
                                                                        listViewOfflineItem
                                                                            .grupoAnimal,
                                                                    itemUidIndex:
                                                                        listViewOfflineIndex,
                                                                    uidAnimalOffline:
                                                                        listViewOfflineItem
                                                                            .uidAnimalOffline,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ).then((value) =>
                                                              safeSetState(
                                                                  () {}));
                                                        },
                                                        text: 'Ação',
                                                        icon: Icon(
                                                          Icons.add_alert,
                                                          size: 15.0,
                                                        ),
                                                        options:
                                                            FFButtonOptions(
                                                          width: 70.0,
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
                                                          color:
                                                              Color(0xFF1A03E9),
                                                          textStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
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
                                                      if ((listViewOfflineItem
                                                                      .dtUltimaAcao !=
                                                                  '') &&
                                                          (functions.verificaDataAcaoDataAtual(
                                                                  listViewOfflineItem
                                                                      .dtUltimaAcao) ==
                                                              true))
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      5.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Icon(
                                                            Icons.check_circle,
                                                            color: Color(
                                                                0xFF048508),
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
            ],
          ),
        ),
      ),
    );
  }
}
