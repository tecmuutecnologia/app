import '/backend/backend.dart';
import '/components/ui/flutter_flow_icon_button.dart';
import 'package:tecmuu/utils/flutter_flow_theme.dart';
import '/components/ui/flutter_flow_util.dart';
import '/components/ui/flutter_flow_widgets.dart';
import '/utils/instant_timer.dart';
import '/screens/tecnico/propriedade/animals/descarte_animal/descarte_animal_widget.dart';
import '/screens/tecnico/propriedade/inseminacoes/nova_inseminacao/nova_inseminacao_widget.dart';
import '/screens/tecnico/propriedade/inseminacoes/nova_inseminacao_existente_offline/nova_inseminacao_existente_offline_widget.dart';
import '/screens/tecnico/propriedade/inseminacoes/nova_inseminacao_offline/nova_inseminacao_offline_widget.dart';
import '/screens/tecnico/propriedade/inseminacoes/registrar_cio/registrar_cio_widget.dart';
import '/screens/tecnico/propriedade/inseminacoes/registrar_cio_existente_offline/registrar_cio_existente_offline_widget.dart';
import '/screens/tecnico/propriedade/inseminacoes/registrar_cio_offline/registrar_cio_offline_widget.dart';
import '/screens/tecnico/propriedade/sincronizacao/alerta_sem_internet/alerta_sem_internet_widget.dart';
import '/helpers/index.dart' as actions;
import '/helpers/custom_functions.dart' as functions;
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'lista_inseminacoes_model.dart';
export 'lista_inseminacoes_model.dart';

class ListaInseminacoesWidget extends StatefulWidget {
  const ListaInseminacoesWidget({
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

  static String routeName = 'listaInseminacoes';
  static String routePath = '/listaInseminacoes';

  @override
  State<ListaInseminacoesWidget> createState() =>
      _ListaInseminacoesWidgetState();
}

class _ListaInseminacoesWidgetState extends State<ListaInseminacoesWidget> {
  late ListaInseminacoesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListaInseminacoesModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.instantTimer = InstantTimer.periodic(
        duration: Duration(milliseconds: 300),
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
        startImmediately: true,
      );
    });

