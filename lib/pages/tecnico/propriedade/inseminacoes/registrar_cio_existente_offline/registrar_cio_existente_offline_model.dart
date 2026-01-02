import '/flutter_flow/flutter_flow_util.dart';
import 'registrar_cio_existente_offline_widget.dart'
    show RegistrarCioExistenteOfflineWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegistrarCioExistenteOfflineModel
    extends FlutterFlowModel<RegistrarCioExistenteOfflineWidget> {
  ///  State fields for stateful widgets in this component.

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
