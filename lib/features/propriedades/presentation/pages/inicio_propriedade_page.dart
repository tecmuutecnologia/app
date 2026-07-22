// ignore_for_file: unused_import, unused_local_variable

import '/core/auth/firebase_auth/auth_util.dart';
import '/domain/animais/classificacao_animal.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/features/animais/application/animais_providers.dart';
import '/data/objectbox/entities/index.dart';
import '/data/backend.dart';
import '/core/ui/flutter_flow_animations.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/app_card.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/instant_timer.dart';
import '/core/ui/request_manager.dart';
import '/features/sincronizacao/presentation/widgets/alerta_sem_internet_widget.dart';
import '/core/services/index.dart' as actions;
import '/core/ui/custom_functions.dart' as functions;
import '/features/animais/presentation/pages/lista_animais_page.dart';
import '/features/calendario_sanitario/presentation/pages/calendario_sanitario_page.dart';
import '/features/dashboard/presentation/pages/dashboard_tecnico_page.dart';
import '/features/diagnostico_gestacao/presentation/pages/diagnosticogestacao_page.dart';
import '/features/exame_ginecologico/presentation/pages/exame_ginecologico_page.dart';
import '/features/financeiro/presentation/pages/relatorio_financeiro_page.dart';
import '/features/inseminacoes/presentation/pages/lista_inseminacoes_page.dart';
import '/features/prenhas/presentation/pages/animais_prenhas_page.dart';
import '/features/propriedades/presentation/pages/editar_propriedade_page.dart';
import '/features/propriedades/presentation/pages/lista_propriedade_page.dart';
import '/features/receituario/presentation/pages/receituarios_lista_page.dart';
import '/features/recria/presentation/pages/recriacao_page.dart';
import '/features/relatorios/presentation/pages/indices_zootecnicos_page.dart';
import '/features/relatorios/presentation/pages/listacompleta_page.dart';
import '/features/relatorios/presentation/pages/resumo_rebanho_page.dart';
import '/features/secas/presentation/pages/secas_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class InicioPropriedadePage extends ConsumerStatefulWidget {
  const InicioPropriedadePage({
    super.key,
    required this.nomePropriedade,
    required this.uidPropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.diasDg,
    this.propriedadePendenteId,
  });

  final String? nomePropriedade;
  final DocumentReference? uidPropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? diasDg;

  /// Id LOCAL (ObjectBox) quando a propriedade está PENDENTE de ativação — usado
  /// para rotear a edição pela pendente (id local) em vez do docRef reservado.
  final int? propriedadePendenteId;

  static String routeName = 'inicioPropriedade';
  static String routePath = '/inicioPropriedade';

  @override
  ConsumerState<InicioPropriedadePage> createState() =>
      _InicioPropriedadePageState();
}

