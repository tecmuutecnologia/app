// ignore_for_file: dead_code, dead_null_aware_expression
import '/data/backend.dart';
import '/core/ui/app_card.dart';
import '/data/objectbox/index.dart';
import 'dart:async';
import '/core/ui/flutter_flow_animations.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ConfirmaPpWidget extends StatefulWidget {
  const ConfirmaPpWidget({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.uidAnimaisProdutores,
    this.uidAnimalOffline,
    required this.grupoPredominante,
    required this.nomeAnimal,
    required this.visitaPresencial,
    required this.diasDg,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final DocumentReference? uidAnimaisProdutores;

  /// Identidade local do animal criado OFFLINE (sem firestoreId no Firestore).
  /// Para esses, [uidAnimaisProdutores] e null; a acao guarda este id e o
  /// vinculo e resolvido pela cascata quando o animal sincroniza (E3p2).
  final String? uidAnimalOffline;
  final String? grupoPredominante;
  final String? nomeAnimal;
  final bool? visitaPresencial;
  final String? diasDg;

  @override
  State<ConfirmaPpWidget> createState() => _ConfirmaPpWidgetState();
}

class _ConfirmaPpWidgetState extends State<ConfirmaPpWidget>
    with TickerProviderStateMixin {
  final animationsMap = <String, AnimationInfo>{};

  AnimaisProdutoresRecord? _outUidAnimaisAnimal;
  FocusNode? _dtPPFocusNode;
  TextEditingController? _dtPPTextController;
  late MaskTextInputFormatter _dtPPMask;
  final String? Function(BuildContext, String?)? _dtPPTextControllerValidator =
      null;
  DateTime? _datePicked;

  @override
  void initState() {
    super.initState();

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _outUidAnimaisAnimal = await AnimaisProdutoresRecord.getDocumentOnce(
          widget.uidAnimaisProdutores!);
    });

    _dtPPTextController ??= TextEditingController();
    _dtPPFocusNode ??= FocusNode();

    _dtPPMask = MaskTextInputFormatter(mask: '##/##/####');
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
          _dtPPTextController?.text = dateTimeFormat(
            "dd/MM/yyyy",
            getCurrentTimestamp,
            locale: FFLocalizations.of(context).languageCode,
          );
        }));
  }

  @override
  void dispose() {
    _dtPPFocusNode?.dispose();
    _dtPPTextController?.dispose();

    super.dispose();
  }

  /// Registra a confirmação de PP offline-first: cria a ação 'PP' via
  /// AcaoRepository e atualiza o animal (Inseminada PP) via AnimalRepository,
  /// sem bloquear a UI.
  Future<void> _confirmaPpOfflineFirst() async {
    final hoje = dateTimeFormat('dd/MM/yyyy', getCurrentTimestamp,
        locale: FFLocalizations.of(context).languageCode);
    final acao = AcaoEntity(
      parentPath: widget.uidTecnico!.path,
      uidAnimalAnimaisProdutoresPath: widget.uidAnimaisProdutores?.path,
      uidAnimalOffline:
          widget.uidAnimaisProdutores == null ? widget.uidAnimalOffline : null,
      nomeAnimal: widget.nomeAnimal,
      acao: 'PP',
      dataVisita: hoje,
      dataDaAcao: getCurrentTimestamp,
      dtPP: _dtPPTextController.text,
    );
    unawaited(AcaoRepository().add(acao));

    final dados = <String, dynamic>{
      'status': 'Inseminada PP',
      'dtPP': _dtPPTextController.text,
      'dtUltimoPP': hoje,
      'idStatusAnimal': 1,
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
      unawaited(_outUidAnimaisAnimal!.reference.update(
          createAnimaisProdutoresRecordData(
              status: 'Inseminada PP',
              dtPP: _dtPPTextController.text,
              dtUltimoPP: hoje,
              idStatusAnimal: 1)));
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
        'Data prenhes',
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
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                  child: TextFormField(
                    controller: _dtPPTextController,
                    focusNode: _dtPPFocusNode,
                    onChanged: (_) => EasyDebounce.debounce(
                      '_dtPPTextController',
                      Duration(milliseconds: 2000),
                      () => safeSetState(() {}),
                    ),
                    autofocus: false,
                    textCapitalization: TextCapitalization.none,
                    textInputAction: TextInputAction.next,
                    readOnly: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Data da PP (prenhes)',
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
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppTokens.secondary,
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
                      contentPadding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 12.0, 16.0, 12.0),
                      suffixIcon: _dtPPTextController!.text.isNotEmpty
                          ? InkWell(
                              onTap: () async {
                                _dtPPTextController?.clear();
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
                        _dtPPTextControllerValidator.asValidator(context),
                    inputFormatters: [_dtPPMask],
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
                    _dtPPTextController?.text = dateTimeFormat(
                      "dd/MM/yyyy",
                      _datePicked,
                      locale: FFLocalizations.of(context).languageCode,
                    );
                    _dtPPMask.updateMask(
                      newValue: TextEditingValue(
                        text: _dtPPTextController!.text,
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
                if (_dtPPTextController.text != '') {
                  await _confirmaPpOfflineFirst();
                  _shouldSetState = true;
                } else {
                  await showDialog(
                    context: context,
                    builder: (alertDialogContext) {
                      return AlertDialog(
                        title: Text('Data da prenhes vazia.'),
                        content: Text('Selecione uma data'),
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

                Navigator.pop(context);
                if (_shouldSetState) safeSetState(() {});
              },
              text: 'PP',
              icon: Icon(
                Icons.check,
                size: 15.0,
              ),
              options: FFButtonOptions(
                height: 44.0,
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: Color(0xFF1A03E9),
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
