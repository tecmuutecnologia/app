// ignore_for_file: unnecessary_null_comparison

import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/domain/animais/classificacao_animal.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  FocusNode? _tratamentoRecomendacaoFocusNode;
  TextEditingController? _tratamentoRecomendacaoTextController;
  final String? Function(BuildContext, String?)?
      _tratamentoRecomendacaoTextControllerValidator = null;

  @override
  void initState() {
    super.initState();

    _tratamentoRecomendacaoTextController ??=
        TextEditingController(text: widget.obsRecomendacao);
    _tratamentoRecomendacaoFocusNode ??= FocusNode();
    _tratamentoRecomendacaoFocusNode!.addListener(
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
    _tratamentoRecomendacaoFocusNode?.dispose();
    _tratamentoRecomendacaoTextController?.dispose();

    super.dispose();
  }

  /// Animal do tratamento, resolvido do ObjectBox pelo caminho guardado.
  /// Antes cada item da lista abria um StreamBuilder do Firestore — uma
  /// leitura de rede por linha, que offline nunca resolvia.
  AnimaisProdutoresStruct? _animalDoTratamento(TratamentoEntity t) {
    final caminho = t.uidAnimalPath;
    if (caminho == null || caminho.isEmpty) return null;
    final entity = AnimalRepository().getByFirestoreId(caminho.split('/').last);
    return entity == null ? null : animalEntityToStruct(entity);
  }

  /// Caminho do resumo da visita — é por ele que tratamentos e recomendações
  /// se ligam à visita agora (campo, não hierarquia).
  String? get _resumoPath => widget.parameter2 == null
      ? null
      : 'resumo_da_visita/${widget.parameter2!.id}';

  /// Tratamentos desta visita e deste tipo de ação, ordenados como a query
  /// original: data de inseminação, depois brinco, depois nome.
  List<TratamentoEntity> _tratamentosDaVisita() {
    final lista = TratamentoRepository()
        .getAll()
        .where((e) =>
            !e.isDeleted &&
            e.uidResumoDaVisitaPath == _resumoPath &&
            e.tipoAcao == widget.parameter1)
        .toList();
    lista.sort((a, b) {
      final da = a.compararDtUltimaInseminacao;
      final db = b.compararDtUltimaInseminacao;
      if (da != null && db != null) {
        final c = da.compareTo(db);
        if (c != 0) return c;
      }
      final c = a.brincoAnimalOrder.compareTo(b.brincoAnimalOrder);
      if (c != 0) return c;
      return (a.nomeAnimal ?? '').compareTo(b.nomeAnimal ?? '');
    });
    return lista;
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
              // Tratamentos do ObjectBox, ligados pelo CAMPO uidResumoDaVisita
              // (viraram subcoleção da propriedade, não do resumo).
              child: Builder(
                builder: (context) {
                  final listViewTratamentosRecordList = _tratamentosDaVisita();

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
                            child: Builder(
                              builder: (context) {
                                final iconAnimaisProdutoresRecord =
                                    _animalDoTratamento(
                                        listViewTratamentosRecord);
                                if (iconAnimaisProdutoresRecord == null) {
                                  return const SizedBox.shrink();
                                }

                                return Icon(
                                  Icons.circle_sharp,
                                  color: () {
                                    if (ehVaca(iconAnimaisProdutoresRecord
                                        .grupoAnimal)) {
                                      return Color(0xFF048508);
                                    } else if (ehNovilha(
                                        iconAnimaisProdutoresRecord
                                            .grupoAnimal)) {
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
                          Builder(
                            builder: (context) {
                              final textAnimaisProdutoresRecord =
                                  _animalDoTratamento(
                                      listViewTratamentosRecord);
                              if (textAnimaisProdutoresRecord == null) {
                                return const SizedBox.shrink();
                              }

                              return Text(
                                () {
                                  if ((textAnimaisProdutoresRecord.nomeAnimal !=
                                          '') &&
                                      (textAnimaisProdutoresRecord
                                              .brincoAnimal !=
                                          null) &&
                                      (textAnimaisProdutoresRecord
                                              .brincoAnimal !=
                                          -1)) {
                                    return '${textAnimaisProdutoresRecord.nomeAnimal} - ${textAnimaisProdutoresRecord.brincoAnimal.toString()}';
                                  } else if (textAnimaisProdutoresRecord
                                          .nomeAnimal !=
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
                            child: Builder(
                              builder: (context) {
                                final textAnimaisProdutoresRecord =
                                    _animalDoTratamento(
                                        listViewTratamentosRecord);
                                if (textAnimaisProdutoresRecord == null) {
                                  return const SizedBox.shrink();
                                }

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
              // Tratamentos do ObjectBox, ligados pelo CAMPO uidResumoDaVisita
              // (viraram subcoleção da propriedade, não do resumo).
              child: Builder(
                builder: (context) {
                  final listViewTratamentosRecordList = _tratamentosDaVisita();

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
                            child: Builder(
                              builder: (context) {
                                final iconAnimaisProdutoresRecord =
                                    _animalDoTratamento(
                                        listViewTratamentosRecord);
                                if (iconAnimaisProdutoresRecord == null) {
                                  return const SizedBox.shrink();
                                }

                                return Icon(
                                  Icons.circle_sharp,
                                  color: () {
                                    if (ehVaca(iconAnimaisProdutoresRecord
                                        .grupoAnimal)) {
                                      return Color(0xFF048508);
                                    } else if (ehNovilha(
                                        iconAnimaisProdutoresRecord
                                            .grupoAnimal)) {
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
                          Builder(
                            builder: (context) {
                              final textAnimaisProdutoresRecord =
                                  _animalDoTratamento(
                                      listViewTratamentosRecord);
                              if (textAnimaisProdutoresRecord == null) {
                                return const SizedBox.shrink();
                              }

                              return Text(
                                () {
                                  if ((textAnimaisProdutoresRecord.nomeAnimal !=
                                          '') &&
                                      (textAnimaisProdutoresRecord
                                              .brincoAnimal !=
                                          null) &&
                                      (textAnimaisProdutoresRecord
                                              .brincoAnimal !=
                                          -1)) {
                                    return '${textAnimaisProdutoresRecord.nomeAnimal} - ${textAnimaisProdutoresRecord.brincoAnimal.toString()}';
                                  } else if (textAnimaisProdutoresRecord
                                          .nomeAnimal !=
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
                            child: Builder(
                              builder: (context) {
                                final textAnimaisProdutoresRecord =
                                    _animalDoTratamento(
                                        listViewTratamentosRecord);
                                if (textAnimaisProdutoresRecord == null) {
                                  return const SizedBox.shrink();
                                }

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
                    controller: _tratamentoRecomendacaoTextController,
                    focusNode: _tratamentoRecomendacaoFocusNode,
                    onChanged: (_) => EasyDebounce.debounce(
                      '_tratamentoRecomendacaoTextController',
                      Duration(milliseconds: 2000),
                      () async {
                        // Recomendação atualizada no ObjectBox (offline-first).
                        // Antes era uma query + update no Firestore, com `!`
                        // sobre um resultado que podia ser null.
                        final repo = RecomendacaoRepository();
                        final rec = repo
                            .getAll()
                            .where((e) =>
                                !e.isDeleted &&
                                e.uidResumoDaVisitaPath == _resumoPath &&
                                e.tituloRecomendacao == widget.parameter1)
                            .firstOrNull;
                        if (rec != null) {
                          rec.descricaoRecomendacao =
                              _tratamentoRecomendacaoTextController.text;
                          await repo.save(rec);
                        }

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
                    validator: _tratamentoRecomendacaoTextControllerValidator
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
