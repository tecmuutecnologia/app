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
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'editar_animal_model.dart';
export 'editar_animal_model.dart';

class EditarAnimalWidget extends StatefulWidget {
  const EditarAnimalWidget({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.grupoPredominante,
    required this.visitaPresencial,
    int? initialTabSelect,
    required this.uidAnimal,
    required this.diasDg,
  }) : this.initialTabSelect = initialTabSelect ?? 0;

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final String? grupoPredominante;
  final bool? visitaPresencial;
  final int initialTabSelect;
  final DocumentReference? uidAnimal;
  final String? diasDg;

  static String routeName = 'editarAnimal';
  static String routePath = '/editarAnimal';

  @override
  State<EditarAnimalWidget> createState() => _EditarAnimalWidgetState();
}

class _EditarAnimalWidgetState extends State<EditarAnimalWidget> {
  late EditarAnimalModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditarAnimalModel());

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

    _model.nomeFocusNode ??= FocusNode();

    _model.brincoFocusNode ??= FocusNode();

    _model.pesoFocusNode ??= FocusNode();

    _model.dataNascimentoFocusNode ??= FocusNode();

    _model.dataNascimentoMask = MaskTextInputFormatter(mask: '##/##/####');

    _model.touroFocusNode ??= FocusNode();

    _model.vacaFocusNode ??= FocusNode();

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

    return StreamBuilder<AnimaisProdutoresRecord>(
      stream: AnimaisProdutoresRecord.getDocument(widget.uidAnimal!),
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

        final editarAnimalAnimaisProdutoresRecord = snapshot.data!;

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
                            'Editar animal',
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
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                TextFormField(
                                  controller: _model.nomeTextController ??=
                                      TextEditingController(
                                    text: editarAnimalAnimaisProdutoresRecord
                                        .nomeAnimal,
                                  ),
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
                                  controller: _model.brincoTextController ??=
                                      TextEditingController(
                                    text: editarAnimalAnimaisProdutoresRecord
                                        .brincoAnimal
                                        .toString(),
                                  ),
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
                                  stream: queryRacasRecord(),
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
                                        _model.racaValue ??=
                                            editarAnimalAnimaisProdutoresRecord
                                                .racaAnimal,
                                      ),
                                      options: racaRacasRecordList
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
                                  stream: queryGrupoRecord(),
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
                                            editarAnimalAnimaisProdutoresRecord
                                                .grupoAnimal,
                                      ),
                                      options: grupoGrupoRecordList
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
                                        value: _model.switchValue ??=
                                            editarAnimalAnimaisProdutoresRecord
                                                .liberaInseminacao,
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
                                    controller: _model.pesoTextController ??=
                                        TextEditingController(
                                      text: editarAnimalAnimaisProdutoresRecord
                                          .pesoAnimal,
                                    ),
                                    focusNode: _model.pesoFocusNode,
                                    autofocus: false,
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
                                    keyboardType: TextInputType.number,
                                    cursorColor:
                                        FlutterFlowTheme.of(context).primary,
                                    validator: _model
                                        .pesoTextControllerValidator
                                        .asValidator(context),
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
                                                  .dataNascimentoTextController ??=
                                              TextEditingController(
                                            text:
                                                editarAnimalAnimaisProdutoresRecord
                                                    .dtNascimento,
                                          ),
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
                                              final _datePickedCupertinoTheme =
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
                                                        _datePickedCupertinoTheme
                                                            .copyWith(
                                                      textTheme:
                                                          _datePickedCupertinoTheme
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
                                                      maximumDate: (DateTime
                                                              .fromMicrosecondsSinceEpoch(
                                                                  2024708400000000) ??
                                                          DateTime(2050)),
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryBackground,
                                                      use24hFormat: false,
                                                      onDateTimeChanged:
                                                          (newDateTime) =>
                                                              safeSetState(() {
                                                        _model.datePicked =
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
                                            _model.datePicked,
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
                                  controller: _model.touroTextController ??=
                                      TextEditingController(
                                    text: editarAnimalAnimaisProdutoresRecord
                                        .touro,
                                  ),
                                  focusNode: _model.touroFocusNode,
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
                                  validator: _model.touroTextControllerValidator
                                      .asValidator(context),
                                ),
                                TextFormField(
                                  controller: _model.vacaTextController ??=
                                      TextEditingController(
                                    text: editarAnimalAnimaisProdutoresRecord
                                        .vaca,
                                  ),
                                  focusNode: _model.vacaFocusNode,
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
                                  validator: _model.vacaTextControllerValidator
                                      .asValidator(context),
                                ),
                              ].divide(SizedBox(height: 12.0)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 24.0, 0.0, 12.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            if ((_model.nomeTextController.text != '') ||
                                (_model.brincoTextController.text != '')) {
                              if (_model.formKey.currentState == null ||
                                  !_model.formKey.currentState!.validate()) {
                                return;
                              }
                              if (_model.racaValue == null) {
                                return;
                              }
                              if (_model.grupoValue == null) {
                                return;
                              }
                              if ((_model.grupoValue == 'Vacas') ||
                                  (_model.grupoValue == 'Novilhas')) {
                                await widget.uidAnimal!
                                    .update(createAnimaisProdutoresRecordData(
                                  uidTecnicoPropriedade:
                                      editarAnimalAnimaisProdutoresRecord
                                          .uidTecnicoPropriedade,
                                  nomeAnimal: _model.nomeTextController.text,
                                  brincoAnimal: int.tryParse(
                                      _model.brincoTextController.text),
                                  racaAnimal: _model.racaValue,
                                  pesoAnimal: _model.pesoTextController.text,
                                  dtNascimento:
                                      _model.dataNascimentoTextController.text,
                                  touro: _model.touroTextController.text,
                                  vaca: _model.vacaTextController.text,
                                  grupoAnimal:
                                      editarAnimalAnimaisProdutoresRecord
                                          .grupoAnimal,
                                  nomeBrincoConcat: () {
                                    if ((_model
                                                    .nomeTextController.text !=
                                                '') &&
                                        (_model.brincoTextController.text !=
                                                '') &&
                                        (_model.brincoTextController.text !=
                                            '-1')) {
                                      return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                    } else if (_model.nomeTextController.text != '') {
                                      return _model.nomeTextController.text;
                                    } else {
                                      return _model.brincoTextController.text;
                                    }
                                  }(),
                                  brincoAnimalOrder: (_model.brincoTextController
                                                      .text !=
                                                  '') &&
                                          (_model.brincoTextController.text !=
                                              '-1')
                                      ? int.tryParse(
                                          _model.brincoTextController.text)
                                      : 999999,
                                ));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Animal atualizado com sucesso!',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).secondary,
                                  ),
                                );

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

                                return;
                              } else {
                                if (_model.grupoValue == 'Touros') {
                                  await widget.uidAnimal!
                                      .update(createAnimaisProdutoresRecordData(
                                    uidTecnicoPropriedade:
                                        editarAnimalAnimaisProdutoresRecord
                                            .uidTecnicoPropriedade,
                                    nomeAnimal: _model.nomeTextController.text,
                                    brincoAnimal: int.tryParse(
                                        _model.brincoTextController.text),
                                    racaAnimal: _model.racaValue,
                                    pesoAnimal: _model.pesoTextController.text,
                                    dtNascimento: _model
                                        .dataNascimentoTextController.text,
                                    touro: _model.touroTextController.text,
                                    vaca: _model.vacaTextController.text,
                                    grupoAnimal:
                                        editarAnimalAnimaisProdutoresRecord
                                            .grupoAnimal,
                                    nomeBrincoConcat: () {
                                      if ((_model.nomeTextController.text !=
                                                  '') &&
                                          (_model.brincoTextController
                                                      .text !=
                                                  '') &&
                                          (_model.brincoTextController.text !=
                                              '-1')) {
                                        return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                      } else if (_model.nomeTextController.text !=
                                              '') {
                                        return _model.nomeTextController.text;
                                      } else {
                                        return _model.brincoTextController.text;
                                      }
                                    }(),
                                    brincoAnimalOrder: (_model.brincoTextController
                                                        .text !=
                                                    '') &&
                                            (_model.brincoTextController.text !=
                                                '-1')
                                        ? int.tryParse(
                                            _model.brincoTextController.text)
                                        : 999999,
                                    liberaInseminacao: _model.switchValue,
                                  ));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Animal atualizado com sucesso!',
                                        style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                        ),
                                      ),
                                      duration: Duration(milliseconds: 4000),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .secondary,
                                    ),
                                  );

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

                                  return;
                                } else {
                                  if (_model.grupoValue == 'Sêmens') {
                                    await widget.uidAnimal!.update(
                                        createAnimaisProdutoresRecordData(
                                      uidTecnicoPropriedade:
                                          editarAnimalAnimaisProdutoresRecord
                                              .uidTecnicoPropriedade,
                                      nomeAnimal:
                                          _model.nomeTextController.text,
                                      brincoAnimal: int.tryParse(
                                          _model.brincoTextController.text),
                                      racaAnimal: _model.racaValue,
                                      dtNascimento: _model
                                          .dataNascimentoTextController.text,
                                      touro: _model.touroTextController.text,
                                      vaca: _model.vacaTextController.text,
                                      grupoAnimal:
                                          editarAnimalAnimaisProdutoresRecord
                                              .grupoAnimal,
                                      nomeBrincoConcat: () {
                                        if ((_model.nomeTextController
                                                        .text !=
                                                    '') &&
                                            (_model.brincoTextController
                                                        .text !=
                                                    '') &&
                                            (editarAnimalAnimaisProdutoresRecord
                                                    .brincoAnimal !=
                                                -1)) {
                                          return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                        } else if (_model.nomeTextController.text !=
                                                '') {
                                          return _model.nomeTextController.text;
                                        } else {
                                          return _model
                                              .brincoTextController.text;
                                        }
                                      }(),
                                      brincoAnimalOrder: (_model.brincoTextController
                                                          .text !=
                                                      '') &&
                                              (_model.brincoTextController
                                                      .text !=
                                                  '-1')
                                          ? int.tryParse(
                                              _model.brincoTextController.text)
                                          : 999999,
                                      liberaInseminacao: _model.switchValue,
                                    ));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Animal atualizado com sucesso!',
                                          style: TextStyle(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                          ),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                        backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .secondary,
                                      ),
                                    );

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

                                    return;
                                  } else {
                                    await widget.uidAnimal!.update(
                                        createAnimaisProdutoresRecordData(
                                      uidTecnicoPropriedade:
                                          editarAnimalAnimaisProdutoresRecord
                                              .uidTecnicoPropriedade,
                                      nomeAnimal:
                                          _model.nomeTextController.text,
                                      brincoAnimal: int.tryParse(
                                          _model.brincoTextController.text),
                                      racaAnimal: _model.racaValue,
                                      pesoAnimal:
                                          _model.pesoTextController.text,
                                      dtNascimento: _model
                                          .dataNascimentoTextController.text,
                                      touro: _model.touroTextController.text,
                                      vaca: _model.vacaTextController.text,
                                      grupoAnimal:
                                          editarAnimalAnimaisProdutoresRecord
                                              .grupoAnimal,
                                      nomeBrincoConcat: () {
                                        if ((_model.nomeTextController
                                                        .text !=
                                                    '') &&
                                            (_model.brincoTextController
                                                        .text !=
                                                    '') &&
                                            (editarAnimalAnimaisProdutoresRecord
                                                    .brincoAnimal !=
                                                -1)) {
                                          return '${_model.nomeTextController.text} - ${_model.brincoTextController.text}';
                                        } else if (_model.nomeTextController.text !=
                                                '') {
                                          return _model.nomeTextController.text;
                                        } else {
                                          return _model
                                              .brincoTextController.text;
                                        }
                                      }(),
                                      brincoAnimalOrder: (_model.brincoTextController
                                                          .text !=
                                                      '') &&
                                              (_model.brincoTextController
                                                      .text !=
                                                  '-1')
                                          ? int.tryParse(
                                              _model.brincoTextController.text)
                                          : 999999,
                                    ));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Animal atualizado com sucesso!',
                                          style: TextStyle(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                          ),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                        backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .secondary,
                                      ),
                                    );

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

                                    return;
                                  }
                                }
                              }
                            } else {
                              await showDialog(
                                context: context,
                                builder: (alertDialogContext) {
                                  return AlertDialog(
                                    title: Text(
                                        'O campo nome ou brinco é obrigatório.'),
                                    content: Text(
                                        'Informe um nome ou brinco ao animal para avançar.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(alertDialogContext),
                                        child: Text('Ok'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              return;
                            }
                          },
                          text: 'Editar animal',
                          icon: Icon(
                            Icons.save,
                            size: 15.0,
                          ),
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 48.0,
                            padding: EdgeInsets.all(0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: Color(0xFFEC3B5B),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
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
                            elevation: 4.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(60.0),
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
