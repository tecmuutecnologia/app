// ignore_for_file: dead_code

import '/data/backend.dart';
import '/core/ui/app_card.dart';
import '/data/objectbox/repositories/animal_repository.dart';
import '/core/connectivity/connectivity_service.dart';
import 'dart:async';
import '/core/ui/flutter_flow_animations.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import 'dart:ui';
import '/core/ui/custom_functions.dart' as functions;
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegistrarPrePartoWidget extends StatefulWidget {
  const RegistrarPrePartoWidget({
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
    required this.dtPrePartoPrevista,
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
  final DateTime? dtPrePartoPrevista;

  @override
  State<RegistrarPrePartoWidget> createState() =>
      _RegistrarPrePartoWidgetState();
}

class _RegistrarPrePartoWidgetState extends State<RegistrarPrePartoWidget>
    with TickerProviderStateMixin {
  final animationsMap = <String, AnimationInfo>{};

  FocusNode? _dtPrePartoFocusNode;
  TextEditingController? _dtPrePartoTextController;
  late MaskTextInputFormatter _dtPrePartoMask;
  final String? Function(BuildContext, String?)?
      _dtPrePartoTextControllerValidator = null;
  DateTime? _datePicked;
  ResumoDaVisitaRecord? _outUidResumoDaVisita;
  AnimaisProdutoresRecord? _uidAnimalRecebeAcao1;
  RecomendacoesRecord? _outUidRecomendacoes;
  ResumoDaVisitaRecord? _outNewUidResumoDaVisita;
  AnimaisProdutoresRecord? _uidAnimalRecebeAcao;
  RecomendacoesRecord? _outUidRecomendacoes2;

  @override
  void initState() {
    super.initState();

    _dtPrePartoTextController ??= TextEditingController();
    _dtPrePartoFocusNode ??= FocusNode();

    _dtPrePartoMask = MaskTextInputFormatter(mask: '##/##/####');
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
          _dtPrePartoTextController?.text = dateTimeFormat(
            "dd/MM/yyyy",
            widget.dtPrePartoPrevista,
            locale: FFLocalizations.of(context).languageCode,
          );
        }));
  }

  @override
  void dispose() {
    _dtPrePartoFocusNode?.dispose();
    _dtPrePartoTextController?.dispose();

    super.dispose();
  }

  /// Registra o pré-parto de forma offline-first: atualiza o status do animal
  /// ('Pré Parto') direto no ObjectBox (fonte única), delegando o sync com o
  /// Firestore aos repositórios. Funciona sem conexão.
  Future<void> _registrarPrePartoOfflineFirst() async {
    final dados = {
      'status': 'Pré Parto',
      'dtPreParto': _dtPrePartoTextController.text,
      'idStatusAnimal': 5,
    };
    final animalRepo = AnimalRepository();
    final entity = widget.uidAnimaisProdutores != null
        ? animalRepo.getByFirestoreId(widget.uidAnimaisProdutores!.id)
        : null;
    if (entity != null) {
      unawaited(animalRepo.update(entity, dados));
    } else {
      unawaited(
          widget.uidAnimaisProdutores!.update(createAnimaisProdutoresRecordData(
        status: 'Pré Parto',
        dtPreParto: _dtPrePartoTextController.text,
        idStatusAnimal: 5,
      )));
    }
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
            _p4(context),
          ],
        ),
      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
    );
  }

  Widget _p2(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 0.0, 0.0),
      child: Text(
        'Registrar pré parto',
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
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                  child: TextFormField(
                    controller: _dtPrePartoTextController,
                    focusNode: _dtPrePartoFocusNode,
                    autofocus: false,
                    readOnly: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Data pré parto*',
                      labelStyle:
                          FlutterFlowTheme.of(context).labelMedium.override(
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
                      hintStyle:
                          FlutterFlowTheme.of(context).labelMedium.override(
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
                          color: AppTokens.secondary,
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
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      contentPadding: EdgeInsetsDirectional.fromSTEB(
                          20.0, 24.0, 20.0, 24.0),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                    cursorColor: FlutterFlowTheme.of(context).primary,
                    validator:
                        _dtPrePartoTextControllerValidator.asValidator(context),
                    inputFormatters: [_dtPrePartoMask],
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
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            child: CupertinoTheme(
                              data: _datePickedCupertinoTheme.copyWith(
                                textTheme: _datePickedCupertinoTheme.textTheme
                                    .copyWith(
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
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .headlineMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineMedium
                                                    .fontStyle,
                                          ),
                                ),
                              ),
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.date,
                                minimumDate: (widget.dtPrePartoPrevista ??
                                    DateTime.now()),
                                initialDateTime: (widget.dtPrePartoPrevista ??
                                    DateTime.now()),
                                maximumDate: DateTime(2050),
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
                    _dtPrePartoTextController?.text = dateTimeFormat(
                      "dd/MM/yyyy",
                      _datePicked,
                      locale: FFLocalizations.of(context).languageCode,
                    );
                    _dtPrePartoMask.updateMask(
                      newValue: TextEditingValue(
                        text: _dtPrePartoTextController!.text,
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
        ),
      ],
    );
  }

  Widget _p4(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 24.0),
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
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: FlutterFlowTheme.of(context).secondaryBackground,
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
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
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
          ),
          Align(
            alignment: AlignmentDirectional(0.0, 0.05),
            child: FFButtonWidget(
              onPressed: () async {
                var _shouldSetState = false;
                if (_dtPrePartoTextController.text == '') {
                  await showDialog(
                    context: context,
                    builder: (alertDialogContext) {
                      return AlertDialog(
                        title: Text('Data do Pré-Parto obrigatória.'),
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

                // Offline-first: atualiza o animal (Pré Parto) no
                // ObjectBox; sync enfileirado pelos repositórios.
                await _registrarPrePartoOfflineFirst();
                _shouldSetState = true;

                // Bookkeeping de visita/tratamento/recomendação roda
                // só online (offline a antiga variante também omite).
                if (ConnectivityService.instance.isOnline) {
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
                    _uidAnimalRecebeAcao1 =
                        await AnimaisProdutoresRecord.getDocumentOnce(
                            widget.uidAnimaisProdutores!);
                    _shouldSetState = true;

                    await TratamentosRecord.createDoc(
                            _outUidResumoDaVisita!.reference)
                        .set(createTratamentosRecordData(
                      uidAnimal: widget.uidAnimaisProdutores,
                      tipoAcao: 'Pré Parto',
                      uidResumoDaVisita: _outUidResumoDaVisita?.reference,
                      observacaoAcao: _dtPrePartoTextController.text,
                      brincoAnimal: widget.brincoAnimal,
                      nomeAnimal: widget.nomeAnimal,
                      grupoAnimal: widget.grupoAnimal,
                      brincoAnimalOrder:
                          functions.converterStringToInt(widget.brincoAnimal!),
                      compararDtUltimaInseminacao:
                          _uidAnimalRecebeAcao1?.compararDtUltimaInseminacao,
                    ));
                    _outUidRecomendacoes = await queryRecomendacoesRecordOnce(
                      parent: _outUidResumoDaVisita?.reference,
                      queryBuilder: (recomendacoesRecord) => recomendacoesRecord
                          .where(
                            'uidResumoDaVisita',
                            isEqualTo: _outUidResumoDaVisita?.reference,
                          )
                          .where(
                            'tituloRecomendacao',
                            isEqualTo: 'Pré Parto',
                          ),
                      singleRecord: true,
                    ).then((s) => s.firstOrNull);
                    _shouldSetState = true;
                    if (_outUidRecomendacoes?.reference == null) {
                      await RecomendacoesRecord.createDoc(
                              _outUidResumoDaVisita!.reference)
                          .set(createRecomendacoesRecordData(
                        tituloRecomendacao: 'Pré Parto',
                        uidResumoDaVisita: _outUidResumoDaVisita?.reference,
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
                                locale:
                                    FFLocalizations.of(context).languageCode,
                              ),
                            ),
                            resumoDaVisitaRecordReference);
                    _shouldSetState = true;

                    await _outNewUidResumoDaVisita!.reference
                        .update(createResumoDaVisitaRecordData(
                      uidResumoDaVisita: _outNewUidResumoDaVisita?.reference,
                    ));
                    _uidAnimalRecebeAcao =
                        await AnimaisProdutoresRecord.getDocumentOnce(
                            widget.uidAnimaisProdutores!);
                    _shouldSetState = true;

                    await TratamentosRecord.createDoc(
                            _outNewUidResumoDaVisita!.reference)
                        .set(createTratamentosRecordData(
                      uidAnimal: widget.uidAnimaisProdutores,
                      tipoAcao: 'Pré Parto',
                      uidResumoDaVisita: _outNewUidResumoDaVisita?.reference,
                      observacaoAcao: _dtPrePartoTextController.text,
                      brincoAnimal: widget.brincoAnimal,
                      nomeAnimal: widget.nomeAnimal,
                      grupoAnimal: widget.grupoAnimal,
                      brincoAnimalOrder:
                          functions.converterStringToInt(widget.brincoAnimal!),
                      compararDtUltimaInseminacao:
                          _uidAnimalRecebeAcao?.compararDtUltimaInseminacao,
                    ));
                    _outUidRecomendacoes2 = await queryRecomendacoesRecordOnce(
                      parent: _outNewUidResumoDaVisita?.reference,
                      queryBuilder: (recomendacoesRecord) => recomendacoesRecord
                          .where(
                            'uidResumoDaVisita',
                            isEqualTo: _outNewUidResumoDaVisita?.reference,
                          )
                          .where(
                            'tituloRecomendacao',
                            isEqualTo: 'Pré Parto',
                          ),
                      singleRecord: true,
                    ).then((s) => s.firstOrNull);
                    _shouldSetState = true;
                    if (_outUidRecomendacoes2?.reference == null) {
                      await RecomendacoesRecord.createDoc(
                              _outNewUidResumoDaVisita!.reference)
                          .set(createRecomendacoesRecordData(
                        tituloRecomendacao: 'Pré Parto',
                        uidResumoDaVisita: _outNewUidResumoDaVisita?.reference,
                      ));
                    }
                  }
                }

                Navigator.pop(context);
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
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
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
