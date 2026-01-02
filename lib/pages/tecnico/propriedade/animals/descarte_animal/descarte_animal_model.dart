import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'descarte_animal_widget.dart' show DescarteAnimalWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DescarteAnimalModel extends FlutterFlowModel<DescarteAnimalWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Read Document] action in descarteAnimal widget.
  AnimaisProdutoresRecord? outUidAnimaisAnimal;
  // State field(s) for motivoDescarte widget.
  String? motivoDescarteValue;
  FormFieldController<String>? motivoDescarteValueController;
  // State field(s) for dtDescarte widget.
  FocusNode? dtDescarteFocusNode;
  TextEditingController? dtDescarteTextController;
  late MaskTextInputFormatter dtDescarteMask;
  String? Function(BuildContext, String?)? dtDescarteTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    dtDescarteFocusNode?.dispose();
    dtDescarteTextController?.dispose();
  }
}
