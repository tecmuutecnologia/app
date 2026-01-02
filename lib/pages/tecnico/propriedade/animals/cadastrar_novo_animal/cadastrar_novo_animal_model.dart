import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'cadastrar_novo_animal_widget.dart' show CadastrarNovoAnimalWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastrarNovoAnimalModel
    extends FlutterFlowModel<CadastrarNovoAnimalWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in cadastrarNovoAnimal widget.
  bool? respostaNet;
  // State field(s) for nome widget.
  FocusNode? nomeFocusNode;
  TextEditingController? nomeTextController;
  String? Function(BuildContext, String?)? nomeTextControllerValidator;
  // State field(s) for brinco widget.
  FocusNode? brincoFocusNode;
  TextEditingController? brincoTextController;
  String? Function(BuildContext, String?)? brincoTextControllerValidator;
  // State field(s) for raca widget.
  String? racaValue;
  FormFieldController<String>? racaValueController;
  // State field(s) for grupo widget.
  String? grupoValue;
  FormFieldController<String>? grupoValueController;
  // State field(s) for Switch widget.
  bool? switchValue;
  // State field(s) for peso widget.
  FocusNode? pesoFocusNode;
  TextEditingController? pesoTextController;
  String? Function(BuildContext, String?)? pesoTextControllerValidator;
  // State field(s) for dataNascimento widget.
  FocusNode? dataNascimentoFocusNode;
  TextEditingController? dataNascimentoTextController;
  late MaskTextInputFormatter dataNascimentoMask;
  String? Function(BuildContext, String?)?
      dataNascimentoTextControllerValidator;
  String? _dataNascimentoTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório';
    }

    return null;
  }

  DateTime? datePicked1;
  // State field(s) for touroPai widget.
  FocusNode? touroPaiFocusNode;
  TextEditingController? touroPaiTextController;
  String? Function(BuildContext, String?)? touroPaiTextControllerValidator;
  // State field(s) for vacaMae widget.
  FocusNode? vacaMaeFocusNode;
  TextEditingController? vacaMaeTextController;
  String? Function(BuildContext, String?)? vacaMaeTextControllerValidator;
  // State field(s) for dataUltimoParto widget.
  FocusNode? dataUltimoPartoFocusNode;
  TextEditingController? dataUltimoPartoTextController;
  late MaskTextInputFormatter dataUltimoPartoMask;
  String? Function(BuildContext, String?)?
      dataUltimoPartoTextControllerValidator;
  DateTime? datePicked2;
  // Stores action output result for [Firestore Query - Query a collection] action in Icon widget.
  List<StatusAnimaisRecord>? outListaAnimais;
  // State field(s) for dataUltimaInseminacao widget.
  FocusNode? dataUltimaInseminacaoFocusNode;
  TextEditingController? dataUltimaInseminacaoTextController;
  late MaskTextInputFormatter dataUltimaInseminacaoMask;
  String? Function(BuildContext, String?)?
      dataUltimaInseminacaoTextControllerValidator;
  DateTime? datePicked3;
  // State field(s) for touroInseminacao widget.
  String? touroInseminacaoValue;
  FormFieldController<String>? touroInseminacaoValueController;
  // State field(s) for statusAnimal widget.
  String? statusAnimalValue;
  FormFieldController<String>? statusAnimalValueController;
  // Stores action output result for [Firestore Query - Query a collection] action in btnCadastrarAnimal widget.
  List<AnimaisProdutoresRecord>? outListaAnimaisVerificaNome;
  // Stores action output result for [Firestore Query - Query a collection] action in btnCadastrarAnimal widget.
  List<AnimaisProdutoresRecord>? outListaAnimaisVerificaBrinco;
  // Stores action output result for [Firestore Query - Query a collection] action in btnCadastrarAnimal widget.
  List<AnimaisProdutoresRecord>? outListaAnimaisVerificaNomeOff;
  // Stores action output result for [Firestore Query - Query a collection] action in btnCadastrarAnimal widget.
  List<AnimaisProdutoresRecord>? outListaAnimaisVerificaBrincoOff;

  /// Query cache managers for this widget.

  final _animaisLiberaoParaInseminarManager =
      StreamRequestManager<List<AnimaisProdutoresRecord>>();
  Stream<List<AnimaisProdutoresRecord>> animaisLiberaoParaInseminar({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<AnimaisProdutoresRecord>> Function() requestFn,
  }) =>
      _animaisLiberaoParaInseminarManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearAnimaisLiberaoParaInseminarCache() =>
      _animaisLiberaoParaInseminarManager.clear();
  void clearAnimaisLiberaoParaInseminarCacheKey(String? uniqueKey) =>
      _animaisLiberaoParaInseminarManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {
    dataNascimentoTextControllerValidator =
        _dataNascimentoTextControllerValidator;
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    nomeFocusNode?.dispose();
    nomeTextController?.dispose();

    brincoFocusNode?.dispose();
    brincoTextController?.dispose();

    pesoFocusNode?.dispose();
    pesoTextController?.dispose();

    dataNascimentoFocusNode?.dispose();
    dataNascimentoTextController?.dispose();

    touroPaiFocusNode?.dispose();
    touroPaiTextController?.dispose();

    vacaMaeFocusNode?.dispose();
    vacaMaeTextController?.dispose();

    dataUltimoPartoFocusNode?.dispose();
    dataUltimoPartoTextController?.dispose();

    dataUltimaInseminacaoFocusNode?.dispose();
    dataUltimaInseminacaoTextController?.dispose();

    /// Dispose query cache managers for this widget.

    clearAnimaisLiberaoParaInseminarCache();
  }

  /// Action blocks.
  Future teste(BuildContext context) async {}
}
