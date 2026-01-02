import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'registrar_cio_widget.dart' show RegistrarCioWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegistrarCioModel extends FlutterFlowModel<RegistrarCioWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Read Document] action in registrarCio widget.
  AnimaisProdutoresRecord? outUidAnimaisAnimal;
  // State field(s) for dtCio widget.
  FocusNode? dtCioFocusNode;
  TextEditingController? dtCioTextController;
  late MaskTextInputFormatter dtCioMask;
  String? Function(BuildContext, String?)? dtCioTextControllerValidator;
  DateTime? datePicked;
  // State field(s) for obs widget.
  FocusNode? obsFocusNode;
  TextEditingController? obsTextController;
  String? Function(BuildContext, String?)? obsTextControllerValidator;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  AcoesRecord? outUidAcaoRealizada;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    dtCioFocusNode?.dispose();
    dtCioTextController?.dispose();

    obsFocusNode?.dispose();
    obsTextController?.dispose();
  }
}
