import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/tecnico/propriedade/receituario/assinatura_produtor/assinatura_produtor_widget.dart';
import '/pages/tecnico/propriedade/receituario/assinatura_tecnico/assinatura_tecnico_widget.dart';
import '/pages/tecnico/propriedade/receituario/lista_animais_tratamentos/lista_animais_tratamentos_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'resumo_visita_atual_model.dart';
export 'resumo_visita_atual_model.dart';

class ResumoVisitaAtualWidget extends StatefulWidget {
  const ResumoVisitaAtualWidget({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.uidResumoVisita,
    required this.diasDg,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final DocumentReference? uidResumoVisita;
  final String? diasDg;

  static String routeName = 'resumoVisitaAtual';
  static String routePath = '/resumoVisitaAtual';

  @override
  State<ResumoVisitaAtualWidget> createState() =>
      _ResumoVisitaAtualWidgetState();
}

class _ResumoVisitaAtualWidgetState extends State<ResumoVisitaAtualWidget> {
  late ResumoVisitaAtualModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ResumoVisitaAtualModel());

    _model.obsGeralTextController ??= TextEditingController();
    _model.obsGeralFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ResumoDaVisitaRecord>(
      stream: ResumoDaVisitaRecord.getDocument(widget.uidResumoVisita!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFF75E38),
                  ),
                ),
              ),
            ),
          );
        }

        final resumoVisitaAtualResumoDaVisitaRecord = snapshot.data!;

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
                                context.goNamed(
                                  ReceituariosListaWidget.routeName,
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
                            'Visita ${resumoVisitaAtualResumoDaVisitaRecord.dtVisitaFormatado}',
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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 0.0),
                      child: StreamBuilder<List<RecomendacoesRecord>>(
                        stream: queryRecomendacoesRecord(
                          parent: widget.uidResumoVisita,
                          queryBuilder: (recomendacoesRecord) =>
                              recomendacoesRecord
                                  .where(
                                    'uidResumoDaVisita',
                                    isEqualTo: widget.uidResumoVisita,
                                  )
                                  .orderBy('tituloRecomendacao'),
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
                          List<RecomendacoesRecord>
                              listViewRecomendacoesRecordList = snapshot.data!;

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: listViewRecomendacoesRecordList.length,
                            itemBuilder: (context, listViewIndex) {
                              final listViewRecomendacoesRecord =
                                  listViewRecomendacoesRecordList[
                                      listViewIndex];
                              return ListaAnimaisTratamentosWidget(
                                key: Key(
                                    'Keydky_${listViewIndex}_of_${listViewRecomendacoesRecordList.length}'),
                                parameter1: listViewRecomendacoesRecord
                                    .tituloRecomendacao,
                                parameter2: widget.uidResumoVisita!,
                                obsRecomendacao: listViewRecomendacoesRecord
                                    .descricaoRecomendacao,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  if ((resumoVisitaAtualResumoDaVisitaRecord
                                  .assinaturaProdutor !=
                              '') ||
                      (resumoVisitaAtualResumoDaVisitaRecord
                                  .assinaturaTecnico !=
                              ''))
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            12.0, 0.0, 12.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (resumoVisitaAtualResumoDaVisitaRecord
                                        .dtAssinaturaFormatado !=
                                    '')
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 4.0, 0.0, 0.0),
                                child: Text(
                                  'Visita concluída e assinada em:',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        color: Color(0xFF606A85),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            if (resumoVisitaAtualResumoDaVisitaRecord
                                        .dtAssinaturaFormatado !=
                                    '')
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 4.0, 0.0, 12.0),
                                child: Text(
                                  resumoVisitaAtualResumoDaVisitaRecord
                                      .dtAssinaturaFormatado,
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        color: Color(0xFF606A85),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic,
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                              ),
                            if (resumoVisitaAtualResumoDaVisitaRecord
                                        .assinaturaTecnico !=
                                    '')
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 4.0, 0.0, 0.0),
                                child: Text(
                                  'Assinatura Técnico:',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        color: Color(0xFF606A85),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            if (resumoVisitaAtualResumoDaVisitaRecord
                                        .assinaturaTecnico !=
                                    '')
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    resumoVisitaAtualResumoDaVisitaRecord
                                        .assinaturaTecnico,
                                    width: 250.0,
                                    height: 80.0,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            if (resumoVisitaAtualResumoDaVisitaRecord
                                        .assinaturaProdutor !=
                                    '')
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 4.0, 0.0, 0.0),
                                child: Text(
                                  'Assinatura Produtor:',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        color: Color(0xFF606A85),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            if (resumoVisitaAtualResumoDaVisitaRecord
                                        .assinaturaProdutor !=
                                    '')
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    resumoVisitaAtualResumoDaVisitaRecord
                                        .assinaturaProdutor,
                                    width: 250.0,
                                    height: 80.0,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            if (resumoVisitaAtualResumoDaVisitaRecord
                                        .obsGeralVisita !=
                                    '')
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 10.0, 0.0, 0.0),
                                child: Text(
                                  'Observação geral visita:',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        color: Color(0xFF606A85),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            if (resumoVisitaAtualResumoDaVisitaRecord
                                        .obsGeralVisita !=
                                    '')
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 4.0, 0.0, 12.0),
                                child: Text(
                                  resumoVisitaAtualResumoDaVisitaRecord
                                      .obsGeralVisita,
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        color: Color(0xFF606A85),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic,
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  if ((resumoVisitaAtualResumoDaVisitaRecord
                                  .assinaturaProdutor ==
                              '') ||
                      (resumoVisitaAtualResumoDaVisitaRecord
                                  .assinaturaTecnico ==
                              ''))
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 0.0, 12.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if ((resumoVisitaAtualResumoDaVisitaRecord
                                                  .assinaturaProdutor ==
                                              '') &&
                                      (resumoVisitaAtualResumoDaVisitaRecord
                                                  .dtAssinaturaFormatado ==
                                              ''))
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 16.0, 0.0, 0.0),
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
                                                  child:
                                                      AssinaturaProdutorWidget(
                                                    uidResumoVisita: widget
                                                        .uidResumoVisita!,
                                                  ),
                                                ),
                                              );
                                            },
                                          ).then(
                                              (value) => safeSetState(() {}));
                                        },
                                        text: 'Assinatura Produtor Pendente',
                                        icon: Icon(
                                          Icons.assignment,
                                          size: 22.0,
                                        ),
                                        options: FFButtonOptions(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  1.0,
                                          height: 40.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  24.0, 0.0, 24.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.readexPro(
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
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 3.0,
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                  if ((resumoVisitaAtualResumoDaVisitaRecord
                                                  .assinaturaTecnico ==
                                              '') &&
                                      (resumoVisitaAtualResumoDaVisitaRecord
                                                  .dtAssinaturaFormatado ==
                                              ''))
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 16.0, 0.0, 0.0),
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
                                                  child:
                                                      AssinaturaTecnicoWidget(
                                                    uidResumoVisita: widget
                                                        .uidResumoVisita!,
                                                  ),
                                                ),
                                              );
                                            },
                                          ).then(
                                              (value) => safeSetState(() {}));
                                        },
                                        text: 'Assinatura Técnico Pendente',
                                        icon: Icon(
                                          Icons.assignment,
                                          size: 22.0,
                                        ),
                                        options: FFButtonOptions(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  1.0,
                                          height: 40.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  24.0, 0.0, 24.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: Color(0xFFBE6740),
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.readexPro(
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
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 3.0,
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (((resumoVisitaAtualResumoDaVisitaRecord
                                      .assinaturaProdutor !=
                                  '') ||
                          (resumoVisitaAtualResumoDaVisitaRecord
                                      .assinaturaTecnico !=
                                  '')) &&
                      (resumoVisitaAtualResumoDaVisitaRecord
                                  .obsGeralVisita ==
                              ''))
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 10.0, 12.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Observações gerais:',
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
                                  TextFormField(
                                    controller: _model.obsGeralTextController,
                                    focusNode: _model.obsGeralFocusNode,
                                    autofocus: false,
                                    obscureText: false,
                                    decoration: InputDecoration(
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
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
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
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              20.0, 24.0, 20.0, 24.0),
                                    ),
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
                                    maxLines: 3,
                                    maxLength: 100,
                                    maxLengthEnforcement:
                                        MaxLengthEnforcement.none,
                                    buildCounter: (context,
                                            {required currentLength,
                                            required isFocused,
                                            maxLength}) =>
                                        null,
                                    cursorColor:
                                        FlutterFlowTheme.of(context).primary,
                                    validator: _model
                                        .obsGeralTextControllerValidator
                                        .asValidator(context),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 16.0, 0.0, 0.0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        if ((resumoVisitaAtualResumoDaVisitaRecord
                                                        .assinaturaProdutor !=
                                                    '') ||
                                            (resumoVisitaAtualResumoDaVisitaRecord
                                                        .assinaturaTecnico !=
                                                    '')) {
                                          await widget.uidResumoVisita!.update(
                                              createResumoDaVisitaRecordData(
                                            dtAssinatura: getCurrentTimestamp,
                                            obsGeralVisita: _model
                                                .obsGeralTextController.text,
                                            dtAssinaturaFormatado:
                                                dateTimeFormat(
                                              "dd/MM/yyyy",
                                              getCurrentTimestamp,
                                              locale:
                                                  FFLocalizations.of(context)
                                                      .languageCode,
                                            ),
                                          ));
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title:
                                                    Text('Visita concluída!'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          context.goNamed(
                                            ReceituariosListaWidget.routeName,
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
                                              'visitaPresencial':
                                                  serializeParam(
                                                widget.visitaPresencial,
                                                ParamType.bool,
                                              ),
                                              'diasDg': serializeParam(
                                                '',
                                                ParamType.String,
                                              ),
                                            }.withoutNulls,
                                          );

                                          return;
                                        } else {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Assinatura(s) pendente(s)!'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          return;
                                        }
                                      },
                                      text: 'Apenas Salvar',
                                      icon: Icon(
                                        Icons.check,
                                        size: 22.0,
                                      ),
                                      options: FFButtonOptions(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                1.0,
                                        height: 40.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 0.0, 24.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: Color(0xFF048508),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                              color: Colors.white,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                        elevation: 3.0,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 16.0, 0.0, 16.0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        var _shouldSetState = false;
                                        if ((resumoVisitaAtualResumoDaVisitaRecord
                                                        .assinaturaProdutor !=
                                                    '') ||
                                            (resumoVisitaAtualResumoDaVisitaRecord
                                                        .assinaturaTecnico !=
                                                    '')) {
                                          _model.outUidPropriedade2 =
                                              await PropriedadesRecord
                                                  .getDocumentOnce(
                                                      widget.uidPropriedade!);
                                          _shouldSetState = true;
                                          _model.outUidTecnico2 =
                                              await TecnicoRecord
                                                  .getDocumentOnce(
                                                      widget.uidTecnico!);
                                          _shouldSetState = true;
                                          _model.outUidPersonTecnico2 =
                                              await queryPersonRecordOnce(
                                            queryBuilder: (personRecord) =>
                                                personRecord.where(
                                              'uid',
                                              isEqualTo: _model
                                                  .outUidTecnico2?.uidPerson,
                                            ),
                                            singleRecord: true,
                                          ).then((s) => s.firstOrNull);
                                          _shouldSetState = true;

                                          await widget.uidResumoVisita!.update(
                                              createResumoDaVisitaRecordData(
                                            dtAssinatura: getCurrentTimestamp,
                                            dtAssinaturaFormatado:
                                                dateTimeFormat(
                                              "dd/MM/yyyy",
                                              getCurrentTimestamp,
                                              locale:
                                                  FFLocalizations.of(context)
                                                      .languageCode,
                                            ),
                                            obsGeralVisita: _model
                                                .obsGeralTextController.text,
                                          ));
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title:
                                                    Text('Visita concluída!'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          context.goNamed(
                                            ReceituariosListaWidget.routeName,
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
                                              'visitaPresencial':
                                                  serializeParam(
                                                widget.visitaPresencial,
                                                ParamType.bool,
                                              ),
                                              'diasDg': serializeParam(
                                                '',
                                                ParamType.String,
                                              ),
                                            }.withoutNulls,
                                          );

                                          await actions.createReceituario(
                                            widget.uidResumoVisita!,
                                            _model.outUidPropriedade2
                                                ?.displayName,
                                            _model.outUidPropriedade2?.endereco,
                                            _model.outUidPersonTecnico2
                                                ?.displayName,
                                            _model.outUidPersonTecnico2
                                                ?.phoneNumber,
                                            resumoVisitaAtualResumoDaVisitaRecord
                                                .dtVisitaFormatado,
                                            _model.outUidPersonTecnico2?.email,
                                            _model
                                                .outUidPersonTecnico2?.empresa,
                                            'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/tecmuu-xingpe/assets/mjfv0ghrztrz/logo-2.png',
                                          );
                                          if (_shouldSetState)
                                            safeSetState(() {});
                                          return;
                                        } else {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Assinatura(s) pendente(s)!'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          if (_shouldSetState)
                                            safeSetState(() {});
                                          return;
                                        }

                                        if (_shouldSetState)
                                          safeSetState(() {});
                                      },
                                      text: 'Salvar e gerar PDF',
                                      icon: Icon(
                                        Icons.playlist_add_check_rounded,
                                        size: 22.0,
                                      ),
                                      options: FFButtonOptions(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                1.0,
                                        height: 40.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 0.0, 24.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                              color: Colors.white,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                        elevation: 3.0,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (((resumoVisitaAtualResumoDaVisitaRecord
                                      .assinaturaProdutor !=
                                  '') ||
                          (resumoVisitaAtualResumoDaVisitaRecord
                                      .assinaturaTecnico !=
                                  '')) &&
                      (resumoVisitaAtualResumoDaVisitaRecord
                                  .obsGeralVisita !=
                              '') &&
                      (resumoVisitaAtualResumoDaVisitaRecord
                                  .dtAssinaturaFormatado !=
                              ''))
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 0.0, 12.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 16.0, 0.0, 16.0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        _model.outUidPropriedade =
                                            await PropriedadesRecord
                                                .getDocumentOnce(
                                                    widget.uidPropriedade!);
                                        _model.outUidTecnico =
                                            await TecnicoRecord.getDocumentOnce(
                                                widget.uidTecnico!);
                                        _model.outUidPersonTecnico =
                                            await queryPersonRecordOnce(
                                          queryBuilder: (personRecord) =>
                                              personRecord.where(
                                            'uid',
                                            isEqualTo:
                                                _model.outUidTecnico?.uidPerson,
                                          ),
                                          singleRecord: true,
                                        ).then((s) => s.firstOrNull);
                                        await actions.createReceituario(
                                          widget.uidResumoVisita!,
                                          _model.outUidPropriedade?.displayName,
                                          _model.outUidPropriedade?.endereco,
                                          _model
                                              .outUidPersonTecnico?.displayName,
                                          _model
                                              .outUidPersonTecnico?.phoneNumber,
                                          resumoVisitaAtualResumoDaVisitaRecord
                                              .dtVisitaFormatado,
                                          _model.outUidPersonTecnico?.email,
                                          _model.outUidPersonTecnico?.empresa,
                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/tecmuu-xingpe/assets/mjfv0ghrztrz/logo-2.png',
                                        );

                                        safeSetState(() {});
                                      },
                                      text: 'Gerar PDF',
                                      icon: Icon(
                                        Icons.playlist_add_check_rounded,
                                        size: 22.0,
                                      ),
                                      options: FFButtonOptions(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                1.0,
                                        height: 40.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 0.0, 24.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                              color: Colors.white,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                        elevation: 3.0,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
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
  }
}
