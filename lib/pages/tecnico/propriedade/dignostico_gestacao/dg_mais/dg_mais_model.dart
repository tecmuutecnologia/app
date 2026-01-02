import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dg_mais_widget.dart' show DgMaisWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DgMaisModel extends FlutterFlowModel<DgMaisWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Read Document] action in dgMais widget.
  AnimaisProdutoresRecord? outUidAnimaisAnimal;
  // State field(s) for dtDgMais widget.
  FocusNode? dtDgMaisFocusNode;
  TextEditingController? dtDgMaisTextController;
  late MaskTextInputFormatter dtDgMaisMask;
  String? Function(BuildContext, String?)? dtDgMaisTextControllerValidator;
  DateTime? datePicked;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    dtDgMaisFocusNode?.dispose();
    dtDgMaisTextController?.dispose();
  }
}
