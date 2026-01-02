import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/tecnico/propriedade/animals/descarte_animal/descarte_animal_widget.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lista_animais_copy_model.dart';
export 'lista_animais_copy_model.dart';

class ListaAnimaisCopyWidget extends StatefulWidget {
  const ListaAnimaisCopyWidget({
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

  static String routeName = 'listaAnimaisCopy';
  static String routePath = '/listaAnimaisCopy';

  @override
  State<ListaAnimaisCopyWidget> createState() => _ListaAnimaisCopyWidgetState();
}

class _ListaAnimaisCopyWidgetState extends State<ListaAnimaisCopyWidget>
    with TickerProviderStateMixin {
  late ListaAnimaisCopyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListaAnimaisCopyModel());

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

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      unselectedLabelColor:
                          FlutterFlowTheme.of(context).secondaryText,
                      backgroundColor: Color(0xFFF75E38),
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
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 15.0),
                          child: StreamBuilder<List<AnimaisProdutoresRecord>>(
                            stream: queryAnimaisProdutoresRecord(
                              parent: widget.uidTecnico,
                              queryBuilder: (animaisProdutoresRecord) =>
                                  animaisProdutoresRecord
                                      .where(
                                        'grupoAnimal',
                                        isEqualTo: 'Bezerras',
                                      )
                                      .where(
                                        'uidTecnicoPropriedade',
                                        isEqualTo: widget.uidPropriedade,
                                      )
                                      .orderBy('nomeAnimal')
                                      .orderBy('brincoAnimalOrder'),
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFFF75E38),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              List<AnimaisProdutoresRecord>
                                  listViewAnimaisProdutoresRecordList =
                                  snapshot.data!;

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    listViewAnimaisProdutoresRecordList.length,
                                itemBuilder: (context, listViewIndex) {
                                  final listViewAnimaisProdutoresRecord =
                                      listViewAnimaisProdutoresRecordList[
                                          listViewIndex];
                                  return Visibility(
                                    visible: listViewAnimaisProdutoresRecord
                                            .status !=
                                        'Descarte',
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 8.0, 16.0, 0.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                            ProntuarioAnimalWidget.routeName,
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
                                              'emailPropriedade':
                                                  serializeParam(
                                                widget.emailPropriedade,
                                                ParamType.String,
                                              ),
                                              'uidAnimaisProdutores':
                                                  serializeParam(
                                                listViewAnimaisProdutoresRecord
                                                    .reference,
                                                ParamType.DocumentReference,
                                              ),
                                              'grupoPredominante':
                                                  serializeParam(
                                                listViewAnimaisProdutoresRecord
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
                                        onLongPress: () async {
                                          await showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            enableDrag: false,
                                            context: context,
                                            builder: (context) {
                                              return GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                child: Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child: DescarteAnimalWidget(
                                                    uidPropriedade:
                                                        widget.uidPropriedade!,
                                                    nomePropriedade: widget
                                                        .nomePropriedade!,
                                                    uidTecnico:
                                                        widget.uidTecnico!,
                                                    emailPropriedade: widget
                                                        .emailPropriedade!,
                                                    uidAnimaisProdutores:
                                                        listViewAnimaisProdutoresRecord
                                                            .reference,
                                                    grupoPredominante:
                                                        listViewAnimaisProdutoresRecord
                                                            .grupoAnimal,
                                                    nomeAnimal:
                                                        listViewAnimaisProdutoresRecord
                                                            .nomeAnimal,
                                                    visitaPresencial: widget
                                                        .visitaPresencial!,
                                                    diasDg: '',
                                                  ),
                                                ),
                                              );
                                            },
                                          ).then(
                                              (value) => safeSetState(() {}));
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 80.0,
                                                      decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                      ),
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -1.0, 0.0),
                                                      child: Text(
                                                        () {
                                                          if ((listViewAnimaisProdutoresRecord
                                                                          .nomeAnimal !=
                                                                      '') &&
                                                              (listViewAnimaisProdutoresRecord
                                                                      .brincoAnimal !=
                                                                  null) &&
                                                              (listViewAnimaisProdutoresRecord
                                                                      .brincoAnimal !=
                                                                  -1)) {
                                                            return '${listViewAnimaisProdutoresRecord.nomeAnimal} - ${listViewAnimaisProdutoresRecord.brincoAnimal.toString()}';
                                                          } else if (listViewAnimaisProdutoresRecord
                                                                      .nomeAnimal !=
                                                                  '') {
                                                            return listViewAnimaisProdutoresRecord
                                                                .nomeAnimal;
                                                          } else {
                                                            return listViewAnimaisProdutoresRecord
                                                                .brincoAnimal
                                                                .toString();
                                                          }
                                                        }(),
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Mãe:',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Pai:',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 70.0,
                                                      height: 25.0,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          listViewAnimaisProdutoresRecord
                                                              .vaca,
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
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 70.0,
                                                      height: 25.0,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          listViewAnimaisProdutoresRecord
                                                              .touro,
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
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          15.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: 35.0,
                                                        height: 35.0,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child:
                                                            FlutterFlowIconButton(
                                                          borderColor:
                                                              Color(0xFF4138F7),
                                                          borderRadius: 20.0,
                                                          borderWidth: 1.0,
                                                          buttonSize: 40.0,
                                                          fillColor:
                                                              Color(0xFF4138F7),
                                                          icon: Icon(
                                                            Icons
                                                                .document_scanner_rounded,
                                                            color: Colors.white,
                                                            size: 20.0,
                                                          ),
                                                          onPressed: () async {
                                                            context.pushNamed(
                                                              ProntuarioAnimalWidget
                                                                  .routeName,
                                                              queryParameters: {
                                                                'uidPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidPropriedade,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'nomePropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .nomePropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'uidTecnico':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidTecnico,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'emailPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .emailPropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'uidAnimaisProdutores':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .reference,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'grupoPredominante':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'visitaPresencial':
                                                                    serializeParam(
                                                                  widget
                                                                      .visitaPresencial,
                                                                  ParamType
                                                                      .bool,
                                                                ),
                                                                'diasDg':
                                                                    serializeParam(
                                                                  widget
                                                                      .diasDg,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                              }.withoutNulls,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          5.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: 35.0,
                                                        height: 35.0,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child:
                                                            FlutterFlowIconButton(
                                                          borderColor:
                                                              Color(0xFFF75E38),
                                                          borderRadius: 20.0,
                                                          borderWidth: 1.0,
                                                          buttonSize: 40.0,
                                                          fillColor:
                                                              Color(0xFFF75E38),
                                                          icon: Icon(
                                                            Icons.edit,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            size: 20.0,
                                                          ),
                                                          onPressed: () async {
                                                            context.pushNamed(
                                                              EditarAnimalWidget
                                                                  .routeName,
                                                              queryParameters: {
                                                                'uidPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidPropriedade,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'nomePropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .nomePropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'uidTecnico':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidTecnico,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'emailPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .emailPropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'grupoPredominante':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'visitaPresencial':
                                                                    serializeParam(
                                                                  widget
                                                                      .visitaPresencial,
                                                                  ParamType
                                                                      .bool,
                                                                ),
                                                                'initialTabSelect':
                                                                    serializeParam(
                                                                  widget
                                                                      .initialTabSelect,
                                                                  ParamType.int,
                                                                ),
                                                                'uidAnimal':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .reference,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'diasDg':
                                                                    serializeParam(
                                                                  widget
                                                                      .diasDg,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                              }.withoutNulls,
                                                            );
                                                          },
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
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 15.0),
                          child: StreamBuilder<List<AnimaisProdutoresRecord>>(
                            stream: queryAnimaisProdutoresRecord(
                              parent: widget.uidTecnico,
                              queryBuilder: (animaisProdutoresRecord) =>
                                  animaisProdutoresRecord
                                      .where(
                                        'grupoAnimal',
                                        isEqualTo: 'Bezerros',
                                      )
                                      .where(
                                        'uidTecnicoPropriedade',
                                        isEqualTo: widget.uidPropriedade,
                                      )
                                      .orderBy('nomeAnimal')
                                      .orderBy('brincoAnimalOrder'),
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFFF75E38),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              List<AnimaisProdutoresRecord>
                                  listViewAnimaisProdutoresRecordList =
                                  snapshot.data!;

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    listViewAnimaisProdutoresRecordList.length,
                                itemBuilder: (context, listViewIndex) {
                                  final listViewAnimaisProdutoresRecord =
                                      listViewAnimaisProdutoresRecordList[
                                          listViewIndex];
                                  return Visibility(
                                    visible: listViewAnimaisProdutoresRecord
                                            .status !=
                                        'Descarte',
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 8.0, 16.0, 0.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                            ProntuarioAnimalWidget.routeName,
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
                                              'emailPropriedade':
                                                  serializeParam(
                                                widget.emailPropriedade,
                                                ParamType.String,
                                              ),
                                              'uidAnimaisProdutores':
                                                  serializeParam(
                                                listViewAnimaisProdutoresRecord
                                                    .reference,
                                                ParamType.DocumentReference,
                                              ),
                                              'grupoPredominante':
                                                  serializeParam(
                                                listViewAnimaisProdutoresRecord
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
                                        onLongPress: () async {
                                          await showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            enableDrag: false,
                                            context: context,
                                            builder: (context) {
                                              return GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                child: Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child: DescarteAnimalWidget(
                                                    uidPropriedade:
                                                        widget.uidPropriedade!,
                                                    nomePropriedade: widget
                                                        .nomePropriedade!,
                                                    uidTecnico:
                                                        widget.uidTecnico!,
                                                    emailPropriedade: widget
                                                        .emailPropriedade!,
                                                    uidAnimaisProdutores:
                                                        listViewAnimaisProdutoresRecord
                                                            .reference,
                                                    grupoPredominante:
                                                        listViewAnimaisProdutoresRecord
                                                            .grupoAnimal,
                                                    nomeAnimal:
                                                        listViewAnimaisProdutoresRecord
                                                            .nomeAnimal,
                                                    visitaPresencial: widget
                                                        .visitaPresencial!,
                                                    diasDg: widget.diasDg!,
                                                  ),
                                                ),
                                              );
                                            },
                                          ).then(
                                              (value) => safeSetState(() {}));
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 80.0,
                                                      decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                      ),
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -1.0, 0.0),
                                                      child: Text(
                                                        () {
                                                          if ((listViewAnimaisProdutoresRecord
                                                                          .nomeAnimal !=
                                                                      '') &&
                                                              (listViewAnimaisProdutoresRecord
                                                                      .brincoAnimal !=
                                                                  null) &&
                                                              (listViewAnimaisProdutoresRecord
                                                                      .brincoAnimal !=
                                                                  -1)) {
                                                            return '${listViewAnimaisProdutoresRecord.nomeAnimal} - ${listViewAnimaisProdutoresRecord.brincoAnimal.toString()}';
                                                          } else if (listViewAnimaisProdutoresRecord
                                                                      .nomeAnimal !=
                                                                  '') {
                                                            return listViewAnimaisProdutoresRecord
                                                                .nomeAnimal;
                                                          } else {
                                                            return listViewAnimaisProdutoresRecord
                                                                .brincoAnimal
                                                                .toString();
                                                          }
                                                        }(),
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Mãe:',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Pai:',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 70.0,
                                                      height: 25.0,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          listViewAnimaisProdutoresRecord
                                                              .vaca,
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
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 70.0,
                                                      height: 25.0,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          listViewAnimaisProdutoresRecord
                                                              .touro,
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
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          15.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: 35.0,
                                                        height: 35.0,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child:
                                                            FlutterFlowIconButton(
                                                          borderColor:
                                                              Color(0xFF4138F7),
                                                          borderRadius: 20.0,
                                                          borderWidth: 1.0,
                                                          buttonSize: 40.0,
                                                          fillColor:
                                                              Color(0xFF4138F7),
                                                          icon: Icon(
                                                            Icons
                                                                .document_scanner_rounded,
                                                            color: Colors.white,
                                                            size: 20.0,
                                                          ),
                                                          onPressed: () async {
                                                            context.pushNamed(
                                                              ProntuarioAnimalWidget
                                                                  .routeName,
                                                              queryParameters: {
                                                                'uidPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidPropriedade,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'nomePropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .nomePropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'uidTecnico':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidTecnico,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'emailPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .emailPropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'uidAnimaisProdutores':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .reference,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'grupoPredominante':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'visitaPresencial':
                                                                    serializeParam(
                                                                  widget
                                                                      .visitaPresencial,
                                                                  ParamType
                                                                      .bool,
                                                                ),
                                                                'diasDg':
                                                                    serializeParam(
                                                                  widget
                                                                      .diasDg,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                              }.withoutNulls,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          5.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: 35.0,
                                                        height: 35.0,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child:
                                                            FlutterFlowIconButton(
                                                          borderColor:
                                                              Color(0xFFF75E38),
                                                          borderRadius: 20.0,
                                                          borderWidth: 1.0,
                                                          buttonSize: 40.0,
                                                          fillColor:
                                                              Color(0xFFF75E38),
                                                          icon: Icon(
                                                            Icons.edit,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            size: 20.0,
                                                          ),
                                                          onPressed: () async {
                                                            context.pushNamed(
                                                              EditarAnimalWidget
                                                                  .routeName,
                                                              queryParameters: {
                                                                'uidPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidPropriedade,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'nomePropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .nomePropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'uidTecnico':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidTecnico,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'emailPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .emailPropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'grupoPredominante':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'visitaPresencial':
                                                                    serializeParam(
                                                                  widget
                                                                      .visitaPresencial,
                                                                  ParamType
                                                                      .bool,
                                                                ),
                                                                'initialTabSelect':
                                                                    serializeParam(
                                                                  widget
                                                                      .initialTabSelect,
                                                                  ParamType.int,
                                                                ),
                                                                'uidAnimal':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .reference,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'diasDg':
                                                                    serializeParam(
                                                                  widget
                                                                      .diasDg,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                              }.withoutNulls,
                                                            );
                                                          },
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
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 15.0),
                          child: StreamBuilder<List<AnimaisProdutoresRecord>>(
                            stream: queryAnimaisProdutoresRecord(
                              parent: widget.uidTecnico,
                              queryBuilder: (animaisProdutoresRecord) =>
                                  animaisProdutoresRecord
                                      .where(
                                        'grupoAnimal',
                                        isEqualTo: 'Novilhas',
                                      )
                                      .where(
                                        'uidTecnicoPropriedade',
                                        isEqualTo: widget.uidPropriedade,
                                      )
                                      .orderBy('nomeAnimal')
                                      .orderBy('brincoAnimalOrder'),
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFFF75E38),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              List<AnimaisProdutoresRecord>
                                  listViewAnimaisProdutoresRecordList =
                                  snapshot.data!;

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    listViewAnimaisProdutoresRecordList.length,
                                itemBuilder: (context, listViewIndex) {
                                  final listViewAnimaisProdutoresRecord =
                                      listViewAnimaisProdutoresRecordList[
                                          listViewIndex];
                                  return Visibility(
                                    visible: listViewAnimaisProdutoresRecord
                                            .status !=
                                        'Descarte',
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 8.0, 16.0, 0.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                            ProntuarioAnimalWidget.routeName,
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
                                              'emailPropriedade':
                                                  serializeParam(
                                                widget.emailPropriedade,
                                                ParamType.String,
                                              ),
                                              'uidAnimaisProdutores':
                                                  serializeParam(
                                                listViewAnimaisProdutoresRecord
                                                    .reference,
                                                ParamType.DocumentReference,
                                              ),
                                              'grupoPredominante':
                                                  serializeParam(
                                                listViewAnimaisProdutoresRecord
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
                                        onLongPress: () async {
                                          await showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            enableDrag: false,
                                            context: context,
                                            builder: (context) {
                                              return GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                child: Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child: DescarteAnimalWidget(
                                                    uidPropriedade:
                                                        widget.uidPropriedade!,
                                                    nomePropriedade: widget
                                                        .nomePropriedade!,
                                                    uidTecnico:
                                                        widget.uidTecnico!,
                                                    emailPropriedade: widget
                                                        .emailPropriedade!,
                                                    uidAnimaisProdutores:
                                                        listViewAnimaisProdutoresRecord
                                                            .reference,
                                                    grupoPredominante:
                                                        listViewAnimaisProdutoresRecord
                                                            .grupoAnimal,
                                                    nomeAnimal:
                                                        listViewAnimaisProdutoresRecord
                                                            .nomeAnimal,
                                                    visitaPresencial: widget
                                                        .visitaPresencial!,
                                                    diasDg: widget.diasDg!,
                                                  ),
                                                ),
                                              );
                                            },
                                          ).then(
                                              (value) => safeSetState(() {}));
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 80.0,
                                                      decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                      ),
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -1.0, 0.0),
                                                      child: Text(
                                                        () {
                                                          if ((listViewAnimaisProdutoresRecord
                                                                          .nomeAnimal !=
                                                                      '') &&
                                                              (listViewAnimaisProdutoresRecord
                                                                      .brincoAnimal !=
                                                                  null) &&
                                                              (listViewAnimaisProdutoresRecord
                                                                      .brincoAnimal !=
                                                                  -1)) {
                                                            return '${listViewAnimaisProdutoresRecord.nomeAnimal} - ${listViewAnimaisProdutoresRecord.brincoAnimal.toString()}';
                                                          } else if (listViewAnimaisProdutoresRecord
                                                                      .nomeAnimal !=
                                                                  '') {
                                                            return listViewAnimaisProdutoresRecord
                                                                .nomeAnimal;
                                                          } else {
                                                            return listViewAnimaisProdutoresRecord
                                                                .brincoAnimal
                                                                .toString();
                                                          }
                                                        }(),
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Mãe:',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Pai:',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 70.0,
                                                      height: 25.0,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          listViewAnimaisProdutoresRecord
                                                              .vaca,
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
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 70.0,
                                                      height: 25.0,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          listViewAnimaisProdutoresRecord
                                                              .touro,
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
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          15.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: 35.0,
                                                        height: 35.0,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child:
                                                            FlutterFlowIconButton(
                                                          borderColor:
                                                              Color(0xFF4138F7),
                                                          borderRadius: 20.0,
                                                          borderWidth: 1.0,
                                                          buttonSize: 40.0,
                                                          fillColor:
                                                              Color(0xFF4138F7),
                                                          icon: Icon(
                                                            Icons
                                                                .document_scanner_rounded,
                                                            color: Colors.white,
                                                            size: 20.0,
                                                          ),
                                                          onPressed: () async {
                                                            context.pushNamed(
                                                              ProntuarioAnimalWidget
                                                                  .routeName,
                                                              queryParameters: {
                                                                'uidPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidPropriedade,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'nomePropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .nomePropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'uidTecnico':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidTecnico,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'emailPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .emailPropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'uidAnimaisProdutores':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .reference,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'grupoPredominante':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'visitaPresencial':
                                                                    serializeParam(
                                                                  widget
                                                                      .visitaPresencial,
                                                                  ParamType
                                                                      .bool,
                                                                ),
                                                                'diasDg':
                                                                    serializeParam(
                                                                  widget
                                                                      .diasDg,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                              }.withoutNulls,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          5.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: 35.0,
                                                        height: 35.0,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child:
                                                            FlutterFlowIconButton(
                                                          borderColor:
                                                              Color(0xFFF75E38),
                                                          borderRadius: 20.0,
                                                          borderWidth: 1.0,
                                                          buttonSize: 40.0,
                                                          fillColor:
                                                              Color(0xFFF75E38),
                                                          icon: Icon(
                                                            Icons.edit,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            size: 20.0,
                                                          ),
                                                          onPressed: () async {
                                                            context.pushNamed(
                                                              EditarAnimalWidget
                                                                  .routeName,
                                                              queryParameters: {
                                                                'uidPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidPropriedade,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'nomePropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .nomePropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'uidTecnico':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidTecnico,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'emailPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .emailPropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'grupoPredominante':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'visitaPresencial':
                                                                    serializeParam(
                                                                  widget
                                                                      .visitaPresencial,
                                                                  ParamType
                                                                      .bool,
                                                                ),
                                                                'initialTabSelect':
                                                                    serializeParam(
                                                                  widget
                                                                      .initialTabSelect,
                                                                  ParamType.int,
                                                                ),
                                                                'uidAnimal':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .reference,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'diasDg':
                                                                    serializeParam(
                                                                  widget
                                                                      .diasDg,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                              }.withoutNulls,
                                                            );
                                                          },
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
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 15.0),
                          child: StreamBuilder<List<AnimaisProdutoresRecord>>(
                            stream: queryAnimaisProdutoresRecord(
                              parent: widget.uidTecnico,
                              queryBuilder: (animaisProdutoresRecord) =>
                                  animaisProdutoresRecord
                                      .where(
                                        'grupoAnimal',
                                        isEqualTo: 'Sêmens',
                                      )
                                      .where(
                                        'uidTecnicoPropriedade',
                                        isEqualTo: widget.uidPropriedade,
                                      )
                                      .orderBy('nomeAnimal')
                                      .orderBy('brincoAnimalOrder'),
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFFF75E38),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              List<AnimaisProdutoresRecord>
                                  listViewAnimaisProdutoresRecordList =
                                  snapshot.data!;

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    listViewAnimaisProdutoresRecordList.length,
                                itemBuilder: (context, listViewIndex) {
                                  final listViewAnimaisProdutoresRecord =
                                      listViewAnimaisProdutoresRecordList[
                                          listViewIndex];
                                  return Visibility(
                                    visible: listViewAnimaisProdutoresRecord
                                            .status !=
                                        'Descarte',
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 8.0, 16.0, 0.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                            ProntuarioAnimalWidget.routeName,
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
                                              'emailPropriedade':
                                                  serializeParam(
                                                widget.emailPropriedade,
                                                ParamType.String,
                                              ),
                                              'uidAnimaisProdutores':
                                                  serializeParam(
                                                listViewAnimaisProdutoresRecord
                                                    .reference,
                                                ParamType.DocumentReference,
                                              ),
                                              'grupoPredominante':
                                                  serializeParam(
                                                listViewAnimaisProdutoresRecord
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
                                        onLongPress: () async {
                                          await showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            enableDrag: false,
                                            context: context,
                                            builder: (context) {
                                              return GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                child: Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child: DescarteAnimalWidget(
                                                    uidPropriedade:
                                                        widget.uidPropriedade!,
                                                    nomePropriedade: widget
                                                        .nomePropriedade!,
                                                    uidTecnico:
                                                        widget.uidTecnico!,
                                                    emailPropriedade: widget
                                                        .emailPropriedade!,
                                                    uidAnimaisProdutores:
                                                        listViewAnimaisProdutoresRecord
                                                            .reference,
                                                    grupoPredominante:
                                                        listViewAnimaisProdutoresRecord
                                                            .grupoAnimal,
                                                    nomeAnimal:
                                                        listViewAnimaisProdutoresRecord
                                                            .nomeAnimal,
                                                    visitaPresencial: widget
                                                        .visitaPresencial!,
                                                    diasDg: widget.diasDg!,
                                                  ),
                                                ),
                                              );
                                            },
                                          ).then(
                                              (value) => safeSetState(() {}));
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 80.0,
                                                      decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                      ),
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -1.0, 0.0),
                                                      child: Text(
                                                        () {
                                                          if ((listViewAnimaisProdutoresRecord
                                                                          .nomeAnimal !=
                                                                      '') &&
                                                              (listViewAnimaisProdutoresRecord
                                                                      .brincoAnimal !=
                                                                  null) &&
                                                              (listViewAnimaisProdutoresRecord
                                                                      .brincoAnimal !=
                                                                  -1)) {
                                                            return '${listViewAnimaisProdutoresRecord.nomeAnimal} - ${listViewAnimaisProdutoresRecord.brincoAnimal.toString()}';
                                                          } else if (listViewAnimaisProdutoresRecord
                                                                      .nomeAnimal !=
                                                                  '') {
                                                            return listViewAnimaisProdutoresRecord
                                                                .nomeAnimal;
                                                          } else {
                                                            return listViewAnimaisProdutoresRecord
                                                                .brincoAnimal
                                                                .toString();
                                                          }
                                                        }(),
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Mãe:',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Pai:',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 70.0,
                                                      height: 25.0,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          listViewAnimaisProdutoresRecord
                                                              .vaca,
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
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 70.0,
                                                      height: 25.0,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          listViewAnimaisProdutoresRecord
                                                              .touro,
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
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          15.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: 35.0,
                                                        height: 35.0,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child:
                                                            FlutterFlowIconButton(
                                                          borderColor:
                                                              Color(0xFF4138F7),
                                                          borderRadius: 20.0,
                                                          borderWidth: 1.0,
                                                          buttonSize: 40.0,
                                                          fillColor:
                                                              Color(0xFF4138F7),
                                                          icon: Icon(
                                                            Icons
                                                                .document_scanner_rounded,
                                                            color: Colors.white,
                                                            size: 20.0,
                                                          ),
                                                          onPressed: () async {
                                                            context.pushNamed(
                                                              ProntuarioAnimalWidget
                                                                  .routeName,
                                                              queryParameters: {
                                                                'uidPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidPropriedade,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'nomePropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .nomePropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'uidTecnico':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidTecnico,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'emailPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .emailPropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'uidAnimaisProdutores':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .reference,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'grupoPredominante':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'visitaPresencial':
                                                                    serializeParam(
                                                                  widget
                                                                      .visitaPresencial,
                                                                  ParamType
                                                                      .bool,
                                                                ),
                                                                'diasDg':
                                                                    serializeParam(
                                                                  widget
                                                                      .diasDg,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                              }.withoutNulls,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          5.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: 35.0,
                                                        height: 35.0,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child:
                                                            FlutterFlowIconButton(
                                                          borderColor:
                                                              Color(0xFFF75E38),
                                                          borderRadius: 20.0,
                                                          borderWidth: 1.0,
                                                          buttonSize: 40.0,
                                                          fillColor:
                                                              Color(0xFFF75E38),
                                                          icon: Icon(
                                                            Icons.edit,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            size: 20.0,
                                                          ),
                                                          onPressed: () async {
                                                            context.pushNamed(
                                                              EditarAnimalWidget
                                                                  .routeName,
                                                              queryParameters: {
                                                                'uidPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidPropriedade,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'nomePropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .nomePropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'uidTecnico':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidTecnico,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'emailPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .emailPropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'grupoPredominante':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'visitaPresencial':
                                                                    serializeParam(
                                                                  widget
                                                                      .visitaPresencial,
                                                                  ParamType
                                                                      .bool,
                                                                ),
                                                                'initialTabSelect':
                                                                    serializeParam(
                                                                  widget
                                                                      .initialTabSelect,
                                                                  ParamType.int,
                                                                ),
                                                                'uidAnimal':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .reference,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'diasDg':
                                                                    serializeParam(
                                                                  widget
                                                                      .diasDg,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                              }.withoutNulls,
                                                            );
                                                          },
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
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 15.0),
                          child: StreamBuilder<List<AnimaisProdutoresRecord>>(
                            stream: queryAnimaisProdutoresRecord(
                              parent: widget.uidTecnico,
                              queryBuilder: (animaisProdutoresRecord) =>
                                  animaisProdutoresRecord
                                      .where(
                                        'grupoAnimal',
                                        isEqualTo: 'Touros',
                                      )
                                      .where(
                                        'uidTecnicoPropriedade',
                                        isEqualTo: widget.uidPropriedade,
                                      )
                                      .orderBy('nomeAnimal')
                                      .orderBy('brincoAnimalOrder'),
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFFF75E38),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              List<AnimaisProdutoresRecord>
                                  listViewAnimaisProdutoresRecordList =
                                  snapshot.data!;

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    listViewAnimaisProdutoresRecordList.length,
                                itemBuilder: (context, listViewIndex) {
                                  final listViewAnimaisProdutoresRecord =
                                      listViewAnimaisProdutoresRecordList[
                                          listViewIndex];
                                  return Visibility(
                                    visible: listViewAnimaisProdutoresRecord
                                            .status !=
                                        'Descarte',
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 8.0, 16.0, 0.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                            ProntuarioAnimalWidget.routeName,
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
                                              'emailPropriedade':
                                                  serializeParam(
                                                widget.emailPropriedade,
                                                ParamType.String,
                                              ),
                                              'uidAnimaisProdutores':
                                                  serializeParam(
                                                listViewAnimaisProdutoresRecord
                                                    .reference,
                                                ParamType.DocumentReference,
                                              ),
                                              'grupoPredominante':
                                                  serializeParam(
                                                listViewAnimaisProdutoresRecord
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
                                        onLongPress: () async {
                                          await showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            enableDrag: false,
                                            context: context,
                                            builder: (context) {
                                              return GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                child: Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child: DescarteAnimalWidget(
                                                    uidPropriedade:
                                                        widget.uidPropriedade!,
                                                    nomePropriedade: widget
                                                        .nomePropriedade!,
                                                    uidTecnico:
                                                        widget.uidTecnico!,
                                                    emailPropriedade: widget
                                                        .emailPropriedade!,
                                                    uidAnimaisProdutores:
                                                        listViewAnimaisProdutoresRecord
                                                            .reference,
                                                    grupoPredominante:
                                                        listViewAnimaisProdutoresRecord
                                                            .grupoAnimal,
                                                    nomeAnimal:
                                                        listViewAnimaisProdutoresRecord
                                                            .nomeAnimal,
                                                    visitaPresencial: widget
                                                        .visitaPresencial!,
                                                    diasDg: widget.diasDg!,
                                                  ),
                                                ),
                                              );
                                            },
                                          ).then(
                                              (value) => safeSetState(() {}));
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 80.0,
                                                      decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                      ),
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -1.0, 0.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            () {
                                                              if ((listViewAnimaisProdutoresRecord
                                                                              .nomeAnimal !=
                                                                          '') &&
                                                                  (listViewAnimaisProdutoresRecord
                                                                          .brincoAnimal !=
                                                                      null) &&
                                                                  (listViewAnimaisProdutoresRecord
                                                                          .brincoAnimal !=
                                                                      -1)) {
                                                                return '${listViewAnimaisProdutoresRecord.nomeAnimal} - ${listViewAnimaisProdutoresRecord.brincoAnimal.toString()}';
                                                              } else if (listViewAnimaisProdutoresRecord
                                                                          .nomeAnimal !=
                                                                      '') {
                                                                return listViewAnimaisProdutoresRecord
                                                                    .nomeAnimal;
                                                              } else {
                                                                return listViewAnimaisProdutoresRecord
                                                                    .brincoAnimal
                                                                    .toString();
                                                              }
                                                            }(),
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyLarge
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                          if (listViewAnimaisProdutoresRecord
                                                                  .liberaInseminacao ==
                                                              false)
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      -1.0,
                                                                      0.0),
                                                              child:
                                                                  FlutterFlowIconButton(
                                                                buttonSize:
                                                                    35.0,
                                                                icon: Icon(
                                                                  Icons
                                                                      .new_releases_outlined,
                                                                  color: Color(
                                                                      0xFFC59501),
                                                                  size: 20.0,
                                                                ),
                                                                onPressed: () {
                                                                  print(
                                                                      'IconButton pressed ...');
                                                                },
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Mãe:',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Pai:',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 70.0,
                                                      height: 25.0,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          listViewAnimaisProdutoresRecord
                                                              .vaca,
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
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 70.0,
                                                      height: 25.0,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          listViewAnimaisProdutoresRecord
                                                              .touro,
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
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          15.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: 35.0,
                                                        height: 35.0,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child:
                                                            FlutterFlowIconButton(
                                                          borderColor:
                                                              Color(0xFF4138F7),
                                                          borderRadius: 20.0,
                                                          borderWidth: 1.0,
                                                          buttonSize: 40.0,
                                                          fillColor:
                                                              Color(0xFF4138F7),
                                                          icon: Icon(
                                                            Icons
                                                                .document_scanner_rounded,
                                                            color: Colors.white,
                                                            size: 20.0,
                                                          ),
                                                          onPressed: () async {
                                                            context.pushNamed(
                                                              ProntuarioAnimalWidget
                                                                  .routeName,
                                                              queryParameters: {
                                                                'uidPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidPropriedade,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'nomePropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .nomePropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'uidTecnico':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidTecnico,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'emailPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .emailPropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'uidAnimaisProdutores':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .reference,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'grupoPredominante':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'visitaPresencial':
                                                                    serializeParam(
                                                                  widget
                                                                      .visitaPresencial,
                                                                  ParamType
                                                                      .bool,
                                                                ),
                                                                'diasDg':
                                                                    serializeParam(
                                                                  widget
                                                                      .diasDg,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                              }.withoutNulls,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          5.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: 35.0,
                                                        height: 35.0,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child:
                                                            FlutterFlowIconButton(
                                                          borderColor:
                                                              Color(0xFFF75E38),
                                                          borderRadius: 20.0,
                                                          borderWidth: 1.0,
                                                          buttonSize: 40.0,
                                                          fillColor:
                                                              Color(0xFFF75E38),
                                                          icon: Icon(
                                                            Icons.edit,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            size: 20.0,
                                                          ),
                                                          onPressed: () async {
                                                            context.pushNamed(
                                                              EditarAnimalWidget
                                                                  .routeName,
                                                              queryParameters: {
                                                                'uidPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidPropriedade,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'nomePropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .nomePropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'uidTecnico':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidTecnico,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'emailPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .emailPropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'grupoPredominante':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'visitaPresencial':
                                                                    serializeParam(
                                                                  widget
                                                                      .visitaPresencial,
                                                                  ParamType
                                                                      .bool,
                                                                ),
                                                                'initialTabSelect':
                                                                    serializeParam(
                                                                  widget
                                                                      .initialTabSelect,
                                                                  ParamType.int,
                                                                ),
                                                                'uidAnimal':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .reference,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'diasDg':
                                                                    serializeParam(
                                                                  widget
                                                                      .diasDg,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                              }.withoutNulls,
                                                            );
                                                          },
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
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 15.0),
                          child: StreamBuilder<List<AnimaisProdutoresRecord>>(
                            stream: queryAnimaisProdutoresRecord(
                              parent: widget.uidTecnico,
                              queryBuilder: (animaisProdutoresRecord) =>
                                  animaisProdutoresRecord
                                      .where(
                                        'grupoAnimal',
                                        isEqualTo: 'Vacas',
                                      )
                                      .where(
                                        'uidTecnicoPropriedade',
                                        isEqualTo: widget.uidPropriedade,
                                      )
                                      .orderBy('nomeAnimal')
                                      .orderBy('brincoAnimalOrder'),
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFFF75E38),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              List<AnimaisProdutoresRecord>
                                  listViewAnimaisProdutoresRecordList =
                                  snapshot.data!;

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    listViewAnimaisProdutoresRecordList.length,
                                itemBuilder: (context, listViewIndex) {
                                  final listViewAnimaisProdutoresRecord =
                                      listViewAnimaisProdutoresRecordList[
                                          listViewIndex];
                                  return Visibility(
                                    visible: listViewAnimaisProdutoresRecord
                                            .status !=
                                        'Descarte',
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 8.0, 16.0, 0.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                            ProntuarioAnimalWidget.routeName,
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
                                              'emailPropriedade':
                                                  serializeParam(
                                                widget.emailPropriedade,
                                                ParamType.String,
                                              ),
                                              'uidAnimaisProdutores':
                                                  serializeParam(
                                                listViewAnimaisProdutoresRecord
                                                    .reference,
                                                ParamType.DocumentReference,
                                              ),
                                              'grupoPredominante':
                                                  serializeParam(
                                                listViewAnimaisProdutoresRecord
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
                                        onLongPress: () async {
                                          await showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            enableDrag: false,
                                            context: context,
                                            builder: (context) {
                                              return GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                child: Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child: DescarteAnimalWidget(
                                                    uidPropriedade:
                                                        widget.uidPropriedade!,
                                                    nomePropriedade: widget
                                                        .nomePropriedade!,
                                                    uidTecnico:
                                                        widget.uidTecnico!,
                                                    emailPropriedade: widget
                                                        .emailPropriedade!,
                                                    uidAnimaisProdutores:
                                                        listViewAnimaisProdutoresRecord
                                                            .reference,
                                                    grupoPredominante:
                                                        listViewAnimaisProdutoresRecord
                                                            .grupoAnimal,
                                                    nomeAnimal:
                                                        listViewAnimaisProdutoresRecord
                                                            .nomeAnimal,
                                                    visitaPresencial: widget
                                                        .visitaPresencial!,
                                                    diasDg: widget.diasDg!,
                                                  ),
                                                ),
                                              );
                                            },
                                          ).then(
                                              (value) => safeSetState(() {}));
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 80.0,
                                                      decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                      ),
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -1.0, 0.0),
                                                      child: Text(
                                                        () {
                                                          if ((listViewAnimaisProdutoresRecord
                                                                          .nomeAnimal !=
                                                                      '') &&
                                                              (listViewAnimaisProdutoresRecord
                                                                      .brincoAnimal !=
                                                                  null) &&
                                                              (listViewAnimaisProdutoresRecord
                                                                      .brincoAnimal !=
                                                                  -1)) {
                                                            return '${listViewAnimaisProdutoresRecord.nomeAnimal} - ${listViewAnimaisProdutoresRecord.brincoAnimal.toString()}';
                                                          } else if (listViewAnimaisProdutoresRecord
                                                                      .nomeAnimal !=
                                                                  '') {
                                                            return listViewAnimaisProdutoresRecord
                                                                .nomeAnimal;
                                                          } else {
                                                            return listViewAnimaisProdutoresRecord
                                                                .brincoAnimal
                                                                .toString();
                                                          }
                                                        }(),
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Mãe:',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Pai:',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 70.0,
                                                      height: 25.0,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          listViewAnimaisProdutoresRecord
                                                              .vaca,
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
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 70.0,
                                                      height: 25.0,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          listViewAnimaisProdutoresRecord
                                                              .touro,
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
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          15.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: 35.0,
                                                        height: 35.0,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child:
                                                            FlutterFlowIconButton(
                                                          borderColor:
                                                              Color(0xFF4138F7),
                                                          borderRadius: 20.0,
                                                          borderWidth: 1.0,
                                                          buttonSize: 40.0,
                                                          fillColor:
                                                              Color(0xFF4138F7),
                                                          icon: Icon(
                                                            Icons
                                                                .document_scanner_rounded,
                                                            color: Colors.white,
                                                            size: 20.0,
                                                          ),
                                                          onPressed: () async {
                                                            context.pushNamed(
                                                              ProntuarioAnimalWidget
                                                                  .routeName,
                                                              queryParameters: {
                                                                'uidPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidPropriedade,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'nomePropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .nomePropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'uidTecnico':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidTecnico,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'emailPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .emailPropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'uidAnimaisProdutores':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .reference,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'grupoPredominante':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'visitaPresencial':
                                                                    serializeParam(
                                                                  widget
                                                                      .visitaPresencial,
                                                                  ParamType
                                                                      .bool,
                                                                ),
                                                                'diasDg':
                                                                    serializeParam(
                                                                  widget
                                                                      .diasDg,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                              }.withoutNulls,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          5.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: 35.0,
                                                        height: 35.0,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child:
                                                            FlutterFlowIconButton(
                                                          borderColor:
                                                              Color(0xFFF75E38),
                                                          borderRadius: 20.0,
                                                          borderWidth: 1.0,
                                                          buttonSize: 40.0,
                                                          fillColor:
                                                              Color(0xFFF75E38),
                                                          icon: Icon(
                                                            Icons.edit,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            size: 20.0,
                                                          ),
                                                          onPressed: () async {
                                                            context.pushNamed(
                                                              EditarAnimalWidget
                                                                  .routeName,
                                                              queryParameters: {
                                                                'uidPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidPropriedade,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'nomePropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .nomePropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'uidTecnico':
                                                                    serializeParam(
                                                                  widget
                                                                      .uidTecnico,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'emailPropriedade':
                                                                    serializeParam(
                                                                  widget
                                                                      .emailPropriedade,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'grupoPredominante':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                                'visitaPresencial':
                                                                    serializeParam(
                                                                  widget
                                                                      .visitaPresencial,
                                                                  ParamType
                                                                      .bool,
                                                                ),
                                                                'initialTabSelect':
                                                                    serializeParam(
                                                                  widget
                                                                      .initialTabSelect,
                                                                  ParamType.int,
                                                                ),
                                                                'uidAnimal':
                                                                    serializeParam(
                                                                  listViewAnimaisProdutoresRecord
                                                                      .reference,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                                'diasDg':
                                                                    serializeParam(
                                                                  widget
                                                                      .diasDg,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                              }.withoutNulls,
                                                            );
                                                          },
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
                                    ),
                                  );
                                },
                              );
                            },
                          ),
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
                            return '2';
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
