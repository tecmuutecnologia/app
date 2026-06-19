// ignore_for_file: dead_code, dead_null_aware_expression

import '/data/backend.dart';
import '/core/ui/app_card.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/core/constants/grupos_racas_constantes.dart';
import '/core/ui/flutter_flow_drop_down.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/form_field_controller.dart';
import '/core/ui/instant_timer.dart';
import '/core/ui/request_manager.dart';
import 'dart:ui';
import '/core/services/index.dart' as actions;
import '/core/ui/custom_functions.dart' as functions;
import '/features/animais/presentation/pages/lista_animais_page.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class CadastrarNovoAnimalPage extends StatefulWidget {
  const CadastrarNovoAnimalPage({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.grupoPredominante,
    required this.visitaPresencial,
    int? initialTabSelect,
    required this.diasDg,
  }) : this.initialTabSelect = initialTabSelect ?? 0;

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final String? grupoPredominante;
  final bool? visitaPresencial;
  final int initialTabSelect;
  final String? diasDg;

  static String routeName = 'cadastrarNovoAnimal';
  static String routePath = '/cadastrarNovoAnimal';

  @override
  State<CadastrarNovoAnimalPage> createState() =>
      _CadastrarNovoAnimalPageState();
}

class _CadastrarNovoAnimalPageState extends State<CadastrarNovoAnimalPage> {
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
      return 'Campo é obrigatório';
    }
    return null;
  }

  DateTime? _datePicked1;
  FocusNode? _touroPaiFocusNode;
  TextEditingController? _touroPaiTextController;
  final String? Function(BuildContext, String?)?
      _touroPaiTextControllerValidator = null;
  FocusNode? _vacaMaeFocusNode;
  TextEditingController? _vacaMaeTextController;
  final String? Function(BuildContext, String?)?
      _vacaMaeTextControllerValidator = null;
  FocusNode? _dataUltimoPartoFocusNode;
  TextEditingController? _dataUltimoPartoTextController;
  late MaskTextInputFormatter _dataUltimoPartoMask;
  final String? Function(BuildContext, String?)?
      _dataUltimoPartoTextControllerValidator = null;
  DateTime? _datePicked2;
  List<StatusAnimaisRecord>? _outListaAnimais;
  FocusNode? _dataUltimaInseminacaoFocusNode;
  TextEditingController? _dataUltimaInseminacaoTextController;
  late MaskTextInputFormatter _dataUltimaInseminacaoMask;
  final String? Function(BuildContext, String?)?
      _dataUltimaInseminacaoTextControllerValidator = null;
  DateTime? _datePicked3;
  String? _touroInseminacaoValue;
  FormFieldController<String>? _touroInseminacaoValueController;
  String? _statusAnimalValue;
  FormFieldController<String>? _statusAnimalValueController;
  List<AnimaisProdutoresRecord>? _outListaAnimaisVerificaNome;
  List<AnimaisProdutoresRecord>? _outListaAnimaisVerificaBrinco;
  List<AnimaisProdutoresRecord>? _outListaAnimaisVerificaNomeOff;
  List<AnimaisProdutoresRecord>? _outListaAnimaisVerificaBrincoOff;

  final _animaisLiberaoParaInseminarManager =
      StreamRequestManager<List<AnimaisProdutoresRecord>>();
  Stream<List<AnimaisProdutoresRecord>> _animaisLiberaoParaInseminar({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<AnimaisProdutoresRecord>> Function() requestFn,
  }) =>
      _animaisLiberaoParaInseminarManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );

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

    _nomeTextController ??= TextEditingController();
    _nomeFocusNode ??= FocusNode();

    _brincoTextController ??= TextEditingController();
    _brincoFocusNode ??= FocusNode();

    _switchValue = true;
    _pesoTextController ??= TextEditingController();
    _pesoFocusNode ??= FocusNode();

    _dataNascimentoTextController ??=
        TextEditingController(text: functions.obterDataAtualMenosTresAnos());
    _dataNascimentoFocusNode ??= FocusNode();

    _dataNascimentoMask = MaskTextInputFormatter(mask: '##/##/####');
    _touroPaiTextController ??= TextEditingController();
    _touroPaiFocusNode ??= FocusNode();

    _vacaMaeTextController ??= TextEditingController();
    _vacaMaeFocusNode ??= FocusNode();

    _dataUltimoPartoTextController ??= TextEditingController();
    _dataUltimoPartoFocusNode ??= FocusNode();

    _dataUltimoPartoMask = MaskTextInputFormatter(mask: '##/##/####');
    _dataUltimaInseminacaoTextController ??= TextEditingController();
    _dataUltimaInseminacaoFocusNode ??= FocusNode();

    _dataUltimaInseminacaoMask = MaskTextInputFormatter(mask: '##/##/####');
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
    _touroPaiFocusNode?.dispose();
    _touroPaiTextController?.dispose();
    _vacaMaeFocusNode?.dispose();
    _vacaMaeTextController?.dispose();
    _dataUltimoPartoFocusNode?.dispose();
    _dataUltimoPartoTextController?.dispose();
    _dataUltimaInseminacaoFocusNode?.dispose();
    _dataUltimaInseminacaoTextController?.dispose();
    _animaisLiberaoParaInseminarManager.clear();

    super.dispose();
  }

  /// Cadastra o(s) animal(is) (offline-first). Extraído do onPressed do
  /// botão de salvar (Fase 4): eram ~4000 linhas inline.
  Future<void> _cadastrarAnimal(BuildContext context) async {
    var _shouldSetState = false;
    if (_respostaNet!) {
      // Animais criados offline agora vão direto ao ObjectBox (sem fila no
      // FFAppState), então não há mais "pendentes" a bloquear o cadastro.
      {
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
        _outListaAnimaisVerificaNome = await queryAnimaisProdutoresRecordOnce(
          parent: widget.uidTecnico,
          queryBuilder: (animaisProdutoresRecord) => animaisProdutoresRecord
              .where(
                'uidTecnicoPropriedade',
                isEqualTo: widget.uidPropriedade,
              )
              .where(
                'nomeAnimal',
                isEqualTo: _nomeTextController.text,
              ),
        );
        _shouldSetState = true;
        _outListaAnimaisVerificaBrinco = await queryAnimaisProdutoresRecordOnce(
          parent: widget.uidTecnico,
          queryBuilder: (animaisProdutoresRecord) => animaisProdutoresRecord
              .where(
                'uidTecnicoPropriedade',
                isEqualTo: widget.uidPropriedade,
              )
              .where(
                'brincoAnimal',
                isEqualTo: int.tryParse(_brincoTextController.text),
              ),
        );
        _shouldSetState = true;
        if ((_outListaAnimaisVerificaNome!.length > 0) &&
            (_outListaAnimaisVerificaBrinco!.length > 0)) {
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: Text('Nome ou brinco já existe.'),
                content: Text('Digite outro nome ou brinco.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext),
                    child: Text('Ok'),
                  ),
                ],
              );
            },
          );
          if (_shouldSetState) safeSetState(() {});
          return;
        }
        if ((_nomeTextController.text != '') ||
            (_brincoTextController.text != '')) {
          if (_dataUltimaInseminacaoTextController.text != '') {
            if (!(_touroInseminacaoValue != null &&
                _touroInseminacaoValue != '')) {
              await showDialog(
                context: context,
                builder: (alertDialogContext) {
                  return AlertDialog(
                    title: Text('Touro inseminação não selecionado.'),
                    content: Text('Selecione o touro usado.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(alertDialogContext),
                        child: Text('Ok'),
                      ),
                    ],
                  );
                },
              );
              if (_shouldSetState) safeSetState(() {});
              return;
            }
          }
        } else {
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: Text('Nome ou brinco obrigatório.'),
                content: Text('Preencha ao menos um dos campos.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext),
                    child: Text('Ok'),
                  ),
                ],
              );
            },
          );
          if (_shouldSetState) safeSetState(() {});
          return;
        }

        if ((_grupoValue == 'Vacas') || (_grupoValue == 'Novilhas')) {
          if (_statusAnimalValue != null && _statusAnimalValue != '') {
            if (_statusAnimalValue == 'Inseminada') {
              if ((_dataUltimaInseminacaoTextController.text != '') &&
                  (_dataUltimoPartoTextController.text == '') &&
                  (_touroInseminacaoValue != null &&
                      _touroInseminacaoValue != '')) {
                await AnimaisProdutoresRecord.createDoc(widget.uidTecnico!)
                    .set(createAnimaisProdutoresRecordData(
                  uidTecnicoPropriedade: widget.uidPropriedade,
                  nomeAnimal: _nomeTextController.text,
                  brincoAnimal: _brincoTextController.text != ''
                      ? int.tryParse(_brincoTextController.text)
                      : -1,
                  racaAnimal: _racaValue,
                  pesoAnimal: _pesoTextController.text,
                  dtNascimento: _dataNascimentoTextController.text,
                  touro: _touroPaiTextController.text,
                  vaca: _vacaMaeTextController.text,
                  status: _statusAnimalValue,
                  dtUltimaInseminacao:
                      _dataUltimaInseminacaoTextController.text,
                  grupoAnimal: _grupoValue,
                  nomeTouroUltimaInseminacao: _touroInseminacaoValue,
                  dtPartoPrevisto: functions.somarDataParto(
                      _dataUltimaInseminacaoTextController.text),
                  dtSecPrevista: functions.somarDataSecagem(
                      _dataUltimaInseminacaoTextController.text),
                  dtPrePartoPrevista: functions.somarDataPreParto(
                      _dataUltimaInseminacaoTextController.text),
                  totalInseminacoes: 1,
                  compararDtUltimaInseminacao:
                      functions.converterDataUltimaInseminacao(
                          _dataUltimaInseminacaoTextController.text),
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
                  idStatusAnimal: 3,
                  brincoAnimalOrder: _brincoTextController.text != ''
                      ? int.tryParse(_brincoTextController.text)
                      : 999999,
                ));

                await widget.uidTecnico!.update({
                  ...mapToFirestore(
                    {
                      'quantidadeAnimaisCadastrados': FieldValue.increment(1),
                      'restanteLimiteAnimais': FieldValue.increment(-(1)),
                    },
                  ),
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Animal cadastrado com sucesso!',
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                    duration: Duration(milliseconds: 4000),
                    backgroundColor: FlutterFlowTheme.of(context).secondary,
                  ),
                );
                if (Navigator.of(context).canPop()) {
                  context.pop();
                }
                context.pushNamed(
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
                    'tabBarOpenSelected': serializeParam(
                      0,
                      ParamType.int,
                    ),
                  }.withoutNulls,
                );

                if (_shouldSetState) safeSetState(() {});
                return;
              } else {
                if ((_dataUltimoPartoTextController.text != '') &&
                    (_dataUltimaInseminacaoTextController.text != '') &&
                    (_touroInseminacaoValue != null &&
                        _touroInseminacaoValue != '')) {
                  await AnimaisProdutoresRecord.createDoc(widget.uidTecnico!)
                      .set(createAnimaisProdutoresRecordData(
                    uidTecnicoPropriedade: widget.uidPropriedade,
                    nomeAnimal: _nomeTextController.text,
                    brincoAnimal: _brincoTextController.text != ''
                        ? int.tryParse(_brincoTextController.text)
                        : -1,
                    racaAnimal: _racaValue,
                    pesoAnimal: _pesoTextController.text,
                    dtNascimento: _dataNascimentoTextController.text,
                    touro: _touroPaiTextController.text,
                    vaca: _vacaMaeTextController.text,
                    status: _statusAnimalValue,
                    dtUltimaInseminacao:
                        _dataUltimaInseminacaoTextController.text,
                    dtUltimoParto: _dataUltimoPartoTextController.text,
                    grupoAnimal: _grupoValue,
                    nomeTouroUltimaInseminacao: _touroInseminacaoValue,
                    dtPartoPrevisto: functions.somarDataParto(
                        _dataUltimaInseminacaoTextController.text),
                    dtSecPrevista: functions.somarDataSecagem(
                        _dataUltimaInseminacaoTextController.text),
                    dtPrePartoPrevista: functions.somarDataPreParto(
                        _dataUltimaInseminacaoTextController.text),
                    totalInseminacoes: 1,
                    totalPartos: 1,
                    compararDtUltimaInseminacao:
                        functions.converterDataUltimaInseminacao(
                            _dataUltimaInseminacaoTextController.text),
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
                    idStatusAnimal: 3,
                    dtUltimoPartoContingencia:
                        _dataUltimoPartoTextController.text,
                    brincoAnimalOrder: _brincoTextController.text != ''
                        ? int.tryParse(_brincoTextController.text)
                        : 999999,
                  ));

                  await widget.uidTecnico!.update({
                    ...mapToFirestore(
                      {
                        'quantidadeAnimaisCadastrados': FieldValue.increment(1),
                        'restanteLimiteAnimais': FieldValue.increment(-(1)),
                      },
                    ),
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Animal cadastrado com sucesso!',
                        style: TextStyle(
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                      duration: Duration(milliseconds: 4000),
                      backgroundColor: FlutterFlowTheme.of(context).secondary,
                    ),
                  );
                  if (Navigator.of(context).canPop()) {
                    context.pop();
                  }
                  context.pushNamed(
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
                      'tabBarOpenSelected': serializeParam(
                        0,
                        ParamType.int,
                      ),
                    }.withoutNulls,
                  );

                  if (_shouldSetState) safeSetState(() {});
                  return;
                } else {
                  if (_shouldSetState) safeSetState(() {});
                  return;
                }
              }
            } else {
              if (_statusAnimalValue == 'Seca') {
                if (_grupoValue == 'Vacas') {
                  await AnimaisProdutoresRecord.createDoc(widget.uidTecnico!)
                      .set(createAnimaisProdutoresRecordData(
                    uidTecnicoPropriedade: widget.uidPropriedade,
                    nomeAnimal: _nomeTextController.text,
                    brincoAnimal: _brincoTextController.text != ''
                        ? int.tryParse(_brincoTextController.text)
                        : -1,
                    racaAnimal: _racaValue,
                    pesoAnimal: _pesoTextController.text,
                    dtNascimento: _dataNascimentoTextController.text,
                    touro: _touroPaiTextController.text,
                    vaca: _vacaMaeTextController.text,
                    status: _statusAnimalValue,
                    dtUltimaInseminacao:
                        _dataUltimaInseminacaoTextController.text,
                    grupoAnimal: _grupoValue,
                    dtPartoPrevisto: functions.somarDataParto(
                        _dataUltimaInseminacaoTextController.text),
                    dtSecPrevista: functions.somarDataSecagem(
                        _dataUltimaInseminacaoTextController.text),
                    dtPrePartoPrevista: functions.somarDataPreParto(
                        _dataUltimaInseminacaoTextController.text),
                    nomeTouroUltimaInseminacao: _touroInseminacaoValue,
                    compararDtUltimaInseminacao:
                        functions.converterDataUltimaInseminacao(
                            _dataUltimaInseminacaoTextController.text),
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
                    idStatusAnimal: 4,
                    brincoAnimalOrder: _brincoTextController.text != ''
                        ? int.tryParse(_brincoTextController.text)
                        : 999999,
                  ));

                  await widget.uidTecnico!.update({
                    ...mapToFirestore(
                      {
                        'quantidadeAnimaisCadastrados': FieldValue.increment(1),
                        'restanteLimiteAnimais': FieldValue.increment(-(1)),
                      },
                    ),
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Animal cadastrado com sucesso!',
                        style: TextStyle(
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                      duration: Duration(milliseconds: 4000),
                      backgroundColor: FlutterFlowTheme.of(context).secondary,
                    ),
                  );
                  if (Navigator.of(context).canPop()) {
                    context.pop();
                  }
                  context.pushNamed(
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
                      'tabBarOpenSelected': serializeParam(
                        0,
                        ParamType.int,
                      ),
                    }.withoutNulls,
                  );

                  if (_shouldSetState) safeSetState(() {});
                  return;
                } else {
                  await showDialog(
                    context: context,
                    builder: (alertDialogContext) {
                      return AlertDialog(
                        title: Text(
                            'O status de \"Seca\" é permitido somente em vacas.'),
                        content: Text('Atualize o status.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(alertDialogContext),
                            child: Text('Ok'),
                          ),
                        ],
                      );
                    },
                  );
                  if (_shouldSetState) safeSetState(() {});
                  return;
                }
              } else {
                if (_statusAnimalValue == 'Vazia') {
                  await AnimaisProdutoresRecord.createDoc(widget.uidTecnico!)
                      .set(createAnimaisProdutoresRecordData(
                    uidTecnicoPropriedade: widget.uidPropriedade,
                    nomeAnimal: _nomeTextController.text,
                    brincoAnimal: _brincoTextController.text != ''
                        ? int.tryParse(_brincoTextController.text)
                        : -1,
                    racaAnimal: _racaValue,
                    pesoAnimal: _pesoTextController.text,
                    dtNascimento: _dataNascimentoTextController.text,
                    touro: _touroPaiTextController.text,
                    vaca: _vacaMaeTextController.text,
                    status: _statusAnimalValue,
                    grupoAnimal: _grupoValue,
                    dtUltimoParto: _dataUltimoPartoTextController.text,
                    totalPartos:
                        _dataUltimoPartoTextController.text != '' ? 1 : 0,
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
                    idStatusAnimal: 2,
                    dtUltimoPartoContingencia:
                        _dataUltimoPartoTextController.text,
                    brincoAnimalOrder: _brincoTextController.text != ''
                        ? int.tryParse(_brincoTextController.text)
                        : 999999,
                  ));

                  await widget.uidTecnico!.update({
                    ...mapToFirestore(
                      {
                        'quantidadeAnimaisCadastrados': FieldValue.increment(1),
                        'restanteLimiteAnimais': FieldValue.increment(-(1)),
                      },
                    ),
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Animal cadastrado com sucesso!',
                        style: TextStyle(
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                      duration: Duration(milliseconds: 4000),
                      backgroundColor: FlutterFlowTheme.of(context).secondary,
                    ),
                  );
                  if (Navigator.of(context).canPop()) {
                    context.pop();
                  }
                  context.pushNamed(
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
                      'tabBarOpenSelected': serializeParam(
                        0,
                        ParamType.int,
                      ),
                    }.withoutNulls,
                  );

                  if (_shouldSetState) safeSetState(() {});
                  return;
                } else {
                  if (_statusAnimalValue == 'Prenha') {
                    if ((_dataUltimaInseminacaoTextController.text != '') &&
                        (_touroInseminacaoValue != null &&
                            _touroInseminacaoValue != '')) {
                      await AnimaisProdutoresRecord.createDoc(
                              widget.uidTecnico!)
                          .set(createAnimaisProdutoresRecordData(
                        uidTecnicoPropriedade: widget.uidPropriedade,
                        nomeAnimal: _nomeTextController.text,
                        brincoAnimal: _brincoTextController.text != ''
                            ? int.tryParse(_brincoTextController.text)
                            : -1,
                        racaAnimal: _racaValue,
                        pesoAnimal: _pesoTextController.text,
                        dtNascimento: _dataNascimentoTextController.text,
                        touro: _touroPaiTextController.text,
                        vaca: _vacaMaeTextController.text,
                        status: _statusAnimalValue,
                        dtUltimaInseminacao:
                            _dataUltimaInseminacaoTextController.text,
                        grupoAnimal: _grupoValue,
                        nomeTouroUltimaInseminacao: _touroInseminacaoValue,
                        dtPartoPrevisto: functions.somarDataParto(
                            _dataUltimaInseminacaoTextController.text),
                        dtSecPrevista: functions.somarDataSecagem(
                            _dataUltimaInseminacaoTextController.text),
                        dtPrePartoPrevista: functions.somarDataPreParto(
                            _dataUltimaInseminacaoTextController.text),
                        totalInseminacoes: 1,
                        dtDgMais: dateTimeFormat(
                          "dd/MM/yyyy",
                          getCurrentTimestamp,
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                        dtUltimoParto: _dataUltimoPartoTextController.text,
                        compararDtUltimaInseminacao:
                            functions.converterDataUltimaInseminacao(
                                _dataUltimaInseminacaoTextController.text),
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
                        idStatusAnimal: 6,
                        dtUltimoPartoContingencia:
                            _dataUltimoPartoTextController.text,
                        brincoAnimalOrder: _brincoTextController.text != ''
                            ? int.tryParse(_brincoTextController.text)
                            : 999999,
                      ));

                      await widget.uidTecnico!.update({
                        ...mapToFirestore(
                          {
                            'quantidadeAnimaisCadastrados':
                                FieldValue.increment(1),
                            'restanteLimiteAnimais': FieldValue.increment(-(1)),
                          },
                        ),
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Animal cadastrado com sucesso!',
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                          duration: Duration(milliseconds: 4000),
                          backgroundColor:
                              FlutterFlowTheme.of(context).secondary,
                        ),
                      );
                      if (Navigator.of(context).canPop()) {
                        context.pop();
                      }
                      context.pushNamed(
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
                          'tabBarOpenSelected': serializeParam(
                            0,
                            ParamType.int,
                          ),
                        }.withoutNulls,
                      );

                      if (_shouldSetState) safeSetState(() {});
                      return;
                    } else {
                      await showDialog(
                        context: context,
                        builder: (alertDialogContext) {
                          return AlertDialog(
                            title: Text(
                                'Data última inseminação vazia ou Touro inseminação não selecionado.'),
                            content: Text('Preencha os campos obrigatórios.'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(alertDialogContext),
                                child: Text('Ok'),
                              ),
                            ],
                          );
                        },
                      );
                      if (_shouldSetState) safeSetState(() {});
                      return;
                    }
                  } else {
                    if (_statusAnimalValue == 'Inseminada PP') {
                      if ((_dataUltimaInseminacaoTextController.text != '') &&
                          (_touroInseminacaoValue != null &&
                              _touroInseminacaoValue != '')) {
                        await AnimaisProdutoresRecord.createDoc(
                                widget.uidTecnico!)
                            .set(createAnimaisProdutoresRecordData(
                          uidTecnicoPropriedade: widget.uidPropriedade,
                          nomeAnimal: _nomeTextController.text,
                          brincoAnimal: _brincoTextController.text != ''
                              ? int.tryParse(_brincoTextController.text)
                              : -1,
                          racaAnimal: _racaValue,
                          pesoAnimal: _pesoTextController.text,
                          dtNascimento: _dataNascimentoTextController.text,
                          touro: _touroPaiTextController.text,
                          vaca: _vacaMaeTextController.text,
                          status: _statusAnimalValue,
                          dtUltimaInseminacao:
                              _dataUltimaInseminacaoTextController.text,
                          grupoAnimal: _grupoValue,
                          nomeTouroUltimaInseminacao: _touroInseminacaoValue,
                          dtPartoPrevisto: functions.somarDataParto(
                              _dataUltimaInseminacaoTextController.text),
                          dtSecPrevista: functions.somarDataSecagem(
                              _dataUltimaInseminacaoTextController.text),
                          dtPrePartoPrevista: functions.somarDataPreParto(
                              _dataUltimaInseminacaoTextController.text),
                          totalInseminacoes: 1,
                          dtPP: dateTimeFormat(
                            "dd/MM/yyyy",
                            getCurrentTimestamp,
                            locale: FFLocalizations.of(context).languageCode,
                          ),
                          dtUltimoPP: dateTimeFormat(
                            "dd/MM/yyyy",
                            getCurrentTimestamp,
                            locale: FFLocalizations.of(context).languageCode,
                          ),
                          dtUltimoParto: _dataUltimoPartoTextController.text,
                          compararDtUltimaInseminacao:
                              functions.converterDataUltimaInseminacao(
                                  _dataUltimaInseminacaoTextController.text),
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
                          idStatusAnimal: 1,
                          dtUltimoPartoContingencia:
                              _dataUltimoPartoTextController.text,
                          brincoAnimalOrder: _brincoTextController.text != ''
                              ? int.tryParse(_brincoTextController.text)
                              : 999999,
                        ));

                        await widget.uidTecnico!.update({
                          ...mapToFirestore(
                            {
                              'quantidadeAnimaisCadastrados':
                                  FieldValue.increment(1),
                              'restanteLimiteAnimais':
                                  FieldValue.increment(-(1)),
                            },
                          ),
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Animal cadastrado com sucesso!',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                            duration: Duration(milliseconds: 4000),
                            backgroundColor:
                                FlutterFlowTheme.of(context).secondary,
                          ),
                        );
                        if (Navigator.of(context).canPop()) {
                          context.pop();
                        }
                        context.pushNamed(
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
                            'tabBarOpenSelected': serializeParam(
                              0,
                              ParamType.int,
                            ),
                          }.withoutNulls,
                        );

                        if (_shouldSetState) safeSetState(() {});
                        return;
                      } else {
                        await showDialog(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              title: Text(
                                  'Data última inseminação vazia ou Touro inseminação não selecionado.'),
                              content: Text('Preencha os campos obrigatórios.'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext),
                                  child: Text('Ok'),
                                ),
                              ],
                            );
                          },
                        );
                        if (_shouldSetState) safeSetState(() {});
                        return;
                      }
                    } else {
                      if (_statusAnimalValue == 'Pré Parto') {
                        if ((_dataUltimaInseminacaoTextController.text != '') &&
                            (_touroInseminacaoValue != null &&
                                _touroInseminacaoValue != '')) {
                          await AnimaisProdutoresRecord.createDoc(
                                  widget.uidTecnico!)
                              .set(createAnimaisProdutoresRecordData(
                            uidTecnicoPropriedade: widget.uidPropriedade,
                            nomeAnimal: _nomeTextController.text,
                            brincoAnimal: _brincoTextController.text != ''
                                ? int.tryParse(_brincoTextController.text)
                                : -1,
                            racaAnimal: _racaValue,
                            pesoAnimal: _pesoTextController.text,
                            dtNascimento: _dataNascimentoTextController.text,
                            touro: _touroPaiTextController.text,
                            vaca: _vacaMaeTextController.text,
                            status: _statusAnimalValue,
                            dtUltimaInseminacao:
                                _dataUltimaInseminacaoTextController.text,
                            grupoAnimal: _grupoValue,
                            nomeTouroUltimaInseminacao: _touroInseminacaoValue,
                            dtPartoPrevisto: functions.somarDataParto(
                                _dataUltimaInseminacaoTextController.text),
                            dtSecPrevista: functions.somarDataSecagem(
                                _dataUltimaInseminacaoTextController.text),
                            dtPrePartoPrevista: functions.somarDataPreParto(
                                _dataUltimaInseminacaoTextController.text),
                            totalInseminacoes: 1,
                            dtPP: dateTimeFormat(
                              "dd/MM/yyyy",
                              getCurrentTimestamp,
                              locale: FFLocalizations.of(context).languageCode,
                            ),
                            dtUltimoPP: dateTimeFormat(
                              "dd/MM/yyyy",
                              getCurrentTimestamp,
                              locale: FFLocalizations.of(context).languageCode,
                            ),
                            dtUltimoParto: _dataUltimoPartoTextController.text,
                            compararDtUltimaInseminacao:
                                functions.converterDataUltimaInseminacao(
                                    _dataUltimaInseminacaoTextController.text),
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
                            idStatusAnimal: 5,
                            dtUltimoPartoContingencia:
                                _dataUltimoPartoTextController.text,
                            brincoAnimalOrder: _brincoTextController.text != ''
                                ? int.tryParse(_brincoTextController.text)
                                : 999999,
                          ));

                          await widget.uidTecnico!.update({
                            ...mapToFirestore(
                              {
                                'quantidadeAnimaisCadastrados':
                                    FieldValue.increment(1),
                                'restanteLimiteAnimais':
                                    FieldValue.increment(-(1)),
                              },
                            ),
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Animal cadastrado com sucesso!',
                                style: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              duration: Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).secondary,
                            ),
                          );
                          if (Navigator.of(context).canPop()) {
                            context.pop();
                          }
                          context.pushNamed(
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
                              'tabBarOpenSelected': serializeParam(
                                0,
                                ParamType.int,
                              ),
                            }.withoutNulls,
                          );

                          if (_shouldSetState) safeSetState(() {});
                          return;
                        } else {
                          await showDialog(
                            context: context,
                            builder: (alertDialogContext) {
                              return AlertDialog(
                                title: Text(
                                    'Data última inseminação vazia ou Touro inseminação não selecionado.'),
                                content:
                                    Text('Preencha os campos obrigatórios.'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(alertDialogContext),
                                    child: Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (_shouldSetState) safeSetState(() {});
                          return;
                        }
                      } else {
                        if (_shouldSetState) safeSetState(() {});
                        return;
                      }
                    }
                  }
                }
              }
            }
          } else {
            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text('Status é obrigatório.'),
                  content: Text('Selecione ao menos um status.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(alertDialogContext),
                      child: Text('Ok'),
                    ),
                  ],
                );
              },
            );
            if (_shouldSetState) safeSetState(() {});
            return;
          }
        } else {
          if ((_grupoValue == 'Sêmens') || (_grupoValue == 'Touros')) {
            if (_grupoValue == 'Touros') {
              await AnimaisProdutoresRecord.createDoc(widget.uidTecnico!)
                  .set(createAnimaisProdutoresRecordData(
                uidTecnicoPropriedade: widget.uidPropriedade,
                nomeAnimal: _nomeTextController.text,
                brincoAnimal: _brincoTextController.text != ''
                    ? int.tryParse(_brincoTextController.text)
                    : -1,
                racaAnimal: _racaValue,
                pesoAnimal: _pesoTextController.text,
                dtNascimento: _dataNascimentoTextController.text,
                touro: _touroPaiTextController.text,
                vaca: _vacaMaeTextController.text,
                grupoAnimal: _grupoValue,
                liberaInseminacao: () {
                  if (_grupoValue == 'Touros') {
                    return _switchValue;
                  } else if (_grupoValue == 'Sêmens') {
                    return _switchValue;
                  } else {
                    return true;
                  }
                }(),
                status: '',
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
                brincoAnimalOrder: _brincoTextController.text != ''
                    ? int.tryParse(_brincoTextController.text)
                    : 999999,
              ));

              await widget.uidTecnico!.update({
                ...mapToFirestore(
                  {
                    'quantidadeAnimaisCadastrados': FieldValue.increment(1),
                    'restanteLimiteAnimais': FieldValue.increment(-(1)),
                  },
                ),
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Animal cadastrado com sucesso!',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  duration: Duration(milliseconds: 4000),
                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                ),
              );
              if (Navigator.of(context).canPop()) {
                context.pop();
              }
              context.pushNamed(
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

              if (_shouldSetState) safeSetState(() {});
              return;
            } else {
              if (_grupoValue == 'Sêmens') {
                await AnimaisProdutoresRecord.createDoc(widget.uidTecnico!)
                    .set(createAnimaisProdutoresRecordData(
                  uidTecnicoPropriedade: widget.uidPropriedade,
                  nomeAnimal: _nomeTextController.text,
                  brincoAnimal: _brincoTextController.text != ''
                      ? int.tryParse(_brincoTextController.text)
                      : -1,
                  racaAnimal: _racaValue,
                  dtNascimento: _dataNascimentoTextController.text,
                  touro: _touroPaiTextController.text,
                  grupoAnimal: _grupoValue,
                  liberaInseminacao: () {
                    if (_grupoValue == 'Touros') {
                      return _switchValue;
                    } else if (_grupoValue == 'Sêmens') {
                      return _switchValue;
                    } else {
                      return true;
                    }
                  }(),
                  status: '',
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
                  brincoAnimalOrder: _brincoTextController.text != ''
                      ? int.tryParse(_brincoTextController.text)
                      : 999999,
                ));

                await widget.uidTecnico!.update({
                  ...mapToFirestore(
                    {
                      'quantidadeAnimaisCadastrados': FieldValue.increment(1),
                      'restanteLimiteAnimais': FieldValue.increment(-(1)),
                    },
                  ),
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Animal cadastrado com sucesso!',
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                    duration: Duration(milliseconds: 4000),
                    backgroundColor: FlutterFlowTheme.of(context).secondary,
                  ),
                );
                if (Navigator.of(context).canPop()) {
                  context.pop();
                }
                context.pushNamed(
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

                if (_shouldSetState) safeSetState(() {});
                return;
              } else {
                if (_shouldSetState) safeSetState(() {});
                return;
              }
            }
          } else {
            await AnimaisProdutoresRecord.createDoc(widget.uidTecnico!)
                .set(createAnimaisProdutoresRecordData(
              uidTecnicoPropriedade: widget.uidPropriedade,
              nomeAnimal: _nomeTextController.text,
              brincoAnimal: _brincoTextController.text != ''
                  ? int.tryParse(_brincoTextController.text)
                  : -1,
              racaAnimal: _racaValue,
              pesoAnimal: _pesoTextController.text,
              dtNascimento: _dataNascimentoTextController.text,
              touro: _touroPaiTextController.text,
              vaca: _vacaMaeTextController.text,
              grupoAnimal: _grupoValue,
              status: '',
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
              brincoAnimalOrder: _brincoTextController.text != ''
                  ? int.tryParse(_brincoTextController.text)
                  : 999999,
            ));

            await widget.uidTecnico!.update({
              ...mapToFirestore(
                {
                  'quantidadeAnimaisCadastrados': FieldValue.increment(1),
                  'restanteLimiteAnimais': FieldValue.increment(-(1)),
                },
              ),
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Animal cadastrado com sucesso!',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
                duration: Duration(milliseconds: 4000),
                backgroundColor: FlutterFlowTheme.of(context).secondary,
              ),
            );
            if (Navigator.of(context).canPop()) {
              context.pop();
            }
            context.pushNamed(
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

            if (_shouldSetState) safeSetState(() {});
            return;
          }
        }
      }
    } else {
      if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
        return;
      }
      if (_racaValue == null) {
        return;
      }
      if (_grupoValue == null) {
        return;
      }
      _outListaAnimaisVerificaNomeOff = await queryAnimaisProdutoresRecordOnce(
        parent: widget.uidTecnico,
        queryBuilder: (animaisProdutoresRecord) => animaisProdutoresRecord
            .where(
              'uidTecnicoPropriedade',
              isEqualTo: widget.uidPropriedade,
            )
            .where(
              'nomeAnimal',
              isEqualTo: _nomeTextController.text,
            ),
      );
      _shouldSetState = true;
      _outListaAnimaisVerificaBrincoOff =
          await queryAnimaisProdutoresRecordOnce(
        parent: widget.uidTecnico,
        queryBuilder: (animaisProdutoresRecord) => animaisProdutoresRecord
            .where(
              'uidTecnicoPropriedade',
              isEqualTo: widget.uidPropriedade,
            )
            .where(
              'brincoAnimal',
              isEqualTo: int.tryParse(_brincoTextController.text),
            ),
      );
      _shouldSetState = true;
      if ((_outListaAnimaisVerificaNomeOff!.length > 0) &&
          (_outListaAnimaisVerificaBrincoOff!.length > 0)) {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Nome ou brinco já existe.'),
              content: Text('Digite outro nome ou brinco.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext),
                  child: Text('Ok'),
                ),
              ],
            );
          },
        );
        if (_shouldSetState) safeSetState(() {});
        return;
      }
      if ((_nomeTextController.text != '') ||
          (_brincoTextController.text != '')) {
        if (_dataUltimaInseminacaoTextController.text != '') {
          if (!(_touroInseminacaoValue != null &&
              _touroInseminacaoValue != '')) {
            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text('Touro inseminação não selecionado.'),
                  content: Text('Selecione o touro usado.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(alertDialogContext),
                      child: Text('Ok'),
                    ),
                  ],
                );
              },
            );
            if (_shouldSetState) safeSetState(() {});
            return;
          }
        }
      } else {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Nome ou brinco obrigatório.'),
              content: Text('Preencha ao menos um dos campos.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext),
                  child: Text('Ok'),
                ),
              ],
            );
          },
        );
        if (_shouldSetState) safeSetState(() {});
        return;
      }

      if ((_grupoValue == 'Vacas') || (_grupoValue == 'Novilhas')) {
        if (_statusAnimalValue != null && _statusAnimalValue != '') {
          if (_statusAnimalValue == 'Inseminada') {
            if ((_dataUltimaInseminacaoTextController.text != '') &&
                (_dataUltimoPartoTextController.text == '') &&
                (_touroInseminacaoValue != null &&
                    _touroInseminacaoValue != '')) {
              await criarAnimalOffline(AnimaisProdutoresStruct(
                uidTecnicoPropriedade: widget.uidPropriedade,
                nomeAnimal: _nomeTextController.text,
                racaAnimal: _racaValue,
                pesoAnimal: _pesoTextController.text,
                dtNascimento: _dataNascimentoTextController.text,
                touro: _touroPaiTextController.text,
                vaca: _vacaMaeTextController.text,
                status: _statusAnimalValue,
                grupoAnimal: _grupoValue,
                dtUltimaInseminacao: _dataUltimaInseminacaoTextController.text,
                brincoAnimalOrder: _brincoTextController.text != ''
                    ? int.tryParse(_brincoTextController.text)
                    : 999999,
                brincoAnimal: _brincoTextController.text != ''
                    ? int.tryParse(_brincoTextController.text)
                    : -1,
                nomeTouroUltimaInseminacao: _touroInseminacaoValue,
                dtPartoPrevisto: functions
                    .somarDataParto(_dataUltimaInseminacaoTextController.text),
                dtSecPrevista: functions.somarDataSecagem(
                    _dataUltimaInseminacaoTextController.text),
                dtPrePartoPrevista: functions.somarDataPreParto(
                    _dataUltimaInseminacaoTextController.text),
                totalInseminacoes: 1,
                compararDtUltimaInseminacao:
                    functions.converterDataUltimaInseminacao(
                        _dataUltimaInseminacaoTextController.text),
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
                idStatusAnimal: 3,
                uidAnimalOffline: functions.criarUidRandom(),
              ));
              safeSetState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Animal cadastrado com sucesso!',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  duration: Duration(milliseconds: 4000),
                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                ),
              );
              if (Navigator.of(context).canPop()) {
                context.pop();
              }
              context.pushNamed(
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
                  'tabBarOpenSelected': serializeParam(
                    0,
                    ParamType.int,
                  ),
                }.withoutNulls,
              );

              if (_shouldSetState) safeSetState(() {});
              return;
            } else {
              if ((_dataUltimoPartoTextController.text != '') &&
                  (_dataUltimaInseminacaoTextController.text != '') &&
                  (_touroInseminacaoValue != null &&
                      _touroInseminacaoValue != '')) {
                await criarAnimalOffline(AnimaisProdutoresStruct(
                  uidTecnicoPropriedade: widget.uidPropriedade,
                  nomeAnimal: _nomeTextController.text,
                  racaAnimal: _racaValue,
                  pesoAnimal: _pesoTextController.text,
                  dtNascimento: _dataNascimentoTextController.text,
                  touro: _touroPaiTextController.text,
                  vaca: _vacaMaeTextController.text,
                  grupoAnimal: _grupoValue,
                  brincoAnimalOrder: _brincoTextController.text != ''
                      ? int.tryParse(_brincoTextController.text)
                      : 999999,
                  brincoAnimal: _brincoTextController.text != ''
                      ? int.tryParse(_brincoTextController.text)
                      : -1,
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
                  status: _statusAnimalValue,
                  dtUltimaInseminacao:
                      _dataUltimaInseminacaoTextController.text,
                  dtUltimoParto: _dataUltimoPartoTextController.text,
                  nomeTouroUltimaInseminacao: _touroInseminacaoValue,
                  dtPartoPrevisto: functions.somarDataParto(
                      _dataUltimaInseminacaoTextController.text),
                  dtSecPrevista: functions.somarDataSecagem(
                      _dataUltimaInseminacaoTextController.text),
                  dtPrePartoPrevista: functions.somarDataPreParto(
                      _dataUltimaInseminacaoTextController.text),
                  totalInseminacoes: 1,
                  totalPartos: 1,
                  compararDtUltimaInseminacao:
                      functions.converterDataUltimaInseminacao(
                          _dataUltimaInseminacaoTextController.text),
                  idStatusAnimal: 3,
                  dtUltimoPartoContingencia:
                      _dataUltimoPartoTextController.text,
                  uidAnimalOffline: functions.criarUidRandom(),
                ));
                safeSetState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Animal cadastrado com sucesso!',
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                    duration: Duration(milliseconds: 4000),
                    backgroundColor: FlutterFlowTheme.of(context).secondary,
                  ),
                );
                if (Navigator.of(context).canPop()) {
                  context.pop();
                }
                context.pushNamed(
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
                    'tabBarOpenSelected': serializeParam(
                      0,
                      ParamType.int,
                    ),
                  }.withoutNulls,
                );

                if (_shouldSetState) safeSetState(() {});
                return;
              } else {
                if (_shouldSetState) safeSetState(() {});
                return;
              }
            }
          } else {
            if (_statusAnimalValue == 'Seca') {
              if (_grupoValue == 'Vacas') {
                await criarAnimalOffline(AnimaisProdutoresStruct(
                  uidTecnicoPropriedade: widget.uidPropriedade,
                  nomeAnimal: _nomeTextController.text,
                  racaAnimal: _racaValue,
                  pesoAnimal: _pesoTextController.text,
                  dtNascimento: _dataNascimentoTextController.text,
                  touro: _touroPaiTextController.text,
                  vaca: _vacaMaeTextController.text,
                  grupoAnimal: _grupoValue,
                  brincoAnimalOrder: _brincoTextController.text != ''
                      ? int.tryParse(_brincoTextController.text)
                      : 999999,
                  brincoAnimal: _brincoTextController.text != ''
                      ? int.tryParse(_brincoTextController.text)
                      : -1,
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
                  status: _statusAnimalValue,
                  dtUltimaInseminacao:
                      _dataUltimaInseminacaoTextController.text,
                  dtPartoPrevisto: functions.somarDataParto(
                      _dataUltimaInseminacaoTextController.text),
                  dtSecPrevista: functions.somarDataSecagem(
                      _dataUltimaInseminacaoTextController.text),
                  dtPrePartoPrevista: functions.somarDataPreParto(
                      _dataUltimaInseminacaoTextController.text),
                  nomeTouroUltimaInseminacao: _touroInseminacaoValue,
                  compararDtUltimaInseminacao:
                      functions.converterDataUltimaInseminacao(
                          _dataUltimaInseminacaoTextController.text),
                  idStatusAnimal: 4,
                  uidAnimalOffline: functions.criarUidRandom(),
                ));
                safeSetState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Animal cadastrado com sucesso!',
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                    duration: Duration(milliseconds: 4000),
                    backgroundColor: FlutterFlowTheme.of(context).secondary,
                  ),
                );
                if (Navigator.of(context).canPop()) {
                  context.pop();
                }
                context.pushNamed(
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
                    'tabBarOpenSelected': serializeParam(
                      0,
                      ParamType.int,
                    ),
                  }.withoutNulls,
                );

                if (_shouldSetState) safeSetState(() {});
                return;
              } else {
                await showDialog(
                  context: context,
                  builder: (alertDialogContext) {
                    return AlertDialog(
                      title: Text(
                          'O status de \"Seca\" é permitido somente em vacas.'),
                      content: Text('Atualize o status.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(alertDialogContext),
                          child: Text('Ok'),
                        ),
                      ],
                    );
                  },
                );
                if (_shouldSetState) safeSetState(() {});
                return;
              }
            } else {
              if (_statusAnimalValue == 'Vazia') {
                await criarAnimalOffline(AnimaisProdutoresStruct(
                  uidTecnicoPropriedade: widget.uidPropriedade,
                  nomeAnimal: _nomeTextController.text,
                  racaAnimal: _racaValue,
                  pesoAnimal: _pesoTextController.text,
                  dtNascimento: _dataNascimentoTextController.text,
                  touro: _touroPaiTextController.text,
                  vaca: _vacaMaeTextController.text,
                  grupoAnimal: _grupoValue,
                  brincoAnimalOrder: _brincoTextController.text != ''
                      ? int.tryParse(_brincoTextController.text)
                      : 999999,
                  brincoAnimal: _brincoTextController.text != ''
                      ? int.tryParse(_brincoTextController.text)
                      : -1,
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
                  dtUltimoParto: _dataUltimoPartoTextController.text,
                  status: _statusAnimalValue,
                  totalPartos:
                      _dataUltimoPartoTextController.text != '' ? 1 : 0,
                  idStatusAnimal: 2,
                  dtUltimoPartoContingencia:
                      _dataUltimoPartoTextController.text,
                  uidAnimalOffline: functions.criarUidRandom(),
                ));
                safeSetState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Animal cadastrado com sucesso!',
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                    duration: Duration(milliseconds: 4000),
                    backgroundColor: FlutterFlowTheme.of(context).secondary,
                  ),
                );
                if (Navigator.of(context).canPop()) {
                  context.pop();
                }
                context.pushNamed(
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
                    'tabBarOpenSelected': serializeParam(
                      0,
                      ParamType.int,
                    ),
                  }.withoutNulls,
                );

                if (_shouldSetState) safeSetState(() {});
                return;
              } else {
                if (_statusAnimalValue == 'Prenha') {
                  if ((_dataUltimaInseminacaoTextController.text != '') &&
                      (_touroInseminacaoValue != null &&
                          _touroInseminacaoValue != '')) {
                    await criarAnimalOffline(AnimaisProdutoresStruct(
                      uidTecnicoPropriedade: widget.uidPropriedade,
                      nomeAnimal: _nomeTextController.text,
                      racaAnimal: _racaValue,
                      pesoAnimal: _pesoTextController.text,
                      dtNascimento: _dataNascimentoTextController.text,
                      touro: _touroPaiTextController.text,
                      vaca: _vacaMaeTextController.text,
                      grupoAnimal: _grupoValue,
                      brincoAnimalOrder: _brincoTextController.text != ''
                          ? int.tryParse(_brincoTextController.text)
                          : 999999,
                      brincoAnimal: _brincoTextController.text != ''
                          ? int.tryParse(_brincoTextController.text)
                          : -1,
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
                      status: _statusAnimalValue,
                      dtUltimaInseminacao:
                          _dataUltimaInseminacaoTextController.text,
                      nomeTouroUltimaInseminacao: _touroInseminacaoValue,
                      dtPartoPrevisto: functions.somarDataParto(
                          _dataUltimaInseminacaoTextController.text),
                      dtSecPrevista: functions.somarDataSecagem(
                          _dataUltimaInseminacaoTextController.text),
                      dtPrePartoPrevista: functions.somarDataPreParto(
                          _dataUltimaInseminacaoTextController.text),
                      totalInseminacoes: 1,
                      dtDgMais: dateTimeFormat(
                        "dd/MM/yyyy",
                        getCurrentTimestamp,
                        locale: FFLocalizations.of(context).languageCode,
                      ),
                      dtUltimoParto: _dataUltimoPartoTextController.text,
                      compararDtUltimaInseminacao:
                          functions.converterDataUltimaInseminacao(
                              _dataUltimaInseminacaoTextController.text),
                      idStatusAnimal: 6,
                      dtUltimoPartoContingencia:
                          _dataUltimoPartoTextController.text,
                      uidAnimalOffline: functions.criarUidRandom(),
                    ));
                    safeSetState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Animal cadastrado com sucesso!',
                          style: TextStyle(
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                        ),
                        duration: Duration(milliseconds: 4000),
                        backgroundColor: FlutterFlowTheme.of(context).secondary,
                      ),
                    );
                    if (Navigator.of(context).canPop()) {
                      context.pop();
                    }
                    context.pushNamed(
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
                        'tabBarOpenSelected': serializeParam(
                          0,
                          ParamType.int,
                        ),
                      }.withoutNulls,
                    );

                    if (_shouldSetState) safeSetState(() {});
                    return;
                  } else {
                    await showDialog(
                      context: context,
                      builder: (alertDialogContext) {
                        return AlertDialog(
                          title: Text(
                              'Data última inseminação vazia ou Touro inseminação não selecionado.'),
                          content: Text('Preencha os campos obrigatórios.'),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(alertDialogContext),
                              child: Text('Ok'),
                            ),
                          ],
                        );
                      },
                    );
                    if (_shouldSetState) safeSetState(() {});
                    return;
                  }
                } else {
                  if (_statusAnimalValue == 'Inseminada PP') {
                    if ((_dataUltimaInseminacaoTextController.text != '') &&
                        (_touroInseminacaoValue != null &&
                            _touroInseminacaoValue != '')) {
                      await criarAnimalOffline(AnimaisProdutoresStruct(
                        uidTecnicoPropriedade: widget.uidPropriedade,
                        nomeAnimal: _nomeTextController.text,
                        racaAnimal: _racaValue,
                        pesoAnimal: _pesoTextController.text,
                        dtNascimento: _dataNascimentoTextController.text,
                        touro: _touroPaiTextController.text,
                        vaca: _vacaMaeTextController.text,
                        grupoAnimal: _grupoValue,
                        brincoAnimalOrder: _brincoTextController.text != ''
                            ? int.tryParse(_brincoTextController.text)
                            : 999999,
                        brincoAnimal: _brincoTextController.text != ''
                            ? int.tryParse(_brincoTextController.text)
                            : -1,
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
                        status: _statusAnimalValue,
                        dtUltimaInseminacao:
                            _dataUltimaInseminacaoTextController.text,
                        nomeTouroUltimaInseminacao: _touroInseminacaoValue,
                        dtPartoPrevisto: functions.somarDataParto(
                            _dataUltimaInseminacaoTextController.text),
                        dtSecPrevista: functions.somarDataSecagem(
                            _dataUltimaInseminacaoTextController.text),
                        dtPrePartoPrevista: functions.somarDataPreParto(
                            _dataUltimaInseminacaoTextController.text),
                        totalInseminacoes: 1,
                        dtPP: dateTimeFormat(
                          "dd/MM/yyyy",
                          getCurrentTimestamp,
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                        dtUltimoPP: dateTimeFormat(
                          "dd/MM/yyyy",
                          getCurrentTimestamp,
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                        dtUltimoParto: _dataUltimoPartoTextController.text,
                        compararDtUltimaInseminacao:
                            functions.converterDataUltimaInseminacao(
                                _dataUltimaInseminacaoTextController.text),
                        idStatusAnimal: 1,
                        dtUltimoPartoContingencia:
                            _dataUltimoPartoTextController.text,
                        uidAnimalOffline: functions.criarUidRandom(),
                      ));
                      safeSetState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Animal cadastrado com sucesso!',
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                          duration: Duration(milliseconds: 4000),
                          backgroundColor:
                              FlutterFlowTheme.of(context).secondary,
                        ),
                      );
                      if (Navigator.of(context).canPop()) {
                        context.pop();
                      }
                      context.pushNamed(
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
                          'tabBarOpenSelected': serializeParam(
                            0,
                            ParamType.int,
                          ),
                        }.withoutNulls,
                      );

                      if (_shouldSetState) safeSetState(() {});
                      return;
                    } else {
                      await showDialog(
                        context: context,
                        builder: (alertDialogContext) {
                          return AlertDialog(
                            title: Text(
                                'Data última inseminação vazia ou Touro inseminação não selecionado.'),
                            content: Text('Preencha os campos obrigatórios.'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(alertDialogContext),
                                child: Text('Ok'),
                              ),
                            ],
                          );
                        },
                      );
                      if (_shouldSetState) safeSetState(() {});
                      return;
                    }
                  } else {
                    if (_statusAnimalValue == 'Pré Parto') {
                      if ((_dataUltimaInseminacaoTextController.text != '') &&
                          (_touroInseminacaoValue != null &&
                              _touroInseminacaoValue != '')) {
                        await criarAnimalOffline(AnimaisProdutoresStruct(
                          uidTecnicoPropriedade: widget.uidPropriedade,
                          nomeAnimal: _nomeTextController.text,
                          racaAnimal: _racaValue,
                          pesoAnimal: _pesoTextController.text,
                          dtNascimento: _dataNascimentoTextController.text,
                          touro: _touroPaiTextController.text,
                          vaca: _vacaMaeTextController.text,
                          grupoAnimal: _grupoValue,
                          brincoAnimalOrder: _brincoTextController.text != ''
                              ? int.tryParse(_brincoTextController.text)
                              : 999999,
                          brincoAnimal: _brincoTextController.text != ''
                              ? int.tryParse(_brincoTextController.text)
                              : -1,
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
                          status: _statusAnimalValue,
                          dtUltimaInseminacao:
                              _dataUltimaInseminacaoTextController.text,
                          nomeTouroUltimaInseminacao: _touroInseminacaoValue,
                          dtPartoPrevisto: functions.somarDataParto(
                              _dataUltimaInseminacaoTextController.text),
                          dtSecPrevista: functions.somarDataSecagem(
                              _dataUltimaInseminacaoTextController.text),
                          dtPrePartoPrevista: functions.somarDataPreParto(
                              _dataUltimaInseminacaoTextController.text),
                          totalInseminacoes: 1,
                          dtPP: dateTimeFormat(
                            "dd/MM/yyyy",
                            getCurrentTimestamp,
                            locale: FFLocalizations.of(context).languageCode,
                          ),
                          dtUltimoPP: dateTimeFormat(
                            "dd/MM/yyyy",
                            getCurrentTimestamp,
                            locale: FFLocalizations.of(context).languageCode,
                          ),
                          dtUltimoParto: _dataUltimoPartoTextController.text,
                          compararDtUltimaInseminacao:
                              functions.converterDataUltimaInseminacao(
                                  _dataUltimaInseminacaoTextController.text),
                          idStatusAnimal: 5,
                          dtUltimoPartoContingencia:
                              _dataUltimoPartoTextController.text,
                          uidAnimalOffline: functions.criarUidRandom(),
                        ));
                        safeSetState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Animal cadastrado com sucesso!',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                            duration: Duration(milliseconds: 4000),
                            backgroundColor:
                                FlutterFlowTheme.of(context).secondary,
                          ),
                        );
                        if (Navigator.of(context).canPop()) {
                          context.pop();
                        }
                        context.pushNamed(
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
                            'tabBarOpenSelected': serializeParam(
                              0,
                              ParamType.int,
                            ),
                          }.withoutNulls,
                        );

                        if (_shouldSetState) safeSetState(() {});
                        return;
                      } else {
                        await showDialog(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              title: Text(
                                  'Data última inseminação vazia ou Touro inseminação não selecionado.'),
                              content: Text('Preencha os campos obrigatórios.'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext),
                                  child: Text('Ok'),
                                ),
                              ],
                            );
                          },
                        );
                        if (_shouldSetState) safeSetState(() {});
                        return;
                      }
                    } else {
                      if (_shouldSetState) safeSetState(() {});
                      return;
                    }
                  }
                }
              }
            }
          }
        } else {
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: Text('Status é obrigatório.'),
                content: Text('Selecione ao menos um status.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext),
                    child: Text('Ok'),
                  ),
                ],
              );
            },
          );
          if (_shouldSetState) safeSetState(() {});
          return;
        }
      } else {
        if ((_grupoValue == 'Sêmens') || (_grupoValue == 'Touros')) {
          if (_grupoValue == 'Touros') {
            await criarAnimalOffline(AnimaisProdutoresStruct(
              uidTecnicoPropriedade: widget.uidPropriedade,
              nomeAnimal: _nomeTextController.text,
              racaAnimal: _racaValue,
              pesoAnimal: _pesoTextController.text,
              dtNascimento: _dataNascimentoTextController.text,
              touro: _touroPaiTextController.text,
              vaca: _vacaMaeTextController.text,
              grupoAnimal: _grupoValue,
              brincoAnimalOrder: _brincoTextController.text != ''
                  ? int.tryParse(_brincoTextController.text)
                  : 999999,
              brincoAnimal: _brincoTextController.text != ''
                  ? int.tryParse(_brincoTextController.text)
                  : -1,
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
              liberaInseminacao: () {
                if (_grupoValue == 'Touros') {
                  return _switchValue;
                } else if (_grupoValue == 'Sêmens') {
                  return _switchValue;
                } else {
                  return true;
                }
              }(),
              uidAnimalOffline: functions.criarUidRandom(),
            ));
            safeSetState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Animal cadastrado com sucesso!',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
                duration: Duration(milliseconds: 4000),
                backgroundColor: FlutterFlowTheme.of(context).secondary,
              ),
            );
            if (Navigator.of(context).canPop()) {
              context.pop();
            }
            context.pushNamed(
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

            if (_shouldSetState) safeSetState(() {});
            return;
          } else {
            if (_grupoValue == 'Sêmens') {
              await criarAnimalOffline(AnimaisProdutoresStruct(
                uidTecnicoPropriedade: widget.uidPropriedade,
                nomeAnimal: _nomeTextController.text,
                racaAnimal: _racaValue,
                pesoAnimal: _pesoTextController.text,
                dtNascimento: _dataNascimentoTextController.text,
                touro: _touroPaiTextController.text,
                grupoAnimal: _grupoValue,
                brincoAnimalOrder: _brincoTextController.text != ''
                    ? int.tryParse(_brincoTextController.text)
                    : 999999,
                brincoAnimal: _brincoTextController.text != ''
                    ? int.tryParse(_brincoTextController.text)
                    : -1,
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
                liberaInseminacao: () {
                  if (_grupoValue == 'Touros') {
                    return _switchValue;
                  } else if (_grupoValue == 'Sêmens') {
                    return _switchValue;
                  } else {
                    return true;
                  }
                }(),
                uidAnimalOffline: functions.criarUidRandom(),
              ));
              safeSetState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Animal cadastrado com sucesso!',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  duration: Duration(milliseconds: 4000),
                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                ),
              );
              if (Navigator.of(context).canPop()) {
                context.pop();
              }
              context.pushNamed(
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

              if (_shouldSetState) safeSetState(() {});
              return;
            } else {
              if (_shouldSetState) safeSetState(() {});
              return;
            }
          }
        } else {
          await criarAnimalOffline(AnimaisProdutoresStruct(
            uidTecnicoPropriedade: widget.uidPropriedade,
            nomeAnimal: _nomeTextController.text,
            racaAnimal: _racaValue,
            pesoAnimal: _pesoTextController.text,
            dtNascimento: _dataNascimentoTextController.text,
            touro: _touroPaiTextController.text,
            vaca: _vacaMaeTextController.text,
            grupoAnimal: _grupoValue,
            brincoAnimalOrder: _brincoTextController.text != ''
                ? int.tryParse(_brincoTextController.text)
                : 999999,
            brincoAnimal: _brincoTextController.text != ''
                ? int.tryParse(_brincoTextController.text)
                : -1,
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
            uidAnimalOffline: functions.criarUidRandom(),
          ));
          safeSetState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Animal cadastrado com sucesso!',
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
              duration: Duration(milliseconds: 4000),
              backgroundColor: FlutterFlowTheme.of(context).secondary,
            ),
          );
          if (Navigator.of(context).canPop()) {
            context.pop();
          }
          context.pushNamed(
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

          if (_shouldSetState) safeSetState(() {});
          return;
        }
      }
    }

    if (_shouldSetState) safeSetState(() {});
  }

  Widget _p1(BuildContext context) {
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
          'Adicionar animal',
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

  Widget _p2(BuildContext context,
      dynamic cadastrarNovoAnimalStatusAnimaisRecordList) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _p3(context),
              _p4(context),
              _p5(context),
              _p6(context),
              if (((widget.grupoPredominante == 'Sêmens') ||
                      (widget.grupoPredominante == 'Touros')) ||
                  ((_grupoValue == 'Touros') || (_grupoValue == 'Sêmens')))
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _p11(context),
                    _p12(context),
                  ],
                ),
              if (_grupoValue != 'Sêmens')
                TextFormField(
                  controller: _pesoTextController,
                  focusNode: _pesoFocusNode,
                  autofocus: false,
                  textCapitalization: TextCapitalization.none,
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
                  maxLength: 5,
                  maxLengthEnforcement: MaxLengthEnforcement.none,
                  buildCounter: (context,
                          {required currentLength,
                          required isFocused,
                          maxLength}) =>
                      null,
                  keyboardType: TextInputType.number,
                  cursorColor: FlutterFlowTheme.of(context).primary,
                  validator: _pesoTextControllerValidator.asValidator(context),
                  inputFormatters: [
                    if (!isAndroid && !isiOS)
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        return TextEditingValue(
                          selection: newValue.selection,
                          text: newValue.text
                              .toCapitalization(TextCapitalization.none),
                        );
                      }),
                  ],
                ),
              _p7(context),
              _p8(context),
              _p9(context),
              if (((_grupoValue == 'Vacas') ||
                      (widget.grupoPredominante == 'Vacas')) &&
                  (_statusAnimalValue != 'Seca'))
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _p13(context),
                    _p14(context),
                  ],
                ),
              if (((_grupoValue == 'Vacas') || (_grupoValue == 'Novilhas')) ||
                  ((widget.grupoPredominante == 'Novilhas') ||
                      (widget.grupoPredominante == 'Vacas')))
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _p15(context),
                    _p16(context),
                  ],
                ),
              if (((_grupoValue == 'Vacas') || (_grupoValue == 'Novilhas')) &&
                  (_dataUltimaInseminacaoTextController.text != ''))
                StreamBuilder<List<AnimaisProdutoresRecord>>(
                  stream: _animaisLiberaoParaInseminar(
                    requestFn: () => queryAnimaisProdutoresRecord(
                      parent: widget.uidTecnico,
                      queryBuilder: (animaisProdutoresRecord) =>
                          animaisProdutoresRecord
                              .where(
                                'uidTecnicoPropriedade',
                                isEqualTo: widget.uidPropriedade,
                              )
                              .where(
                                'liberaInseminacao',
                                isEqualTo: true,
                              ),
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
                        touroInseminacaoAnimaisProdutoresRecordList =
                        snapshot.data!;

                    return FlutterFlowDropDown<String>(
                      controller: _touroInseminacaoValueController ??=
                          FormFieldController<String>(null),
                      options: functions.duasListasEmUma(
                          touroInseminacaoAnimaisProdutoresRecordList
                              .map((e) => e.nomeBrincoConcat)
                              .toList(),
                          <String>[])!,
                      onChanged: (val) =>
                          safeSetState(() => _touroInseminacaoValue = val),
                      width: double.infinity,
                      height: 50.0,
                      searchHintTextStyle:
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
                      searchTextStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
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
                      textStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
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
                      hintText: 'Touro/sêmen inseminação',
                      searchHintText: 'Digite para pesquisar...',
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      elevation: 2.0,
                      borderColor: FlutterFlowTheme.of(context).alternate,
                      borderWidth: 2.0,
                      borderRadius: 8.0,
                      margin:
                          EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                      hidesUnderline: true,
                      isSearchable: true,
                      isMultiSelect: false,
                    );
                  },
                ),
              if (((widget.grupoPredominante == 'Novilhas') ||
                      (widget.grupoPredominante == 'Vacas')) ||
                  ((_grupoValue == 'Vacas') || (_grupoValue == 'Novilhas')))
                FlutterFlowDropDown<String>(
                  controller: _statusAnimalValueController ??=
                      FormFieldController<String>(
                    _statusAnimalValue ??= 'Vazia',
                  ),
                  options: () {
                    if ((_dataUltimaInseminacaoTextController.text != '') &&
                        (_dataUltimoPartoTextController.text != '') &&
                        (_datePicked2! > _datePicked3!)) {
                      return cadastrarNovoAnimalStatusAnimaisRecordList
                          .map((e) => e.descricao)
                          .toList()
                          .where((e) => e == 'Vazia')
                          .toList();
                    } else if ((_dataUltimaInseminacaoTextController.text !=
                            '') &&
                        (_dataUltimoPartoTextController.text != '') &&
                        (_datePicked2! < _datePicked3!)) {
                      return cadastrarNovoAnimalStatusAnimaisRecordList
                          .map((e) => e.descricao)
                          .toList()
                          .where((e) =>
                              (e == 'Inseminada') ||
                              (e == 'Prenha') ||
                              (e == 'Seca') ||
                              (e == 'Inseminada PP') ||
                              (e == 'Pré Parto'))
                          .toList();
                    } else if ((_dataUltimaInseminacaoTextController.text !=
                            '') &&
                        (_dataUltimoPartoTextController.text == '')) {
                      return functions.retornaStringEmLista(_grupoValue ==
                              'Novilhas'
                          ? 'Inseminada, Inseminada PP, Prenha, Pré Parto'
                          : 'Inseminada, Inseminada PP, Prenha, Seca, Pré Parto');
                    } else if ((_dataUltimaInseminacaoTextController.text ==
                            '') &&
                        (_dataUltimoPartoTextController.text != '')) {
                      return cadastrarNovoAnimalStatusAnimaisRecordList
                          .map((e) => e.descricao)
                          .toList()
                          .where((e) => e == 'Vazia')
                          .toList();
                    } else {
                      return functions.retornaStringEmLista('Vazia');
                    }
                  }(),
                  onChanged: (val) =>
                      safeSetState(() => _statusAnimalValue = val),
                  width: double.infinity,
                  height: 50.0,
                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
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
                  hintText: 'Status animal',
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
                ),
              _p10(context),
            ].divide(SizedBox(height: 12.0)),
          ),
        ),
      ),
    );
  }

  Widget _p3(BuildContext context) {
    return TextFormField(
      controller: _nomeTextController,
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

  Widget _p4(BuildContext context) {
    return TextFormField(
      controller: _brincoTextController,
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

  Widget _p5(BuildContext context) {
    return StreamBuilder<List<RacasRecord>>(
      stream: FFAppState().racasGeral(
        requestFn: () => queryRacasRecord(),
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
        List<RacasRecord> racaRacasRecordList = snapshot.data!;

        return FlutterFlowDropDown<String>(
          controller: _racaValueController ??= FormFieldController<String>(
            _racaValue ??= 'Holandesa',
          ),
          options: _respostaNet!
              ? racaRacasRecordList.map((e) => e.descricao).toList()
              : kRacasDescricoes.toList(),
          onChanged: (val) => safeSetState(() => _racaValue = val),
          width: double.infinity,
          height: 50.0,
          searchHintTextStyle: FlutterFlowTheme.of(context)
              .labelMedium
              .override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          searchTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
          textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
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
      },
    );
  }

  Widget _p6(BuildContext context) {
    return StreamBuilder<List<GrupoRecord>>(
      stream: FFAppState().gruposGeral(
        requestFn: () => queryGrupoRecord(),
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
        List<GrupoRecord> grupoGrupoRecordList = snapshot.data!;

        return FlutterFlowDropDown<String>(
          controller: _grupoValueController ??= FormFieldController<String>(
            _grupoValue ??= widget.grupoPredominante,
          ),
          options: _respostaNet!
              ? grupoGrupoRecordList.map((e) => e.descricao).toList()
              : kGruposDescricoes.toList(),
          onChanged: (val) => safeSetState(() => _grupoValue = val),
          width: double.infinity,
          height: 50.0,
          textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
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
      },
    );
  }

  Widget _p7(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
            child: TextFormField(
              controller: _dataNascimentoTextController,
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
                  final _datePicked1CupertinoTheme = CupertinoTheme.of(context);
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
                        data: _datePicked1CupertinoTheme.copyWith(
                          textTheme:
                              _datePicked1CupertinoTheme.textTheme.copyWith(
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
                          maximumDate: (getCurrentTimestamp ?? DateTime(2050)),
                          backgroundColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          use24hFormat: false,
                          onDateTimeChanged: (newDateTime) => safeSetState(() {
                            _datePicked1 = newDateTime;
                          }),
                        ),
                      ),
                    ),
                  );
                });
            safeSetState(() {
              _dataNascimentoTextController?.text = dateTimeFormat(
                "dd/MM/yyyy",
                _datePicked1,
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

  Widget _p8(BuildContext context) {
    return TextFormField(
      controller: _touroPaiTextController,
      focusNode: _touroPaiFocusNode,
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
      validator: _touroPaiTextControllerValidator.asValidator(context),
    );
  }

  Widget _p9(BuildContext context) {
    return TextFormField(
      controller: _vacaMaeTextController,
      focusNode: _vacaMaeFocusNode,
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
      validator: _vacaMaeTextControllerValidator.asValidator(context),
    );
  }

  Widget _p10(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 12.0),
      child: FFButtonWidget(
        onPressed: () async {
          await _cadastrarAnimal(context);
        },
        text: 'Adicionar Novo',
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

  Widget _p11(BuildContext context) {
    return Text(
      'Liberar para inseminações:',
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.readexPro(
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            letterSpacing: 0.0,
            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
    );
  }

  Widget _p12(BuildContext context) {
    return Switch.adaptive(
      value: _switchValue!,
      onChanged: (newValue) async {
        safeSetState(() => _switchValue = newValue);
      },
      activeColor: FlutterFlowTheme.of(context).tertiary,
      activeTrackColor: FlutterFlowTheme.of(context).alternate,
      inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
      inactiveThumbColor: FlutterFlowTheme.of(context).secondaryText,
    );
  }

  Widget _p13(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
        child: TextFormField(
          controller: _dataUltimoPartoTextController,
          focusNode: _dataUltimoPartoFocusNode,
          onChanged: (_) => EasyDebounce.debounce(
            '_dataUltimoPartoTextController',
            Duration(milliseconds: 2000),
            () => safeSetState(() {}),
          ),
          autofocus: false,
          textCapitalization: TextCapitalization.none,
          textInputAction: TextInputAction.next,
          readOnly: true,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Último parto',
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
            contentPadding:
                EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
            suffixIcon: _dataUltimoPartoTextController!.text.isNotEmpty
                ? InkWell(
                    onTap: () async {
                      _dataUltimoPartoTextController?.clear();
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
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
          maxLength: 10,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          keyboardType: TextInputType.datetime,
          validator:
              _dataUltimoPartoTextControllerValidator.asValidator(context),
          inputFormatters: [_dataUltimoPartoMask],
        ),
      ),
    );
  }

  Widget _p14(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        var _shouldSetState = false;
        // calendarUltimoParto
        await showModalBottomSheet<bool>(
            context: context,
            builder: (context) {
              final _datePicked2CupertinoTheme = CupertinoTheme.of(context);
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
                    data: _datePicked2CupertinoTheme.copyWith(
                      textTheme: _datePicked2CupertinoTheme.textTheme.copyWith(
                        dateTimePickerTextStyle: FlutterFlowTheme.of(context)
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
                              color: FlutterFlowTheme.of(context).primaryText,
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
                      minimumDate: DateTime(1900),
                      initialDateTime: getCurrentTimestamp,
                      maximumDate: (getCurrentTimestamp ?? DateTime(2050)),
                      backgroundColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      use24hFormat: false,
                      onDateTimeChanged: (newDateTime) => safeSetState(() {
                        _datePicked2 = newDateTime;
                      }),
                    ),
                  ),
                ),
              );
            });
        safeSetState(() {
          _dataUltimoPartoTextController?.text = dateTimeFormat(
            "dd/MM/yyyy",
            _datePicked2,
            locale: FFLocalizations.of(context).languageCode,
          );
          _dataUltimoPartoMask.updateMask(
            newValue: TextEditingValue(
              text: _dataUltimoPartoTextController!.text,
            ),
          );
        });
        if (_datePicked2! > _datePicked3!) {
          safeSetState(() {
            _statusAnimalValueController?.value = 'Vazia';
            _statusAnimalValue = 'Vazia';
          });
          if (_shouldSetState) safeSetState(() {});
          return;
        } else {
          _outListaAnimais = await queryStatusAnimaisRecordOnce();
          _shouldSetState = true;
          safeSetState(() {
            _statusAnimalValueController?.value =
                (_outListaAnimais != null && (_outListaAnimais)!.isNotEmpty)
                    .toString();
            _statusAnimalValue =
                (_outListaAnimais != null && (_outListaAnimais)!.isNotEmpty)
                    .toString();
          });
          safeSetState(() {
            _statusAnimalValueController?.value = 'Inseminada';
            _statusAnimalValue = 'Inseminada';
          });
          if (_shouldSetState) safeSetState(() {});
          return;
        }

        if (_shouldSetState) safeSetState(() {});
      },
      child: Icon(
        Icons.calendar_month,
        color: FlutterFlowTheme.of(context).secondaryText,
        size: 24.0,
      ),
    );
  }

  Widget _p15(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
        child: TextFormField(
          controller: _dataUltimaInseminacaoTextController,
          focusNode: _dataUltimaInseminacaoFocusNode,
          onChanged: (_) => EasyDebounce.debounce(
            '_dataUltimaInseminacaoTextController',
            Duration(milliseconds: 2000),
            () => safeSetState(() {}),
          ),
          autofocus: false,
          textCapitalization: TextCapitalization.none,
          textInputAction: TextInputAction.next,
          readOnly: true,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Última inseminação',
            labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
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
            contentPadding:
                EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
            suffixIcon: _dataUltimaInseminacaoTextController!.text.isNotEmpty
                ? InkWell(
                    onTap: () async {
                      _dataUltimaInseminacaoTextController?.clear();
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
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
          maxLength: 10,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          keyboardType: TextInputType.datetime,
          validator: _dataUltimaInseminacaoTextControllerValidator
              .asValidator(context),
          inputFormatters: [_dataUltimaInseminacaoMask],
        ),
      ),
    );
  }

  Widget _p16(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        // calendarUltimoParto
        await showModalBottomSheet<bool>(
            context: context,
            builder: (context) {
              final _datePicked3CupertinoTheme = CupertinoTheme.of(context);
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
                    data: _datePicked3CupertinoTheme.copyWith(
                      textTheme: _datePicked3CupertinoTheme.textTheme.copyWith(
                        dateTimePickerTextStyle: FlutterFlowTheme.of(context)
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
                              color: FlutterFlowTheme.of(context).primaryText,
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
                      minimumDate: DateTime(1900),
                      initialDateTime: getCurrentTimestamp,
                      maximumDate: (getCurrentTimestamp ?? DateTime(2050)),
                      backgroundColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      use24hFormat: false,
                      onDateTimeChanged: (newDateTime) => safeSetState(() {
                        _datePicked3 = newDateTime;
                      }),
                    ),
                  ),
                ),
              );
            });
        safeSetState(() {
          _dataUltimaInseminacaoTextController?.text = dateTimeFormat(
            "dd/MM/yyyy",
            _datePicked3,
            locale: FFLocalizations.of(context).languageCode,
          );
          _dataUltimaInseminacaoMask.updateMask(
            newValue: TextEditingValue(
              text: _dataUltimaInseminacaoTextController!.text,
            ),
          );
        });
        if ((_dataUltimaInseminacaoTextController.text != '') &&
            (_dataUltimoPartoTextController.text != '')) {
          if (_datePicked2! > _datePicked3!) {
            safeSetState(() {
              _statusAnimalValueController?.value = 'Vazia';
              _statusAnimalValue = 'Vazia';
            });
            return;
          } else {
            safeSetState(() {
              _statusAnimalValueController?.value = 'Inseminada';
              _statusAnimalValue = 'Inseminada';
            });
            return;
          }
        } else {
          safeSetState(() {
            _statusAnimalValueController?.value = 'Inseminada';
            _statusAnimalValue = 'Inseminada';
          });
          return;
        }
      },
      child: Icon(
        Icons.calendar_month,
        color: FlutterFlowTheme.of(context).secondaryText,
        size: 24.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return StreamBuilder<List<StatusAnimaisRecord>>(
      stream: FFAppState().statusAnimaisGeral(
        requestFn: () => queryStatusAnimaisRecord(),
      ),
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
        List<StatusAnimaisRecord> cadastrarNovoAnimalStatusAnimaisRecordList =
            snapshot.data!;

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
                    _respostaNet! ? Color(0xFFF75E38) : Color(0xFFF2886E),
                automaticallyImplyLeading: false,
                actions: [],
                flexibleSpace: FlexibleSpaceBar(
                  title: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _p1(context),
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
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _p2(context, cadastrarNovoAnimalStatusAnimaisRecordList),
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
