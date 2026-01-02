import '/flutter_flow/flutter_flow_util.dart';
import 'registrar_pre_parto_existente_offline_widget.dart'
    show RegistrarPrePartoExistenteOfflineWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegistrarPrePartoExistenteOfflineModel
    extends FlutterFlowModel<RegistrarPrePartoExistenteOfflineWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for dtPreParto widget.
  FocusNode? dtPrePartoFocusNode;
  TextEditingController? dtPrePartoTextController;
  late MaskTextInputFormatter dtPrePartoMask;
  String? Function(BuildContext, String?)? dtPrePartoTextControllerValidator;
  DateTime? datePicked;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    dtPrePartoFocusNode?.dispose();
    dtPrePartoTextController?.dispose();
  }
}
