import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'confirma_pp_widget.dart' show ConfirmaPpWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ConfirmaPpModel extends FlutterFlowModel<ConfirmaPpWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Read Document] action in confirmaPp widget.
  AnimaisProdutoresRecord? outUidAnimaisAnimal;
  // State field(s) for dtPP widget.
  FocusNode? dtPPFocusNode;
  TextEditingController? dtPPTextController;
  late MaskTextInputFormatter dtPPMask;
  String? Function(BuildContext, String?)? dtPPTextControllerValidator;
  DateTime? datePicked;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  AcoesRecord? outUidAcaoRealizada;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    dtPPFocusNode?.dispose();
    dtPPTextController?.dispose();
  }
}
