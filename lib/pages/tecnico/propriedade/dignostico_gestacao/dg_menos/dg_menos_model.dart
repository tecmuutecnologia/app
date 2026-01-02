import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dg_menos_widget.dart' show DgMenosWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DgMenosModel extends FlutterFlowModel<DgMenosWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Read Document] action in dgMenos widget.
  AnimaisProdutoresRecord? outUidAnimaisAnimal;
  // State field(s) for dtDgMenos widget.
  FocusNode? dtDgMenosFocusNode;
  TextEditingController? dtDgMenosTextController;
  late MaskTextInputFormatter dtDgMenosMask;
  String? Function(BuildContext, String?)? dtDgMenosTextControllerValidator;
  DateTime? datePicked;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  AcoesRecord? outUidAcaoRealizada;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    dtDgMenosFocusNode?.dispose();
    dtDgMenosTextController?.dispose();
  }
}
