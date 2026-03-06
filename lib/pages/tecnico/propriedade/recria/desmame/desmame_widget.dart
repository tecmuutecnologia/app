import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'desmame_model.dart';
export 'desmame_model.dart';

/// Modo de operação do widget de desmame
enum DesmameMode {
  /// Online - salva direto no Firestore
  online,

  /// Offline para animais novos criados localmente
  offlineNew,

  /// Offline para animais existentes que precisam de sincronização
  offlineExisting,
}

/// Widget para desmame de animais
/// Suporta modos: online, offlineNew, offlineExisting
class DesmameWidget extends StatefulWidget {
  const DesmameWidget({
    super.key,
    required this.mode,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.diasDg,
    required this.nomeAnimal,
    required this.brincoAnimal,
    required this.grupoAnimal,
    // Parâmetros condicionais baseados no modo
    this.uidAnimaisProdutores, // Online e OfflineExisting
    this.uidAnimalOffline, // OfflineNew
    this.itemUidIndex, // OfflineNew e OfflineExisting
  });

  final DesmameMode mode;
  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? diasDg;
  final String? nomeAnimal;
  final String? brincoAnimal;
  final String? grupoAnimal;

  // Parâmetros condicionais
  final DocumentReference? uidAnimaisProdutores;
  final String? uidAnimalOffline;
  final int? itemUidIndex;

  @override
  State<DesmameWidget> createState() => _DesmameWidgetState();
}

