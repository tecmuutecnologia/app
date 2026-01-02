import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'dg_mais_existente_offline_model.dart';
export 'dg_mais_existente_offline_model.dart';

class DgMaisExistenteOfflineWidget extends StatefulWidget {
  const DgMaisExistenteOfflineWidget({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.uidAnimaisProdutores,
    required this.grupoPredominante,
    required this.nomeAnimal,
    required this.visitaPresencial,
    required this.diasDg,
    required this.itemUidIndex,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final DocumentReference? uidAnimaisProdutores;
  final String? grupoPredominante;
  final String? nomeAnimal;
  final bool? visitaPresencial;
  final String? diasDg;
  final int? itemUidIndex;

  @override
  State<DgMaisExistenteOfflineWidget> createState() =>
      _DgMaisExistenteOfflineWidgetState();
}

class _DgMaisExistenteOfflineWidgetState
    extends State<DgMaisExistenteOfflineWidget> with TickerProviderStateMixin {
  late DgMaisExistenteOfflineModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DgMaisExistenteOfflineModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.outUidAnimaisAnimal =
          await AnimaisProdutoresRecord.getDocumentOnce(
              widget.uidAnimaisProdutores!);
    });

    _model.dtDgMaisTextController ??= TextEditingController();
    _model.dtDgMaisFocusNode ??= FocusNode();

