import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'nova_inseminacao_backup_model.dart';
export 'nova_inseminacao_backup_model.dart';

class NovaInseminacaoBackupWidget extends StatefulWidget {
  const NovaInseminacaoBackupWidget({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.uidAnimaisProdutores,
    required this.grupoPredominante,
    required this.nomeAnimal,
    required this.visitaPresencial,
    required this.dtUltimaInseminacao,
    required this.brincoAnimal,
    required this.diasDg,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final DocumentReference? uidAnimaisProdutores;
  final String? grupoPredominante;
  final String? nomeAnimal;
  final bool? visitaPresencial;
  final String? dtUltimaInseminacao;
  final String? brincoAnimal;
  final String? diasDg;

  @override
  State<NovaInseminacaoBackupWidget> createState() =>
      _NovaInseminacaoBackupWidgetState();
}

class _NovaInseminacaoBackupWidgetState
    extends State<NovaInseminacaoBackupWidget> with TickerProviderStateMixin {
  late NovaInseminacaoBackupModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NovaInseminacaoBackupModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.outUidAnimaisAnimal =
          await AnimaisProdutoresRecord.getDocumentOnce(
              widget.uidAnimaisProdutores!);
    });

    _model.dtInseminacaoTextController ??= TextEditingController();
    _model.dtInseminacaoFocusNode ??= FocusNode();

