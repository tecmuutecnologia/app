import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'registrar_secagem_model.dart';
export 'registrar_secagem_model.dart';

class RegistrarSecagemWidget extends StatefulWidget {
  const RegistrarSecagemWidget({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.diasDg,
    required this.uidAnimaisProdutores,
    required this.nomeAnimal,
    required this.brincoAnimal,
    required this.grupoAnimal,
    required this.dtSecPrevista,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? diasDg;
  final DocumentReference? uidAnimaisProdutores;
  final String? nomeAnimal;
  final String? brincoAnimal;
  final String? grupoAnimal;
  final DateTime? dtSecPrevista;

  @override
  State<RegistrarSecagemWidget> createState() => _RegistrarSecagemWidgetState();
}

class _RegistrarSecagemWidgetState extends State<RegistrarSecagemWidget>
    with TickerProviderStateMixin {
  late RegistrarSecagemModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RegistrarSecagemModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.outUidAnimaisAnimal =
          await AnimaisProdutoresRecord.getDocumentOnce(
              widget.uidAnimaisProdutores!);
    });

    _model.dtSecagemTextController ??= TextEditingController();
    _model.dtSecagemFocusNode ??= FocusNode();

    _model.dtSecagemMask = MaskTextInputFormatter(mask: '##/##/####');
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
          _model.dtSecagemTextController?.text = dateTimeFormat(
            "dd/MM/yyyy",
            widget.dtSecPrevista,
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
                      'Data secagem',
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
                                  controller: _model.dtSecagemTextController,
                                  focusNode: _model.dtSecagemFocusNode,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.dtSecagemTextController',
                                    Duration(milliseconds: 2000),
                                    () => safeSetState(() {}),
                                  ),
                                  autofocus: false,
                                  textCapitalization: TextCapitalization.none,
                                  textInputAction: TextInputAction.next,
                                  readOnly: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Data início da secagem',
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
                                    suffixIcon: _model.dtSecagemTextController!
                                            .text.isNotEmpty
                                        ? InkWell(
                                            onTap: () async {
                                              _model.dtSecagemTextController
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
                                      .dtSecagemTextControllerValidator
                                      .asValidator(context),
                                  inputFormatters: [_model.dtSecagemMask],
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
                                              minimumDate:
                                                  (widget.dtSecPrevista ??
                                                      DateTime.now()),
                                              initialDateTime:
                                                  (widget.dtSecPrevista ??
                                                      DateTime.now()),
                                              maximumDate: DateTime(2050),
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
                                  _model.dtSecagemTextController?.text =
                                      dateTimeFormat(
                                    "dd/MM/yyyy",
                                    _model.datePicked,
                                    locale: FFLocalizations.of(context)
                                        .languageCode,
                                  );
                                  _model.dtSecagemMask.updateMask(
                                    newValue: TextEditingValue(
                                      text:
                                          _model.dtSecagemTextController!.text,
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
                        EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 24.0),
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
                              if (_model.dtSecagemTextController.text != '') {
                                var acoesRecordReference =
                                    AcoesRecord.createDoc(widget.uidTecnico!);
                                await acoesRecordReference
                                    .set(createAcoesRecordData(
                                  uidAnimalAnimaisProdutores:
                                      widget.uidAnimaisProdutores,
                                  nomeAnimal: widget.nomeAnimal,
                                  acao: 'Secagem',
                                  dataVisita:
                                      _model.dtSecagemTextController.text,
                                  dataDaAcao: getCurrentTimestamp,
                                ));
                                _model.outUidAcaoRealizada =
                                    AcoesRecord.getDocumentFromData(
                                        createAcoesRecordData(
                                          uidAnimalAnimaisProdutores:
                                              widget.uidAnimaisProdutores,
                                          nomeAnimal: widget.nomeAnimal,
                                          acao: 'Secagem',
                                          dataVisita: _model
                                              .dtSecagemTextController.text,
                                          dataDaAcao: getCurrentTimestamp,
                                        ),
                                        acoesRecordReference);
                                _shouldSetState = true;
                              } else {
                                await showDialog(
                                  context: context,
                                  builder: (alertDialogContext) {
                                    return AlertDialog(
                                      title: Text('Data da secagem vazia.'),
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
                                if (_shouldSetState) safeSetState(() {});
                                return;
                              }

                              await _model.outUidAnimaisAnimal!.reference
                                  .update(createAnimaisProdutoresRecordData(
                                status: 'Seca',
                                dtSecagem: _model.dtSecagemTextController.text,
                                dtUltimoParto: '',
                                idStatusAnimal: 4,
                              ));
                              _model.outUidResumoDaVisita =
                                  await queryResumoDaVisitaRecordOnce(
                                queryBuilder: (resumoDaVisitaRecord) =>
                                    resumoDaVisitaRecord
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
                                            locale: FFLocalizations.of(context)
                                                .languageCode,
                                          ),
                                        ),
                                singleRecord: true,
                              ).then((s) => s.firstOrNull);
                              _shouldSetState = true;
                              if (_model.outUidResumoDaVisita != null) {
                                _model.uidAnimalRecebeAcao1 =
                                    await AnimaisProdutoresRecord
                                        .getDocumentOnce(
                                            widget.uidAnimaisProdutores!);
                                _shouldSetState = true;

                                await TratamentosRecord.createDoc(
                                        _model.outUidResumoDaVisita!.reference)
                                    .set(createTratamentosRecordData(
                                  uidAnimal: widget.uidAnimaisProdutores,
                                  tipoAcao: 'Secagem',
                                  uidResumoDaVisita:
                                      _model.outUidResumoDaVisita?.reference,
                                  observacaoAcao:
                                      _model.dtSecagemTextController.text,
                                  brincoAnimal: widget.brincoAnimal,
                                  nomeAnimal: widget.nomeAnimal,
                                  grupoAnimal: widget.grupoAnimal,
                                  brincoAnimalOrder:
                                      functions.converterStringToInt(
                                          widget.brincoAnimal!),
                                  compararDtUltimaInseminacao: _model
                                      .uidAnimalRecebeAcao1
                                      ?.compararDtUltimaInseminacao,
                                ));
                                _model.outUidRecomendacoes =
                                    await queryRecomendacoesRecordOnce(
                                  parent:
                                      _model.outUidResumoDaVisita?.reference,
                                  queryBuilder: (recomendacoesRecord) =>
                                      recomendacoesRecord
                                          .where(
                                            'uidResumoDaVisita',
                                            isEqualTo: _model
                                                .outUidResumoDaVisita
                                                ?.reference,
                                          )
                                          .where(
                                            'tituloRecomendacao',
                                            isEqualTo: 'Secagem',
                                          ),
                                  singleRecord: true,
                                ).then((s) => s.firstOrNull);
                                _shouldSetState = true;
                                if (_model.outUidRecomendacoes?.reference ==
                                    null) {
                                  await RecomendacoesRecord.createDoc(_model
                                          .outUidResumoDaVisita!.reference)
                                      .set(createRecomendacoesRecordData(
                                    tituloRecomendacao: 'Secagem',
                                    uidResumoDaVisita:
                                        _model.outUidResumoDaVisita?.reference,
                                  ));
                                }
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
                                    locale: FFLocalizations.of(context)
                                        .languageCode,
                                  ),
                                ));
                                _model.outNewUidResumoDaVisita =
                                    ResumoDaVisitaRecord.getDocumentFromData(
                                        createResumoDaVisitaRecordData(
                                          uidPropriedade:
                                              widget.uidPropriedade,
                                          uidTecnico: widget.uidTecnico,
                                          dtVisita: getCurrentTimestamp,
                                          dtVisitaFormatado: dateTimeFormat(
                                            "dd/MM/yyyy",
                                            getCurrentTimestamp,
                                            locale: FFLocalizations.of(context)
                                                .languageCode,
                                          ),
                                        ),
                                        resumoDaVisitaRecordReference);
                                _shouldSetState = true;

                                await _model.outNewUidResumoDaVisita!.reference
                                    .update(createResumoDaVisitaRecordData(
                                  uidResumoDaVisita:
                                      _model.outNewUidResumoDaVisita?.reference,
                                ));
                                _model.uidAnimalRecebeAcao =
                                    await AnimaisProdutoresRecord
                                        .getDocumentOnce(
                                            widget.uidAnimaisProdutores!);
                                _shouldSetState = true;

                                await TratamentosRecord.createDoc(_model
                                        .outNewUidResumoDaVisita!.reference)
                                    .set(createTratamentosRecordData(
                                  uidAnimal: widget.uidAnimaisProdutores,
                                  tipoAcao: 'Secagem',
                                  uidResumoDaVisita:
                                      _model.outNewUidResumoDaVisita?.reference,
                                  observacaoAcao:
                                      _model.dtSecagemTextController.text,
                                  brincoAnimal: widget.brincoAnimal,
                                  nomeAnimal: widget.nomeAnimal,
                                  grupoAnimal: widget.grupoAnimal,
                                  brincoAnimalOrder:
                                      functions.converterStringToInt(
                                          widget.brincoAnimal!),
                                  compararDtUltimaInseminacao: _model
                                      .uidAnimalRecebeAcao
                                      ?.compararDtUltimaInseminacao,
                                ));
                                _model.outUidRecomendacoes2 =
                                    await queryRecomendacoesRecordOnce(
                                  parent:
                                      _model.outNewUidResumoDaVisita?.reference,
                                  queryBuilder: (recomendacoesRecord) =>
                                      recomendacoesRecord
                                          .where(
                                            'uidResumoDaVisita',
                                            isEqualTo: _model
                                                .outNewUidResumoDaVisita
                                                ?.reference,
                                          )
                                          .where(
                                            'tituloRecomendacao',
                                            isEqualTo: 'Secagem',
                                          ),
                                  singleRecord: true,
                                ).then((s) => s.firstOrNull);
                                _shouldSetState = true;
                                if (_model.outUidRecomendacoes2?.reference ==
                                    null) {
                                  await RecomendacoesRecord.createDoc(_model
                                          .outNewUidResumoDaVisita!.reference)
                                      .set(createRecomendacoesRecordData(
                                    tituloRecomendacao: 'Secagem',
                                    uidResumoDaVisita: _model
                                        .outNewUidResumoDaVisita?.reference,
                                  ));
                                }
                              }

                              Navigator.pop(context);
                              if (_shouldSetState) safeSetState(() {});
                            },
                            text: 'Secar',
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
