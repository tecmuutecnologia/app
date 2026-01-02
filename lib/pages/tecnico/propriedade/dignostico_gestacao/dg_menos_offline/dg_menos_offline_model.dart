import '/flutter_flow/flutter_flow_util.dart';
import 'dg_menos_offline_widget.dart' show DgMenosOfflineWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DgMenosOfflineModel extends FlutterFlowModel<DgMenosOfflineWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for dtDgMenos widget.
  FocusNode? dtDgMenosFocusNode;
  TextEditingController? dtDgMenosTextController;
  late MaskTextInputFormatter dtDgMenosMask;
  String? Function(BuildContext, String?)? dtDgMenosTextControllerValidator;
  DateTime? datePicked;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    dtDgMenosFocusNode?.dispose();
    dtDgMenosTextController?.dispose();
  }
}
