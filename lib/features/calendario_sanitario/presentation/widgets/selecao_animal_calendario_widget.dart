// ignore_for_file: unnecessary_null_comparison

import '/data/backend.dart';
import '/core/ui/flutter_flow_animations.dart';
import '/core/ui/flutter_flow_button_tabbar.dart';
import '/core/ui/flutter_flow_checkbox_group.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/form_field_controller.dart';
import 'nova_acao_calendario_sanitario_widget.dart';
import '/core/ui/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final animationsMap = <String, AnimationInfo>{};

  final _formKey = GlobalKey<FormState>();
  TabController? _tabBarController;
  int get _tabBarCurrentIndex =>
      _tabBarController != null ? _tabBarController!.index : 0;

  bool? _checkboxValue1;
  FormFieldController<List<String>>? _checkboxGroupTodosValueController;
  List<String>? get _checkboxGroupTodosValues =>
      _checkboxGroupTodosValueController?.value;
  set _checkboxGroupTodosValues(List<String>? v) =>
      _checkboxGroupTodosValueController?.value = v;
  bool? _checkboxValue2;
  FormFieldController<List<String>>? _checkboxGroupTerneirosValueController;
  List<String>? get _checkboxGroupTerneirosValues =>
      _checkboxGroupTerneirosValueController?.value;
  set _checkboxGroupTerneirosValues(List<String>? v) =>
      _checkboxGroupTerneirosValueController?.value = v;
  bool? _checkboxValue3;
  FormFieldController<List<String>>? _checkboxGroupNovilhasValueController;
  List<String>? get _checkboxGroupNovilhasValues =>
      _checkboxGroupNovilhasValueController?.value;
  set _checkboxGroupNovilhasValues(List<String>? v) =>
      _checkboxGroupNovilhasValueController?.value = v;
  bool? _checkboxValue4;
  FormFieldController<List<String>>? _checkboxGroupTourosValueController;
  List<String>? get _checkboxGroupTourosValues =>
      _checkboxGroupTourosValueController?.value;
  set _checkboxGroupTourosValues(List<String>? v) =>
      _checkboxGroupTourosValueController?.value = v;
  bool? _checkboxValue5;
  FormFieldController<List<String>>? _checkboxGroupVacasValueController;
  List<String>? get _checkboxGroupVacasValues =>
      _checkboxGroupVacasValueController?.value;
  set _checkboxGroupVacasValues(List<String>? v) =>
      _checkboxGroupVacasValueController?.value = v;
  bool? _checkboxValue6;
  FormFieldController<List<String>>? _checkboxGroupTerneirasValueController;
  List<String>? get _checkboxGroupTerneirasValues =>
      _checkboxGroupTerneirasValueController?.value;
  set _checkboxGroupTerneirasValues(List<String>? v) =>
      _checkboxGroupTerneirasValueController?.value = v;

  @override
  void initState() {
    super.initState();

    _tabBarController = TabController(
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
    _tabBarController?.dispose();

    super.dispose();
  }

  Widget _p1(BuildContext context) {
    return Padding(
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
              _p2(context),
              _p3(context),
              _p4(context),
              if (((_checkboxGroupTodosValues != null &&
                          (_checkboxGroupTodosValues)!.isNotEmpty) &&
                      (_checkboxGroupTodosValues!.length >= 1)) ||
                  ((_checkboxGroupTerneirosValues != null &&
                          (_checkboxGroupTerneirosValues)!.isNotEmpty) &&
                      (_checkboxGroupTerneirosValues!.length >= 1)) ||
                  ((_checkboxGroupNovilhasValues != null &&
                          (_checkboxGroupNovilhasValues)!.isNotEmpty) &&
                      (_checkboxGroupNovilhasValues!.length >= 1)) ||
                  ((_checkboxGroupTourosValues != null &&
                          (_checkboxGroupTourosValues)!.isNotEmpty) &&
                      (_checkboxGroupTourosValues!.length >= 1)) ||
                  ((_checkboxGroupVacasValues != null &&
                          (_checkboxGroupVacasValues)!.isNotEmpty) &&
                      (_checkboxGroupVacasValues!.length >= 1)) ||
                  ((_checkboxGroupTerneirasValues != null &&
                          (_checkboxGroupTerneirasValues)!.isNotEmpty) &&
                      (_checkboxGroupTerneirasValues!.length >= 1)))
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
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
                                if (_tabBarCurrentIndex == 0) {
                                  return _checkboxGroupTodosValues!;
                                } else if (_tabBarCurrentIndex == 1) {
                                  return _checkboxGroupTerneirosValues!;
                                } else if (_tabBarCurrentIndex == 2) {
                                  return _checkboxGroupNovilhasValues!;
                                } else if (_tabBarCurrentIndex == 3) {
                                  return _checkboxGroupTourosValues!;
                                } else if (_tabBarCurrentIndex == 4) {
                                  return _checkboxGroupVacasValues!;
                                } else if (_tabBarCurrentIndex == 5) {
                                  return _checkboxGroupTerneirasValues!;
                                } else {
                                  return _checkboxGroupTodosValues!;
                                }
                              }(),
                              qtdAnimaisSelecionados: () {
                                if (_tabBarCurrentIndex == 0) {
                                  return _checkboxGroupTodosValues!.length;
                                } else if (_tabBarCurrentIndex == 1) {
                                  return _checkboxGroupTerneirosValues!.length;
                                } else if (_tabBarCurrentIndex == 2) {
                                  return _checkboxGroupNovilhasValues!.length;
                                } else if (_tabBarCurrentIndex == 3) {
                                  return _checkboxGroupTourosValues!.length;
                                } else if (_tabBarCurrentIndex == 4) {
                                  return _checkboxGroupVacasValues!.length;
                                } else if (_tabBarCurrentIndex == 5) {
                                  return _checkboxGroupTerneirasValues!.length;
                                } else {
                                  return _checkboxGroupTodosValues!.length;
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
                      padding:
                          EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
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
    );
  }

  Widget _p2(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 5.0, 5.0, 12.0),
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
    );
  }

  Widget _p3(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
      child: Text(
        'Selecione um ou mais animais',
        style: FlutterFlowTheme.of(context).headlineMedium.override(
              font: GoogleFonts.outfit(
                fontWeight:
                    FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                fontStyle:
                    FlutterFlowTheme.of(context).headlineMedium.fontStyle,
              ),
              fontSize: 18.0,
              letterSpacing: 0.0,
              fontWeight:
                  FlutterFlowTheme.of(context).headlineMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
            ),
      ),
    );
  }

  Widget _p4(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Container(
          height: 350.0,
          decoration: BoxDecoration(),
          child: Column(
            children: [
              _p5(context),
              _p6(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _p5(BuildContext context) {
    return Align(
      alignment: Alignment(-1.0, 0),
      child: FlutterFlowButtonTabBar(
        useToggleButtonStyle: false,
        isScrollable: true,
        labelStyle: FlutterFlowTheme.of(context).titleMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
            ),
        unselectedLabelStyle: TextStyle(),
        labelColor: Colors.white,
        unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
        backgroundColor: Color(0xFFF75E38),
        borderColor: Color(0xFFEC3B5B),
        borderWidth: 2.0,
        borderRadius: 12.0,
        elevation: 0.0,
        labelPadding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
        buttonMargin: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 16.0, 0.0),
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
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
        controller: _tabBarController,
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
    );
  }

  Widget _p6(BuildContext context) {
    return Expanded(
      child: TabBarView(
        controller: _tabBarController,
        children: [
          _p7(context),
          _p8(context),
          _p9(context),
          _p10(context),
          _p11(context),
          _p12(context),
        ],
      ),
    );
  }

  Widget _p7(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          StreamBuilder<List<AnimaisProdutoresRecord>>(
            stream: queryAnimaisProdutoresRecord(
              parent: widget.uidTecnico,
              queryBuilder: (animaisProdutoresRecord) => animaisProdutoresRecord
                  .where(
                    'uidTecnicoPropriedade',
                    isEqualTo: widget.uidPropriedade,
                  )
                  .where(
                    'grupoAnimal',
                    isNotEqualTo: 'Sêmens',
                  )
                  .orderBy('grupoAnimal')
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
                  containerAnimaisProdutoresRecordList = snapshot.data!;

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (containerAnimaisProdutoresRecordList.length >= 1)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Theme(
                              data: ThemeData(
                                checkboxTheme: CheckboxThemeData(
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                                unselectedWidgetColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                              child: Checkbox(
                                value: _checkboxValue1 ??= false,
                                onChanged: (newValue) async {
                                  safeSetState(
                                      () => _checkboxValue1 = newValue!);
                                  if (newValue!) {
                                    safeSetState(() => _checkboxGroupTodosValueController
                                            ?.value =
                                        List.from(functions.formatAnimalData(
                                            containerAnimaisProdutoresRecordList
                                                .map((e) => e.nomeAnimal)
                                                .toList(),
                                            containerAnimaisProdutoresRecordList
                                                .map((e) => e.brincoAnimal)
                                                .toList())));
                                  } else {
                                    safeSetState(() =>
                                        _checkboxGroupTodosValueController
                                            ?.value = []);
                                  }
                                },
                                side: (FlutterFlowTheme.of(context)
                                            .secondaryText !=
                                        null)
                                    ? BorderSide(
                                        width: 2,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                      )
                                    : null,
                                activeColor:
                                    FlutterFlowTheme.of(context).primary,
                                checkColor: FlutterFlowTheme.of(context).info,
                              ),
                            ),
                            Text(
                              'Selecionar tudo',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: FlutterFlowCheckboxGroup(
                        options: functions
                            .formatAnimalData(
                                containerAnimaisProdutoresRecordList
                                    .map((e) => e.nomeAnimal)
                                    .toList(),
                                containerAnimaisProdutoresRecordList
                                    .map((e) => e.brincoAnimal)
                                    .toList())
                            .toList(),
                        onChanged: (val) =>
                            safeSetState(() => _checkboxGroupTodosValues = val),
                        controller: _checkboxGroupTodosValueController ??=
                            FormFieldController<List<String>>(
                          [],
                        ),
                        activeColor: FlutterFlowTheme.of(context).tertiary,
                        checkColor: FlutterFlowTheme.of(context).info,
                        checkboxBorderColor:
                            FlutterFlowTheme.of(context).secondaryText,
                        textStyle:
                            FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
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
                        checkboxBorderRadius: BorderRadius.circular(4.0),
                        initialized: _checkboxGroupTodosValues != null,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _p8(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          StreamBuilder<List<AnimaisProdutoresRecord>>(
            stream: queryAnimaisProdutoresRecord(
              parent: widget.uidTecnico,
              queryBuilder: (animaisProdutoresRecord) => animaisProdutoresRecord
                  .where(
                    'uidTecnicoPropriedade',
                    isEqualTo: widget.uidPropriedade,
                  )
                  .where(
                    'grupoAnimal',
                    isEqualTo: 'Bezerros',
                  )
                  .where(
                    'status',
                    isNotEqualTo: 'Descarte',
                  )
                  .orderBy('status')
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
                  containerAnimaisProdutoresRecordList = snapshot.data!;

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (containerAnimaisProdutoresRecordList.length >= 1)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Theme(
                              data: ThemeData(
                                checkboxTheme: CheckboxThemeData(
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                                unselectedWidgetColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                              child: Checkbox(
                                value: _checkboxValue2 ??= false,
                                onChanged: (newValue) async {
                                  safeSetState(
                                      () => _checkboxValue2 = newValue!);
                                  if (newValue!) {
                                    safeSetState(() =>
                                        _checkboxGroupTerneirosValueController
                                                ?.value =
                                            List.from(functions.formatAnimalData(
                                                containerAnimaisProdutoresRecordList
                                                    .map((e) => e.nomeAnimal)
                                                    .toList(),
                                                containerAnimaisProdutoresRecordList
                                                    .map((e) => e.brincoAnimal)
                                                    .toList())));
                                  } else {
                                    safeSetState(() =>
                                        _checkboxGroupTerneirosValueController
                                            ?.value = []);
                                  }
                                },
                                side: (FlutterFlowTheme.of(context)
                                            .secondaryText !=
                                        null)
                                    ? BorderSide(
                                        width: 2,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                      )
                                    : null,
                                activeColor:
                                    FlutterFlowTheme.of(context).primary,
                                checkColor: FlutterFlowTheme.of(context).info,
                              ),
                            ),
                            Text(
                              'Selecionar tudo',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: FlutterFlowCheckboxGroup(
                        options: functions
                            .formatAnimalData(
                                containerAnimaisProdutoresRecordList
                                    .map((e) => e.nomeAnimal)
                                    .toList(),
                                containerAnimaisProdutoresRecordList
                                    .map((e) => e.brincoAnimal)
                                    .toList())
                            .toList(),
                        onChanged: (val) => safeSetState(
                            () => _checkboxGroupTerneirosValues = val),
                        controller: _checkboxGroupTerneirosValueController ??=
                            FormFieldController<List<String>>(
                          [],
                        ),
                        activeColor: FlutterFlowTheme.of(context).tertiary,
                        checkColor: FlutterFlowTheme.of(context).info,
                        checkboxBorderColor:
                            FlutterFlowTheme.of(context).secondaryText,
                        textStyle:
                            FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
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
                        checkboxBorderRadius: BorderRadius.circular(4.0),
                        initialized: _checkboxGroupTerneirosValues != null,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _p9(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          StreamBuilder<List<AnimaisProdutoresRecord>>(
            stream: queryAnimaisProdutoresRecord(
              parent: widget.uidTecnico,
              queryBuilder: (animaisProdutoresRecord) => animaisProdutoresRecord
                  .where(
                    'uidTecnicoPropriedade',
                    isEqualTo: widget.uidPropriedade,
                  )
                  .where(
                    'status',
                    isNotEqualTo: 'Descarte',
                  )
                  .where(
                    'grupoAnimal',
                    isEqualTo: 'Novilhas',
                  )
                  .orderBy('status')
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
                  containerAnimaisProdutoresRecordList = snapshot.data!;

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (containerAnimaisProdutoresRecordList.length >= 1)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Theme(
                              data: ThemeData(
                                checkboxTheme: CheckboxThemeData(
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                                unselectedWidgetColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                              child: Checkbox(
                                value: _checkboxValue3 ??= false,
                                onChanged: (newValue) async {
                                  safeSetState(
                                      () => _checkboxValue3 = newValue!);
                                  if (newValue!) {
                                    safeSetState(() =>
                                        _checkboxGroupNovilhasValueController
                                                ?.value =
                                            List.from(functions.formatAnimalData(
                                                containerAnimaisProdutoresRecordList
                                                    .map((e) => e.nomeAnimal)
                                                    .toList(),
                                                containerAnimaisProdutoresRecordList
                                                    .map((e) => e.brincoAnimal)
                                                    .toList())));
                                  } else {
                                    safeSetState(() =>
                                        _checkboxGroupNovilhasValueController
                                            ?.value = []);
                                  }
                                },
                                side: (FlutterFlowTheme.of(context)
                                            .secondaryText !=
                                        null)
                                    ? BorderSide(
                                        width: 2,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                      )
                                    : null,
                                activeColor:
                                    FlutterFlowTheme.of(context).primary,
                                checkColor: FlutterFlowTheme.of(context).info,
                              ),
                            ),
                            Text(
                              'Selecionar tudo',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: FlutterFlowCheckboxGroup(
                        options: functions
                            .formatAnimalData(
                                containerAnimaisProdutoresRecordList
                                    .map((e) => e.nomeAnimal)
                                    .toList(),
                                containerAnimaisProdutoresRecordList
                                    .map((e) => e.brincoAnimal)
                                    .toList())
                            .toList(),
                        onChanged: (val) => safeSetState(
                            () => _checkboxGroupNovilhasValues = val),
                        controller: _checkboxGroupNovilhasValueController ??=
                            FormFieldController<List<String>>(
                          [],
                        ),
                        activeColor: FlutterFlowTheme.of(context).tertiary,
                        checkColor: FlutterFlowTheme.of(context).info,
                        checkboxBorderColor:
                            FlutterFlowTheme.of(context).secondaryText,
                        textStyle:
                            FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
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
                        checkboxBorderRadius: BorderRadius.circular(4.0),
                        initialized: _checkboxGroupNovilhasValues != null,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _p10(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          StreamBuilder<List<AnimaisProdutoresRecord>>(
            stream: queryAnimaisProdutoresRecord(
              parent: widget.uidTecnico,
              queryBuilder: (animaisProdutoresRecord) => animaisProdutoresRecord
                  .where(
                    'uidTecnicoPropriedade',
                    isEqualTo: widget.uidPropriedade,
                  )
                  .where(
                    'status',
                    isNotEqualTo: 'Descarte',
                  )
                  .where(
                    'grupoAnimal',
                    isEqualTo: 'Touros',
                  )
                  .orderBy('status')
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
                  containerAnimaisProdutoresRecordList = snapshot.data!;

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (containerAnimaisProdutoresRecordList.length >= 1)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Theme(
                              data: ThemeData(
                                checkboxTheme: CheckboxThemeData(
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                                unselectedWidgetColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                              child: Checkbox(
                                value: _checkboxValue4 ??= false,
                                onChanged: (newValue) async {
                                  safeSetState(
                                      () => _checkboxValue4 = newValue!);
                                  if (newValue!) {
                                    safeSetState(() =>
                                        _checkboxGroupTourosValueController
                                                ?.value =
                                            List.from(functions.formatAnimalData(
                                                containerAnimaisProdutoresRecordList
                                                    .map((e) => e.nomeAnimal)
                                                    .toList(),
                                                containerAnimaisProdutoresRecordList
                                                    .map((e) => e.brincoAnimal)
                                                    .toList())));
                                  } else {
                                    safeSetState(() =>
                                        _checkboxGroupTourosValueController
                                            ?.value = []);
                                  }
                                },
                                side: (FlutterFlowTheme.of(context)
                                            .secondaryText !=
                                        null)
                                    ? BorderSide(
                                        width: 2,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                      )
                                    : null,
                                activeColor:
                                    FlutterFlowTheme.of(context).primary,
                                checkColor: FlutterFlowTheme.of(context).info,
                              ),
                            ),
                            Text(
                              'Selecionar tudo',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: FlutterFlowCheckboxGroup(
                        options: functions
                            .formatAnimalData(
                                containerAnimaisProdutoresRecordList
                                    .map((e) => e.nomeAnimal)
                                    .toList(),
                                containerAnimaisProdutoresRecordList
                                    .map((e) => e.brincoAnimal)
                                    .toList())
                            .toList(),
                        onChanged: (val) => safeSetState(
                            () => _checkboxGroupTourosValues = val),
                        controller: _checkboxGroupTourosValueController ??=
                            FormFieldController<List<String>>(
                          [],
                        ),
                        activeColor: FlutterFlowTheme.of(context).tertiary,
                        checkColor: FlutterFlowTheme.of(context).info,
                        checkboxBorderColor:
                            FlutterFlowTheme.of(context).secondaryText,
                        textStyle:
                            FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
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
                        checkboxBorderRadius: BorderRadius.circular(4.0),
                        initialized: _checkboxGroupTourosValues != null,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _p11(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          StreamBuilder<List<AnimaisProdutoresRecord>>(
            stream: queryAnimaisProdutoresRecord(
              parent: widget.uidTecnico,
              queryBuilder: (animaisProdutoresRecord) => animaisProdutoresRecord
                  .where(
                    'uidTecnicoPropriedade',
                    isEqualTo: widget.uidPropriedade,
                  )
                  .where(
                    'status',
                    isNotEqualTo: 'Descarte',
                  )
                  .where(
                    'grupoAnimal',
                    isEqualTo: 'Vacas',
                  )
                  .orderBy('status')
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
                  containerAnimaisProdutoresRecordList = snapshot.data!;

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (containerAnimaisProdutoresRecordList.length >= 1)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Theme(
                              data: ThemeData(
                                checkboxTheme: CheckboxThemeData(
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                                unselectedWidgetColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                              child: Checkbox(
                                value: _checkboxValue5 ??= false,
                                onChanged: (newValue) async {
                                  safeSetState(
                                      () => _checkboxValue5 = newValue!);
                                  if (newValue!) {
                                    safeSetState(() => _checkboxGroupVacasValueController
                                            ?.value =
                                        List.from(functions.formatAnimalData(
                                            containerAnimaisProdutoresRecordList
                                                .map((e) => e.nomeAnimal)
                                                .toList(),
                                            containerAnimaisProdutoresRecordList
                                                .map((e) => e.brincoAnimal)
                                                .toList())));
                                  } else {
                                    safeSetState(() =>
                                        _checkboxGroupVacasValueController
                                            ?.value = []);
                                  }
                                },
                                side: (FlutterFlowTheme.of(context)
                                            .secondaryText !=
                                        null)
                                    ? BorderSide(
                                        width: 2,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                      )
                                    : null,
                                activeColor:
                                    FlutterFlowTheme.of(context).primary,
                                checkColor: FlutterFlowTheme.of(context).info,
                              ),
                            ),
                            Text(
                              'Selecionar tudo',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: FlutterFlowCheckboxGroup(
                        options: functions
                            .formatAnimalData(
                                containerAnimaisProdutoresRecordList
                                    .map((e) => e.nomeAnimal)
                                    .toList(),
                                containerAnimaisProdutoresRecordList
                                    .map((e) => e.brincoAnimal)
                                    .toList())
                            .toList(),
                        onChanged: (val) =>
                            safeSetState(() => _checkboxGroupVacasValues = val),
                        controller: _checkboxGroupVacasValueController ??=
                            FormFieldController<List<String>>(
                          [],
                        ),
                        activeColor: FlutterFlowTheme.of(context).tertiary,
                        checkColor: FlutterFlowTheme.of(context).info,
                        checkboxBorderColor:
                            FlutterFlowTheme.of(context).secondaryText,
                        textStyle:
                            FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
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
                        checkboxBorderRadius: BorderRadius.circular(4.0),
                        initialized: _checkboxGroupVacasValues != null,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _p12(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          StreamBuilder<List<AnimaisProdutoresRecord>>(
            stream: queryAnimaisProdutoresRecord(
              parent: widget.uidTecnico,
              queryBuilder: (animaisProdutoresRecord) => animaisProdutoresRecord
                  .where(
                    'uidTecnicoPropriedade',
                    isEqualTo: widget.uidPropriedade,
                  )
                  .where(
                    'status',
                    isNotEqualTo: 'Descarte',
                  )
                  .where(
                    'grupoAnimal',
                    isEqualTo: 'Bezerras',
                  )
                  .orderBy('status')
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
                  containerAnimaisProdutoresRecordList = snapshot.data!;

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (containerAnimaisProdutoresRecordList.length >= 1)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Theme(
                              data: ThemeData(
                                checkboxTheme: CheckboxThemeData(
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                                unselectedWidgetColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                              child: Checkbox(
                                value: _checkboxValue6 ??= false,
                                onChanged: (newValue) async {
                                  safeSetState(
                                      () => _checkboxValue6 = newValue!);
                                  if (newValue!) {
                                    safeSetState(() =>
                                        _checkboxGroupTerneirasValueController
                                                ?.value =
                                            List.from(functions.formatAnimalData(
                                                containerAnimaisProdutoresRecordList
                                                    .map((e) => e.nomeAnimal)
                                                    .toList(),
                                                containerAnimaisProdutoresRecordList
                                                    .map((e) => e.brincoAnimal)
                                                    .toList())));
                                  } else {
                                    safeSetState(() =>
                                        _checkboxGroupTerneirasValueController
                                            ?.value = []);
                                  }
                                },
                                side: (FlutterFlowTheme.of(context)
                                            .secondaryText !=
                                        null)
                                    ? BorderSide(
                                        width: 2,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                      )
                                    : null,
                                activeColor:
                                    FlutterFlowTheme.of(context).primary,
                                checkColor: FlutterFlowTheme.of(context).info,
                              ),
                            ),
                            Text(
                              'Selecionar tudo',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: FlutterFlowCheckboxGroup(
                        options: functions
                            .formatAnimalData(
                                containerAnimaisProdutoresRecordList
                                    .map((e) => e.nomeAnimal)
                                    .toList(),
                                containerAnimaisProdutoresRecordList
                                    .map((e) => e.brincoAnimal)
                                    .toList())
                            .toList(),
                        onChanged: (val) => safeSetState(
                            () => _checkboxGroupTerneirasValues = val),
                        controller: _checkboxGroupTerneirasValueController ??=
                            FormFieldController<List<String>>(
                          [],
                        ),
                        activeColor: FlutterFlowTheme.of(context).tertiary,
                        checkColor: FlutterFlowTheme.of(context).info,
                        checkboxBorderColor:
                            FlutterFlowTheme.of(context).secondaryText,
                        textStyle:
                            FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
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
                        checkboxBorderRadius: BorderRadius.circular(4.0),
                        initialized: _checkboxGroupTerneirasValues != null,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
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
          _p1(context),
        ],
      ),
    );
  }
}