class _InicioPropriedadePageState extends ConsumerState<InicioPropriedadePage>
    with TickerProviderStateMixin {
  InstantTimer? _instantTimer;
  bool? _respostaNet = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _instantTimer = InstantTimer.periodic(
        duration: Duration(seconds: 5),
        callback: (timer) async {
          _respostaNet = await actions.checkInternetConnection();

          safeSetState(() {});
          if (_respostaNet!) {
            safeSetState(() {});
          } else {
            // Offline: notificação passiva via SyncStatusBanner (app-wide);
            // sem modal bloqueante nem flag global. O respostaNet acima já
            // atualiza a UI e o sync ao reconectar é automático.
          }
        },
        startImmediately: false,
      );
    });

    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation4': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation5': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation6': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation7': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation8': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation9': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation10': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation11': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation12': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation13': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation14': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation15': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation16': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
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
    _instantTimer?.cancel();

    super.dispose();
  }

  Widget _cabecalho(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 25.0, 0.0, 0.0),
      child: Text(
        'Menu de Ações',
        textAlign: TextAlign.start,
        style: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FontWeight.w600,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
      ),
    );
  }

  Widget _gradeMenu(BuildContext context,
      dynamic inicioPropriedadeAnimaisProdutoresRecordList) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: GridView(
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          // Altura de célula FIXA (não derivada da largura): o conteúdo dos
          // cards é de tamanho fixo (ícone + badge + label de até 2 linhas),
          // então uma altura constante cabe em qualquer largura de tela e
          // elimina o overflow que ocorria com childAspectRatio: 1.0 (célula
          // quadrada ~112px, menor que o conteúdo ~135px).
          mainAxisExtent: 156.0,
        ),
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          _cardInicio(context),
          _cardTrocarProdutor(context),
          _cardAnimais(context),
          _cardInseminacoes(
              context, inicioPropriedadeAnimaisProdutoresRecordList),
          _cardDiagnosticoGestacao(
              context, inicioPropriedadeAnimaisProdutoresRecordList),
          _cardPrenhas(context, inicioPropriedadeAnimaisProdutoresRecordList),
          _cardSecas(context, inicioPropriedadeAnimaisProdutoresRecordList),
          _cardExameGinecologico(
              context, inicioPropriedadeAnimaisProdutoresRecordList),
          _cardRecria(context, inicioPropriedadeAnimaisProdutoresRecordList),
          _cardListaCompleta(
              context, inicioPropriedadeAnimaisProdutoresRecordList),
          if (_respostaNet ?? true)
            Container(
              width: MediaQuery.sizeOf(context).width * 0.3,
              height: 120.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(18.0),
                boxShadow: AppTokens.softShadow(context),
              ),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  context.pushNamed(
                    ReceituariosListaPage.routeName,
                    queryParameters: {
                      'uidPropriedade': serializeParam(
                        widget.uidPropriedade,
                        ParamType.DocumentReference,
                      ),
                      'nomePropriedade': serializeParam(
                        widget.nomePropriedade,
                        ParamType.String,
                      ),
                      'uidTecnico': serializeParam(
                        widget.uidTecnico,
                        ParamType.DocumentReference,
                      ),
                      'emailPropriedade': serializeParam(
                        widget.emailPropriedade,
                        ParamType.String,
                      ),
                      'visitaPresencial': serializeParam(
                        widget.visitaPresencial,
                        ParamType.bool,
                      ),
                      'diasDg': serializeParam(
                        widget.diasDg,
                        ParamType.String,
                      ),
                    }.withoutNulls,
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.summarize,
                      color: Color(0xFFEC3B5B),
                      size: 30.0,
                    ),
                    _rotuloReceituario(context),
                  ],
                ),
              ),
            ).animateOnPageLoad(
                animationsMap['containerOnPageLoadAnimation11']!),
          if (_respostaNet ?? true)
            Container(
              width: MediaQuery.sizeOf(context).width * 0.3,
              height: 120.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(18.0),
                boxShadow: AppTokens.softShadow(context),
              ),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  context.pushNamed(
                    ResumoRebanhoPage.routeName,
                    queryParameters: {
                      'uidPropriedade': serializeParam(
                        widget.uidPropriedade,
                        ParamType.DocumentReference,
                      ),
                      'nomePropriedade': serializeParam(
                        widget.nomePropriedade,
                        ParamType.String,
                      ),
                      'uidTecnico': serializeParam(
                        widget.uidTecnico,
                        ParamType.DocumentReference,
                      ),
                      'emailPropriedade': serializeParam(
                        widget.emailPropriedade,
                        ParamType.String,
                      ),
                      'visitaPresencial': serializeParam(
                        widget.visitaPresencial,
                        ParamType.bool,
                      ),
                      'diasDg': serializeParam(
                        widget.diasDg,
                        ParamType.String,
                      ),
                    }.withoutNulls,
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.summarize_outlined,
                      color: Color(0xFFEC3B5B),
                      size: 30.0,
                    ),
                    _rotuloResumoRebanho(context),
                  ],
                ),
              ),
            ).animateOnPageLoad(
                animationsMap['containerOnPageLoadAnimation12']!),
          // Calendario sanitario agora le do ObjectBox (offline-first),
          // entao o card nao depende mais de conexao.
          Container(
            width: MediaQuery.sizeOf(context).width * 0.3,
            height: 120.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(18.0),
              boxShadow: AppTokens.softShadow(context),
            ),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                context.pushNamed(
                  CalendarioSanitarioPage.routeName,
                  queryParameters: {
                    'uidPropriedade': serializeParam(
                      widget.uidPropriedade,
                      ParamType.DocumentReference,
                    ),
                    'nomePropriedade': serializeParam(
                      widget.nomePropriedade,
                      ParamType.String,
                    ),
                    'uidTecnico': serializeParam(
                      widget.uidTecnico,
                      ParamType.DocumentReference,
                    ),
                    'emailPropriedade': serializeParam(
                      widget.emailPropriedade,
                      ParamType.String,
                    ),
                    'visitaPresencial': serializeParam(
                      widget.visitaPresencial,
                      ParamType.bool,
                    ),
                    'diasDg': serializeParam(
                      widget.diasDg,
                      ParamType.String,
                    ),
                  }.withoutNulls,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Color(0xFFEC3B5B),
                    size: 28.0,
                  ),
                  _rotuloCalendarioSanitario(context),
                ],
              ),
            ),
          ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation13']!),
          _cardIndicesZootecnicos(context),
          // Financeiro agora le do ObjectBox (offline-first), entao o card
          // nao depende mais de conexao.
          Container(
            width: MediaQuery.sizeOf(context).width * 0.3,
            height: 120.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(18.0),
              boxShadow: AppTokens.softShadow(context),
            ),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                context.pushNamed(
                  RelatorioFinanceiroPage.routeName,
                  queryParameters: {
                    'uidPropriedade': serializeParam(
                      widget.uidPropriedade,
                      ParamType.DocumentReference,
                    ),
                    'nomePropriedade': serializeParam(
                      widget.nomePropriedade,
                      ParamType.String,
                    ),
                    'uidTecnico': serializeParam(
                      widget.uidTecnico,
                      ParamType.DocumentReference,
                    ),
                    'emailPropriedade': serializeParam(
                      widget.emailPropriedade,
                      ParamType.String,
                    ),
                    'visitaPresencial': serializeParam(
                      widget.visitaPresencial,
                      ParamType.bool,
                    ),
                    'diasDg': serializeParam(
                      widget.diasDg,
                      ParamType.String,
                    ),
                  }.withoutNulls,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MenuIconTile(icon: Icons.attach_money_sharp),
                  const SizedBox(height: 8.0),
                  AutoSizeText(
                    'Financeiro',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    minFontSize: 8.0,
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).labelMedium.override(
                          font: GoogleFonts.readexPro(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontStyle,
                          ),
                          color: Color(0xFF14181B),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          fontStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontStyle,
                        ),
                  ),
                ],
              ),
            ),
          ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation15']!),
          if (responsiveVisibility(
            context: context,
            phone: false,
            tablet: false,
            tabletLandscape: false,
            desktop: false,
          ))
            Container(
              width: MediaQuery.sizeOf(context).width * 0.3,
              height: 120.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(18.0),
                boxShadow: AppTokens.softShadow(context),
              ),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {},
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.fileImport,
                      color: Color(0xFFEC3B5B),
                      size: 22.0,
                    ),
                    AutoSizeText(
                      'Importar animais',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      minFontSize: 8.0,
                      overflow: TextOverflow.ellipsis,
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                            font: GoogleFonts.readexPro(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                            color: Color(0xFF14181B),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontStyle,
                          ),
                    ),
                  ],
                ),
              ),
            ).animateOnPageLoad(
                animationsMap['containerOnPageLoadAnimation16']!),
        ],
      ),
    );
  }

  Widget _cardInicio(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.3,
      height: 120.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          context.pushNamed(DashboardTecnicoPage.routeName);

          FFAppState().clearAllAnimaisProdutorCache();
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              color: Color(0xFFEC3B5B),
              size: 22.0,
            ),
            Text(
              'Início',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).labelMedium.override(
                    font: GoogleFonts.readexPro(
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
                    color: Color(0xFF14181B),
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
            ),
          ],
        ),
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation1']!);
  }

  Widget _cardTrocarProdutor(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.3,
      height: 120.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          context.pushNamed(
            ListaPropriedadePage.routeName,
            queryParameters: {
              'visitaPresencial': serializeParam(
                false,
                ParamType.bool,
              ),
            }.withoutNulls,
          );

          FFAppState().clearAllAnimaisProdutorCache();
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.supervisor_account_rounded,
              color: Color(0xFFEC3B5B),
              size: 32.0,
            ),
            Text(
              'Trocar Produtor',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).labelMedium.override(
                    font: GoogleFonts.readexPro(
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
                    color: Color(0xFF14181B),
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
            ),
          ],
        ),
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation2']!);
  }

  Widget _cardAnimais(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.3,
      height: 120.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          if (_respostaNet!) {
            // Animais criados offline vão direto ao ObjectBox e sincronizam ao
            // reconectar — sem fila no FFAppState a bloquear a navegação.
            {
              context.pushNamed(
                ListaAnimaisPage.routeName,
                queryParameters: {
                  'uidPropriedade': serializeParam(
                    widget.uidPropriedade,
                    ParamType.DocumentReference,
                  ),
                  'nomePropriedade': serializeParam(
                    widget.nomePropriedade,
                    ParamType.String,
                  ),
                  'uidTecnico': serializeParam(
                    widget.uidTecnico,
                    ParamType.DocumentReference,
                  ),
                  'emailPropriedade': serializeParam(
                    widget.emailPropriedade,
                    ParamType.String,
                  ),
                  'visitaPresencial': serializeParam(
                    widget.visitaPresencial,
                    ParamType.bool,
                  ),
                  'diasDg': serializeParam(
                    widget.diasDg,
                    ParamType.String,
                  ),
                }.withoutNulls,
              );

              return;
            }
          } else {
            context.pushNamed(
              ListaAnimaisPage.routeName,
              queryParameters: {
                'uidPropriedade': serializeParam(
                  widget.uidPropriedade,
                  ParamType.DocumentReference,
                ),
                'nomePropriedade': serializeParam(
                  widget.nomePropriedade,
                  ParamType.String,
                ),
                'uidTecnico': serializeParam(
                  widget.uidTecnico,
                  ParamType.DocumentReference,
                ),
                'emailPropriedade': serializeParam(
                  widget.emailPropriedade,
                  ParamType.String,
                ),
                'visitaPresencial': serializeParam(
                  widget.visitaPresencial,
                  ParamType.bool,
                ),
                'diasDg': serializeParam(
                  widget.diasDg,
                  ParamType.String,
                ),
              }.withoutNulls,
            );

            return;
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.format_list_numbered,
              color: Color(0xFFEC3B5B),
              size: 24.0,
            ),
            Text(
              'Animais',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).labelMedium.override(
                    font: GoogleFonts.readexPro(
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
            ),
          ],
        ),
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation3']!);
  }

  Widget _cardInseminacoes(BuildContext context,
      dynamic inicioPropriedadeAnimaisProdutoresRecordList) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.3,
      padding: EdgeInsets.all(5.0),
      height: 120.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          context.pushNamed(
            ListaInseminacoesPage.routeName,
            queryParameters: {
              'uidPropriedade': serializeParam(
                widget.uidPropriedade,
                ParamType.DocumentReference,
              ),
              'nomePropriedade': serializeParam(
                widget.nomePropriedade,
                ParamType.String,
              ),
              'uidTecnico': serializeParam(
                widget.uidTecnico,
                ParamType.DocumentReference,
              ),
              'emailPropriedade': serializeParam(
                widget.emailPropriedade,
                ParamType.String,
              ),
              'visitaPresencial': serializeParam(
                widget.visitaPresencial,
                ParamType.bool,
              ),
              'diasDg': serializeParam(
                widget.diasDg,
                ParamType.String,
              ),
            }.withoutNulls,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: AlignmentDirectional(1.0, -1.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(1.0, -1.0),
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                5.0, 5.0, 5.0, 5.0),
                            child: Text(
                              _respostaNet!
                                  ? inicioPropriedadeAnimaisProdutoresRecordList
                                      .where((e) =>
                                          ((ehVaca(e.grupoAnimal)) ||
                                              (ehNovilha(e.grupoAnimal))) &&
                                          ((ehVazia(e.status)) ||
                                              (ehInseminada(e.status)) ||
                                              (ehInseminadaPP(e.status))))
                                      .toList()
                                      .length
                                      .toString()
                                  : (inicioPropriedadeAnimaisProdutoresRecordList
                                          .where((e) =>
                                              ((ehVaca(e.grupoAnimal)) ||
                                                  (ehNovilha(e.grupoAnimal))) &&
                                              ((ehVazia(e.status)) ||
                                                  (ehInseminada(e.status)) ||
                                                  (ehInseminadaPP(e.status))))
                                          .toList()
                                          .length)
                                      .toString(),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: AppTokens.secondary,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.0, -1.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MenuIconTile(
                            icon: Icons.vaccines, accent: AppTokens.secondary),
                        const SizedBox(height: 8.0),
                        AutoSizeText(
                          'Inseminações',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          minFontSize: 8.0,
                          overflow: TextOverflow.ellipsis,
                          style: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                font: GoogleFonts.readexPro(
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation4']!);
  }

  Widget _cardDiagnosticoGestacao(BuildContext context,
      dynamic inicioPropriedadeAnimaisProdutoresRecordList) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.3,
      height: 120.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          context.pushNamed(
            DiagnosticogestacaoPage.routeName,
            queryParameters: {
              'uidPropriedade': serializeParam(
                widget.uidPropriedade,
                ParamType.DocumentReference,
              ),
              'nomePropriedade': serializeParam(
                widget.nomePropriedade,
                ParamType.String,
              ),
              'uidTecnico': serializeParam(
                widget.uidTecnico,
                ParamType.DocumentReference,
              ),
              'emailPropriedade': serializeParam(
                widget.emailPropriedade,
                ParamType.String,
              ),
              'visitaPresencial': serializeParam(
                widget.visitaPresencial,
                ParamType.bool,
              ),
              'diasDg': serializeParam(
                widget.diasDg,
                ParamType.String,
              ),
            }.withoutNulls,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: AlignmentDirectional(1.0, -1.0),
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                      child: Text(
                        inicioPropriedadeAnimaisProdutoresRecordList
                            .where((e) => valueOrDefault<bool>(
                                  (e.dtUltimaInseminacao != '') &&
                                      ((ehVaca(e.grupoAnimal)) ||
                                          (ehNovilha(e.grupoAnimal))) &&
                                      ((ehInseminada(e.status)) ||
                                          (ehInseminadaPP(e.status))) &&
                                      (functions.converterStringParaData(
                                              e.dtUltimaInseminacao,
                                              widget.diasDg!) <=
                                          functions.obterDataAtual()),
                                  true,
                                ))
                            .toList()
                            .length
                            .toString(),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.readexPro(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: AppTokens.secondary,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      MenuIconTile(
                          icon: Icons.medical_information_outlined,
                          accent: AppTokens.secondary),
                      const SizedBox(height: 8.0),
                      AutoSizeText(
                        'Diagnóstico\nGestação',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        minFontSize: 8.0,
                        overflow: TextOverflow.ellipsis,
                        style: FlutterFlowTheme.of(context)
                            .labelMedium
                            .override(
                              font: GoogleFonts.readexPro(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation5']!);
  }

  Widget _cardPrenhas(BuildContext context,
      dynamic inicioPropriedadeAnimaisProdutoresRecordList) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.3,
      height: 120.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          context.pushNamed(
            AnimaisPrenhasPage.routeName,
            queryParameters: {
              'uidPropriedade': serializeParam(
                widget.uidPropriedade,
                ParamType.DocumentReference,
              ),
              'nomePropriedade': serializeParam(
                widget.nomePropriedade,
                ParamType.String,
              ),
              'uidTecnico': serializeParam(
                widget.uidTecnico,
                ParamType.DocumentReference,
              ),
              'emailPropriedade': serializeParam(
                widget.emailPropriedade,
                ParamType.String,
              ),
              'visitaPresencial': serializeParam(
                widget.visitaPresencial,
                ParamType.bool,
              ),
              'diasDg': serializeParam(
                widget.diasDg,
                ParamType.String,
              ),
            }.withoutNulls,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: AlignmentDirectional(1.0, -1.0),
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                      child: Text(
                        inicioPropriedadeAnimaisProdutoresRecordList
                            .where((e) =>
                                (ehPrenha(e.status)) &&
                                (ehVacaOuNovilha(e.grupoAnimal)))
                            .toList()
                            .length
                            .toString(),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.readexPro(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: AppTokens.secondary,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      MenuIconTile(
                          icon: Icons.monitor_heart_outlined,
                          accent: AppTokens.secondary),
                      const SizedBox(height: 8.0),
                      AutoSizeText(
                        'Prenhas',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        minFontSize: 8.0,
                        overflow: TextOverflow.ellipsis,
                        style:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  color: Color(0xFF14181B),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation6']!);
  }

  Widget _cardSecas(BuildContext context,
      dynamic inicioPropriedadeAnimaisProdutoresRecordList) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.3,
      height: 120.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          context.pushNamed(
            SecasPage.routeName,
            queryParameters: {
              'uidPropriedade': serializeParam(
                widget.uidPropriedade,
                ParamType.DocumentReference,
              ),
              'nomePropriedade': serializeParam(
                widget.nomePropriedade,
                ParamType.String,
              ),
              'uidTecnico': serializeParam(
                widget.uidTecnico,
                ParamType.DocumentReference,
              ),
              'emailPropriedade': serializeParam(
                widget.emailPropriedade,
                ParamType.String,
              ),
              'visitaPresencial': serializeParam(
                widget.visitaPresencial,
                ParamType.bool,
              ),
              'diasDg': serializeParam(
                widget.diasDg,
                ParamType.String,
              ),
            }.withoutNulls,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: AlignmentDirectional(1.0, -1.0),
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                      child: Text(
                        inicioPropriedadeAnimaisProdutoresRecordList
                            .where((e) =>
                                ((ehVaca(e.grupoAnimal)) &&
                                    (ehSeca(e.status))) ||
                                (e.status == 'Pré Parto') ||
                                (ehDescarte(e.status)) ||
                                ((ehVazia(e.status)) &&
                                    (e.dtInducaoLactacao != null)))
                            .toList()
                            .length
                            .toString(),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.readexPro(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: AppTokens.secondary,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      MenuIconTile(icon: Icons.alarm_add_sharp),
                      const SizedBox(height: 8.0),
                      AutoSizeText(
                        'Secas',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        minFontSize: 8.0,
                        overflow: TextOverflow.ellipsis,
                        style:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  color: Color(0xFF14181B),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation7']!);
  }

  Widget _cardExameGinecologico(BuildContext context,
      dynamic inicioPropriedadeAnimaisProdutoresRecordList) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.3,
      height: 120.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          context.pushNamed(
            ExameGinecologicoPage.routeName,
            queryParameters: {
              'uidPropriedade': serializeParam(
                widget.uidPropriedade,
                ParamType.DocumentReference,
              ),
              'nomePropriedade': serializeParam(
                widget.nomePropriedade,
                ParamType.String,
              ),
              'uidTecnico': serializeParam(
                widget.uidTecnico,
                ParamType.DocumentReference,
              ),
              'emailPropriedade': serializeParam(
                widget.emailPropriedade,
                ParamType.String,
              ),
              'visitaPresencial': serializeParam(
                widget.visitaPresencial,
                ParamType.bool,
              ),
              'diasDg': serializeParam(
                widget.diasDg,
                ParamType.String,
              ),
            }.withoutNulls,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: AlignmentDirectional(1.0, -1.0),
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                      child: Text(
                        _respostaNet!
                            ? inicioPropriedadeAnimaisProdutoresRecordList
                                .where((e) =>
                                    (ehVazia(e.status)) &&
                                    ((ehNovilha(e.grupoAnimal)) ||
                                        (ehVaca(e.grupoAnimal))) &&
                                    (e.dtInducaoLactacao == null))
                                .toList()
                                .length
                                .toString()
                            : (inicioPropriedadeAnimaisProdutoresRecordList
                                    .where((e) =>
                                        (ehVazia(e.status)) &&
                                        ((ehNovilha(e.grupoAnimal)) ||
                                            (ehVaca(e.grupoAnimal))) &&
                                        (e.dtInducaoLactacao == null))
                                    .toList()
                                    .length)
                                .toString(),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.readexPro(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: AppTokens.secondary,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      MenuIconTile(
                          icon: Icons.medical_services,
                          accent: AppTokens.secondary),
                      const SizedBox(height: 8.0),
                      AutoSizeText(
                        'Exame\nGinecológico',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        minFontSize: 8.0,
                        overflow: TextOverflow.ellipsis,
                        style:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  color: Color(0xFF14181B),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation8']!);
  }

  Widget _cardRecria(BuildContext context,
      dynamic inicioPropriedadeAnimaisProdutoresRecordList) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.3,
      height: 120.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          context.pushNamed(
            RecriacaoPage.routeName,
            queryParameters: {
              'uidPropriedade': serializeParam(
                widget.uidPropriedade,
                ParamType.DocumentReference,
              ),
              'nomePropriedade': serializeParam(
                widget.nomePropriedade,
                ParamType.String,
              ),
              'uidTecnico': serializeParam(
                widget.uidTecnico,
                ParamType.DocumentReference,
              ),
              'emailPropriedade': serializeParam(
                widget.emailPropriedade,
                ParamType.String,
              ),
              'visitaPresencial': serializeParam(
                widget.visitaPresencial,
                ParamType.bool,
              ),
              'diasDg': serializeParam(
                widget.diasDg,
                ParamType.String,
              ),
            }.withoutNulls,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: AlignmentDirectional(1.0, -1.0),
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                      child: Text(
                        _respostaNet!
                            ? inicioPropriedadeAnimaisProdutoresRecordList
                                .where((e) =>
                                    (((ehTouros(e.grupoAnimal)) &&
                                            (e.liberaInseminacao == false)) ||
                                        ((ehNovilha(e.grupoAnimal)) &&
                                            (e.dtInducaoLactacao == null)) ||
                                        (ehBezerras(e.grupoAnimal)) ||
                                        (ehBezerros(e.grupoAnimal))) &&
                                    ((!ehDescarte(e.status)) &&
                                        (e.status != 'Pré Parto')))
                                .toList()
                                .length
                                .toString()
                            : (inicioPropriedadeAnimaisProdutoresRecordList
                                    .where((e) =>
                                        (((ehTouros(e.grupoAnimal)) &&
                                                (e.liberaInseminacao ==
                                                    false)) ||
                                            ((ehNovilha(e.grupoAnimal)) &&
                                                (e.dtInducaoLactacao ==
                                                    null)) ||
                                            (ehBezerras(e.grupoAnimal)) ||
                                            (ehBezerros(e.grupoAnimal))) &&
                                        ((!ehDescarte(e.status)) &&
                                            (e.status != 'Pré Parto')))
                                    .toList()
                                    .length)
                                .toString(),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.readexPro(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: AppTokens.secondary,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      MenuIconTile(icon: Icons.compare_arrows_sharp),
                      const SizedBox(height: 8.0),
                      AutoSizeText(
                        'Recria',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        minFontSize: 8.0,
                        overflow: TextOverflow.ellipsis,
                        style: FlutterFlowTheme.of(context)
                            .labelMedium
                            .override(
                              font: GoogleFonts.readexPro(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation9']!);
  }

  Widget _cardListaCompleta(BuildContext context,
      dynamic inicioPropriedadeAnimaisProdutoresRecordList) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.3,
      height: 120.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          context.pushNamed(
            ListacompletaPage.routeName,
            queryParameters: {
              'uidPropriedade': serializeParam(
                widget.uidPropriedade,
                ParamType.DocumentReference,
              ),
              'nomePropriedade': serializeParam(
                widget.nomePropriedade,
                ParamType.String,
              ),
              'uidTecnico': serializeParam(
                widget.uidTecnico,
                ParamType.DocumentReference,
              ),
              'emailPropriedade': serializeParam(
                widget.emailPropriedade,
                ParamType.String,
              ),
              'visitaPresencial': serializeParam(
                widget.visitaPresencial,
                ParamType.bool,
              ),
              'diasDg': serializeParam(
                widget.diasDg,
                ParamType.String,
              ),
            }.withoutNulls,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: AlignmentDirectional(1.0, -1.0),
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                      child: Text(
                        inicioPropriedadeAnimaisProdutoresRecordList
                            .where((e) =>
                                ((ehNovilha(e.grupoAnimal)) ||
                                    (ehVaca(e.grupoAnimal))) &&
                                (!ehDescarte(e.status)))
                            .toList()
                            .length
                            .toString(),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.readexPro(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: AppTokens.secondary,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MenuIconTile(icon: Icons.list_alt_sharp),
                      const SizedBox(height: 8.0),
                      AutoSizeText(
                        'Lista completa',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        minFontSize: 8.0,
                        overflow: TextOverflow.ellipsis,
                        style:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  color: Color(0xFF14181B),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation10']!);
  }

  Widget _cardIndicesZootecnicos(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.3,
      height: 120.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          context.pushNamed(
            IndicesZootecnicosPage.routeName,
            queryParameters: {
              'uidPropriedade': serializeParam(
                widget.uidPropriedade,
                ParamType.DocumentReference,
              ),
              'nomePropriedade': serializeParam(
                widget.nomePropriedade,
                ParamType.String,
              ),
              'uidTecnico': serializeParam(
                widget.uidTecnico,
                ParamType.DocumentReference,
              ),
              'emailPropriedade': serializeParam(
                widget.emailPropriedade,
                ParamType.String,
              ),
              'visitaPresencial': serializeParam(
                widget.visitaPresencial,
                ParamType.bool,
              ),
              'diasDg': serializeParam(
                widget.diasDg,
                ParamType.String,
              ),
            }.withoutNulls,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_copy_outlined,
              color: Color(0xFFEC3B5B),
              size: 30.0,
            ),
            Text(
              'Indíces Zootécnicos',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).labelMedium.override(
                    font: GoogleFonts.readexPro(
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
                    color: Color(0xFF14181B),
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
            ),
          ],
        ),
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation14']!);
  }

  Widget _rotuloReceituario(BuildContext context) {
    return Text(
      'Receituário',
      textAlign: TextAlign.center,
      style: FlutterFlowTheme.of(context).labelMedium.override(
            font: GoogleFonts.readexPro(
              fontWeight: FontWeight.w600,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
            color: Color(0xFF14181B),
            letterSpacing: 0.0,
            fontWeight: FontWeight.w600,
            fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
          ),
    );
  }

  Widget _rotuloResumoRebanho(BuildContext context) {
    return Text(
      'Resumo Rebanho',
      textAlign: TextAlign.center,
      style: FlutterFlowTheme.of(context).labelMedium.override(
            font: GoogleFonts.readexPro(
              fontWeight: FontWeight.w600,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
            color: Color(0xFF14181B),
            letterSpacing: 0.0,
            fontWeight: FontWeight.w600,
            fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
          ),
    );
  }

  Widget _rotuloCalendarioSanitario(BuildContext context) {
    return Text(
      'Calendário Sanitário',
      textAlign: TextAlign.center,
      style: FlutterFlowTheme.of(context).labelMedium.override(
            font: GoogleFonts.readexPro(
              fontWeight: FontWeight.w600,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
            color: Color(0xFF14181B),
            letterSpacing: 0.0,
            fontWeight: FontWeight.w600,
            fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // context.watch<FFAppState>();

    // Animais lidos do ObjectBox (offline-first), filtrados pela propriedade.
    // Antes vinham de um StreamBuilder do Firestore — que ficava no spinner
    // offline e não enxergava a propriedade pendente. A ordenação por nome é
    // aplicada localmente (a lista alimenta apenas contadores).
    final animaisAsync = ref
        .watch(animaisByPropriedadeProvider(widget.uidPropriedade?.path ?? ''));

    return animaisAsync.when(
      loading: () => Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Center(child: Text('Erro ao carregar os animais.')),
      ),
      data: (inicioPropriedadeAnimaisProdutoresRecordList) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            appBar: AppBar(
              backgroundColor:
                  _respostaNet! ? Color(0xFFF75E38) : Color(0xFFF2886E),
              automaticallyImplyLeading: false,
              title: Text(
                widget.nomePropriedade!,
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      font: GoogleFonts.outfit(
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontStyle,
                      ),
                      color: Colors.white,
                      letterSpacing: 0.0,
                      fontWeight: FlutterFlowTheme.of(context)
                          .headlineMedium
                          .fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                    ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                  child: FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30.0,
                    borderWidth: 1.0,
                    buttonSize: 60.0,
                    icon: Icon(
                      Icons.account_circle_outlined,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () async {
                      context.pushNamed(
                        EditarPropriedadePage.routeName,
                        queryParameters: {
                          // Pendente: edita pelo id local (a pendente não tem
                          // documento no Firestore); ativa: pelo docRef.
                          if (widget.propriedadePendenteId != null)
                            'propriedadePendenteId': serializeParam(
                              widget.propriedadePendenteId,
                              ParamType.int,
                            )
                          else
                            'uidPropriedade': serializeParam(
                              widget.uidPropriedade,
                              ParamType.DocumentReference,
                            ),
                          'nomePropriedade': serializeParam(
                            widget.nomePropriedade,
                            ParamType.String,
                          ),
                          'uidTecnico': serializeParam(
                            widget.uidTecnico,
                            ParamType.DocumentReference,
                          ),
                          'emailPropriedade': serializeParam(
                            widget.emailPropriedade,
                            ParamType.String,
                          ),
                          'visitaPresencial': serializeParam(
                            widget.visitaPresencial,
                            ParamType.bool,
                          ),
                          'emailTecnico': serializeParam(
                            currentUserEmail,
                            ParamType.String,
                          ),
                        }.withoutNulls,
                      );
                    },
                  ),
                ),
              ],
              centerTitle: false,
              elevation: 0.0,
            ),
            body: SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _cabecalho(context),
                    _gradeMenu(
                        context, inicioPropriedadeAnimaisProdutoresRecordList),
                    if (!valueOrDefault<bool>(
                      _respostaNet,
                      true,
                    ))
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wifi_off,
                              color: Color(0xFFD50000),
                              size: 24.0,
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Sem internet! Depois sincronize os dados.',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.readexPro(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFFD50000),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
