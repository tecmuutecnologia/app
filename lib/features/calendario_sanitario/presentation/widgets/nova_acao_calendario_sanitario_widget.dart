// ignore_for_file: dead_code, dead_null_aware_expression

import '/data/backend.dart';
import '/core/ui/flutter_flow_animations.dart';
import '/core/ui/flutter_flow_choice_chips.dart';
import '/core/ui/flutter_flow_drop_down.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/app_card.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/form_field_controller.dart';
import 'dart:ui';
import '/core/ui/custom_functions.dart' as functions;
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class NovaAcaoCalendarioSanitarioWidget extends StatefulWidget {
  const NovaAcaoCalendarioSanitarioWidget({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    this.dtSelect,
    required this.listaAnimaisSelecionados,
    required this.qtdAnimaisSelecionados,
    required this.diasDg,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final DateTime? dtSelect;
  final List<String>? listaAnimaisSelecionados;
  final int? qtdAnimaisSelecionados;
  final String? diasDg;

  @override
  State<NovaAcaoCalendarioSanitarioWidget> createState() =>
      _NovaAcaoCalendarioSanitarioWidgetState();
}

class _NovaAcaoCalendarioSanitarioWidgetState
    extends State<NovaAcaoCalendarioSanitarioWidget>
    with TickerProviderStateMixin {
  final animationsMap = <String, AnimationInfo>{};

  // Estado local (antes no FlutterFlowModel).
  int _qtdInicialAnimais = 0;
  int _qtdMaxAnimais = 0;
  int _qtdInicialAnimais1 = 0;
  int _qtdMaxAnimais1 = 0;
  int _qtdInicialAnimais2 = 0;
  int _qtdMaxAnimais2 = 0;

  final _formKey = GlobalKey<FormState>();
  FormFieldController<List<String>>? _choiceChipsValueController;
  set _choiceChipsValue(String? val) =>
      _choiceChipsValueController?.value = val != null ? [val] : [];
  String? _tipoValue;
  FormFieldController<String>? _tipoValueController;
  String? _valoracaoValue;
  FormFieldController<String>? _valoracaoValueController;
  FocusNode? _dtAcaoFocusNode;
  TextEditingController? _dtAcaoTextController;
  late MaskTextInputFormatter _dtAcaoMask;
  final String? Function(BuildContext, String?)?
      _dtAcaoTextControllerValidator = null;
  DateTime? _datePicked;
  FocusNode? _obsFocusNode;
  TextEditingController? _obsTextController;
  final String? Function(BuildContext, String?)? _obsTextControllerValidator =
      null;

  // Outputs de query/criação.
  AnimaisProdutoresRecord? _outPesquisaAnimalSelecionado;
  ResumoDaVisitaRecord? _outUidResumoDaVisita;
  AnimaisProdutoresRecord? _outPesquisaAnimalSelecionado1;
  RecomendacoesRecord? _outUidRecomendacoes;
  ResumoDaVisitaRecord? _outNewUidResumoDaVisita;
  AnimaisProdutoresRecord? _outPesquisaAnimalSelecionado2;
  RecomendacoesRecord? _outUidRecomendacoes2;

  @override
  void initState() {
    super.initState();

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _qtdMaxAnimais = widget.qtdAnimaisSelecionados!;
      _qtdMaxAnimais1 = widget.qtdAnimaisSelecionados!;
      _qtdMaxAnimais2 = widget.qtdAnimaisSelecionados!;
      safeSetState(() {});
    });

    _dtAcaoTextController ??= TextEditingController();
    _dtAcaoFocusNode ??= FocusNode();

    _dtAcaoMask = MaskTextInputFormatter(mask: '##/##/####');
    _obsTextController ??= TextEditingController();
    _obsFocusNode ??= FocusNode();

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

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {
          _dtAcaoTextController?.text = dateTimeFormat(
            "dd/MM/yyyy",
            getCurrentTimestamp,
            locale: FFLocalizations.of(context).languageCode,
          );
        }));
  }

  @override
  void dispose() {
    _dtAcaoFocusNode?.dispose();
    _dtAcaoTextController?.dispose();
    _obsFocusNode?.dispose();
    _obsTextController?.dispose();

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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _p2(context),
            _p3(context),
          ],
        ),
      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
    );
  }

  Widget _p2(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 0.0, 0.0),
      child: Text(
        'Registrar ação (${widget.listaAnimaisSelecionados?.length.toString()})',
        style: FlutterFlowTheme.of(context).headlineMedium.override(
              font: GoogleFonts.outfit(
                fontWeight:
                    FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                fontStyle:
                    FlutterFlowTheme.of(context).headlineMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight:
                  FlutterFlowTheme.of(context).headlineMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
            ),
      ),
    );
  }

  Widget _p3(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _p4(context),
          _p5(context),
        ],
      ),
    );
  }

  Widget _p4(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _p6(context),
        _p7(context),
        _p8(context),
        _p9(context),
        _p10(context),
      ],
    );
  }

  Widget _p5(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 24.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _p11(context),
          _p12(context),
        ],
      ),
    );
  }

  Widget _p6(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
      child: FlutterFlowChoiceChips(
        options: widget.listaAnimaisSelecionados!
            .map((label) => ChipData(label))
            .toList(),
        onChanged: (widget.listaAnimaisSelecionados != null &&
                (widget.listaAnimaisSelecionados)!.isNotEmpty)
            ? null
            : (val) => safeSetState(() => _choiceChipsValue = val?.firstOrNull),
        selectedChipStyle: ChipStyle(
          backgroundColor: AppTokens.secondary,
          textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                color: Colors.white,
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
          iconColor: Colors.white,
          iconSize: 18.0,
          elevation: 4.0,
          borderRadius: BorderRadius.circular(16.0),
        ),
        unselectedChipStyle: ChipStyle(
          backgroundColor: FlutterFlowTheme.of(context).alternate,
          textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
          iconColor: FlutterFlowTheme.of(context).secondaryText,
          iconSize: 18.0,
          elevation: 0.0,
          borderRadius: BorderRadius.circular(16.0),
        ),
        chipSpacing: 12.0,
        rowSpacing: 12.0,
        multiselect: false,
        alignment: WrapAlignment.start,
        controller: _choiceChipsValueController ??=
            FormFieldController<List<String>>(
          [],
        ),
        wrapped: true,
      ),
    );
  }

  Widget _p7(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
      child: FlutterFlowDropDown<String>(
        controller: _tipoValueController ??= FormFieldController<String>(
          _tipoValue ??= '',
        ),
        options: List<String>.from(['Exame', 'Vacina', 'Doença']),
        optionLabels: ['Exame ', 'Vacina', 'Doença'],
        onChanged: (val) => safeSetState(() => _tipoValue = val),
        width: double.infinity,
        height: 58.0,
        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
        hintText: 'Selecione o tipo',
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: FlutterFlowTheme.of(context).secondaryText,
          size: 24.0,
        ),
        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
        elevation: 2.0,
        borderColor: FlutterFlowTheme.of(context).alternate,
        borderWidth: 2.0,
        borderRadius: 12.0,
        margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
        hidesUnderline: true,
        isSearchable: false,
        isMultiSelect: false,
      ),
    );
  }

  Widget _p8(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
      child: StreamBuilder<List<CalendarioSanitarioRecord>>(
        stream: queryCalendarioSanitarioRecord(
          queryBuilder: (calendarioSanitarioRecord) =>
              calendarioSanitarioRecord.orderBy('descricao'),
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
          List<CalendarioSanitarioRecord>
              valoracaoCalendarioSanitarioRecordList = snapshot.data!;

          return FlutterFlowDropDown<String>(
            controller: _valoracaoValueController ??=
                FormFieldController<String>(null),
            options: List<String>.from(() {
              if (_tipoValue == 'Doença') {
                return valoracaoCalendarioSanitarioRecordList
                    .where((e) => e.tipo == 'Doença')
                    .toList()
                    .map((e) => e.descricao)
                    .toList();
              } else if (_tipoValue == 'Exame') {
                return valoracaoCalendarioSanitarioRecordList
                    .where((e) => e.tipo == 'Exame')
                    .toList()
                    .map((e) => e.descricao)
                    .toList();
              } else if (_tipoValue == 'Vacina') {
                return valoracaoCalendarioSanitarioRecordList
                    .where((e) => e.tipo == 'Vacina')
                    .toList()
                    .map((e) => e.descricao)
                    .toList();
              } else {
                return functions.retornaStringEmLista('Selecione um tipo');
              }
            }()),
            optionLabels: () {
              if (_tipoValue == 'Doença') {
                return valoracaoCalendarioSanitarioRecordList
                    .where((e) => e.tipo == 'Doença')
                    .toList()
                    .map((e) => e.descricao)
                    .toList();
              } else if (_tipoValue == 'Exame') {
                return valoracaoCalendarioSanitarioRecordList
                    .where((e) => e.tipo == 'Exame')
                    .toList()
                    .map((e) => e.descricao)
                    .toList();
              } else if (_tipoValue == 'Vacina') {
                return valoracaoCalendarioSanitarioRecordList
                    .where((e) => e.tipo == 'Vacina')
                    .toList()
                    .map((e) => e.descricao)
                    .toList();
              } else {
                return functions.retornaStringEmLista('Selecione um tipo');
              }
            }(),
            onChanged: (val) => safeSetState(() => _valoracaoValue = val),
            width: double.infinity,
            height: 58.0,
            searchHintTextStyle: FlutterFlowTheme.of(context)
                .labelMedium
                .override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
            searchTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
            textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
            hintText: () {
              if (_tipoValue == 'Exame') {
                return 'Selecione qual exame';
              } else if (_tipoValue == 'Vacina') {
                return 'Selecione qual vacina';
              } else if (_tipoValue == 'Doença') {
                return 'Selecione qual doença';
              } else {
                return 'Selecione';
              }
            }(),
            searchHintText: 'Pesquise...',
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 24.0,
            ),
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            elevation: 2.0,
            borderColor: FlutterFlowTheme.of(context).alternate,
            borderWidth: 2.0,
            borderRadius: 12.0,
            margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
            hidesUnderline: true,
            isSearchable: true,
            isMultiSelect: false,
          );
        },
      ),
    );
  }

  Widget _p9(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
              child: TextFormField(
                controller: _dtAcaoTextController,
                focusNode: _dtAcaoFocusNode,
                onChanged: (_) => EasyDebounce.debounce(
                  '_dtAcaoTextController',
                  Duration(milliseconds: 2000),
                  () => safeSetState(() {}),
                ),
                autofocus: false,
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.next,
                readOnly: true,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Data da ação',
                  labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                  hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).labelMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelMedium.fontStyle,
                      ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                  suffixIcon: _dtAcaoTextController!.text.isNotEmpty
                      ? InkWell(
                          onTap: () async {
                            _dtAcaoTextController?.clear();
                            safeSetState(() {});
                          },
                          child: Icon(
                            Icons.clear,
                            size: 22.0,
                          ),
                        )
                      : null,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                maxLength: 10,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        maxLength}) =>
                    null,
                keyboardType: TextInputType.datetime,
                validator: _dtAcaoTextControllerValidator.asValidator(context),
                inputFormatters: [_dtAcaoMask],
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
                    final _datePickedCupertinoTheme =
                        CupertinoTheme.of(context);
                    return ScrollConfiguration(
                      behavior: const MaterialScrollBehavior().copyWith(
                        dragDevices: {
                          PointerDeviceKind.mouse,
                          PointerDeviceKind.touch,
                          PointerDeviceKind.stylus,
                          PointerDeviceKind.unknown
                        },
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        child: CupertinoTheme(
                          data: _datePickedCupertinoTheme.copyWith(
                            textTheme:
                                _datePickedCupertinoTheme.textTheme.copyWith(
                              dateTimePickerTextStyle:
                                  FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .headlineMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
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
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            minimumDate: DateTime(1900),
                            initialDateTime: getCurrentTimestamp,
                            maximumDate:
                                (getCurrentTimestamp ?? DateTime(2050)),
                            backgroundColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            use24hFormat: false,
                            onDateTimeChanged: (newDateTime) =>
                                safeSetState(() {
                              _datePicked = newDateTime;
                            }),
                          ),
                        ),
                      ),
                    );
                  });
              safeSetState(() {
                _dtAcaoTextController?.text = dateTimeFormat(
                  "dd/MM/yyyy",
                  _datePicked,
                  locale: FFLocalizations.of(context).languageCode,
                );
                _dtAcaoMask.updateMask(
                  newValue: TextEditingValue(
                    text: _dtAcaoTextController!.text,
                  ),
                );
              });
            },
            child: Icon(
              Icons.calendar_month,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 24.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _p10(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
        controller: _obsTextController,
        focusNode: _obsFocusNode,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'Observações',
          labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).alternate,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
          contentPadding:
              EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
        ),
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
        maxLength: 100,
        maxLengthEnforcement: MaxLengthEnforcement.none,
        buildCounter: (context,
                {required currentLength, required isFocused, maxLength}) =>
            null,
        cursorColor: FlutterFlowTheme.of(context).primary,
        validator: _obsTextControllerValidator.asValidator(context),
      ),
    );
  }

  Widget _p11(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.05),
      child: FFButtonWidget(
        onPressed: () async {
          Navigator.pop(context);
        },
        text: 'Cancelar',
        options: FFButtonOptions(
          height: 44.0,
          padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          color: FlutterFlowTheme.of(context).secondaryBackground,
          textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
          elevation: 0.0,
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).alternate,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
          hoverColor: FlutterFlowTheme.of(context).alternate,
          hoverBorderSide: BorderSide(
            color: FlutterFlowTheme.of(context).alternate,
            width: 2.0,
          ),
          hoverTextColor: FlutterFlowTheme.of(context).primaryText,
          hoverElevation: 3.0,
        ),
      ),
    );
  }

  Widget _p12(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.05),
      child: FFButtonWidget(
        onPressed: () async {
          var _shouldSetState = false;
          if (_formKey.currentState == null ||
              !_formKey.currentState!.validate()) {
            return;
          }
          if (_tipoValue == null) {
            return;
          }
          if (_valoracaoValue == null) {
            return;
          }
          if (_valoracaoValue != 'Selecione um tipo') {
            while (_qtdMaxAnimais > _qtdInicialAnimais) {
              _outPesquisaAnimalSelecionado =
                  await queryAnimaisProdutoresRecordOnce(
                parent: widget.uidTecnico,
                queryBuilder: (animaisProdutoresRecord) =>
                    animaisProdutoresRecord
                        .where(
                          'uidTecnicoPropriedade',
                          isEqualTo: widget.uidPropriedade,
                        )
                        .where(
                          'nomeBrincoConcat',
                          isEqualTo: widget.listaAnimaisSelecionados
                              ?.elementAtOrNull(_qtdInicialAnimais),
                        ),
                singleRecord: true,
              ).then((s) => s.firstOrNull);
              _shouldSetState = true;

              await AcoesSanitarioRecord.createDoc(widget.uidTecnico!)
                  .set(createAcoesSanitarioRecordData(
                obsVisita: _obsTextController.text,
                tipoAcao: _tipoValue,
                acao: _valoracaoValue,
                dtAcao: _dtAcaoTextController.text,
                uidPropriedade: widget.uidPropriedade,
                uidAnimalAnimaisProdutores:
                    _outPesquisaAnimalSelecionado?.reference,
              ));

              await AcoesRecord.createDoc(widget.uidTecnico!)
                  .set(createAcoesRecordData(
                obsVisita: _obsTextController.text,
                acao: _valoracaoValue,
                uidPropriedade: widget.uidPropriedade,
                uidAnimalAnimaisProdutores:
                    _outPesquisaAnimalSelecionado?.reference,
                dataVisita: _dtAcaoTextController.text,
                dataDaAcao: getCurrentTimestamp,
              ));
              _qtdInicialAnimais = _qtdInicialAnimais + 1;
              safeSetState(() {});
            }
            _outUidResumoDaVisita = await queryResumoDaVisitaRecordOnce(
              queryBuilder: (resumoDaVisitaRecord) => resumoDaVisitaRecord
                  .where(
                    'uidPropriedade',
                    isEqualTo: widget.uidPropriedade,
                  )
                  .where(
                    'uidTecnico',
                    isEqualTo: widget.uidTecnico,
                  )
                  .where(
                    'dtVisitaFormatado',
                    isEqualTo: dateTimeFormat(
                      "dd/MM/yyyy",
                      getCurrentTimestamp,
                      locale: FFLocalizations.of(context).languageCode,
                    ),
                  ),
              singleRecord: true,
            ).then((s) => s.firstOrNull);
            _shouldSetState = true;
            if (_outUidResumoDaVisita != null) {
              if (_tipoValue == 'Doença') {
                while (_qtdMaxAnimais1 > _qtdInicialAnimais1) {
                  _outPesquisaAnimalSelecionado1 =
                      await queryAnimaisProdutoresRecordOnce(
                    parent: widget.uidTecnico,
                    queryBuilder: (animaisProdutoresRecord) =>
                        animaisProdutoresRecord
                            .where(
                              'uidTecnicoPropriedade',
                              isEqualTo: widget.uidPropriedade,
                            )
                            .where(
                              'nomeBrincoConcat',
                              isEqualTo: widget.listaAnimaisSelecionados
                                  ?.elementAtOrNull(_qtdInicialAnimais1),
                            ),
                    singleRecord: true,
                  ).then((s) => s.firstOrNull);
                  _shouldSetState = true;

                  await TratamentosRecord.createDoc(
                          _outUidResumoDaVisita!.reference)
                      .set(createTratamentosRecordData(
                    uidAnimal: _outPesquisaAnimalSelecionado1?.reference,
                    tipoAcao: _valoracaoValue,
                    uidResumoDaVisita: _outUidResumoDaVisita?.reference,
                    observacaoAcao: _obsTextController.text,
                    brincoAnimal: _outPesquisaAnimalSelecionado1
                        ?.brincoAnimalOrder
                        .toString(),
                    nomeAnimal: _outPesquisaAnimalSelecionado1?.nomeAnimal,
                    grupoAnimal: _outPesquisaAnimalSelecionado1?.grupoAnimal,
                  ));
                  _qtdInicialAnimais1 = _qtdInicialAnimais1 + 1;
                  safeSetState(() {});
                }
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Sucesso!',
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                    duration: Duration(milliseconds: 4000),
                    backgroundColor: FlutterFlowTheme.of(context).secondary,
                  ),
                );
                if (_shouldSetState) safeSetState(() {});
                return;
              }

              _outUidRecomendacoes = await queryRecomendacoesRecordOnce(
                parent: _outUidResumoDaVisita?.reference,
                queryBuilder: (recomendacoesRecord) => recomendacoesRecord
                    .where(
                      'uidResumoDaVisita',
                      isEqualTo: _outUidResumoDaVisita?.reference,
                    )
                    .where(
                      'tituloRecomendacao',
                      isEqualTo: _valoracaoValue,
                    ),
                singleRecord: true,
              ).then((s) => s.firstOrNull);
              _shouldSetState = true;
              if (_outUidRecomendacoes?.reference == null) {
                await RecomendacoesRecord.createDoc(
                        _outUidResumoDaVisita!.reference)
                    .set(createRecomendacoesRecordData(
                  tituloRecomendacao: _valoracaoValue,
                  uidResumoDaVisita: _outUidResumoDaVisita?.reference,
                ));
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Sucesso!',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  duration: Duration(milliseconds: 4000),
                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                ),
              );
              if (_shouldSetState) safeSetState(() {});
              return;
            } else {
              var resumoDaVisitaRecordReference =
                  ResumoDaVisitaRecord.collection.doc();
              await resumoDaVisitaRecordReference
                  .set(createResumoDaVisitaRecordData(
                uidPropriedade: widget.uidPropriedade,
                uidTecnico: widget.uidTecnico,
                dtVisita: getCurrentTimestamp,
                dtVisitaFormatado: dateTimeFormat(
                  "dd/MM/yyyy",
                  getCurrentTimestamp,
                  locale: FFLocalizations.of(context).languageCode,
                ),
              ));
              _outNewUidResumoDaVisita =
                  ResumoDaVisitaRecord.getDocumentFromData(
                      createResumoDaVisitaRecordData(
                        uidPropriedade: widget.uidPropriedade,
                        uidTecnico: widget.uidTecnico,
                        dtVisita: getCurrentTimestamp,
                        dtVisitaFormatado: dateTimeFormat(
                          "dd/MM/yyyy",
                          getCurrentTimestamp,
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                      ),
                      resumoDaVisitaRecordReference);
              _shouldSetState = true;

              await _outNewUidResumoDaVisita!.reference
                  .update(createResumoDaVisitaRecordData(
                uidResumoDaVisita: _outNewUidResumoDaVisita?.reference,
              ));
              if (_tipoValue == 'Doença') {
                while (_qtdMaxAnimais2 > _qtdInicialAnimais2) {
                  _outPesquisaAnimalSelecionado2 =
                      await queryAnimaisProdutoresRecordOnce(
                    parent: widget.uidTecnico,
                    queryBuilder: (animaisProdutoresRecord) =>
                        animaisProdutoresRecord
                            .where(
                              'uidTecnicoPropriedade',
                              isEqualTo: widget.uidPropriedade,
                            )
                            .where(
                              'nomeBrincoConcat',
                              isEqualTo: widget.listaAnimaisSelecionados
                                  ?.elementAtOrNull(_qtdInicialAnimais2),
                            ),
                    singleRecord: true,
                  ).then((s) => s.firstOrNull);
                  _shouldSetState = true;

                  await TratamentosRecord.createDoc(
                          _outNewUidResumoDaVisita!.reference)
                      .set(createTratamentosRecordData(
                    uidAnimal: _outPesquisaAnimalSelecionado2?.reference,
                    tipoAcao: _valoracaoValue,
                    uidResumoDaVisita: _outNewUidResumoDaVisita?.reference,
                    observacaoAcao: _obsTextController.text,
                    brincoAnimal: _outPesquisaAnimalSelecionado2
                        ?.brincoAnimalOrder
                        .toString(),
                    nomeAnimal: _outPesquisaAnimalSelecionado2?.nomeAnimal,
                    grupoAnimal: _outPesquisaAnimalSelecionado2?.grupoAnimal,
                  ));
                  _qtdInicialAnimais2 = _qtdInicialAnimais2 + 1;
                  safeSetState(() {});
                }
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Sucesso!',
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                    duration: Duration(milliseconds: 4000),
                    backgroundColor: FlutterFlowTheme.of(context).secondary,
                  ),
                );
                if (_shouldSetState) safeSetState(() {});
                return;
              }

              _outUidRecomendacoes2 = await queryRecomendacoesRecordOnce(
                parent: _outNewUidResumoDaVisita?.reference,
                queryBuilder: (recomendacoesRecord) => recomendacoesRecord
                    .where(
                      'uidResumoDaVisita',
                      isEqualTo: _outNewUidResumoDaVisita?.reference,
                    )
                    .where(
                      'tituloRecomendacao',
                      isEqualTo: _valoracaoValue,
                    ),
                singleRecord: true,
              ).then((s) => s.firstOrNull);
              _shouldSetState = true;
              if (_outUidRecomendacoes2?.reference == null) {
                await RecomendacoesRecord.createDoc(
                        _outNewUidResumoDaVisita!.reference)
                    .set(createRecomendacoesRecordData(
                  tituloRecomendacao: _valoracaoValue,
                  uidResumoDaVisita: _outNewUidResumoDaVisita?.reference,
                ));
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Sucesso!',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  duration: Duration(milliseconds: 4000),
                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                ),
              );
              if (_shouldSetState) safeSetState(() {});
              return;
            }
          } else {
            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text('Selecione um valor.'),
                  content: Text('Preencha todos os campos.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(alertDialogContext),
                      child: Text('Ok'),
                    ),
                  ],
                );
              },
            );
            if (_shouldSetState) safeSetState(() {});
            return;
          }

          if (_shouldSetState) safeSetState(() {});
        },
        text: 'Registrar',
        icon: Icon(
          Icons.check,
          size: 15.0,
        ),
        options: FFButtonOptions(
          height: 44.0,
          padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          color: Color(0xFF048508),
          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).titleSmall.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
              ),
          elevation: 3.0,
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
          hoverColor: FlutterFlowTheme.of(context).accent1,
          hoverBorderSide: BorderSide(
            color: FlutterFlowTheme.of(context).primary,
            width: 1.0,
          ),
          hoverTextColor: FlutterFlowTheme.of(context).primaryText,
          hoverElevation: 0.0,
        ),
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
