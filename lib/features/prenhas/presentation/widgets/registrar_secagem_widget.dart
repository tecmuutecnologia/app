// ignore_for_file: dead_code

import '/data/backend.dart';
import '/core/ui/app_card.dart';
import '/data/objectbox/entities/index.dart';
import '/data/objectbox/repositories/acao_repository.dart';
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
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
    this.uidAnimalOffline,
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

  /// Identidade local do animal criado OFFLINE (sem firestoreId no Firestore).
  /// Para esses, [uidAnimaisProdutores] e null; a acao guarda este id e o
  /// vinculo e resolvido pela cascata quando o animal sincroniza (E3p2).
  final String? uidAnimalOffline;
  final String? nomeAnimal;
  final String? brincoAnimal;
  final String? grupoAnimal;
  final DateTime? dtSecPrevista;

  @override
  State<RegistrarSecagemWidget> createState() => _RegistrarSecagemWidgetState();
}

class _RegistrarSecagemWidgetState extends State<RegistrarSecagemWidget>
    with TickerProviderStateMixin {
  final animationsMap = <String, AnimationInfo>{};

  AnimaisProdutoresRecord? _outUidAnimaisAnimal;
  FocusNode? _dtSecagemFocusNode;
  TextEditingController? _dtSecagemTextController;
  late MaskTextInputFormatter _dtSecagemMask;
  final String? Function(BuildContext, String?)?
      _dtSecagemTextControllerValidator = null;
  DateTime? _datePicked;

  // Outputs de query/criação (antes no FlutterFlowModel).
  ResumoDaVisitaRecord? _outUidResumoDaVisita;
  AnimaisProdutoresRecord? _uidAnimalRecebeAcao1;
  RecomendacoesRecord? _outUidRecomendacoes;
  ResumoDaVisitaRecord? _outNewUidResumoDaVisita;
  AnimaisProdutoresRecord? _uidAnimalRecebeAcao;
  RecomendacoesRecord? _outUidRecomendacoes2;

  @override
  void initState() {
    super.initState();

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _outUidAnimaisAnimal = await AnimaisProdutoresRecord.getDocumentOnce(
          widget.uidAnimaisProdutores!);
    });

    _dtSecagemTextController ??= TextEditingController();
    _dtSecagemFocusNode ??= FocusNode();

    _dtSecagemMask = MaskTextInputFormatter(mask: '##/##/####');
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
          _dtSecagemTextController?.text = dateTimeFormat(
            "dd/MM/yyyy",
            widget.dtSecPrevista,
            locale: FFLocalizations.of(context).languageCode,
          );
        }));
  }

  @override
  void dispose() {
    _dtSecagemFocusNode?.dispose();
    _dtSecagemTextController?.dispose();

    super.dispose();
  }

  /// Registra a secagem de forma offline-first: grava a ação 'Secagem' e
  /// atualiza o status do animal ('Seca') no ObjectBox (fonte única), delegando
  /// a sincronização com o Firestore aos repositórios. Funciona sem conexão.
  Future<void> _registrarSecagemOfflineFirst() async {
    final acao = AcaoEntity(
      parentPath: widget.uidTecnico!.path,
      uidAnimalAnimaisProdutoresPath: widget.uidAnimaisProdutores?.path,
      uidAnimalOffline:
          widget.uidAnimaisProdutores == null ? widget.uidAnimalOffline : null,
      nomeAnimal: widget.nomeAnimal,
      acao: 'Secagem',
      dataVisita: _dtSecagemTextController.text,
      dataDaAcao: getCurrentTimestamp,
    );
    unawaited(AcaoRepository().add(acao));

    final dados = {
      'status': 'Seca',
      'dtSecagem': _dtSecagemTextController.text,
      'dtUltimoParto': '',
      'idStatusAnimal': 4,
    };
    final animalRepo = AnimalRepository();
    final entity = widget.uidAnimaisProdutores != null
        ? animalRepo.getByFirestoreId(widget.uidAnimaisProdutores!.id)
        : (widget.uidAnimalOffline != null &&
                widget.uidAnimalOffline!.isNotEmpty
            ? animalRepo.getByUidAnimalOffline(widget.uidAnimalOffline!)
            : null);
    if (entity != null) {
      unawaited(animalRepo.update(entity, dados));
    } else if (_outUidAnimaisAnimal != null) {
      unawaited(_outUidAnimaisAnimal!.reference
          .update(createAnimaisProdutoresRecordData(
        status: 'Seca',
        dtSecagem: _dtSecagemTextController.text,
        dtUltimoParto: '',
        idStatusAnimal: 4,
      )));
    }
  }

  Widget _conteudo(BuildContext context) {
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
            _cabecalho(context),
            _campoDataSecagem(context),
            _botoesAcao(context),
          ],
        ),
      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
    );
  }

  Widget _cabecalho(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 0.0, 0.0),
      child: Text(
        'Data secagem',
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

  Widget _campoDataSecagem(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                  child: TextFormField(
                    controller: _dtSecagemTextController,
                    focusNode: _dtSecagemFocusNode,
                    onChanged: (_) => EasyDebounce.debounce(
                      '_dtSecagemTextController',
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
                      labelStyle:
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
                      filled: true,
                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
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
                      contentPadding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 12.0, 16.0, 12.0),
                      suffixIcon: _dtSecagemTextController!.text.isNotEmpty
                          ? InkWell(
                              onTap: () async {
                                _dtSecagemTextController?.clear();
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
                    validator:
                        _dtSecagemTextControllerValidator.asValidator(context),
                    inputFormatters: [_dtSecagemMask],
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
                                minimumDate:
                                    (widget.dtSecPrevista ?? DateTime.now()),
                                initialDateTime:
                                    (widget.dtSecPrevista ?? DateTime.now()),
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
                    _dtSecagemTextController?.text = dateTimeFormat(
                      "dd/MM/yyyy",
                      _datePicked,
                      locale: FFLocalizations.of(context).languageCode,
                    );
                    _dtSecagemMask.updateMask(
                      newValue: TextEditingValue(
                        text: _dtSecagemTextController!.text,
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

  Widget _botoesAcao(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 24.0),
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
                if (_dtSecagemTextController.text == '') {
                  await showDialog(
                    context: context,
                    builder: (alertDialogContext) {
                      return AlertDialog(
                        title: Text('Data da secagem vazia.'),
                        content: Text('Selecione uma data.'),
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

                // Offline-first: grava a ação 'Secagem' e atualiza o
                // status do animal ('Seca') no ObjectBox; o sync com o
                // Firestore é enfileirado pelos repositórios.
                await _registrarSecagemOfflineFirst();
                _shouldSetState = true;

                // Bookkeeping de visita/tratamento/recomendação roda
                // só online — offline a variante original também o omite
                // (evita travar em queries sem rede).
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
                      tipoAcao: 'Secagem',
                      uidResumoDaVisita: _outUidResumoDaVisita?.reference,
                      observacaoAcao: _dtSecagemTextController.text,
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
                            isEqualTo: 'Secagem',
                          ),
                      singleRecord: true,
                    ).then((s) => s.firstOrNull);
                    _shouldSetState = true;
                    if (_outUidRecomendacoes?.reference == null) {
                      await RecomendacoesRecord.createDoc(
                              _outUidResumoDaVisita!.reference)
                          .set(createRecomendacoesRecordData(
                        tituloRecomendacao: 'Secagem',
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
                      tipoAcao: 'Secagem',
                      uidResumoDaVisita: _outNewUidResumoDaVisita?.reference,
                      observacaoAcao: _dtSecagemTextController.text,
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
                            isEqualTo: 'Secagem',
                          ),
                      singleRecord: true,
                    ).then((s) => s.firstOrNull);
                    _shouldSetState = true;
                    if (_outUidRecomendacoes2?.reference == null) {
                      await RecomendacoesRecord.createDoc(
                              _outNewUidResumoDaVisita!.reference)
                          .set(createRecomendacoesRecordData(
                        tituloRecomendacao: 'Secagem',
                        uidResumoDaVisita: _outNewUidResumoDaVisita?.reference,
                      ));
                    }
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
          _conteudo(context),
        ],
      ),
    );
  }
}
