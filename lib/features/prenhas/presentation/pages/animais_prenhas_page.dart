// ignore_for_file: unnecessary_null_comparison, unused_import

import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/domain/animais/classificacao_animal.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/instant_timer.dart';
import '/features/animais/presentation/widgets/descarte_animal_widget.dart';
import '../widgets/registrar_secagem_widget.dart';
import '../widgets/registro_aborto_widget.dart';
import '/features/sincronizacao/presentation/widgets/alerta_sem_internet_widget.dart';
import '/core/services/index.dart' as actions;
import '/core/ui/custom_functions.dart' as functions;
import '/features/propriedades/presentation/pages/inicio_propriedade_page.dart';
import '/features/prontuario/presentation/pages/prontuario_animal_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AnimaisPrenhasPage extends StatefulWidget {
  const AnimaisPrenhasPage({
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

  static String routeName = 'animaisPrenhas';
  static String routePath = '/animaisPrenhas';

  @override
  State<AnimaisPrenhasPage> createState() => _AnimaisPrenhasPageState();
}

class _AnimaisPrenhasPageState extends State<AnimaisPrenhasPage> {
  InstantTimer? _instantTimer;
  bool? _respostaNet = true;

  /// Lista de animais existentes (fonte ObjectBox). Antes em
  /// FFAppState.animaisProdutoresExistentes; agora estado local desta tela.
  List<AnimaisProdutoresStruct> _animaisExistentes = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

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

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _instantTimer?.cancel();

    super.dispose();
  }

  /// Card extraído do build (Fase 4).
  Widget _buildCard1(
      BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Visibility(
      visible: (item.uidTecnicoPropriedade == widget.uidPropriedade) &&
          ehVacaPrenha(item.grupoAnimal, item.status) &&
          (dateTimeFormat(
                "d/M/y",
                item.compararDtUltimaInseminacao,
                locale: FFLocalizations.of(context).languageCode,
              ) !=
              '31/12/2050'),
      child: Align(
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              boxShadow: [
                BoxShadow(
                  blurRadius: 0.0,
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  offset: Offset(
                    0.0,
                    1.0,
                  ),
                )
              ],
              borderRadius: BorderRadius.circular(0.0),
              border: Border.all(
                color: FlutterFlowTheme.of(context).primaryBackground,
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  context.pushNamed(
                    ProntuarioAnimalPage.routeName,
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
                      'uidAnimaisProdutores': serializeParam(
                        item.uidAnimal,
                        ParamType.DocumentReference,
                      ),
                      'grupoPredominante': serializeParam(
                        item.grupoAnimal,
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
                onLongPress: () async {},
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [_part1(context, item, index)],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _part1(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Expanded(
      child: GridView(
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 0.0,
          childAspectRatio: 2.0,
        ),
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          _part2(context, item, index),
          _part3(context, item, index),
          _part4(context, item, index),
          _part5(context, item, index),
          _part6(context, item, index),
          _part7(context, item, index)
        ],
      ),
    );
  }

  Widget _part2(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            color: () {
              if (ehVaca(item.grupoAnimal)) {
                return Color(0xFF048508);
              } else if (ehNovilha(item.grupoAnimal)) {
                return Color(0xFFFF0076);
              } else {
                return Color(0x00000000);
              }
            }(),
            shape: BoxShape.circle,
          ),
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Text(
            () {
              if (ehVaca(item.grupoAnimal)) {
                return 'VAC';
              } else if (ehNovilha(item.grupoAnimal)) {
                return 'NOV';
              } else {
                return 'N/C';
              }
            }(),
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleMedium.fontStyle,
                  ),
                  color: Colors.white,
                  fontSize: 13.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                ),
          ),
        ),
      ],
    );
  }

  Widget _part3(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            () {
              if ((item.nomeAnimal != '') &&
                  (item.brincoAnimal != null) &&
                  (item.brincoAnimal != -1)) {
                return '${item.nomeAnimal} - ${item.brincoAnimal.toString()}';
              } else if (item.nomeAnimal != '') {
                return item.nomeAnimal;
              } else {
                return item.brincoAnimal.toString();
              }
            }(),
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  font: GoogleFonts.readexPro(
                    fontWeight: FontWeight.bold,
                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                  ),
                  fontSize: 13.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                ),
          ),
          Text(
            'Prev. do parto:',
            style: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  fontSize: 10.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
          ),
          Text(
            item.dtPartoPrevisto,
            style: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  fontSize: 10.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
          ),
        ],
      ),
    );
  }

  Widget _part4(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inseminada em:',
          style: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                fontSize: 10.0,
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
        ),
        Text(
          item.dtUltimaInseminacao,
          style: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                fontSize: 10.0,
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
        ),
      ],
    );
  }

  Widget _part5(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
          child: FFButtonWidget(
            onPressed: () async {
              await showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                enableDrag: false,
                context: context,
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: Padding(
                      padding: MediaQuery.viewInsetsOf(context),
                      child: RegistroAbortoWidget(
                        uidPropriedade: widget.uidPropriedade!,
                        nomePropriedade: widget.nomePropriedade!,
                        uidTecnico: widget.uidTecnico!,
                        emailPropriedade: widget.emailPropriedade!,
                        visitaPresencial: widget.visitaPresencial!,
                        diasDg: widget.diasDg!,
                        uidAnimaisProdutores: item.uidAnimal,
                        uidAnimalOffline: item.uidAnimalOffline,
                        nomeAnimal: item.nomeAnimal,
                      ),
                    ),
                  );
                },
              ).then((value) => safeSetState(() {}));
            },
            text: 'Aborto',
            icon: Icon(
              Icons.check_circle_outline_sharp,
              size: 15.0,
            ),
            options: FFButtonOptions(
              width: 100.0,
              height: 40.0,
              padding: EdgeInsets.all(0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: Color(0xFFAE0303),
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.readexPro(
                      fontWeight:
                          FlutterFlowTheme.of(context).titleSmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleSmall.fontStyle,
                    ),
                    color: Colors.white,
                    fontSize: 12.0,
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
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _part6(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sc. prevista:',
            style: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).error,
                  fontSize: 10.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
          ),
          Text(
            item.dtSecPrevista,
            style: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).error,
                  fontSize: 10.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
          ),
        ],
      ),
    );
  }

  Widget _part7(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
          child: FFButtonWidget(
            onPressed: () async {
              await showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                enableDrag: false,
                context: context,
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: Padding(
                      padding: MediaQuery.viewInsetsOf(context),
                      child: RegistrarSecagemWidget(
                        uidPropriedade: widget.uidPropriedade!,
                        nomePropriedade: widget.nomePropriedade!,
                        uidTecnico: widget.uidTecnico!,
                        emailPropriedade: widget.emailPropriedade!,
                        visitaPresencial: widget.visitaPresencial!,
                        diasDg: widget.diasDg!,
                        uidAnimaisProdutores: item.uidAnimal,
                        uidAnimalOffline: item.uidAnimalOffline,
                        nomeAnimal: item.nomeAnimal,
                        brincoAnimal: item.brincoAnimal.toString(),
                        grupoAnimal: item.grupoAnimal,
                        dtSecPrevista: functions
                            .converteDataStringDate(item.dtSecPrevista),
                      ),
                    ),
                  );
                },
              ).then((value) => safeSetState(() {}));
            },
            text: 'Secagem',
            icon: Icon(
              Icons.cancel_rounded,
              size: 15.0,
            ),
            options: FFButtonOptions(
              width: 100.0,
              height: 40.0,
              padding: EdgeInsets.all(0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: Color(0xFFE9AB05),
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.readexPro(
                      fontWeight:
                          FlutterFlowTheme.of(context).titleSmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleSmall.fontStyle,
                    ),
                    color: Colors.white,
                    fontSize: 12.0,
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
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // context.watch<FFAppState>();

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
          child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF75E38), Color(0xFFEC3B5B)],
                  begin: AlignmentDirectional(-1.0, -1.0),
                  end: AlignmentDirectional(1.0, 1.0),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.0),
                  bottomRight: Radius.circular(24.0),
                ),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
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
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 0.0, 0.0),
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
                                  InicioPropriedadePage.routeName,
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
                            'Prenhas',
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
              )),
        ),
        body: SingleChildScrollView(
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Builder(
                builder: (context) {
                  final animaisExistentes = _animaisExistentes
                      .map((e) => e)
                      .toList()
                      .sortedList(
                          keyOf: (e) => e.compararDtUltimaInseminacao,
                          desc: false)
                      .toList();

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: animaisExistentes.length,
                    itemBuilder: (context, animaisExistentesIndex) {
                      final animaisExistentesItem =
                          animaisExistentes[animaisExistentesIndex];
                      return _buildCard1(context, animaisExistentesItem,
                          animaisExistentesIndex);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
