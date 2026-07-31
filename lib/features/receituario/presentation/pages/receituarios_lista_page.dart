import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/core/ui/app_card.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import 'resumo_visita_atual_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReceituariosListaPage extends StatefulWidget {
  const ReceituariosListaPage({
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

  static String routeName = 'receituariosLista';
  static String routePath = '/receituariosLista';

  @override
  State<ReceituariosListaPage> createState() => _ReceituariosListaPageState();
}

class _ReceituariosListaPageState extends State<ReceituariosListaPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Widget _cabecalho(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
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
              context.safePop();
            },
          ),
        ),
        Text(
          'Receituários',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                font: GoogleFonts.outfit(
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
                color: Colors.white,
                fontSize: 22.0,
                letterSpacing: 0.0,
                fontWeight:
                    FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                fontStyle:
                    FlutterFlowTheme.of(context).headlineMedium.fontStyle,
              ),
        ),
      ],
    );
  }

  /// `resumo_da_visita` é coleção TOP-LEVEL, então a referência é reconstruída
  /// só com o `firestoreId`.
  DocumentReference? _refDoResumo(ResumoVisitaEntity e) {
    if (e.firestoreId == null) return null;
    return FirebaseFirestore.instance.doc('resumo_da_visita/${e.firestoreId}');
  }

  /// Receituário assinado: tem ao menos uma assinatura E a data de assinatura.
  /// Campos são nullable no entity, daí o `?? ''`.
  bool _assinado(ResumoVisitaEntity e) {
    final temAssinatura =
        (e.assinaturaProdutor ?? '') != '' || (e.assinaturaTecnico ?? '') != '';
    return temAssinatura && (e.dtAssinaturaFormatado ?? '') != '';
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
                      _cabecalho(context),
                    ],
                  ),
                  centerTitle: true,
                  expandedTitleScale: 1.0,
                ),
                elevation: 0.0,
              )),
        ),
        // Fonte única ObjectBox (offline-first): permite consultar receituários
        // já emitidos sem rede. A EMISSÃO continua online, pois nasce do
        // bookkeeping de visita (ResumoDaVisita + Tratamentos + Recomendações).
        body: StreamBuilder<List<ResumoVisitaEntity>>(
          stream: ResumoVisitaRepository()
              .watchByPropriedade(widget.uidPropriedade?.path ?? ''),
          builder: (context, snapshot) {
            final listViewResumoDaVisitaRecordList = (snapshot.data ??
                    <ResumoVisitaEntity>[])
                .where((e) => !e.isDeleted)
                .toList()
              ..sort((a, b) => (b.dtVisita ?? DateTime(1900))
                  .compareTo(a.dtVisita ?? DateTime(1900)));

            return ListView.builder(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: listViewResumoDaVisitaRecordList.length,
              itemBuilder: (context, listViewIndex) {
                final listViewResumoDaVisitaRecord =
                    listViewResumoDaVisitaRecordList[listViewIndex];
                return Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 10.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.pushNamed(
                          ResumoVisitaAtualPage.routeName,
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
                            'uidResumoVisita': serializeParam(
                              _refDoResumo(listViewResumoDaVisitaRecord),
                              ParamType.DocumentReference,
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
                          color: _assinado(listViewResumoDaVisitaRecord)
                              ? FlutterFlowTheme.of(context).secondaryBackground
                              : Color(0xFFFFB0B0),
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: AppTokens.softShadow(context),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 12.0, 16.0, 12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: GridView(
                                  padding: EdgeInsets.zero,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 0.0,
                                    childAspectRatio: 2.0,
                                  ),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFD8D8D8),
                                            shape: BoxShape.circle,
                                          ),
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: FlutterFlowIconButton(
                                            borderRadius: 20.0,
                                            borderWidth: 1.0,
                                            buttonSize: 40.0,
                                            icon: Icon(
                                              Icons.calendar_month,
                                              color: Color(0xFF048508),
                                              size: 24.0,
                                            ),
                                            onPressed: () {
                                              print('IconButton pressed ...');
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dateTimeFormat(
                                            "dd/MM/yyyy",
                                            listViewResumoDaVisitaRecord
                                                .dtVisita!,
                                            locale: FFLocalizations.of(context)
                                                .languageCode,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                font: GoogleFonts.readexPro(
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
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .fontStyle,
                                              ),
                                        ),
                                        Text(
                                          'Ver detalhes...',
                                          style: FlutterFlowTheme.of(context)
                                              .labelMedium
                                              .override(
                                                font: GoogleFonts.readexPro(
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
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        FlutterFlowIconButton(
                                          borderRadius: 20.0,
                                          borderWidth: 1.0,
                                          buttonSize: 40.0,
                                          icon: Icon(
                                            Icons.keyboard_arrow_right,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 24.0,
                                          ),
                                          onPressed: () async {
                                            context.pushNamed(
                                              ResumoVisitaAtualPage.routeName,
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
                                                'visitaPresencial':
                                                    serializeParam(
                                                  widget.visitaPresencial,
                                                  ParamType.bool,
                                                ),
                                                'uidResumoVisita':
                                                    serializeParam(
                                                  _refDoResumo(
                                                      listViewResumoDaVisitaRecord),
                                                  ParamType.DocumentReference,
                                                ),
                                                'diasDg': serializeParam(
                                                  widget.diasDg,
                                                  ParamType.String,
                                                ),
                                              }.withoutNulls,
                                            );
                                          },
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
      ),
    );
  }
}
