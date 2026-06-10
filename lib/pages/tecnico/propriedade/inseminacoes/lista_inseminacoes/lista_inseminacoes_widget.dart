// ignore_for_file: unnecessary_null_comparison, unused_import

import '/backend/backend.dart';
import '/domain/animais/classificacao_animal.dart';
import '/backend/objectbox/index.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/pages/tecnico/propriedade/animals/descarte_animal/descarte_animal_widget.dart';
import '/pages/tecnico/propriedade/inseminacoes/nova_inseminacao/nova_inseminacao_widget.dart';
import '/pages/tecnico/propriedade/inseminacoes/registrar_cio/registrar_cio_widget.dart';
import '/pages/tecnico/propriedade/sincronizacao/alerta_sem_internet/alerta_sem_internet_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
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

  /// Lista de animais existentes (fonte ObjectBox). Antes em
  /// FFAppState.animaisProdutoresExistentes; agora estado local desta tela.
  List<AnimaisProdutoresStruct> _animaisExistentes = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListaInseminacoesModel());

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
            // sem modal bloqueante nem flag global. O respostaNet acima já
            // atualiza a UI e o sync ao reconectar é automático.
          }
        },
        startImmediately: false,
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

  /// Card extraído do build (Fase 4).
  Widget _buildCard2(
      BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Visibility(
      visible: (item.uidTecnicoPropriedade == widget.uidPropriedade) &&
          ((item.nomeAnimal.toLowerCase().contains(
                  _model.searchListTextController.text.toLowerCase())) ||
              (item.brincoAnimal
                  .toString()
                  .contains(_model.searchListTextController.text))) &&
          ehElegivelInseminacao(item.grupoAnimal, item.status),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
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
    );
  }

  /// Card extraído do build (Fase 4).
  Widget _buildCard1(
      BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Visibility(
      visible: (item.uidTecnicoPropriedade == widget.uidPropriedade) &&
          (((ehVaca(item.grupoAnimal)) || (ehNovilha(item.grupoAnimal))) &&
              ((ehVazia(item.status)) ||
                  (ehInseminada(item.status)) ||
                  (ehInseminadaPP(item.status)))),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
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
            children: [_part2(context, item, index)],
          ),
        ),
      ),
    );
  }

  Widget _part1(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Container(
      width: 360.0,
      height: 140.0,
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
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
            child: Container(
              width: 44.0,
              height: 44.0,
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
                      fontStyle:
                          FlutterFlowTheme.of(context).titleMedium.fontStyle,
                    ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
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
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight:
                              FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                        ),
                  ),
                  if (item.dtUltimaInseminacao != '')
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                      child: Text(
                        'Última insem.: ${item.dtUltimaInseminacao}',
                        style:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
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
                      ),
                    ),
                  if ((ehInseminada(item.status)) ||
                      (ehInseminadaPP(item.status)))
                    Text(
                      'Inseminada',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.readexPro(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: Color(0xFF048508),
                            fontSize: 11.0,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
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
                                    child: RegistrarCioWidget(
                                      uidPropriedade: widget.uidPropriedade!,
                                      nomePropriedade: widget.nomePropriedade!,
                                      uidTecnico: widget.uidTecnico!,
                                      emailPropriedade:
                                          widget.emailPropriedade!,
                                      uidAnimaisProdutores: item.uidAnimal,
                                      uidAnimalOffline: item.uidAnimalOffline,
                                      grupoPredominante: item.grupoAnimal,
                                      nomeAnimal: item.nomeAnimal,
                                      visitaPresencial:
                                          widget.visitaPresencial!,
                                      brincoAnimal:
                                          item.brincoAnimal.toString(),
                                      diasDg: widget.diasDg!,
                                    ),
                                  ),
                                );
                              },
                            ).then((value) => safeSetState(() {}));
                          },
                          text: 'Fez Cio',
                          icon: Icon(
                            Icons.repeat,
                            size: 15.0,
                          ),
                          options: FFButtonOptions(
                            height: 30.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 0.0, 10.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: Color(0xFF1A03E9),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
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
                      SizedBox(width: 8.0),
                      Expanded(
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
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  child: Padding(
                                    padding: MediaQuery.viewInsetsOf(context),
                                    child: NovaInseminacaoWidget(
                                      uidPropriedade: widget.uidPropriedade!,
                                      nomePropriedade: widget.nomePropriedade!,
                                      uidTecnico: widget.uidTecnico!,
                                      emailPropriedade:
                                          widget.emailPropriedade!,
                                      grupoPredominante: item.grupoAnimal,
                                      nomeAnimal: item.nomeAnimal,
                                      visitaPresencial:
                                          widget.visitaPresencial!,
                                      dtUltimaInseminacao:
                                          item.dtUltimaInseminacao,
                                      brincoAnimal:
                                          item.brincoAnimal.toString(),
                                      diasDg: widget.diasDg!,
                                      uidAnimaisProdutores: item.uidAnimal,
                                      uidAnimalOffline: item.uidAnimalOffline,
                                    ),
                                  ),
                                );
                              },
                            ).then((value) => safeSetState(() {}));
                          },
                          text: 'Inseminar',
                          icon: Icon(
                            Icons.playlist_add,
                            size: 15.0,
                          ),
                          options: FFButtonOptions(
                            height: 30.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 0.0, 10.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: Color(0xFF7E39EF),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _part2(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Container(
      width: 360.0,
      height: 140.0,
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
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
            child: Container(
              width: 44.0,
              height: 44.0,
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
                      fontStyle:
                          FlutterFlowTheme.of(context).titleMedium.fontStyle,
                    ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
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
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight:
                              FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                        ),
                  ),
                  if (item.dtUltimaInseminacao != '')
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                      child: Text(
                        'Última insem.: ${item.dtUltimaInseminacao}',
                        style:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
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
                      ),
                    ),
                  if ((ehInseminada(item.status)) ||
                      (ehInseminadaPP(item.status)))
                    Text(
                      'Inseminada',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.readexPro(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: Color(0xFF048508),
                            fontSize: 11.0,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
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
                                    child: RegistrarCioWidget(
                                      uidPropriedade: widget.uidPropriedade!,
                                      nomePropriedade: widget.nomePropriedade!,
                                      uidTecnico: widget.uidTecnico!,
                                      emailPropriedade:
                                          widget.emailPropriedade!,
                                      uidAnimaisProdutores: item.uidAnimal,
                                      uidAnimalOffline: item.uidAnimalOffline,
                                      grupoPredominante: item.grupoAnimal,
                                      nomeAnimal: item.nomeAnimal,
                                      visitaPresencial:
                                          widget.visitaPresencial!,
                                      brincoAnimal:
                                          item.brincoAnimal.toString(),
                                      diasDg: widget.diasDg!,
                                    ),
                                  ),
                                );
                              },
                            ).then((value) => safeSetState(() {}));
                          },
                          text: 'Fez Cio',
                          icon: Icon(
                            Icons.repeat,
                            size: 15.0,
                          ),
                          options: FFButtonOptions(
                            height: 30.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 0.0, 10.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: Color(0xFF1A03E9),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
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
                      SizedBox(width: 8.0),
                      Expanded(
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
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  child: Padding(
                                    padding: MediaQuery.viewInsetsOf(context),
                                    child: NovaInseminacaoWidget(
                                      uidPropriedade: widget.uidPropriedade!,
                                      nomePropriedade: widget.nomePropriedade!,
                                      uidTecnico: widget.uidTecnico!,
                                      emailPropriedade:
                                          widget.emailPropriedade!,
                                      grupoPredominante: item.grupoAnimal,
                                      nomeAnimal: item.nomeAnimal,
                                      visitaPresencial:
                                          widget.visitaPresencial!,
                                      dtUltimaInseminacao:
                                          item.dtUltimaInseminacao,
                                      brincoAnimal:
                                          item.brincoAnimal.toString(),
                                      diasDg: widget.diasDg!,
                                      uidAnimaisProdutores: item.uidAnimal,
                                      uidAnimalOffline: item.uidAnimalOffline,
                                    ),
                                  ),
                                );
                              },
                            ).then((value) => safeSetState(() {}));
                          },
                          text: 'Inseminar',
                          icon: Icon(
                            Icons.playlist_add,
                            size: 15.0,
                          ),
                          options: FFButtonOptions(
                            height: 30.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 0.0, 10.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: Color(0xFF7E39EF),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
                                onChanged: (_) {
                                  safeSetState(() {});
                                },
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
              if (_model.searchListTextController.text == '')
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
                      Builder(
                        builder: (context) {
                          final listaAnimaisOfflineExistente =
                              _animaisExistentes.toList();

                          return ListView.builder(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 120.0),
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: listaAnimaisOfflineExistente.length,
                            itemBuilder:
                                (context, listaAnimaisOfflineExistenteIndex) {
                              final listaAnimaisOfflineExistenteItem =
                                  listaAnimaisOfflineExistente[
                                      listaAnimaisOfflineExistenteIndex];
                              return _buildCard1(
                                  context,
                                  listaAnimaisOfflineExistenteItem,
                                  listaAnimaisOfflineExistenteIndex);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              if (_model.searchListTextController.text != '')
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
                      if (_model.searchListTextController.text != '')
                        Builder(
                          builder: (context) {
                            final listaAnimaisOfflineExistente =
                                _animaisExistentes.toList();

                            return ListView.builder(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 120.0),
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: listaAnimaisOfflineExistente.length,
                              itemBuilder:
                                  (context, listaAnimaisOfflineExistenteIndex) {
                                final listaAnimaisOfflineExistenteItem =
                                    listaAnimaisOfflineExistente[
                                        listaAnimaisOfflineExistenteIndex];
                                return _buildCard2(
                                    context,
                                    listaAnimaisOfflineExistenteItem,
                                    listaAnimaisOfflineExistenteIndex);
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