class _DesmameWidgetState extends State<DesmameWidget>
    with TickerProviderStateMixin {
  late DesmameModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DesmameModel());

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
    // Observa FFAppState apenas para modos offline
    if (widget.mode != DesmameMode.online) {
      context.watch<FFAppState>();
    }

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
                    offset: Offset(0.0, 5.0),
                  )
                ],
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(context),
                  _buildDescription(context),
                  _buildButtons(context),
                ],
              ),
            ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 0.0, 0.0),
      child: Text(
        'Desmame',
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

  Widget _buildDescription(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 16.0, 0.0),
          child: Text(
            'Deseja realmente realizar o desmame deste animal? O mesmo passará a ser um boi ou novilha.',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  fontSize: 16.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 24.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCancelButton(context),
          _buildConfirmButton(context),
        ],
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
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

  Widget _buildConfirmButton(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.05),
      child: FFButtonWidget(
        onPressed: () async {
          await _performDesmame(context);
          Navigator.pop(context);
        },
        text: 'Desmamar',
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

  /// Executa o desmame baseado no modo
  Future<void> _performDesmame(BuildContext context) async {
    switch (widget.mode) {
      case DesmameMode.online:
        await _performOnlineDesmame();
        break;
      case DesmameMode.offlineNew:
        _performOfflineNewDesmame();
        break;
      case DesmameMode.offlineExisting:
        _performOfflineExistingDesmame(context);
        break;
    }
  }

  /// Desmame online - salva direto no Firestore
  Future<void> _performOnlineDesmame() async {
    if (widget.grupoAnimal == 'Bezerras') {
      await widget.uidAnimaisProdutores!
          .update(createAnimaisProdutoresRecordData(
        grupoAnimal: 'Novilhas',
        dtDesmame: getCurrentTimestamp,
        status: 'Vazia',
      ));
    } else {
      await widget.uidAnimaisProdutores!
          .update(createAnimaisProdutoresRecordData(
        grupoAnimal: 'Touros',
        dtDesmame: getCurrentTimestamp,
        liberaInseminacao: false,
      ));
    }
  }

  /// Desmame offline para animais novos
  void _performOfflineNewDesmame() {
    if (widget.grupoAnimal == 'Bezerras') {
      FFAppState().updateAnimaisProdutoresOfflineAtIndex(
        widget.itemUidIndex!,
        (e) => e
          ..grupoAnimal = 'Novilhas'
          ..dtDesmame = getCurrentTimestamp
          ..status = 'Vazia',
      );
    } else {
      FFAppState().updateAnimaisProdutoresOfflineAtIndex(
        widget.itemUidIndex!,
        (e) => e
          ..grupoAnimal = 'Touros'
          ..dtDesmame = getCurrentTimestamp
          ..liberaInseminacao = false,
      );
    }
    safeSetState(() {});
  }

  /// Desmame offline para animais existentes - atualiza local e adiciona a editados
  void _performOfflineExistingDesmame(BuildContext context) {
    final index = widget.itemUidIndex!;
    final existingAnimal =
        FFAppState().animaisProdutoresExistentes.elementAtOrNull(index);

    if (existingAnimal == null) return;

    if (widget.grupoAnimal == 'Bezerras') {
      // Atualiza no local
      FFAppState().updateAnimaisProdutoresOfflineAtIndex(
        index,
        (e) => e
          ..grupoAnimal = 'Novilhas'
          ..dtDesmame = getCurrentTimestamp
          ..status = 'Vazia',
      );
      safeSetState(() {});

      // Adiciona aos editados para sincronização
      FFAppState().addToAnimaisProdutoresEditados(
        _createEditedAnimalStruct(
          existingAnimal,
          grupoAnimal: 'Novilhas',
          status: 'Vazia',
          context: context,
        ),
      );
    } else {
      // Atualiza no local
      FFAppState().updateAnimaisProdutoresExistentesAtIndex(
        index,
        (e) => e
          ..grupoAnimal = 'Touros'
          ..dtDesmame = getCurrentTimestamp
          ..liberaInseminacao = false,
      );
      safeSetState(() {});

      // Adiciona aos editados para sincronização
      FFAppState().addToAnimaisProdutoresEditados(
        _createEditedAnimalStruct(
          existingAnimal,
          grupoAnimal: 'Touros',
          liberaInseminacao: false,
          context: context,
        ),
      );
    }
    safeSetState(() {});
  }

  /// Cria struct do animal editado para sincronização
  AnimaisProdutoresStruct _createEditedAnimalStruct(
    AnimaisProdutoresStruct existingAnimal, {
    required String grupoAnimal,
    String? status,
    bool? liberaInseminacao,
    required BuildContext context,
  }) {
    final dtUltimoParto = existingAnimal.dtUltimoParto.isNotEmpty
        ? existingAnimal.dtUltimoParto
        : dateTimeFormat(
            "dd/MM/yyyy",
            getCurrentTimestamp,
            locale: FFLocalizations.of(context).languageCode,
          );

    return AnimaisProdutoresStruct(
      uidTecnicoPropriedade: existingAnimal.uidTecnicoPropriedade,
      nomeAnimal: existingAnimal.nomeAnimal,
      racaAnimal: existingAnimal.racaAnimal,
      pesoAnimal: existingAnimal.pesoAnimal,
      dtNascimento: existingAnimal.dtNascimento,
      touro: existingAnimal.touro,
      vaca: existingAnimal.vaca,
      status: status ?? existingAnimal.status,
      grupoAnimal: grupoAnimal,
      dtUltimaInseminacao: existingAnimal.dtUltimaInseminacao,
      dtUltimoParto: dtUltimoParto,
      liberaInseminacao: liberaInseminacao ?? existingAnimal.liberaInseminacao,
      dtPartoPrevisto: existingAnimal.dtPartoPrevisto,
      dtSecPrevista: existingAnimal.dtSecPrevista,
      dtPrePartoPrevista: existingAnimal.dtPrePartoPrevista,
      dtPP: existingAnimal.dtPP,
      dtDgMais: existingAnimal.dtDgMais,
      dtDgMenos: existingAnimal.dtDgMenos,
      dtAborto: existingAnimal.dtAborto,
      dtSecagem: existingAnimal.dtSecagem,
      dtUltimoPP: existingAnimal.dtUltimoPP,
      nomeTouroUltimaInseminacao: existingAnimal.nomeTouroUltimaInseminacao,
      totalInseminacoes: existingAnimal.totalInseminacoes,
      totalPartos: existingAnimal.totalPartos,
      dtPreParto: existingAnimal.dtPreParto,
      motivoDescarteAnimal: existingAnimal.motivoDescarteAnimal,
      dtDescarteAnimal: existingAnimal.dtDescarteAnimal,
      dtUltimaAcao: existingAnimal.dtUltimaAcao,
      compararDtUltimaInseminacao: existingAnimal.compararDtUltimaInseminacao,
      nomeBrincoConcat: existingAnimal.nomeBrincoConcat,
      idGrupoAnimal: existingAnimal.idGrupoAnimal,
      dtUltimoPartoContingencia: dtUltimoParto,
      idStatusAnimal: existingAnimal.idStatusAnimal,
      dtInducaoLactacao: existingAnimal.dtInducaoLactacao,
      dtDesmame: getCurrentTimestamp,
      brincoAnimal: existingAnimal.brincoAnimal,
      brincoAnimalOrder: existingAnimal.brincoAnimalOrder,
      uidAnimal: existingAnimal.uidAnimal,
      uidAnimalOffline: existingAnimal.uidAnimalOffline,
    );
  }
}
