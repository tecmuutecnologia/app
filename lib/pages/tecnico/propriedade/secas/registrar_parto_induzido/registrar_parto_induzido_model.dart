import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'registrar_parto_induzido_widget.dart' show RegistrarPartoInduzidoWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegistrarPartoInduzidoModel
    extends FlutterFlowModel<RegistrarPartoInduzidoWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Read Document] action in registrarPartoInduzido widget.
  AnimaisProdutoresRecord? outUidAnimaisAnimal;
  // State field(s) for dtPartoInduzido widget.
  FocusNode? dtPartoInduzidoFocusNode;
  TextEditingController? dtPartoInduzidoTextController;
  late MaskTextInputFormatter dtPartoInduzidoMask;
  String? Function(BuildContext, String?)?
      dtPartoInduzidoTextControllerValidator;
  DateTime? datePicked;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    dtPartoInduzidoFocusNode?.dispose();
    dtPartoInduzidoTextController?.dispose();
  }
}
