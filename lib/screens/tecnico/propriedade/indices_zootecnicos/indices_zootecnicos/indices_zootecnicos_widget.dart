import '/backend/backend.dart';
import '/components/ui/flutter_flow_charts.dart';
import '/components/ui/flutter_flow_icon_button.dart';
import 'package:tecmuu/utils/flutter_flow_theme.dart';
import '/components/ui/flutter_flow_util.dart';
import '/helpers/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'indices_zootecnicos_model.dart';
export 'indices_zootecnicos_model.dart';

class IndicesZootecnicosWidget extends StatefulWidget {
  const IndicesZootecnicosWidget({
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

  static String routeName = 'indicesZootecnicos';
  static String routePath = '/indicesZootecnicos';

  @override
  State<IndicesZootecnicosWidget> createState() =>
      _IndicesZootecnicosWidgetState();
}

class _IndicesZootecnicosWidgetState extends State<IndicesZootecnicosWidget> {
  late IndicesZootecnicosModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => IndicesZootecnicosModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chartPieChartColorsList1 = [
      FlutterFlowTheme.of(context).tertiary,
      FlutterFlowTheme.of(context).secondary,
      FlutterFlowTheme.of(context).warning,
      FlutterFlowTheme.of(context).error,
      Color(0xFF65D239),
      Color(0xFF3E8DD0),
      Color(0xFF2F1F86),
      Color(0xFF333EBA)
    ];
    final chartPieChartColorsList2 = [
      FlutterFlowTheme.of(context).tertiary,
      FlutterFlowTheme.of(context).secondary,
      FlutterFlowTheme.of(context).error,
      FlutterFlowTheme.of(context).warning,
      Color(0xFF65D239),
      Color(0xFF3E8DD0),
      Color(0xFF861F7C)
    ];
    final chartPieChartColorsList3 = [
      FlutterFlowTheme.of(context).tertiary,
      FlutterFlowTheme.of(context).secondary,
      FlutterFlowTheme.of(context).error,
      FlutterFlowTheme.of(context).warning,
      Color(0xFF65D239),
      Color(0xFF3E8DD0)
    ];
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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
                        'Índices zootécnicos',
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
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).tertiary,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      'assets/images/vaca-icone.fw.png',
                                      height: 35.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StreamBuilder<List<AnimaisProdutoresRecord>>(
                                    stream: queryAnimaisProdutoresRecord(
                                      parent: widget.uidTecnico,
                                      queryBuilder: (animaisProdutoresRecord) =>
                                          animaisProdutoresRecord
                                              .where(
                                                'uidTecnicoPropriedade',
                                                isEqualTo:
                                                    widget.uidPropriedade,
                                              )
                                              .where(
                                                'grupoAnimal',
                                                isNotEqualTo: 'Sêmens',
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
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Color(0xFFF75E38),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      List<AnimaisProdutoresRecord>
                                          textAnimaisProdutoresRecordList =
                                          snapshot.data!;

                                      return Text(
                                        textAnimaisProdutoresRecordList.length
                                            .toString(),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                fontWeight: FontWeight.w800,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .tertiary,
                                              fontSize: 25.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w800,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Animais\nativos',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 0.0, 0.0, 0.0),
                          child: Container(
                            width: 120.0,
                            height: 120.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0),
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).tertiary,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/lactacao.fw.png',
                                        height: 35.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    StreamBuilder<
                                        List<AnimaisProdutoresRecord>>(
                                      stream: queryAnimaisProdutoresRecord(
                                        parent: widget.uidTecnico,
                                        queryBuilder:
                                            (animaisProdutoresRecord) =>
                                                animaisProdutoresRecord
                                                    .where(
                                                      'uidTecnicoPropriedade',
                                                      isEqualTo: widget
                                                          .uidPropriedade,
                                                    )
                                                    .where(
                                                      'grupoAnimal',
                                                      isEqualTo: 'Vacas',
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
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Color(0xFFF75E38),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        List<AnimaisProdutoresRecord>
                                            textAnimaisProdutoresRecordList =
                                            snapshot.data!;

                                        return Text(
                                          textAnimaisProdutoresRecordList
                                              .where((e) =>
                                                  (e.status == 'Vazia') ||
                                                  (e.status == 'Prenha') ||
                                                  (e.status == 'Inseminada') ||
                                                  (e.status == 'Inseminada PP'))
                                              .toList()
                                              .length
                                              .toString(),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.readexPro(
                                                  fontWeight: FontWeight.w800,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .tertiary,
                                                fontSize: 25.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w800,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Vacas em\nlactação',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 0.0, 0.0, 0.0),
                          child: Container(
                            width: 120.0,
                            height: 120.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0),
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).tertiary,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/dias-em-aberto.fw.png',
                                        height: 35.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    StreamBuilder<
                                        List<AnimaisProdutoresRecord>>(
                                      stream: queryAnimaisProdutoresRecord(
                                        parent: widget.uidTecnico,
                                        queryBuilder:
                                            (animaisProdutoresRecord) =>
                                                animaisProdutoresRecord
                                                    .where(
                                                      'uidTecnicoPropriedade',
                                                      isEqualTo: widget
                                                          .uidPropriedade,
                                                    )
                                                    .where(
                                                      'grupoAnimal',
                                                      isEqualTo: 'Vacas',
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
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Color(0xFFF75E38),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        List<AnimaisProdutoresRecord>
                                            textAnimaisProdutoresRecordList =
                                            snapshot.data!;

                                        return Text(
                                          valueOrDefault<String>(
                                            functions
                                                .calcularIntervaloMedio(
                                                    textAnimaisProdutoresRecordList
                                                        .where((e) =>
                                                            (e.dtUltimaInseminacao !=
                                                                    '') &&
                                                            (e.dtUltimoParto !=
                                                                    ''))
                                                        .toList()
                                                        .map((e) =>
                                                            e.dtUltimoParto)
                                                        .toList(),
                                                    textAnimaisProdutoresRecordList
                                                        .where((e) =>
                                                            (e.dtUltimaInseminacao !=
                                                                    '') &&
                                                            (e.dtUltimoParto !=
                                                                    ''))
                                                        .toList()
                                                        .map((e) => e.dtUltimaInseminacao)
                                                        .toList())
                                                ?.toString(),
                                            '0',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.readexPro(
                                                  fontWeight: FontWeight.w800,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .tertiary,
                                                fontSize: 25.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w800,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Dias em\naberto',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
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
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).tertiary,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      'assets/images/intervalo-partos.fw.png',
                                      height: 35.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StreamBuilder<List<AnimaisProdutoresRecord>>(
                                    stream: queryAnimaisProdutoresRecord(
                                      parent: widget.uidTecnico,
                                      queryBuilder: (animaisProdutoresRecord) =>
                                          animaisProdutoresRecord
                                              .where(
                                                'uidTecnicoPropriedade',
                                                isEqualTo:
                                                    widget.uidPropriedade,
                                              )
                                              .where(
                                                'grupoAnimal',
                                                isEqualTo: 'Vacas',
                                              )
                                              .where(
                                                'status',
                                                isNotEqualTo: 'Inseminada',
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
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Color(0xFFF75E38),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      List<AnimaisProdutoresRecord>
                                          textAnimaisProdutoresRecordList =
                                          snapshot.data!;

                                      return Text(
                                        valueOrDefault<String>(
                                          functions
                                              .mediaDiasEntreDatas(
                                                  textAnimaisProdutoresRecordList
                                                      .where((e) =>
                                                          (e.dtUltimoPartoContingencia !=
                                                                  '') &&
                                                          (e.dtPartoPrevisto !=
                                                                  ''))
                                                      .toList()
                                                      .map((e) => e
                                                          .dtUltimoPartoContingencia)
                                                      .toList(),
                                                  textAnimaisProdutoresRecordList
                                                      .where((e) =>
                                                          (e.dtUltimoPartoContingencia !=
                                                                  '') &&
                                                          (e.dtPartoPrevisto !=
                                                                  ''))
                                                      .toList()
                                                      .map((e) =>
                                                          e.dtPartoPrevisto)
                                                      .toList())
                                              ?.toString(),
                                          '0',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                fontWeight: FontWeight.w800,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .tertiary,
                                              fontSize: 25.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w800,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Intervalo entre\npartos',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 0.0, 0.0, 0.0),
                          child: Container(
                            width: 120.0,
                            height: 120.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0),
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).tertiary,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/media-producao.fw.png',
                                        height: 35.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    StreamBuilder<List<FinanceiroRecord>>(
                                      stream: queryFinanceiroRecord(
                                        parent: widget.uidTecnico,
                                        queryBuilder: (financeiroRecord) =>
                                            financeiroRecord
                                                .where(
                                                  'uidPropriedade',
                                                  isEqualTo:
                                                      widget.uidPropriedade,
                                                )
                                                .orderBy('dtRelatorio',
                                                    descending: true),
                                        singleRecord: true,
                                      ),
                                      builder: (context, snapshot) {
                                        // Customize what your widget looks like when it's loading.
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: SizedBox(
                                              width: 50.0,
                                              height: 50.0,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Color(0xFFF75E38),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        List<FinanceiroRecord>
                                            textFinanceiroRecordList =
                                            snapshot.data!;
                                        // Return an empty Container when the item does not exist.
                                        if (snapshot.data!.isEmpty) {
                                          return Container();
                                        }
                                        final textFinanceiroRecord =
                                            textFinanceiroRecordList.isNotEmpty
                                                ? textFinanceiroRecordList.first
                                                : null;

                                        return Text(
                                          valueOrDefault<String>(
                                            textFinanceiroRecord
                                                ?.mediaProducaoVaca,
                                            '0',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.readexPro(
                                                  fontWeight: FontWeight.w800,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .tertiary,
                                                fontSize: 25.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w800,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Média produção\nanimal',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 0.0, 0.0, 0.0),
                          child: Container(
                            width: 120.0,
                            height: 120.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0),
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).tertiary,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/custo-litro-leite.fw.png',
                                        height: 35.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    StreamBuilder<List<FinanceiroRecord>>(
                                      stream: queryFinanceiroRecord(
                                        parent: widget.uidTecnico,
                                        queryBuilder: (financeiroRecord) =>
                                            financeiroRecord
                                                .where(
                                                  'uidPropriedade',
                                                  isEqualTo:
                                                      widget.uidPropriedade,
                                                )
                                                .orderBy('dtRelatorio',
                                                    descending: true),
                                        singleRecord: true,
                                      ),
                                      builder: (context, snapshot) {
                                        // Customize what your widget looks like when it's loading.
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: SizedBox(
                                              width: 50.0,
                                              height: 50.0,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Color(0xFFF75E38),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        List<FinanceiroRecord>
                                            textFinanceiroRecordList =
                                            snapshot.data!;
                                        // Return an empty Container when the item does not exist.
                                        if (snapshot.data!.isEmpty) {
                                          return Container();
                                        }
                                        final textFinanceiroRecord =
                                            textFinanceiroRecordList.isNotEmpty
                                                ? textFinanceiroRecordList.first
                                                : null;

                                        return Text(
                                          valueOrDefault<String>(
                                            textFinanceiroRecord
                                                ?.custoLitroLeite,
                                            '0',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.readexPro(
                                                  fontWeight: FontWeight.w800,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .tertiary,
                                                fontSize: 25.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w800,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Custo litro\nleite',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
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
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).tertiary,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      'assets/images/litros-leite.fw.png',
                                      height: 35.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StreamBuilder<List<AnimaisProdutoresRecord>>(
                                    stream: queryAnimaisProdutoresRecord(
                                      parent: widget.uidTecnico,
                                      queryBuilder: (animaisProdutoresRecord) =>
                                          animaisProdutoresRecord.where(
                                        'uidTecnicoPropriedade',
                                        isEqualTo: widget.uidPropriedade,
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
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Color(0xFFF75E38),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      List<AnimaisProdutoresRecord>
                                          textAnimaisProdutoresRecordList =
                                          snapshot.data!;

                                      return Text(
                                        functions
                                            .somaDiasDesdeDatas(
                                                textAnimaisProdutoresRecordList
                                                    .where((e) =>
                                                        e.dtUltimoParto != '')
                                                    .toList()
                                                    .map((e) => e.dtUltimoParto)
                                                    .toList())
                                            .toString(),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                fontWeight: FontWeight.w800,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .tertiary,
                                              fontSize: 25.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w800,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'DEL',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
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
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 340.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 10.0, 10.0, 10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Categorias',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                FutureBuilder<List<AnimaisProdutoresRecord>>(
                                  future: queryAnimaisProdutoresRecordOnce(
                                    parent: widget.uidTecnico,
                                    queryBuilder: (animaisProdutoresRecord) =>
                                        animaisProdutoresRecord
                                            .where(
                                              'uidTecnicoPropriedade',
                                              isEqualTo: widget.uidPropriedade,
                                            )
                                            .where(
                                              'grupoAnimal',
                                              isNotEqualTo: 'Sêmens',
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
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Color(0xFFF75E38),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    List<AnimaisProdutoresRecord>
                                        chartAnimaisProdutoresRecordList =
                                        snapshot.data!;

                                    return Container(
                                      width: 330.0,
                                      height: 500.0,
                                      child: Stack(
                                        children: [
                                          FlutterFlowPieChart(
                                            data: FFPieChartData(
                                              values: functions
                                                  .retornaContagemGrupos(
                                                      chartAnimaisProdutoresRecordList
                                                          .map((e) =>
                                                              e.grupoAnimal)
                                                          .toList()
                                                          .where((e) =>
                                                              e != 'Sêmens')
                                                          .toList()),
                                              colors: chartPieChartColorsList1,
                                              radius: [80.0],
                                              borderColor: [Color(0x00000000)],
                                            ),
                                            donutHoleRadius: 0.0,
                                            donutHoleColor: Colors.transparent,
                                            sectionLabelType:
                                                PieChartSectionLabelType
                                                    .percent,
                                            sectionLabelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineSmall
                                                    .override(
                                                      font: GoogleFonts.outfit(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineSmall
                                                                .fontStyle,
                                                      ),
                                                      fontSize: 15.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineSmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineSmall
                                                              .fontStyle,
                                                    ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(1.0, 1.0),
                                            child: FlutterFlowChartLegendWidget(
                                              entries: functions
                                                  .retornaGruposUnicos(
                                                      chartAnimaisProdutoresRecordList
                                                          .map((e) =>
                                                              e.grupoAnimal)
                                                          .toList()
                                                          .where((e) =>
                                                              e != 'Sêmens')
                                                          .toList())
                                                  .asMap()
                                                  .entries
                                                  .map(
                                                    (label) => LegendEntry(
                                                      chartPieChartColorsList1[
                                                          label.key %
                                                              chartPieChartColorsList1
                                                                  .length],
                                                      label.value,
                                                    ),
                                                  )
                                                  .toList(),
                                              width: 150.0,
                                              height: 150.0,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.readexPro(
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
                                              textPadding: EdgeInsetsDirectional
                                                  .fromSTEB(5.0, 0.0, 0.0, 0.0),
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(5.0, 0.0, 5.0, 0.0),
                                              borderWidth: 1.0,
                                              borderColor: Colors.black,
                                              indicatorSize: 10.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 340.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 10.0, 10.0, 10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Reprodução',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                FutureBuilder<List<AnimaisProdutoresRecord>>(
                                  future: queryAnimaisProdutoresRecordOnce(
                                    parent: widget.uidTecnico,
                                    queryBuilder: (animaisProdutoresRecord) =>
                                        animaisProdutoresRecord
                                            .where(
                                              'uidTecnicoPropriedade',
                                              isEqualTo: widget.uidPropriedade,
                                            )
                                            .where(
                                              'grupoAnimal',
                                              isNotEqualTo: 'Sêmens',
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
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Color(0xFFF75E38),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    List<AnimaisProdutoresRecord>
                                        chartAnimaisProdutoresRecordList =
                                        snapshot.data!;

                                    return Container(
                                      width: 330.0,
                                      height: 500.0,
                                      child: Stack(
                                        children: [
                                          FlutterFlowPieChart(
                                            data: FFPieChartData(
                                              values: functions.retornaReproducaoQuantidade(
                                                  chartAnimaisProdutoresRecordList
                                                      .where((e) =>
                                                          ((e.status == 'Inseminada') ||
                                                              (e.status ==
                                                                  'Prenha') ||
                                                              (e.status ==
                                                                  'Vazia') ||
                                                              (e.status ==
                                                                  'Inseminada PP') ||
                                                              (e.status ==
                                                                  'Seca') ||
                                                              (e.status ==
                                                                  'Pré Parto')) &&
                                                          ((e.grupoAnimal ==
                                                                  'Vacas') ||
                                                              (e.grupoAnimal ==
                                                                  'Novilhas')))
                                                      .toList()
                                                      .map((e) => e.status)
                                                      .toList()),
                                              colors: chartPieChartColorsList2,
                                              radius: [80.0],
                                              borderColor: [Color(0x00000000)],
                                            ),
                                            donutHoleRadius: 0.0,
                                            donutHoleColor: Colors.transparent,
                                            sectionLabelType:
                                                PieChartSectionLabelType
                                                    .percent,
                                            sectionLabelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineSmall
                                                    .override(
                                                      font: GoogleFonts.outfit(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineSmall
                                                                .fontStyle,
                                                      ),
                                                      fontSize: 15.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineSmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineSmall
                                                              .fontStyle,
                                                    ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(1.0, 1.0),
                                            child: FlutterFlowChartLegendWidget(
                                              entries: functions
                                                  .retornaReproducaoStringHold(
                                                      chartAnimaisProdutoresRecordList
                                                          .where((e) =>
                                                              ((e.status ==
                                                                      'Inseminada') ||
                                                                  (e.status ==
                                                                      'Prenha') ||
                                                                  (e.status ==
                                                                      'Vazia') ||
                                                                  (e.status ==
                                                                      'Inseminada PP') ||
                                                                  (e.status ==
                                                                      'Seca') ||
                                                                  (e.status ==
                                                                      'Pré Parto')) &&
                                                              ((e.grupoAnimal ==
                                                                      'Vacas') ||
                                                                  (e.grupoAnimal ==
                                                                      'Novilhas')))
                                                          .toList()
                                                          .map((e) => e.status)
                                                          .toList())
                                                  .asMap()
                                                  .entries
                                                  .map(
                                                    (label) => LegendEntry(
                                                      chartPieChartColorsList2[
                                                          label.key %
                                                              chartPieChartColorsList2
                                                                  .length],
                                                      label.value,
                                                    ),
                                                  )
                                                  .toList(),
                                              width: 150.0,
                                              height: 150.0,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.readexPro(
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
                                              textPadding: EdgeInsetsDirectional
                                                  .fromSTEB(5.0, 0.0, 0.0, 0.0),
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(5.0, 0.0, 5.0, 0.0),
                                              borderWidth: 1.0,
                                              borderColor: Colors.black,
                                              indicatorSize: 10.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 340.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 10.0, 10.0, 10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Rebanho produtivo',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0.0, -1.0),
                                  child: FutureBuilder<
                                      List<AnimaisProdutoresRecord>>(
                                    future: queryAnimaisProdutoresRecordOnce(
                                      parent: widget.uidTecnico,
                                      queryBuilder: (animaisProdutoresRecord) =>
                                          animaisProdutoresRecord
                                              .where(
                                                'uidTecnicoPropriedade',
                                                isEqualTo:
                                                    widget.uidPropriedade,
                                              )
                                              .where(
                                                'grupoAnimal',
                                                isNotEqualTo: 'Sêmens',
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
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Color(0xFFF75E38),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      List<AnimaisProdutoresRecord>
                                          chartAnimaisProdutoresRecordList =
                                          snapshot.data!;

                                      return Container(
                                        width: double.infinity,
                                        height: 500.0,
                                        child: Stack(
                                          children: [
                                            FlutterFlowPieChart(
                                              data: FFPieChartData(
                                                values: functions.retornaRebanhoProdutivoId(
                                                    chartAnimaisProdutoresRecordList
                                                        .where((e) =>
                                                            ((e.status ==
                                                                    'Inseminada') ||
                                                                (e.status ==
                                                                    'Inseminada PP') ||
                                                                (e.status ==
                                                                    'Vazia') ||
                                                                (e.status ==
                                                                    'Prenha') ||
                                                                (e.status ==
                                                                    'Pré Parto') ||
                                                                (e.status ==
                                                                    'Seca')) &&
                                                            ((e.grupoAnimal ==
                                                                    'Vacas') ||
                                                                (e.grupoAnimal ==
                                                                    'Novilhas')))
                                                        .toList()
                                                        .map((e) => e.status)
                                                        .toList()),
                                                colors:
                                                    chartPieChartColorsList3,
                                                radius: [80.0],
                                                borderColor: [
                                                  Color(0x00000000)
                                                ],
                                              ),
                                              donutHoleRadius: 0.0,
                                              donutHoleColor:
                                                  Colors.transparent,
                                              sectionLabelType:
                                                  PieChartSectionLabelType
                                                      .percent,
                                              sectionLabelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineSmall
                                                      .override(
                                                        font:
                                                            GoogleFonts.outfit(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineSmall
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 15.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineSmall
                                                                .fontStyle,
                                                      ),
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -1.0, 1.0),
                                              child:
                                                  FlutterFlowChartLegendWidget(
                                                entries: functions
                                                    .retornaReproducaoString(chartAnimaisProdutoresRecordList
                                                        .where((e) =>
                                                            ((e.status ==
                                                                    'Inseminada') ||
                                                                (e.status ==
                                                                    'Inseminada PP') ||
                                                                (e.status ==
                                                                    'Vazia') ||
                                                                (e.status ==
                                                                    'Prenha') ||
                                                                (e.status ==
                                                                    'Pré Parto') ||
                                                                (e.status ==
                                                                    'Seca')) &&
                                                            ((e.grupoAnimal ==
                                                                    'Vacas') ||
                                                                (e.grupoAnimal ==
                                                                    'Novilhas')))
                                                        .toList()
                                                        .map((e) => e.status)
                                                        .toList())
                                                    .asMap()
                                                    .entries
                                                    .map(
                                                      (label) => LegendEntry(
                                                        chartPieChartColorsList3[
                                                            label.key %
                                                                chartPieChartColorsList3
                                                                    .length],
                                                        label.value,
                                                      ),
                                                    )
                                                    .toList(),
                                                width: 150.0,
                                                height: 150.0,
                                                textStyle: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font:
                                                          GoogleFonts.readexPro(
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
                                                textPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            5.0, 0.0, 0.0, 0.0),
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        5.0, 25.0, 5.0, 0.0),
                                                borderWidth: 1.0,
                                                borderColor: Colors.black,
                                                indicatorSize: 7.0,
                                                indicatorBorderRadius:
                                                    BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(0.0),
                                                  bottomRight:
                                                      Radius.circular(0.0),
                                                  topLeft: Radius.circular(0.0),
                                                  topRight:
                                                      Radius.circular(0.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
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
        ),
      ),
    );
  }
}
