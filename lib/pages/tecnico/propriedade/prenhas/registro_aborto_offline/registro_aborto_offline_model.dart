import '/flutter_flow/flutter_flow_util.dart';
import 'registro_aborto_offline_widget.dart' show RegistroAbortoOfflineWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegistroAbortoOfflineModel
    extends FlutterFlowModel<RegistroAbortoOfflineWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for dtAborto widget.
  FocusNode? dtAbortoFocusNode;
  TextEditingController? dtAbortoTextController;
  late MaskTextInputFormatter dtAbortoMask;
  String? Function(BuildContext, String?)? dtAbortoTextControllerValidator;
  DateTime? datePicked;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    dtAbortoFocusNode?.dispose();
    dtAbortoTextController?.dispose();
  }
}
