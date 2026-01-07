import '/backend/backend.dart';
import '/components/ui/flutter_flow_icon_button.dart';
import 'package:tecmuu/utils/flutter_flow_theme.dart';
import '/components/ui/flutter_flow_util.dart';
import '/components/ui/flutter_flow_widgets.dart';
import '/screens/tecnico/propriedade/animals/descarte_animal/descarte_animal_widget.dart';
import '/screens/tecnico/propriedade/inseminacoes/nova_inseminacao/nova_inseminacao_widget.dart';
import '/screens/tecnico/propriedade/inseminacoes/registrar_cio/registrar_cio_widget.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lista_inseminacoes_antes_offline_model.dart';
export 'lista_inseminacoes_antes_offline_model.dart';

class ListaInseminacoesAntesOfflineWidget extends StatefulWidget {
  const ListaInseminacoesAntesOfflineWidget({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    this.diasDg,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? diasDg;

  static String routeName = 'listaInseminacoesAntesOffline';
  static String routePath = '/listaInseminacoesAntesOffline';

  @override
  State<ListaInseminacoesAntesOfflineWidget> createState() =>
      _ListaInseminacoesAntesOfflineWidgetState();
}

class _ListaInseminacoesAntesOfflineWidgetState
    extends State<ListaInseminacoesAntesOfflineWidget> {
  late ListaInseminacoesAntesOfflineModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListaInseminacoesAntesOfflineModel());

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
                        'Inseminações',
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              StreamBuilder<List<AnimaisProdutoresRecord>>(
                stream: queryAnimaisProdutoresRecord(
                  parent: widget.uidTecnico,
                  queryBuilder: (animaisProdutoresRecord) =>
                      animaisProdutoresRecord
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
                      listViewAnimaisProdutoresRecordList = snapshot.data!;

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: listViewAnimaisProdutoresRecordList.length,
                    itemBuilder: (context, listViewIndex) {
                      final listViewAnimaisProdutoresRecord =
                          listViewAnimaisProdutoresRecordList[listViewIndex];
                      return Visibility(
                        visible: ((listViewAnimaisProdutoresRecord
                                        .grupoAnimal ==
                                    'Vacas') ||
                                (listViewAnimaisProdutoresRecord.grupoAnimal ==
                                    'Novilhas')) &&
                            ((listViewAnimaisProdutoresRecord.status ==
                                    'Vazia') ||
                                (listViewAnimaisProdutoresRecord.status ==
                                    'Inseminada') ||
                                (listViewAnimaisProdutoresRecord.status ==
                                    'Inseminada PP')),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 12.0, 16.0, 12.0),
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
                                  'emailPropriedade': serializeParam(
                                    widget.emailPropriedade,
                                    ParamType.String,
                                  ),
                                  'uidAnimaisProdutores': serializeParam(
                                    listViewAnimaisProdutoresRecord.reference,
                                    ParamType.DocumentReference,
                                  ),
                                  'grupoPredominante': serializeParam(
                                    listViewAnimaisProdutoresRecord.grupoAnimal,
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
                            onLongPress: () async {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                enableDrag: false,
                                context: context,
                                builder: (context) {
                                  return GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    child: Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: DescarteAnimalWidget(
                                        uidPropriedade: widget.uidPropriedade!,
                                        nomePropriedade:
                                            widget.nomePropriedade!,
                                        uidTecnico: widget.uidTecnico!,
                                        emailPropriedade:
                                            widget.emailPropriedade!,
                                        uidAnimaisProdutores:
                                            listViewAnimaisProdutoresRecord
                                                .reference,
                                        grupoPredominante:
                                            listViewAnimaisProdutoresRecord
                                                .grupoAnimal,
                                        nomeAnimal:
                                            listViewAnimaisProdutoresRecord
                                                .nomeAnimal,
                                        visitaPresencial:
                                            widget.visitaPresencial!,
                                        diasDg: widget.diasDg!,
                                      ),
                                    ),
                                  );
                                },
                              ).then((value) => safeSetState(() {}));
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: 360.0,
                                  height: 140.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4.0,
                                        color: Color(0x33000000),
                                        offset: Offset(
                                          0.0,
                                          2.0,
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 0.0, 0.0),
                                        child: Container(
                                          width: 44.0,
                                          height: 44.0,
                                          decoration: BoxDecoration(
                                            color: () {
                                              if (listViewAnimaisProdutoresRecord
                                                      .grupoAnimal ==
                                                  'Vacas') {
                                                return Color(0xFF048508);
                                              } else if (listViewAnimaisProdutoresRecord
                                                      .grupoAnimal ==
                                                  'Novilhas') {
                                                return Color(0xFFFF0076);
                                              } else {
                                                return Color(0x00000000);
                                              }
                                            }(),
                                            shape: BoxShape.circle,
                                          ),
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Text(
                                            () {
                                              if (listViewAnimaisProdutoresRecord
                                                      .grupoAnimal ==
                                                  'Vacas') {
                                                return 'VAC';
                                              } else if (listViewAnimaisProdutoresRecord
                                                      .grupoAnimal ==
                                                  'Novilhas') {
                                                return 'NOV';
                                              } else {
                                                return 'N/C';
                                              }
                                            }(),
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  font: GoogleFonts.readexPro(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontStyle,
                                                  ),
                                                  color: Colors.white,
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 0.0, 0.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyLarge
                                                    .override(
                                                      font:
                                                          GoogleFonts.readexPro(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontStyle,
                                                      ),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .fontStyle,
                                                    ),
                                              ),
                                              if (listViewAnimaisProdutoresRecord
                                                      .dtUltimaInseminacao !=
                                                  '')
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 4.0, 0.0, 0.0),
                                                  child: Text(
                                                    'Última insem.: ${listViewAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              if ((listViewAnimaisProdutoresRecord
                                                          .status ==
                                                      'Inseminada') ||
                                                  (listViewAnimaisProdutoresRecord
                                                          .status ==
                                                      'Inseminada PP'))
                                                Text(
                                                  'Inseminada',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            Color(0xFF048508),
                                                        fontSize: 11.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 4.0, 0.0, 4.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                RegistrarCioWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
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
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              brincoAnimal:
                                                                  listViewAnimaisProdutoresRecord
                                                                      .brincoAnimal
                                                                      .toString(),
                                                              diasDg: widget
                                                                  .diasDg!,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Fez Cio',
                                                  icon: Icon(
                                                    Icons.repeat,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    height: 30.0,
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(24.0, 0.0,
                                                                24.0, 0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF1A03E9),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              NovaInseminacaoWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
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
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            dtUltimaInseminacao:
                                                                listViewAnimaisProdutoresRecord
                                                                    .dtUltimaInseminacao,
                                                            brincoAnimal:
                                                                listViewAnimaisProdutoresRecord
                                                                    .brincoAnimal
                                                                    .toString(),
                                                            diasDg:
                                                                widget.diasDg!,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Inseminar',
                                                icon: Icon(
                                                  Icons.playlist_add,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 30.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          24.0, 0.0, 24.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFF7E39EF),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                            ],
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
                      );
                    },
                  );
                },
              ),
              StreamBuilder<List<AnimaisProdutoresRecord>>(
                stream: queryAnimaisProdutoresRecord(
                  parent: widget.uidTecnico,
                  queryBuilder: (animaisProdutoresRecord) =>
                      animaisProdutoresRecord
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
                      listViewAnimaisProdutoresRecordList = snapshot.data!;

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: listViewAnimaisProdutoresRecordList.length,
                    itemBuilder: (context, listViewIndex) {
                      final listViewAnimaisProdutoresRecord =
                          listViewAnimaisProdutoresRecordList[listViewIndex];
                      return Visibility(
                        visible: ((listViewAnimaisProdutoresRecord
                                        .grupoAnimal ==
                                    'Vacas') ||
                                (listViewAnimaisProdutoresRecord.grupoAnimal ==
                                    'Novilhas')) &&
                            ((listViewAnimaisProdutoresRecord.status ==
                                    'Vazia') ||
                                (listViewAnimaisProdutoresRecord.status ==
                                    'Inseminada') ||
                                (listViewAnimaisProdutoresRecord.status ==
                                    'Inseminada PP')),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 12.0, 16.0, 12.0),
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
                                  'emailPropriedade': serializeParam(
                                    widget.emailPropriedade,
                                    ParamType.String,
                                  ),
                                  'uidAnimaisProdutores': serializeParam(
                                    listViewAnimaisProdutoresRecord.reference,
                                    ParamType.DocumentReference,
                                  ),
                                  'grupoPredominante': serializeParam(
                                    listViewAnimaisProdutoresRecord.grupoAnimal,
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
                            onLongPress: () async {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                enableDrag: false,
                                context: context,
                                builder: (context) {
                                  return GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    child: Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: DescarteAnimalWidget(
                                        uidPropriedade: widget.uidPropriedade!,
                                        nomePropriedade:
                                            widget.nomePropriedade!,
                                        uidTecnico: widget.uidTecnico!,
                                        emailPropriedade:
                                            widget.emailPropriedade!,
                                        uidAnimaisProdutores:
                                            listViewAnimaisProdutoresRecord
                                                .reference,
                                        grupoPredominante:
                                            listViewAnimaisProdutoresRecord
                                                .grupoAnimal,
                                        nomeAnimal:
                                            listViewAnimaisProdutoresRecord
                                                .nomeAnimal,
                                        visitaPresencial:
                                            widget.visitaPresencial!,
                                        diasDg: widget.diasDg!,
                                      ),
                                    ),
                                  );
                                },
                              ).then((value) => safeSetState(() {}));
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: 360.0,
                                  height: 140.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4.0,
                                        color: Color(0x33000000),
                                        offset: Offset(
                                          0.0,
                                          2.0,
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 0.0, 0.0),
                                        child: Container(
                                          width: 44.0,
                                          height: 44.0,
                                          decoration: BoxDecoration(
                                            color: () {
                                              if (listViewAnimaisProdutoresRecord
                                                      .grupoAnimal ==
                                                  'Vacas') {
                                                return Color(0xFF048508);
                                              } else if (listViewAnimaisProdutoresRecord
                                                      .grupoAnimal ==
                                                  'Novilhas') {
                                                return Color(0xFFFF0076);
                                              } else {
                                                return Color(0x00000000);
                                              }
                                            }(),
                                            shape: BoxShape.circle,
                                          ),
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Text(
                                            () {
                                              if (listViewAnimaisProdutoresRecord
                                                      .grupoAnimal ==
                                                  'Vacas') {
                                                return 'VAC';
                                              } else if (listViewAnimaisProdutoresRecord
                                                      .grupoAnimal ==
                                                  'Novilhas') {
                                                return 'NOV';
                                              } else {
                                                return 'N/C';
                                              }
                                            }(),
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  font: GoogleFonts.readexPro(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontStyle,
                                                  ),
                                                  color: Colors.white,
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 0.0, 0.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyLarge
                                                    .override(
                                                      font:
                                                          GoogleFonts.readexPro(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontStyle,
                                                      ),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .fontStyle,
                                                    ),
                                              ),
                                              if (listViewAnimaisProdutoresRecord
                                                      .dtUltimaInseminacao !=
                                                  '')
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 4.0, 0.0, 0.0),
                                                  child: Text(
                                                    'Última insem.: ${listViewAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              if ((listViewAnimaisProdutoresRecord
                                                          .status ==
                                                      'Inseminada') ||
                                                  (listViewAnimaisProdutoresRecord
                                                          .status ==
                                                      'Inseminada PP'))
                                                Text(
                                                  'Inseminada',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            Color(0xFF048508),
                                                        fontSize: 11.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 4.0, 0.0, 4.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                RegistrarCioWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
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
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              brincoAnimal:
                                                                  listViewAnimaisProdutoresRecord
                                                                      .brincoAnimal
                                                                      .toString(),
                                                              diasDg: widget
                                                                  .diasDg!,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Fez Cio',
                                                  icon: Icon(
                                                    Icons.repeat,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    height: 30.0,
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(24.0, 0.0,
                                                                24.0, 0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF1A03E9),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              NovaInseminacaoWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
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
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            dtUltimaInseminacao:
                                                                listViewAnimaisProdutoresRecord
                                                                    .dtUltimaInseminacao,
                                                            brincoAnimal:
                                                                listViewAnimaisProdutoresRecord
                                                                    .brincoAnimal
                                                                    .toString(),
                                                            diasDg:
                                                                widget.diasDg!,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Inseminar',
                                                icon: Icon(
                                                  Icons.playlist_add,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 30.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          24.0, 0.0, 24.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFF7E39EF),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                            ],
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
                      );
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
