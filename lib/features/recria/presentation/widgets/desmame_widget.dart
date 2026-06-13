import '/backend/backend.dart';
import '/domain/animais/classificacao_animal.dart';
import '/backend/objectbox/repositories/animal_repository.dart';
import 'dart:async';
import '/core/ui/flutter_flow_animations.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// Modo de operação do widget de desmame
enum DesmameMode {
  /// Online - salva direto no Firestore
  online,

  /// Offline para animais novos criados localmente
  offlineNew,
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
  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();

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
    }
  }

  /// Desmame offline-first - grava no ObjectBox (fonte única) e delega o sync
  /// com o Firestore ao repositório. Funciona com ou sem conexão (usado tanto
  /// para o caso online quanto para o de animal existente offline).
  Future<void> _performOnlineDesmame() async {
    final dados = ehBezerras(widget.grupoAnimal)
        ? <String, dynamic>{
            'grupoAnimal': 'Novilhas',
            'dtDesmame': getCurrentTimestamp,
            'status': 'Vazia',
          }
        : <String, dynamic>{
            'grupoAnimal': 'Touros',
            'dtDesmame': getCurrentTimestamp,
            'liberaInseminacao': false,
          };
    final animalRepo = AnimalRepository();
    final entity = widget.uidAnimaisProdutores != null
        ? animalRepo.getByFirestoreId(widget.uidAnimaisProdutores!.id)
        : null;
    if (entity != null) {
      unawaited(animalRepo.update(entity, dados));
    } else if (widget.uidAnimaisProdutores != null) {
      unawaited(widget.uidAnimaisProdutores!.update(
        ehBezerras(widget.grupoAnimal)
            ? createAnimaisProdutoresRecordData(
                grupoAnimal: 'Novilhas',
                dtDesmame: getCurrentTimestamp,
                status: 'Vazia',
              )
            : createAnimaisProdutoresRecordData(
                grupoAnimal: 'Touros',
                dtDesmame: getCurrentTimestamp,
                liberaInseminacao: false,
              ),
      ));
    }
  }

  /// Desmame offline para animais novos
  void _performOfflineNewDesmame() {
    // Animal criado offline: aplica o desmame no ObjectBox via AnimalRepository
    // (localizado por uidAnimalOffline). Persiste e sincroniza ao reconectar —
    // antes ia para o array animaisProdutoresOffline (órfão sem o sincronizar).
    final dados = ehBezerras(widget.grupoAnimal)
        ? <String, dynamic>{
            'grupoAnimal': 'Novilhas',
            'dtDesmame': getCurrentTimestamp,
            'status': 'Vazia',
          }
        : <String, dynamic>{
            'grupoAnimal': 'Touros',
            'dtDesmame': getCurrentTimestamp,
            'liberaInseminacao': false,
          };
    final animalRepo = AnimalRepository();
    final entity = (widget.uidAnimalOffline ?? '').isNotEmpty
        ? animalRepo.getByUidAnimalOffline(widget.uidAnimalOffline!)
        : null;
    if (entity != null) {
      unawaited(animalRepo.update(entity, dados));
    }
    safeSetState(() {});
  }
}
