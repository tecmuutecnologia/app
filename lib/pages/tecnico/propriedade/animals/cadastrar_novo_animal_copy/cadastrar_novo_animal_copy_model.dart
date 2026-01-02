import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'cadastrar_novo_animal_copy_widget.dart'
    show CadastrarNovoAnimalCopyWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastrarNovoAnimalCopyModel
    extends FlutterFlowModel<CadastrarNovoAnimalCopyWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
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

  @override
  void initState(BuildContext context) {
    dataNascimentoTextControllerValidator =
        _dataNascimentoTextControllerValidator;
  }

  @override
  void dispose() {
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
  }

  /// Action blocks.
  Future teste(BuildContext context) async {}
}
