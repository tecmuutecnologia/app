import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_checkbox_group.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/pages/tecnico/propriedade/calendario_sanitario/nova_acao_calendario_sanitario/nova_acao_calendario_sanitario_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'selecao_animal_calendario_model.dart';
export 'selecao_animal_calendario_model.dart';

class SelecaoAnimalCalendarioWidget extends StatefulWidget {
  const SelecaoAnimalCalendarioWidget({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;

  @override
  State<SelecaoAnimalCalendarioWidget> createState() =>
      _SelecaoAnimalCalendarioWidgetState();
}

class _SelecaoAnimalCalendarioWidgetState
    extends State<SelecaoAnimalCalendarioWidget> with TickerProviderStateMixin {
  late SelecaoAnimalCalendarioModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelecaoAnimalCalendarioModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 6,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 300.ms),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 300.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
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
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).accent4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 2.0, 16.0, 16.0),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxWidth: 670.0,
              ),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12.0,
                    color: Color(0x1E000000),
                    offset: Offset(
                      0.0,
                      5.0,
                    ),
                  )
                ],
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(24.0, 5.0, 5.0, 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              color: FlutterFlowTheme.of(context).error,
                              size: 35.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                      child: Text(
                        'Selecione um ou mais animais',
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
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                      child: Form(
                        key: _model.formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Container(
                          height: 350.0,
                          decoration: BoxDecoration(),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment(-1.0, 0),
                                child: FlutterFlowButtonTabBar(
                                  useToggleButtonStyle: false,
                                  isScrollable: true,
                                  labelStyle: FlutterFlowTheme.of(context)
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
                                      FlutterFlowTheme.of(context)
                                          .secondaryText,
                                  backgroundColor: Color(0xFFF75E38),
                                  borderColor: Color(0xFFEC3B5B),
                                  borderWidth: 2.0,
                                  borderRadius: 12.0,
                                  elevation: 0.0,
                                  labelPadding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  buttonMargin: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 12.0, 16.0, 0.0),
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  tabs: [
                                    Tab(
                                      text: 'Todos',
                                    ),
                                    Tab(
                                      text: 'Bezerros',
                                    ),
                                    Tab(
                                      text: 'Novilhas',
                                    ),
                                    Tab(
                                      text: 'Touros',
                                    ),
                                    Tab(
                                      text: 'Vacas',
                                    ),
                                    Tab(
                                      text: 'Bezerras',
                                    ),
                                  ],
                                  controller: _model.tabBarController,
                                  onTap: (i) async {
                                    [
                                      () async {},
                                      () async {},
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
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          StreamBuilder<
                                              List<AnimaisProdutoresRecord>>(
                                            stream:
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
                                                            'grupoAnimal',
                                                            isNotEqualTo:
                                                                'Sêmens',
                                                          )
                                                          .orderBy(
                                                              'grupoAnimal')
                                                          .orderBy('nomeAnimal')
                                                          .orderBy(
                                                              'brincoAnimalOrder'),
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
                                                  containerAnimaisProdutoresRecordList =
                                                  snapshot.data!;

                                              return Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    if (containerAnimaisProdutoresRecordList
                                                            .length >=
                                                        1)
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    16.0,
                                                                    0.0,
                                                                    16.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Theme(
                                                              data: ThemeData(
                                                                checkboxTheme:
                                                                    CheckboxThemeData(
                                                                  visualDensity:
                                                                      VisualDensity
                                                                          .compact,
                                                                  materialTapTargetSize:
                                                                      MaterialTapTargetSize
                                                                          .shrinkWrap,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4.0),
                                                                  ),
                                                                ),
                                                                unselectedWidgetColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                              ),
                                                              child: Checkbox(
                                                                value: _model
                                                                        .checkboxValue1 ??=
                                                                    false,
                                                                onChanged:
                                                                    (newValue) async {
                                                                  safeSetState(() =>
                                                                      _model.checkboxValue1 =
                                                                          newValue!);
                                                                  if (newValue!) {
                                                                    safeSetState(() => _model.checkboxGroupTodosValueController?.value = List.from(functions.formatAnimalData(
                                                                        containerAnimaisProdutoresRecordList
                                                                            .map((e) => e
                                                                                .nomeAnimal)
                                                                            .toList(),
                                                                        containerAnimaisProdutoresRecordList
                                                                            .map((e) =>
                                                                                e.brincoAnimal)
                                                                            .toList())));
                                                                  } else {
                                                                    safeSetState(() => _model
                                                                        .checkboxGroupTodosValueController
                                                                        ?.value = []);
                                                                  }
                                                                },
                                                                side: (FlutterFlowTheme.of(context)
                                                                            .secondaryText !=
                                                                        null)
                                                                    ? BorderSide(
                                                                        width:
                                                                            2,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                      )
                                                                    : null,
                                                                activeColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                checkColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .info,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Selecionar tudo',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  16.0,
                                                                  0.0),
                                                      child:
                                                          FlutterFlowCheckboxGroup(
                                                        options: functions
                                                            .formatAnimalData(
                                                                containerAnimaisProdutoresRecordList
                                                                    .map((e) => e
                                                                        .nomeAnimal)
                                                                    .toList(),
                                                                containerAnimaisProdutoresRecordList
                                                                    .map((e) =>
                                                                        e.brincoAnimal)
                                                                    .toList())
                                                            .toList(),
                                                        onChanged: (val) =>
                                                            safeSetState(() =>
                                                                _model.checkboxGroupTodosValues =
                                                                    val),
                                                        controller: _model
                                                                .checkboxGroupTodosValueController ??=
                                                            FormFieldController<
                                                                List<String>>(
                                                          [],
                                                        ),
                                                        activeColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .tertiary,
                                                        checkColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .info,
                                                        checkboxBorderColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                        checkboxBorderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                        initialized: _model
                                                                .checkboxGroupTodosValues !=
                                                            null,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          StreamBuilder<
                                              List<AnimaisProdutoresRecord>>(
                                            stream:
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
                                                            'grupoAnimal',
                                                            isEqualTo:
                                                                'Bezerros',
                                                          )
                                                          .where(
                                                            'status',
                                                            isNotEqualTo:
                                                                'Descarte',
                                                          )
                                                          .orderBy('status')
                                                          .orderBy('nomeAnimal')
                                                          .orderBy(
                                                              'brincoAnimalOrder'),
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
                                                  containerAnimaisProdutoresRecordList =
                                                  snapshot.data!;

                                              return Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    if (containerAnimaisProdutoresRecordList
                                                            .length >=
                                                        1)
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    16.0,
                                                                    0.0,
                                                                    16.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Theme(
                                                              data: ThemeData(
                                                                checkboxTheme:
                                                                    CheckboxThemeData(
                                                                  visualDensity:
                                                                      VisualDensity
                                                                          .compact,
                                                                  materialTapTargetSize:
                                                                      MaterialTapTargetSize
                                                                          .shrinkWrap,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4.0),
                                                                  ),
                                                                ),
                                                                unselectedWidgetColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                              ),
                                                              child: Checkbox(
                                                                value: _model
                                                                        .checkboxValue2 ??=
                                                                    false,
                                                                onChanged:
                                                                    (newValue) async {
                                                                  safeSetState(() =>
                                                                      _model.checkboxValue2 =
                                                                          newValue!);
                                                                  if (newValue!) {
                                                                    safeSetState(() => _model.checkboxGroupTerneirosValueController?.value = List.from(functions.formatAnimalData(
                                                                        containerAnimaisProdutoresRecordList
                                                                            .map((e) => e
                                                                                .nomeAnimal)
                                                                            .toList(),
                                                                        containerAnimaisProdutoresRecordList
                                                                            .map((e) =>
                                                                                e.brincoAnimal)
                                                                            .toList())));
                                                                  } else {
                                                                    safeSetState(() => _model
                                                                        .checkboxGroupTerneirosValueController
                                                                        ?.value = []);
                                                                  }
                                                                },
                                                                side: (FlutterFlowTheme.of(context)
                                                                            .secondaryText !=
                                                                        null)
                                                                    ? BorderSide(
                                                                        width:
                                                                            2,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                      )
                                                                    : null,
                                                                activeColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                checkColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .info,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Selecionar tudo',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  16.0,
                                                                  0.0),
                                                      child:
                                                          FlutterFlowCheckboxGroup(
                                                        options: functions
                                                            .formatAnimalData(
                                                                containerAnimaisProdutoresRecordList
                                                                    .map((e) => e
                                                                        .nomeAnimal)
                                                                    .toList(),
                                                                containerAnimaisProdutoresRecordList
                                                                    .map((e) =>
                                                                        e.brincoAnimal)
                                                                    .toList())
                                                            .toList(),
                                                        onChanged: (val) =>
                                                            safeSetState(() =>
                                                                _model.checkboxGroupTerneirosValues =
                                                                    val),
                                                        controller: _model
                                                                .checkboxGroupTerneirosValueController ??=
                                                            FormFieldController<
                                                                List<String>>(
                                                          [],
                                                        ),
                                                        activeColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .tertiary,
                                                        checkColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .info,
                                                        checkboxBorderColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                        checkboxBorderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                        initialized: _model
                                                                .checkboxGroupTerneirosValues !=
                                                            null,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          StreamBuilder<
                                              List<AnimaisProdutoresRecord>>(
                                            stream:
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
                                                            'status',
                                                            isNotEqualTo:
                                                                'Descarte',
                                                          )
                                                          .where(
                                                            'grupoAnimal',
                                                            isEqualTo:
                                                                'Novilhas',
                                                          )
                                                          .orderBy('status')
                                                          .orderBy('nomeAnimal')
                                                          .orderBy(
                                                              'brincoAnimalOrder'),
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
                                                  containerAnimaisProdutoresRecordList =
                                                  snapshot.data!;

                                              return Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    if (containerAnimaisProdutoresRecordList
                                                            .length >=
                                                        1)
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    16.0,
                                                                    0.0,
                                                                    16.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Theme(
                                                              data: ThemeData(
                                                                checkboxTheme:
                                                                    CheckboxThemeData(
                                                                  visualDensity:
                                                                      VisualDensity
                                                                          .compact,
                                                                  materialTapTargetSize:
                                                                      MaterialTapTargetSize
                                                                          .shrinkWrap,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4.0),
                                                                  ),
                                                                ),
                                                                unselectedWidgetColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                              ),
                                                              child: Checkbox(
                                                                value: _model
                                                                        .checkboxValue3 ??=
                                                                    false,
                                                                onChanged:
                                                                    (newValue) async {
                                                                  safeSetState(() =>
                                                                      _model.checkboxValue3 =
                                                                          newValue!);
                                                                  if (newValue!) {
                                                                    safeSetState(() => _model.checkboxGroupNovilhasValueController?.value = List.from(functions.formatAnimalData(
                                                                        containerAnimaisProdutoresRecordList
                                                                            .map((e) => e
                                                                                .nomeAnimal)
                                                                            .toList(),
                                                                        containerAnimaisProdutoresRecordList
                                                                            .map((e) =>
                                                                                e.brincoAnimal)
                                                                            .toList())));
                                                                  } else {
                                                                    safeSetState(() => _model
                                                                        .checkboxGroupNovilhasValueController
                                                                        ?.value = []);
                                                                  }
                                                                },
                                                                side: (FlutterFlowTheme.of(context)
                                                                            .secondaryText !=
                                                                        null)
                                                                    ? BorderSide(
                                                                        width:
                                                                            2,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                      )
                                                                    : null,
                                                                activeColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                checkColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .info,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Selecionar tudo',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  16.0,
                                                                  0.0),
                                                      child:
                                                          FlutterFlowCheckboxGroup(
                                                        options: functions
                                                            .formatAnimalData(
                                                                containerAnimaisProdutoresRecordList
                                                                    .map((e) => e
                                                                        .nomeAnimal)
                                                                    .toList(),
                                                                containerAnimaisProdutoresRecordList
                                                                    .map((e) =>
                                                                        e.brincoAnimal)
                                                                    .toList())
                                                            .toList(),
                                                        onChanged: (val) =>
                                                            safeSetState(() =>
                                                                _model.checkboxGroupNovilhasValues =
                                                                    val),
                                                        controller: _model
                                                                .checkboxGroupNovilhasValueController ??=
                                                            FormFieldController<
                                                                List<String>>(
                                                          [],
                                                        ),
                                                        activeColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .tertiary,
                                                        checkColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .info,
                                                        checkboxBorderColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                        checkboxBorderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                        initialized: _model
                                                                .checkboxGroupNovilhasValues !=
                                                            null,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          StreamBuilder<
                                              List<AnimaisProdutoresRecord>>(
                                            stream:
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
                                                            'status',
                                                            isNotEqualTo:
                                                                'Descarte',
                                                          )
                                                          .where(
                                                            'grupoAnimal',
                                                            isEqualTo: 'Touros',
                                                          )
                                                          .orderBy('status')
                                                          .orderBy('nomeAnimal')
                                                          .orderBy(
                                                              'brincoAnimalOrder'),
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
                                                  containerAnimaisProdutoresRecordList =
                                                  snapshot.data!;

                                              return Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    if (containerAnimaisProdutoresRecordList
                                                            .length >=
                                                        1)
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    16.0,
                                                                    0.0,
                                                                    16.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Theme(
                                                              data: ThemeData(
                                                                checkboxTheme:
                                                                    CheckboxThemeData(
                                                                  visualDensity:
                                                                      VisualDensity
                                                                          .compact,
                                                                  materialTapTargetSize:
                                                                      MaterialTapTargetSize
                                                                          .shrinkWrap,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4.0),
                                                                  ),
                                                                ),
                                                                unselectedWidgetColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                              ),
                                                              child: Checkbox(
                                                                value: _model
                                                                        .checkboxValue4 ??=
                                                                    false,
                                                                onChanged:
                                                                    (newValue) async {
                                                                  safeSetState(() =>
                                                                      _model.checkboxValue4 =
                                                                          newValue!);
                                                                  if (newValue!) {
                                                                    safeSetState(() => _model.checkboxGroupTourosValueController?.value = List.from(functions.formatAnimalData(
                                                                        containerAnimaisProdutoresRecordList
                                                                            .map((e) => e
                                                                                .nomeAnimal)
                                                                            .toList(),
                                                                        containerAnimaisProdutoresRecordList
                                                                            .map((e) =>
                                                                                e.brincoAnimal)
                                                                            .toList())));
                                                                  } else {
                                                                    safeSetState(() => _model
                                                                        .checkboxGroupTourosValueController
                                                                        ?.value = []);
                                                                  }
                                                                },
                                                                side: (FlutterFlowTheme.of(context)
                                                                            .secondaryText !=
                                                                        null)
                                                                    ? BorderSide(
                                                                        width:
                                                                            2,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                      )
                                                                    : null,
                                                                activeColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                checkColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .info,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Selecionar tudo',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  16.0,
                                                                  0.0),
                                                      child:
                                                          FlutterFlowCheckboxGroup(
                                                        options: functions
                                                            .formatAnimalData(
                                                                containerAnimaisProdutoresRecordList
                                                                    .map((e) => e
                                                                        .nomeAnimal)
                                                                    .toList(),
                                                                containerAnimaisProdutoresRecordList
                                                                    .map((e) =>
                                                                        e.brincoAnimal)
                                                                    .toList())
                                                            .toList(),
                                                        onChanged: (val) =>
                                                            safeSetState(() =>
                                                                _model.checkboxGroupTourosValues =
                                                                    val),
                                                        controller: _model
                                                                .checkboxGroupTourosValueController ??=
                                                            FormFieldController<
                                                                List<String>>(
                                                          [],
                                                        ),
                                                        activeColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .tertiary,
                                                        checkColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .info,
                                                        checkboxBorderColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                        checkboxBorderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                        initialized: _model
                                                                .checkboxGroupTourosValues !=
                                                            null,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          StreamBuilder<
                                              List<AnimaisProdutoresRecord>>(
                                            stream:
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
                                                            'status',
                                                            isNotEqualTo:
                                                                'Descarte',
                                                          )
                                                          .where(
                                                            'grupoAnimal',
                                                            isEqualTo: 'Vacas',
                                                          )
                                                          .orderBy('status')
                                                          .orderBy('nomeAnimal')
                                                          .orderBy(
                                                              'brincoAnimalOrder'),
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
                                                  containerAnimaisProdutoresRecordList =
                                                  snapshot.data!;

                                              return Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    if (containerAnimaisProdutoresRecordList
                                                            .length >=
                                                        1)
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    16.0,
                                                                    0.0,
                                                                    16.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Theme(
                                                              data: ThemeData(
                                                                checkboxTheme:
                                                                    CheckboxThemeData(
                                                                  visualDensity:
                                                                      VisualDensity
                                                                          .compact,
                                                                  materialTapTargetSize:
                                                                      MaterialTapTargetSize
                                                                          .shrinkWrap,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4.0),
                                                                  ),
                                                                ),
                                                                unselectedWidgetColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                              ),
                                                              child: Checkbox(
                                                                value: _model
                                                                        .checkboxValue5 ??=
                                                                    false,
                                                                onChanged:
                                                                    (newValue) async {
                                                                  safeSetState(() =>
                                                                      _model.checkboxValue5 =
                                                                          newValue!);
                                                                  if (newValue!) {
                                                                    safeSetState(() => _model.checkboxGroupVacasValueController?.value = List.from(functions.formatAnimalData(
                                                                        containerAnimaisProdutoresRecordList
                                                                            .map((e) => e
                                                                                .nomeAnimal)
                                                                            .toList(),
                                                                        containerAnimaisProdutoresRecordList
                                                                            .map((e) =>
                                                                                e.brincoAnimal)
                                                                            .toList())));
                                                                  } else {
                                                                    safeSetState(() => _model
                                                                        .checkboxGroupVacasValueController
                                                                        ?.value = []);
                                                                  }
                                                                },
                                                                side: (FlutterFlowTheme.of(context)
                                                                            .secondaryText !=
                                                                        null)
                                                                    ? BorderSide(
                                                                        width:
                                                                            2,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                      )
                                                                    : null,
                                                                activeColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                checkColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .info,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Selecionar tudo',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  16.0,
                                                                  0.0),
                                                      child:
                                                          FlutterFlowCheckboxGroup(
                                                        options: functions
                                                            .formatAnimalData(
                                                                containerAnimaisProdutoresRecordList
                                                                    .map((e) => e
                                                                        .nomeAnimal)
                                                                    .toList(),
                                                                containerAnimaisProdutoresRecordList
                                                                    .map((e) =>
                                                                        e.brincoAnimal)
                                                                    .toList())
                                                            .toList(),
                                                        onChanged: (val) =>
                                                            safeSetState(() =>
                                                                _model.checkboxGroupVacasValues =
                                                                    val),
                                                        controller: _model
                                                                .checkboxGroupVacasValueController ??=
                                                            FormFieldController<
                                                                List<String>>(
                                                          [],
                                                        ),
                                                        activeColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .tertiary,
                                                        checkColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .info,
                                                        checkboxBorderColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                        checkboxBorderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                        initialized: _model
                                                                .checkboxGroupVacasValues !=
                                                            null,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          StreamBuilder<
                                              List<AnimaisProdutoresRecord>>(
                                            stream:
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
                                                            'status',
                                                            isNotEqualTo:
                                                                'Descarte',
                                                          )
                                                          .where(
                                                            'grupoAnimal',
                                                            isEqualTo:
                                                                'Bezerras',
                                                          )
                                                          .orderBy('status')
                                                          .orderBy('nomeAnimal')
                                                          .orderBy(
                                                              'brincoAnimalOrder'),
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
                                                  containerAnimaisProdutoresRecordList =
                                                  snapshot.data!;

                                              return Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    if (containerAnimaisProdutoresRecordList
                                                            .length >=
                                                        1)
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    16.0,
                                                                    0.0,
                                                                    16.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Theme(
                                                              data: ThemeData(
                                                                checkboxTheme:
                                                                    CheckboxThemeData(
                                                                  visualDensity:
                                                                      VisualDensity
                                                                          .compact,
                                                                  materialTapTargetSize:
                                                                      MaterialTapTargetSize
                                                                          .shrinkWrap,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4.0),
                                                                  ),
                                                                ),
                                                                unselectedWidgetColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                              ),
                                                              child: Checkbox(
                                                                value: _model
                                                                        .checkboxValue6 ??=
                                                                    false,
                                                                onChanged:
                                                                    (newValue) async {
                                                                  safeSetState(() =>
                                                                      _model.checkboxValue6 =
                                                                          newValue!);
                                                                  if (newValue!) {
                                                                    safeSetState(() => _model.checkboxGroupTerneirasValueController?.value = List.from(functions.formatAnimalData(
                                                                        containerAnimaisProdutoresRecordList
                                                                            .map((e) => e
                                                                                .nomeAnimal)
                                                                            .toList(),
                                                                        containerAnimaisProdutoresRecordList
                                                                            .map((e) =>
                                                                                e.brincoAnimal)
                                                                            .toList())));
                                                                  } else {
                                                                    safeSetState(() => _model
                                                                        .checkboxGroupTerneirasValueController
                                                                        ?.value = []);
                                                                  }
                                                                },
                                                                side: (FlutterFlowTheme.of(context)
                                                                            .secondaryText !=
                                                                        null)
                                                                    ? BorderSide(
                                                                        width:
                                                                            2,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                      )
                                                                    : null,
                                                                activeColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                checkColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .info,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Selecionar tudo',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  16.0,
                                                                  0.0),
                                                      child:
                                                          FlutterFlowCheckboxGroup(
                                                        options: functions
                                                            .formatAnimalData(
                                                                containerAnimaisProdutoresRecordList
                                                                    .map((e) => e
                                                                        .nomeAnimal)
                                                                    .toList(),
                                                                containerAnimaisProdutoresRecordList
                                                                    .map((e) =>
                                                                        e.brincoAnimal)
                                                                    .toList())
                                                            .toList(),
                                                        onChanged: (val) =>
                                                            safeSetState(() =>
                                                                _model.checkboxGroupTerneirasValues =
                                                                    val),
                                                        controller: _model
                                                                .checkboxGroupTerneirasValueController ??=
                                                            FormFieldController<
                                                                List<String>>(
                                                          [],
                                                        ),
                                                        activeColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .tertiary,
                                                        checkColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .info,
                                                        checkboxBorderColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                        checkboxBorderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                        initialized: _model
                                                                .checkboxGroupTerneirasValues !=
                                                            null,
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                      ),
                    ),
                    if (((_model.checkboxGroupTodosValues != null &&
                                (_model.checkboxGroupTodosValues)!
                                    .isNotEmpty) &&
                            (_model.checkboxGroupTodosValues!.length >= 1)) ||
                        ((_model.checkboxGroupTerneirosValues != null &&
                                (_model.checkboxGroupTerneirosValues)!
                                    .isNotEmpty) &&
                            (_model.checkboxGroupTerneirosValues!.length >=
                                1)) ||
                        ((_model.checkboxGroupNovilhasValues != null &&
                                (_model.checkboxGroupNovilhasValues)!
                                    .isNotEmpty) &&
                            (_model.checkboxGroupNovilhasValues!.length >=
                                1)) ||
                        ((_model.checkboxGroupTourosValues != null &&
                                (_model.checkboxGroupTourosValues)!
                                    .isNotEmpty) &&
                            (_model.checkboxGroupTourosValues!.length >= 1)) ||
                        ((_model.checkboxGroupVacasValues != null &&
                                (_model.checkboxGroupVacasValues)!
                                    .isNotEmpty) &&
                            (_model.checkboxGroupVacasValues!.length >= 1)) ||
                        ((_model.checkboxGroupTerneirasValues != null &&
                                (_model.checkboxGroupTerneirasValues)!
                                    .isNotEmpty) &&
                            (_model.checkboxGroupTerneirasValues!.length >= 1)))
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            Navigator.pop(context);
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              enableDrag: false,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: MediaQuery.viewInsetsOf(context),
                                  child: NovaAcaoCalendarioSanitarioWidget(
                                    uidPropriedade: widget.uidPropriedade!,
                                    nomePropriedade: widget.nomePropriedade!,
                                    uidTecnico: widget.uidTecnico!,
                                    emailPropriedade: widget.emailPropriedade!,
                                    visitaPresencial: widget.visitaPresencial!,
                                    listaAnimaisSelecionados: () {
                                      if (_model.tabBarCurrentIndex == 0) {
                                        return _model.checkboxGroupTodosValues!;
                                      } else if (_model.tabBarCurrentIndex ==
                                          1) {
                                        return _model
                                            .checkboxGroupTerneirosValues!;
                                      } else if (_model.tabBarCurrentIndex ==
                                          2) {
                                        return _model
                                            .checkboxGroupNovilhasValues!;
                                      } else if (_model.tabBarCurrentIndex ==
                                          3) {
                                        return _model
                                            .checkboxGroupTourosValues!;
                                      } else if (_model.tabBarCurrentIndex ==
                                          4) {
                                        return _model.checkboxGroupVacasValues!;
                                      } else if (_model.tabBarCurrentIndex ==
                                          5) {
                                        return _model
                                            .checkboxGroupTerneirasValues!;
                                      } else {
                                        return _model.checkboxGroupTodosValues!;
                                      }
                                    }(),
                                    qtdAnimaisSelecionados: () {
                                      if (_model.tabBarCurrentIndex == 0) {
                                        return _model
                                            .checkboxGroupTodosValues!.length;
                                      } else if (_model.tabBarCurrentIndex ==
                                          1) {
                                        return _model
                                            .checkboxGroupTerneirosValues!
                                            .length;
                                      } else if (_model.tabBarCurrentIndex ==
                                          2) {
                                        return _model
                                            .checkboxGroupNovilhasValues!
                                            .length;
                                      } else if (_model.tabBarCurrentIndex ==
                                          3) {
                                        return _model
                                            .checkboxGroupTourosValues!.length;
                                      } else if (_model.tabBarCurrentIndex ==
                                          4) {
                                        return _model
                                            .checkboxGroupVacasValues!.length;
                                      } else if (_model.tabBarCurrentIndex ==
                                          5) {
                                        return _model
                                            .checkboxGroupTerneirasValues!
                                            .length;
                                      } else {
                                        return _model
                                            .checkboxGroupTodosValues!.length;
                                      }
                                    }(),
                                    diasDg: '',
                                  ),
                                );
                              },
                            ).then((value) => safeSetState(() {}));
                          },
                          text: 'Lançar nova ação',
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
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
            ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
          ),
        ],
      ),
    );
  }
}
