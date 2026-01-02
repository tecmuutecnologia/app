import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'registro_aborto_widget.dart' show RegistroAbortoWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegistroAbortoModel extends FlutterFlowModel<RegistroAbortoWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Read Document] action in registroAborto widget.
  AnimaisProdutoresRecord? outUidAnimaisAnimal;
  // State field(s) for dtAborto widget.
  FocusNode? dtAbortoFocusNode;
  TextEditingController? dtAbortoTextController;
  late MaskTextInputFormatter dtAbortoMask;
  String? Function(BuildContext, String?)? dtAbortoTextControllerValidator;
  DateTime? datePicked;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  AcoesRecord? outUidAcaoRealizada;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    dtAbortoFocusNode?.dispose();
    dtAbortoTextController?.dispose();
  }
}
