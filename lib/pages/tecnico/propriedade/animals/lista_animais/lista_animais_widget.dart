// ignore_for_file: unnecessary_null_comparison

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/pages/tecnico/propriedade/sincronizacao/alerta_sem_internet/alerta_sem_internet_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import '/features/animais/presentation/animal_group_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'lista_animais_model.dart';
export 'lista_animais_model.dart';

class ListaAnimaisWidget extends StatefulWidget {
  const ListaAnimaisWidget({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    int? tabBarOpenSelected,
    required this.visitaPresencial,
    int? initialTabSelect,
    this.diasDg,
  })  : this.tabBarOpenSelected = tabBarOpenSelected ?? 1,
        this.initialTabSelect = initialTabSelect ?? 0;

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final int tabBarOpenSelected;
  final bool? visitaPresencial;
  final int initialTabSelect;
  final String? diasDg;

  static String routeName = 'listaAnimais';
  static String routePath = '/listaAnimais';

  @override
  State<ListaAnimaisWidget> createState() => _ListaAnimaisWidgetState();
}

class _ListaAnimaisWidgetState extends State<ListaAnimaisWidget>
    with TickerProviderStateMixin {
  late ListaAnimaisModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListaAnimaisModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.instantTimer = InstantTimer.periodic(
        duration: Duration(seconds: 5),
        callback: (timer) async {
          _model.respostaNet = await actions.checkInternetConnection();

          safeSetState(() {});
          if (_model.respostaNet!) {
            FFAppState().verificaInternet = -1;
            safeSetState(() {});
          } else {
            if (FFAppState().verificaInternet == -1) {
              FFAppState().verificaInternet = 0;
              safeSetState(() {});
              _model.instantTimer?.cancel();
              await showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                isDismissible: false,
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
                      child: AlertaSemInternetWidget(),
                    ),
                  );
                },
              ).then((value) => safeSetState(() {}));

              return;
            }
          }
        },
        startImmediately: false,
      );
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 6,
      initialIndex: min(
          valueOrDefault<int>(
            widget.initialTabSelect,
            0,
          ),
          5),
    )..addListener(() => safeSetState(() {}));

    _model.searchListBezerrasTextController ??= TextEditingController();
    _model.searchListBezerrasFocusNode ??= FocusNode();

    _model.searchListBezerrosTextController ??= TextEditingController();
    _model.searchListBezerrosFocusNode ??= FocusNode();

    _model.searchListNovilhasTextController ??= TextEditingController();
    _model.searchListNovilhasFocusNode ??= FocusNode();

    _model.searchListSemensTextController ??= TextEditingController();
    _model.searchListSemensFocusNode ??= FocusNode();

    _model.searchListTourosTextController ??= TextEditingController();
    _model.searchListTourosFocusNode ??= FocusNode();

    _model.searchListVacasTextController ??= TextEditingController();
    _model.searchListVacasFocusNode ??= FocusNode();

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
            backgroundColor:
                _model.respostaNet! ? Color(0xFFF75E38) : Color(0xFFF2886E),
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
                                  false,
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
                        'Animais',
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      unselectedLabelColor: Color(0xFF525D67),
                      backgroundColor: valueOrDefault<Color>(
                        _model.respostaNet!
                            ? Color(0xFFF75E38)
                            : Color(0xFFF2886E),
                        Color(0xFFF75E38),
                      ),
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
                          text: 'Bezerras',
                        ),
                        Tab(
                          text: 'Bezerros',
                        ),
                        Tab(
                          text: 'Novilhas',
                        ),
                        Tab(
                          text: 'Sêmens',
                        ),
                        Tab(
                          text: 'Touros',
                        ),
                        Tab(
                          text: 'Vacas',
                        ),
                      ],
                      controller: _model.tabBarController,
                      onTap: (i) async {
                        [
                          () async {},
                          () async {},
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
                        AnimalGroupListView(
                          propriedadePath: widget.uidPropriedade!.path,
                          grupo: 'Bezerras',
                          onEditAnimal: (firestoreId) {
                            context.pushNamed(
                              EditarAnimalWidget.routeName,
                              queryParameters: {
                                'uidPropriedade': serializeParam(
                                    widget.uidPropriedade,
                                    ParamType.DocumentReference),
                                'nomePropriedade': serializeParam(
                                    widget.nomePropriedade, ParamType.String),
                                'uidTecnico': serializeParam(widget.uidTecnico,
                                    ParamType.DocumentReference),
                                'emailPropriedade': serializeParam(
                                    widget.emailPropriedade, ParamType.String),
                                'grupoPredominante':
                                    serializeParam('Bezerras', ParamType.String),
                                'visitaPresencial': serializeParam(
                                    widget.visitaPresencial, ParamType.bool),
                                'initialTabSelect': serializeParam(
                                    widget.initialTabSelect, ParamType.int),
                                'uidAnimal': serializeParam(
                                    // Animais vivem sob o técnico
                                    FirebaseFirestore.instance.doc(
                                        '${widget.uidTecnico!.path}/animaisProdutores/$firestoreId'),
                                    ParamType.DocumentReference),
                                'diasDg': serializeParam(
                                    widget.diasDg, ParamType.String),
                              }.withoutNulls,
                            );
                          },
                        ),
                        AnimalGroupListView(
                          propriedadePath: widget.uidPropriedade!.path,
                          grupo: 'Bezerros',
                          onEditAnimal: (firestoreId) {
                            context.pushNamed(
                              EditarAnimalWidget.routeName,
                              queryParameters: {
                                'uidPropriedade': serializeParam(
                                    widget.uidPropriedade,
                                    ParamType.DocumentReference),
                                'nomePropriedade': serializeParam(
                                    widget.nomePropriedade, ParamType.String),
                                'uidTecnico': serializeParam(widget.uidTecnico,
                                    ParamType.DocumentReference),
                                'emailPropriedade': serializeParam(
                                    widget.emailPropriedade, ParamType.String),
                                'grupoPredominante':
                                    serializeParam('Bezerros', ParamType.String),
                                'visitaPresencial': serializeParam(
                                    widget.visitaPresencial, ParamType.bool),
                                'initialTabSelect': serializeParam(
                                    widget.initialTabSelect, ParamType.int),
                                'uidAnimal': serializeParam(
                                    // Animais vivem sob o técnico
                                    FirebaseFirestore.instance.doc(
                                        '${widget.uidTecnico!.path}/animaisProdutores/$firestoreId'),
                                    ParamType.DocumentReference),
                                'diasDg': serializeParam(
                                    widget.diasDg, ParamType.String),
                              }.withoutNulls,
                            );
                          },
                        ),
                        AnimalGroupListView(
                          propriedadePath: widget.uidPropriedade!.path,
                          grupo: 'Novilhas',
                          onEditAnimal: (firestoreId) {
                            context.pushNamed(
                              EditarAnimalWidget.routeName,
                              queryParameters: {
                                'uidPropriedade': serializeParam(
                                    widget.uidPropriedade,
                                    ParamType.DocumentReference),
                                'nomePropriedade': serializeParam(
                                    widget.nomePropriedade, ParamType.String),
                                'uidTecnico': serializeParam(widget.uidTecnico,
                                    ParamType.DocumentReference),
                                'emailPropriedade': serializeParam(
                                    widget.emailPropriedade, ParamType.String),
                                'grupoPredominante':
                                    serializeParam('Novilhas', ParamType.String),
                                'visitaPresencial': serializeParam(
                                    widget.visitaPresencial, ParamType.bool),
                                'initialTabSelect': serializeParam(
                                    widget.initialTabSelect, ParamType.int),
                                'uidAnimal': serializeParam(
                                    // Animais vivem sob o técnico
                                    FirebaseFirestore.instance.doc(
                                        '${widget.uidTecnico!.path}/animaisProdutores/$firestoreId'),
                                    ParamType.DocumentReference),
                                'diasDg': serializeParam(
                                    widget.diasDg, ParamType.String),
                              }.withoutNulls,
                            );
                          },
                        ),
                        AnimalGroupListView(
                          propriedadePath: widget.uidPropriedade!.path,
                          grupo: 'Sêmens',
                          onEditAnimal: (firestoreId) {
                            context.pushNamed(
                              EditarAnimalWidget.routeName,
                              queryParameters: {
                                'uidPropriedade': serializeParam(
                                    widget.uidPropriedade,
                                    ParamType.DocumentReference),
                                'nomePropriedade': serializeParam(
                                    widget.nomePropriedade, ParamType.String),
                                'uidTecnico': serializeParam(widget.uidTecnico,
                                    ParamType.DocumentReference),
                                'emailPropriedade': serializeParam(
                                    widget.emailPropriedade, ParamType.String),
                                'grupoPredominante':
                                    serializeParam('Sêmens', ParamType.String),
                                'visitaPresencial': serializeParam(
                                    widget.visitaPresencial, ParamType.bool),
                                'initialTabSelect': serializeParam(
                                    widget.initialTabSelect, ParamType.int),
                                'uidAnimal': serializeParam(
                                    // Animais vivem sob o técnico
                                    FirebaseFirestore.instance.doc(
                                        '${widget.uidTecnico!.path}/animaisProdutores/$firestoreId'),
                                    ParamType.DocumentReference),
                                'diasDg': serializeParam(
                                    widget.diasDg, ParamType.String),
                              }.withoutNulls,
                            );
                          },
                        ),
                        AnimalGroupListView(
                          propriedadePath: widget.uidPropriedade!.path,
                          grupo: 'Touros',
                          onEditAnimal: (firestoreId) {
                            context.pushNamed(
                              EditarAnimalWidget.routeName,
                              queryParameters: {
                                'uidPropriedade': serializeParam(
                                    widget.uidPropriedade,
                                    ParamType.DocumentReference),
                                'nomePropriedade': serializeParam(
                                    widget.nomePropriedade, ParamType.String),
                                'uidTecnico': serializeParam(widget.uidTecnico,
                                    ParamType.DocumentReference),
                                'emailPropriedade': serializeParam(
                                    widget.emailPropriedade, ParamType.String),
                                'grupoPredominante':
                                    serializeParam('Touros', ParamType.String),
                                'visitaPresencial': serializeParam(
                                    widget.visitaPresencial, ParamType.bool),
                                'initialTabSelect': serializeParam(
                                    widget.initialTabSelect, ParamType.int),
                                'uidAnimal': serializeParam(
                                    // Animais vivem sob o técnico
                                    FirebaseFirestore.instance.doc(
                                        '${widget.uidTecnico!.path}/animaisProdutores/$firestoreId'),
                                    ParamType.DocumentReference),
                                'diasDg': serializeParam(
                                    widget.diasDg, ParamType.String),
                              }.withoutNulls,
                            );
                          },
                        ),
                        AnimalGroupListView(
                          propriedadePath: widget.uidPropriedade!.path,
                          grupo: 'Vacas',
                          onEditAnimal: (firestoreId) {
                            context.pushNamed(
                              EditarAnimalWidget.routeName,
                              queryParameters: {
                                'uidPropriedade': serializeParam(
                                    widget.uidPropriedade,
                                    ParamType.DocumentReference),
                                'nomePropriedade': serializeParam(
                                    widget.nomePropriedade, ParamType.String),
                                'uidTecnico': serializeParam(widget.uidTecnico,
                                    ParamType.DocumentReference),
                                'emailPropriedade': serializeParam(
                                    widget.emailPropriedade, ParamType.String),
                                'grupoPredominante':
                                    serializeParam('Vacas', ParamType.String),
                                'visitaPresencial': serializeParam(
                                    widget.visitaPresencial, ParamType.bool),
                                'initialTabSelect': serializeParam(
                                    widget.initialTabSelect, ParamType.int),
                                'uidAnimal': serializeParam(
                                    // Animais vivem sob o técnico: tecnico/{id}/animaisProdutores/{id}
                                    FirebaseFirestore.instance.doc(
                                        '${widget.uidTecnico!.path}/animaisProdutores/$firestoreId'),
                                    ParamType.DocumentReference),
                                'diasDg': serializeParam(
                                    widget.diasDg, ParamType.String),
                              }.withoutNulls,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: FFButtonWidget(
                onPressed: () async {
                  if ((_model.respostaNet == true) &&
                      (FFAppState().animaisProdutoresOffline.length > 0)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Sincronize os dados primeiro.',
                          style: TextStyle(
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                        ),
                        duration: Duration(milliseconds: 4000),
                        backgroundColor: Color(0xFFD23939),
                      ),
                    );
                    return;
                  } else {
                    context.pushNamed(
                      CadastrarNovoAnimalWidget.routeName,
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
                        'grupoPredominante': serializeParam(
                          () {
                            if (_model.tabBarCurrentIndex == 0) {
                              return 'Bezerras';
                            } else if (_model.tabBarCurrentIndex == 1) {
                              return 'Bezerros';
                            } else if (_model.tabBarCurrentIndex == 2) {
                              return 'Novilhas';
                            } else if (_model.tabBarCurrentIndex == 3) {
                              return 'Sêmens';
                            } else if (_model.tabBarCurrentIndex == 4) {
                              return 'Touros';
                            } else if (_model.tabBarCurrentIndex == 5) {
                              return 'Vacas';
                            } else {
                              return 'Novilhas';
                            }
                          }(),
                          ParamType.String,
                        ),
                        'visitaPresencial': serializeParam(
                          widget.visitaPresencial,
                          ParamType.bool,
                        ),
                        'initialTabSelect': serializeParam(
                          _model.tabBarCurrentIndex,
                          ParamType.int,
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
                text: '',
                icon: Icon(
                  Icons.add,
                  size: 35.0,
                ),
                options: FFButtonOptions(
                  width: 65.0,
                  height: 65.0,
                  padding: EdgeInsets.all(0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                  color: Color(0xFFEC3B5B),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                        color: Colors.white,
                        fontSize: 45.0,
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
                  borderRadius: BorderRadius.circular(100.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
