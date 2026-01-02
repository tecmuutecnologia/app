import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'registrar_parto_induzido_existente_offline_model.dart';
export 'registrar_parto_induzido_existente_offline_model.dart';

class RegistrarPartoInduzidoExistenteOfflineWidget extends StatefulWidget {
  const RegistrarPartoInduzidoExistenteOfflineWidget({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.diasDg,
    required this.uidAnimaisProdutores,
    required this.nomeAnimal,
    required this.itemUidIndex,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? diasDg;
  final DocumentReference? uidAnimaisProdutores;
  final String? nomeAnimal;
  final int? itemUidIndex;

  @override
  State<RegistrarPartoInduzidoExistenteOfflineWidget> createState() =>
      _RegistrarPartoInduzidoExistenteOfflineWidgetState();
}

class _RegistrarPartoInduzidoExistenteOfflineWidgetState
    extends State<RegistrarPartoInduzidoExistenteOfflineWidget>
    with TickerProviderStateMixin {
  late RegistrarPartoInduzidoExistenteOfflineModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(
        context, () => RegistrarPartoInduzidoExistenteOfflineModel());

    _model.dtPartoInduzidoTextController ??= TextEditingController();
    _model.dtPartoInduzidoFocusNode ??= FocusNode();

    _model.dtPartoInduzidoMask = MaskTextInputFormatter(mask: '##/##/####');
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
          _model.dtPartoInduzidoTextController?.text = dateTimeFormat(
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
      child: SingleChildScrollView(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 16.0, 0.0, 0.0),
                        child: Text(
                          valueOrDefault<String>(
                            widget.nomeAnimal,
                            'Animal',
                          ),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 16.0, 0.0),
                                    child: TextFormField(
                                      controller:
                                          _model.dtPartoInduzidoTextController,
                                      focusNode:
                                          _model.dtPartoInduzidoFocusNode,
                                      autofocus: false,
                                      readOnly: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Data parto induzido*',
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
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        contentPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                20.0, 24.0, 20.0, 24.0),
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
                                      maxLength: 10,
                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.enforced,
                                      buildCounter: (context,
                                              {required currentLength,
                                              required isFocused,
                                              maxLength}) =>
                                          null,
                                      keyboardType: TextInputType.datetime,
                                      cursorColor:
                                          FlutterFlowTheme.of(context).primary,
                                      validator: _model
                                          .dtPartoInduzidoTextControllerValidator
                                          .asValidator(context),
                                      inputFormatters: [
                                        _model.dtPartoInduzidoMask
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              child: CupertinoTheme(
                                                data: _datePickedCupertinoTheme
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
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight: FlutterFlowTheme
                                                                      .of(context)
                                                                  .headlineMedium
                                                                  .fontWeight,
                                                              fontStyle: FlutterFlowTheme
                                                                      .of(context)
                                                                  .headlineMedium
                                                                  .fontStyle,
                                                            ),
                                                  ),
                                                ),
                                                child: CupertinoDatePicker(
                                                  mode: CupertinoDatePickerMode
                                                      .date,
                                                  minimumDate: DateTime(1900),
                                                  initialDateTime: functions
                                                      .obterDataAtualFormat(),
                                                  maximumDate: (functions
                                                          .obterDataAtualFormat() ??
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
                                      _model.dtPartoInduzidoTextController
                                          ?.text = dateTimeFormat(
                                        "dd/MM/yyyy",
                                        _model.datePicked,
                                        locale: FFLocalizations.of(context)
                                            .languageCode,
                                      );
                                      _model.dtPartoInduzidoMask.updateMask(
                                        newValue: TextEditingValue(
                                          text: _model
                                              .dtPartoInduzidoTextController!
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
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 12.0, 24.0, 24.0),
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
                                  elevation: 0.0,
                                  borderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                  hoverColor:
                                      FlutterFlowTheme.of(context).alternate,
                                  hoverBorderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
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
                                  if (_model.dtPartoInduzidoTextController
                                              .text !=
                                          '') {
                                    FFAppState()
                                        .updateAnimaisProdutoresExistentesAtIndex(
                                      widget.itemUidIndex!,
                                      (e) => e
                                        ..dtUltimoParto = _model
                                            .dtPartoInduzidoTextController.text
                                        ..dtUltimoPartoContingencia = _model
                                            .dtPartoInduzidoTextController.text
                                        ..incrementTotalPartos(1)
                                        ..dtPartoPrevisto = null
                                        ..dtPrePartoPrevista = null
                                        ..dtSecagem = null
                                        ..dtSecPrevista = null
                                        ..grupoAnimal = 'Vacas'
                                        ..status = 'Vazia'
                                        ..idStatusAnimal = 2
                                        ..dtInducaoLactacao = null,
                                    );
                                    safeSetState(() {});
                                    FFAppState().addToAnimaisProdutoresEditados(
                                        AnimaisProdutoresStruct(
                                      uidTecnicoPropriedade: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.uidTecnicoPropriedade,
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
                                      status: 'Vazia',
                                      grupoAnimal: 'Vacas',
                                      dtUltimaInseminacao: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtUltimaInseminacao,
                                      dtUltimoParto: _model
                                          .dtPartoInduzidoTextController.text,
                                      liberaInseminacao: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.liberaInseminacao,
                                      dtPartoPrevisto: '0',
                                      dtSecPrevista: '0',
                                      dtPrePartoPrevista: '0',
                                      dtPP: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtPP,
                                      dtDgMais: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtDgMais,
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
                                      dtUltimoPP: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtUltimoPP,
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
                                                  widget.itemUidIndex!)!
                                              .totalPartos +
                                          1,
                                      dtPreParto: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.totalPartos
                                          .toString(),
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
                                      dtUltimaAcao: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtUltimaAcao,
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
                                      dtUltimoPartoContingencia: _model
                                          .dtPartoInduzidoTextController.text,
                                      idStatusAnimal: 2,
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
                                      uidAnimalOffline: FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.uidAnimalOffline,
                                    ));
                                    safeSetState(() {});
                                    Navigator.pop(context);
                                    return;
                                  } else {
                                    await showDialog(
                                      context: context,
                                      builder: (alertDialogContext) {
                                        return AlertDialog(
                                          title: Text(
                                              'Selecione uma data para salvar.'),
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
                                    return;
                                  }
                                },
                                text: 'Salvar',
                                icon: Icon(
                                  Icons.check_circle_outline_sharp,
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
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
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
                                  hoverColor:
                                      FlutterFlowTheme.of(context).accent1,
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
                ),
              ).animateOnPageLoad(
                  animationsMap['containerOnPageLoadAnimation']!),
            ),
          ],
        ),
      ),
    );
  }
}
