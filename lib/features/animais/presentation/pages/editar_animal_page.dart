// ignore_for_file: dead_null_aware_expression

import '/data/backend.dart';
import '/core/ui/app_card.dart';
import '/core/ui/success_overlay.dart';
import '/core/ui/flutter_flow_drop_down.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/form_field_controller.dart';
import '/core/ui/instant_timer.dart';
import 'dart:ui';
import '/core/services/index.dart' as actions;
import '/data/objectbox/index.dart';
import '/features/animais/presentation/pages/lista_animais_page.dart';
import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class EditarAnimalPage extends StatefulWidget {
  const EditarAnimalPage({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.grupoPredominante,
    required this.visitaPresencial,
    int? initialTabSelect,
    required this.uidAnimal,
    required this.diasDg,
  }) : this.initialTabSelect = initialTabSelect ?? 0;

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final String? grupoPredominante;
  final bool? visitaPresencial;
  final int initialTabSelect;
  final DocumentReference? uidAnimal;
  final String? diasDg;

  static String routeName = 'editarAnimal';
  static String routePath = '/editarAnimal';

  @override
  State<EditarAnimalPage> createState() => _EditarAnimalPageState();
}

class _EditarAnimalPageState extends State<EditarAnimalPage> {
  final _formKey = GlobalKey<FormState>();
  InstantTimer? _instantTimer;
  bool? _respostaNet = true;
  FocusNode? _nomeFocusNode;
  TextEditingController? _nomeTextController;
  final String? Function(BuildContext, String?)? _nomeTextControllerValidator =
      null;
  FocusNode? _brincoFocusNode;
  TextEditingController? _brincoTextController;
  final String? Function(BuildContext, String?)?
      _brincoTextControllerValidator = null;
  String? _racaValue;
  FormFieldController<String>? _racaValueController;
  String? _grupoValue;
  FormFieldController<String>? _grupoValueController;
  bool? _switchValue;
  FocusNode? _pesoFocusNode;
  TextEditingController? _pesoTextController;
  final String? Function(BuildContext, String?)? _pesoTextControllerValidator =
      null;
  FocusNode? _dataNascimentoFocusNode;
  TextEditingController? _dataNascimentoTextController;
  late MaskTextInputFormatter _dataNascimentoMask;
  String? _dataNascimentoTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    return null;
  }

  DateTime? _datePicked;
  FocusNode? _touroFocusNode;
  TextEditingController? _touroTextController;
  final String? Function(BuildContext, String?)? _touroTextControllerValidator =
      null;
  FocusNode? _vacaFocusNode;
  TextEditingController? _vacaTextController;
  final String? Function(BuildContext, String?)? _vacaTextControllerValidator =
      null;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _instantTimer = InstantTimer.periodic(
        duration: Duration(seconds: 5),
        callback: (timer) async {
          _respostaNet = await actions.checkInternetConnection();

          safeSetState(() {});
          if (_respostaNet!) {
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

    _nomeFocusNode ??= FocusNode();

    _brincoFocusNode ??= FocusNode();

    _pesoFocusNode ??= FocusNode();

    _dataNascimentoFocusNode ??= FocusNode();

    _dataNascimentoMask = MaskTextInputFormatter(mask: '##/##/####');

    _touroFocusNode ??= FocusNode();

    _vacaFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _instantTimer?.cancel();
    _nomeFocusNode?.dispose();
    _nomeTextController?.dispose();
    _brincoFocusNode?.dispose();
    _brincoTextController?.dispose();
    _pesoFocusNode?.dispose();
    _pesoTextController?.dispose();
    _dataNascimentoFocusNode?.dispose();
    _dataNascimentoTextController?.dispose();
    _touroFocusNode?.dispose();
    _touroTextController?.dispose();
    _vacaFocusNode?.dispose();
    _vacaTextController?.dispose();

    super.dispose();
  }

  /// Salva a edição do animal de forma offline-first.
  ///
  /// Grava no ObjectBox (síncrono, funciona sem internet) via AnimalRepository e
  /// dispara o push ao Firestore em segundo plano (online envia agora; offline
  /// enfileira para o sync automático). A UI NÃO bloqueia esperando a rede —
  /// corrige o botão "Editar animal" que ficava girando sem conexão.
  Future<void> _saveAnimalOfflineFirst(Map<String, dynamic> recordData) async {
    final repo = AnimalRepository();
    final entity = repo.getByFirestoreId(widget.uidAnimal!.id);
    if (entity == null) {
      // Registro ainda não está no cache local: grava direto no Firestore
      // (persistência offline cuida do envio) sem aguardar a rede.
      unawaited(widget.uidAnimal!.update(recordData));
      return;
    }
    // A escrita local do ObjectBox é síncrona; o push corre em segundo plano.
    unawaited(repo.update(entity, recordData));
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
              context.goNamed(
                ListaAnimaisPage.routeName,
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
                  'initialTabSelect': serializeParam(
                    widget.initialTabSelect,
                    ParamType.int,
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
          'Editar animal',
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

  Widget _formularioEdicao(
      BuildContext context, dynamic editarAnimalAnimaisProdutoresRecord) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _campoNome(context, editarAnimalAnimaisProdutoresRecord),
              _campoBrinco(context, editarAnimalAnimaisProdutoresRecord),
              _campoRaca(context, editarAnimalAnimaisProdutoresRecord),
              _campoGrupo(context, editarAnimalAnimaisProdutoresRecord),
              if (((widget.grupoPredominante == 'Sêmens') ||
                      (widget.grupoPredominante == 'Touros')) ||
                  ((_grupoValue == 'Touros') || (_grupoValue == 'Sêmens')))
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Liberar para inseminações:',
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
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                    Switch.adaptive(
                      value: _switchValue ??=
                          editarAnimalAnimaisProdutoresRecord.liberaInseminacao,
                      onChanged: (newValue) async {
                        safeSetState(() => _switchValue = newValue);
                      },
                      activeColor: FlutterFlowTheme.of(context).tertiary,
                      activeTrackColor: FlutterFlowTheme.of(context).alternate,
                      inactiveTrackColor:
                          FlutterFlowTheme.of(context).alternate,
                      inactiveThumbColor:
                          FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ],
                ),
              if (_grupoValue != 'Sêmens')
                TextFormField(
                  controller: _pesoTextController ??= TextEditingController(
                    text: editarAnimalAnimaisProdutoresRecord.pesoAnimal,
                  ),
                  focusNode: _pesoFocusNode,
                  autofocus: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Peso em KG',
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
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTokens.secondary,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                  ),
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
                  keyboardType: TextInputType.number,
                  cursorColor: FlutterFlowTheme.of(context).primary,
                  validator: _pesoTextControllerValidator.asValidator(context),
                ),
              _campoDataNascimento(
                  context, editarAnimalAnimaisProdutoresRecord),
              _campoTouro(context, editarAnimalAnimaisProdutoresRecord),
              _campoVaca(context, editarAnimalAnimaisProdutoresRecord),
            ].divide(SizedBox(height: 12.0)),
          ),
        ),
      ),
    );
  }

  Widget _secaoSalvar(
      BuildContext context, dynamic editarAnimalAnimaisProdutoresRecord) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 12.0),
      child: FFButtonWidget(
        onPressed: () async {
          if ((_nomeTextController.text != '') ||
              (_brincoTextController.text != '')) {
            if (_formKey.currentState == null ||
                !_formKey.currentState!.validate()) {
              return;
            }
            if (_racaValue == null) {
              return;
            }
            if (_grupoValue == null) {
              return;
            }
            // Checagem de duplicidade pelo PAR (nome + brinco), só entre animais
            // ativos (não descartados), excluindo o próprio animal em edição.
            // Brinco vazio é normalizado para -1, igual à persistência.
            final propPath = (editarAnimalAnimaisProdutoresRecord
                    .uidTecnicoPropriedade as DocumentReference?)
                ?.path;
            final brincoNovo = _brincoTextController.text != ''
                ? (int.tryParse(_brincoTextController.text) ?? -1)
                : -1;
            if (propPath != null &&
                AnimalRepository().existeAnimalAtivoComNomeBrinco(
                  propriedadePath: propPath,
                  nome: _nomeTextController.text,
                  brinco: brincoNovo,
                  excluirFirestoreId: widget.uidAnimal?.id,
                )) {
              await showDialog(
                context: context,
                builder: (alertDialogContext) {
                  return AlertDialog(
                    title: Text('Animal já cadastrado.'),
                    content: Text(
                        'Já existe um animal ativo com este nome e brinco.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(alertDialogContext),
                        child: Text('Ok'),
                      ),
                    ],
                  );
                },
              );
              return;
            }
            if ((_grupoValue == 'Vacas') || (_grupoValue == 'Novilhas')) {
              await _saveAnimalOfflineFirst(createAnimaisProdutoresRecordData(
                uidTecnicoPropriedade:
                    editarAnimalAnimaisProdutoresRecord.uidTecnicoPropriedade,
                nomeAnimal: _nomeTextController.text,
                brincoAnimal: int.tryParse(_brincoTextController.text),
                racaAnimal: _racaValue,
                pesoAnimal: _pesoTextController.text,
                dtNascimento: _dataNascimentoTextController.text,
                touro: _touroTextController.text,
                vaca: _vacaTextController.text,
                grupoAnimal: editarAnimalAnimaisProdutoresRecord.grupoAnimal,
                nomeBrincoConcat: () {
                  if ((_nomeTextController.text != '') &&
                      (_brincoTextController.text != '') &&
                      (_brincoTextController.text != '-1')) {
                    return '${_nomeTextController.text} - ${_brincoTextController.text}';
                  } else if (_nomeTextController.text != '') {
                    return _nomeTextController.text;
                  } else {
                    return _brincoTextController.text;
                  }
                }(),
                brincoAnimalOrder: (_brincoTextController.text != '') &&
                        (_brincoTextController.text != '-1')
                    ? int.tryParse(_brincoTextController.text)
                    : 999999,
              ));
              mostrarSucessoOverlay(context,
                  mensagem: 'Animal atualizado com sucesso!');

              context.goNamed(
                ListaAnimaisPage.routeName,
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
                  'initialTabSelect': serializeParam(
                    widget.initialTabSelect,
                    ParamType.int,
                  ),
                  'diasDg': serializeParam(
                    widget.diasDg,
                    ParamType.String,
                  ),
                }.withoutNulls,
              );

              return;
            } else {
              if (_grupoValue == 'Touros') {
                await _saveAnimalOfflineFirst(createAnimaisProdutoresRecordData(
                  uidTecnicoPropriedade:
                      editarAnimalAnimaisProdutoresRecord.uidTecnicoPropriedade,
                  nomeAnimal: _nomeTextController.text,
                  brincoAnimal: int.tryParse(_brincoTextController.text),
                  racaAnimal: _racaValue,
                  pesoAnimal: _pesoTextController.text,
                  dtNascimento: _dataNascimentoTextController.text,
                  touro: _touroTextController.text,
                  vaca: _vacaTextController.text,
                  grupoAnimal: editarAnimalAnimaisProdutoresRecord.grupoAnimal,
                  nomeBrincoConcat: () {
                    if ((_nomeTextController.text != '') &&
                        (_brincoTextController.text != '') &&
                        (_brincoTextController.text != '-1')) {
                      return '${_nomeTextController.text} - ${_brincoTextController.text}';
                    } else if (_nomeTextController.text != '') {
                      return _nomeTextController.text;
                    } else {
                      return _brincoTextController.text;
                    }
                  }(),
                  brincoAnimalOrder: (_brincoTextController.text != '') &&
                          (_brincoTextController.text != '-1')
                      ? int.tryParse(_brincoTextController.text)
                      : 999999,
                  liberaInseminacao: _switchValue,
                ));
                mostrarSucessoOverlay(context,
                    mensagem: 'Animal atualizado com sucesso!');

                context.goNamed(
                  ListaAnimaisPage.routeName,
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
                    'initialTabSelect': serializeParam(
                      widget.initialTabSelect,
                      ParamType.int,
                    ),
                    'diasDg': serializeParam(
                      widget.diasDg,
                      ParamType.String,
                    ),
                  }.withoutNulls,
                );

                return;
              } else {
                if (_grupoValue == 'Sêmens') {
                  await _saveAnimalOfflineFirst(
                      createAnimaisProdutoresRecordData(
                    uidTecnicoPropriedade: editarAnimalAnimaisProdutoresRecord
                        .uidTecnicoPropriedade,
                    nomeAnimal: _nomeTextController.text,
                    brincoAnimal: int.tryParse(_brincoTextController.text),
                    racaAnimal: _racaValue,
                    dtNascimento: _dataNascimentoTextController.text,
                    touro: _touroTextController.text,
                    vaca: _vacaTextController.text,
                    grupoAnimal:
                        editarAnimalAnimaisProdutoresRecord.grupoAnimal,
                    nomeBrincoConcat: () {
                      if ((_nomeTextController.text != '') &&
                          (_brincoTextController.text != '') &&
                          (editarAnimalAnimaisProdutoresRecord.brincoAnimal !=
                              -1)) {
                        return '${_nomeTextController.text} - ${_brincoTextController.text}';
                      } else if (_nomeTextController.text != '') {
                        return _nomeTextController.text;
                      } else {
                        return _brincoTextController.text;
                      }
                    }(),
                    brincoAnimalOrder: (_brincoTextController.text != '') &&
                            (_brincoTextController.text != '-1')
                        ? int.tryParse(_brincoTextController.text)
                        : 999999,
                    liberaInseminacao: _switchValue,
                  ));
                  mostrarSucessoOverlay(context,
                      mensagem: 'Animal atualizado com sucesso!');

                  context.goNamed(
                    ListaAnimaisPage.routeName,
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
                      'initialTabSelect': serializeParam(
                        widget.initialTabSelect,
                        ParamType.int,
                      ),
                      'diasDg': serializeParam(
                        widget.diasDg,
                        ParamType.String,
                      ),
                    }.withoutNulls,
                  );

                  return;
                } else {
                  await _saveAnimalOfflineFirst(
                      createAnimaisProdutoresRecordData(
                    uidTecnicoPropriedade: editarAnimalAnimaisProdutoresRecord
                        .uidTecnicoPropriedade,
                    nomeAnimal: _nomeTextController.text,
                    brincoAnimal: int.tryParse(_brincoTextController.text),
                    racaAnimal: _racaValue,
                    pesoAnimal: _pesoTextController.text,
                    dtNascimento: _dataNascimentoTextController.text,
                    touro: _touroTextController.text,
                    vaca: _vacaTextController.text,
                    grupoAnimal:
                        editarAnimalAnimaisProdutoresRecord.grupoAnimal,
                    nomeBrincoConcat: () {
                      if ((_nomeTextController.text != '') &&
                          (_brincoTextController.text != '') &&
                          (editarAnimalAnimaisProdutoresRecord.brincoAnimal !=
                              -1)) {
                        return '${_nomeTextController.text} - ${_brincoTextController.text}';
                      } else if (_nomeTextController.text != '') {
                        return _nomeTextController.text;
                      } else {
                        return _brincoTextController.text;
                      }
                    }(),
                    brincoAnimalOrder: (_brincoTextController.text != '') &&
                            (_brincoTextController.text != '-1')
                        ? int.tryParse(_brincoTextController.text)
                        : 999999,
                  ));
                  mostrarSucessoOverlay(context,
                      mensagem: 'Animal atualizado com sucesso!');

                  context.goNamed(
                    ListaAnimaisPage.routeName,
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
                      'initialTabSelect': serializeParam(
                        widget.initialTabSelect,
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
              }
            }
          } else {
            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text('O campo nome ou brinco é obrigatório.'),
                  content:
                      Text('Informe um nome ou brinco ao animal para avançar.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(alertDialogContext),
                      child: Text('Ok'),
                    ),
                  ],
                );
              },
            );
            return;
          }
        },
        text: 'Editar animal',
        icon: Icon(
          Icons.save,
          size: 15.0,
        ),
        options: FFButtonOptions(
          width: double.infinity,
          height: 48.0,
          padding: EdgeInsets.all(0.0),
          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          color: Color(0xFFEC3B5B),
          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).titleSmall.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                ),
                color: Colors.white,
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
              ),
          elevation: 4.0,
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(60.0),
        ),
      ),
    );
  }

  Widget _campoNome(
      BuildContext context, dynamic editarAnimalAnimaisProdutoresRecord) {
    return TextFormField(
      controller: _nomeTextController ??= TextEditingController(
        text: editarAnimalAnimaisProdutoresRecord.nomeAnimal,
      ),
      focusNode: _nomeFocusNode,
      autofocus: false,
      obscureText: false,
      decoration: InputDecoration(
        labelText: 'Nome*',
        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTokens.secondary,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      ),
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.readexPro(
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            letterSpacing: 0.0,
            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
      cursorColor: FlutterFlowTheme.of(context).primary,
      validator: _nomeTextControllerValidator.asValidator(context),
    );
  }

  Widget _campoBrinco(
      BuildContext context, dynamic editarAnimalAnimaisProdutoresRecord) {
    return TextFormField(
      controller: _brincoTextController ??= TextEditingController(
        text: editarAnimalAnimaisProdutoresRecord.brincoAnimal.toString(),
      ),
      focusNode: _brincoFocusNode,
      autofocus: false,
      obscureText: false,
      decoration: InputDecoration(
        labelText: 'Nº registro/brinco*',
        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTokens.secondary,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      ),
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.readexPro(
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            letterSpacing: 0.0,
            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
      keyboardType: TextInputType.number,
      cursorColor: FlutterFlowTheme.of(context).primary,
      validator: _brincoTextControllerValidator.asValidator(context),
    );
  }

  Widget _campoRaca(
      BuildContext context, dynamic editarAnimalAnimaisProdutoresRecord) {
    // Raças do ObjectBox (offline-first) — sem StreamBuilder de rede.
    return FlutterFlowDropDown<String>(
      controller: _racaValueController ??= FormFieldController<String>(
        _racaValue ??= editarAnimalAnimaisProdutoresRecord.racaAnimal,
      ),
      options: ReferenciaRepository().racas(),
      onChanged: (val) => safeSetState(() => _racaValue = val),
      width: double.infinity,
      height: 50.0,
      searchHintTextStyle: FlutterFlowTheme.of(context).labelMedium.override(
            font: GoogleFonts.readexPro(
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
            letterSpacing: 0.0,
            fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
          ),
      searchTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.readexPro(
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            letterSpacing: 0.0,
            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
      textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.readexPro(
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            letterSpacing: 0.0,
            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
      hintText: 'Raça predominante*',
      searchHintText: 'Pesquise uma raça...',
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: FlutterFlowTheme.of(context).secondaryText,
        size: 24.0,
      ),
      fillColor: FlutterFlowTheme.of(context).primaryBackground,
      elevation: 2.0,
      borderColor: FlutterFlowTheme.of(context).alternate,
      borderWidth: 2.0,
      borderRadius: 8.0,
      margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
      hidesUnderline: true,
      isOverButton: true,
      isSearchable: true,
      isMultiSelect: false,
    );
  }

  Widget _campoGrupo(
      BuildContext context, dynamic editarAnimalAnimaisProdutoresRecord) {
    // Grupos do ObjectBox (offline-first) — sem StreamBuilder de rede.
    return FlutterFlowDropDown<String>(
      controller: _grupoValueController ??= FormFieldController<String>(
        _grupoValue ??= editarAnimalAnimaisProdutoresRecord.grupoAnimal,
      ),
      options: ReferenciaRepository().grupos(),
      onChanged: (val) => safeSetState(() => _grupoValue = val),
      width: double.infinity,
      height: 50.0,
      textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.readexPro(
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            letterSpacing: 0.0,
            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
      hintText: 'Grupo predominante*',
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: FlutterFlowTheme.of(context).secondaryText,
        size: 24.0,
      ),
      fillColor: FlutterFlowTheme.of(context).primaryBackground,
      elevation: 2.0,
      borderColor: FlutterFlowTheme.of(context).alternate,
      borderWidth: 2.0,
      borderRadius: 8.0,
      margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
      hidesUnderline: true,
      isSearchable: false,
      isMultiSelect: false,
    );
  }

  Widget _campoDataNascimento(
      BuildContext context, dynamic editarAnimalAnimaisProdutoresRecord) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
            child: TextFormField(
              controller: _dataNascimentoTextController ??=
                  TextEditingController(
                text: editarAnimalAnimaisProdutoresRecord.dtNascimento,
              ),
              focusNode: _dataNascimentoFocusNode,
              onChanged: (_) => EasyDebounce.debounce(
                '_dataNascimentoTextController',
                Duration(milliseconds: 2000),
                () => safeSetState(() {}),
              ),
              autofocus: false,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.next,
              readOnly: true,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'Data nascimento',
                hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).labelMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).labelMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).primaryBackground,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppTokens.secondary,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding:
                    EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                suffixIcon: _dataNascimentoTextController!.text.isNotEmpty
                    ? InkWell(
                        onTap: () async {
                          _dataNascimentoTextController?.clear();
                          safeSetState(() {});
                        },
                        child: Icon(
                          Icons.clear,
                          size: 22.0,
                        ),
                      )
                    : null,
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.readexPro(
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
              maxLength: 10,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      maxLength}) =>
                  null,
              keyboardType: TextInputType.datetime,
              validator:
                  _dataNascimentoTextControllerValidator.asValidator(context),
              inputFormatters: [_dataNascimentoMask],
            ),
          ),
        ),
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            // calendarNascimento
            await showModalBottomSheet<bool>(
                context: context,
                builder: (context) {
                  final _datePickedCupertinoTheme = CupertinoTheme.of(context);
                  return ScrollConfiguration(
                    behavior: const MaterialScrollBehavior().copyWith(
                      dragDevices: {
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.touch,
                        PointerDeviceKind.stylus,
                        PointerDeviceKind.unknown
                      },
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      child: CupertinoTheme(
                        data: _datePickedCupertinoTheme.copyWith(
                          textTheme:
                              _datePickedCupertinoTheme.textTheme.copyWith(
                            dateTimePickerTextStyle:
                                FlutterFlowTheme.of(context)
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
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .fontStyle,
                                    ),
                          ),
                        ),
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          minimumDate: (DateTime.fromMicrosecondsSinceEpoch(
                                  1577847600000000) ??
                              DateTime(1900)),
                          initialDateTime: DateTime.fromMicrosecondsSinceEpoch(
                              1609470000000000),
                          maximumDate: (DateTime.fromMicrosecondsSinceEpoch(
                                  2024708400000000) ??
                              DateTime(2050)),
                          backgroundColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          use24hFormat: false,
                          onDateTimeChanged: (newDateTime) => safeSetState(() {
                            _datePicked = newDateTime;
                          }),
                        ),
                      ),
                    ),
                  );
                });
            safeSetState(() {
              _dataNascimentoTextController?.text = dateTimeFormat(
                "dd/MM/yyyy",
                _datePicked,
                locale: FFLocalizations.of(context).languageCode,
              );
              _dataNascimentoMask.updateMask(
                newValue: TextEditingValue(
                  text: _dataNascimentoTextController!.text,
                ),
              );
            });
          },
          child: Icon(
            Icons.calendar_month,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24.0,
          ),
        ),
      ],
    );
  }

  Widget _campoTouro(
      BuildContext context, dynamic editarAnimalAnimaisProdutoresRecord) {
    return TextFormField(
      controller: _touroTextController ??= TextEditingController(
        text: editarAnimalAnimaisProdutoresRecord.touro,
      ),
      focusNode: _touroFocusNode,
      autofocus: false,
      obscureText: false,
      decoration: InputDecoration(
        labelText: 'Touro (Pai)',
        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTokens.secondary,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      ),
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.readexPro(
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            letterSpacing: 0.0,
            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
      cursorColor: FlutterFlowTheme.of(context).primary,
      validator: _touroTextControllerValidator.asValidator(context),
    );
  }

  Widget _campoVaca(
      BuildContext context, dynamic editarAnimalAnimaisProdutoresRecord) {
    return TextFormField(
      controller: _vacaTextController ??= TextEditingController(
        text: editarAnimalAnimaisProdutoresRecord.vaca,
      ),
      focusNode: _vacaFocusNode,
      autofocus: false,
      obscureText: false,
      decoration: InputDecoration(
        labelText: 'Vaca (Mãe)',
        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTokens.secondary,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      ),
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.readexPro(
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            letterSpacing: 0.0,
            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
      textAlign: TextAlign.start,
      cursorColor: FlutterFlowTheme.of(context).primary,
      validator: _vacaTextControllerValidator.asValidator(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return StreamBuilder<AnimaisProdutoresRecord>(
      stream: AnimaisProdutoresRecord.getDocument(widget.uidAnimal!),
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

        final editarAnimalAnimaisProdutoresRecord = snapshot.data!;

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
            body: SafeArea(
              top: true,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _formularioEdicao(
                          context, editarAnimalAnimaisProdutoresRecord),
                      _secaoSalvar(
                          context, editarAnimalAnimaisProdutoresRecord),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
