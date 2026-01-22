import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import '/pages/tecnico/propriedade/sincronizacao/alerta_sem_internet/alerta_sem_internet_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'cadastrar_novo_animal_model.dart';
export 'cadastrar_novo_animal_model.dart';

class CadastrarNovoAnimalWidget extends StatefulWidget {
  const CadastrarNovoAnimalWidget({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.grupoPredominante,
    required this.visitaPresencial,
    int? initialTabSelect,
    required this.diasDg,
  }) : this.initialTabSelect = initialTabSelect ?? 0;

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final String? grupoPredominante;
  final bool? visitaPresencial;
  final int initialTabSelect;
  final String? diasDg;

  static String routeName = 'cadastrarNovoAnimal';
  static String routePath = '/cadastrarNovoAnimal';

  @override
  State<CadastrarNovoAnimalWidget> createState() =>
      _CadastrarNovoAnimalWidgetState();
}

class _CadastrarNovoAnimalWidgetState extends State<CadastrarNovoAnimalWidget> {
  late CadastrarNovoAnimalModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CadastrarNovoAnimalModel());

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

    _model.nomeTextController ??= TextEditingController();
    _model.nomeFocusNode ??= FocusNode();

    _model.brincoTextController ??= TextEditingController();
    _model.brincoFocusNode ??= FocusNode();

    _model.switchValue = true;
    _model.pesoTextController ??= TextEditingController();
    _model.pesoFocusNode ??= FocusNode();

    _model.dataNascimentoTextController ??=
        TextEditingController(text: functions.obterDataAtualMenosTresAnos());
    _model.dataNascimentoFocusNode ??= FocusNode();

    _model.dataNascimentoMask = MaskTextInputFormatter(mask: '##/##/####');
    _model.touroPaiTextController ??= TextEditingController();
    _model.touroPaiFocusNode ??= FocusNode();

    _model.vacaMaeTextController ??= TextEditingController();
    _model.vacaMaeFocusNode ??= FocusNode();

    _model.dataUltimoPartoTextController ??= TextEditingController();
    _model.dataUltimoPartoFocusNode ??= FocusNode();

    _model.dataUltimoPartoMask = MaskTextInputFormatter(mask: '##/##/####');
    _model.dataUltimaInseminacaoTextController ??= TextEditingController();
    _model.dataUltimaInseminacaoFocusNode ??= FocusNode();

    _model.dataUltimaInseminacaoMask =
        MaskTextInputFormatter(mask: '##/##/####');
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

    return StreamBuilder<List<StatusAnimaisRecord>>(
      stream: FFAppState().statusAnimaisGeral(
        requestFn: () => queryStatusAnimaisRecord(),
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
        List<StatusAnimaisRecord> cadastrarNovoAnimalStatusAnimaisRecordList =
            snapshot.data!;

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
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 0.0, 0.0),
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
                                context.goNamed(
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
                                    'initialTabSelect': serializeParam(
                                      widget.initialTabSelect,
                                      ParamType.int,
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
                            'Adicionar animal',
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
            body: SafeArea(
              top: true,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: _model.formKey,
                        autovalidateMode: AutovalidateMode.always,
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                TextFormField(
                                  controller: _model.nomeTextController,
                                  focusNode: _model.nomeFocusNode,
                                  autofocus: false,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Nome*',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            16.0, 12.0, 16.0, 12.0),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primary,
                                  validator: _model.nomeTextControllerValidator
                                      .asValidator(context),
                                ),
                                TextFormField(
                                  controller: _model.brincoTextController,
                                  focusNode: _model.brincoFocusNode,
                                  autofocus: false,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Nº registro/brinco*',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            16.0, 12.0, 16.0, 12.0),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                  keyboardType: TextInputType.number,
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primary,
                                  validator: _model
                                      .brincoTextControllerValidator
                                      .asValidator(context),
                                ),
                                StreamBuilder<List<RacasRecord>>(
                                  stream: FFAppState().racasGeral(
                                    requestFn: () => queryRacasRecord(),
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
                                    List<RacasRecord> racaRacasRecordList =
                                        snapshot.data!;

                                    return FlutterFlowDropDown<String>(
                                      controller: _model.racaValueController ??=
                                          FormFieldController<String>(
                                        _model.racaValue ??= 'Holandesa',
                                      ),
                                      options: _model.respostaNet!
                                          ? racaRacasRecordList
                                              .map((e) => e.descricao)
                                              .toList()
                                          : FFAppState()
                                              .racas
                                              .map((e) => e.descricao)
                                              .toList(),
                                      onChanged: (val) => safeSetState(
                                          () => _model.racaValue = val),
                                      width: double.infinity,
                                      height: 50.0,
                                      searchHintTextStyle: FlutterFlowTheme.of(
                                              context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                      searchTextStyle: FlutterFlowTheme.of(
                                              context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                      hintText: 'Raça predominante*',
                                      searchHintText: 'Pesquise uma raça...',
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 24.0,
                                      ),
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      elevation: 2.0,
                                      borderColor: FlutterFlowTheme.of(context)
                                          .alternate,
                                      borderWidth: 2.0,
                                      borderRadius: 8.0,
                                      margin: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 4.0, 16.0, 4.0),
                                      hidesUnderline: true,
                                      isOverButton: true,
                                      isSearchable: true,
                                      isMultiSelect: false,
                                    );
                                  },
                                ),
                                StreamBuilder<List<GrupoRecord>>(
                                  stream: FFAppState().gruposGeral(
                                    requestFn: () => queryGrupoRecord(),
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
                                    List<GrupoRecord> grupoGrupoRecordList =
                                        snapshot.data!;

                                    return FlutterFlowDropDown<String>(
                                      controller:
                                          _model.grupoValueController ??=
                                              FormFieldController<String>(
                                        _model.grupoValue ??=
                                            widget.grupoPredominante,
                                      ),
                                      options: _model.respostaNet!
                                          ? grupoGrupoRecordList
                                              .map((e) => e.descricao)
                                              .toList()
                                          : FFAppState()
                                              .grupo
                                              .map((e) => e.descricao)
                                              .toList(),
                                      onChanged: (val) => safeSetState(
                                          () => _model.grupoValue = val),
                                      width: double.infinity,
                                      height: 50.0,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                      hintText: 'Grupo predominante*',
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 24.0,
                                      ),
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      elevation: 2.0,
                                      borderColor: FlutterFlowTheme.of(context)
                                          .alternate,
                                      borderWidth: 2.0,
                                      borderRadius: 8.0,
                                      margin: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 4.0, 16.0, 4.0),
                                      hidesUnderline: true,
                                      isSearchable: false,
                                      isMultiSelect: false,
                                    );
                                  },
                                ),
                                if (((widget.grupoPredominante == 'Sêmens') ||
                                        (widget.grupoPredominante ==
                                            'Touros')) ||
                                    ((_model.grupoValue == 'Touros') ||
                                        (_model.grupoValue == 'Sêmens')))
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Liberar para inseminações:',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                      Switch.adaptive(
                                        value: _model.switchValue!,
                                        onChanged: (newValue) async {
                                          safeSetState(() =>
                                              _model.switchValue = newValue);
                                        },
                                        activeColor:
                                            FlutterFlowTheme.of(context)
                                                .tertiary,
                                        activeTrackColor:
                                            FlutterFlowTheme.of(context)
                                                .alternate,
                                        inactiveTrackColor:
                                            FlutterFlowTheme.of(context)
                                                .alternate,
                                        inactiveThumbColor:
                                            FlutterFlowTheme.of(context)
                                                .secondaryText,
                                      ),
                                    ],
                                  ),
                                if (_model.grupoValue != 'Sêmens')
                                  TextFormField(
                                    controller: _model.pesoTextController,
                                    focusNode: _model.pesoFocusNode,
                                    autofocus: false,
                                    textCapitalization: TextCapitalization.none,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Peso em KG',
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              16.0, 12.0, 16.0, 12.0),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                    maxLength: 5,
                                    maxLengthEnforcement:
                                        MaxLengthEnforcement.none,
                                    buildCounter: (context,
                                            {required currentLength,
                                            required isFocused,
                                            maxLength}) =>
                                        null,
                                    keyboardType: TextInputType.number,
                                    cursorColor:
                                        FlutterFlowTheme.of(context).primary,
                                    validator: _model
                                        .pesoTextControllerValidator
                                        .asValidator(context),
                                    inputFormatters: [
                                      if (!isAndroid && !isiOS)
                                        TextInputFormatter.withFunction(
                                            (oldValue, newValue) {
                                          return TextEditingValue(
                                            selection: newValue.selection,
                                            text: newValue.text
                                                .toCapitalization(
                                                    TextCapitalization.none),
                                          );
                                        }),
                                    ],
                                  ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 8.0, 0.0),
                                        child: TextFormField(
                                          controller: _model
                                              .dataNascimentoTextController,
                                          focusNode:
                                              _model.dataNascimentoFocusNode,
                                          onChanged: (_) =>
                                              EasyDebounce.debounce(
                                            '_model.dataNascimentoTextController',
                                            Duration(milliseconds: 2000),
                                            () => safeSetState(() {}),
                                          ),
                                          autofocus: false,
                                          textCapitalization:
                                              TextCapitalization.none,
                                          textInputAction: TextInputAction.next,
                                          readOnly: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Data nascimento',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      font:
                                                          GoogleFonts.readexPro(
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
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 12.0, 16.0, 12.0),
                                            suffixIcon: _model
                                                    .dataNascimentoTextController!
                                                    .text
                                                    .isNotEmpty
                                                ? InkWell(
                                                    onTap: () async {
                                                      _model
                                                          .dataNascimentoTextController
                                                          ?.clear();
                                                      safeSetState(() {});
                                                    },
                                                    child: Icon(
                                                      Icons.clear,
                                                      size: 22.0,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.readexPro(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                          maxLength: 10,
                                          maxLengthEnforcement:
                                              MaxLengthEnforcement.enforced,
                                          buildCounter: (context,
                                                  {required currentLength,
                                                  required isFocused,
                                                  maxLength}) =>
                                              null,
                                          keyboardType: TextInputType.datetime,
                                          validator: _model
                                              .dataNascimentoTextControllerValidator
                                              .asValidator(context),
                                          inputFormatters: [
                                            _model.dataNascimentoMask
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        // calendarNascimento
                                        await showModalBottomSheet<bool>(
                                            context: context,
                                            builder: (context) {
                                              final _datePicked1CupertinoTheme =
                                                  CupertinoTheme.of(context);
                                              return ScrollConfiguration(
                                                behavior:
                                                    const MaterialScrollBehavior()
                                                        .copyWith(
                                                  dragDevices: {
                                                    PointerDeviceKind.mouse,
                                                    PointerDeviceKind.touch,
                                                    PointerDeviceKind.stylus,
                                                    PointerDeviceKind.unknown
                                                  },
                                                ),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      3,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  child: CupertinoTheme(
                                                    data:
                                                        _datePicked1CupertinoTheme
                                                            .copyWith(
                                                      textTheme:
                                                          _datePicked1CupertinoTheme
                                                              .textTheme
                                                              .copyWith(
                                                        dateTimePickerTextStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .outfit(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    ),
                                                    child: CupertinoDatePicker(
                                                      mode:
                                                          CupertinoDatePickerMode
                                                              .date,
                                                      minimumDate: (DateTime
                                                              .fromMicrosecondsSinceEpoch(
                                                                  1577847600000000) ??
                                                          DateTime(1900)),
                                                      initialDateTime: DateTime
                                                          .fromMicrosecondsSinceEpoch(
                                                              1609470000000000),
                                                      maximumDate:
                                                          (getCurrentTimestamp ??
                                                              DateTime(2050)),
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryBackground,
                                                      use24hFormat: false,
                                                      onDateTimeChanged:
                                                          (newDateTime) =>
                                                              safeSetState(() {
                                                        _model.datePicked1 =
                                                            newDateTime;
                                                      }),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                        safeSetState(() {
                                          _model.dataNascimentoTextController
                                              ?.text = dateTimeFormat(
                                            "dd/MM/yyyy",
                                            _model.datePicked1,
                                            locale: FFLocalizations.of(context)
                                                .languageCode,
                                          );
                                          _model.dataNascimentoMask.updateMask(
                                            newValue: TextEditingValue(
                                              text: _model
                                                  .dataNascimentoTextController!
                                                  .text,
                                            ),
                                          );
                                        });
                                      },
                                      child: Icon(
                                        Icons.calendar_month,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 24.0,
                                      ),
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  controller: _model.touroPaiTextController,
                                  focusNode: _model.touroPaiFocusNode,
                                  autofocus: false,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Touro (Pai)',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            16.0, 12.0, 16.0, 12.0),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primary,
                                  validator: _model
                                      .touroPaiTextControllerValidator
                                      .asValidator(context),
                                ),
                                TextFormField(
                                  controller: _model.vacaMaeTextController,
                                  focusNode: _model.vacaMaeFocusNode,
                                  autofocus: false,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Vaca (Mãe)',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            16.0, 12.0, 16.0, 12.0),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                  textAlign: TextAlign.start,
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primary,
                                  validator: _model
                                      .vacaMaeTextControllerValidator
                                      .asValidator(context),
                                ),
                                if (((_model.grupoValue == 'Vacas') ||
                                        (widget.grupoPredominante ==
                                            'Vacas')) &&
                                    (_model.statusAnimalValue != 'Seca'))
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 8.0, 0.0),
                                          child: TextFormField(
                                            controller: _model
                                                .dataUltimoPartoTextController,
                                            focusNode:
                                                _model.dataUltimoPartoFocusNode,
                                            onChanged: (_) =>
                                                EasyDebounce.debounce(
                                              '_model.dataUltimoPartoTextController',
                                              Duration(milliseconds: 2000),
                                              () => safeSetState(() {}),
                                            ),
                                            autofocus: false,
                                            textCapitalization:
                                                TextCapitalization.none,
                                            textInputAction:
                                                TextInputAction.next,
                                            readOnly: true,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: 'Último parto',
                                              hintStyle: FlutterFlowTheme.of(
                                                      context)
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
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              contentPadding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(16.0, 12.0,
                                                          16.0, 12.0),
                                              suffixIcon: _model
                                                      .dataUltimoPartoTextController!
                                                      .text
                                                      .isNotEmpty
                                                  ? InkWell(
                                                      onTap: () async {
                                                        _model
                                                            .dataUltimoPartoTextController
                                                            ?.clear();
                                                        safeSetState(() {});
                                                      },
                                                      child: Icon(
                                                        Icons.clear,
                                                        size: 22.0,
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.readexPro(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                            maxLength: 10,
                                            maxLengthEnforcement:
                                                MaxLengthEnforcement.enforced,
                                            buildCounter: (context,
                                                    {required currentLength,
                                                    required isFocused,
                                                    maxLength}) =>
                                                null,
                                            keyboardType:
                                                TextInputType.datetime,
                                            validator: _model
                                                .dataUltimoPartoTextControllerValidator
                                                .asValidator(context),
                                            inputFormatters: [
                                              _model.dataUltimoPartoMask
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          var _shouldSetState = false;
                                          // calendarUltimoParto
                                          await showModalBottomSheet<bool>(
                                              context: context,
                                              builder: (context) {
                                                final _datePicked2CupertinoTheme =
                                                    CupertinoTheme.of(context);
                                                return ScrollConfiguration(
                                                  behavior:
                                                      const MaterialScrollBehavior()
                                                          .copyWith(
                                                    dragDevices: {
                                                      PointerDeviceKind.mouse,
                                                      PointerDeviceKind.touch,
                                                      PointerDeviceKind.stylus,
                                                      PointerDeviceKind.unknown
                                                    },
                                                  ),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            3,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    child: CupertinoTheme(
                                                      data:
                                                          _datePicked2CupertinoTheme
                                                              .copyWith(
                                                        textTheme:
                                                            _datePicked2CupertinoTheme
                                                                .textTheme
                                                                .copyWith(
                                                          dateTimePickerTextStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .outfit(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .headlineMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .headlineMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineMedium
                                                                        .fontStyle,
                                                                  ),
                                                        ),
                                                      ),
                                                      child:
                                                          CupertinoDatePicker(
                                                        mode:
                                                            CupertinoDatePickerMode
                                                                .date,
                                                        minimumDate:
                                                            DateTime(1900),
                                                        initialDateTime:
                                                            getCurrentTimestamp,
                                                        maximumDate:
                                                            (getCurrentTimestamp ??
                                                                DateTime(2050)),
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryBackground,
                                                        use24hFormat: false,
                                                        onDateTimeChanged:
                                                            (newDateTime) =>
                                                                safeSetState(
                                                                    () {
                                                          _model.datePicked2 =
                                                              newDateTime;
                                                        }),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                          safeSetState(() {
                                            _model.dataUltimoPartoTextController
                                                ?.text = dateTimeFormat(
                                              "dd/MM/yyyy",
                                              _model.datePicked2,
                                              locale:
                                                  FFLocalizations.of(context)
                                                      .languageCode,
                                            );
                                            _model.dataUltimoPartoMask
                                                .updateMask(
                                              newValue: TextEditingValue(
                                                text: _model
                                                    .dataUltimoPartoTextController!
                                                    .text,
                                              ),
                                            );
                                          });
                                          if (_model.datePicked2! >
                                              _model.datePicked3!) {
                                            safeSetState(() {
                                              _model.statusAnimalValueController
                                                  ?.value = 'Vazia';
                                              _model.statusAnimalValue =
                                                  'Vazia';
                                            });
                                            if (_shouldSetState)
                                              safeSetState(() {});
                                            return;
                                          } else {
                                            _model.outListaAnimais =
                                                await queryStatusAnimaisRecordOnce();
                                            _shouldSetState = true;
                                            safeSetState(() {
                                              _model.statusAnimalValueController
                                                  ?.value = (_model
                                                              .outListaAnimais !=
                                                          null &&
                                                      (_model.outListaAnimais)!
                                                          .isNotEmpty)
                                                  .toString();
                                              _model.statusAnimalValue = (_model
                                                              .outListaAnimais !=
                                                          null &&
                                                      (_model.outListaAnimais)!
                                                          .isNotEmpty)
                                                  .toString();
                                            });
                                            safeSetState(() {
                                              _model.statusAnimalValueController
                                                  ?.value = 'Inseminada';
                                              _model.statusAnimalValue =
                                                  'Inseminada';
                                            });
                                            if (_shouldSetState)
                                              safeSetState(() {});
                                            return;
                                          }

                                          if (_shouldSetState)
                                            safeSetState(() {});
                                        },
                                        child: Icon(
                                          Icons.calendar_month,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (((_model.grupoValue == 'Vacas') ||
                                        (_model.grupoValue == 'Novilhas')) ||
                                    ((widget.grupoPredominante ==
                                            'Novilhas') ||
                                        (widget.grupoPredominante == 'Vacas')))
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 8.0, 0.0),
                                          child: TextFormField(
                                            controller: _model
                                                .dataUltimaInseminacaoTextController,
                                            focusNode: _model
                                                .dataUltimaInseminacaoFocusNode,
                                            onChanged: (_) =>
                                                EasyDebounce.debounce(
                                              '_model.dataUltimaInseminacaoTextController',
                                              Duration(milliseconds: 2000),
                                              () => safeSetState(() {}),
                                            ),
                                            autofocus: false,
                                            textCapitalization:
                                                TextCapitalization.none,
                                            textInputAction:
                                                TextInputAction.next,
                                            readOnly: true,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: 'Última inseminação',
                                              labelStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.readexPro(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                              hintStyle: FlutterFlowTheme.of(
                                                      context)
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
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              contentPadding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(16.0, 12.0,
                                                          16.0, 12.0),
                                              suffixIcon: _model
                                                      .dataUltimaInseminacaoTextController!
                                                      .text
                                                      .isNotEmpty
                                                  ? InkWell(
                                                      onTap: () async {
                                                        _model
                                                            .dataUltimaInseminacaoTextController
                                                            ?.clear();
                                                        safeSetState(() {});
                                                      },
                                                      child: Icon(
                                                        Icons.clear,
                                                        size: 22.0,
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.readexPro(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                            maxLength: 10,
                                            maxLengthEnforcement:
                                                MaxLengthEnforcement.enforced,
                                            buildCounter: (context,
                                                    {required currentLength,
                                                    required isFocused,
                                                    maxLength}) =>
                                                null,
                                            keyboardType:
                                                TextInputType.datetime,
                                            validator: _model
                                                .dataUltimaInseminacaoTextControllerValidator
                                                .asValidator(context),
                                            inputFormatters: [
                                              _model.dataUltimaInseminacaoMask
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          // calendarUltimoParto
                                          await showModalBottomSheet<bool>(
                                              context: context,
                                              builder: (context) {
                                                final _datePicked3CupertinoTheme =
                                                    CupertinoTheme.of(context);
                                                return ScrollConfiguration(
                                                  behavior:
                                                      const MaterialScrollBehavior()
                                                          .copyWith(
                                                    dragDevices: {
                                                      PointerDeviceKind.mouse,
                                                      PointerDeviceKind.touch,
                                                      PointerDeviceKind.stylus,
                                                      PointerDeviceKind.unknown
                                                    },
                                                  ),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            3,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    child: CupertinoTheme(
                                                      data:
                                                          _datePicked3CupertinoTheme
                                                              .copyWith(
                                                        textTheme:
                                                            _datePicked3CupertinoTheme
                                                                .textTheme
                                                                .copyWith(
                                                          dateTimePickerTextStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .outfit(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .headlineMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .headlineMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineMedium
                                                                        .fontStyle,
                                                                  ),
                                                        ),
                                                      ),
                                                      child:
                                                          CupertinoDatePicker(
                                                        mode:
                                                            CupertinoDatePickerMode
                                                                .date,
                                                        minimumDate:
                                                            DateTime(1900),
                                                        initialDateTime:
                                                            getCurrentTimestamp,
                                                        maximumDate:
                                                            (getCurrentTimestamp ??
                                                                DateTime(2050)),
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryBackground,
                                                        use24hFormat: false,
                                                        onDateTimeChanged:
                                                            (newDateTime) =>
                                                                safeSetState(
                                                                    () {
                                                          _model.datePicked3 =
                                                              newDateTime;
                                                        }),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                          safeSetState(() {
                                            _model
                                                .dataUltimaInseminacaoTextController
                                                ?.text = dateTimeFormat(
                                              "dd/MM/yyyy",
                                              _model.datePicked3,
                                              locale:
                                                  FFLocalizations.of(context)
                                                      .languageCode,
                                            );
                                            _model.dataUltimaInseminacaoMask
                                                .updateMask(
                                              newValue: TextEditingValue(
                                                text: _model
                                                    .dataUltimaInseminacaoTextController!
                                                    .text,
                                              ),
                                            );
                                          });
                                          if ((_model.dataUltimaInseminacaoTextController
                                                          .text !=
                                                      '') &&
                                              (_model.dataUltimoPartoTextController
                                                          .text !=
                                                      '')) {
                                            if (_model.datePicked2! >
                                                _model.datePicked3!) {
                                              safeSetState(() {
                                                _model
                                                    .statusAnimalValueController
                                                    ?.value = 'Vazia';
                                                _model.statusAnimalValue =
                                                    'Vazia';
                                              });
                                              return;
                                            } else {
                                              safeSetState(() {
                                                _model
                                                    .statusAnimalValueController
                                                    ?.value = 'Inseminada';
                                                _model.statusAnimalValue =
                                                    'Inseminada';
                                              });
                                              return;
                                            }
                                          } else {
                                            safeSetState(() {
                                              _model.statusAnimalValueController
                                                  ?.value = 'Inseminada';
                                              _model.statusAnimalValue =
                                                  'Inseminada';
                                            });
                                            return;
                                          }
                                        },
                                        child: Icon(
                                          Icons.calendar_month,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (((_model.grupoValue == 'Vacas') ||
                                        (_model.grupoValue == 'Novilhas')) &&
                                    (_model.dataUltimaInseminacaoTextController
                                                .text !=
                                            ''))
                                  StreamBuilder<List<AnimaisProdutoresRecord>>(
                                    stream: _model.animaisLiberaoParaInseminar(
                                      requestFn: () =>
                                          queryAnimaisProdutoresRecord(
                                        parent: widget.uidTecnico,
                                        queryBuilder:
                                            (animaisProdutoresRecord) =>
                                                animaisProdutoresRecord
                                                    .where(
                                                      'uidTecnicoPropriedade',
                                                      isEqualTo: widget
                                                          .uidPropriedade,
                                                    )
                                                    .where(
                                                      'liberaInseminacao',
                                                      isEqualTo: true,
                                                    ),
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
                                          touroInseminacaoAnimaisProdutoresRecordList =
                                          snapshot.data!;

                                      return FlutterFlowDropDown<String>(
                                        controller: _model
                                                .touroInseminacaoValueController ??=
                                            FormFieldController<String>(null),
                                        options: functions.duasListasEmUma(
                                            touroInseminacaoAnimaisProdutoresRecordList
                                                .map((e) => e.nomeBrincoConcat)
                                                .toList(),
                                            FFAppState()
                                                .animaisProdutoresOffline
                                                .where((e) =>
                                                    (e.uidTecnicoPropriedade ==
                                                        widget
                                                            .uidPropriedade) &&
                                                    (e.liberaInseminacao ==
                                                        true))
                                                .toList()
                                                .map((e) => e.nomeBrincoConcat)
                                                .toList())!,
                                        onChanged: (val) => safeSetState(() =>
                                            _model.touroInseminacaoValue = val),
                                        width: double.infinity,
                                        height: 50.0,
                                        searchHintTextStyle: FlutterFlowTheme
                                                .of(context)
                                            .labelMedium
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                        searchTextStyle: FlutterFlowTheme.of(
                                                context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                        hintText: 'Touro/sêmen inseminação',
                                        searchHintText:
                                            'Digite para pesquisar...',
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        elevation: 2.0,
                                        borderColor:
                                            FlutterFlowTheme.of(context)
                                                .alternate,
                                        borderWidth: 2.0,
                                        borderRadius: 8.0,
                                        margin: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 4.0, 16.0, 4.0),
                                        hidesUnderline: true,
                                        isSearchable: true,
                                        isMultiSelect: false,
                                      );
                                    },
                                  ),
                                if (((widget.grupoPredominante ==
                                            'Novilhas') ||
                                        (widget.grupoPredominante ==
                                            'Vacas')) ||
                                    ((_model.grupoValue == 'Vacas') ||
                                        (_model.grupoValue == 'Novilhas')))
                                  FlutterFlowDropDown<String>(
                                    controller:
                                        _model.statusAnimalValueController ??=
                                            FormFieldController<String>(
                                      _model.statusAnimalValue ??= 'Vazia',
                                    ),
                                    options: () {
                                      if ((_model.dataUltimaInseminacaoTextController.text != '') &&
                                          (_model.dataUltimoPartoTextController.text !=
                                                  '') &&
                                          (_model.datePicked2! >
                                              _model.datePicked3!)) {
                                        return cadastrarNovoAnimalStatusAnimaisRecordList
                                            .map((e) => e.descricao)
                                            .toList()
                                            .where((e) => e == 'Vazia')
                                            .toList();
                                      } else if ((_model.dataUltimaInseminacaoTextController.text != '') &&
                                          (_model.dataUltimoPartoTextController.text !=
                                                  '') &&
                                          (_model.datePicked2! <
                                              _model.datePicked3!)) {
                                        return cadastrarNovoAnimalStatusAnimaisRecordList
                                            .map((e) => e.descricao)
                                            .toList()
                                            .where((e) =>
                                                (e == 'Inseminada') ||
                                                (e == 'Prenha') ||
                                                (e == 'Seca') ||
                                                (e == 'Inseminada PP') ||
                                                (e == 'Pré Parto'))
                                            .toList();
                                      } else if ((_model.dataUltimaInseminacaoTextController.text !=
                                                  '') &&
                                          (_model.dataUltimoPartoTextController.text ==
                                                  '')) {
                                        return functions.retornaStringEmLista(_model
                                                    .grupoValue ==
                                                'Novilhas'
                                            ? 'Inseminada, Inseminada PP, Prenha, Pré Parto'
                                            : 'Inseminada, Inseminada PP, Prenha, Seca, Pré Parto');
                                      } else if ((_model.dataUltimaInseminacaoTextController.text ==
                                                  '') &&
                                          (_model.dataUltimoPartoTextController.text != '')) {
                                        return cadastrarNovoAnimalStatusAnimaisRecordList
                                            .map((e) => e.descricao)
                                            .toList()
                                            .where((e) => e == 'Vazia')
                                            .toList();
                                      } else {
                                        return functions
                                            .retornaStringEmLista('Vazia');
                                      }
                                    }(),
                                    onChanged: (val) => safeSetState(
                                        () => _model.statusAnimalValue = val),
                                    width: double.infinity,
                                    height: 50.0,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                    hintText: 'Status animal',
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 24.0,
                                    ),
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    elevation: 2.0,
                                    borderColor:
                                        FlutterFlowTheme.of(context).alternate,
                                    borderWidth: 2.0,
                                    borderRadius: 8.0,
                                    margin: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 4.0, 16.0, 4.0),
                                    hidesUnderline: true,
                                    isSearchable: false,
                                    isMultiSelect: false,
                                  ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 24.0, 0.0, 12.0),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      var _shouldSetState = false;
                                      if (_model.respostaNet!) {
                                        if (FFAppState()
                                                .animaisProdutoresOffline
                                                .length ==
                                            0) {
                                          if (_model.formKey.currentState ==
                                                  null ||
                                              !_model.formKey.currentState!
                                                  .validate()) {
                                            return;
                                          }
                                          if (_model.racaValue == null) {
                                            return;
                                          }
                                          if (_model.grupoValue == null) {
                                            return;
                                          }
                                          _model.outListaAnimaisVerificaNome =
                                              await queryAnimaisProdutoresRecordOnce(
                                            parent: widget.uidTecnico,
                                            queryBuilder:
                                                (animaisProdutoresRecord) =>
                                                    animaisProdutoresRecord
                                                        .where(
                                                          'uidTecnicoPropriedade',
                                                          isEqualTo: widget
                                                              .uidPropriedade,
                                                        )
                                                        .where(
                                                          'nomeAnimal',
                                                          isEqualTo: _model
                                                              .nomeTextController
                                                              .text,
                                                        ),
                                          );
                                          _shouldSetState = true;
                                          _model.outListaAnimaisVerificaBrinco =
                                              await queryAnimaisProdutoresRecordOnce(
                                            parent: widget.uidTecnico,
                                            queryBuilder:
                                                (animaisProdutoresRecord) =>
                                                    animaisProdutoresRecord
                                                        .where(
                                                          'uidTecnicoPropriedade',
                                                          isEqualTo: widget
                                                              .uidPropriedade,
                                                        )
                                                        .where(
                                                          'brincoAnimal',
                                                          isEqualTo: int
                                                              .tryParse(_model
                                                                  .brincoTextController
                                                                  .text),
                                                        ),
                                          );
                                          _shouldSetState = true;
                                          if ((_model.outListaAnimaisVerificaNome!
                                                      .length >
                                                  0) &&
                                              (_model.outListaAnimaisVerificaBrinco!
                                                      .length >
                                                  0)) {
                                            await showDialog(
                                              context: context,
                                              builder: (alertDialogContext) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Nome ou brinco já existe.'),
                                                  content: Text(
                                                      'Digite outro nome ou brinco.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              alertDialogContext),
                                                      child: Text('Ok'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            if (_shouldSetState)
                                              safeSetState(() {});
                                            return;
                                          }
                                          if ((_model.nomeTextController
                                                          .text !=
                                                      '') ||
                                              (_model.brincoTextController
                                                          .text !=
                                                      '')) {
                                            if (_model.dataUltimaInseminacaoTextController
                                                        .text !=
                                                    '') {
                                              if (!(_model.touroInseminacaoValue !=
                                                      null &&
                                                  _model.touroInseminacaoValue !=
                                                      '')) {
                                                await showDialog(
                                                  context: context,
                                                  builder:
                                                      (alertDialogContext) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Touro inseminação não selecionado.'),
                                                      content: Text(
                                                          'Selecione o touro usado.'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  alertDialogContext),
                                                          child: Text('Ok'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                if (_shouldSetState)
                                                  safeSetState(() {});
                                                return;
                                              }
                                            }
                                          } else {
                                            await showDialog(
                                              context: context,
                                              builder: (alertDialogContext) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Nome ou brinco obrigatório.'),
                                                  content: Text(
                                                      'Preencha ao menos um dos campos.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              alertDialogContext),
                                                      child: Text('Ok'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            if (_shouldSetState)
                                              safeSetState(() {});
                                            return;
                                          }

                                          if ((_model.grupoValue == 'Vacas') ||
                                              (_model.grupoValue ==
                                                  'Novilhas')) {
                                            if (_model.statusAnimalValue !=
                                                    null &&
                                                _model.statusAnimalValue !=
                                                    '') {
                                              if (_model.statusAnimalValue ==
                                                  'Inseminada') {
                                                if ((_model.dataUltimaInseminacaoTextController.text != '') &&
                                                    (_model.dataUltimoPartoTextController
                                                                .text ==
                                                            '') &&
                                                    (_model.touroInseminacaoValue !=
                                                            null &&
                                                        _model.touroInseminacaoValue !=
                                                            '')) {
                                                  await AnimaisProdutoresRecord
                                                          .createDoc(widget
                                                              .uidTecnico!)
                                                      .set(
                                                          createAnimaisProdutoresRecordData(
                                                    uidTecnicoPropriedade:
                                                        widget.uidPropriedade,
                                                    nomeAnimal: _model
                                                        .nomeTextController
                                                        .text,
                                                    brincoAnimal: _model.brincoTextController
                                                                    .text !=
                                                                ''
                                                        ? int.tryParse(_model
                                                            .brincoTextController
                                                            .text)
                                                        : -1,
                                                    racaAnimal:
                                                        _model.racaValue,
                                                    pesoAnimal: _model
                                                        .pesoTextController
                                                        .text,
                                                    dtNascimento: _model
                                                        .dataNascimentoTextController
                                                        .text,
                                                    touro: _model
                                                        .touroPaiTextController
                                                        .text,
                                                    vaca: _model
                                                        .vacaMaeTextController
                                                        .text,
                                                    status: _model
                                                        .statusAnimalValue,
                                                    dtUltimaInseminacao: _model
                                                        .dataUltimaInseminacaoTextController
                                                        .text,
                                                    grupoAnimal:
                                                        _model.grupoValue,
                                                    nomeTouroUltimaInseminacao:
                                                        _model
                                                            .touroInseminacaoValue,
                                                    dtPartoPrevisto: functions
                                                        .somarDataParto(_model
                                                            .dataUltimaInseminacaoTextController
                                                            .text),
                                                    dtSecPrevista: functions
                                                        .somarDataSecagem(_model
                                                            .dataUltimaInseminacaoTextController
                                                            .text),
                                                    dtPrePartoPrevista: functions
                                                        .somarDataPreParto(_model
                                                            .dataUltimaInseminacaoTextController
                                                            .text),
                                                    totalInseminacoes: 1,
                                                    compararDtUltimaInseminacao:
                                                        functions
                                                            .converterDataUltimaInseminacao(
                                                                _model
                                                                    .dataUltimaInseminacaoTextController
                                                                    .text),
                                                    nomeBrincoConcat: () {
                                                      if ((_model.nomeTextController.text != '') &&
                                                          (_model.brincoTextController
                                                                      .text !=
                                                                  '') &&
                                                          (_model.brincoTextController
                                                                  .text !=
                                                              '-1')) {
                                                        return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                                      } else if (_model.nomeTextController
                                                                  .text !=
                                                              '') {
                                                        return _model
                                                            .nomeTextController
                                                            .text;
                                                      } else {
                                                        return _model
                                                            .brincoTextController
                                                            .text;
                                                      }
                                                    }(),
                                                    idStatusAnimal: 3,
                                                    brincoAnimalOrder: _model.brincoTextController
                                                                    .text !=
                                                                ''
                                                        ? int.tryParse(_model
                                                            .brincoTextController
                                                            .text)
                                                        : 999999,
                                                  ));

                                                  await widget.uidTecnico!
                                                      .update({
                                                    ...mapToFirestore(
                                                      {
                                                        'quantidadeAnimaisCadastrados':
                                                            FieldValue
                                                                .increment(1),
                                                        'restanteLimiteAnimais':
                                                            FieldValue
                                                                .increment(
                                                                    -(1)),
                                                      },
                                                    ),
                                                  });
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Animal cadastrado com sucesso!',
                                                        style: TextStyle(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                        ),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                  );
                                                  if (Navigator.of(context)
                                                      .canPop()) {
                                                    context.pop();
                                                  }
                                                  context.pushNamed(
                                                    ListaAnimaisWidget
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
                                                        widget
                                                            .emailPropriedade,
                                                        ParamType.String,
                                                      ),
                                                      'visitaPresencial':
                                                          serializeParam(
                                                        widget
                                                            .visitaPresencial,
                                                        ParamType.bool,
                                                      ),
                                                      'initialTabSelect':
                                                          serializeParam(
                                                        widget
                                                            .initialTabSelect,
                                                        ParamType.int,
                                                      ),
                                                      'diasDg': serializeParam(
                                                        widget.diasDg,
                                                        ParamType.String,
                                                      ),
                                                      'tabBarOpenSelected':
                                                          serializeParam(
                                                        0,
                                                        ParamType.int,
                                                      ),
                                                    }.withoutNulls,
                                                  );

                                                  if (_shouldSetState)
                                                    safeSetState(() {});
                                                  return;
                                                } else {
                                                  if ((_model.dataUltimoPartoTextController.text != '') &&
                                                      (_model.dataUltimaInseminacaoTextController
                                                                  .text !=
                                                              '') &&
                                                      (_model.touroInseminacaoValue !=
                                                              null &&
                                                          _model.touroInseminacaoValue !=
                                                              '')) {
                                                    await AnimaisProdutoresRecord
                                                            .createDoc(widget
                                                                .uidTecnico!)
                                                        .set(
                                                            createAnimaisProdutoresRecordData(
                                                      uidTecnicoPropriedade:
                                                          widget
                                                              .uidPropriedade,
                                                      nomeAnimal: _model
                                                          .nomeTextController
                                                          .text,
                                                      brincoAnimal: _model.brincoTextController
                                                                      .text !=
                                                                  ''
                                                          ? int.tryParse(_model
                                                              .brincoTextController
                                                              .text)
                                                          : -1,
                                                      racaAnimal:
                                                          _model.racaValue,
                                                      pesoAnimal: _model
                                                          .pesoTextController
                                                          .text,
                                                      dtNascimento: _model
                                                          .dataNascimentoTextController
                                                          .text,
                                                      touro: _model
                                                          .touroPaiTextController
                                                          .text,
                                                      vaca: _model
                                                          .vacaMaeTextController
                                                          .text,
                                                      status: _model
                                                          .statusAnimalValue,
                                                      dtUltimaInseminacao: _model
                                                          .dataUltimaInseminacaoTextController
                                                          .text,
                                                      dtUltimoParto: _model
                                                          .dataUltimoPartoTextController
                                                          .text,
                                                      grupoAnimal:
                                                          _model.grupoValue,
                                                      nomeTouroUltimaInseminacao:
                                                          _model
                                                              .touroInseminacaoValue,
                                                      dtPartoPrevisto: functions
                                                          .somarDataParto(_model
                                                              .dataUltimaInseminacaoTextController
                                                              .text),
                                                      dtSecPrevista: functions
                                                          .somarDataSecagem(_model
                                                              .dataUltimaInseminacaoTextController
                                                              .text),
                                                      dtPrePartoPrevista: functions
                                                          .somarDataPreParto(_model
                                                              .dataUltimaInseminacaoTextController
                                                              .text),
                                                      totalInseminacoes: 1,
                                                      totalPartos: 1,
                                                      compararDtUltimaInseminacao:
                                                          functions
                                                              .converterDataUltimaInseminacao(
                                                                  _model
                                                                      .dataUltimaInseminacaoTextController
                                                                      .text),
                                                      nomeBrincoConcat: () {
                                                        if ((_model.nomeTextController.text != '') &&
                                                            (_model.brincoTextController
                                                                        .text !=
                                                                    '') &&
                                                            (_model.brincoTextController
                                                                    .text !=
                                                                '-1')) {
                                                          return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                                        } else if (_model.nomeTextController
                                                                    .text !=
                                                                '') {
                                                          return _model
                                                              .nomeTextController
                                                              .text;
                                                        } else {
                                                          return _model
                                                              .brincoTextController
                                                              .text;
                                                        }
                                                      }(),
                                                      idStatusAnimal: 3,
                                                      dtUltimoPartoContingencia:
                                                          _model
                                                              .dataUltimoPartoTextController
                                                              .text,
                                                      brincoAnimalOrder: _model.brincoTextController
                                                                      .text !=
                                                                  ''
                                                          ? int.tryParse(_model
                                                              .brincoTextController
                                                              .text)
                                                          : 999999,
                                                    ));

                                                    await widget.uidTecnico!
                                                        .update({
                                                      ...mapToFirestore(
                                                        {
                                                          'quantidadeAnimaisCadastrados':
                                                              FieldValue
                                                                  .increment(1),
                                                          'restanteLimiteAnimais':
                                                              FieldValue
                                                                  .increment(
                                                                      -(1)),
                                                        },
                                                      ),
                                                    });
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Animal cadastrado com sucesso!',
                                                          style: TextStyle(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                          ),
                                                        ),
                                                        duration: Duration(
                                                            milliseconds: 4000),
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                      ),
                                                    );
                                                    if (Navigator.of(context)
                                                        .canPop()) {
                                                      context.pop();
                                                    }
                                                    context.pushNamed(
                                                      ListaAnimaisWidget
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
                                                        'visitaPresencial':
                                                            serializeParam(
                                                          widget
                                                              .visitaPresencial,
                                                          ParamType.bool,
                                                        ),
                                                        'initialTabSelect':
                                                            serializeParam(
                                                          widget
                                                              .initialTabSelect,
                                                          ParamType.int,
                                                        ),
                                                        'diasDg':
                                                            serializeParam(
                                                          widget.diasDg,
                                                          ParamType.String,
                                                        ),
                                                        'tabBarOpenSelected':
                                                            serializeParam(
                                                          0,
                                                          ParamType.int,
                                                        ),
                                                      }.withoutNulls,
                                                    );

                                                    if (_shouldSetState)
                                                      safeSetState(() {});
                                                    return;
                                                  } else {
                                                    if (_shouldSetState)
                                                      safeSetState(() {});
                                                    return;
                                                  }
                                                }
                                              } else {
                                                if (_model.statusAnimalValue ==
                                                    'Seca') {
                                                  if (_model.grupoValue ==
                                                      'Vacas') {
                                                    await AnimaisProdutoresRecord
                                                            .createDoc(widget
                                                                .uidTecnico!)
                                                        .set(
                                                            createAnimaisProdutoresRecordData(
                                                      uidTecnicoPropriedade:
                                                          widget
                                                              .uidPropriedade,
                                                      nomeAnimal: _model
                                                          .nomeTextController
                                                          .text,
                                                      brincoAnimal: _model.brincoTextController
                                                                      .text !=
                                                                  ''
                                                          ? int.tryParse(_model
                                                              .brincoTextController
                                                              .text)
                                                          : -1,
                                                      racaAnimal:
                                                          _model.racaValue,
                                                      pesoAnimal: _model
                                                          .pesoTextController
                                                          .text,
                                                      dtNascimento: _model
                                                          .dataNascimentoTextController
                                                          .text,
                                                      touro: _model
                                                          .touroPaiTextController
                                                          .text,
                                                      vaca: _model
                                                          .vacaMaeTextController
                                                          .text,
                                                      status: _model
                                                          .statusAnimalValue,
                                                      dtUltimaInseminacao: _model
                                                          .dataUltimaInseminacaoTextController
                                                          .text,
                                                      grupoAnimal:
                                                          _model.grupoValue,
                                                      dtPartoPrevisto: functions
                                                          .somarDataParto(_model
                                                              .dataUltimaInseminacaoTextController
                                                              .text),
                                                      dtSecPrevista: functions
                                                          .somarDataSecagem(_model
                                                              .dataUltimaInseminacaoTextController
                                                              .text),
                                                      dtPrePartoPrevista: functions
                                                          .somarDataPreParto(_model
                                                              .dataUltimaInseminacaoTextController
                                                              .text),
                                                      nomeTouroUltimaInseminacao:
                                                          _model
                                                              .touroInseminacaoValue,
                                                      compararDtUltimaInseminacao:
                                                          functions
                                                              .converterDataUltimaInseminacao(
                                                                  _model
                                                                      .dataUltimaInseminacaoTextController
                                                                      .text),
                                                      nomeBrincoConcat: () {
                                                        if ((_model.nomeTextController.text != '') &&
                                                            (_model.brincoTextController
                                                                        .text !=
                                                                    '') &&
                                                            (_model.brincoTextController
                                                                    .text !=
                                                                '-1')) {
                                                          return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                                        } else if (_model.nomeTextController
                                                                    .text !=
                                                                '') {
                                                          return _model
                                                              .nomeTextController
                                                              .text;
                                                        } else {
                                                          return _model
                                                              .brincoTextController
                                                              .text;
                                                        }
                                                      }(),
                                                      idStatusAnimal: 4,
                                                      brincoAnimalOrder: _model.brincoTextController
                                                                      .text !=
                                                                  ''
                                                          ? int.tryParse(_model
                                                              .brincoTextController
                                                              .text)
                                                          : 999999,
                                                    ));

                                                    await widget.uidTecnico!
                                                        .update({
                                                      ...mapToFirestore(
                                                        {
                                                          'quantidadeAnimaisCadastrados':
                                                              FieldValue
                                                                  .increment(1),
                                                          'restanteLimiteAnimais':
                                                              FieldValue
                                                                  .increment(
                                                                      -(1)),
                                                        },
                                                      ),
                                                    });
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Animal cadastrado com sucesso!',
                                                          style: TextStyle(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                          ),
                                                        ),
                                                        duration: Duration(
                                                            milliseconds: 4000),
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                      ),
                                                    );
                                                    if (Navigator.of(context)
                                                        .canPop()) {
                                                      context.pop();
                                                    }
                                                    context.pushNamed(
                                                      ListaAnimaisWidget
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
                                                        'visitaPresencial':
                                                            serializeParam(
                                                          widget
                                                              .visitaPresencial,
                                                          ParamType.bool,
                                                        ),
                                                        'initialTabSelect':
                                                            serializeParam(
                                                          widget
                                                              .initialTabSelect,
                                                          ParamType.int,
                                                        ),
                                                        'diasDg':
                                                            serializeParam(
                                                          widget.diasDg,
                                                          ParamType.String,
                                                        ),
                                                        'tabBarOpenSelected':
                                                            serializeParam(
                                                          0,
                                                          ParamType.int,
                                                        ),
                                                      }.withoutNulls,
                                                    );

                                                    if (_shouldSetState)
                                                      safeSetState(() {});
                                                    return;
                                                  } else {
                                                    await showDialog(
                                                      context: context,
                                                      builder:
                                                          (alertDialogContext) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'O status de \"Seca\" é permitido somente em vacas.'),
                                                          content: Text(
                                                              'Atualize o status.'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      alertDialogContext),
                                                              child: Text('Ok'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                    if (_shouldSetState)
                                                      safeSetState(() {});
                                                    return;
                                                  }
                                                } else {
                                                  if (_model
                                                          .statusAnimalValue ==
                                                      'Vazia') {
                                                    await AnimaisProdutoresRecord
                                                            .createDoc(widget
                                                                .uidTecnico!)
                                                        .set(
                                                            createAnimaisProdutoresRecordData(
                                                      uidTecnicoPropriedade:
                                                          widget
                                                              .uidPropriedade,
                                                      nomeAnimal: _model
                                                          .nomeTextController
                                                          .text,
                                                      brincoAnimal: _model.brincoTextController
                                                                      .text !=
                                                                  ''
                                                          ? int.tryParse(_model
                                                              .brincoTextController
                                                              .text)
                                                          : -1,
                                                      racaAnimal:
                                                          _model.racaValue,
                                                      pesoAnimal: _model
                                                          .pesoTextController
                                                          .text,
                                                      dtNascimento: _model
                                                          .dataNascimentoTextController
                                                          .text,
                                                      touro: _model
                                                          .touroPaiTextController
                                                          .text,
                                                      vaca: _model
                                                          .vacaMaeTextController
                                                          .text,
                                                      status: _model
                                                          .statusAnimalValue,
                                                      grupoAnimal:
                                                          _model.grupoValue,
                                                      dtUltimoParto: _model
                                                          .dataUltimoPartoTextController
                                                          .text,
                                                      totalPartos: _model.dataUltimoPartoTextController
                                                                      .text !=
                                                                  ''
                                                          ? 1
                                                          : 0,
                                                      nomeBrincoConcat: () {
                                                        if ((_model.nomeTextController.text != '') &&
                                                            (_model.brincoTextController
                                                                        .text !=
                                                                    '') &&
                                                            (_model.brincoTextController
                                                                    .text !=
                                                                '-1')) {
                                                          return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                                        } else if (_model.nomeTextController
                                                                    .text !=
                                                                '') {
                                                          return _model
                                                              .nomeTextController
                                                              .text;
                                                        } else {
                                                          return _model
                                                              .brincoTextController
                                                              .text;
                                                        }
                                                      }(),
                                                      idStatusAnimal: 2,
                                                      dtUltimoPartoContingencia:
                                                          _model
                                                              .dataUltimoPartoTextController
                                                              .text,
                                                      brincoAnimalOrder: _model.brincoTextController
                                                                      .text !=
                                                                  ''
                                                          ? int.tryParse(_model
                                                              .brincoTextController
                                                              .text)
                                                          : 999999,
                                                    ));

                                                    await widget.uidTecnico!
                                                        .update({
                                                      ...mapToFirestore(
                                                        {
                                                          'quantidadeAnimaisCadastrados':
                                                              FieldValue
                                                                  .increment(1),
                                                          'restanteLimiteAnimais':
                                                              FieldValue
                                                                  .increment(
                                                                      -(1)),
                                                        },
                                                      ),
                                                    });
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Animal cadastrado com sucesso!',
                                                          style: TextStyle(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                          ),
                                                        ),
                                                        duration: Duration(
                                                            milliseconds: 4000),
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                      ),
                                                    );
                                                    if (Navigator.of(context)
                                                        .canPop()) {
                                                      context.pop();
                                                    }
                                                    context.pushNamed(
                                                      ListaAnimaisWidget
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
                                                        'visitaPresencial':
                                                            serializeParam(
                                                          widget
                                                              .visitaPresencial,
                                                          ParamType.bool,
                                                        ),
                                                        'initialTabSelect':
                                                            serializeParam(
                                                          widget
                                                              .initialTabSelect,
                                                          ParamType.int,
                                                        ),
                                                        'diasDg':
                                                            serializeParam(
                                                          widget.diasDg,
                                                          ParamType.String,
                                                        ),
                                                        'tabBarOpenSelected':
                                                            serializeParam(
                                                          0,
                                                          ParamType.int,
                                                        ),
                                                      }.withoutNulls,
                                                    );

                                                    if (_shouldSetState)
                                                      safeSetState(() {});
                                                    return;
                                                  } else {
                                                    if (_model
                                                            .statusAnimalValue ==
                                                        'Prenha') {
                                                      if ((_model.dataUltimaInseminacaoTextController
                                                                      .text !=
                                                                  '') &&
                                                          (_model.touroInseminacaoValue !=
                                                                  null &&
                                                              _model.touroInseminacaoValue !=
                                                                  '')) {
                                                        await AnimaisProdutoresRecord
                                                                .createDoc(widget
                                                                    .uidTecnico!)
                                                            .set(
                                                                createAnimaisProdutoresRecordData(
                                                          uidTecnicoPropriedade:
                                                              widget
                                                                  .uidPropriedade,
                                                          nomeAnimal: _model
                                                              .nomeTextController
                                                              .text,
                                                          brincoAnimal: _model.brincoTextController
                                                                          .text !=
                                                                      ''
                                                              ? int.tryParse(_model
                                                                  .brincoTextController
                                                                  .text)
                                                              : -1,
                                                          racaAnimal:
                                                              _model.racaValue,
                                                          pesoAnimal: _model
                                                              .pesoTextController
                                                              .text,
                                                          dtNascimento: _model
                                                              .dataNascimentoTextController
                                                              .text,
                                                          touro: _model
                                                              .touroPaiTextController
                                                              .text,
                                                          vaca: _model
                                                              .vacaMaeTextController
                                                              .text,
                                                          status: _model
                                                              .statusAnimalValue,
                                                          dtUltimaInseminacao:
                                                              _model
                                                                  .dataUltimaInseminacaoTextController
                                                                  .text,
                                                          grupoAnimal:
                                                              _model.grupoValue,
                                                          nomeTouroUltimaInseminacao:
                                                              _model
                                                                  .touroInseminacaoValue,
                                                          dtPartoPrevisto: functions
                                                              .somarDataParto(_model
                                                                  .dataUltimaInseminacaoTextController
                                                                  .text),
                                                          dtSecPrevista: functions
                                                              .somarDataSecagem(
                                                                  _model
                                                                      .dataUltimaInseminacaoTextController
                                                                      .text),
                                                          dtPrePartoPrevista: functions
                                                              .somarDataPreParto(
                                                                  _model
                                                                      .dataUltimaInseminacaoTextController
                                                                      .text),
                                                          totalInseminacoes: 1,
                                                          dtDgMais:
                                                              dateTimeFormat(
                                                            "dd/MM/yyyy",
                                                            getCurrentTimestamp,
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          ),
                                                          dtUltimoParto: _model
                                                              .dataUltimoPartoTextController
                                                              .text,
                                                          compararDtUltimaInseminacao:
                                                              functions.converterDataUltimaInseminacao(
                                                                  _model
                                                                      .dataUltimaInseminacaoTextController
                                                                      .text),
                                                          nomeBrincoConcat: () {
                                                            if ((_model.nomeTextController.text != '') &&
                                                                (_model.brincoTextController
                                                                            .text !=
                                                                        '') &&
                                                                (_model.brincoTextController
                                                                        .text !=
                                                                    '-1')) {
                                                              return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                                            } else if (_model.nomeTextController
                                                                        .text !=
                                                                    '') {
                                                              return _model
                                                                  .nomeTextController
                                                                  .text;
                                                            } else {
                                                              return _model
                                                                  .brincoTextController
                                                                  .text;
                                                            }
                                                          }(),
                                                          idStatusAnimal: 6,
                                                          dtUltimoPartoContingencia:
                                                              _model
                                                                  .dataUltimoPartoTextController
                                                                  .text,
                                                          brincoAnimalOrder: _model.brincoTextController
                                                                          .text !=
                                                                      ''
                                                              ? int.tryParse(_model
                                                                  .brincoTextController
                                                                  .text)
                                                              : 999999,
                                                        ));

                                                        await widget
                                                            .uidTecnico!
                                                            .update({
                                                          ...mapToFirestore(
                                                            {
                                                              'quantidadeAnimaisCadastrados':
                                                                  FieldValue
                                                                      .increment(
                                                                          1),
                                                              'restanteLimiteAnimais':
                                                                  FieldValue
                                                                      .increment(
                                                                          -(1)),
                                                            },
                                                          ),
                                                        });
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'Animal cadastrado com sucesso!',
                                                              style: TextStyle(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                              ),
                                                            ),
                                                            duration: Duration(
                                                                milliseconds:
                                                                    4000),
                                                            backgroundColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary,
                                                          ),
                                                        );
                                                        if (Navigator.of(
                                                                context)
                                                            .canPop()) {
                                                          context.pop();
                                                        }
                                                        context.pushNamed(
                                                          ListaAnimaisWidget
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
                                                              widget
                                                                  .uidTecnico,
                                                              ParamType
                                                                  .DocumentReference,
                                                            ),
                                                            'emailPropriedade':
                                                                serializeParam(
                                                              widget
                                                                  .emailPropriedade,
                                                              ParamType.String,
                                                            ),
                                                            'visitaPresencial':
                                                                serializeParam(
                                                              widget
                                                                  .visitaPresencial,
                                                              ParamType.bool,
                                                            ),
                                                            'initialTabSelect':
                                                                serializeParam(
                                                              widget
                                                                  .initialTabSelect,
                                                              ParamType.int,
                                                            ),
                                                            'diasDg':
                                                                serializeParam(
                                                              widget.diasDg,
                                                              ParamType.String,
                                                            ),
                                                            'tabBarOpenSelected':
                                                                serializeParam(
                                                              0,
                                                              ParamType.int,
                                                            ),
                                                          }.withoutNulls,
                                                        );

                                                        if (_shouldSetState)
                                                          safeSetState(() {});
                                                        return;
                                                      } else {
                                                        await showDialog(
                                                          context: context,
                                                          builder:
                                                              (alertDialogContext) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Data última inseminação vazia ou Touro inseminação não selecionado.'),
                                                              content: Text(
                                                                  'Preencha os campos obrigatórios.'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          alertDialogContext),
                                                                  child: Text(
                                                                      'Ok'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                        if (_shouldSetState)
                                                          safeSetState(() {});
                                                        return;
                                                      }
                                                    } else {
                                                      if (_model
                                                              .statusAnimalValue ==
                                                          'Inseminada PP') {
                                                        if ((_model.dataUltimaInseminacaoTextController
                                                                        .text !=
                                                                    '') &&
                                                            (_model.touroInseminacaoValue !=
                                                                    null &&
                                                                _model.touroInseminacaoValue !=
                                                                    '')) {
                                                          await AnimaisProdutoresRecord
                                                                  .createDoc(widget
                                                                      .uidTecnico!)
                                                              .set(
                                                                  createAnimaisProdutoresRecordData(
                                                            uidTecnicoPropriedade:
                                                                widget
                                                                    .uidPropriedade,
                                                            nomeAnimal: _model
                                                                .nomeTextController
                                                                .text,
                                                            brincoAnimal: _model.brincoTextController
                                                                            .text !=
                                                                        ''
                                                                ? int.tryParse(
                                                                    _model
                                                                        .brincoTextController
                                                                        .text)
                                                                : -1,
                                                            racaAnimal: _model
                                                                .racaValue,
                                                            pesoAnimal: _model
                                                                .pesoTextController
                                                                .text,
                                                            dtNascimento: _model
                                                                .dataNascimentoTextController
                                                                .text,
                                                            touro: _model
                                                                .touroPaiTextController
                                                                .text,
                                                            vaca: _model
                                                                .vacaMaeTextController
                                                                .text,
                                                            status: _model
                                                                .statusAnimalValue,
                                                            dtUltimaInseminacao:
                                                                _model
                                                                    .dataUltimaInseminacaoTextController
                                                                    .text,
                                                            grupoAnimal: _model
                                                                .grupoValue,
                                                            nomeTouroUltimaInseminacao:
                                                                _model
                                                                    .touroInseminacaoValue,
                                                            dtPartoPrevisto: functions
                                                                .somarDataParto(
                                                                    _model
                                                                        .dataUltimaInseminacaoTextController
                                                                        .text),
                                                            dtSecPrevista: functions
                                                                .somarDataSecagem(
                                                                    _model
                                                                        .dataUltimaInseminacaoTextController
                                                                        .text),
                                                            dtPrePartoPrevista:
                                                                functions.somarDataPreParto(
                                                                    _model
                                                                        .dataUltimaInseminacaoTextController
                                                                        .text),
                                                            totalInseminacoes:
                                                                1,
                                                            dtPP:
                                                                dateTimeFormat(
                                                              "dd/MM/yyyy",
                                                              getCurrentTimestamp,
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ),
                                                            dtUltimoPP:
                                                                dateTimeFormat(
                                                              "dd/MM/yyyy",
                                                              getCurrentTimestamp,
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ),
                                                            dtUltimoParto: _model
                                                                .dataUltimoPartoTextController
                                                                .text,
                                                            compararDtUltimaInseminacao:
                                                                functions.converterDataUltimaInseminacao(
                                                                    _model
                                                                        .dataUltimaInseminacaoTextController
                                                                        .text),
                                                            nomeBrincoConcat:
                                                                () {
                                                              if ((_model.nomeTextController.text != '') &&
                                                                  (_model.brincoTextController
                                                                              .text !=
                                                                          '') &&
                                                                  (_model.brincoTextController
                                                                          .text !=
                                                                      '-1')) {
                                                                return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                                              } else if (_model.nomeTextController
                                                                          .text !=
                                                                      '') {
                                                                return _model
                                                                    .nomeTextController
                                                                    .text;
                                                              } else {
                                                                return _model
                                                                    .brincoTextController
                                                                    .text;
                                                              }
                                                            }(),
                                                            idStatusAnimal: 1,
                                                            dtUltimoPartoContingencia:
                                                                _model
                                                                    .dataUltimoPartoTextController
                                                                    .text,
                                                            brincoAnimalOrder: _model.brincoTextController
                                                                            .text !=
                                                                        ''
                                                                ? int.tryParse(
                                                                    _model
                                                                        .brincoTextController
                                                                        .text)
                                                                : 999999,
                                                          ));

                                                          await widget
                                                              .uidTecnico!
                                                              .update({
                                                            ...mapToFirestore(
                                                              {
                                                                'quantidadeAnimaisCadastrados':
                                                                    FieldValue
                                                                        .increment(
                                                                            1),
                                                                'restanteLimiteAnimais':
                                                                    FieldValue
                                                                        .increment(
                                                                            -(1)),
                                                              },
                                                            ),
                                                          });
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                'Animal cadastrado com sucesso!',
                                                                style:
                                                                    TextStyle(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                ),
                                                              ),
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      4000),
                                                              backgroundColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                            ),
                                                          );
                                                          if (Navigator.of(
                                                                  context)
                                                              .canPop()) {
                                                            context.pop();
                                                          }
                                                          context.pushNamed(
                                                            ListaAnimaisWidget
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
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'uidTecnico':
                                                                  serializeParam(
                                                                widget
                                                                    .uidTecnico,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                              'emailPropriedade':
                                                                  serializeParam(
                                                                widget
                                                                    .emailPropriedade,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'visitaPresencial':
                                                                  serializeParam(
                                                                widget
                                                                    .visitaPresencial,
                                                                ParamType.bool,
                                                              ),
                                                              'initialTabSelect':
                                                                  serializeParam(
                                                                widget
                                                                    .initialTabSelect,
                                                                ParamType.int,
                                                              ),
                                                              'diasDg':
                                                                  serializeParam(
                                                                widget.diasDg,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'tabBarOpenSelected':
                                                                  serializeParam(
                                                                0,
                                                                ParamType.int,
                                                              ),
                                                            }.withoutNulls,
                                                          );

                                                          if (_shouldSetState)
                                                            safeSetState(() {});
                                                          return;
                                                        } else {
                                                          await showDialog(
                                                            context: context,
                                                            builder:
                                                                (alertDialogContext) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Data última inseminação vazia ou Touro inseminação não selecionado.'),
                                                                content: Text(
                                                                    'Preencha os campos obrigatórios.'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            alertDialogContext),
                                                                    child: Text(
                                                                        'Ok'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                          if (_shouldSetState)
                                                            safeSetState(() {});
                                                          return;
                                                        }
                                                      } else {
                                                        if (_model
                                                                .statusAnimalValue ==
                                                            'Pré Parto') {
                                                          if ((_model.dataUltimaInseminacaoTextController
                                                                          .text !=
                                                                      '') &&
                                                              (_model.touroInseminacaoValue !=
                                                                      null &&
                                                                  _model.touroInseminacaoValue !=
                                                                      '')) {
                                                            await AnimaisProdutoresRecord
                                                                    .createDoc(
                                                                        widget
                                                                            .uidTecnico!)
                                                                .set(
                                                                    createAnimaisProdutoresRecordData(
                                                              uidTecnicoPropriedade:
                                                                  widget
                                                                      .uidPropriedade,
                                                              nomeAnimal: _model
                                                                  .nomeTextController
                                                                  .text,
                                                              brincoAnimal: _model.brincoTextController
                                                                              .text !=
                                                                          ''
                                                                  ? int.tryParse(
                                                                      _model
                                                                          .brincoTextController
                                                                          .text)
                                                                  : -1,
                                                              racaAnimal: _model
                                                                  .racaValue,
                                                              pesoAnimal: _model
                                                                  .pesoTextController
                                                                  .text,
                                                              dtNascimento: _model
                                                                  .dataNascimentoTextController
                                                                  .text,
                                                              touro: _model
                                                                  .touroPaiTextController
                                                                  .text,
                                                              vaca: _model
                                                                  .vacaMaeTextController
                                                                  .text,
                                                              status: _model
                                                                  .statusAnimalValue,
                                                              dtUltimaInseminacao:
                                                                  _model
                                                                      .dataUltimaInseminacaoTextController
                                                                      .text,
                                                              grupoAnimal: _model
                                                                  .grupoValue,
                                                              nomeTouroUltimaInseminacao:
                                                                  _model
                                                                      .touroInseminacaoValue,
                                                              dtPartoPrevisto: functions
                                                                  .somarDataParto(
                                                                      _model
                                                                          .dataUltimaInseminacaoTextController
                                                                          .text),
                                                              dtSecPrevista: functions
                                                                  .somarDataSecagem(
                                                                      _model
                                                                          .dataUltimaInseminacaoTextController
                                                                          .text),
                                                              dtPrePartoPrevista:
                                                                  functions.somarDataPreParto(
                                                                      _model
                                                                          .dataUltimaInseminacaoTextController
                                                                          .text),
                                                              totalInseminacoes:
                                                                  1,
                                                              dtPP:
                                                                  dateTimeFormat(
                                                                "dd/MM/yyyy",
                                                                getCurrentTimestamp,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              ),
                                                              dtUltimoPP:
                                                                  dateTimeFormat(
                                                                "dd/MM/yyyy",
                                                                getCurrentTimestamp,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              ),
                                                              dtUltimoParto: _model
                                                                  .dataUltimoPartoTextController
                                                                  .text,
                                                              compararDtUltimaInseminacao:
                                                                  functions.converterDataUltimaInseminacao(
                                                                      _model
                                                                          .dataUltimaInseminacaoTextController
                                                                          .text),
                                                              nomeBrincoConcat:
                                                                  () {
                                                                if ((_model.nomeTextController.text != '') &&
                                                                    (_model.brincoTextController.text !=
                                                                            '') &&
                                                                    (_model.brincoTextController
                                                                            .text !=
                                                                        '-1')) {
                                                                  return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                                                } else if (_model.nomeTextController
                                                                            .text !=
                                                                        '') {
                                                                  return _model
                                                                      .nomeTextController
                                                                      .text;
                                                                } else {
                                                                  return _model
                                                                      .brincoTextController
                                                                      .text;
                                                                }
                                                              }(),
                                                              idStatusAnimal: 5,
                                                              dtUltimoPartoContingencia:
                                                                  _model
                                                                      .dataUltimoPartoTextController
                                                                      .text,
                                                              brincoAnimalOrder: _model.brincoTextController
                                                                              .text !=
                                                                          ''
                                                                  ? int.tryParse(
                                                                      _model
                                                                          .brincoTextController
                                                                          .text)
                                                                  : 999999,
                                                            ));

                                                            await widget
                                                                .uidTecnico!
                                                                .update({
                                                              ...mapToFirestore(
                                                                {
                                                                  'quantidadeAnimaisCadastrados':
                                                                      FieldValue
                                                                          .increment(
                                                                              1),
                                                                  'restanteLimiteAnimais':
                                                                      FieldValue
                                                                          .increment(
                                                                              -(1)),
                                                                },
                                                              ),
                                                            });
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  'Animal cadastrado com sucesso!',
                                                                  style:
                                                                      TextStyle(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                  ),
                                                                ),
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        4000),
                                                                backgroundColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondary,
                                                              ),
                                                            );
                                                            if (Navigator.of(
                                                                    context)
                                                                .canPop()) {
                                                              context.pop();
                                                            }
                                                            context.pushNamed(
                                                              ListaAnimaisWidget
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
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'uidTecnico':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidTecnico,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'emailPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .emailPropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'visitaPresencial':
                                                                    serializeParam(
                                                                  widget
                                                                      .visitaPresencial,
                                                                  ParamType
                                                                      .bool,
                                                                ),
                                                                'initialTabSelect':
                                                                    serializeParam(
                                                                  widget
                                                                      .initialTabSelect,
                                                                  ParamType.int,
                                                                ),
                                                                'diasDg':
                                                                    serializeParam(
                                                                  widget
                                                                      .diasDg,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'tabBarOpenSelected':
                                                                    serializeParam(
                                                                  0,
                                                                  ParamType.int,
                                                                ),
                                                              }.withoutNulls,
                                                            );

                                                            if (_shouldSetState)
                                                              safeSetState(
                                                                  () {});
                                                            return;
                                                          } else {
                                                            await showDialog(
                                                              context: context,
                                                              builder:
                                                                  (alertDialogContext) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      'Data última inseminação vazia ou Touro inseminação não selecionado.'),
                                                                  content: Text(
                                                                      'Preencha os campos obrigatórios.'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(alertDialogContext),
                                                                      child: Text(
                                                                          'Ok'),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                            if (_shouldSetState)
                                                              safeSetState(
                                                                  () {});
                                                            return;
                                                          }
                                                        } else {
                                                          if (_shouldSetState)
                                                            safeSetState(() {});
                                                          return;
                                                        }
                                                      }
                                                    }
                                                  }
                                                }
                                              }
                                            } else {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Status é obrigatório.'),
                                                    content: Text(
                                                        'Selecione ao menos um status.'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                alertDialogContext),
                                                        child: Text('Ok'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              if (_shouldSetState)
                                                safeSetState(() {});
                                              return;
                                            }
                                          } else {
                                            if ((_model.grupoValue ==
                                                    'Sêmens') ||
                                                (_model.grupoValue ==
                                                    'Touros')) {
                                              if (_model.grupoValue ==
                                                  'Touros') {
                                                await AnimaisProdutoresRecord
                                                        .createDoc(
                                                            widget.uidTecnico!)
                                                    .set(
                                                        createAnimaisProdutoresRecordData(
                                                  uidTecnicoPropriedade:
                                                      widget.uidPropriedade,
                                                  nomeAnimal: _model
                                                      .nomeTextController.text,
                                                  brincoAnimal: _model.brincoTextController
                                                                  .text !=
                                                              ''
                                                      ? int.tryParse(_model
                                                          .brincoTextController
                                                          .text)
                                                      : -1,
                                                  racaAnimal: _model.racaValue,
                                                  pesoAnimal: _model
                                                      .pesoTextController.text,
                                                  dtNascimento: _model
                                                      .dataNascimentoTextController
                                                      .text,
                                                  touro: _model
                                                      .touroPaiTextController
                                                      .text,
                                                  vaca: _model
                                                      .vacaMaeTextController
                                                      .text,
                                                  grupoAnimal:
                                                      _model.grupoValue,
                                                  liberaInseminacao: () {
                                                    if (_model.grupoValue ==
                                                        'Touros') {
                                                      return _model.switchValue;
                                                    } else if (_model
                                                            .grupoValue ==
                                                        'Sêmens') {
                                                      return _model.switchValue;
                                                    } else {
                                                      return true;
                                                    }
                                                  }(),
                                                  status: '',
                                                  nomeBrincoConcat: () {
                                                    if ((_model.nomeTextController.text != '') &&
                                                        (_model.brincoTextController
                                                                    .text !=
                                                                '') &&
                                                        (_model.brincoTextController
                                                                .text !=
                                                            '-1')) {
                                                      return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                                    } else if (_model.nomeTextController
                                                                .text !=
                                                            '') {
                                                      return _model
                                                          .nomeTextController
                                                          .text;
                                                    } else {
                                                      return _model
                                                          .brincoTextController
                                                          .text;
                                                    }
                                                  }(),
                                                  brincoAnimalOrder: _model.brincoTextController
                                                                  .text !=
                                                              ''
                                                      ? int.tryParse(_model
                                                          .brincoTextController
                                                          .text)
                                                      : 999999,
                                                ));

                                                await widget.uidTecnico!
                                                    .update({
                                                  ...mapToFirestore(
                                                    {
                                                      'quantidadeAnimaisCadastrados':
                                                          FieldValue.increment(
                                                              1),
                                                      'restanteLimiteAnimais':
                                                          FieldValue.increment(
                                                              -(1)),
                                                    },
                                                  ),
                                                });
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Animal cadastrado com sucesso!',
                                                      style: TextStyle(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                    backgroundColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .secondary,
                                                  ),
                                                );
                                                if (Navigator.of(context)
                                                    .canPop()) {
                                                  context.pop();
                                                }
                                                context.pushNamed(
                                                  ListaAnimaisWidget.routeName,
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
                                                    'visitaPresencial':
                                                        serializeParam(
                                                      widget.visitaPresencial,
                                                      ParamType.bool,
                                                    ),
                                                    'initialTabSelect':
                                                        serializeParam(
                                                      widget.initialTabSelect,
                                                      ParamType.int,
                                                    ),
                                                    'diasDg': serializeParam(
                                                      widget.diasDg,
                                                      ParamType.String,
                                                    ),
                                                  }.withoutNulls,
                                                );

                                                if (_shouldSetState)
                                                  safeSetState(() {});
                                                return;
                                              } else {
                                                if (_model.grupoValue ==
                                                    'Sêmens') {
                                                  await AnimaisProdutoresRecord
                                                          .createDoc(widget
                                                              .uidTecnico!)
                                                      .set(
                                                          createAnimaisProdutoresRecordData(
                                                    uidTecnicoPropriedade:
                                                        widget.uidPropriedade,
                                                    nomeAnimal: _model
                                                        .nomeTextController
                                                        .text,
                                                    brincoAnimal: _model.brincoTextController
                                                                    .text !=
                                                                ''
                                                        ? int.tryParse(_model
                                                            .brincoTextController
                                                            .text)
                                                        : -1,
                                                    racaAnimal:
                                                        _model.racaValue,
                                                    dtNascimento: _model
                                                        .dataNascimentoTextController
                                                        .text,
                                                    touro: _model
                                                        .touroPaiTextController
                                                        .text,
                                                    grupoAnimal:
                                                        _model.grupoValue,
                                                    liberaInseminacao: () {
                                                      if (_model.grupoValue ==
                                                          'Touros') {
                                                        return _model
                                                            .switchValue;
                                                      } else if (_model
                                                              .grupoValue ==
                                                          'Sêmens') {
                                                        return _model
                                                            .switchValue;
                                                      } else {
                                                        return true;
                                                      }
                                                    }(),
                                                    status: '',
                                                    nomeBrincoConcat: () {
                                                      if ((_model.nomeTextController.text != '') &&
                                                          (_model.brincoTextController
                                                                      .text !=
                                                                  '') &&
                                                          (_model.brincoTextController
                                                                  .text !=
                                                              '-1')) {
                                                        return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                                      } else if (_model.nomeTextController
                                                                  .text !=
                                                              '') {
                                                        return _model
                                                            .nomeTextController
                                                            .text;
                                                      } else {
                                                        return _model
                                                            .brincoTextController
                                                            .text;
                                                      }
                                                    }(),
                                                    brincoAnimalOrder: _model.brincoTextController
                                                                    .text !=
                                                                ''
                                                        ? int.tryParse(_model
                                                            .brincoTextController
                                                            .text)
                                                        : 999999,
                                                  ));

                                                  await widget.uidTecnico!
                                                      .update({
                                                    ...mapToFirestore(
                                                      {
                                                        'quantidadeAnimaisCadastrados':
                                                            FieldValue
                                                                .increment(1),
                                                        'restanteLimiteAnimais':
                                                            FieldValue
                                                                .increment(
                                                                    -(1)),
                                                      },
                                                    ),
                                                  });
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Animal cadastrado com sucesso!',
                                                        style: TextStyle(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                        ),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                  );
                                                  if (Navigator.of(context)
                                                      .canPop()) {
                                                    context.pop();
                                                  }
                                                  context.pushNamed(
                                                    ListaAnimaisWidget
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
                                                        widget
                                                            .emailPropriedade,
                                                        ParamType.String,
                                                      ),
                                                      'visitaPresencial':
                                                          serializeParam(
                                                        widget
                                                            .visitaPresencial,
                                                        ParamType.bool,
                                                      ),
                                                      'initialTabSelect':
                                                          serializeParam(
                                                        widget
                                                            .initialTabSelect,
                                                        ParamType.int,
                                                      ),
                                                      'diasDg': serializeParam(
                                                        widget.diasDg,
                                                        ParamType.String,
                                                      ),
                                                    }.withoutNulls,
                                                  );

                                                  if (_shouldSetState)
                                                    safeSetState(() {});
                                                  return;
                                                } else {
                                                  if (_shouldSetState)
                                                    safeSetState(() {});
                                                  return;
                                                }
                                              }
                                            } else {
                                              await AnimaisProdutoresRecord
                                                      .createDoc(
                                                          widget.uidTecnico!)
                                                  .set(
                                                      createAnimaisProdutoresRecordData(
                                                uidTecnicoPropriedade:
                                                    widget.uidPropriedade,
                                                nomeAnimal: _model
                                                    .nomeTextController.text,
                                                brincoAnimal: _model.brincoTextController
                                                                .text !=
                                                            ''
                                                    ? int.tryParse(_model
                                                        .brincoTextController
                                                        .text)
                                                    : -1,
                                                racaAnimal: _model.racaValue,
                                                pesoAnimal: _model
                                                    .pesoTextController.text,
                                                dtNascimento: _model
                                                    .dataNascimentoTextController
                                                    .text,
                                                touro: _model
                                                    .touroPaiTextController
                                                    .text,
                                                vaca: _model
                                                    .vacaMaeTextController.text,
                                                grupoAnimal: _model.grupoValue,
                                                status: '',
                                                nomeBrincoConcat: () {
                                                  if ((_model.nomeTextController.text != '') &&
                                                      (_model.brincoTextController
                                                                  .text !=
                                                              '') &&
                                                      (_model.brincoTextController
                                                              .text !=
                                                          '-1')) {
                                                    return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                                  } else if (_model.nomeTextController
                                                              .text !=
                                                          '') {
                                                    return _model
                                                        .nomeTextController
                                                        .text;
                                                  } else {
                                                    return _model
                                                        .brincoTextController
                                                        .text;
                                                  }
                                                }(),
                                                brincoAnimalOrder: _model.brincoTextController
                                                                .text !=
                                                            ''
                                                    ? int.tryParse(_model
                                                        .brincoTextController
                                                        .text)
                                                    : 999999,
                                              ));

                                              await widget.uidTecnico!.update({
                                                ...mapToFirestore(
                                                  {
                                                    'quantidadeAnimaisCadastrados':
                                                        FieldValue.increment(1),
                                                    'restanteLimiteAnimais':
                                                        FieldValue.increment(
                                                            -(1)),
                                                  },
                                                ),
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Animal cadastrado com sucesso!',
                                                    style: TextStyle(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                    ),
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 4000),
                                                  backgroundColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondary,
                                                ),
                                              );
                                              if (Navigator.of(context)
                                                  .canPop()) {
                                                context.pop();
                                              }
                                              context.pushNamed(
                                                ListaAnimaisWidget.routeName,
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
                                                  'visitaPresencial':
                                                      serializeParam(
                                                    widget.visitaPresencial,
                                                    ParamType.bool,
                                                  ),
                                                  'initialTabSelect':
                                                      serializeParam(
                                                    widget.initialTabSelect,
                                                    ParamType.int,
                                                  ),
                                                  'diasDg': serializeParam(
                                                    widget.diasDg,
                                                    ParamType.String,
                                                  ),
                                                }.withoutNulls,
                                              );

                                              if (_shouldSetState)
                                                safeSetState(() {});
                                              return;
                                            }
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Sincronize os dados primeiro.',
                                                style: TextStyle(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                ),
                                              ),
                                              duration:
                                                  Duration(milliseconds: 4000),
                                              backgroundColor:
                                                  Color(0xFFCC4038),
                                            ),
                                          );
                                          if (_shouldSetState)
                                            safeSetState(() {});
                                          return;
                                        }
                                      } else {
                                        if (_model.formKey.currentState ==
                                                null ||
                                            !_model.formKey.currentState!
                                                .validate()) {
                                          return;
                                        }
                                        if (_model.racaValue == null) {
                                          return;
                                        }
                                        if (_model.grupoValue == null) {
                                          return;
                                        }
                                        _model.outListaAnimaisVerificaNomeOff =
                                            await queryAnimaisProdutoresRecordOnce(
                                          parent: widget.uidTecnico,
                                          queryBuilder:
                                              (animaisProdutoresRecord) =>
                                                  animaisProdutoresRecord
                                                      .where(
                                                        'uidTecnicoPropriedade',
                                                        isEqualTo: widget
                                                            .uidPropriedade,
                                                      )
                                                      .where(
                                                        'nomeAnimal',
                                                        isEqualTo: _model
                                                            .nomeTextController
                                                            .text,
                                                      ),
                                        );
                                        _shouldSetState = true;
                                        _model.outListaAnimaisVerificaBrincoOff =
                                            await queryAnimaisProdutoresRecordOnce(
                                          parent: widget.uidTecnico,
                                          queryBuilder:
                                              (animaisProdutoresRecord) =>
                                                  animaisProdutoresRecord
                                                      .where(
                                                        'uidTecnicoPropriedade',
                                                        isEqualTo: widget
                                                            .uidPropriedade,
                                                      )
                                                      .where(
                                                        'brincoAnimal',
                                                        isEqualTo: int.tryParse(
                                                            _model
                                                                .brincoTextController
                                                                .text),
                                                      ),
                                        );
                                        _shouldSetState = true;
                                        if ((_model.outListaAnimaisVerificaNomeOff!
                                                    .length >
                                                0) &&
                                            (_model.outListaAnimaisVerificaBrincoOff!
                                                    .length >
                                                0)) {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Nome ou brinco já existe.'),
                                                content: Text(
                                                    'Digite outro nome ou brinco.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          if (_shouldSetState)
                                            safeSetState(() {});
                                          return;
                                        }
                                        if ((_model.nomeTextController
                                                        .text !=
                                                    '') ||
                                            (_model.brincoTextController
                                                        .text !=
                                                    '')) {
                                          if (_model.dataUltimaInseminacaoTextController
                                                      .text !=
                                                  '') {
                                            if (!(_model.touroInseminacaoValue !=
                                                    null &&
                                                _model.touroInseminacaoValue !=
                                                    '')) {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Touro inseminação não selecionado.'),
                                                    content: Text(
                                                        'Selecione o touro usado.'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                alertDialogContext),
                                                        child: Text('Ok'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              if (_shouldSetState)
                                                safeSetState(() {});
                                              return;
                                            }
                                          }
                                        } else {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Nome ou brinco obrigatório.'),
                                                content: Text(
                                                    'Preencha ao menos um dos campos.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          if (_shouldSetState)
                                            safeSetState(() {});
                                          return;
                                        }

                                        if ((_model.grupoValue == 'Vacas') ||
                                            (_model.grupoValue == 'Novilhas')) {
                                          if (_model.statusAnimalValue !=
                                                  null &&
                                              _model.statusAnimalValue != '') {
                                            if (_model.statusAnimalValue ==
                                                'Inseminada') {
                                              if ((_model.dataUltimaInseminacaoTextController.text != '') &&
                                                  (_model.dataUltimoPartoTextController
                                                              .text ==
                                                          '') &&
                                                  (_model.touroInseminacaoValue !=
                                                          null &&
                                                      _model.touroInseminacaoValue !=
                                                          '')) {
                                                FFAppState()
                                                    .addToAnimaisProdutoresOffline(
                                                        AnimaisProdutoresStruct(
                                                  uidTecnicoPropriedade:
                                                      widget.uidPropriedade,
                                                  nomeAnimal: _model
                                                      .nomeTextController.text,
                                                  racaAnimal: _model.racaValue,
                                                  pesoAnimal: _model
                                                      .pesoTextController.text,
                                                  dtNascimento: _model
                                                      .dataNascimentoTextController
                                                      .text,
                                                  touro: _model
                                                      .touroPaiTextController
                                                      .text,
                                                  vaca: _model
                                                      .vacaMaeTextController
                                                      .text,
                                                  status:
                                                      _model.statusAnimalValue,
                                                  grupoAnimal:
                                                      _model.grupoValue,
                                                  dtUltimaInseminacao: _model
                                                      .dataUltimaInseminacaoTextController
                                                      .text,
                                                  brincoAnimalOrder: _model.brincoTextController
                                                                  .text !=
                                                              ''
                                                      ? int.tryParse(_model
                                                          .brincoTextController
                                                          .text)
                                                      : 999999,
                                                  brincoAnimal: _model.brincoTextController
                                                                  .text !=
                                                              ''
                                                      ? int.tryParse(_model
                                                          .brincoTextController
                                                          .text)
                                                      : -1,
                                                  nomeTouroUltimaInseminacao:
                                                      _model
                                                          .touroInseminacaoValue,
                                                  dtPartoPrevisto: functions
                                                      .somarDataParto(_model
                                                          .dataUltimaInseminacaoTextController
                                                          .text),
                                                  dtSecPrevista: functions
                                                      .somarDataSecagem(_model
                                                          .dataUltimaInseminacaoTextController
                                                          .text),
                                                  dtPrePartoPrevista: functions
                                                      .somarDataPreParto(_model
                                                          .dataUltimaInseminacaoTextController
                                                          .text),
                                                  totalInseminacoes: 1,
                                                  compararDtUltimaInseminacao: functions
                                                      .converterDataUltimaInseminacao(
                                                          _model
                                                              .dataUltimaInseminacaoTextController
                                                              .text),
                                                  nomeBrincoConcat: () {
                                                    if ((_model.nomeTextController.text != '') &&
                                                        (_model.brincoTextController
                                                                    .text !=
                                                                '') &&
                                                        (_model.brincoTextController
                                                                .text !=
                                                            '-1')) {
                                                      return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                                    } else if (_model.nomeTextController
                                                                .text !=
                                                            '') {
                                                      return _model
                                                          .nomeTextController
                                                          .text;
                                                    } else {
                                                      return _model
                                                          .brincoTextController
                                                          .text;
                                                    }
                                                  }(),
                                                  idStatusAnimal: 3,
                                                  uidAnimalOffline: functions
                                                      .criarUidRandom(),
                                                ));
                                                safeSetState(() {});
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Animal cadastrado com sucesso!',
                                                      style: TextStyle(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                    backgroundColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .secondary,
                                                  ),
                                                );
                                                if (Navigator.of(context)
                                                    .canPop()) {
                                                  context.pop();
                                                }
                                                context.pushNamed(
                                                  ListaAnimaisWidget.routeName,
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
                                                    'visitaPresencial':
                                                        serializeParam(
                                                      widget.visitaPresencial,
                                                      ParamType.bool,
                                                    ),
                                                    'initialTabSelect':
                                                        serializeParam(
                                                      widget.initialTabSelect,
                                                      ParamType.int,
                                                    ),
                                                    'diasDg': serializeParam(
                                                      widget.diasDg,
                                                      ParamType.String,
                                                    ),
                                                    'tabBarOpenSelected':
                                                        serializeParam(
                                                      0,
                                                      ParamType.int,
                                                    ),
                                                  }.withoutNulls,
                                                );

                                                if (_shouldSetState)
                                                  safeSetState(() {});
                                                return;
                                              } else {
                                                if ((_model.dataUltimoPartoTextController.text != '') &&
                                                    (_model.dataUltimaInseminacaoTextController
                                                                .text !=
                                                            '') &&
                                                    (_model.touroInseminacaoValue !=
                                                            null &&
                                                        _model.touroInseminacaoValue !=
                                                            '')) {
                                                  FFAppState()
                                                      .addToAnimaisProdutoresOffline(
                                                          AnimaisProdutoresStruct(
                                                    uidTecnicoPropriedade:
                                                        widget.uidPropriedade,
                                                    nomeAnimal: _model
                                                        .nomeTextController
                                                        .text,
                                                    racaAnimal:
                                                        _model.racaValue,
                                                    pesoAnimal: _model
                                                        .pesoTextController
                                                        .text,
                                                    dtNascimento: _model
                                                        .dataNascimentoTextController
                                                        .text,
                                                    touro: _model
                                                        .touroPaiTextController
                                                        .text,
                                                    vaca: _model
                                                        .vacaMaeTextController
                                                        .text,
                                                    grupoAnimal:
                                                        _model.grupoValue,
                                                    brincoAnimalOrder: _model.brincoTextController
                                                                    .text !=
                                                                ''
                                                        ? int.tryParse(_model
                                                            .brincoTextController
                                                            .text)
                                                        : 999999,
                                                    brincoAnimal: _model.brincoTextController
                                                                    .text !=
                                                                ''
                                                        ? int.tryParse(_model
                                                            .brincoTextController
                                                            .text)
                                                        : -1,
                                                    nomeBrincoConcat: () {
                                                      if ((_model.nomeTextController.text != '') &&
                                                          (_model.brincoTextController
                                                                      .text !=
                                                                  '') &&
                                                          (_model.brincoTextController
                                                                  .text !=
                                                              '-1')) {
                                                        return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                                      } else if (_model.nomeTextController
                                                                  .text !=
                                                              '') {
                                                        return _model
                                                            .nomeTextController
                                                            .text;
                                                      } else {
                                                        return _model
                                                            .brincoTextController
                                                            .text;
                                                      }
                                                    }(),
                                                    status: _model
                                                        .statusAnimalValue,
                                                    dtUltimaInseminacao: _model
                                                        .dataUltimaInseminacaoTextController
                                                        .text,
                                                    dtUltimoParto: _model
                                                        .dataUltimoPartoTextController
                                                        .text,
                                                    nomeTouroUltimaInseminacao:
                                                        _model
                                                            .touroInseminacaoValue,
                                                    dtPartoPrevisto: functions
                                                        .somarDataParto(_model
                                                            .dataUltimaInseminacaoTextController
                                                            .text),
                                                    dtSecPrevista: functions
                                                        .somarDataSecagem(_model
                                                            .dataUltimaInseminacaoTextController
                                                            .text),
                                                    dtPrePartoPrevista: functions
                                                        .somarDataPreParto(_model
                                                            .dataUltimaInseminacaoTextController
                                                            .text),
                                                    totalInseminacoes: 1,
                                                    totalPartos: 1,
                                                    compararDtUltimaInseminacao:
                                                        functions
                                                            .converterDataUltimaInseminacao(
                                                                _model
                                                                    .dataUltimaInseminacaoTextController
                                                                    .text),
                                                    idStatusAnimal: 3,
                                                    dtUltimoPartoContingencia:
                                                        _model
                                                            .dataUltimoPartoTextController
                                                            .text,
                                                    uidAnimalOffline: functions
                                                        .criarUidRandom(),
                                                  ));
                                                  safeSetState(() {});
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Animal cadastrado com sucesso!',
                                                        style: TextStyle(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                        ),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                  );
                                                  if (Navigator.of(context)
                                                      .canPop()) {
                                                    context.pop();
                                                  }
                                                  context.pushNamed(
                                                    ListaAnimaisWidget
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
                                                        widget
                                                            .emailPropriedade,
                                                        ParamType.String,
                                                      ),
                                                      'visitaPresencial':
                                                          serializeParam(
                                                        widget
                                                            .visitaPresencial,
                                                        ParamType.bool,
                                                      ),
                                                      'initialTabSelect':
                                                          serializeParam(
                                                        widget
                                                            .initialTabSelect,
                                                        ParamType.int,
                                                      ),
                                                      'diasDg': serializeParam(
                                                        widget.diasDg,
                                                        ParamType.String,
                                                      ),
                                                      'tabBarOpenSelected':
                                                          serializeParam(
                                                        0,
                                                        ParamType.int,
                                                      ),
                                                    }.withoutNulls,
                                                  );

                                                  if (_shouldSetState)
                                                    safeSetState(() {});
                                                  return;
                                                } else {
                                                  if (_shouldSetState)
                                                    safeSetState(() {});
                                                  return;
                                                }
                                              }
                                            } else {
                                              if (_model.statusAnimalValue ==
                                                  'Seca') {
                                                if (_model.grupoValue ==
                                                    'Vacas') {
                                                  FFAppState()
                                                      .addToAnimaisProdutoresOffline(
                                                          AnimaisProdutoresStruct(
                                                    uidTecnicoPropriedade:
                                                        widget.uidPropriedade,
                                                    nomeAnimal: _model
                                                        .nomeTextController
                                                        .text,
                                                    racaAnimal:
                                                        _model.racaValue,
                                                    pesoAnimal: _model
                                                        .pesoTextController
                                                        .text,
                                                    dtNascimento: _model
                                                        .dataNascimentoTextController
                                                        .text,
                                                    touro: _model
                                                        .touroPaiTextController
                                                        .text,
                                                    vaca: _model
                                                        .vacaMaeTextController
                                                        .text,
                                                    grupoAnimal:
                                                        _model.grupoValue,
                                                    brincoAnimalOrder: _model.brincoTextController
                                                                    .text !=
                                                                ''
                                                        ? int.tryParse(_model
                                                            .brincoTextController
                                                            .text)
                                                        : 999999,
                                                    brincoAnimal: _model.brincoTextController
                                                                    .text !=
                                                                ''
                                                        ? int.tryParse(_model
                                                            .brincoTextController
                                                            .text)
                                                        : -1,
                                                    nomeBrincoConcat: () {
                                                      if ((_model.nomeTextController.text != '') &&
                                                          (_model.brincoTextController
                                                                      .text !=
                                                                  '') &&
                                                          (_model.brincoTextController
                                                                  .text !=
                                                              '-1')) {
                                                        return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                                      } else if (_model.nomeTextController
                                                                  .text !=
                                                              '') {
                                                        return _model
                                                            .nomeTextController
                                                            .text;
                                                      } else {
                                                        return _model
                                                            .brincoTextController
                                                            .text;
                                                      }
                                                    }(),
                                                    status: _model
                                                        .statusAnimalValue,
                                                    dtUltimaInseminacao: _model
                                                        .dataUltimaInseminacaoTextController
                                                        .text,
                                                    dtPartoPrevisto: functions
                                                        .somarDataParto(_model
                                                            .dataUltimaInseminacaoTextController
                                                            .text),
                                                    dtSecPrevista: functions
                                                        .somarDataSecagem(_model
                                                            .dataUltimaInseminacaoTextController
                                                            .text),
                                                    dtPrePartoPrevista: functions
                                                        .somarDataPreParto(_model
                                                            .dataUltimaInseminacaoTextController
                                                            .text),
                                                    nomeTouroUltimaInseminacao:
                                                        _model
                                                            .touroInseminacaoValue,
                                                    compararDtUltimaInseminacao:
                                                        functions
                                                            .converterDataUltimaInseminacao(
                                                                _model
                                                                    .dataUltimaInseminacaoTextController
                                                                    .text),
                                                    idStatusAnimal: 4,
                                                    uidAnimalOffline: functions
                                                        .criarUidRandom(),
                                                  ));
                                                  safeSetState(() {});
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Animal cadastrado com sucesso!',
                                                        style: TextStyle(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                        ),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                  );
                                                  if (Navigator.of(context)
                                                      .canPop()) {
                                                    context.pop();
                                                  }
                                                  context.pushNamed(
                                                    ListaAnimaisWidget
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
                                                        widget
                                                            .emailPropriedade,
                                                        ParamType.String,
                                                      ),
                                                      'visitaPresencial':
                                                          serializeParam(
                                                        widget
                                                            .visitaPresencial,
                                                        ParamType.bool,
                                                      ),
                                                      'initialTabSelect':
                                                          serializeParam(
                                                        widget
                                                            .initialTabSelect,
                                                        ParamType.int,
                                                      ),
                                                      'diasDg': serializeParam(
                                                        widget.diasDg,
                                                        ParamType.String,
                                                      ),
                                                      'tabBarOpenSelected':
                                                          serializeParam(
                                                        0,
                                                        ParamType.int,
                                                      ),
                                                    }.withoutNulls,
                                                  );

                                                  if (_shouldSetState)
                                                    safeSetState(() {});
                                                  return;
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'O status de \"Seca\" é permitido somente em vacas.'),
                                                        content: Text(
                                                            'Atualize o status.'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    alertDialogContext),
                                                            child: Text('Ok'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  if (_shouldSetState)
                                                    safeSetState(() {});
                                                  return;
                                                }
                                              } else {
                                                if (_model.statusAnimalValue ==
                                                    'Vazia') {
                                                  FFAppState()
                                                      .addToAnimaisProdutoresOffline(
                                                          AnimaisProdutoresStruct(
                                                    uidTecnicoPropriedade:
                                                        widget.uidPropriedade,
                                                    nomeAnimal: _model
                                                        .nomeTextController
                                                        .text,
                                                    racaAnimal:
                                                        _model.racaValue,
                                                    pesoAnimal: _model
                                                        .pesoTextController
                                                        .text,
                                                    dtNascimento: _model
                                                        .dataNascimentoTextController
                                                        .text,
                                                    touro: _model
                                                        .touroPaiTextController
                                                        .text,
                                                    vaca: _model
                                                        .vacaMaeTextController
                                                        .text,
                                                    grupoAnimal:
                                                        _model.grupoValue,
                                                    brincoAnimalOrder: _model.brincoTextController
                                                                    .text !=
                                                                ''
                                                        ? int.tryParse(_model
                                                            .brincoTextController
                                                            .text)
                                                        : 999999,
                                                    brincoAnimal: _model.brincoTextController
                                                                    .text !=
                                                                ''
                                                        ? int.tryParse(_model
                                                            .brincoTextController
                                                            .text)
                                                        : -1,
                                                    nomeBrincoConcat: () {
                                                      if ((_model.nomeTextController.text != '') &&
                                                          (_model.brincoTextController
                                                                      .text !=
                                                                  '') &&
                                                          (_model.brincoTextController
                                                                  .text !=
                                                              '-1')) {
                                                        return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                                      } else if (_model.nomeTextController
                                                                  .text !=
                                                              '') {
                                                        return _model
                                                            .nomeTextController
                                                            .text;
                                                      } else {
                                                        return _model
                                                            .brincoTextController
                                                            .text;
                                                      }
                                                    }(),
                                                    dtUltimoParto: _model
                                                        .dataUltimoPartoTextController
                                                        .text,
                                                    status: _model
                                                        .statusAnimalValue,
                                                    totalPartos:
                                                        _model.dataUltimoPartoTextController
                                                                        .text !=
                                                                    ''
                                                            ? 1
                                                            : 0,
                                                    idStatusAnimal: 2,
                                                    dtUltimoPartoContingencia:
                                                        _model
                                                            .dataUltimoPartoTextController
                                                            .text,
                                                    uidAnimalOffline: functions
                                                        .criarUidRandom(),
                                                  ));
                                                  safeSetState(() {});
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Animal cadastrado com sucesso!',
                                                        style: TextStyle(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                        ),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                  );
                                                  if (Navigator.of(context)
                                                      .canPop()) {
                                                    context.pop();
                                                  }
                                                  context.pushNamed(
                                                    ListaAnimaisWidget
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
                                                        widget
                                                            .emailPropriedade,
                                                        ParamType.String,
                                                      ),
                                                      'visitaPresencial':
                                                          serializeParam(
                                                        widget
                                                            .visitaPresencial,
                                                        ParamType.bool,
                                                      ),
                                                      'initialTabSelect':
                                                          serializeParam(
                                                        widget
                                                            .initialTabSelect,
                                                        ParamType.int,
                                                      ),
                                                      'diasDg': serializeParam(
                                                        widget.diasDg,
                                                        ParamType.String,
                                                      ),
                                                      'tabBarOpenSelected':
                                                          serializeParam(
                                                        0,
                                                        ParamType.int,
                                                      ),
                                                    }.withoutNulls,
                                                  );

                                                  if (_shouldSetState)
                                                    safeSetState(() {});
                                                  return;
                                                } else {
                                                  if (_model
                                                          .statusAnimalValue ==
                                                      'Prenha') {
                                                    if ((_model.dataUltimaInseminacaoTextController
                                                                    .text !=
                                                                '') &&
                                                        (_model.touroInseminacaoValue !=
                                                                null &&
                                                            _model.touroInseminacaoValue !=
                                                                '')) {
                                                      FFAppState()
                                                          .addToAnimaisProdutoresOffline(
                                                              AnimaisProdutoresStruct(
                                                        uidTecnicoPropriedade:
                                                            widget
                                                                .uidPropriedade,
                                                        nomeAnimal: _model
                                                            .nomeTextController
                                                            .text,
                                                        racaAnimal:
                                                            _model.racaValue,
                                                        pesoAnimal: _model
                                                            .pesoTextController
                                                            .text,
                                                        dtNascimento: _model
                                                            .dataNascimentoTextController
                                                            .text,
                                                        touro: _model
                                                            .touroPaiTextController
                                                            .text,
                                                        vaca: _model
                                                            .vacaMaeTextController
                                                            .text,
                                                        grupoAnimal:
                                                            _model.grupoValue,
                                                        brincoAnimalOrder: _model.brincoTextController
                                                                        .text !=
                                                                    ''
                                                            ? int.tryParse(_model
                                                                .brincoTextController
                                                                .text)
                                                            : 999999,
                                                        brincoAnimal: _model.brincoTextController
                                                                        .text !=
                                                                    ''
                                                            ? int.tryParse(_model
                                                                .brincoTextController
                                                                .text)
                                                            : -1,
                                                        nomeBrincoConcat: () {
                                                          if ((_model.nomeTextController.text != '') &&
                                                              (_model.brincoTextController
                                                                          .text !=
                                                                      '') &&
                                                              (_model.brincoTextController
                                                                      .text !=
                                                                  '-1')) {
                                                            return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                                          } else if (_model.nomeTextController
                                                                      .text !=
                                                                  '') {
                                                            return _model
                                                                .nomeTextController
                                                                .text;
                                                          } else {
                                                            return _model
                                                                .brincoTextController
                                                                .text;
                                                          }
                                                        }(),
                                                        status: _model
                                                            .statusAnimalValue,
                                                        dtUltimaInseminacao: _model
                                                            .dataUltimaInseminacaoTextController
                                                            .text,
                                                        nomeTouroUltimaInseminacao:
                                                            _model
                                                                .touroInseminacaoValue,
                                                        dtPartoPrevisto: functions
                                                            .somarDataParto(_model
                                                                .dataUltimaInseminacaoTextController
                                                                .text),
                                                        dtSecPrevista: functions
                                                            .somarDataSecagem(_model
                                                                .dataUltimaInseminacaoTextController
                                                                .text),
                                                        dtPrePartoPrevista: functions
                                                            .somarDataPreParto(
                                                                _model
                                                                    .dataUltimaInseminacaoTextController
                                                                    .text),
                                                        totalInseminacoes: 1,
                                                        dtDgMais:
                                                            dateTimeFormat(
                                                          "dd/MM/yyyy",
                                                          getCurrentTimestamp,
                                                          locale:
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .languageCode,
                                                        ),
                                                        dtUltimoParto: _model
                                                            .dataUltimoPartoTextController
                                                            .text,
                                                        compararDtUltimaInseminacao:
                                                            functions
                                                                .converterDataUltimaInseminacao(
                                                                    _model
                                                                        .dataUltimaInseminacaoTextController
                                                                        .text),
                                                        idStatusAnimal: 6,
                                                        dtUltimoPartoContingencia:
                                                            _model
                                                                .dataUltimoPartoTextController
                                                                .text,
                                                        uidAnimalOffline:
                                                            functions
                                                                .criarUidRandom(),
                                                      ));
                                                      safeSetState(() {});
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'Animal cadastrado com sucesso!',
                                                            style: TextStyle(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                            ),
                                                          ),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  4000),
                                                          backgroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondary,
                                                        ),
                                                      );
                                                      if (Navigator.of(context)
                                                          .canPop()) {
                                                        context.pop();
                                                      }
                                                      context.pushNamed(
                                                        ListaAnimaisWidget
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
                                                          'visitaPresencial':
                                                              serializeParam(
                                                            widget
                                                                .visitaPresencial,
                                                            ParamType.bool,
                                                          ),
                                                          'initialTabSelect':
                                                              serializeParam(
                                                            widget
                                                                .initialTabSelect,
                                                            ParamType.int,
                                                          ),
                                                          'diasDg':
                                                              serializeParam(
                                                            widget.diasDg,
                                                            ParamType.String,
                                                          ),
                                                          'tabBarOpenSelected':
                                                              serializeParam(
                                                            0,
                                                            ParamType.int,
                                                          ),
                                                        }.withoutNulls,
                                                      );

                                                      if (_shouldSetState)
                                                        safeSetState(() {});
                                                      return;
                                                    } else {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Data última inseminação vazia ou Touro inseminação não selecionado.'),
                                                            content: Text(
                                                                'Preencha os campos obrigatórios.'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext),
                                                                child:
                                                                    Text('Ok'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                      if (_shouldSetState)
                                                        safeSetState(() {});
                                                      return;
                                                    }
                                                  } else {
                                                    if (_model
                                                            .statusAnimalValue ==
                                                        'Inseminada PP') {
                                                      if ((_model.dataUltimaInseminacaoTextController
                                                                      .text !=
                                                                  '') &&
                                                          (_model.touroInseminacaoValue !=
                                                                  null &&
                                                              _model.touroInseminacaoValue !=
                                                                  '')) {
                                                        FFAppState()
                                                            .addToAnimaisProdutoresOffline(
                                                                AnimaisProdutoresStruct(
                                                          uidTecnicoPropriedade:
                                                              widget
                                                                  .uidPropriedade,
                                                          nomeAnimal: _model
                                                              .nomeTextController
                                                              .text,
                                                          racaAnimal:
                                                              _model.racaValue,
                                                          pesoAnimal: _model
                                                              .pesoTextController
                                                              .text,
                                                          dtNascimento: _model
                                                              .dataNascimentoTextController
                                                              .text,
                                                          touro: _model
                                                              .touroPaiTextController
                                                              .text,
                                                          vaca: _model
                                                              .vacaMaeTextController
                                                              .text,
                                                          grupoAnimal:
                                                              _model.grupoValue,
                                                          brincoAnimalOrder: _model.brincoTextController
                                                                          .text !=
                                                                      ''
                                                              ? int.tryParse(_model
                                                                  .brincoTextController
                                                                  .text)
                                                              : 999999,
                                                          brincoAnimal: _model.brincoTextController
                                                                          .text !=
                                                                      ''
                                                              ? int.tryParse(_model
                                                                  .brincoTextController
                                                                  .text)
                                                              : -1,
                                                          nomeBrincoConcat: () {
                                                            if ((_model.nomeTextController.text != '') &&
                                                                (_model.brincoTextController
                                                                            .text !=
                                                                        '') &&
                                                                (_model.brincoTextController
                                                                        .text !=
                                                                    '-1')) {
                                                              return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                                            } else if (_model.nomeTextController
                                                                        .text !=
                                                                    '') {
                                                              return _model
                                                                  .nomeTextController
                                                                  .text;
                                                            } else {
                                                              return _model
                                                                  .brincoTextController
                                                                  .text;
                                                            }
                                                          }(),
                                                          status: _model
                                                              .statusAnimalValue,
                                                          dtUltimaInseminacao:
                                                              _model
                                                                  .dataUltimaInseminacaoTextController
                                                                  .text,
                                                          nomeTouroUltimaInseminacao:
                                                              _model
                                                                  .touroInseminacaoValue,
                                                          dtPartoPrevisto: functions
                                                              .somarDataParto(_model
                                                                  .dataUltimaInseminacaoTextController
                                                                  .text),
                                                          dtSecPrevista: functions
                                                              .somarDataSecagem(
                                                                  _model
                                                                      .dataUltimaInseminacaoTextController
                                                                      .text),
                                                          dtPrePartoPrevista: functions
                                                              .somarDataPreParto(
                                                                  _model
                                                                      .dataUltimaInseminacaoTextController
                                                                      .text),
                                                          totalInseminacoes: 1,
                                                          dtPP: dateTimeFormat(
                                                            "dd/MM/yyyy",
                                                            getCurrentTimestamp,
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          ),
                                                          dtUltimoPP:
                                                              dateTimeFormat(
                                                            "dd/MM/yyyy",
                                                            getCurrentTimestamp,
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          ),
                                                          dtUltimoParto: _model
                                                              .dataUltimoPartoTextController
                                                              .text,
                                                          compararDtUltimaInseminacao:
                                                              functions.converterDataUltimaInseminacao(
                                                                  _model
                                                                      .dataUltimaInseminacaoTextController
                                                                      .text),
                                                          idStatusAnimal: 1,
                                                          dtUltimoPartoContingencia:
                                                              _model
                                                                  .dataUltimoPartoTextController
                                                                  .text,
                                                          uidAnimalOffline:
                                                              functions
                                                                  .criarUidRandom(),
                                                        ));
                                                        safeSetState(() {});
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'Animal cadastrado com sucesso!',
                                                              style: TextStyle(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                              ),
                                                            ),
                                                            duration: Duration(
                                                                milliseconds:
                                                                    4000),
                                                            backgroundColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary,
                                                          ),
                                                        );
                                                        if (Navigator.of(
                                                                context)
                                                            .canPop()) {
                                                          context.pop();
                                                        }
                                                        context.pushNamed(
                                                          ListaAnimaisWidget
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
                                                              widget
                                                                  .uidTecnico,
                                                              ParamType
                                                                  .DocumentReference,
                                                            ),
                                                            'emailPropriedade':
                                                                serializeParam(
                                                              widget
                                                                  .emailPropriedade,
                                                              ParamType.String,
                                                            ),
                                                            'visitaPresencial':
                                                                serializeParam(
                                                              widget
                                                                  .visitaPresencial,
                                                              ParamType.bool,
                                                            ),
                                                            'initialTabSelect':
                                                                serializeParam(
                                                              widget
                                                                  .initialTabSelect,
                                                              ParamType.int,
                                                            ),
                                                            'diasDg':
                                                                serializeParam(
                                                              widget.diasDg,
                                                              ParamType.String,
                                                            ),
                                                            'tabBarOpenSelected':
                                                                serializeParam(
                                                              0,
                                                              ParamType.int,
                                                            ),
                                                          }.withoutNulls,
                                                        );

                                                        if (_shouldSetState)
                                                          safeSetState(() {});
                                                        return;
                                                      } else {
                                                        await showDialog(
                                                          context: context,
                                                          builder:
                                                              (alertDialogContext) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Data última inseminação vazia ou Touro inseminação não selecionado.'),
                                                              content: Text(
                                                                  'Preencha os campos obrigatórios.'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          alertDialogContext),
                                                                  child: Text(
                                                                      'Ok'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                        if (_shouldSetState)
                                                          safeSetState(() {});
                                                        return;
                                                      }
                                                    } else {
                                                      if (_model
                                                              .statusAnimalValue ==
                                                          'Pré Parto') {
                                                        if ((_model.dataUltimaInseminacaoTextController
                                                                        .text !=
                                                                    '') &&
                                                            (_model.touroInseminacaoValue !=
                                                                    null &&
                                                                _model.touroInseminacaoValue !=
                                                                    '')) {
                                                          FFAppState()
                                                              .addToAnimaisProdutoresOffline(
                                                                  AnimaisProdutoresStruct(
                                                            uidTecnicoPropriedade:
                                                                widget
                                                                    .uidPropriedade,
                                                            nomeAnimal: _model
                                                                .nomeTextController
                                                                .text,
                                                            racaAnimal: _model
                                                                .racaValue,
                                                            pesoAnimal: _model
                                                                .pesoTextController
                                                                .text,
                                                            dtNascimento: _model
                                                                .dataNascimentoTextController
                                                                .text,
                                                            touro: _model
                                                                .touroPaiTextController
                                                                .text,
                                                            vaca: _model
                                                                .vacaMaeTextController
                                                                .text,
                                                            grupoAnimal: _model
                                                                .grupoValue,
                                                            brincoAnimalOrder: _model.brincoTextController
                                                                            .text !=
                                                                        ''
                                                                ? int.tryParse(
                                                                    _model
                                                                        .brincoTextController
                                                                        .text)
                                                                : 999999,
                                                            brincoAnimal: _model.brincoTextController
                                                                            .text !=
                                                                        ''
                                                                ? int.tryParse(
                                                                    _model
                                                                        .brincoTextController
                                                                        .text)
                                                                : -1,
                                                            nomeBrincoConcat:
                                                                () {
                                                              if ((_model.nomeTextController.text != '') &&
                                                                  (_model.brincoTextController
                                                                              .text !=
                                                                          '') &&
                                                                  (_model.brincoTextController
                                                                          .text !=
                                                                      '-1')) {
                                                                return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                                              } else if (_model.nomeTextController
                                                                          .text !=
                                                                      '') {
                                                                return _model
                                                                    .nomeTextController
                                                                    .text;
                                                              } else {
                                                                return _model
                                                                    .brincoTextController
                                                                    .text;
                                                              }
                                                            }(),
                                                            status: _model
                                                                .statusAnimalValue,
                                                            dtUltimaInseminacao:
                                                                _model
                                                                    .dataUltimaInseminacaoTextController
                                                                    .text,
                                                            nomeTouroUltimaInseminacao:
                                                                _model
                                                                    .touroInseminacaoValue,
                                                            dtPartoPrevisto: functions
                                                                .somarDataParto(
                                                                    _model
                                                                        .dataUltimaInseminacaoTextController
                                                                        .text),
                                                            dtSecPrevista: functions
                                                                .somarDataSecagem(
                                                                    _model
                                                                        .dataUltimaInseminacaoTextController
                                                                        .text),
                                                            dtPrePartoPrevista:
                                                                functions.somarDataPreParto(
                                                                    _model
                                                                        .dataUltimaInseminacaoTextController
                                                                        .text),
                                                            totalInseminacoes:
                                                                1,
                                                            dtPP:
                                                                dateTimeFormat(
                                                              "dd/MM/yyyy",
                                                              getCurrentTimestamp,
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ),
                                                            dtUltimoPP:
                                                                dateTimeFormat(
                                                              "dd/MM/yyyy",
                                                              getCurrentTimestamp,
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ),
                                                            dtUltimoParto: _model
                                                                .dataUltimoPartoTextController
                                                                .text,
                                                            compararDtUltimaInseminacao:
                                                                functions.converterDataUltimaInseminacao(
                                                                    _model
                                                                        .dataUltimaInseminacaoTextController
                                                                        .text),
                                                            idStatusAnimal: 5,
                                                            dtUltimoPartoContingencia:
                                                                _model
                                                                    .dataUltimoPartoTextController
                                                                    .text,
                                                            uidAnimalOffline:
                                                                functions
                                                                    .criarUidRandom(),
                                                          ));
                                                          safeSetState(() {});
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                'Animal cadastrado com sucesso!',
                                                                style:
                                                                    TextStyle(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                ),
                                                              ),
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      4000),
                                                              backgroundColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                            ),
                                                          );
                                                          if (Navigator.of(
                                                                  context)
                                                              .canPop()) {
                                                            context.pop();
                                                          }
                                                          context.pushNamed(
                                                            ListaAnimaisWidget
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
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'uidTecnico':
                                                                  serializeParam(
                                                                widget
                                                                    .uidTecnico,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                              'emailPropriedade':
                                                                  serializeParam(
                                                                widget
                                                                    .emailPropriedade,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'visitaPresencial':
                                                                  serializeParam(
                                                                widget
                                                                    .visitaPresencial,
                                                                ParamType.bool,
                                                              ),
                                                              'initialTabSelect':
                                                                  serializeParam(
                                                                widget
                                                                    .initialTabSelect,
                                                                ParamType.int,
                                                              ),
                                                              'diasDg':
                                                                  serializeParam(
                                                                widget.diasDg,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'tabBarOpenSelected':
                                                                  serializeParam(
                                                                0,
                                                                ParamType.int,
                                                              ),
                                                            }.withoutNulls,
                                                          );

                                                          if (_shouldSetState)
                                                            safeSetState(() {});
                                                          return;
                                                        } else {
                                                          await showDialog(
                                                            context: context,
                                                            builder:
                                                                (alertDialogContext) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Data última inseminação vazia ou Touro inseminação não selecionado.'),
                                                                content: Text(
                                                                    'Preencha os campos obrigatórios.'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            alertDialogContext),
                                                                    child: Text(
                                                                        'Ok'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                          if (_shouldSetState)
                                                            safeSetState(() {});
                                                          return;
                                                        }
                                                      } else {
                                                        if (_shouldSetState)
                                                          safeSetState(() {});
                                                        return;
                                                      }
                                                    }
                                                  }
                                                }
                                              }
                                            }
                                          } else {
                                            await showDialog(
                                              context: context,
                                              builder: (alertDialogContext) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Status é obrigatório.'),
                                                  content: Text(
                                                      'Selecione ao menos um status.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              alertDialogContext),
                                                      child: Text('Ok'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            if (_shouldSetState)
                                              safeSetState(() {});
                                            return;
                                          }
                                        } else {
                                          if ((_model.grupoValue == 'Sêmens') ||
                                              (_model.grupoValue == 'Touros')) {
                                            if (_model.grupoValue == 'Touros') {
                                              FFAppState()
                                                  .addToAnimaisProdutoresOffline(
                                                      AnimaisProdutoresStruct(
                                                uidTecnicoPropriedade:
                                                    widget.uidPropriedade,
                                                nomeAnimal: _model
                                                    .nomeTextController.text,
                                                racaAnimal: _model.racaValue,
                                                pesoAnimal: _model
                                                    .pesoTextController.text,
                                                dtNascimento: _model
                                                    .dataNascimentoTextController
                                                    .text,
                                                touro: _model
                                                    .touroPaiTextController
                                                    .text,
                                                vaca: _model
                                                    .vacaMaeTextController.text,
                                                grupoAnimal: _model.grupoValue,
                                                brincoAnimalOrder: _model.brincoTextController
                                                                .text !=
                                                            ''
                                                    ? int.tryParse(_model
                                                        .brincoTextController
                                                        .text)
                                                    : 999999,
                                                brincoAnimal: _model.brincoTextController
                                                                .text !=
                                                            ''
                                                    ? int.tryParse(_model
                                                        .brincoTextController
                                                        .text)
                                                    : -1,
                                                nomeBrincoConcat: () {
                                                  if ((_model.nomeTextController.text != '') &&
                                                      (_model.brincoTextController
                                                                  .text !=
                                                              '') &&
                                                      (_model.brincoTextController
                                                              .text !=
                                                          '-1')) {
                                                    return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                                  } else if (_model.nomeTextController
                                                              .text !=
                                                          '') {
                                                    return _model
                                                        .nomeTextController
                                                        .text;
                                                  } else {
                                                    return _model
                                                        .brincoTextController
                                                        .text;
                                                  }
                                                }(),
                                                liberaInseminacao: () {
                                                  if (_model.grupoValue ==
                                                      'Touros') {
                                                    return _model.switchValue;
                                                  } else if (_model
                                                          .grupoValue ==
                                                      'Sêmens') {
                                                    return _model.switchValue;
                                                  } else {
                                                    return true;
                                                  }
                                                }(),
                                                uidAnimalOffline:
                                                    functions.criarUidRandom(),
                                              ));
                                              safeSetState(() {});
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Animal cadastrado com sucesso!',
                                                    style: TextStyle(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                    ),
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 4000),
                                                  backgroundColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondary,
                                                ),
                                              );
                                              if (Navigator.of(context)
                                                  .canPop()) {
                                                context.pop();
                                              }
                                              context.pushNamed(
                                                ListaAnimaisWidget.routeName,
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
                                                  'visitaPresencial':
                                                      serializeParam(
                                                    widget.visitaPresencial,
                                                    ParamType.bool,
                                                  ),
                                                  'initialTabSelect':
                                                      serializeParam(
                                                    widget.initialTabSelect,
                                                    ParamType.int,
                                                  ),
                                                  'diasDg': serializeParam(
                                                    widget.diasDg,
                                                    ParamType.String,
                                                  ),
                                                }.withoutNulls,
                                              );

                                              if (_shouldSetState)
                                                safeSetState(() {});
                                              return;
                                            } else {
                                              if (_model.grupoValue ==
                                                  'Sêmens') {
                                                FFAppState()
                                                    .addToAnimaisProdutoresOffline(
                                                        AnimaisProdutoresStruct(
                                                  uidTecnicoPropriedade:
                                                      widget.uidPropriedade,
                                                  nomeAnimal: _model
                                                      .nomeTextController.text,
                                                  racaAnimal: _model.racaValue,
                                                  pesoAnimal: _model
                                                      .pesoTextController.text,
                                                  dtNascimento: _model
                                                      .dataNascimentoTextController
                                                      .text,
                                                  touro: _model
                                                      .touroPaiTextController
                                                      .text,
                                                  grupoAnimal:
                                                      _model.grupoValue,
                                                  brincoAnimalOrder: _model.brincoTextController
                                                                  .text !=
                                                              ''
                                                      ? int.tryParse(_model
                                                          .brincoTextController
                                                          .text)
                                                      : 999999,
                                                  brincoAnimal: _model.brincoTextController
                                                                  .text !=
                                                              ''
                                                      ? int.tryParse(_model
                                                          .brincoTextController
                                                          .text)
                                                      : -1,
                                                  nomeBrincoConcat: () {
                                                    if ((_model.nomeTextController.text != '') &&
                                                        (_model.brincoTextController
                                                                    .text !=
                                                                '') &&
                                                        (_model.brincoTextController
                                                                .text !=
                                                            '-1')) {
                                                      return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                                    } else if (_model.nomeTextController
                                                                .text !=
                                                            '') {
                                                      return _model
                                                          .nomeTextController
                                                          .text;
                                                    } else {
                                                      return _model
                                                          .brincoTextController
                                                          .text;
                                                    }
                                                  }(),
                                                  liberaInseminacao: () {
                                                    if (_model.grupoValue ==
                                                        'Touros') {
                                                      return _model.switchValue;
                                                    } else if (_model
                                                            .grupoValue ==
                                                        'Sêmens') {
                                                      return _model.switchValue;
                                                    } else {
                                                      return true;
                                                    }
                                                  }(),
                                                  uidAnimalOffline: functions
                                                      .criarUidRandom(),
                                                ));
                                                safeSetState(() {});
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Animal cadastrado com sucesso!',
                                                      style: TextStyle(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                    backgroundColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .secondary,
                                                  ),
                                                );
                                                if (Navigator.of(context)
                                                    .canPop()) {
                                                  context.pop();
                                                }
                                                context.pushNamed(
                                                  ListaAnimaisWidget.routeName,
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
                                                    'visitaPresencial':
                                                        serializeParam(
                                                      widget.visitaPresencial,
                                                      ParamType.bool,
                                                    ),
                                                    'initialTabSelect':
                                                        serializeParam(
                                                      widget.initialTabSelect,
                                                      ParamType.int,
                                                    ),
                                                    'diasDg': serializeParam(
                                                      widget.diasDg,
                                                      ParamType.String,
                                                    ),
                                                  }.withoutNulls,
                                                );

                                                if (_shouldSetState)
                                                  safeSetState(() {});
                                                return;
                                              } else {
                                                if (_shouldSetState)
                                                  safeSetState(() {});
                                                return;
                                              }
                                            }
                                          } else {
                                            FFAppState()
                                                .addToAnimaisProdutoresOffline(
                                                    AnimaisProdutoresStruct(
                                              uidTecnicoPropriedade:
                                                  widget.uidPropriedade,
                                              nomeAnimal: _model
                                                  .nomeTextController.text,
                                              racaAnimal: _model.racaValue,
                                              pesoAnimal: _model
                                                  .pesoTextController.text,
                                              dtNascimento: _model
                                                  .dataNascimentoTextController
                                                  .text,
                                              touro: _model
                                                  .touroPaiTextController.text,
                                              vaca: _model
                                                  .vacaMaeTextController.text,
                                              grupoAnimal: _model.grupoValue,
                                              brincoAnimalOrder: _model.brincoTextController
                                                              .text !=
                                                          ''
                                                  ? int.tryParse(_model
                                                      .brincoTextController
                                                      .text)
                                                  : 999999,
                                              brincoAnimal: _model.brincoTextController
                                                              .text !=
                                                          ''
                                                  ? int.tryParse(_model
                                                      .brincoTextController
                                                      .text)
                                                  : -1,
                                              nomeBrincoConcat: () {
                                                if ((_model
                                                                .nomeTextController
                                                                .text !=
                                                            '') &&
                                                    (_model.brincoTextController
                                                                .text !=
                                                            '') &&
                                                    (_model.brincoTextController
                                                            .text !=
                                                        '-1')) {
                                                  return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                                } else if (_model.nomeTextController
                                                            .text !=
                                                        '') {
                                                  return _model
                                                      .nomeTextController.text;
                                                } else {
                                                  return _model
                                                      .brincoTextController
                                                      .text;
                                                }
                                              }(),
                                              uidAnimalOffline:
                                                  functions.criarUidRandom(),
                                            ));
                                            safeSetState(() {});
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Animal cadastrado com sucesso!',
                                                  style: TextStyle(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                  ),
                                                ),
                                                duration: Duration(
                                                    milliseconds: 4000),
                                                backgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                              ),
                                            );
                                            if (Navigator.of(context)
                                                .canPop()) {
                                              context.pop();
                                            }
                                            context.pushNamed(
                                              ListaAnimaisWidget.routeName,
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
                                                'visitaPresencial':
                                                    serializeParam(
                                                  widget.visitaPresencial,
                                                  ParamType.bool,
                                                ),
                                                'initialTabSelect':
                                                    serializeParam(
                                                  widget.initialTabSelect,
                                                  ParamType.int,
                                                ),
                                                'diasDg': serializeParam(
                                                  widget.diasDg,
                                                  ParamType.String,
                                                ),
                                              }.withoutNulls,
                                            );

                                            if (_shouldSetState)
                                              safeSetState(() {});
                                            return;
                                          }
                                        }
                                      }

                                      if (_shouldSetState) safeSetState(() {});
                                    },
                                    text: 'Adicionar Novo',
                                    icon: Icon(
                                      Icons.save,
                                      size: 15.0,
                                    ),
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 48.0,
                                      padding: EdgeInsets.all(0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: Color(0xFFEC3B5B),
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
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                      elevation: 4.0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(60.0),
                                    ),
                                  ),
                                ),
                              ].divide(SizedBox(height: 12.0)),
                            ),
                          ),
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
  }
}