    _model.dtDgMaisMask = MaskTextInputFormatter(mask: '##/##/####');
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
          _model.dtDgMaisTextController?.text = dateTimeFormat(
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
    context.watch<FFAppState>();

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
                      'Data do DG+',
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
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 8.0, 0.0),
                                child: TextFormField(
                                  controller: _model.dtDgMaisTextController,
                                  focusNode: _model.dtDgMaisFocusNode,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.dtDgMaisTextController',
                                    Duration(milliseconds: 2000),
                                    () => safeSetState(() {}),
                                  ),
                                  autofocus: false,
                                  textCapitalization: TextCapitalization.none,
                                  textInputAction: TextInputAction.next,
                                  readOnly: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Data do DG+',
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
                                    suffixIcon: _model.dtDgMaisTextController!
                                            .text.isNotEmpty
                                        ? InkWell(
                                            onTap: () async {
                                              _model.dtDgMaisTextController
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
                                      .dtDgMaisTextControllerValidator
                                      .asValidator(context),
                                  inputFormatters: [_model.dtDgMaisMask],
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
                                  _model.dtDgMaisTextController?.text =
                                      dateTimeFormat(
                                    "dd/MM/yyyy",
                                    _model.datePicked,
                                    locale: FFLocalizations.of(context)
                                        .languageCode,
                                  );
                                  _model.dtDgMaisMask.updateMask(
                                    newValue: TextEditingValue(
                                      text: _model.dtDgMaisTextController!.text,
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
                              if (_model.dtDgMaisTextController.text != '') {
                                if (widget.grupoPredominante == 'Vacas') {
                                  FFAppState().addToAcoesOffline(AcoesStruct(
                                    uidAnimalOffline:
                                        widget.uidAnimaisProdutores?.id,
                                    uidPropriedade: widget.uidPropriedade,
                                    nomeAnimal: widget.nomeAnimal,
                                    acao: 'DG+',
                                    dataVisita: dateTimeFormat(
                                      "dd/MM/yyyy",
                                      getCurrentTimestamp,
                                      locale: FFLocalizations.of(context)
                                          .languageCode,
                                    ),
                                    dataDaAcao: getCurrentTimestamp,
                                    uidAnimalAnimaisProdutores:
                                        widget.uidAnimaisProdutores,
                                    dtDgMais:
                                        _model.dtDgMaisTextController.text,
                                  ));
                                  safeSetState(() {});
                                  // Verifica se o animal que está recebendo um ação já tem alguma lançada de forma offline em antes sincronizar.
                                  if (FFAppState()
                                          .animaisProdutoresEditados
                                          .length >
                                      0) {
                                    FFAppState().contador = 0;
                                    FFAppState().verificadorIgualdade = 0;
                                    safeSetState(() {});
                                    while ((FFAppState()
                                                .animaisProdutoresEditados
                                                .length >=
                                            FFAppState().contador) &&
                                        (FFAppState().verificadorIgualdade ==
                                            0)) {
                                      if (FFAppState()
                                              .animaisProdutoresEditados
                                              .elementAtOrNull(
                                                  FFAppState().contador)
                                              ?.uidAnimal ==
                                          widget.uidAnimaisProdutores) {
                                        FFAppState().contador =
                                            FFAppState().contador + 1;
                                        FFAppState().verificadorIgualdade = 1;
                                        safeSetState(() {});
                                        FFAppState()
                                            .updateAnimaisProdutoresExistentesAtIndex(
                                          widget.itemUidIndex!,
                                          (e) => e
                                            ..status = 'Prenha'
                                            ..idStatusAnimal = 6
                                            ..dtDgMais = _model
                                                .dtDgMaisTextController.text,
                                        );
                                        safeSetState(() {});
                                        FFAppState()
                                            .updateAnimaisProdutoresEditadosAtIndex(
                                          FFAppState().contador,
                                          (e) => e
                                            ..status = 'Prenha'
                                            ..idStatusAnimal = 6
                                            ..dtDgMais = _model
                                                .dtDgMaisTextController.text,
                                        );
                                        safeSetState(() {});
                                      } else {
                                        FFAppState().contador =
                                            FFAppState().contador + 1;
                                        safeSetState(() {});
                                      }

                                      break;
                                    }
                                    if (FFAppState().verificadorIgualdade ==
                                        0) {
                                      FFAppState()
                                          .updateAnimaisProdutoresExistentesAtIndex(
                                        widget.itemUidIndex!,
                                        (e) => e
                                          ..status = 'Prenha'
                                          ..idStatusAnimal = 6
                                          ..dtDgMais = _model
                                              .dtDgMaisTextController.text,
                                      );
                                      safeSetState(() {});
                                      FFAppState()
                                          .addToAnimaisProdutoresEditados(
                                              AnimaisProdutoresStruct(
                                        uidTecnicoPropriedade:
                                            widget.uidPropriedade,
                                        nomeAnimal: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.nomeAnimal,
                                        racaAnimal: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.racaAnimal,
                                        pesoAnimal: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.pesoAnimal,
                                        dtNascimento: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtNascimento,
                                        touro: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.touro,
                                        vaca: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.vaca,
                                        status: 'Prenha',
                                        grupoAnimal: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.grupoAnimal,
                                        dtUltimaInseminacao: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtUltimaInseminacao,
                                        dtUltimoParto: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtUltimoParto,
                                        liberaInseminacao: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.liberaInseminacao,
                                        dtPartoPrevisto: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtPartoPrevisto,
                                        dtSecPrevista: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtSecPrevista,
                                        dtPrePartoPrevista: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtPrePartoPrevista,
                                        dtPP: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtPP,
                                        dtDgMais:
                                            _model.dtDgMaisTextController.text,
                                        dtDgMenos: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtDgMenos,
                                        dtAborto: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtAborto,
                                        dtSecagem: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtSecagem,
                                        dtUltimoPP: dateTimeFormat(
                                          "dd/MM/yyyy",
                                          getCurrentTimestamp,
                                          locale: FFLocalizations.of(context)
                                              .languageCode,
                                        ),
                                        nomeTouroUltimaInseminacao: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.nomeTouroUltimaInseminacao,
                                        totalInseminacoes: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.totalInseminacoes,
                                        totalPartos: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.totalPartos,
                                        dtPreParto: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtPreParto,
                                        motivoDescarteAnimal: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.motivoDescarteAnimal,
                                        dtDescarteAnimal: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtDescarteAnimal,
                                        dtUltimaAcao: dateTimeFormat(
                                          "dd/MM/yyyy",
                                          getCurrentTimestamp,
                                          locale: FFLocalizations.of(context)
                                              .languageCode,
                                        ),
                                        compararDtUltimaInseminacao:
                                            FFAppState()
                                                .animaisProdutoresExistentes
                                                .elementAtOrNull(
                                                    widget.itemUidIndex!)
                                                ?.compararDtUltimaInseminacao,
                                        nomeBrincoConcat: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.nomeBrincoConcat,
                                        idGrupoAnimal: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.idGrupoAnimal,
                                        dtUltimoPartoContingencia: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtUltimoPartoContingencia,
                                        idStatusAnimal: 6,
                                        dtInducaoLactacao: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtInducaoLactacao,
                                        dtDesmame: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtDesmame,
                                        brincoAnimal: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.brincoAnimal,
                                        brincoAnimalOrder: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.brincoAnimalOrder,
                                        uidAnimal: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.uidAnimal,
                                      ));
                                      safeSetState(() {});
                                      Navigator.pop(context);
                                      return;
                                    } else {
                                      Navigator.pop(context);
                                      return;
                                    }
                                  } else {
                                    FFAppState()
                                        .updateAnimaisProdutoresExistentesAtIndex(
                                      widget.itemUidIndex!,
                                      (e) => e
                                        ..status = 'Prenha'
                                        ..idStatusAnimal = 6
                                        ..dtDgMais =
                                            _model.dtDgMaisTextController.text,
                                    );
                                    safeSetState(() {});
                                    FFAppState().addToAnimaisProdutoresEditados(
                                        AnimaisProdutoresStruct(
                                      uidTecnicoPropriedade:
                                          widget.uidPropriedade,
                                      nomeAnimal: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.nomeAnimal,
                                      racaAnimal: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.racaAnimal,
                                      pesoAnimal: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.pesoAnimal,
                                      dtNascimento: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtNascimento,
                                      touro: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.touro,
                                      vaca: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.vaca,
                                      status: 'Prenha',
                                      grupoAnimal: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.grupoAnimal,
                                      dtUltimaInseminacao: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtUltimaInseminacao,
                                      dtUltimoParto: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtUltimoParto,
                                      liberaInseminacao: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.liberaInseminacao,
                                      dtPartoPrevisto: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtPartoPrevisto,
                                      dtSecPrevista: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtSecPrevista,
                                      dtPrePartoPrevista: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtPrePartoPrevista,
                                      dtPP: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtPP,
                                      dtDgMais:
                                          _model.dtDgMaisTextController.text,
                                      dtDgMenos: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtDgMenos,
                                      dtAborto: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtAborto,
                                      dtSecagem: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtSecagem,
                                      dtUltimoPP: dateTimeFormat(
                                        "dd/MM/yyyy",
                                        getCurrentTimestamp,
                                        locale: FFLocalizations.of(context)
                                            .languageCode,
                                      ),
                                      nomeTouroUltimaInseminacao: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.nomeTouroUltimaInseminacao,
                                      totalInseminacoes: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.totalInseminacoes,
                                      totalPartos: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.totalPartos,
                                      dtPreParto: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtPreParto,
                                      motivoDescarteAnimal: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.motivoDescarteAnimal,
                                      dtDescarteAnimal: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtDescarteAnimal,
                                      dtUltimaAcao: dateTimeFormat(
                                        "dd/MM/yyyy",
                                        getCurrentTimestamp,
                                        locale: FFLocalizations.of(context)
                                            .languageCode,
                                      ),
                                      compararDtUltimaInseminacao: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.compararDtUltimaInseminacao,
                                      nomeBrincoConcat: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.nomeBrincoConcat,
                                      idGrupoAnimal: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.idGrupoAnimal,
                                      dtUltimoPartoContingencia: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtUltimoPartoContingencia,
                                      idStatusAnimal: 6,
                                      dtInducaoLactacao: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtInducaoLactacao,
                                      dtDesmame: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtDesmame,
                                      brincoAnimal: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.brincoAnimal,
                                      brincoAnimalOrder: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.brincoAnimalOrder,
                                      uidAnimal: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.uidAnimal,
                                    ));
                                    safeSetState(() {});
                                    Navigator.pop(context);
                                    return;
                                  }
                                } else {
                                  FFAppState().addToAcoesOffline(AcoesStruct(
                                    uidAnimalOffline:
                                        widget.uidAnimaisProdutores?.id,
                                    uidPropriedade: widget.uidPropriedade,
                                    nomeAnimal: widget.nomeAnimal,
                                    acao: 'Secagem',
                                    dataVisita: dateTimeFormat(
                                      "dd/MM/yyyy",
                                      getCurrentTimestamp,
                                      locale: FFLocalizations.of(context)
                                          .languageCode,
                                    ),
                                    dataDaAcao: getCurrentTimestamp,
                                    uidAnimalAnimaisProdutores:
                                        widget.uidAnimaisProdutores,
                                  ));
                                  safeSetState(() {});
                                  // Verifica se o animal que está recebendo um ação já tem alguma lançada de forma offline em antes sincronizar.
                                  if (FFAppState()
                                          .animaisProdutoresEditados
                                          .length >
                                      0) {
                                    FFAppState().contador = 0;
                                    FFAppState().verificadorIgualdade = 0;
                                    safeSetState(() {});
                                    while ((FFAppState()
                                                .animaisProdutoresEditados
                                                .length >=
                                            FFAppState().contador) &&
                                        (FFAppState().verificadorIgualdade ==
                                            0)) {
                                      if (FFAppState()
                                              .animaisProdutoresEditados
                                              .elementAtOrNull(
                                                  FFAppState().contador)
                                              ?.uidAnimal ==
                                          widget.uidAnimaisProdutores) {
                                        FFAppState().contador =
                                            FFAppState().contador + 1;
                                        FFAppState().verificadorIgualdade = 1;
                                        safeSetState(() {});
                                        FFAppState()
                                            .updateAnimaisProdutoresExistentesAtIndex(
                                          widget.itemUidIndex!,
                                          (e) => e
                                            ..status = 'Prenha'
                                            ..idStatusAnimal = 6
                                            ..dtDgMais = _model
                                                .dtDgMaisTextController.text,
                                        );
                                        safeSetState(() {});
                                        FFAppState()
                                            .updateAnimaisProdutoresEditadosAtIndex(
                                          FFAppState().contador,
                                          (e) => e
                                            ..status = 'Prenha'
                                            ..idStatusAnimal = 6
                                            ..dtDgMais = _model
                                                .dtDgMaisTextController.text,
                                        );
                                        safeSetState(() {});
                                      } else {
                                        FFAppState().contador =
                                            FFAppState().contador + 1;
                                        safeSetState(() {});
                                      }

                                      break;
                                    }
                                    if (FFAppState().verificadorIgualdade ==
                                        0) {
                                      FFAppState()
                                          .updateAnimaisProdutoresExistentesAtIndex(
                                        widget.itemUidIndex!,
                                        (e) => e
                                          ..status = 'Prenha'
                                          ..idStatusAnimal = 6
                                          ..dtDgMais = _model
                                              .dtDgMaisTextController.text,
                                      );
                                      safeSetState(() {});
                                      FFAppState()
                                          .addToAnimaisProdutoresEditados(
                                              AnimaisProdutoresStruct(
                                        uidTecnicoPropriedade:
                                            widget.uidPropriedade,
                                        nomeAnimal: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.nomeAnimal,
                                        racaAnimal: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.racaAnimal,
                                        pesoAnimal: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.pesoAnimal,
                                        dtNascimento: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtNascimento,
                                        touro: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.touro,
                                        vaca: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.vaca,
                                        status: 'Prenha',
                                        grupoAnimal: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.grupoAnimal,
                                        dtUltimaInseminacao: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtUltimaInseminacao,
                                        dtUltimoParto: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtUltimoParto,
                                        liberaInseminacao: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.liberaInseminacao,
                                        dtPartoPrevisto: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtPartoPrevisto,
                                        dtSecPrevista: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtSecPrevista,
                                        dtPrePartoPrevista: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtPrePartoPrevista,
                                        dtPP: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtPP,
                                        dtDgMais:
                                            _model.dtDgMaisTextController.text,
                                        dtDgMenos: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtDgMenos,
                                        dtAborto: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtAborto,
                                        dtSecagem: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtSecagem,
                                        dtUltimoPP: dateTimeFormat(
                                          "dd/MM/yyyy",
                                          getCurrentTimestamp,
                                          locale: FFLocalizations.of(context)
                                              .languageCode,
                                        ),
                                        nomeTouroUltimaInseminacao: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.nomeTouroUltimaInseminacao,
                                        totalInseminacoes: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.totalInseminacoes,
                                        totalPartos: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.totalPartos,
                                        dtPreParto: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtPreParto,
                                        motivoDescarteAnimal: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.motivoDescarteAnimal,
                                        dtDescarteAnimal: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtDescarteAnimal,
                                        dtUltimaAcao: dateTimeFormat(
                                          "dd/MM/yyyy",
                                          getCurrentTimestamp,
                                          locale: FFLocalizations.of(context)
                                              .languageCode,
                                        ),
                                        compararDtUltimaInseminacao:
                                            FFAppState()
                                                .animaisProdutoresExistentes
                                                .elementAtOrNull(
                                                    widget.itemUidIndex!)
                                                ?.compararDtUltimaInseminacao,
                                        nomeBrincoConcat: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.nomeBrincoConcat,
                                        idGrupoAnimal: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.idGrupoAnimal,
                                        dtUltimoPartoContingencia: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtUltimoPartoContingencia,
                                        idStatusAnimal: 6,
                                        dtInducaoLactacao: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtInducaoLactacao,
                                        dtDesmame: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.dtDesmame,
                                        brincoAnimal: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.brincoAnimal,
                                        brincoAnimalOrder: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.brincoAnimalOrder,
                                        uidAnimal: FFAppState()
                                            .animaisProdutoresExistentes
                                            .elementAtOrNull(
                                                widget.itemUidIndex!)
                                            ?.uidAnimal,
                                      ));
                                      safeSetState(() {});
                                      Navigator.pop(context);
                                      return;
                                    } else {
                                      Navigator.pop(context);
                                      return;
                                    }
                                  } else {
                                    FFAppState()
                                        .updateAnimaisProdutoresExistentesAtIndex(
                                      widget.itemUidIndex!,
                                      (e) => e
                                        ..status = 'Prenha'
                                        ..idStatusAnimal = 6
                                        ..dtDgMais =
                                            _model.dtDgMaisTextController.text,
                                    );
                                    safeSetState(() {});
                                    FFAppState().addToAnimaisProdutoresEditados(
                                        AnimaisProdutoresStruct(
                                      uidTecnicoPropriedade:
                                          widget.uidPropriedade,
                                      nomeAnimal: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.nomeAnimal,
                                      racaAnimal: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.racaAnimal,
                                      pesoAnimal: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.pesoAnimal,
                                      dtNascimento: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtNascimento,
                                      touro: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.touro,
                                      vaca: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.vaca,
                                      status: 'Prenha',
                                      grupoAnimal: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.grupoAnimal,
                                      dtUltimaInseminacao: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtUltimaInseminacao,
                                      dtUltimoParto: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtUltimoParto,
                                      liberaInseminacao: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.liberaInseminacao,
                                      dtPartoPrevisto: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtPartoPrevisto,
                                      dtSecPrevista: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtSecPrevista,
                                      dtPrePartoPrevista: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtPrePartoPrevista,
                                      dtPP: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtPP,
                                      dtDgMais:
                                          _model.dtDgMaisTextController.text,
                                      dtDgMenos: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtDgMenos,
                                      dtAborto: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtAborto,
                                      dtSecagem: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtSecagem,
                                      dtUltimoPP: dateTimeFormat(
                                        "dd/MM/yyyy",
                                        getCurrentTimestamp,
                                        locale: FFLocalizations.of(context)
                                            .languageCode,
                                      ),
                                      nomeTouroUltimaInseminacao: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.nomeTouroUltimaInseminacao,
                                      totalInseminacoes: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.totalInseminacoes,
                                      totalPartos: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.totalPartos,
                                      dtPreParto: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtPreParto,
                                      motivoDescarteAnimal: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.motivoDescarteAnimal,
                                      dtDescarteAnimal: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtDescarteAnimal,
                                      dtUltimaAcao: dateTimeFormat(
                                        "dd/MM/yyyy",
                                        getCurrentTimestamp,
                                        locale: FFLocalizations.of(context)
                                            .languageCode,
                                      ),
                                      compararDtUltimaInseminacao: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.compararDtUltimaInseminacao,
                                      nomeBrincoConcat: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.nomeBrincoConcat,
                                      idGrupoAnimal: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.idGrupoAnimal,
                                      dtUltimoPartoContingencia: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtUltimoPartoContingencia,
                                      idStatusAnimal: 6,
                                      dtInducaoLactacao: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtInducaoLactacao,
                                      dtDesmame: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtDesmame,
                                      brincoAnimal: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.brincoAnimal,
                                      brincoAnimalOrder: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.brincoAnimalOrder,
                                      uidAnimal: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.uidAnimal,
                                    ));
                                    safeSetState(() {});
                                    Navigator.pop(context);
                                    return;
                                  }
                                }
                              } else {
                                await showDialog(
                                  context: context,
                                  builder: (alertDialogContext) {
                                    return AlertDialog(
                                      title: Text('Data do DG+ vazia.'),
                                      content: Text('Selecione uma data.'),
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
                            text: 'DG+',
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
                                    fontSize: 14.0,
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
