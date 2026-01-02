import '/flutter_flow/flutter_flow_util.dart';
import 'dg_mais_offline_widget.dart' show DgMaisOfflineWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DgMaisOfflineModel extends FlutterFlowModel<DgMaisOfflineWidget> {
  ///  State fields for stateful widgets in this component.

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