    _model.searchListTextController ??= TextEditingController();
    _model.searchListFocusNode ??= FocusNode();

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
        body: Container(
          width: MediaQuery.sizeOf(context).width * 1.0,
          height: MediaQuery.sizeOf(context).height * 1.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            primary: false,
            scrollDirection: Axis.vertical,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                child: Text(
                  'Pesquisa rápida:',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: 100.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
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
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 8.0, 0.0),
                              child: TextFormField(
                                controller: _model.searchListTextController,
                                focusNode: _model.searchListFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.searchListTextController',
                                  Duration(milliseconds: 2000),
                                  () async {},
                                ),
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Digite algo para buscar...',
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
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
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
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          FlutterFlowTheme.of(context).tertiary,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Color(0xFFE46D3A),
                                  ),
                                  suffixIcon: _model.searchListTextController!
                                          .text.isNotEmpty
                                      ? InkWell(
                                          onTap: () async {
                                            _model.searchListTextController
                                                ?.clear();
                                            safeSetState(() {});
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            color: Color(0xFF974E2D),
                                            size: 22,
                                          ),
                                        )
                                      : null,
                                ),
                                style: FlutterFlowTheme.of(context)
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
                                validator: _model
                                    .searchListTextControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (_model.respostaNet! &&
                  (_model.searchListTextController.text == ''))
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Visibility(
                    visible: _model.respostaNet ?? true,
                    child: StreamBuilder<List<AnimaisProdutoresRecord>>(
                      stream: _model.allAnimaisInseminacoes(
                        requestFn: () => queryAnimaisProdutoresRecord(
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
                            listViewOnlineAnimaisProdutoresRecordList =
                            snapshot.data!;

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          primary: false,
                          scrollDirection: Axis.vertical,
                          itemCount:
                              listViewOnlineAnimaisProdutoresRecordList.length,
                          itemBuilder: (context, listViewOnlineIndex) {
                            final listViewOnlineAnimaisProdutoresRecord =
                                listViewOnlineAnimaisProdutoresRecordList[
                                    listViewOnlineIndex];
                            return Visibility(
                              visible: ((listViewOnlineAnimaisProdutoresRecord
                                              .grupoAnimal ==
                                          'Vacas') ||
                                      (listViewOnlineAnimaisProdutoresRecord
                                              .grupoAnimal ==
                                          'Novilhas')) &&
                                  ((listViewOnlineAnimaisProdutoresRecord
                                              .status ==
                                          'Vazia') ||
                                      (listViewOnlineAnimaisProdutoresRecord
                                              .status ==
                                          'Inseminada') ||
                                      (listViewOnlineAnimaisProdutoresRecord
                                              .status ==
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
                                          listViewOnlineAnimaisProdutoresRecord
                                              .reference,
                                          ParamType.DocumentReference,
                                        ),
                                        'grupoPredominante': serializeParam(
                                          listViewOnlineAnimaisProdutoresRecord
                                              .grupoAnimal,
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
                                            padding: MediaQuery.viewInsetsOf(
                                                context),
                                            child: DescarteAnimalWidget(
                                              uidPropriedade:
                                                  widget.uidPropriedade!,
                                              nomePropriedade:
                                                  widget.nomePropriedade!,
                                              uidTecnico: widget.uidTecnico!,
                                              emailPropriedade:
                                                  widget.emailPropriedade!,
                                              uidAnimaisProdutores:
                                                  listViewOnlineAnimaisProdutoresRecord
                                                      .reference,
                                              grupoPredominante:
                                                  listViewOnlineAnimaisProdutoresRecord
                                                      .grupoAnimal,
                                              nomeAnimal:
                                                  listViewOnlineAnimaisProdutoresRecord
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 0.0, 0.0),
                                              child: Container(
                                                width: 44.0,
                                                height: 44.0,
                                                decoration: BoxDecoration(
                                                  color: () {
                                                    if (listViewOnlineAnimaisProdutoresRecord
                                                            .grupoAnimal ==
                                                        'Vacas') {
                                                      return Color(0xFF048508);
                                                    } else if (listViewOnlineAnimaisProdutoresRecord
                                                            .grupoAnimal ==
                                                        'Novilhas') {
                                                      return Color(0xFFFF0076);
                                                    } else {
                                                      return Color(0x00000000);
                                                    }
                                                  }(),
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Text(
                                                  () {
                                                    if (listViewOnlineAnimaisProdutoresRecord
                                                            .grupoAnimal ==
                                                        'Vacas') {
                                                      return 'VAC';
                                                    } else if (listViewOnlineAnimaisProdutoresRecord
                                                            .grupoAnimal ==
                                                        'Novilhas') {
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
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        12.0, 0.0, 0.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      () {
                                                        if ((listViewOnlineAnimaisProdutoresRecord
                                                                        .nomeAnimal !=
                                                                    '') &&
                                                            (listViewOnlineAnimaisProdutoresRecord
                                                                    .brincoAnimal !=
                                                                null) &&
                                                            (listViewOnlineAnimaisProdutoresRecord
                                                                    .brincoAnimal !=
                                                                -1)) {
                                                          return '${listViewOnlineAnimaisProdutoresRecord.nomeAnimal} - ${listViewOnlineAnimaisProdutoresRecord.brincoAnimal.toString()}';
                                                        } else if (listViewOnlineAnimaisProdutoresRecord
                                                                    .nomeAnimal !=
                                                                '') {
                                                          return listViewOnlineAnimaisProdutoresRecord
                                                              .nomeAnimal;
                                                        } else {
                                                          return listViewOnlineAnimaisProdutoresRecord
                                                              .brincoAnimal
                                                              .toString();
                                                        }
                                                      }(),
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
                                                    if ((listViewOnlineAnimaisProdutoresRecord
                                                                .dtUltimaInseminacao !=
                                                            '') &&
                                                        (listViewOnlineAnimaisProdutoresRecord
                                                                .dtUltimaInseminacao !=
                                                            '0'))
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    4.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          'Dias IA: ${functions.contarDias(listViewOnlineAnimaisProdutoresRecord.dtUltimaInseminacao).toString()}',
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
                                                    if ((listViewOnlineAnimaisProdutoresRecord
                                                                .dtUltimaInseminacao !=
                                                            '') &&
                                                        (listViewOnlineAnimaisProdutoresRecord
                                                                .dtUltimaInseminacao !=
                                                            '0'))
                                                      Text(
                                                        'Última insem.: ${listViewOnlineAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                    if ((listViewOnlineAnimaisProdutoresRecord
                                                                .status ==
                                                            'Inseminada') ||
                                                        (listViewOnlineAnimaisProdutoresRecord
                                                                .status ==
                                                            'Inseminada PP'))
                                                      Text(
                                                        'Inseminada',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: Color(
                                                                      0xFF048508),
                                                                  fontSize:
                                                                      11.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: FFButtonWidget(
                                                            onPressed: () async {
                                                              await showModalBottomSheet(
                                                                isScrollControlled:
                                                                    true,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
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
                                                                        uidTecnico:
                                                                            widget
                                                                                .uidTecnico!,
                                                                        emailPropriedade:
                                                                            widget
                                                                                .emailPropriedade!,
                                                                        uidAnimaisProdutores:
                                                                            listViewOnlineAnimaisProdutoresRecord
                                                                                .reference,
                                                                        grupoPredominante:
                                                                            listViewOnlineAnimaisProdutoresRecord
                                                                                .grupoAnimal,
                                                                        nomeAnimal:
                                                                            listViewOnlineAnimaisProdutoresRecord
                                                                                .nomeAnimal,
                                                                        visitaPresencial:
                                                                            widget
                                                                                .visitaPresencial!,
                                                                        brincoAnimal:
                                                                            listViewOnlineAnimaisProdutoresRecord
                                                                                .brincoAnimal
                                                                                .toString(),
                                                                        diasDg: widget
                                                                            .diasDg!,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ).then((value) =>
                                                                  safeSetState(
                                                                      () {}));
                                                            },
                                                            text: 'Fez Cio',
                                                            icon: Icon(
                                                              Icons.repeat,
                                                              size: 15.0,
                                                            ),
                                                            options:
                                                                FFButtonOptions(
                                                              height: 30.0,
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10.0,
                                                                          0.0,
                                                                          10.0,
                                                                          0.0),
                                                              iconPadding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              color:
                                                                  Color(0xFF1A03E9),
                                                              textStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(
                                                                                  context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(
                                                                                  context)
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
                                                        ),
                                                        SizedBox(width: 8.0),
                                                        Expanded(
                                                          child: FFButtonWidget(
                                                            onPressed: () async {
                                                              await showModalBottomSheet(
                                                                isScrollControlled:
                                                                    true,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
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
                                                                          NovaInseminacaoWidget(
                                                                        uidPropriedade:
                                                                            widget
                                                                                .uidPropriedade!,
                                                                        nomePropriedade:
                                                                            widget
                                                                                .nomePropriedade!,
                                                                        uidTecnico:
                                                                            widget
                                                                                .uidTecnico!,
                                                                        emailPropriedade:
                                                                            widget
                                                                                .emailPropriedade!,
                                                                        uidAnimaisProdutores:
                                                                            listViewOnlineAnimaisProdutoresRecord
                                                                                .reference,
                                                                        grupoPredominante:
                                                                            listViewOnlineAnimaisProdutoresRecord
                                                                                .grupoAnimal,
                                                                        nomeAnimal:
                                                                            listViewOnlineAnimaisProdutoresRecord
                                                                                .nomeAnimal,
                                                                        visitaPresencial:
                                                                            widget
                                                                                .visitaPresencial!,
                                                                        dtUltimaInseminacao:
                                                                            listViewOnlineAnimaisProdutoresRecord
                                                                                .dtUltimaInseminacao,
                                                                        brincoAnimal:
                                                                            listViewOnlineAnimaisProdutoresRecord
                                                                                .brincoAnimal
                                                                                .toString(),
                                                                        diasDg: widget
                                                                            .diasDg!,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ).then((value) =>
                                                                  safeSetState(
                                                                      () {}));
                                                            },
                                                            text: 'Inseminar',
                                                            icon: Icon(
                                                              Icons.playlist_add,
                                                              size: 15.0,
                                                            ),
                                                            options: FFButtonOptions(
                                                              height: 30.0,
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10.0,
                                                                          0.0,
                                                                          10.0,
                                                                          0.0),
                                                              iconPadding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              color:
                                                                  Color(0xFF7E39EF),
                                                              textStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(
                                                                                  context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(
                                                                                  context)
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
                                                              borderSide: BorderSide(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(8.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
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
                  ),
                ),
              if (!_model.respostaNet! &&
                  (_model.searchListTextController.text == ''))
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    primary: false,
                    scrollDirection: Axis.vertical,
                    children: [
                      if (!_model.respostaNet!)
                        Builder(
                          builder: (context) {
                            final listaAnimaisOfflineExistente = FFAppState()
                                .animaisProdutoresExistentes
                                .toList();

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: listaAnimaisOfflineExistente.length,
                              itemBuilder:
                                  (context, listaAnimaisOfflineExistenteIndex) {
                                final listaAnimaisOfflineExistenteItem =
                                    listaAnimaisOfflineExistente[
                                        listaAnimaisOfflineExistenteIndex];
                                return Visibility(
                                  visible: (listaAnimaisOfflineExistenteItem
                                              .uidTecnicoPropriedade ==
                                          widget.uidPropriedade) &&
                                      (((listaAnimaisOfflineExistenteItem
                                                      .grupoAnimal ==
                                                  'Vacas') ||
                                              (listaAnimaisOfflineExistenteItem
                                                      .grupoAnimal ==
                                                  'Novilhas')) &&
                                          ((listaAnimaisOfflineExistenteItem
                                                      .status ==
                                                  'Vazia') ||
                                              (listaAnimaisOfflineExistenteItem
                                                      .status ==
                                                  'Inseminada') ||
                                              (listaAnimaisOfflineExistenteItem
                                                      .status ==
                                                  'Inseminada PP'))),
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
                                            'uidAnimaisProdutores':
                                                serializeParam(
                                              listaAnimaisOfflineExistenteItem
                                                  .uidAnimal,
                                              ParamType.DocumentReference,
                                            ),
                                            'grupoPredominante': serializeParam(
                                              listaAnimaisOfflineExistenteItem
                                                  .grupoAnimal,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 360.0,
                                            height: 140.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
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
                                                bottomLeft:
                                                    Radius.circular(10.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 0.0, 0.0),
                                                  child: Container(
                                                    width: 44.0,
                                                    height: 44.0,
                                                    decoration: BoxDecoration(
                                                      color: () {
                                                        if (listaAnimaisOfflineExistenteItem
                                                                .grupoAnimal ==
                                                            'Vacas') {
                                                          return Color(
                                                              0xFF048508);
                                                        } else if (listaAnimaisOfflineExistenteItem
                                                                .grupoAnimal ==
                                                            'Novilhas') {
                                                          return Color(
                                                              0xFFFF0076);
                                                        } else {
                                                          return Color(
                                                              0x00000000);
                                                        }
                                                      }(),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Text(
                                                      () {
                                                        if (listaAnimaisOfflineExistenteItem
                                                                .grupoAnimal ==
                                                            'Vacas') {
                                                          return 'VAC';
                                                        } else if (listaAnimaisOfflineExistenteItem
                                                                .grupoAnimal ==
                                                            'Novilhas') {
                                                          return 'NOV';
                                                        } else {
                                                          return 'N/C';
                                                        }
                                                      }(),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .titleMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
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
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(12.0, 0.0,
                                                                0.0, 0.0),
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
                                                            if ((listaAnimaisOfflineExistenteItem
                                                                            .nomeAnimal !=
                                                                        '') &&
                                                                (listaAnimaisOfflineExistenteItem
                                                                        .brincoAnimal !=
                                                                    null) &&
                                                                (listaAnimaisOfflineExistenteItem
                                                                        .brincoAnimal !=
                                                                    -1)) {
                                                              return '${listaAnimaisOfflineExistenteItem.nomeAnimal} - ${listaAnimaisOfflineExistenteItem.brincoAnimal.toString()}';
                                                            } else if (listaAnimaisOfflineExistenteItem
                                                                        .nomeAnimal !=
                                                                    '') {
                                                              return listaAnimaisOfflineExistenteItem
                                                                  .nomeAnimal;
                                                            } else {
                                                              return listaAnimaisOfflineExistenteItem
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
                                                        if (listaAnimaisOfflineExistenteItem
                                                                .dtUltimaInseminacao !=
                                                            '')
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        4.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              'Última insem.: ${listaAnimaisOfflineExistenteItem.dtUltimaInseminacao}',
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
                                                        if ((listaAnimaisOfflineExistenteItem
                                                                    .status ==
                                                                'Inseminada') ||
                                                            (listaAnimaisOfflineExistenteItem
                                                                    .status ==
                                                                'Inseminada PP'))
                                                          Text(
                                                            'Inseminada',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: Color(
                                                                      0xFF048508),
                                                                  fontSize:
                                                                      11.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: FFButtonWidget(
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
                                                                        onTap: () {
                                                                          FocusScope.of(
                                                                                  context)
                                                                              .unfocus();
                                                                          FocusManager
                                                                              .instance
                                                                              .primaryFocus
                                                                              ?.unfocus();
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding: MediaQuery
                                                                              .viewInsetsOf(
                                                                                  context),
                                                                          child:
                                                                              RegistrarCioExistenteOfflineWidget(
                                                                            uidPropriedade:
                                                                                widget.uidPropriedade!,
                                                                            nomePropriedade:
                                                                                widget.nomePropriedade!,
                                                                            uidTecnico:
                                                                                widget.uidTecnico!,
                                                                            emailPropriedade:
                                                                                widget.emailPropriedade!,
                                                                            uidAnimaisProdutores:
                                                                                listaAnimaisOfflineExistenteItem.uidAnimal!,
                                                                            grupoPredominante:
                                                                                listaAnimaisOfflineExistenteItem.grupoAnimal,
                                                                            nomeAnimal:
                                                                                listaAnimaisOfflineExistenteItem.nomeAnimal,
                                                                            visitaPresencial:
                                                                                widget.visitaPresencial!,
                                                                            brincoAnimal: listaAnimaisOfflineExistenteItem
                                                                                .brincoAnimal
                                                                                .toString(),
                                                                            diasDg:
                                                                                widget.diasDg!,
                                                                            itemUidIndex:
                                                                                listaAnimaisOfflineExistenteIndex,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      safeSetState(
                                                                          () {}));
                                                                },
                                                                text: 'Fez Cio',
                                                                icon: Icon(
                                                                  Icons.repeat,
                                                                  size: 15.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  height: 30.0,
                                                                  padding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              10.0,
                                                                              0.0,
                                                                              10.0,
                                                                              0.0),
                                                                  iconPadding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                  color: Color(
                                                                      0xFF1A03E9),
                                                                  textStyle:
                                                                      FlutterFlowTheme.of(
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
                                                            ),
                                                            SizedBox(width: 8.0),
                                                            Expanded(
                                                              child: FFButtonWidget(
                                                                onPressed: () async {
                                                                  await showModalBottomSheet(
                                                                    isScrollControlled:
                                                                        true,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    enableDrag: false,
                                                                    context: context,
                                                                    builder:
                                                                        (context) {
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
                                                                        child:
                                                                            Padding(
                                                                          padding: MediaQuery
                                                                              .viewInsetsOf(
                                                                                  context),
                                                                          child:
                                                                              NovaInseminacaoExistenteOfflineWidget(
                                                                            uidPropriedade:
                                                                                widget
                                                                                    .uidPropriedade!,
                                                                            nomePropriedade:
                                                                                widget
                                                                                    .nomePropriedade!,
                                                                            uidTecnico:
                                                                                widget
                                                                                    .uidTecnico!,
                                                                            emailPropriedade:
                                                                                widget
                                                                                    .emailPropriedade!,
                                                                            grupoPredominante:
                                                                                listaAnimaisOfflineExistenteItem
                                                                                    .grupoAnimal,
                                                                            nomeAnimal:
                                                                                listaAnimaisOfflineExistenteItem
                                                                                    .nomeAnimal,
                                                                            visitaPresencial:
                                                                                widget
                                                                                    .visitaPresencial!,
                                                                            dtUltimaInseminacao:
                                                                                listaAnimaisOfflineExistenteItem
                                                                                    .dtUltimaInseminacao,
                                                                            brincoAnimal: listaAnimaisOfflineExistenteItem
                                                                                .brincoAnimal
                                                                                .toString(),
                                                                            diasDg: widget
                                                                                .diasDg!,
                                                                            itemUidIndex:
                                                                                listaAnimaisOfflineExistenteIndex,
                                                                            uidAnimaisProdutores:
                                                                                listaAnimaisOfflineExistenteItem
                                                                                    .uidAnimal!,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      safeSetState(
                                                                          () {}));
                                                                },
                                                                text: 'Inseminar',
                                                                icon: Icon(
                                                                  Icons.playlist_add,
                                                                  size: 15.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  height: 30.0,
                                                                  padding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              10.0,
                                                                              0.0,
                                                                              10.0,
                                                                              0.0),
                                                                  iconPadding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                  color: Color(
                                                                      0xFF7E39EF),
                                                                  textStyle:
                                                                      FlutterFlowTheme.of(
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
                                                            ),
                                                          ],
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
                      if (!_model.respostaNet!)
                        Builder(
                          builder: (context) {
                            final listaAnimaisOffline =
                                FFAppState().animaisProdutoresOffline.toList();

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: listaAnimaisOffline.length,
                              itemBuilder: (context, listaAnimaisOfflineIndex) {
                                final listaAnimaisOfflineItem =
                                    listaAnimaisOffline[
                                        listaAnimaisOfflineIndex];
                                return Visibility(
                                  visible:
                                      (listaAnimaisOfflineItem
                                                  .uidTecnicoPropriedade ==
                                              widget.uidPropriedade) &&
                                          (((listaAnimaisOfflineItem
                                                          .grupoAnimal ==
                                                      'Vacas') ||
                                                  (listaAnimaisOfflineItem
                                                          .grupoAnimal ==
                                                      'Novilhas')) &&
                                              ((listaAnimaisOfflineItem
                                                          .status ==
                                                      'Vazia') ||
                                                  (listaAnimaisOfflineItem
                                                          .status ==
                                                      'Inseminada') ||
                                                  (listaAnimaisOfflineItem
                                                          .status ==
                                                      'Inseminada PP'))),
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
                                            'uidAnimaisProdutores':
                                                serializeParam(
                                              listaAnimaisOfflineItem.uidAnimal,
                                              ParamType.DocumentReference,
                                            ),
                                            'grupoPredominante': serializeParam(
                                              listaAnimaisOfflineItem
                                                  .grupoAnimal,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 360.0,
                                            height: 140.0,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFDE6E6),
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
                                                bottomLeft:
                                                    Radius.circular(10.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 0.0, 0.0),
                                                  child: Container(
                                                    width: 44.0,
                                                    height: 44.0,
                                                    decoration: BoxDecoration(
                                                      color: () {
                                                        if (listaAnimaisOfflineItem
                                                                .grupoAnimal ==
                                                            'Vacas') {
                                                          return Color(
                                                              0xFF048508);
                                                        } else if (listaAnimaisOfflineItem
                                                                .grupoAnimal ==
                                                            'Novilhas') {
                                                          return Color(
                                                              0xFFFF0076);
                                                        } else {
                                                          return Color(
                                                              0x00000000);
                                                        }
                                                      }(),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Text(
                                                      () {
                                                        if (listaAnimaisOfflineItem
                                                                .grupoAnimal ==
                                                            'Vacas') {
                                                          return 'VAC';
                                                        } else if (listaAnimaisOfflineItem
                                                                .grupoAnimal ==
                                                            'Novilhas') {
                                                          return 'NOV';
                                                        } else {
                                                          return 'N/C';
                                                        }
                                                      }(),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .titleMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
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
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(12.0, 0.0,
                                                                0.0, 0.0),
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
                                                            if ((listaAnimaisOfflineItem
                                                                            .nomeAnimal !=
                                                                        '') &&
                                                                (listaAnimaisOfflineItem
                                                                        .brincoAnimal !=
                                                                    null) &&
                                                                (listaAnimaisOfflineItem
                                                                        .brincoAnimal !=
                                                                    -1)) {
                                                              return '${listaAnimaisOfflineItem.nomeAnimal} - ${listaAnimaisOfflineItem.brincoAnimal.toString()}';
                                                            } else if (listaAnimaisOfflineItem
                                                                        .nomeAnimal !=
                                                                    '') {
                                                              return listaAnimaisOfflineItem
                                                                  .nomeAnimal;
                                                            } else {
                                                              return listaAnimaisOfflineItem
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
                                                        if (listaAnimaisOfflineItem
                                                                .dtUltimaInseminacao !=
                                                            '')
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        4.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              'Última insem.: ${listaAnimaisOfflineItem.dtUltimaInseminacao}',
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
                                                        if ((listaAnimaisOfflineItem
                                                                    .status ==
                                                                'Inseminada') ||
                                                            (listaAnimaisOfflineItem
                                                                    .status ==
                                                                'Inseminada PP'))
                                                          Text(
                                                            'Inseminada',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: Color(
                                                                      0xFF048508),
                                                                  fontSize:
                                                                      11.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: FFButtonWidget(
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
                                                                        onTap: () {
                                                                          FocusScope.of(
                                                                                  context)
                                                                              .unfocus();
                                                                          FocusManager
                                                                              .instance
                                                                              .primaryFocus
                                                                              ?.unfocus();
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding: MediaQuery
                                                                              .viewInsetsOf(
                                                                                  context),
                                                                          child:
                                                                              RegistrarCioOfflineWidget(
                                                                            uidPropriedade:
                                                                                widget.uidPropriedade!,
                                                                            nomePropriedade:
                                                                                widget.nomePropriedade!,
                                                                            uidTecnico:
                                                                                widget.uidTecnico!,
                                                                            emailPropriedade:
                                                                                widget.emailPropriedade!,
                                                                            grupoPredominante:
                                                                                listaAnimaisOfflineItem.grupoAnimal,
                                                                            nomeAnimal:
                                                                                listaAnimaisOfflineItem.nomeAnimal,
                                                                            visitaPresencial:
                                                                                widget.visitaPresencial!,
                                                                            brincoAnimal: listaAnimaisOfflineItem
                                                                                .brincoAnimal
                                                                                .toString(),
                                                                            diasDg:
                                                                                widget.diasDg!,
                                                                            uidAnimalOffline:
                                                                                listaAnimaisOfflineItem.uidAnimalOffline,
                                                                            itemUidIndex:
                                                                                listaAnimaisOfflineIndex,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      safeSetState(
                                                                          () {}));
                                                                },
                                                                text: 'Fez Cio',
                                                                icon: Icon(
                                                                  Icons.repeat,
                                                                  size: 15.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  height: 30.0,
                                                                  padding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              10.0,
                                                                              0.0,
                                                                              10.0,
                                                                              0.0),
                                                                  iconPadding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                  color: Color(
                                                                      0xFF1A03E9),
                                                                  textStyle:
                                                                      FlutterFlowTheme.of(
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
                                                            ),
                                                            SizedBox(width: 8.0),
                                                            Expanded(
                                                              child: FFButtonWidget(
                                                                onPressed: () async {
                                                                  await showModalBottomSheet(
                                                                    isScrollControlled:
                                                                        true,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    enableDrag: false,
                                                                    context: context,
                                                                    builder:
                                                                        (context) {
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
                                                                        child:
                                                                            Padding(
                                                                          padding: MediaQuery
                                                                              .viewInsetsOf(
                                                                                  context),
                                                                          child:
                                                                              NovaInseminacaoOfflineWidget(
                                                                            uidPropriedade:
                                                                                widget
                                                                                    .uidPropriedade!,
                                                                            nomePropriedade:
                                                                                widget
                                                                                    .nomePropriedade!,
                                                                            uidTecnico:
                                                                                widget
                                                                                    .uidTecnico!,
                                                                            emailPropriedade:
                                                                                widget
                                                                                    .emailPropriedade!,
                                                                            grupoPredominante:
                                                                                listaAnimaisOfflineItem
                                                                                    .grupoAnimal,
                                                                            nomeAnimal:
                                                                                listaAnimaisOfflineItem
                                                                                    .nomeAnimal,
                                                                            visitaPresencial:
                                                                                widget
                                                                                    .visitaPresencial!,
                                                                            dtUltimaInseminacao:
                                                                                listaAnimaisOfflineItem
                                                                                    .dtUltimaInseminacao,
                                                                            brincoAnimal: listaAnimaisOfflineItem
                                                                                .brincoAnimal
                                                                                .toString(),
                                                                            diasDg: widget
                                                                                .diasDg!,
                                                                            uidAnimalOffline:
                                                                                listaAnimaisOfflineItem
                                                                                    .uidAnimalOffline,
                                                                            itemUidIndex:
                                                                                listaAnimaisOfflineIndex,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      safeSetState(
                                                                          () {}));
                                                                },
                                                                text: 'Inseminar',
                                                                icon: Icon(
                                                                  Icons.playlist_add,
                                                                  size: 15.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  height: 30.0,
                                                                  padding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              10.0,
                                                                              0.0,
                                                                              10.0,
                                                                              0.0),
                                                                  iconPadding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                  color: Color(
                                                                      0xFF7E39EF),
                                                                  textStyle:
                                                                      FlutterFlowTheme.of(
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
                                                            ),
                                                          ],
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
              if (_model.respostaNet! &&
                  (_model.searchListTextController.text != ''))
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Visibility(
                    visible: _model.respostaNet! &&
                        (_model.searchListTextController.text != ''),
                    child: StreamBuilder<List<AnimaisProdutoresRecord>>(
                      stream: _model.allAnimaisInseminacoes(
                        requestFn: () => queryAnimaisProdutoresRecord(
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
                            listViewOnlineAnimaisProdutoresRecordList =
                            snapshot.data!;

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          primary: false,
                          scrollDirection: Axis.vertical,
                          itemCount:
                              listViewOnlineAnimaisProdutoresRecordList.length,
                          itemBuilder: (context, listViewOnlineIndex) {
                            final listViewOnlineAnimaisProdutoresRecord =
                                listViewOnlineAnimaisProdutoresRecordList[
                                    listViewOnlineIndex];
                            return Visibility(
                              visible: ((listViewOnlineAnimaisProdutoresRecord
                                              .grupoAnimal ==
                                          'Vacas') ||
                                      (listViewOnlineAnimaisProdutoresRecord
                                              .grupoAnimal ==
                                          'Novilhas')) &&
                                  ((listViewOnlineAnimaisProdutoresRecord
                                              .nomeAnimal
                                              .toLowerCase()
                                              .contains(_model
                                                  .searchListTextController.text
                                                  .toLowerCase())) ||
                                      (listViewOnlineAnimaisProdutoresRecord
                                              .brincoAnimal
                                              .toString()
                                              .contains(_model
                                                  .searchListTextController
                                                  .text))) &&
                                  ((listViewOnlineAnimaisProdutoresRecord
                                              .status ==
                                          'Vazia') ||
                                      (listViewOnlineAnimaisProdutoresRecord
                                              .status ==
                                          'Inseminada') ||
                                      (listViewOnlineAnimaisProdutoresRecord
                                              .status ==
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
                                          listViewOnlineAnimaisProdutoresRecord
                                              .reference,
                                          ParamType.DocumentReference,
                                        ),
                                        'grupoPredominante': serializeParam(
                                          listViewOnlineAnimaisProdutoresRecord
                                              .grupoAnimal,
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
                                            padding: MediaQuery.viewInsetsOf(
                                                context),
                                            child: DescarteAnimalWidget(
                                              uidPropriedade:
                                                  widget.uidPropriedade!,
                                              nomePropriedade:
                                                  widget.nomePropriedade!,
                                              uidTecnico: widget.uidTecnico!,
                                              emailPropriedade:
                                                  widget.emailPropriedade!,
                                              uidAnimaisProdutores:
                                                  listViewOnlineAnimaisProdutoresRecord
                                                      .reference,
                                              grupoPredominante:
                                                  listViewOnlineAnimaisProdutoresRecord
                                                      .grupoAnimal,
                                              nomeAnimal:
                                                  listViewOnlineAnimaisProdutoresRecord
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 0.0, 0.0),
                                              child: Container(
                                                width: 44.0,
                                                height: 44.0,
                                                decoration: BoxDecoration(
                                                  color: () {
                                                    if (listViewOnlineAnimaisProdutoresRecord
                                                            .grupoAnimal ==
                                                        'Vacas') {
                                                      return Color(0xFF048508);
                                                    } else if (listViewOnlineAnimaisProdutoresRecord
                                                            .grupoAnimal ==
                                                        'Novilhas') {
                                                      return Color(0xFFFF0076);
                                                    } else {
                                                      return Color(0x00000000);
                                                    }
                                                  }(),
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Text(
                                                  () {
                                                    if (listViewOnlineAnimaisProdutoresRecord
                                                            .grupoAnimal ==
                                                        'Vacas') {
                                                      return 'VAC';
                                                    } else if (listViewOnlineAnimaisProdutoresRecord
                                                            .grupoAnimal ==
                                                        'Novilhas') {
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
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        12.0, 0.0, 0.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      () {
                                                        if ((listViewOnlineAnimaisProdutoresRecord
                                                                        .nomeAnimal !=
                                                                    '') &&
                                                            (listViewOnlineAnimaisProdutoresRecord
                                                                    .brincoAnimal !=
                                                                null) &&
                                                            (listViewOnlineAnimaisProdutoresRecord
                                                                    .brincoAnimal !=
                                                                -1)) {
                                                          return '${listViewOnlineAnimaisProdutoresRecord.nomeAnimal} - ${listViewOnlineAnimaisProdutoresRecord.brincoAnimal.toString()}';
                                                        } else if (listViewOnlineAnimaisProdutoresRecord
                                                                    .nomeAnimal !=
                                                                '') {
                                                          return listViewOnlineAnimaisProdutoresRecord
                                                              .nomeAnimal;
                                                        } else {
                                                          return listViewOnlineAnimaisProdutoresRecord
                                                              .brincoAnimal
                                                              .toString();
                                                        }
                                                      }(),
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
                                                    if ((listViewOnlineAnimaisProdutoresRecord
                                                                .dtUltimaInseminacao !=
                                                            '') &&
                                                        (listViewOnlineAnimaisProdutoresRecord
                                                                .dtUltimaInseminacao !=
                                                            '0'))
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    4.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          'Última insem.: ${listViewOnlineAnimaisProdutoresRecord.dtUltimaInseminacao}',
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
                                                    if ((listViewOnlineAnimaisProdutoresRecord
                                                                .status ==
                                                            'Inseminada') ||
                                                        (listViewOnlineAnimaisProdutoresRecord
                                                                .status ==
                                                            'Inseminada PP'))
                                                      Text(
                                                        'Inseminada',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: Color(
                                                                      0xFF048508),
                                                                  fontSize:
                                                                      11.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: FFButtonWidget(
                                                            onPressed: () async {
                                                              await showModalBottomSheet(
                                                                isScrollControlled:
                                                                    true,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
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
                                                                        uidTecnico:
                                                                            widget
                                                                                .uidTecnico!,
                                                                        emailPropriedade:
                                                                            widget
                                                                                .emailPropriedade!,
                                                                        uidAnimaisProdutores:
                                                                            listViewOnlineAnimaisProdutoresRecord
                                                                                .reference,
                                                                        grupoPredominante:
                                                                            listViewOnlineAnimaisProdutoresRecord
                                                                                .grupoAnimal,
                                                                        nomeAnimal:
                                                                            listViewOnlineAnimaisProdutoresRecord
                                                                                .nomeAnimal,
                                                                        visitaPresencial:
                                                                            widget
                                                                                .visitaPresencial!,
                                                                        brincoAnimal:
                                                                            listViewOnlineAnimaisProdutoresRecord
                                                                                .brincoAnimal
                                                                                .toString(),
                                                                        diasDg: widget
                                                                            .diasDg!,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ).then((value) =>
                                                                  safeSetState(
                                                                      () {}));
                                                            },
                                                            text: 'Fez Cio',
                                                            icon: Icon(
                                                              Icons.repeat,
                                                              size: 15.0,
                                                            ),
                                                            options:
                                                                FFButtonOptions(
                                                              height: 30.0,
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10.0,
                                                                          0.0,
                                                                          10.0,
                                                                          0.0),
                                                              iconPadding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              color:
                                                                  Color(0xFF1A03E9),
                                                              textStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(
                                                                                  context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(
                                                                                  context)
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
                                                        ),
                                                        SizedBox(width: 8.0),
                                                        Expanded(
                                                          child: FFButtonWidget(
                                                            onPressed: () async {
                                                              await showModalBottomSheet(
                                                                isScrollControlled:
                                                                    true,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
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
                                                                          NovaInseminacaoWidget(
                                                                        uidPropriedade:
                                                                            widget
                                                                                .uidPropriedade!,
                                                                        nomePropriedade:
                                                                            widget
                                                                                .nomePropriedade!,
                                                                        uidTecnico:
                                                                            widget
                                                                                .uidTecnico!,
                                                                        emailPropriedade:
                                                                            widget
                                                                                .emailPropriedade!,
                                                                        uidAnimaisProdutores:
                                                                            listViewOnlineAnimaisProdutoresRecord
                                                                                .reference,
                                                                        grupoPredominante:
                                                                            listViewOnlineAnimaisProdutoresRecord
                                                                                .grupoAnimal,
                                                                        nomeAnimal:
                                                                            listViewOnlineAnimaisProdutoresRecord
                                                                                .nomeAnimal,
                                                                        visitaPresencial:
                                                                            widget
                                                                                .visitaPresencial!,
                                                                        dtUltimaInseminacao:
                                                                            listViewOnlineAnimaisProdutoresRecord
                                                                                .dtUltimaInseminacao,
                                                                        brincoAnimal:
                                                                            listViewOnlineAnimaisProdutoresRecord
                                                                                .brincoAnimal
                                                                                .toString(),
                                                                        diasDg: widget
                                                                            .diasDg!,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ).then((value) =>
                                                                  safeSetState(
                                                                      () {}));
                                                            },
                                                            text: 'Inseminar',
                                                            icon: Icon(
                                                              Icons.playlist_add,
                                                              size: 15.0,
                                                            ),
                                                            options: FFButtonOptions(
                                                              height: 30.0,
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10.0,
                                                                          0.0,
                                                                          10.0,
                                                                          0.0),
                                                              iconPadding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              color:
                                                                  Color(0xFF7E39EF),
                                                              textStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(
                                                                                  context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(
                                                                                  context)
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
                                                              borderSide: BorderSide(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(8.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
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
                  ),
                ),
              if (!_model.respostaNet! &&
                  (_model.searchListTextController.text != ''))
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    primary: false,
                    scrollDirection: Axis.vertical,
                    children: [
                      if (!_model.respostaNet! &&
                          (_model.searchListTextController.text != ''))
                        Builder(
                          builder: (context) {
                            final listaAnimaisOfflineExistente = FFAppState()
                                .animaisProdutoresExistentes
                                .toList();

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: listaAnimaisOfflineExistente.length,
                              itemBuilder:
                                  (context, listaAnimaisOfflineExistenteIndex) {
                                final listaAnimaisOfflineExistenteItem =
                                    listaAnimaisOfflineExistente[
                                        listaAnimaisOfflineExistenteIndex];
                                return Visibility(
                                  visible: (listaAnimaisOfflineExistenteItem
                                              .uidTecnicoPropriedade ==
                                          widget.uidPropriedade) &&
                                      ((listaAnimaisOfflineExistenteItem.nomeAnimal
                                              .toLowerCase()
                                              .contains(_model.searchListTextController
                                                  .text.toLowerCase())) ||
                                          (listaAnimaisOfflineExistenteItem.brincoAnimal
                                              .toString()
                                              .contains(_model
                                                  .searchListTextController
                                                  .text))) &&
                                      (((listaAnimaisOfflineExistenteItem.grupoAnimal == 'Vacas') ||
                                              (listaAnimaisOfflineExistenteItem.grupoAnimal ==
                                                  'Novilhas')) &&
                                          ((listaAnimaisOfflineExistenteItem.status == 'Vazia') ||
                                              (listaAnimaisOfflineExistenteItem.status ==
                                                  'Inseminada') ||
                                              (listaAnimaisOfflineExistenteItem.status ==
                                                  'Inseminada PP'))),
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
                                            'uidAnimaisProdutores':
                                                serializeParam(
                                              listaAnimaisOfflineExistenteItem
                                                  .uidAnimal,
                                              ParamType.DocumentReference,
                                            ),
                                            'grupoPredominante': serializeParam(
                                              listaAnimaisOfflineExistenteItem
                                                  .grupoAnimal,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 360.0,
                                            height: 140.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
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
                                                bottomLeft:
                                                    Radius.circular(10.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 0.0, 0.0),
                                                  child: Container(
                                                    width: 44.0,
                                                    height: 44.0,
                                                    decoration: BoxDecoration(
                                                      color: () {
                                                        if (listaAnimaisOfflineExistenteItem
                                                                .grupoAnimal ==
                                                            'Vacas') {
                                                          return Color(
                                                              0xFF048508);
                                                        } else if (listaAnimaisOfflineExistenteItem
                                                                .grupoAnimal ==
                                                            'Novilhas') {
                                                          return Color(
                                                              0xFFFF0076);
                                                        } else {
                                                          return Color(
                                                              0x00000000);
                                                        }
                                                      }(),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Text(
                                                      () {
                                                        if (listaAnimaisOfflineExistenteItem
                                                                .grupoAnimal ==
                                                            'Vacas') {
                                                          return 'VAC';
                                                        } else if (listaAnimaisOfflineExistenteItem
                                                                .grupoAnimal ==
                                                            'Novilhas') {
                                                          return 'NOV';
                                                        } else {
                                                          return 'N/C';
                                                        }
                                                      }(),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .titleMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
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
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(12.0, 0.0,
                                                                0.0, 0.0),
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
                                                            if ((listaAnimaisOfflineExistenteItem
                                                                            .nomeAnimal !=
                                                                        '') &&
                                                                (listaAnimaisOfflineExistenteItem
                                                                        .brincoAnimal !=
                                                                    null) &&
                                                                (listaAnimaisOfflineExistenteItem
                                                                        .brincoAnimal !=
                                                                    -1)) {
                                                              return '${listaAnimaisOfflineExistenteItem.nomeAnimal} - ${listaAnimaisOfflineExistenteItem.brincoAnimal.toString()}';
                                                            } else if (listaAnimaisOfflineExistenteItem
                                                                        .nomeAnimal !=
                                                                    '') {
                                                              return listaAnimaisOfflineExistenteItem
                                                                  .nomeAnimal;
                                                            } else {
                                                              return listaAnimaisOfflineExistenteItem
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
                                                        if (listaAnimaisOfflineExistenteItem
                                                                .dtUltimaInseminacao !=
                                                            '')
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        4.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              'Última insem.: ${listaAnimaisOfflineExistenteItem.dtUltimaInseminacao}',
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
                                                        if ((listaAnimaisOfflineExistenteItem
                                                                    .status ==
                                                                'Inseminada') ||
                                                            (listaAnimaisOfflineExistenteItem
                                                                    .status ==
                                                                'Inseminada PP'))
                                                          Text(
                                                            'Inseminada',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: Color(
                                                                      0xFF048508),
                                                                  fontSize:
                                                                      11.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: FFButtonWidget(
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
                                                                        onTap: () {
                                                                          FocusScope.of(
                                                                                  context)
                                                                              .unfocus();
                                                                          FocusManager
                                                                              .instance
                                                                              .primaryFocus
                                                                              ?.unfocus();
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding: MediaQuery
                                                                              .viewInsetsOf(
                                                                                  context),
                                                                          child:
                                                                              RegistrarCioExistenteOfflineWidget(
                                                                            uidPropriedade:
                                                                                widget.uidPropriedade!,
                                                                            nomePropriedade:
                                                                                widget.nomePropriedade!,
                                                                            uidTecnico:
                                                                                widget.uidTecnico!,
                                                                            emailPropriedade:
                                                                                widget.emailPropriedade!,
                                                                            uidAnimaisProdutores:
                                                                                listaAnimaisOfflineExistenteItem.uidAnimal!,
                                                                            grupoPredominante:
                                                                                listaAnimaisOfflineExistenteItem.grupoAnimal,
                                                                            nomeAnimal:
                                                                                listaAnimaisOfflineExistenteItem.nomeAnimal,
                                                                            visitaPresencial:
                                                                                widget.visitaPresencial!,
                                                                            brincoAnimal: listaAnimaisOfflineExistenteItem
                                                                                .brincoAnimal
                                                                                .toString(),
                                                                            diasDg:
                                                                                widget.diasDg!,
                                                                            itemUidIndex:
                                                                                listaAnimaisOfflineExistenteIndex,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      safeSetState(
                                                                          () {}));
                                                                },
                                                                text: 'Fez Cio',
                                                                icon: Icon(
                                                                  Icons.repeat,
                                                                  size: 15.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  height: 30.0,
                                                                  padding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              10.0,
                                                                              0.0,
                                                                              10.0,
                                                                              0.0),
                                                                  iconPadding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                  color: Color(
                                                                      0xFF1A03E9),
                                                                  textStyle:
                                                                      FlutterFlowTheme.of(
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
                                                            ),
                                                            SizedBox(width: 8.0),
                                                            Expanded(
                                                              child: FFButtonWidget(
                                                                onPressed: () async {
                                                                  await showModalBottomSheet(
                                                                    isScrollControlled:
                                                                        true,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    enableDrag: false,
                                                                    context: context,
                                                                    builder:
                                                                        (context) {
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
                                                                        child:
                                                                            Padding(
                                                                          padding: MediaQuery
                                                                              .viewInsetsOf(
                                                                                  context),
                                                                          child:
                                                                              NovaInseminacaoExistenteOfflineWidget(
                                                                            uidPropriedade:
                                                                                widget
                                                                                    .uidPropriedade!,
                                                                            nomePropriedade:
                                                                                widget
                                                                                    .nomePropriedade!,
                                                                            uidTecnico:
                                                                                widget
                                                                                    .uidTecnico!,
                                                                            emailPropriedade:
                                                                                widget
                                                                                    .emailPropriedade!,
                                                                            grupoPredominante:
                                                                                listaAnimaisOfflineExistenteItem
                                                                                    .grupoAnimal,
                                                                            nomeAnimal:
                                                                                listaAnimaisOfflineExistenteItem
                                                                                    .nomeAnimal,
                                                                            visitaPresencial:
                                                                                widget
                                                                                    .visitaPresencial!,
                                                                            dtUltimaInseminacao:
                                                                                listaAnimaisOfflineExistenteItem
                                                                                    .dtUltimaInseminacao,
                                                                            brincoAnimal: listaAnimaisOfflineExistenteItem
                                                                                .brincoAnimal
                                                                                .toString(),
                                                                            diasDg: widget
                                                                                .diasDg!,
                                                                            itemUidIndex:
                                                                                listaAnimaisOfflineExistenteIndex,
                                                                            uidAnimaisProdutores:
                                                                                listaAnimaisOfflineExistenteItem
                                                                                    .uidAnimal!,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      safeSetState(
                                                                          () {}));
                                                                },
                                                                text: 'Inseminar',
                                                                icon: Icon(
                                                                  Icons.playlist_add,
                                                                  size: 15.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  height: 30.0,
                                                                  padding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              10.0,
                                                                              0.0,
                                                                              10.0,
                                                                              0.0),
                                                                  iconPadding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                  color: Color(
                                                                      0xFF7E39EF),
                                                                  textStyle:
                                                                      FlutterFlowTheme.of(
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
                                                            ),
                                                          ],
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
                      if (!_model.respostaNet! &&
                          (_model.searchListTextController.text != ''))
                        Builder(
                          builder: (context) {
                            final listaAnimaisOffline =
                                FFAppState().animaisProdutoresOffline.toList();

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: listaAnimaisOffline.length,
                              itemBuilder: (context, listaAnimaisOfflineIndex) {
                                final listaAnimaisOfflineItem =
                                    listaAnimaisOffline[
                                        listaAnimaisOfflineIndex];
                                return Visibility(
                                  visible: (listaAnimaisOfflineItem.uidTecnicoPropriedade ==
                                          widget.uidPropriedade) &&
                                      ((listaAnimaisOfflineItem.nomeAnimal
                                              .toLowerCase()
                                              .contains(_model.searchListTextController
                                                  .text.toLowerCase())) ||
                                          (listaAnimaisOfflineItem.brincoAnimal
                                              .toString()
                                              .contains(_model
                                                  .searchListTextController
                                                  .text))) &&
                                      (((listaAnimaisOfflineItem.grupoAnimal ==
                                                  'Vacas') ||
                                              (listaAnimaisOfflineItem.grupoAnimal ==
                                                  'Novilhas')) &&
                                          ((listaAnimaisOfflineItem.status == 'Vazia') ||
                                              (listaAnimaisOfflineItem.status ==
                                                  'Inseminada') ||
                                              (listaAnimaisOfflineItem.status ==
                                                  'Inseminada PP'))),
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
                                            'uidAnimaisProdutores':
                                                serializeParam(
                                              listaAnimaisOfflineItem.uidAnimal,
                                              ParamType.DocumentReference,
                                            ),
                                            'grupoPredominante': serializeParam(
                                              listaAnimaisOfflineItem
                                                  .grupoAnimal,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 360.0,
                                            height: 140.0,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFDE6E6),
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
                                                bottomLeft:
                                                    Radius.circular(10.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 0.0, 0.0),
                                                  child: Container(
                                                    width: 44.0,
                                                    height: 44.0,
                                                    decoration: BoxDecoration(
                                                      color: () {
                                                        if (listaAnimaisOfflineItem
                                                                .grupoAnimal ==
                                                            'Vacas') {
                                                          return Color(
                                                              0xFF048508);
                                                        } else if (listaAnimaisOfflineItem
                                                                .grupoAnimal ==
                                                            'Novilhas') {
                                                          return Color(
                                                              0xFFFF0076);
                                                        } else {
                                                          return Color(
                                                              0x00000000);
                                                        }
                                                      }(),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Text(
                                                      () {
                                                        if (listaAnimaisOfflineItem
                                                                .grupoAnimal ==
                                                            'Vacas') {
                                                          return 'VAC';
                                                        } else if (listaAnimaisOfflineItem
                                                                .grupoAnimal ==
                                                            'Novilhas') {
                                                          return 'NOV';
                                                        } else {
                                                          return 'N/C';
                                                        }
                                                      }(),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .titleMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
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
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(12.0, 0.0,
                                                                0.0, 0.0),
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
                                                            if ((listaAnimaisOfflineItem
                                                                            .nomeAnimal !=
                                                                        '') &&
                                                                (listaAnimaisOfflineItem
                                                                        .brincoAnimal !=
                                                                    null) &&
                                                                (listaAnimaisOfflineItem
                                                                        .brincoAnimal !=
                                                                    -1)) {
                                                              return '${listaAnimaisOfflineItem.nomeAnimal} - ${listaAnimaisOfflineItem.brincoAnimal.toString()}';
                                                            } else if (listaAnimaisOfflineItem
                                                                        .nomeAnimal !=
                                                                    '') {
                                                              return listaAnimaisOfflineItem
                                                                  .nomeAnimal;
                                                            } else {
                                                              return listaAnimaisOfflineItem
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
                                                        if (listaAnimaisOfflineItem
                                                                .dtUltimaInseminacao !=
                                                            '')
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        4.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              'Última insem.: ${listaAnimaisOfflineItem.dtUltimaInseminacao}',
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
                                                        if ((listaAnimaisOfflineItem
                                                                    .status ==
                                                                'Inseminada') ||
                                                            (listaAnimaisOfflineItem
                                                                    .status ==
                                                                'Inseminada PP'))
                                                          Text(
                                                            'Inseminada',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .readexPro(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: Color(
                                                                      0xFF048508),
                                                                  fontSize:
                                                                      11.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: FFButtonWidget(
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
                                                                        onTap: () {
                                                                          FocusScope.of(
                                                                                  context)
                                                                              .unfocus();
                                                                          FocusManager
                                                                              .instance
                                                                              .primaryFocus
                                                                              ?.unfocus();
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding: MediaQuery
                                                                              .viewInsetsOf(
                                                                                  context),
                                                                          child:
                                                                              RegistrarCioOfflineWidget(
                                                                            uidPropriedade:
                                                                                widget.uidPropriedade!,
                                                                            nomePropriedade:
                                                                                widget.nomePropriedade!,
                                                                            uidTecnico:
                                                                                widget.uidTecnico!,
                                                                            emailPropriedade:
                                                                                widget.emailPropriedade!,
                                                                            grupoPredominante:
                                                                                listaAnimaisOfflineItem.grupoAnimal,
                                                                            nomeAnimal:
                                                                                listaAnimaisOfflineItem.nomeAnimal,
                                                                            visitaPresencial:
                                                                                widget.visitaPresencial!,
                                                                            brincoAnimal: listaAnimaisOfflineItem
                                                                                .brincoAnimal
                                                                                .toString(),
                                                                            diasDg:
                                                                                widget.diasDg!,
                                                                            uidAnimalOffline:
                                                                                listaAnimaisOfflineItem.uidAnimalOffline,
                                                                            itemUidIndex:
                                                                                listaAnimaisOfflineIndex,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      safeSetState(
                                                                          () {}));
                                                                },
                                                                text: 'Fez Cio',
                                                                icon: Icon(
                                                                  Icons.repeat,
                                                                  size: 15.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  height: 30.0,
                                                                  padding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              10.0,
                                                                              0.0,
                                                                              10.0,
                                                                              0.0),
                                                                  iconPadding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                  color: Color(
                                                                      0xFF1A03E9),
                                                                  textStyle:
                                                                      FlutterFlowTheme.of(
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
                                                            ),
                                                            SizedBox(width: 8.0),
                                                            Expanded(
                                                              child: FFButtonWidget(
                                                                onPressed: () async {
                                                                  await showModalBottomSheet(
                                                                    isScrollControlled:
                                                                        true,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    enableDrag: false,
                                                                    context: context,
                                                                    builder:
                                                                        (context) {
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
                                                                        child:
                                                                            Padding(
                                                                          padding: MediaQuery
                                                                              .viewInsetsOf(
                                                                                  context),
                                                                          child:
                                                                              NovaInseminacaoOfflineWidget(
                                                                            uidPropriedade:
                                                                                widget
                                                                                    .uidPropriedade!,
                                                                            nomePropriedade:
                                                                                widget
                                                                                    .nomePropriedade!,
                                                                            uidTecnico:
                                                                                widget
                                                                                    .uidTecnico!,
                                                                            emailPropriedade:
                                                                                widget
                                                                                    .emailPropriedade!,
                                                                            grupoPredominante:
                                                                                listaAnimaisOfflineItem
                                                                                    .grupoAnimal,
                                                                            nomeAnimal:
                                                                                listaAnimaisOfflineItem
                                                                                    .nomeAnimal,
                                                                            visitaPresencial:
                                                                                widget
                                                                                    .visitaPresencial!,
                                                                            dtUltimaInseminacao:
                                                                                listaAnimaisOfflineItem
                                                                                    .dtUltimaInseminacao,
                                                                            brincoAnimal: listaAnimaisOfflineItem
                                                                                .brincoAnimal
                                                                                .toString(),
                                                                            diasDg: widget
                                                                                .diasDg!,
                                                                            uidAnimalOffline:
                                                                                listaAnimaisOfflineItem
                                                                                    .uidAnimalOffline,
                                                                            itemUidIndex:
                                                                                listaAnimaisOfflineIndex,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      safeSetState(
                                                                          () {}));
                                                                },
                                                                text: 'Inseminar',
                                                                icon: Icon(
                                                                  Icons.playlist_add,
                                                                  size: 15.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  height: 30.0,
                                                                  padding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              10.0,
                                                                              0.0,
                                                                              10.0,
                                                                              0.0),
                                                                  iconPadding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                  color: Color(
                                                                      0xFF7E39EF),
                                                                  textStyle:
                                                                      FlutterFlowTheme.of(
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
                                                            ),
                                                          ],
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
            ],
          ),
        ),
      ),
    );
  }
}
