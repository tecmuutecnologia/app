// ignore_for_file: unnecessary_null_comparison

import '/backend/backend.dart';
import '/backend/objectbox/index.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/domain/animais/classificacao_animal.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/pages/tecnico/propriedade/prenhas/registro_aborto/registro_aborto_widget.dart';
import '/pages/tecnico/propriedade/prenhas/registro_aborto_offline/registro_aborto_offline_widget.dart';
import '/pages/tecnico/propriedade/secas/registrar_parto/registrar_parto_widget.dart';
import '/pages/tecnico/propriedade/secas/registrar_parto_induzido/registrar_parto_induzido_widget.dart';
import '/pages/tecnico/propriedade/secas/registrar_parto_induzido_offline/registrar_parto_induzido_offline_widget.dart';
import '/pages/tecnico/propriedade/secas/registrar_parto_offline/registrar_parto_offline_widget.dart';
import '/pages/tecnico/propriedade/secas/registrar_pre_parto/registrar_pre_parto_widget.dart';
import '/pages/tecnico/propriedade/secas/registrar_pre_parto_offline/registrar_pre_parto_offline_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'secas_model.dart';
export 'secas_model.dart';

class SecasWidget extends StatefulWidget {
  const SecasWidget({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.diasDg,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? diasDg;

  static String routeName = 'secas';
  static String routePath = '/secas';

  @override
  State<SecasWidget> createState() => _SecasWidgetState();
}

class _SecasWidgetState extends State<SecasWidget>
    with TickerProviderStateMixin {
  late SecasModel _model;

  /// Lista de animais existentes (fonte ObjectBox). Antes em
  /// FFAppState.animaisProdutoresExistentes; agora estado local desta tela.
  List<AnimaisProdutoresStruct> _animaisExistentes = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SecasModel());

    // Fonte única: carrega a lista do ObjectBox (offline-first). A tela renderiza
    // sempre desta lista; o Firestore é usado apenas para sincronizar.
    if (ObjectBoxService.isInitialized) {
      _animaisExistentes = AnimalRepository()
          .getAll()
          .where((a) => !a.isDeleted)
          .map(animalEntityToStruct)
          .toList();
    }

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.instantTimer = InstantTimer.periodic(
        duration: Duration(seconds: 5),
        callback: (timer) async {
          _model.respostaNet = await actions.checkInternetConnection();

          safeSetState(() {});
          if (_model.respostaNet!) {
            safeSetState(() {});
          } else {
            // Offline: notificação passiva via SyncStatusBanner (app-wide);
            // sem flag global. O respostaNet acima já atualiza a UI.
          }
        },
        startImmediately: false,
      );
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 4,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            backgroundColor: Color(0xFFF75E38),
            automaticallyImplyLeading: false,
            actions: [],
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                        child: FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 30.0,
                          borderWidth: 1.0,
                          buttonSize: 50.0,
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          onPressed: () async {
                            context.pushNamed(
                              InicioPropriedadeWidget.routeName,
                              queryParameters: {
                                'nomePropriedade': serializeParam(
                                  widget.nomePropriedade,
                                  ParamType.String,
                                ),
                                'uidPropriedade': serializeParam(
                                  widget.uidPropriedade,
                                  ParamType.DocumentReference,
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
                        ),
                      ),
                      Text(
                        'Animais em secagem',
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
                              color: Colors.white,
                              fontSize: 22.0,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .fontStyle,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              centerTitle: true,
              expandedTitleScale: 1.0,
            ),
            elevation: 0.0,
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment(-1.0, 0),
                    child: FlutterFlowButtonTabBar(
                      useToggleButtonStyle: false,
                      isScrollable: true,
                      labelStyle:
                          FlutterFlowTheme.of(context).titleMedium.override(
                                font: GoogleFonts.readexPro(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .fontStyle,
                              ),
                      unselectedLabelStyle: TextStyle(),
                      labelColor: Colors.white,
                      unselectedLabelColor:
                          FlutterFlowTheme.of(context).secondaryText,
                      backgroundColor: Color(0xFFF75E38),
                      unselectedBackgroundColor: Color(0xFFC5C5C5),
                      borderColor: Color(0xFFEC3B5B),
                      borderWidth: 2.0,
                      borderRadius: 12.0,
                      elevation: 0.0,
                      labelPadding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      buttonMargin:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 16.0, 0.0),
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      tabs: [
                        Tab(
                          text: 'Vacas secas',
                        ),
                        Tab(
                          text: 'Pré Parto',
                        ),
                        Tab(
                          text: 'Indução Lactação',
                        ),
                        Tab(
                          text: 'Descarte',
                        ),
                      ],
                      controller: _model.tabBarController,
                      onTap: (i) async {
                        [
                          () async {},
                          () async {},
                          () async {},
                          () async {}
                        ][i]();
                      },
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _model.tabBarController,
                      children: [
                        SingleChildScrollView(
                          primary: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Builder(
                                builder: (context) {
                                  final vacasExistenteOffline =
                                      _animaisExistentes
                                          .map((e) => e)
                                          .toList()
                                          .sortedList(
                                              keyOf: (e) =>
                                                  e.compararDtUltimaInseminacao,
                                              desc: false)
                                          .toList();

                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: vacasExistenteOffline.length,
                                    itemBuilder:
                                        (context, vacasExistenteOfflineIndex) {
                                      final vacasExistenteOfflineItem =
                                          vacasExistenteOffline[
                                              vacasExistenteOfflineIndex];
                                      return Visibility(
                                        visible: (vacasExistenteOfflineItem
                                                    .uidTecnicoPropriedade ==
                                                widget.uidPropriedade) &&
                                            ehVacaSeca(
                                                vacasExistenteOfflineItem
                                                    .grupoAnimal,
                                                vacasExistenteOfflineItem
                                                    .status) &&
                                            (dateTimeFormat(
                                                  "d/M/y",
                                                  vacasExistenteOfflineItem
                                                      .compararDtUltimaInseminacao,
                                                  locale: FFLocalizations.of(
                                                          context)
                                                      .languageCode,
                                                ) !=
                                                '31/12/2050'),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 8.0, 16.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {},
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: ListView(
                                                padding: EdgeInsets.zero,
                                                primary: false,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                children: [
                                                  InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {},
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          10.0),
                                                              child: Container(
                                                                width: 44.0,
                                                                height: 44.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: () {
                                                                    if (ehVaca(
                                                                        vacasExistenteOfflineItem
                                                                            .grupoAnimal)) {
                                                                      return Color(
                                                                          0xFF048508);
                                                                    } else if (ehNovilha(
                                                                        vacasExistenteOfflineItem
                                                                            .grupoAnimal)) {
                                                                      return Color(
                                                                          0xFFFF0076);
                                                                    } else {
                                                                      return Color(
                                                                          0x00000000);
                                                                    }
                                                                  }(),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                child: Text(
                                                                  () {
                                                                    if (ehVaca(
                                                                        vacasExistenteOfflineItem
                                                                            .grupoAnimal)) {
                                                                      return 'VAC';
                                                                    } else if (ehNovilha(
                                                                        vacasExistenteOfflineItem
                                                                            .grupoAnimal)) {
                                                                      return 'NOV';
                                                                    } else {
                                                                      return 'N/C';
                                                                    }
                                                                  }(),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            13.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              () {
                                                                if ((vacasExistenteOfflineItem
                                                                            .nomeAnimal !=
                                                                        '') &&
                                                                    (vacasExistenteOfflineItem
                                                                            .brincoAnimal !=
                                                                        null) &&
                                                                    (vacasExistenteOfflineItem
                                                                            .brincoAnimal !=
                                                                        -1)) {
                                                                  return '${vacasExistenteOfflineItem.nomeAnimal} - ${vacasExistenteOfflineItem.brincoAnimal.toString()}';
                                                                } else if (vacasExistenteOfflineItem
                                                                        .nomeAnimal !=
                                                                    '') {
                                                                  return vacasExistenteOfflineItem
                                                                      .nomeAnimal;
                                                                } else {
                                                                  return vacasExistenteOfflineItem
                                                                      .brincoAnimal
                                                                      .toString();
                                                                }
                                                              }(),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLarge
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Inseminada em: ${vacasExistenteOfflineItem.dtUltimaInseminacao}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Pré parto prev.: ${vacasExistenteOfflineItem.dtPrePartoPrevista}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Parto previsto: ${vacasExistenteOfflineItem.dtPartoPrevisto}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 15.0,
                                                                0.0, 15.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      10.0,
                                                                      0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child:
                                                                    FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    await showModalBottomSheet(
                                                                      isScrollControlled:
                                                                          true,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      enableDrag:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            FocusScope.of(context).unfocus();
                                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                MediaQuery.viewInsetsOf(context),
                                                                            child:
                                                                                RegistroAbortoWidget(
                                                                              uidPropriedade: widget.uidPropriedade!,
                                                                              nomePropriedade: widget.nomePropriedade!,
                                                                              uidTecnico: widget.uidTecnico!,
                                                                              emailPropriedade: widget.emailPropriedade!,
                                                                              visitaPresencial: widget.visitaPresencial!,
                                                                              diasDg: widget.diasDg!,
                                                                              uidAnimaisProdutores: vacasExistenteOfflineItem.uidAnimal,
                                                                              uidAnimalOffline: vacasExistenteOfflineItem.uidAnimalOffline,
                                                                              nomeAnimal: vacasExistenteOfflineItem.nomeAnimal,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).then((value) =>
                                                                        safeSetState(
                                                                            () {}));
                                                                  },
                                                                  text:
                                                                      'Aborto',
                                                                  icon: Icon(
                                                                    Icons
                                                                        .cancel_sharp,
                                                                    size: 15.0,
                                                                  ),
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width:
                                                                        100.0,
                                                                    height:
                                                                        40.0,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: Color(
                                                                        0xFFAE0303),
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        3.0,
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      10.0,
                                                                      0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child:
                                                                    FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    await showModalBottomSheet(
                                                                      isScrollControlled:
                                                                          true,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      enableDrag:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            FocusScope.of(context).unfocus();
                                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                MediaQuery.viewInsetsOf(context),
                                                                            child:
                                                                                RegistrarPartoWidget(
                                                                              uidPropriedade: widget.uidPropriedade!,
                                                                              nomePropriedade: widget.nomePropriedade!,
                                                                              uidTecnico: widget.uidTecnico!,
                                                                              emailPropriedade: widget.emailPropriedade!,
                                                                              visitaPresencial: widget.visitaPresencial!,
                                                                              diasDg: widget.diasDg!,
                                                                              uidAnimaisProdutores: vacasExistenteOfflineItem.uidAnimal,
                                                                              uidAnimalOffline: vacasExistenteOfflineItem.uidAnimalOffline,
                                                                              nomeVacaAtual: vacasExistenteOfflineItem.nomeAnimal,
                                                                              nomeTourtoUltimaInseminacao: vacasExistenteOfflineItem.nomeTouroUltimaInseminacao,
                                                                              brincoVacaAtual: vacasExistenteOfflineItem.brincoAnimal.toString(),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).then((value) =>
                                                                        safeSetState(
                                                                            () {}));
                                                                  },
                                                                  text: 'Parto',
                                                                  icon: Icon(
                                                                    Icons
                                                                        .add_alert,
                                                                    size: 15.0,
                                                                  ),
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width:
                                                                        100.0,
                                                                    height:
                                                                        40.0,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: Color(
                                                                        0xFF048508),
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        3.0,
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child:
                                                                  FFButtonWidget(
                                                                onPressed:
                                                                    () async {
                                                                  await showModalBottomSheet(
                                                                    isScrollControlled:
                                                                        true,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    enableDrag:
                                                                        false,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          FocusScope.of(context)
                                                                              .unfocus();
                                                                          FocusManager
                                                                              .instance
                                                                              .primaryFocus
                                                                              ?.unfocus();
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              MediaQuery.viewInsetsOf(context),
                                                                          child:
                                                                              RegistrarPrePartoWidget(
                                                                            uidPropriedade:
                                                                                widget.uidPropriedade!,
                                                                            nomePropriedade:
                                                                                widget.nomePropriedade!,
                                                                            uidTecnico:
                                                                                widget.uidTecnico!,
                                                                            emailPropriedade:
                                                                                widget.emailPropriedade!,
                                                                            visitaPresencial:
                                                                                widget.visitaPresencial!,
                                                                            diasDg:
                                                                                widget.diasDg!,
                                                                            uidAnimaisProdutores:
                                                                                vacasExistenteOfflineItem.uidAnimal!,
                                                                            nomeAnimal:
                                                                                vacasExistenteOfflineItem.nomeAnimal,
                                                                            brincoAnimal:
                                                                                vacasExistenteOfflineItem.brincoAnimal.toString(),
                                                                            grupoAnimal:
                                                                                vacasExistenteOfflineItem.grupoAnimal,
                                                                            dtPrePartoPrevista:
                                                                                functions.converteDataStringDate(vacasExistenteOfflineItem.dtPrePartoPrevista),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      safeSetState(
                                                                          () {}));
                                                                },
                                                                text:
                                                                    'Pré-parto',
                                                                icon: Icon(
                                                                  Icons.check,
                                                                  size: 15.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  width: 100.0,
                                                                  height: 40.0,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0.0),
                                                                  iconPadding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  color: Color(
                                                                      0xFF1A03E9),
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                  elevation:
                                                                      3.0,
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 1.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
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
                                },
                              ),
                              Builder(
                                builder: (context) {
                                  final vacasSecasOffline = FFAppState()
                                      .animaisProdutoresOffline
                                      .map((e) => e)
                                      .toList()
                                      .sortedList(
                                          keyOf: (e) =>
                                              e.compararDtUltimaInseminacao,
                                          desc: false)
                                      .toList();

                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: vacasSecasOffline.length,
                                    itemBuilder:
                                        (context, vacasSecasOfflineIndex) {
                                      final vacasSecasOfflineItem =
                                          vacasSecasOffline[
                                              vacasSecasOfflineIndex];
                                      return Visibility(
                                        visible: (vacasSecasOfflineItem
                                                    .uidTecnicoPropriedade ==
                                                widget.uidPropriedade) &&
                                            ehVacaSeca(
                                                vacasSecasOfflineItem
                                                    .grupoAnimal,
                                                vacasSecasOfflineItem.status) &&
                                            (dateTimeFormat(
                                                  "d/M/y",
                                                  vacasSecasOfflineItem
                                                      .compararDtUltimaInseminacao,
                                                  locale: FFLocalizations.of(
                                                          context)
                                                      .languageCode,
                                                ) !=
                                                '31/12/2050'),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 8.0, 16.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {},
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: ListView(
                                                padding: EdgeInsets.zero,
                                                primary: false,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                children: [
                                                  InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {},
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          10.0),
                                                              child: Container(
                                                                width: 44.0,
                                                                height: 44.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: () {
                                                                    if (ehVaca(
                                                                        vacasSecasOfflineItem
                                                                            .grupoAnimal)) {
                                                                      return Color(
                                                                          0xFF048508);
                                                                    } else if (ehNovilha(
                                                                        vacasSecasOfflineItem
                                                                            .grupoAnimal)) {
                                                                      return Color(
                                                                          0xFFFF0076);
                                                                    } else {
                                                                      return Color(
                                                                          0x00000000);
                                                                    }
                                                                  }(),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                child: Text(
                                                                  () {
                                                                    if (ehVaca(
                                                                        vacasSecasOfflineItem
                                                                            .grupoAnimal)) {
                                                                      return 'VAC';
                                                                    } else if (ehNovilha(
                                                                        vacasSecasOfflineItem
                                                                            .grupoAnimal)) {
                                                                      return 'NOV';
                                                                    } else {
                                                                      return 'N/C';
                                                                    }
                                                                  }(),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            13.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              () {
                                                                if ((vacasSecasOfflineItem
                                                                            .nomeAnimal !=
                                                                        '') &&
                                                                    (vacasSecasOfflineItem
                                                                            .brincoAnimal !=
                                                                        null) &&
                                                                    (vacasSecasOfflineItem
                                                                            .brincoAnimal !=
                                                                        -1)) {
                                                                  return '${vacasSecasOfflineItem.nomeAnimal} - ${vacasSecasOfflineItem.brincoAnimal.toString()}';
                                                                } else if (vacasSecasOfflineItem
                                                                        .nomeAnimal !=
                                                                    '') {
                                                                  return vacasSecasOfflineItem
                                                                      .nomeAnimal;
                                                                } else {
                                                                  return vacasSecasOfflineItem
                                                                      .brincoAnimal
                                                                      .toString();
                                                                }
                                                              }(),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLarge
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Inseminada em: ${vacasSecasOfflineItem.dtUltimaInseminacao}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Pré parto prev.: ${vacasSecasOfflineItem.dtPrePartoPrevista}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Parto previsto: ${vacasSecasOfflineItem.dtPartoPrevisto}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 15.0,
                                                                0.0, 15.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      10.0,
                                                                      0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child:
                                                                    FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    await showModalBottomSheet(
                                                                      isScrollControlled:
                                                                          true,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      enableDrag:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            FocusScope.of(context).unfocus();
                                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                MediaQuery.viewInsetsOf(context),
                                                                            child:
                                                                                RegistroAbortoOfflineWidget(
                                                                              uidPropriedade: widget.uidPropriedade!,
                                                                              nomePropriedade: widget.nomePropriedade!,
                                                                              uidTecnico: widget.uidTecnico!,
                                                                              emailPropriedade: widget.emailPropriedade!,
                                                                              visitaPresencial: widget.visitaPresencial!,
                                                                              diasDg: widget.diasDg!,
                                                                              nomeAnimal: vacasSecasOfflineItem.nomeAnimal,
                                                                              itemUidIndex: vacasSecasOfflineItem.itemUidIndexAtual,
                                                                              uidAnimalOffline: vacasSecasOfflineItem.uidAnimalOffline,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).then((value) =>
                                                                        safeSetState(
                                                                            () {}));
                                                                  },
                                                                  text:
                                                                      'Aborto',
                                                                  icon: Icon(
                                                                    Icons
                                                                        .cancel_sharp,
                                                                    size: 15.0,
                                                                  ),
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width:
                                                                        100.0,
                                                                    height:
                                                                        40.0,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: Color(
                                                                        0xFFAE0303),
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        3.0,
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      10.0,
                                                                      0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child:
                                                                    FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    await showModalBottomSheet(
                                                                      isScrollControlled:
                                                                          true,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      enableDrag:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            FocusScope.of(context).unfocus();
                                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                MediaQuery.viewInsetsOf(context),
                                                                            child:
                                                                                RegistrarPartoOfflineWidget(
                                                                              uidPropriedade: widget.uidPropriedade!,
                                                                              nomePropriedade: widget.nomePropriedade!,
                                                                              uidTecnico: widget.uidTecnico!,
                                                                              emailPropriedade: widget.emailPropriedade!,
                                                                              visitaPresencial: widget.visitaPresencial!,
                                                                              diasDg: widget.diasDg!,
                                                                              nomeVacaAtual: vacasSecasOfflineItem.nomeAnimal,
                                                                              nomeTourtoUltimaInseminacao: vacasSecasOfflineItem.nomeTouroUltimaInseminacao,
                                                                              brincoVacaAtual: vacasSecasOfflineItem.brincoAnimal.toString(),
                                                                              uidAnimalOffline: vacasSecasOfflineItem.uidAnimalOffline,
                                                                              itemUidIndex: vacasSecasOfflineItem.itemUidIndexAtual,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).then((value) =>
                                                                        safeSetState(
                                                                            () {}));
                                                                  },
                                                                  text: 'Parto',
                                                                  icon: Icon(
                                                                    Icons
                                                                        .add_alert,
                                                                    size: 15.0,
                                                                  ),
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width:
                                                                        100.0,
                                                                    height:
                                                                        40.0,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: Color(
                                                                        0xFF048508),
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        3.0,
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child:
                                                                  FFButtonWidget(
                                                                onPressed:
                                                                    () async {
                                                                  await showModalBottomSheet(
                                                                    isScrollControlled:
                                                                        true,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    enableDrag:
                                                                        false,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          FocusScope.of(context)
                                                                              .unfocus();
                                                                          FocusManager
                                                                              .instance
                                                                              .primaryFocus
                                                                              ?.unfocus();
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              MediaQuery.viewInsetsOf(context),
                                                                          child:
                                                                              RegistrarPrePartoOfflineWidget(
                                                                            uidPropriedade:
                                                                                widget.uidPropriedade!,
                                                                            nomePropriedade:
                                                                                widget.nomePropriedade!,
                                                                            uidTecnico:
                                                                                widget.uidTecnico!,
                                                                            emailPropriedade:
                                                                                widget.emailPropriedade!,
                                                                            visitaPresencial:
                                                                                widget.visitaPresencial!,
                                                                            diasDg:
                                                                                widget.diasDg!,
                                                                            nomeAnimal:
                                                                                vacasSecasOfflineItem.nomeAnimal,
                                                                            brincoAnimal:
                                                                                vacasSecasOfflineItem.brincoAnimal.toString(),
                                                                            grupoAnimal:
                                                                                vacasSecasOfflineItem.grupoAnimal,
                                                                            dtPrePartoPrevista:
                                                                                functions.converteDataStringDate(vacasSecasOfflineItem.dtPrePartoPrevista),
                                                                            itemUidIndex:
                                                                                vacasSecasOfflineItem.itemUidIndexAtual,
                                                                            uidAnimalOffline:
                                                                                vacasSecasOfflineItem.uidAnimalOffline,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      safeSetState(
                                                                          () {}));
                                                                },
                                                                text:
                                                                    'Pré-parto',
                                                                icon: Icon(
                                                                  Icons.check,
                                                                  size: 15.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  width: 100.0,
                                                                  height: 40.0,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0.0),
                                                                  iconPadding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  color: Color(
                                                                      0xFF1A03E9),
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                  elevation:
                                                                      3.0,
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 1.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
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
                                },
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          primary: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Builder(
                                builder: (context) {
                                  final animaisExistentesOffline =
                                      _animaisExistentes
                                          .map((e) => e)
                                          .toList()
                                          .sortedList(
                                              keyOf: (e) =>
                                                  e.compararDtUltimaInseminacao,
                                              desc: false)
                                          .toList();

                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: animaisExistentesOffline.length,
                                    itemBuilder: (context,
                                        animaisExistentesOfflineIndex) {
                                      final animaisExistentesOfflineItem =
                                          animaisExistentesOffline[
                                              animaisExistentesOfflineIndex];
                                      return Visibility(
                                        visible: (animaisExistentesOfflineItem
                                                    .uidTecnicoPropriedade ==
                                                widget.uidPropriedade) &&
                                            (animaisExistentesOfflineItem
                                                    .status ==
                                                'Pré Parto') &&
                                            (dateTimeFormat(
                                                  "d/M/y",
                                                  animaisExistentesOfflineItem
                                                      .compararDtUltimaInseminacao,
                                                  locale: FFLocalizations.of(
                                                          context)
                                                      .languageCode,
                                                ) !=
                                                '31/12/2050'),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 8.0, 16.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                ProntuarioAnimalWidget
                                                    .routeName,
                                                queryParameters: {
                                                  'uidPropriedade':
                                                      serializeParam(
                                                    widget.uidPropriedade,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'nomePropriedade':
                                                      serializeParam(
                                                    widget.nomePropriedade,
                                                    ParamType.String,
                                                  ),
                                                  'uidTecnico': serializeParam(
                                                    widget.uidTecnico,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'emailPropriedade':
                                                      serializeParam(
                                                    widget.emailPropriedade,
                                                    ParamType.String,
                                                  ),
                                                  'uidAnimaisProdutores':
                                                      serializeParam(
                                                    animaisExistentesOfflineItem
                                                        .uidAnimal,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'grupoPredominante':
                                                      serializeParam(
                                                    animaisExistentesOfflineItem
                                                        .grupoAnimal,
                                                    ParamType.String,
                                                  ),
                                                  'visitaPresencial':
                                                      serializeParam(
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
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 10.0, 0.0, 10.0),
                                                child: ListView(
                                                  padding: EdgeInsets.zero,
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          10.0),
                                                              child: Container(
                                                                width: 44.0,
                                                                height: 44.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: () {
                                                                    if (ehVaca(
                                                                        animaisExistentesOfflineItem
                                                                            .grupoAnimal)) {
                                                                      return Color(
                                                                          0xFF048508);
                                                                    } else if (ehNovilha(
                                                                        animaisExistentesOfflineItem
                                                                            .grupoAnimal)) {
                                                                      return Color(
                                                                          0xFFFF0076);
                                                                    } else {
                                                                      return Color(
                                                                          0x00000000);
                                                                    }
                                                                  }(),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                child: Text(
                                                                  () {
                                                                    if (ehVaca(
                                                                        animaisExistentesOfflineItem
                                                                            .grupoAnimal)) {
                                                                      return 'VAC';
                                                                    } else if (ehNovilha(
                                                                        animaisExistentesOfflineItem
                                                                            .grupoAnimal)) {
                                                                      return 'NOV';
                                                                    } else {
                                                                      return 'N/C';
                                                                    }
                                                                  }(),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            13.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              () {
                                                                if ((animaisExistentesOfflineItem
                                                                            .nomeAnimal !=
                                                                        '') &&
                                                                    (animaisExistentesOfflineItem
                                                                            .brincoAnimal !=
                                                                        null) &&
                                                                    (animaisExistentesOfflineItem
                                                                            .brincoAnimal !=
                                                                        -1)) {
                                                                  return '${animaisExistentesOfflineItem.nomeAnimal} - ${animaisExistentesOfflineItem.brincoAnimal.toString()}';
                                                                } else if (animaisExistentesOfflineItem
                                                                        .nomeAnimal !=
                                                                    '') {
                                                                  return animaisExistentesOfflineItem
                                                                      .nomeAnimal;
                                                                } else {
                                                                  return animaisExistentesOfflineItem
                                                                      .brincoAnimal
                                                                      .toString();
                                                                }
                                                              }(),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLarge
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Inseminada em: ${animaisExistentesOfflineItem.dtUltimaInseminacao}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Pré parto prev.: ${animaisExistentesOfflineItem.dtPrePartoPrevista}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Parto previsto: ${animaisExistentesOfflineItem.dtPartoPrevisto}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  5.0,
                                                                  0.0,
                                                                  15.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        10.0,
                                                                        0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      await showModalBottomSheet(
                                                                        isScrollControlled:
                                                                            true,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        enableDrag:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              FocusScope.of(context).unfocus();
                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: MediaQuery.viewInsetsOf(context),
                                                                              child: RegistroAbortoWidget(
                                                                                uidPropriedade: widget.uidPropriedade!,
                                                                                nomePropriedade: widget.nomePropriedade!,
                                                                                uidTecnico: widget.uidTecnico!,
                                                                                emailPropriedade: widget.emailPropriedade!,
                                                                                visitaPresencial: widget.visitaPresencial!,
                                                                                diasDg: widget.diasDg!,
                                                                                uidAnimaisProdutores: animaisExistentesOfflineItem.uidAnimal,
                                                                                uidAnimalOffline: animaisExistentesOfflineItem.uidAnimalOffline,
                                                                                nomeAnimal: animaisExistentesOfflineItem.nomeAnimal,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ).then((value) =>
                                                                          safeSetState(
                                                                              () {}));
                                                                    },
                                                                    text:
                                                                        'Aborto',
                                                                    icon: Icon(
                                                                      Icons
                                                                          .cancel_sharp,
                                                                      size:
                                                                          15.0,
                                                                    ),
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width:
                                                                          100.0,
                                                                      height:
                                                                          40.0,
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              0.0),
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: Color(
                                                                          0xFFAE0303),
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.readexPro(
                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                            ),
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                      elevation:
                                                                          3.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        10.0,
                                                                        0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [],
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child:
                                                                    FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    await showModalBottomSheet(
                                                                      isScrollControlled:
                                                                          true,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      enableDrag:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            FocusScope.of(context).unfocus();
                                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                MediaQuery.viewInsetsOf(context),
                                                                            child:
                                                                                RegistrarPartoWidget(
                                                                              uidPropriedade: widget.uidPropriedade!,
                                                                              nomePropriedade: widget.nomePropriedade!,
                                                                              uidTecnico: widget.uidTecnico!,
                                                                              emailPropriedade: widget.emailPropriedade!,
                                                                              visitaPresencial: widget.visitaPresencial!,
                                                                              diasDg: widget.diasDg!,
                                                                              uidAnimaisProdutores: animaisExistentesOfflineItem.uidAnimal,
                                                                              uidAnimalOffline: animaisExistentesOfflineItem.uidAnimalOffline,
                                                                              nomeVacaAtual: animaisExistentesOfflineItem.nomeAnimal,
                                                                              nomeTourtoUltimaInseminacao: animaisExistentesOfflineItem.nomeTouroUltimaInseminacao,
                                                                              brincoVacaAtual: animaisExistentesOfflineItem.brincoAnimal.toString(),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).then((value) =>
                                                                        safeSetState(
                                                                            () {}));
                                                                  },
                                                                  text: 'Parto',
                                                                  icon: Icon(
                                                                    Icons
                                                                        .add_alert,
                                                                    size: 15.0,
                                                                  ),
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width:
                                                                        100.0,
                                                                    height:
                                                                        40.0,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: Color(
                                                                        0xFF12BE24),
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        3.0,
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              Builder(
                                builder: (context) {
                                  final animaisProdutoresOffline = FFAppState()
                                      .animaisProdutoresOffline
                                      .map((e) => e)
                                      .toList()
                                      .sortedList(
                                          keyOf: (e) =>
                                              e.compararDtUltimaInseminacao,
                                          desc: false)
                                      .toList();

                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: animaisProdutoresOffline.length,
                                    itemBuilder: (context,
                                        animaisProdutoresOfflineIndex) {
                                      final animaisProdutoresOfflineItem =
                                          animaisProdutoresOffline[
                                              animaisProdutoresOfflineIndex];
                                      return Visibility(
                                        visible: (animaisProdutoresOfflineItem
                                                    .uidTecnicoPropriedade ==
                                                widget.uidPropriedade) &&
                                            (animaisProdutoresOfflineItem
                                                    .status ==
                                                'Pré Parto') &&
                                            (dateTimeFormat(
                                                  "d/M/y",
                                                  animaisProdutoresOfflineItem
                                                      .compararDtUltimaInseminacao,
                                                  locale: FFLocalizations.of(
                                                          context)
                                                      .languageCode,
                                                ) !=
                                                '31/12/2050'),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 8.0, 16.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                ProntuarioAnimalWidget
                                                    .routeName,
                                                queryParameters: {
                                                  'uidPropriedade':
                                                      serializeParam(
                                                    widget.uidPropriedade,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'nomePropriedade':
                                                      serializeParam(
                                                    widget.nomePropriedade,
                                                    ParamType.String,
                                                  ),
                                                  'uidTecnico': serializeParam(
                                                    widget.uidTecnico,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'emailPropriedade':
                                                      serializeParam(
                                                    widget.emailPropriedade,
                                                    ParamType.String,
                                                  ),
                                                  'uidAnimaisProdutores':
                                                      serializeParam(
                                                    animaisProdutoresOfflineItem
                                                        .uidAnimal,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'grupoPredominante':
                                                      serializeParam(
                                                    animaisProdutoresOfflineItem
                                                        .grupoAnimal,
                                                    ParamType.String,
                                                  ),
                                                  'visitaPresencial':
                                                      serializeParam(
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
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 10.0, 0.0, 10.0),
                                                child: ListView(
                                                  padding: EdgeInsets.zero,
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          10.0),
                                                              child: Container(
                                                                width: 44.0,
                                                                height: 44.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: () {
                                                                    if (ehVaca(
                                                                        animaisProdutoresOfflineItem
                                                                            .grupoAnimal)) {
                                                                      return Color(
                                                                          0xFF048508);
                                                                    } else if (ehNovilha(
                                                                        animaisProdutoresOfflineItem
                                                                            .grupoAnimal)) {
                                                                      return Color(
                                                                          0xFFFF0076);
                                                                    } else {
                                                                      return Color(
                                                                          0x00000000);
                                                                    }
                                                                  }(),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                child: Text(
                                                                  () {
                                                                    if (ehVaca(
                                                                        animaisProdutoresOfflineItem
                                                                            .grupoAnimal)) {
                                                                      return 'VAC';
                                                                    } else if (ehNovilha(
                                                                        animaisProdutoresOfflineItem
                                                                            .grupoAnimal)) {
                                                                      return 'NOV';
                                                                    } else {
                                                                      return 'N/C';
                                                                    }
                                                                  }(),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            13.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              () {
                                                                if ((animaisProdutoresOfflineItem
                                                                            .nomeAnimal !=
                                                                        '') &&
                                                                    (animaisProdutoresOfflineItem
                                                                            .brincoAnimal !=
                                                                        null) &&
                                                                    (animaisProdutoresOfflineItem
                                                                            .brincoAnimal !=
                                                                        -1)) {
                                                                  return '${animaisProdutoresOfflineItem.nomeAnimal} - ${animaisProdutoresOfflineItem.brincoAnimal.toString()}';
                                                                } else if (animaisProdutoresOfflineItem
                                                                        .nomeAnimal !=
                                                                    '') {
                                                                  return animaisProdutoresOfflineItem
                                                                      .nomeAnimal;
                                                                } else {
                                                                  return animaisProdutoresOfflineItem
                                                                      .brincoAnimal
                                                                      .toString();
                                                                }
                                                              }(),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLarge
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Inseminada em: ${animaisProdutoresOfflineItem.dtUltimaInseminacao}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Pré parto prev.: ${animaisProdutoresOfflineItem.dtPrePartoPrevista}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Parto previsto: ${animaisProdutoresOfflineItem.dtPartoPrevisto}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  5.0,
                                                                  0.0,
                                                                  15.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        10.0,
                                                                        0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      await showModalBottomSheet(
                                                                        isScrollControlled:
                                                                            true,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        enableDrag:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              FocusScope.of(context).unfocus();
                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: MediaQuery.viewInsetsOf(context),
                                                                              child: RegistroAbortoOfflineWidget(
                                                                                uidPropriedade: widget.uidPropriedade!,
                                                                                nomePropriedade: widget.nomePropriedade!,
                                                                                uidTecnico: widget.uidTecnico!,
                                                                                emailPropriedade: widget.emailPropriedade!,
                                                                                visitaPresencial: widget.visitaPresencial!,
                                                                                diasDg: widget.diasDg!,
                                                                                nomeAnimal: animaisProdutoresOfflineItem.nomeAnimal,
                                                                                itemUidIndex: animaisProdutoresOfflineItem.itemUidIndexAtual,
                                                                                uidAnimalOffline: animaisProdutoresOfflineItem.uidAnimalOffline,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ).then((value) =>
                                                                          safeSetState(
                                                                              () {}));
                                                                    },
                                                                    text:
                                                                        'Aborto',
                                                                    icon: Icon(
                                                                      Icons
                                                                          .cancel_sharp,
                                                                      size:
                                                                          15.0,
                                                                    ),
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width:
                                                                          100.0,
                                                                      height:
                                                                          40.0,
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              0.0),
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: Color(
                                                                          0xFFAE0303),
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.readexPro(
                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                            ),
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                      elevation:
                                                                          3.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        10.0,
                                                                        0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [],
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child:
                                                                    FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    await showModalBottomSheet(
                                                                      isScrollControlled:
                                                                          true,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      enableDrag:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            FocusScope.of(context).unfocus();
                                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                MediaQuery.viewInsetsOf(context),
                                                                            child:
                                                                                RegistrarPartoOfflineWidget(
                                                                              uidPropriedade: widget.uidPropriedade!,
                                                                              nomePropriedade: widget.nomePropriedade!,
                                                                              uidTecnico: widget.uidTecnico!,
                                                                              emailPropriedade: widget.emailPropriedade!,
                                                                              visitaPresencial: widget.visitaPresencial!,
                                                                              diasDg: widget.diasDg!,
                                                                              nomeVacaAtual: animaisProdutoresOfflineItem.nomeAnimal,
                                                                              nomeTourtoUltimaInseminacao: animaisProdutoresOfflineItem.nomeTouroUltimaInseminacao,
                                                                              brincoVacaAtual: animaisProdutoresOfflineItem.brincoAnimal.toString(),
                                                                              uidAnimalOffline: animaisProdutoresOfflineItem.uidAnimalOffline,
                                                                              itemUidIndex: animaisProdutoresOfflineItem.itemUidIndexAtual,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).then((value) =>
                                                                        safeSetState(
                                                                            () {}));
                                                                  },
                                                                  text: 'Parto',
                                                                  icon: Icon(
                                                                    Icons
                                                                        .add_alert,
                                                                    size: 15.0,
                                                                  ),
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width:
                                                                        100.0,
                                                                    height:
                                                                        40.0,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: Color(
                                                                        0xFF12BE24),
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        3.0,
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          primary: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Builder(
                                builder: (context) {
                                  final animaisExistenteOffline =
                                      _animaisExistentes.toList();

                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: animaisExistenteOffline.length,
                                    itemBuilder: (context,
                                        animaisExistenteOfflineIndex) {
                                      final animaisExistenteOfflineItem =
                                          animaisExistenteOffline[
                                              animaisExistenteOfflineIndex];
                                      return Visibility(
                                        visible: (animaisExistenteOfflineItem
                                                    .uidTecnicoPropriedade ==
                                                widget.uidPropriedade) &&
                                            (ehVazia(animaisExistenteOfflineItem
                                                .status)) &&
                                            (animaisExistenteOfflineItem
                                                    .dtInducaoLactacao !=
                                                null),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 8.0, 16.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                ProntuarioAnimalWidget
                                                    .routeName,
                                                queryParameters: {
                                                  'uidPropriedade':
                                                      serializeParam(
                                                    widget.uidPropriedade,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'nomePropriedade':
                                                      serializeParam(
                                                    widget.nomePropriedade,
                                                    ParamType.String,
                                                  ),
                                                  'uidTecnico': serializeParam(
                                                    widget.uidTecnico,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'emailPropriedade':
                                                      serializeParam(
                                                    widget.emailPropriedade,
                                                    ParamType.String,
                                                  ),
                                                  'uidAnimaisProdutores':
                                                      serializeParam(
                                                    animaisExistenteOfflineItem
                                                        .uidAnimal,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'grupoPredominante':
                                                      serializeParam(
                                                    animaisExistenteOfflineItem
                                                        .grupoAnimal,
                                                    ParamType.String,
                                                  ),
                                                  'visitaPresencial':
                                                      serializeParam(
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
                                            child: Container(
                                              width: double.infinity,
                                              height: 100.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: ListView(
                                                padding: EdgeInsets.zero,
                                                primary: false,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: Container(
                                                              width: 44.0,
                                                              height: 44.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: () {
                                                                  if (ehVaca(
                                                                      animaisExistenteOfflineItem
                                                                          .grupoAnimal)) {
                                                                    return Color(
                                                                        0xFF048508);
                                                                  } else if (ehNovilha(
                                                                      animaisExistenteOfflineItem
                                                                          .grupoAnimal)) {
                                                                    return Color(
                                                                        0xFFFF0076);
                                                                  } else {
                                                                    return Color(
                                                                        0x00000000);
                                                                  }
                                                                }(),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              child: Text(
                                                                () {
                                                                  if (ehVaca(
                                                                      animaisExistenteOfflineItem
                                                                          .grupoAnimal)) {
                                                                    return 'VAC';
                                                                  } else if (ehNovilha(
                                                                      animaisExistenteOfflineItem
                                                                          .grupoAnimal)) {
                                                                    return 'NOV';
                                                                  } else {
                                                                    return 'N/C';
                                                                  }
                                                                }(),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    10.0,
                                                                    0.0,
                                                                    10.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              () {
                                                                if ((animaisExistenteOfflineItem
                                                                            .nomeAnimal !=
                                                                        '') &&
                                                                    (animaisExistenteOfflineItem
                                                                            .brincoAnimal !=
                                                                        null) &&
                                                                    (animaisExistenteOfflineItem
                                                                            .brincoAnimal !=
                                                                        -1)) {
                                                                  return '${animaisExistenteOfflineItem.nomeAnimal} - ${animaisExistenteOfflineItem.brincoAnimal.toString()}';
                                                                } else if (animaisExistenteOfflineItem
                                                                        .nomeAnimal !=
                                                                    '') {
                                                                  return animaisExistenteOfflineItem
                                                                      .nomeAnimal;
                                                                } else {
                                                                  return animaisExistenteOfflineItem
                                                                      .brincoAnimal
                                                                      .toString();
                                                                }
                                                              }(),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLarge
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontStyle,
                                                                    ),
                                                                    fontSize:
                                                                        14.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Indução lactação: ${animaisExistenteOfflineItem.dtInducaoLactacao?.toString()}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            FFButtonWidget(
                                                              onPressed:
                                                                  () async {
                                                                if ((animaisExistenteOfflineItem
                                                                            .grupoAnimal ==
                                                                        'Novilha') ||
                                                                    (ehNovilha(
                                                                        animaisExistenteOfflineItem
                                                                            .grupoAnimal))) {
                                                                  _animaisExistentes[
                                                                              animaisExistenteOfflineIndex]
                                                                          .grupoAnimal =
                                                                      'Vacas';
                                                                  safeSetState(
                                                                      () {});
                                                                }

                                                                await showModalBottomSheet(
                                                                  isScrollControlled:
                                                                      true,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  enableDrag:
                                                                      false,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        FocusScope.of(context)
                                                                            .unfocus();
                                                                        FocusManager
                                                                            .instance
                                                                            .primaryFocus
                                                                            ?.unfocus();
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            MediaQuery.viewInsetsOf(context),
                                                                        child:
                                                                            RegistrarPartoInduzidoWidget(
                                                                          uidPropriedade:
                                                                              widget.uidPropriedade!,
                                                                          nomePropriedade:
                                                                              widget.nomePropriedade!,
                                                                          uidTecnico:
                                                                              widget.uidTecnico!,
                                                                          emailPropriedade:
                                                                              widget.emailPropriedade!,
                                                                          visitaPresencial:
                                                                              widget.visitaPresencial!,
                                                                          diasDg:
                                                                              widget.diasDg!,
                                                                          uidAnimaisProdutores:
                                                                              animaisExistenteOfflineItem.uidAnimal!,
                                                                          nomeAnimal:
                                                                              animaisExistenteOfflineItem.nomeAnimal,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ).then((value) =>
                                                                    safeSetState(
                                                                        () {}));
                                                              },
                                                              text:
                                                                  'Induzir lactação',
                                                              icon: Icon(
                                                                Icons.add_alert,
                                                                size: 15.0,
                                                              ),
                                                              options:
                                                                  FFButtonOptions(
                                                                width: 140.0,
                                                                height: 40.0,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0.0),
                                                                iconPadding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                color: Color(
                                                                    0xFF12BE24),
                                                                textStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontStyle,
                                                                    ),
                                                                elevation: 3.0,
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .transparent,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
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
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              Builder(
                                builder: (context) {
                                  final animaisProdutoresOfflineInducao =
                                      FFAppState()
                                          .animaisProdutoresOffline
                                          .toList();

                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount:
                                        animaisProdutoresOfflineInducao.length,
                                    itemBuilder: (context,
                                        animaisProdutoresOfflineInducaoIndex) {
                                      final animaisProdutoresOfflineInducaoItem =
                                          animaisProdutoresOfflineInducao[
                                              animaisProdutoresOfflineInducaoIndex];
                                      return Visibility(
                                        visible: (animaisProdutoresOfflineInducaoItem
                                                    .uidTecnicoPropriedade ==
                                                widget.uidPropriedade) &&
                                            (ehVazia(
                                                animaisProdutoresOfflineInducaoItem
                                                    .status)) &&
                                            (animaisProdutoresOfflineInducaoItem
                                                    .dtInducaoLactacao !=
                                                null),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 8.0, 16.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {},
                                            child: Container(
                                              width: double.infinity,
                                              height: 100.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: ListView(
                                                padding: EdgeInsets.zero,
                                                primary: false,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: Container(
                                                              width: 44.0,
                                                              height: 44.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: () {
                                                                  if (ehVaca(
                                                                      animaisProdutoresOfflineInducaoItem
                                                                          .grupoAnimal)) {
                                                                    return Color(
                                                                        0xFF048508);
                                                                  } else if (ehNovilha(
                                                                      animaisProdutoresOfflineInducaoItem
                                                                          .grupoAnimal)) {
                                                                    return Color(
                                                                        0xFFFF0076);
                                                                  } else {
                                                                    return Color(
                                                                        0x00000000);
                                                                  }
                                                                }(),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              child: Text(
                                                                () {
                                                                  if (ehVaca(
                                                                      animaisProdutoresOfflineInducaoItem
                                                                          .grupoAnimal)) {
                                                                    return 'VAC';
                                                                  } else if (ehNovilha(
                                                                      animaisProdutoresOfflineInducaoItem
                                                                          .grupoAnimal)) {
                                                                    return 'NOV';
                                                                  } else {
                                                                    return 'N/C';
                                                                  }
                                                                }(),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    10.0,
                                                                    0.0,
                                                                    10.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              () {
                                                                if ((animaisProdutoresOfflineInducaoItem
                                                                            .nomeAnimal !=
                                                                        '') &&
                                                                    (animaisProdutoresOfflineInducaoItem
                                                                            .brincoAnimal !=
                                                                        null) &&
                                                                    (animaisProdutoresOfflineInducaoItem
                                                                            .brincoAnimal !=
                                                                        -1)) {
                                                                  return '${animaisProdutoresOfflineInducaoItem.nomeAnimal} - ${animaisProdutoresOfflineInducaoItem.brincoAnimal.toString()}';
                                                                } else if (animaisProdutoresOfflineInducaoItem
                                                                        .nomeAnimal !=
                                                                    '') {
                                                                  return animaisProdutoresOfflineInducaoItem
                                                                      .nomeAnimal;
                                                                } else {
                                                                  return animaisProdutoresOfflineInducaoItem
                                                                      .brincoAnimal
                                                                      .toString();
                                                                }
                                                              }(),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLarge
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontStyle,
                                                                    ),
                                                                    fontSize:
                                                                        14.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            Text(
                                                              'Indução lactação: ${animaisProdutoresOfflineInducaoItem.dtInducaoLactacao?.toString()}',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    fontSize:
                                                                        13.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            FFButtonWidget(
                                                              onPressed:
                                                                  () async {
                                                                if ((animaisProdutoresOfflineInducaoItem
                                                                            .grupoAnimal ==
                                                                        'Novilha') ||
                                                                    (ehNovilha(
                                                                        animaisProdutoresOfflineInducaoItem
                                                                            .grupoAnimal))) {
                                                                  FFAppState()
                                                                      .updateAnimaisProdutoresOfflineAtIndex(
                                                                    animaisProdutoresOfflineInducaoIndex,
                                                                    (e) => e
                                                                      ..grupoAnimal =
                                                                          'Vacas',
                                                                  );
                                                                  safeSetState(
                                                                      () {});
                                                                }

                                                                await showModalBottomSheet(
                                                                  isScrollControlled:
                                                                      true,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  enableDrag:
                                                                      false,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        FocusScope.of(context)
                                                                            .unfocus();
                                                                        FocusManager
                                                                            .instance
                                                                            .primaryFocus
                                                                            ?.unfocus();
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            MediaQuery.viewInsetsOf(context),
                                                                        child:
                                                                            RegistrarPartoInduzidoOfflineWidget(
                                                                          uidPropriedade:
                                                                              widget.uidPropriedade!,
                                                                          nomePropriedade:
                                                                              widget.nomePropriedade!,
                                                                          uidTecnico:
                                                                              widget.uidTecnico!,
                                                                          emailPropriedade:
                                                                              widget.emailPropriedade!,
                                                                          visitaPresencial:
                                                                              widget.visitaPresencial!,
                                                                          diasDg:
                                                                              widget.diasDg!,
                                                                          nomeAnimal:
                                                                              animaisProdutoresOfflineInducaoItem.nomeAnimal,
                                                                          itemUidIndex:
                                                                              animaisProdutoresOfflineInducaoIndex,
                                                                          uidAnimalOffline:
                                                                              animaisProdutoresOfflineInducaoItem.uidAnimalOffline,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ).then((value) =>
                                                                    safeSetState(
                                                                        () {}));
                                                              },
                                                              text:
                                                                  'Induzir lactação',
                                                              icon: Icon(
                                                                Icons.add_alert,
                                                                size: 15.0,
                                                              ),
                                                              options:
                                                                  FFButtonOptions(
                                                                width: 140.0,
                                                                height: 40.0,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0.0),
                                                                iconPadding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                color: Color(
                                                                    0xFF12BE24),
                                                                textStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontStyle,
                                                                    ),
                                                                elevation: 3.0,
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .transparent,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
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
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          primary: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Builder(
                                builder: (context) {
                                  final animaisExistentesOfflineDescarte =
                                      _animaisExistentes.toList();

                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount:
                                        animaisExistentesOfflineDescarte.length,
                                    itemBuilder: (context,
                                        animaisExistentesOfflineDescarteIndex) {
                                      final animaisExistentesOfflineDescarteItem =
                                          animaisExistentesOfflineDescarte[
                                              animaisExistentesOfflineDescarteIndex];
                                      return Visibility(
                                        visible: (animaisExistentesOfflineDescarteItem
                                                    .uidTecnicoPropriedade ==
                                                widget.uidPropriedade) &&
                                            (ehDescarte(
                                                animaisExistentesOfflineDescarteItem
                                                    .status)),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 8.0, 16.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                ProntuarioAnimalWidget
                                                    .routeName,
                                                queryParameters: {
                                                  'uidPropriedade':
                                                      serializeParam(
                                                    widget.uidPropriedade,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'nomePropriedade':
                                                      serializeParam(
                                                    widget.nomePropriedade,
                                                    ParamType.String,
                                                  ),
                                                  'uidTecnico': serializeParam(
                                                    widget.uidTecnico,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'emailPropriedade':
                                                      serializeParam(
                                                    widget.emailPropriedade,
                                                    ParamType.String,
                                                  ),
                                                  'uidAnimaisProdutores':
                                                      serializeParam(
                                                    animaisExistentesOfflineDescarteItem
                                                        .uidAnimal,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'grupoPredominante':
                                                      serializeParam(
                                                    animaisExistentesOfflineDescarteItem
                                                        .grupoAnimal,
                                                    ParamType.String,
                                                  ),
                                                  'visitaPresencial':
                                                      serializeParam(
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
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: ListView(
                                                padding: EdgeInsets.zero,
                                                primary: false,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: Container(
                                                              width: 44.0,
                                                              height: 44.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: () {
                                                                  if (ehVaca(
                                                                      animaisExistentesOfflineDescarteItem
                                                                          .grupoAnimal)) {
                                                                    return Color(
                                                                        0xFF048508);
                                                                  } else if (ehNovilha(
                                                                      animaisExistentesOfflineDescarteItem
                                                                          .grupoAnimal)) {
                                                                    return Color(
                                                                        0xFFFF0076);
                                                                  } else {
                                                                    return Color(
                                                                        0x00000000);
                                                                  }
                                                                }(),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              child: Text(
                                                                () {
                                                                  if (ehVaca(
                                                                      animaisExistentesOfflineDescarteItem
                                                                          .grupoAnimal)) {
                                                                    return 'VAC';
                                                                  } else if (ehNovilha(
                                                                      animaisExistentesOfflineDescarteItem
                                                                          .grupoAnimal)) {
                                                                    return 'NOV';
                                                                  } else {
                                                                    return 'N/C';
                                                                  }
                                                                }(),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            () {
                                                              if ((animaisExistentesOfflineDescarteItem
                                                                          .nomeAnimal !=
                                                                      '') &&
                                                                  (animaisExistentesOfflineDescarteItem
                                                                          .brincoAnimal !=
                                                                      null) &&
                                                                  (animaisExistentesOfflineDescarteItem
                                                                          .brincoAnimal !=
                                                                      -1)) {
                                                                return '${animaisExistentesOfflineDescarteItem.nomeAnimal} - ${animaisExistentesOfflineDescarteItem.brincoAnimal.toString()}';
                                                              } else if (animaisExistentesOfflineDescarteItem
                                                                      .nomeAnimal !=
                                                                  '') {
                                                                return animaisExistentesOfflineDescarteItem
                                                                    .nomeAnimal;
                                                              } else {
                                                                return animaisExistentesOfflineDescarteItem
                                                                    .brincoAnimal
                                                                    .toString();
                                                              }
                                                            }(),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyLarge
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        4.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              'Data do descarte: ${animaisExistentesOfflineDescarteItem.dtDescarteAnimal}',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        4.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              'Motivo: ${animaisExistentesOfflineDescarteItem.motivoDescarteAnimal}',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 15.0,
                                                                0.0, 15.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      10.0,
                                                                      0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child:
                                                                    FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    var confirmDialogResponse =
                                                                        await showDialog<bool>(
                                                                              context: context,
                                                                              builder: (alertDialogContext) {
                                                                                return AlertDialog(
                                                                                  title: Text('Deseja realmente restaurar  o animal?'),
                                                                                  content: Text('Ele voltará para a lista do rebanho com o status vazia.'),
                                                                                  actions: [
                                                                                    TextButton(
                                                                                      onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                      child: Text('Cancelar'),
                                                                                    ),
                                                                                    TextButton(
                                                                                      onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                      child: Text('Confirmar'),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            ) ??
                                                                            false;
                                                                    if (confirmDialogResponse) {
                                                                      _animaisExistentes[animaisExistentesOfflineDescarteIndex]
                                                                              .status =
                                                                          'Vazia';
                                                                      safeSetState(
                                                                          () {});
                                                                      FFAppState()
                                                                          .addToAnimaisProdutoresEditados(
                                                                              AnimaisProdutoresStruct(
                                                                        uidTecnicoPropriedade: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.uidTecnicoPropriedade,
                                                                        nomeAnimal: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.nomeAnimal,
                                                                        racaAnimal: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.racaAnimal,
                                                                        pesoAnimal: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.pesoAnimal,
                                                                        dtNascimento: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.dtNascimento,
                                                                        touro: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.touro,
                                                                        vaca: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.vaca,
                                                                        status:
                                                                            'Vazia',
                                                                        grupoAnimal: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.grupoAnimal,
                                                                        dtUltimaInseminacao: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.dtUltimaInseminacao,
                                                                        dtUltimoParto: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.dtUltimoParto,
                                                                        liberaInseminacao: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.liberaInseminacao,
                                                                        dtPartoPrevisto: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.dtPartoPrevisto,
                                                                        dtSecPrevista: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.dtSecPrevista,
                                                                        dtPrePartoPrevista: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.dtPrePartoPrevista,
                                                                        dtPP: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.dtPP,
                                                                        dtDgMais: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.dtDgMais,
                                                                        dtDgMenos: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.dtDgMenos,
                                                                        dtAborto: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.dtAborto,
                                                                        dtSecagem: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.dtSecagem,
                                                                        dtUltimoPP: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.dtUltimoPP,
                                                                        nomeTouroUltimaInseminacao: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.nomeTouroUltimaInseminacao,
                                                                        totalInseminacoes: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.totalInseminacoes,
                                                                        totalPartos: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.totalPartos,
                                                                        dtPreParto: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.dtPreParto,
                                                                        motivoDescarteAnimal: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.motivoDescarteAnimal,
                                                                        dtDescarteAnimal: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.dtDescarteAnimal,
                                                                        dtUltimaAcao: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.dtUltimaAcao,
                                                                        compararDtUltimaInseminacao: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.compararDtUltimaInseminacao,
                                                                        nomeBrincoConcat: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.nomeBrincoConcat,
                                                                        idGrupoAnimal: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.idGrupoAnimal,
                                                                        dtUltimoPartoContingencia: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.dtUltimoPartoContingencia,
                                                                        idStatusAnimal: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.idStatusAnimal,
                                                                        dtInducaoLactacao: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.dtInducaoLactacao,
                                                                        dtDesmame: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.dtDesmame,
                                                                        brincoAnimal: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.brincoAnimal,
                                                                        brincoAnimalOrder: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.brincoAnimalOrder,
                                                                        uidAnimal: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.uidAnimal,
                                                                        uidAnimalOffline: _animaisExistentes
                                                                            .elementAtOrNull(animaisExistentesOfflineDescarteIndex)
                                                                            ?.uidAnimalOffline,
                                                                      ));
                                                                      safeSetState(
                                                                          () {});
                                                                      Navigator.pop(
                                                                          context);
                                                                      return;
                                                                    } else {
                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  },
                                                                  text:
                                                                      'Restaurar',
                                                                  icon: Icon(
                                                                    Icons
                                                                        .restore,
                                                                    size: 15.0,
                                                                  ),
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width:
                                                                        100.0,
                                                                    height:
                                                                        40.0,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: Color(
                                                                        0xFF12BE24),
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        3.0,
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      10.0,
                                                                      0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [],
                                                          ),
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child:
                                                                  FFButtonWidget(
                                                                onPressed:
                                                                    () async {
                                                                  var confirmDialogResponse =
                                                                      await showDialog<
                                                                              bool>(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (alertDialogContext) {
                                                                              return AlertDialog(
                                                                                title: Text('Deseja realmente apagar o animal?'),
                                                                                content: Text('Essa ação é irreversível.'),
                                                                                actions: [
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                    child: Text('Cancelar'),
                                                                                  ),
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                    child: Text('Confirmar'),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          ) ??
                                                                          false;
                                                                  if (confirmDialogResponse) {
                                                                    FFAppState()
                                                                        .addToAnimaisApagadosExistentesOffline(
                                                                            AnimaisApagadosExistentesOfflineStruct(
                                                                      uidAnimal:
                                                                          animaisExistentesOfflineDescarteItem
                                                                              .uidAnimal,
                                                                      uidTecnicoPropriedade:
                                                                          widget
                                                                              .uidPropriedade,
                                                                    ));
                                                                    safeSetState(
                                                                        () {});
                                                                    _animaisExistentes
                                                                        .removeAt(
                                                                            animaisExistentesOfflineDescarteIndex);
                                                                    safeSetState(
                                                                        () {});
                                                                    Navigator.pop(
                                                                        context);
                                                                    return;
                                                                  } else {
                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                },
                                                                text:
                                                                    'Eliminar',
                                                                icon: Icon(
                                                                  Icons.clear,
                                                                  size: 15.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  width: 100.0,
                                                                  height: 40.0,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0.0),
                                                                  iconPadding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  color: Color(
                                                                      0xFFAE0303),
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                  elevation:
                                                                      3.0,
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 1.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
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
                                },
                              ),
                              Builder(
                                builder: (context) {
                                  final animaisProdutoresOfflineDescarte =
                                      FFAppState()
                                          .animaisProdutoresOffline
                                          .toList();

                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount:
                                        animaisProdutoresOfflineDescarte.length,
                                    itemBuilder: (context,
                                        animaisProdutoresOfflineDescarteIndex) {
                                      final animaisProdutoresOfflineDescarteItem =
                                          animaisProdutoresOfflineDescarte[
                                              animaisProdutoresOfflineDescarteIndex];
                                      return Visibility(
                                        visible: (animaisProdutoresOfflineDescarteItem
                                                    .uidTecnicoPropriedade ==
                                                widget.uidPropriedade) &&
                                            (ehDescarte(
                                                animaisProdutoresOfflineDescarteItem
                                                    .status)),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 8.0, 16.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {},
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: ListView(
                                                padding: EdgeInsets.zero,
                                                primary: false,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: Container(
                                                              width: 44.0,
                                                              height: 44.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: () {
                                                                  if (ehVaca(
                                                                      animaisProdutoresOfflineDescarteItem
                                                                          .grupoAnimal)) {
                                                                    return Color(
                                                                        0xFF048508);
                                                                  } else if (ehNovilha(
                                                                      animaisProdutoresOfflineDescarteItem
                                                                          .grupoAnimal)) {
                                                                    return Color(
                                                                        0xFFFF0076);
                                                                  } else {
                                                                    return Color(
                                                                        0x00000000);
                                                                  }
                                                                }(),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              child: Text(
                                                                () {
                                                                  if (ehVaca(
                                                                      animaisProdutoresOfflineDescarteItem
                                                                          .grupoAnimal)) {
                                                                    return 'VAC';
                                                                  } else if (ehNovilha(
                                                                      animaisProdutoresOfflineDescarteItem
                                                                          .grupoAnimal)) {
                                                                    return 'NOV';
                                                                  } else {
                                                                    return 'N/C';
                                                                  }
                                                                }(),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .readexPro(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            () {
                                                              if ((animaisProdutoresOfflineDescarteItem
                                                                          .nomeAnimal !=
                                                                      '') &&
                                                                  (animaisProdutoresOfflineDescarteItem
                                                                          .brincoAnimal !=
                                                                      null) &&
                                                                  (animaisProdutoresOfflineDescarteItem
                                                                          .brincoAnimal !=
                                                                      -1)) {
                                                                return '${animaisProdutoresOfflineDescarteItem.nomeAnimal} - ${animaisProdutoresOfflineDescarteItem.brincoAnimal.toString()}';
                                                              } else if (animaisProdutoresOfflineDescarteItem
                                                                      .nomeAnimal !=
                                                                  '') {
                                                                return animaisProdutoresOfflineDescarteItem
                                                                    .nomeAnimal;
                                                              } else {
                                                                return animaisProdutoresOfflineDescarteItem
                                                                    .brincoAnimal
                                                                    .toString();
                                                              }
                                                            }(),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyLarge
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        4.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              'Data do descarte: ${animaisProdutoresOfflineDescarteItem.dtDescarteAnimal}',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        4.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              'Motivo: ${animaisProdutoresOfflineDescarteItem.motivoDescarteAnimal}',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .readexPro(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 15.0,
                                                                0.0, 15.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      10.0,
                                                                      0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child:
                                                                    FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    var confirmDialogResponse =
                                                                        await showDialog<bool>(
                                                                              context: context,
                                                                              builder: (alertDialogContext) {
                                                                                return AlertDialog(
                                                                                  title: Text('Deseja realmente restaurar  o animal?'),
                                                                                  content: Text('Ele voltará para a lista do rebanho com o status vazia.'),
                                                                                  actions: [
                                                                                    TextButton(
                                                                                      onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                      child: Text('Cancelar'),
                                                                                    ),
                                                                                    TextButton(
                                                                                      onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                      child: Text('Confirmar'),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            ) ??
                                                                            false;
                                                                    if (confirmDialogResponse) {
                                                                      FFAppState()
                                                                          .updateAnimaisProdutoresOfflineAtIndex(
                                                                        animaisProdutoresOfflineDescarteIndex,
                                                                        (e) => e
                                                                          ..status =
                                                                              'Vazia',
                                                                      );
                                                                      safeSetState(
                                                                          () {});
                                                                      Navigator.pop(
                                                                          context);
                                                                      return;
                                                                    } else {
                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  },
                                                                  text:
                                                                      'Restaurar',
                                                                  icon: Icon(
                                                                    Icons
                                                                        .restore,
                                                                    size: 15.0,
                                                                  ),
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width:
                                                                        100.0,
                                                                    height:
                                                                        40.0,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: Color(
                                                                        0xFF12BE24),
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        3.0,
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      10.0,
                                                                      0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [],
                                                          ),
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child:
                                                                  FFButtonWidget(
                                                                onPressed:
                                                                    () async {
                                                                  var confirmDialogResponse =
                                                                      await showDialog<
                                                                              bool>(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (alertDialogContext) {
                                                                              return AlertDialog(
                                                                                title: Text('Deseja realmente apagar o animal?'),
                                                                                content: Text('Essa ação é irreversível.'),
                                                                                actions: [
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                    child: Text('Cancelar'),
                                                                                  ),
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                    child: Text('Confirmar'),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          ) ??
                                                                          false;
                                                                  if (confirmDialogResponse) {
                                                                    FFAppState()
                                                                        .removeAtIndexFromAnimaisProdutoresOffline(
                                                                            animaisProdutoresOfflineDescarteIndex);
                                                                    safeSetState(
                                                                        () {});
                                                                    Navigator.pop(
                                                                        context);
                                                                    return;
                                                                  } else {
                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                },
                                                                text:
                                                                    'Eliminar',
                                                                icon: Icon(
                                                                  Icons.clear,
                                                                  size: 15.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  width: 100.0,
                                                                  height: 40.0,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0.0),
                                                                  iconPadding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  color: Color(
                                                                      0xFFAE0303),
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                  elevation:
                                                                      3.0,
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 1.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
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
                                },
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
          ],
        ),
      ),
    );
  }
}