    _model.dtInseminacaoMask = MaskTextInputFormatter(mask: '##/##/####');
    _model.obsTextController ??= TextEditingController();
    _model.obsFocusNode ??= FocusNode();

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
          _model.dtInseminacaoTextController?.text = dateTimeFormat(
            "dd/MM/yyyy",
            getCurrentTimestamp,
            locale: FFLocalizations.of(context).languageCode,
          );
        }));
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
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 0.0, 0.0),
                    child: Text(
                      'Inseminar - ${() {
                        if ((widget.nomeAnimal != null &&
                                widget.nomeAnimal != '') &&
                            (widget.brincoAnimal != null &&
                                widget.brincoAnimal != '') &&
                            (widget.brincoAnimal != '-1')) {
                          return '${widget.nomeAnimal} - ${widget.brincoAnimal}';
                        } else if (widget.nomeAnimal != null &&
                            widget.nomeAnimal != '') {
                          return widget.nomeAnimal;
                        } else {
                          return widget.brincoAnimal;
                        }
                      }()}',
                      style:
                          FlutterFlowTheme.of(context).headlineMedium.override(
                                font: GoogleFonts.outfit(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .fontStyle,
                                ),
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
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 16.0, 16.0, 0.0),
                        child: StreamBuilder<List<AnimaisProdutoresRecord>>(
                          stream: queryAnimaisProdutoresRecord(
                            parent: widget.uidTecnico,
                            queryBuilder: (animaisProdutoresRecord) =>
                                animaisProdutoresRecord
                                    .where(
                                      'uidTecnicoPropriedade',
                                      isEqualTo: widget.uidPropriedade,
                                    )
                                    .where(
                                      'liberaInseminacao',
                                      isEqualTo: true,
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFFF75E38),
                                    ),
                                  ),
                                ),
                              );
                            }
                            List<AnimaisProdutoresRecord>
                                touroAnimaisProdutoresRecordList =
                                snapshot.data!;

                            return FlutterFlowDropDown<String>(
                              controller: _model.touroValueController ??=
                                  FormFieldController<String>(null),
                              options: touroAnimaisProdutoresRecordList
                                  .map((e) => valueOrDefault<String>(
                                        e.nomeAnimal,
                                        'Indefinido',
                                      ))
                                  .toList(),
                              onChanged: (val) =>
                                  safeSetState(() => _model.touroValue = val),
                              width: double.infinity,
                              height: 58.0,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
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
                              hintText: 'Selecione um Touro/Sêmen',
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              elevation: 2.0,
                              borderColor:
                                  FlutterFlowTheme.of(context).alternate,
                              borderWidth: 2.0,
                              borderRadius: 12.0,
                              margin: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 4.0, 16.0, 4.0),
                              hidesUnderline: true,
                              isSearchable: false,
                              isMultiSelect: false,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 16.0, 16.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 8.0, 0.0),
                                child: TextFormField(
                                  controller:
                                      _model.dtInseminacaoTextController,
                                  focusNode: _model.dtInseminacaoFocusNode,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.dtInseminacaoTextController',
                                    Duration(milliseconds: 2000),
                                    () => safeSetState(() {}),
                                  ),
                                  autofocus: false,
                                  textCapitalization: TextCapitalization.none,
                                  textInputAction: TextInputAction.next,
                                  readOnly: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Data da inseminação',
                                    labelStyle: FlutterFlowTheme.of(context)
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
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            16.0, 12.0, 16.0, 12.0),
                                    suffixIcon: _model
                                            .dtInseminacaoTextController!
                                            .text
                                            .isNotEmpty
                                        ? InkWell(
                                            onTap: () async {
                                              _model.dtInseminacaoTextController
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
                                      .dtInseminacaoTextControllerValidator
                                      .asValidator(context),
                                  inputFormatters: [_model.dtInseminacaoMask],
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
                                        behavior: const MaterialScrollBehavior()
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          child: CupertinoTheme(
                                            data: _datePickedCupertinoTheme
                                                .copyWith(
                                              textTheme:
                                                  _datePickedCupertinoTheme
                                                      .textTheme
                                                      .copyWith(
                                                dateTimePickerTextStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .outfit(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineMedium
                                                                  .fontStyle,
                                                        ),
                                              ),
                                            ),
                                            child: CupertinoDatePicker(
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                              minimumDate: DateTime(1900),
                                              initialDateTime:
                                                  getCurrentTimestamp,
                                              maximumDate:
                                                  (getCurrentTimestamp ??
                                                      DateTime(2050)),
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              use24hFormat: false,
                                              onDateTimeChanged:
                                                  (newDateTime) =>
                                                      safeSetState(() {
                                                _model.datePicked = newDateTime;
                                              }),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                safeSetState(() {
                                  _model.dtInseminacaoTextController?.text =
                                      dateTimeFormat(
                                    "dd/MM/yyyy",
                                    _model.datePicked,
                                    locale: FFLocalizations.of(context)
                                        .languageCode,
                                  );
                                  _model.dtInseminacaoMask.updateMask(
                                    newValue: TextEditingValue(
                                      text: _model
                                          .dtInseminacaoTextController!.text,
                                    ),
                                  );
                                });
                              },
                              child: Icon(
                                Icons.calendar_month,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 16.0, 16.0, 0.0),
                        child: TextFormField(
                          controller: _model.obsTextController,
                          focusNode: _model.obsFocusNode,
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Observações',
                            labelStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                            hintStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
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
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            contentPadding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 24.0, 20.0, 24.0),
                          ),
                          style:
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
                          maxLength: 100,
                          maxLengthEnforcement: MaxLengthEnforcement.none,
                          buildCounter: (context,
                                  {required currentLength,
                                  required isFocused,
                                  maxLength}) =>
                              null,
                          cursorColor: FlutterFlowTheme.of(context).primary,
                          validator: _model.obsTextControllerValidator
                              .asValidator(context),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 24.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.05),
                          child: FFButtonWidget(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            text: 'Cancelar',
                            options: FFButtonOptions(
                              height: 44.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
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
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                              hoverColor:
                                  FlutterFlowTheme.of(context).alternate,
                              hoverBorderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                              hoverTextColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              hoverElevation: 3.0,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.05),
                          child: FFButtonWidget(
                            onPressed: () async {
                              var _shouldSetState = false;
                              if (_model.touroValue != null &&
                                  _model.touroValue != '') {
                                if (_model.dtInseminacaoTextController.text !=
                                        '') {
                                  if (widget.dtUltimaInseminacao != null &&
                                      widget.dtUltimaInseminacao != '') {
                                    if (functions
                                            .verificarDataUltimoPartoMenorMaiorAtual(
                                                widget.dtUltimaInseminacao!,
                                                _model
                                                    .dtInseminacaoTextController
                                                    .text) ==
                                        false) {
                                      var confirmDialogResponse =
                                          await showDialog<bool>(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'A data informada é mais antiga que a atual.'),
                                                    content: Text(
                                                        'Deseja realmente salvar uma data mais antiga?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                alertDialogContext,
                                                                false),
                                                        child: Text('Cancelar'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                alertDialogContext,
                                                                true),
                                                        child: Text(
                                                            'Confirma e substituir'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ) ??
                                              false;
                                      if (confirmDialogResponse) {
                                        var acoesRecordReference1 =
                                            AcoesRecord.createDoc(
                                                widget.uidTecnico!);
                                        await acoesRecordReference1
                                            .set(createAcoesRecordData(
                                          uidAnimalAnimaisProdutores:
                                              widget.uidAnimaisProdutores,
                                          nomeAnimal: widget.nomeAnimal,
                                          acao: 'Inseminada',
                                          dataVisita: _model
                                              .dtInseminacaoTextController.text,
                                          obsVisita:
                                              _model.obsTextController.text,
                                          touroInseminacao: _model.touroValue,
                                          dataPartoPrevisto:
                                              functions.somarDataParto(_model
                                                  .dtInseminacaoTextController
                                                  .text),
                                          dataSecPrevista:
                                              functions.somarDataSecagem(_model
                                                  .dtInseminacaoTextController
                                                  .text),
                                          dataPrePartoPrevista:
                                              functions.somarDataPreParto(_model
                                                  .dtInseminacaoTextController
                                                  .text),
                                          dataDaAcao: getCurrentTimestamp,
                                          uidPropriedade:
                                              widget.uidPropriedade,
                                        ));
                                        _model.outUidAcaoRealizada =
                                            AcoesRecord.getDocumentFromData(
                                                createAcoesRecordData(
                                                  uidAnimalAnimaisProdutores:
                                                      widget
                                                          .uidAnimaisProdutores,
                                                  nomeAnimal:
                                                      widget.nomeAnimal,
                                                  acao: 'Inseminada',
                                                  dataVisita: _model
                                                      .dtInseminacaoTextController
                                                      .text,
                                                  obsVisita: _model
                                                      .obsTextController.text,
                                                  touroInseminacao:
                                                      _model.touroValue,
                                                  dataPartoPrevisto: functions
                                                      .somarDataParto(_model
                                                          .dtInseminacaoTextController
                                                          .text),
                                                  dataSecPrevista: functions
                                                      .somarDataSecagem(_model
                                                          .dtInseminacaoTextController
                                                          .text),
                                                  dataPrePartoPrevista: functions
                                                      .somarDataPreParto(_model
                                                          .dtInseminacaoTextController
                                                          .text),
                                                  dataDaAcao:
                                                      getCurrentTimestamp,
                                                  uidPropriedade:
                                                      widget.uidPropriedade,
                                                ),
                                                acoesRecordReference1);
                                        _shouldSetState = true;

                                        await _model
                                            .outUidAnimaisAnimal!.reference
                                            .update({
                                          ...createAnimaisProdutoresRecordData(
                                            dtUltimaInseminacao: _model
                                                .dtInseminacaoTextController
                                                .text,
                                            status: 'Inseminada',
                                            dtPartoPrevisto:
                                                functions.somarDataParto(_model
                                                    .dtInseminacaoTextController
                                                    .text),
                                            dtSecPrevista: functions
                                                .somarDataSecagem(_model
                                                    .dtInseminacaoTextController
                                                    .text),
                                            dtPrePartoPrevista: functions
                                                .somarDataPreParto(_model
                                                    .dtInseminacaoTextController
                                                    .text),
                                            dtPP: '',
                                            nomeTouroUltimaInseminacao:
                                                _model.touroValue,
                                            compararDtUltimaInseminacao: functions
                                                .converterDataUltimaInseminacao(
                                                    _model
                                                        .dtInseminacaoTextController
                                                        .text),
                                            idStatusAnimal: 3,
                                          ),
                                          ...mapToFirestore(
                                            {
                                              'totalInseminacoes':
                                                  FieldValue.increment(1),
                                            },
                                          ),
                                        });
                                        await showDialog(
                                          context: context,
                                          builder: (alertDialogContext) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Ação cadastrada com sucesso!'),
                                              content: Text(
                                                  'Nova ação adicionada ao animal.'),
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
                                        Navigator.pop(context);
                                        if (_shouldSetState)
                                          safeSetState(() {});
                                        return;
                                      } else {
                                        if (_shouldSetState)
                                          safeSetState(() {});
                                        return;
                                      }
                                    } else {
                                      var acoesRecordReference2 =
                                          AcoesRecord.createDoc(
                                              widget.uidTecnico!);
                                      await acoesRecordReference2
                                          .set(createAcoesRecordData(
                                        uidAnimalAnimaisProdutores:
                                            widget.uidAnimaisProdutores,
                                        nomeAnimal: widget.nomeAnimal,
                                        acao: 'Inseminada',
                                        dataVisita: _model
                                            .dtInseminacaoTextController.text,
                                        obsVisita:
                                            _model.obsTextController.text,
                                        touroInseminacao: _model.touroValue,
                                        dataPartoPrevisto:
                                            functions.somarDataParto(_model
                                                .dtInseminacaoTextController
                                                .text),
                                        dataSecPrevista:
                                            functions.somarDataSecagem(_model
                                                .dtInseminacaoTextController
                                                .text),
                                        dataPrePartoPrevista:
                                            functions.somarDataPreParto(_model
                                                .dtInseminacaoTextController
                                                .text),
                                        dataDaAcao: getCurrentTimestamp,
                                        uidPropriedade: widget.uidPropriedade,
                                      ));
                                      _model.outUidAcaoRealizada2 =
                                          AcoesRecord.getDocumentFromData(
                                              createAcoesRecordData(
                                                uidAnimalAnimaisProdutores:
                                                    widget
                                                        .uidAnimaisProdutores,
                                                nomeAnimal: widget.nomeAnimal,
                                                acao: 'Inseminada',
                                                dataVisita: _model
                                                    .dtInseminacaoTextController
                                                    .text,
                                                obsVisita: _model
                                                    .obsTextController.text,
                                                touroInseminacao:
                                                    _model.touroValue,
                                                dataPartoPrevisto: functions
                                                    .somarDataParto(_model
                                                        .dtInseminacaoTextController
                                                        .text),
                                                dataSecPrevista: functions
                                                    .somarDataSecagem(_model
                                                        .dtInseminacaoTextController
                                                        .text),
                                                dataPrePartoPrevista: functions
                                                    .somarDataPreParto(_model
                                                        .dtInseminacaoTextController
                                                        .text),
                                                dataDaAcao: getCurrentTimestamp,
                                                uidPropriedade:
                                                    widget.uidPropriedade,
                                              ),
                                              acoesRecordReference2);
                                      _shouldSetState = true;

                                      await _model
                                          .outUidAnimaisAnimal!.reference
                                          .update({
                                        ...createAnimaisProdutoresRecordData(
                                          dtUltimaInseminacao: _model
                                              .dtInseminacaoTextController.text,
                                          status: 'Inseminada',
                                          dtPartoPrevisto:
                                              functions.somarDataParto(_model
                                                  .dtInseminacaoTextController
                                                  .text),
                                          dtSecPrevista:
                                              functions.somarDataSecagem(_model
                                                  .dtInseminacaoTextController
                                                  .text),
                                          dtPrePartoPrevista:
                                              functions.somarDataPreParto(_model
                                                  .dtInseminacaoTextController
                                                  .text),
                                          dtPP: '',
                                          nomeTouroUltimaInseminacao:
                                              _model.touroValue,
                                          compararDtUltimaInseminacao: functions
                                              .converterDataUltimaInseminacao(
                                                  _model
                                                      .dtInseminacaoTextController
                                                      .text),
                                          idStatusAnimal: 3,
                                        ),
                                        ...mapToFirestore(
                                          {
                                            'totalInseminacoes':
                                                FieldValue.increment(1),
                                          },
                                        ),
                                      });
                                      await showDialog(
                                        context: context,
                                        builder: (alertDialogContext) {
                                          return AlertDialog(
                                            title: Text(
                                                'Ação cadastrada com sucesso!'),
                                            content: Text(
                                                'Nova ação adicionada ao animal.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    alertDialogContext),
                                                child: Text('Ok'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      Navigator.pop(context);
                                      if (_shouldSetState) safeSetState(() {});
                                      return;
                                    }
                                  } else {
                                    var acoesRecordReference3 =
                                        AcoesRecord.createDoc(
                                            widget.uidTecnico!);
                                    await acoesRecordReference3
                                        .set(createAcoesRecordData(
                                      uidAnimalAnimaisProdutores:
                                          widget.uidAnimaisProdutores,
                                      nomeAnimal: widget.nomeAnimal,
                                      acao: 'Inseminada',
                                      dataVisita: _model
                                          .dtInseminacaoTextController.text,
                                      obsVisita: _model.obsTextController.text,
                                      touroInseminacao: _model.touroValue,
                                      dataPartoPrevisto:
                                          functions.somarDataParto(_model
                                              .dtInseminacaoTextController
                                              .text),
                                      dataSecPrevista:
                                          functions.somarDataSecagem(_model
                                              .dtInseminacaoTextController
                                              .text),
                                      dataPrePartoPrevista:
                                          functions.somarDataPreParto(_model
                                              .dtInseminacaoTextController
                                              .text),
                                      dataDaAcao: getCurrentTimestamp,
                                      uidPropriedade: widget.uidPropriedade,
                                    ));
                                    _model.outUidAcaoRealizada3 =
                                        AcoesRecord.getDocumentFromData(
                                            createAcoesRecordData(
                                              uidAnimalAnimaisProdutores:
                                                  widget.uidAnimaisProdutores,
                                              nomeAnimal: widget.nomeAnimal,
                                              acao: 'Inseminada',
                                              dataVisita: _model
                                                  .dtInseminacaoTextController
                                                  .text,
                                              obsVisita:
                                                  _model.obsTextController.text,
                                              touroInseminacao:
                                                  _model.touroValue,
                                              dataPartoPrevisto: functions
                                                  .somarDataParto(_model
                                                      .dtInseminacaoTextController
                                                      .text),
                                              dataSecPrevista: functions
                                                  .somarDataSecagem(_model
                                                      .dtInseminacaoTextController
                                                      .text),
                                              dataPrePartoPrevista: functions
                                                  .somarDataPreParto(_model
                                                      .dtInseminacaoTextController
                                                      .text),
                                              dataDaAcao: getCurrentTimestamp,
                                              uidPropriedade:
                                                  widget.uidPropriedade,
                                            ),
                                            acoesRecordReference3);
                                    _shouldSetState = true;

                                    await _model.outUidAnimaisAnimal!.reference
                                        .update({
                                      ...createAnimaisProdutoresRecordData(
                                        dtUltimaInseminacao: _model
                                            .dtInseminacaoTextController.text,
                                        status: 'Inseminada',
                                        dtPartoPrevisto:
                                            functions.somarDataParto(_model
                                                .dtInseminacaoTextController
                                                .text),
                                        dtSecPrevista:
                                            functions.somarDataSecagem(_model
                                                .dtInseminacaoTextController
                                                .text),
                                        dtPrePartoPrevista:
                                            functions.somarDataPreParto(_model
                                                .dtInseminacaoTextController
                                                .text),
                                        dtPP: '',
                                        nomeTouroUltimaInseminacao:
                                            _model.touroValue,
                                        compararDtUltimaInseminacao: functions
                                            .converterDataUltimaInseminacao(
                                                _model
                                                    .dtInseminacaoTextController
                                                    .text),
                                        idStatusAnimal: 3,
                                      ),
                                      ...mapToFirestore(
                                        {
                                          'totalInseminacoes':
                                              FieldValue.increment(1),
                                        },
                                      ),
                                    });
                                    await showDialog(
                                      context: context,
                                      builder: (alertDialogContext) {
                                        return AlertDialog(
                                          title: Text(
                                              'Ação cadastrada com sucesso!'),
                                          content: Text(
                                              'Nova ação adicionada ao animal.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  alertDialogContext),
                                              child: Text('Ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    Navigator.pop(context);
                                    if (_shouldSetState) safeSetState(() {});
                                    return;
                                  }
                                } else {
                                  await showDialog(
                                    context: context,
                                    builder: (alertDialogContext) {
                                      return AlertDialog(
                                        title:
                                            Text('Data da inseminação vazia'),
                                        content: Text('Selecione uma data'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                alertDialogContext),
                                            child: Text('Ok'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (_shouldSetState) safeSetState(() {});
                                  return;
                                }
                              } else {
                                await showDialog(
                                  context: context,
                                  builder: (alertDialogContext) {
                                    return AlertDialog(
                                      title: Text('Selecione um touro!'),
                                      content: Text(
                                          'Escolha um touro ou sêmen cadastrado.'),
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
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFF048508),
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
                              borderRadius: BorderRadius.circular(12.0),
                              hoverColor: FlutterFlowTheme.of(context).accent1,
                              hoverBorderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 1.0,
                              ),
                              hoverTextColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              hoverElevation: 0.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
          ),
        ],
      ),
    );
  }
}
