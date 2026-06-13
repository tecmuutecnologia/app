// ignore_for_file: unnecessary_null_comparison
import '/backend/backend.dart';
import '/domain/animais/classificacao_animal.dart';
import '/backend/objectbox/index.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/instant_timer.dart';
import '/custom_code/actions/index.dart' as actions;
import '/core/ui/custom_functions.dart' as functions;
import '/pages/tecnico/propriedade/dignostico_gestacao/dg_mais/dg_mais_widget.dart';
import '/pages/tecnico/propriedade/dignostico_gestacao/dg_menos/dg_menos_widget.dart';
import '/pages/tecnico/propriedade/dignostico_gestacao/confirma_pp/confirma_pp_widget.dart';
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

  /// Lista de animais existentes (fonte ObjectBox). Antes em
  /// FFAppState.animaisProdutoresExistentes; agora estado local desta tela.
  List<AnimaisProdutoresStruct> _animaisExistentes = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DiagnosticogestacaoModel());

    // Fonte única: carrega a lista do ObjectBox (offline-first). A tela renderiza
    // sempre desta lista; o Firestore é usado apenas para sincronizar.
    if (ObjectBoxService.isInitialized) {
      _animaisExistentes = AnimalRepository()
          .getAll()
          .where((a) => !a.isDeleted)
          .map(animalEntityToStruct)
          .toList();
    }

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.instantTimer = InstantTimer.periodic(
        duration: Duration(seconds: 5),
        callback: (timer) async {
          _model.respostaNet = await actions.checkInternetConnection();

          safeSetState(() {});
          if (_model.respostaNet!) {
            safeSetState(() {});
          } else {
            // Offline: notificação passiva via SyncStatusBanner (app-wide);
            // sem flag global. O respostaNet acima já atualiza a UI.
          }
        },
        startImmediately: false,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  /// Card extraído do build (Fase 4).
  Widget _buildCard1(
      BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Visibility(
      visible: valueOrDefault<bool>(
        (item.uidTecnicoPropriedade == widget.uidPropriedade) &&
            (item.dtUltimaInseminacao != '') &&
            ((ehVaca(item.grupoAnimal)) || (ehNovilha(item.grupoAnimal))) &&
            ((ehInseminada(item.status)) || (ehInseminadaPP(item.status))) &&
            (functions.converterStringParaData(
                    item.dtUltimaInseminacao, widget.diasDg!) <=
                functions.obterDataAtual()),
        true,
      ),
      child: Align(
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
          child: Container(
            width: double.infinity,
            height: 180.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              boxShadow: [
                BoxShadow(
                  blurRadius: 0.0,
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  offset: Offset(
                    0.0,
                    1.0,
                  ),
                )
              ],
              borderRadius: BorderRadius.circular(0.0),
              border: Border.all(
                color: FlutterFlowTheme.of(context).primaryBackground,
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
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
                        item.uidAnimal,
                        ParamType.DocumentReference,
                      ),
                      'grupoPredominante': serializeParam(
                        item.grupoAnimal,
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
                    _part1(context, item, index),
                    _part2(context, item, index)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _part1(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: () {
          if (ehVaca(item.grupoAnimal)) {
            return Color(0xFF048508);
          } else if (ehNovilha(item.grupoAnimal)) {
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
          if (ehVaca(item.grupoAnimal)) {
            return 'VAC';
          } else if (ehNovilha(item.grupoAnimal)) {
            return 'NOV';
          } else {
            return 'N/C';
          }
        }(),
        style: FlutterFlowTheme.of(context).titleMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
              ),
              color: Colors.white,
              fontSize: 13.0,
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
            ),
      ),
    );
  }

  Widget _part2(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _part3(context, item, index),
          _part4(context, item, index),
          _part5(context, item, index),
          _part6(context, item, index)
        ],
      ),
    );
  }

  Widget _part3(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          () {
            if ((item.nomeAnimal != '') &&
                (item.brincoAnimal != null) &&
                (item.brincoAnimal != -1)) {
              return '${item.nomeAnimal} - ${item.brincoAnimal.toString()}';
            } else if (item.nomeAnimal != '') {
              return item.nomeAnimal;
            } else {
              return item.brincoAnimal.toString();
            }
          }(),
          style: FlutterFlowTheme.of(context).bodyLarge.override(
                font: GoogleFonts.readexPro(
                  fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
              ),
        ),
      ],
    );
  }

  Widget _part4(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'Touro: ${item.nomeTouroUltimaInseminacao}',
          style: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
        ),
      ],
    );
  }

  Widget _part5(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'Inseminada em: ${item.dtUltimaInseminacao}',
          style: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
        ),
      ],
    );
  }

  Widget _part6(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
              child: FFButtonWidget(
                onPressed: ((!ehInseminadaPP(item.status)) && (item.dtPP == ''))
                    ? null
                    : () async {
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
                                child: DgMaisWidget(
                                  uidPropriedade: widget.uidPropriedade!,
                                  nomePropriedade: widget.nomePropriedade!,
                                  uidTecnico: widget.uidTecnico!,
                                  emailPropriedade: widget.emailPropriedade!,
                                  uidAnimaisProdutores: item.uidAnimal,
                                  uidAnimalOffline: item.uidAnimalOffline,
                                  grupoPredominante: item.grupoAnimal,
                                  nomeAnimal: item.nomeAnimal,
                                  visitaPresencial: widget.visitaPresencial!,
                                  diasDg: widget.diasDg!,
                                ),
                              ),
                            );
                          },
                        ).then((value) => safeSetState(() {}));
                      },
                text: 'DG +',
                icon: Icon(
                  Icons.check_circle,
                  size: 15.0,
                ),
                options: FFButtonOptions(
                  width: 80.0,
                  height: 40.0,
                  padding: EdgeInsets.all(0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: Color(0xFF048508),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                        color: Colors.white,
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                  elevation: 3.0,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  disabledColor: FlutterFlowTheme.of(context).primaryBackground,
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
              child: FFButtonWidget(
                onPressed: () async {
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
                          child: ConfirmaPpWidget(
                            uidPropriedade: widget.uidPropriedade!,
                            nomePropriedade: widget.nomePropriedade!,
                            uidTecnico: widget.uidTecnico!,
                            emailPropriedade: widget.emailPropriedade!,
                            uidAnimaisProdutores: item.uidAnimal,
                            uidAnimalOffline: item.uidAnimalOffline,
                            grupoPredominante: item.grupoAnimal,
                            nomeAnimal: item.nomeAnimal,
                            visitaPresencial: widget.visitaPresencial!,
                            diasDg: widget.diasDg!,
                          ),
                        ),
                      );
                    },
                  ).then((value) => safeSetState(() {}));
                },
                text: 'PP',
                icon: Icon(
                  Icons.notifications,
                  size: 15.0,
                ),
                options: FFButtonOptions(
                  width: 80.0,
                  height: 40.0,
                  padding: EdgeInsets.all(0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: Color(0xFF1A03E9),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                        color: Colors.white,
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                  elevation: 4.0,
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
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5.0, 4.0, 0.0, 0.0),
              child: FFButtonWidget(
                onPressed: () async {
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
                          child: DgMenosWidget(
                            uidPropriedade: widget.uidPropriedade!,
                            nomePropriedade: widget.nomePropriedade!,
                            uidTecnico: widget.uidTecnico!,
                            emailPropriedade: widget.emailPropriedade!,
                            uidAnimaisProdutores: item.uidAnimal,
                            uidAnimalOffline: item.uidAnimalOffline,
                            grupoPredominante: item.grupoAnimal,
                            nomeAnimal: item.nomeAnimal,
                            visitaPresencial: widget.visitaPresencial!,
                          ),
                        ),
                      );
                    },
                  ).then((value) => safeSetState(() {}));
                },
                text: 'DG -',
                icon: Icon(
                  Icons.cancel_rounded,
                  size: 15.0,
                ),
                options: FFButtonOptions(
                  width: 80.0,
                  height: 40.0,
                  padding: EdgeInsets.all(0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: Color(0xFFAE0303),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                        color: Colors.white,
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
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
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if ((item.dtUltimoPP != '') &&
                functions.verificaDataIgualAtualString(item.dtUltimoPP))
              FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 0.0,
                borderWidth: 0.0,
                buttonSize: 40.0,
                icon: Icon(
                  Icons.check_circle,
                  color: Color(0xFF048508),
                  size: 30.0,
                ),
                onPressed: () {
                  print('IconButton pressed ...');
                },
              ),
          ],
        ),
      ],
    );
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
            backgroundColor: (_model.respostaNet ?? true)
                ? Color(0xFFF75E38)
                : Color(0xFFF2886E),
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
              Builder(
                builder: (context) {
                  final animaisExistentes = _animaisExistentes.toList();

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: animaisExistentes.length,
                    itemBuilder: (context, animaisExistentesIndex) {
                      final animaisExistentesItem =
                          animaisExistentes[animaisExistentesIndex];
                      return _buildCard1(context, animaisExistentesItem,
                          animaisExistentesIndex);
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
