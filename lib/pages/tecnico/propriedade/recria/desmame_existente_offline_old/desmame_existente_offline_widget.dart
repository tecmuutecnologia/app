import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'desmame_existente_offline_model.dart';
export 'desmame_existente_offline_model.dart';

class DesmameExistenteOfflineWidget extends StatefulWidget {
  const DesmameExistenteOfflineWidget({
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
  final String? brincoAnimal;
  final String? grupoAnimal;
  final int? itemUidIndex;

  @override
  State<DesmameExistenteOfflineWidget> createState() =>
      _DesmameExistenteOfflineWidgetState();
}

class _DesmameExistenteOfflineWidgetState
    extends State<DesmameExistenteOfflineWidget> with TickerProviderStateMixin {
  late DesmameExistenteOfflineModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DesmameExistenteOfflineModel());

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
                      'Desmame',
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
                            24.0, 16.0, 16.0, 0.0),
                        child: Text(
                          'Deseja realmente realizar o desmame deste animal? O mesmo passará a ser um boi ou novilha.',
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
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
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
                              if (widget.grupoAnimal == 'Bezerras') {
                                FFAppState()
                                    .updateAnimaisProdutoresOfflineAtIndex(
                                  widget.itemUidIndex!,
                                  (e) => e
                                    ..grupoAnimal = 'Novilhas'
                                    ..dtDesmame = getCurrentTimestamp
                                    ..status = 'Vazia',
                                );
                                safeSetState(() {});
                                FFAppState().addToAnimaisProdutoresEditados(
                                    AnimaisProdutoresStruct(
                                  uidTecnicoPropriedade: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.uidTecnicoPropriedade,
                                  nomeAnimal: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.nomeAnimal,
                                  racaAnimal: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.racaAnimal,
                                  pesoAnimal: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.pesoAnimal,
                                  dtNascimento: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtNascimento,
                                  touro: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.touro,
                                  vaca: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.vaca,
                                  status: 'Vazia',
                                  grupoAnimal: 'Novilhas',
                                  dtUltimaInseminacao: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtUltimaInseminacao,
                                  dtUltimoParto: FFAppState()
                                                  .animaisProdutoresExistentes
                                                  .elementAtOrNull(
                                                      widget.itemUidIndex!)
                                                  ?.dtUltimoParto !=
                                              null &&
                                          FFAppState()
                                                  .animaisProdutoresExistentes
                                                  .elementAtOrNull(
                                                      widget.itemUidIndex!)
                                                  ?.dtUltimoParto !=
                                              ''
                                      ? FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtUltimoParto
                                      : dateTimeFormat(
                                          "dd/MM/yyyy",
                                          getCurrentTimestamp,
                                          locale: FFLocalizations.of(context)
                                              .languageCode,
                                        ),
                                  liberaInseminacao: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.liberaInseminacao,
                                  dtPartoPrevisto: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtPartoPrevisto,
                                  dtSecPrevista: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtSecPrevista,
                                  dtPrePartoPrevista: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtPrePartoPrevista,
                                  dtPP: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtPP,
                                  dtDgMais: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtDgMais,
                                  dtDgMenos: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtDgMenos,
                                  dtAborto: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtAborto,
                                  dtSecagem: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtSecagem,
                                  dtUltimoPP: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtUltimoPP,
                                  nomeTouroUltimaInseminacao: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.nomeTouroUltimaInseminacao,
                                  totalInseminacoes: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.totalInseminacoes,
                                  totalPartos: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.totalPartos,
                                  dtPreParto: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtPreParto,
                                  motivoDescarteAnimal: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.motivoDescarteAnimal,
                                  dtDescarteAnimal: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtDescarteAnimal,
                                  dtUltimaAcao: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtUltimaAcao,
                                  compararDtUltimaInseminacao: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.compararDtUltimaInseminacao,
                                  nomeBrincoConcat: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.nomeBrincoConcat,
                                  idGrupoAnimal: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.idGrupoAnimal,
                                  dtUltimoPartoContingencia: FFAppState()
                                                  .animaisProdutoresExistentes
                                                  .elementAtOrNull(
                                                      widget.itemUidIndex!)
                                                  ?.dtUltimoParto !=
                                              null &&
                                          FFAppState()
                                                  .animaisProdutoresExistentes
                                                  .elementAtOrNull(
                                                      widget.itemUidIndex!)
                                                  ?.dtUltimoParto !=
                                              ''
                                      ? FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtUltimoParto
                                      : dateTimeFormat(
                                          "dd/MM/yyyy",
                                          getCurrentTimestamp,
                                          locale: FFLocalizations.of(context)
                                              .languageCode,
                                        ),
                                  idStatusAnimal: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.idStatusAnimal,
                                  dtInducaoLactacao: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtInducaoLactacao,
                                  dtDesmame: getCurrentTimestamp,
                                  brincoAnimal: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.brincoAnimal,
                                  brincoAnimalOrder: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.brincoAnimalOrder,
                                  uidAnimal: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.uidAnimal,
                                  uidAnimalOffline: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.uidAnimalOffline,
                                ));
                                safeSetState(() {});
                              } else {
                                FFAppState()
                                    .updateAnimaisProdutoresExistentesAtIndex(
                                  widget.itemUidIndex!,
                                  (e) => e
                                    ..grupoAnimal = 'Touros'
                                    ..dtDesmame = getCurrentTimestamp
                                    ..liberaInseminacao = false,
                                );
                                safeSetState(() {});
                                FFAppState().addToAnimaisProdutoresEditados(
                                    AnimaisProdutoresStruct(
                                  uidTecnicoPropriedade: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.uidTecnicoPropriedade,
                                  nomeAnimal: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.nomeAnimal,
                                  racaAnimal: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.racaAnimal,
                                  pesoAnimal: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.pesoAnimal,
                                  dtNascimento: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtNascimento,
                                  touro: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.touro,
                                  vaca: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.vaca,
                                  status: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.status,
                                  grupoAnimal: 'Touros',
                                  dtUltimaInseminacao: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtUltimaInseminacao,
                                  dtUltimoParto: FFAppState()
                                                  .animaisProdutoresExistentes
                                                  .elementAtOrNull(
                                                      widget.itemUidIndex!)
                                                  ?.dtUltimoParto !=
                                              null &&
                                          FFAppState()
                                                  .animaisProdutoresExistentes
                                                  .elementAtOrNull(
                                                      widget.itemUidIndex!)
                                                  ?.dtUltimoParto !=
                                              ''
                                      ? FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtUltimoParto
                                      : dateTimeFormat(
                                          "dd/MM/yyyy",
                                          getCurrentTimestamp,
                                          locale: FFLocalizations.of(context)
                                              .languageCode,
                                        ),
                                  liberaInseminacao: false,
                                  dtPartoPrevisto: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtPartoPrevisto,
                                  dtSecPrevista: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtSecPrevista,
                                  dtPrePartoPrevista: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtPrePartoPrevista,
                                  dtPP: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtPP,
                                  dtDgMais: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtDgMais,
                                  dtDgMenos: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtDgMenos,
                                  dtAborto: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtAborto,
                                  dtSecagem: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtSecagem,
                                  dtUltimoPP: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtUltimoPP,
                                  nomeTouroUltimaInseminacao: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.nomeTouroUltimaInseminacao,
                                  totalInseminacoes: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.totalInseminacoes,
                                  totalPartos: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.totalPartos,
                                  dtPreParto: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtPreParto,
                                  motivoDescarteAnimal: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.motivoDescarteAnimal,
                                  dtDescarteAnimal: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtDescarteAnimal,
                                  dtUltimaAcao: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtUltimaAcao,
                                  compararDtUltimaInseminacao: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.compararDtUltimaInseminacao,
                                  nomeBrincoConcat: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.nomeBrincoConcat,
                                  idGrupoAnimal: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.idGrupoAnimal,
                                  dtUltimoPartoContingencia: FFAppState()
                                                  .animaisProdutoresExistentes
                                                  .elementAtOrNull(
                                                      widget.itemUidIndex!)
                                                  ?.dtUltimoParto !=
                                              null &&
                                          FFAppState()
                                                  .animaisProdutoresExistentes
                                                  .elementAtOrNull(
                                                      widget.itemUidIndex!)
                                                  ?.dtUltimoParto !=
                                              ''
                                      ? FFAppState()
                                          .animaisProdutoresExistentes
                                          .elementAtOrNull(
                                              widget.itemUidIndex!)
                                          ?.dtUltimoParto
                                      : dateTimeFormat(
                                          "dd/MM/yyyy",
                                          getCurrentTimestamp,
                                          locale: FFLocalizations.of(context)
                                              .languageCode,
                                        ),
                                  idStatusAnimal: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.idStatusAnimal,
                                  dtInducaoLactacao: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.dtInducaoLactacao,
                                  dtDesmame: getCurrentTimestamp,
                                  brincoAnimal: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.brincoAnimal,
                                  brincoAnimalOrder: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.brincoAnimalOrder,
                                  uidAnimal: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.uidAnimal,
                                  uidAnimalOffline: FFAppState()
                                      .animaisProdutoresExistentes
                                      .elementAtOrNull(widget.itemUidIndex!)
                                      ?.uidAnimalOffline,
                                ));
                                safeSetState(() {});
                              }

                              Navigator.pop(context);
                            },
                            text: 'Desmamar',
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
