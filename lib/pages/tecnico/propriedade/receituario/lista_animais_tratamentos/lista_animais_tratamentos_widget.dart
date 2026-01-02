import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lista_animais_tratamentos_model.dart';
export 'lista_animais_tratamentos_model.dart';

class ListaAnimaisTratamentosWidget extends StatefulWidget {
  const ListaAnimaisTratamentosWidget({
    super.key,
    this.parameter1,
    required this.parameter2,
    this.obsRecomendacao,
  });

  final String? parameter1;
  final DocumentReference? parameter2;
  final String? obsRecomendacao;

  @override
  State<ListaAnimaisTratamentosWidget> createState() =>
      _ListaAnimaisTratamentosWidgetState();
}

class _ListaAnimaisTratamentosWidgetState
    extends State<ListaAnimaisTratamentosWidget> {
  late ListaAnimaisTratamentosModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListaAnimaisTratamentosModel());

    _model.tratamentoRecomendacaoTextController ??=
        TextEditingController(text: widget.obsRecomendacao);
    _model.tratamentoRecomendacaoFocusNode ??= FocusNode();
    _model.tratamentoRecomendacaoFocusNode!.addListener(
      () async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Atualizado com sucesso!',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            duration: Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
          ),
        );
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                child: Text(
                  widget.parameter1!,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
              ),
            ],
          ),
          if ((widget.parameter1 == 'Secagem') ||
              (widget.parameter1 == 'Pré Parto'))
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
              child: StreamBuilder<List<TratamentosRecord>>(
                stream: queryTratamentosRecord(
                  parent: widget.parameter2,
                  queryBuilder: (tratamentosRecord) => tratamentosRecord
                      .where(
                        'tipoAcao',
                        isEqualTo: widget.parameter1,
                      )
                      .where(
                        'uidResumoDaVisita',
                        isEqualTo: widget.parameter2,
                      )
                      .orderBy('compararDtUltimaInseminacao')
                      .orderBy('brincoAnimalOrder')
                      .orderBy('nomeAnimal'),
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
                  List<TratamentosRecord> listViewTratamentosRecordList =
                      snapshot.data!;

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: listViewTratamentosRecordList.length,
                    itemBuilder: (context, listViewIndex) {
                      final listViewTratamentosRecord =
                          listViewTratamentosRecordList[listViewIndex];
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 10.0, 0.0),
                            child: StreamBuilder<AnimaisProdutoresRecord>(
                              stream: AnimaisProdutoresRecord.getDocument(
                                  listViewTratamentosRecord.uidAnimal!),
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

                                final iconAnimaisProdutoresRecord =
                                    snapshot.data!;

                                return Icon(
                                  Icons.circle_sharp,
                                  color: () {
                                    if (iconAnimaisProdutoresRecord
                                            .grupoAnimal ==
                                        'Vacas') {
                                      return Color(0xFF048508);
                                    } else if (iconAnimaisProdutoresRecord
                                            .grupoAnimal ==
                                        'Novilhas') {
                                      return Color(0xFFFF0076);
                                    } else {
                                      return FlutterFlowTheme.of(context)
                                          .tertiary;
                                    }
                                  }(),
                                  size: 10.0,
                                );
                              },
                            ),
                          ),
                          StreamBuilder<AnimaisProdutoresRecord>(
                            stream: AnimaisProdutoresRecord.getDocument(
                                listViewTratamentosRecord.uidAnimal!),
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

                              final textAnimaisProdutoresRecord =
                                  snapshot.data!;

                              return Text(
                                () {
                                  if ((textAnimaisProdutoresRecord
                                                  .nomeAnimal !=
                                              '') &&
                                      (textAnimaisProdutoresRecord
                                              .brincoAnimal !=
                                          null) &&
                                      (textAnimaisProdutoresRecord
                                              .brincoAnimal !=
                                          -1)) {
                                    return '${textAnimaisProdutoresRecord.nomeAnimal} - ${textAnimaisProdutoresRecord.brincoAnimal.toString()}';
                                  } else if (textAnimaisProdutoresRecord.nomeAnimal !=
                                          '') {
                                    return textAnimaisProdutoresRecord
                                        .nomeAnimal;
                                  } else {
                                    return textAnimaisProdutoresRecord
                                        .brincoAnimal
                                        .toString();
                                  }
                                }(),
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
                              );
                            },
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 10.0, 0.0),
                            child: StreamBuilder<AnimaisProdutoresRecord>(
                              stream: AnimaisProdutoresRecord.getDocument(
                                  listViewTratamentosRecord.uidAnimal!),
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

                                final textAnimaisProdutoresRecord =
                                    snapshot.data!;

                                return Text(
                                  () {
                                    if (widget.parameter1 == 'Secagem') {
                                      return ' - ${textAnimaisProdutoresRecord.dtSecPrevista}';
                                    } else if (widget.parameter1 ==
                                        'Pré Parto') {
                                      return ' - ${textAnimaisProdutoresRecord.dtPrePartoPrevista}';
                                    } else {
                                      return ' - ${listViewTratamentosRecord.observacaoAcao}';
                                    }
                                  }(),
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
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          if ((widget.parameter1 != 'Secagem') &&
              (widget.parameter1 != 'Pré Parto'))
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
              child: StreamBuilder<List<TratamentosRecord>>(
                stream: queryTratamentosRecord(
                  parent: widget.parameter2,
                  queryBuilder: (tratamentosRecord) => tratamentosRecord
                      .where(
                        'tipoAcao',
                        isEqualTo: widget.parameter1,
                      )
                      .where(
                        'uidResumoDaVisita',
                        isEqualTo: widget.parameter2,
                      )
                      .orderBy('brincoAnimalOrder')
                      .orderBy('nomeAnimal'),
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
                  List<TratamentosRecord> listViewTratamentosRecordList =
                      snapshot.data!;

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: listViewTratamentosRecordList.length,
                    itemBuilder: (context, listViewIndex) {
                      final listViewTratamentosRecord =
                          listViewTratamentosRecordList[listViewIndex];
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 10.0, 0.0),
                            child: StreamBuilder<AnimaisProdutoresRecord>(
                              stream: AnimaisProdutoresRecord.getDocument(
                                  listViewTratamentosRecord.uidAnimal!),
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

                                final iconAnimaisProdutoresRecord =
                                    snapshot.data!;

                                return Icon(
                                  Icons.circle_sharp,
                                  color: () {
                                    if (iconAnimaisProdutoresRecord
                                            .grupoAnimal ==
                                        'Vacas') {
                                      return Color(0xFF048508);
                                    } else if (iconAnimaisProdutoresRecord
                                            .grupoAnimal ==
                                        'Novilhas') {
                                      return Color(0xFFFF0076);
                                    } else {
                                      return FlutterFlowTheme.of(context)
                                          .tertiary;
                                    }
                                  }(),
                                  size: 10.0,
                                );
                              },
                            ),
                          ),
                          StreamBuilder<AnimaisProdutoresRecord>(
                            stream: AnimaisProdutoresRecord.getDocument(
                                listViewTratamentosRecord.uidAnimal!),
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

                              final textAnimaisProdutoresRecord =
                                  snapshot.data!;

                              return Text(
                                () {
                                  if ((textAnimaisProdutoresRecord
                                                  .nomeAnimal !=
                                              '') &&
                                      (textAnimaisProdutoresRecord
                                              .brincoAnimal !=
                                          null) &&
                                      (textAnimaisProdutoresRecord
                                              .brincoAnimal !=
                                          -1)) {
                                    return '${textAnimaisProdutoresRecord.nomeAnimal} - ${textAnimaisProdutoresRecord.brincoAnimal.toString()}';
                                  } else if (textAnimaisProdutoresRecord.nomeAnimal !=
                                          '') {
                                    return textAnimaisProdutoresRecord
                                        .nomeAnimal;
                                  } else {
                                    return textAnimaisProdutoresRecord
                                        .brincoAnimal
                                        .toString();
                                  }
                                }(),
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
                              );
                            },
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 10.0, 0.0),
                            child: StreamBuilder<AnimaisProdutoresRecord>(
                              stream: AnimaisProdutoresRecord.getDocument(
                                  listViewTratamentosRecord.uidAnimal!),
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

                                final textAnimaisProdutoresRecord =
                                    snapshot.data!;

                                return Text(
                                  () {
                                    if (widget.parameter1 == 'Secagem') {
                                      return ' - ${textAnimaisProdutoresRecord.dtSecPrevista}';
                                    } else if (widget.parameter1 ==
                                        'Pré Parto') {
                                      return ' - ${textAnimaisProdutoresRecord.dtPrePartoPrevista}';
                                    } else {
                                      return ' - ${listViewTratamentosRecord.observacaoAcao}';
                                    }
                                  }(),
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
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(5.0, 10.0, 5.0, 20.0),
                  child: TextFormField(
                    controller: _model.tratamentoRecomendacaoTextController,
                    focusNode: _model.tratamentoRecomendacaoFocusNode,
                    onChanged: (_) => EasyDebounce.debounce(
                      '_model.tratamentoRecomendacaoTextController',
                      Duration(milliseconds: 2000),
                      () async {
                        _model.outUidRecomendacaoObs =
                            await queryRecomendacoesRecordOnce(
                          parent: widget.parameter2,
                          queryBuilder: (recomendacoesRecord) =>
                              recomendacoesRecord.where(
                            'tituloRecomendacao',
                            isEqualTo: widget.parameter1,
                          ),
                          singleRecord: true,
                        ).then((s) => s.firstOrNull);

                        await _model.outUidRecomendacaoObs!.reference
                            .update(createRecomendacoesRecordData(
                          descricaoRecomendacao:
                              _model.tratamentoRecomendacaoTextController.text,
                        ));

                        safeSetState(() {});
                      },
                    ),
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Tratamento:',
                      labelStyle:
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
                      hintStyle:
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
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primary,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                    maxLines: 4,
                    validator: _model
                        .tratamentoRecomendacaoTextControllerValidator
                        .asValidator(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
