import '/flutter_flow/flutter_flow_util.dart';
import 'registrar_secagem_existente_offline_widget.dart'
    show RegistrarSecagemExistenteOfflineWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegistrarSecagemExistenteOfflineModel
    extends FlutterFlowModel<RegistrarSecagemExistenteOfflineWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for dtSecagem widget.
  FocusNode? dtSecagemFocusNode;
  TextEditingController? dtSecagemTextController;
  late MaskTextInputFormatter dtSecagemMask;
  String? Function(BuildContext, String?)? dtSecagemTextControllerValidator;
  DateTime? datePicked;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    dtSecagemFocusNode?.dispose();
    dtSecagemTextController?.dispose();
  }
}
