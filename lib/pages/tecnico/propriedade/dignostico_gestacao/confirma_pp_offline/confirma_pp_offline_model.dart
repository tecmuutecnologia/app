import '/flutter_flow/flutter_flow_util.dart';
import 'confirma_pp_offline_widget.dart' show ConfirmaPpOfflineWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ConfirmaPpOfflineModel extends FlutterFlowModel<ConfirmaPpOfflineWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for dtPP widget.
  FocusNode? dtPPFocusNode;
  TextEditingController? dtPPTextController;
  late MaskTextInputFormatter dtPPMask;
  String? Function(BuildContext, String?)? dtPPTextControllerValidator;
  DateTime? datePicked;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    dtPPFocusNode?.dispose();
    dtPPTextController?.dispose();
  }
}
