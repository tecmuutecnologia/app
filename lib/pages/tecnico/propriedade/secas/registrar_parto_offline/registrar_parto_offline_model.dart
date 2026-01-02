import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'registrar_parto_offline_widget.dart' show RegistrarPartoOfflineWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegistrarPartoOfflineModel
    extends FlutterFlowModel<RegistrarPartoOfflineWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for nome widget.
  FocusNode? nomeFocusNode;
  TextEditingController? nomeTextController;
  String? Function(BuildContext, String?)? nomeTextControllerValidator;
  // State field(s) for brinco widget.
  FocusNode? brincoFocusNode;
  TextEditingController? brincoTextController;
  String? Function(BuildContext, String?)? brincoTextControllerValidator;
  // State field(s) for sexo widget.
  String? sexoValue;
  FormFieldController<String>? sexoValueController;
  // State field(s) for racaPre widget.
  String? racaPreValue;
  FormFieldController<String>? racaPreValueController;
  // State field(s) for dtParto widget.
  FocusNode? dtPartoFocusNode;
  TextEditingController? dtPartoTextController;
  late MaskTextInputFormatter dtPartoMask;
  String? Function(BuildContext, String?)? dtPartoTextControllerValidator;
  DateTime? datePicked;
  // State field(s) for pesoNasc widget.
  FocusNode? pesoNascFocusNode;
  TextEditingController? pesoNascTextController;
  String? Function(BuildContext, String?)? pesoNascTextControllerValidator;
  // State field(s) for novoAnimal widget.
  bool? novoAnimalValue;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nomeFocusNode?.dispose();
    nomeTextController?.dispose();

    brincoFocusNode?.dispose();
    brincoTextController?.dispose();

    dtPartoFocusNode?.dispose();
    dtPartoTextController?.dispose();

    pesoNascFocusNode?.dispose();
    pesoNascTextController?.dispose();
  }
}
