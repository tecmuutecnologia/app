import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'nova_inseminacao_offline_widget.dart' show NovaInseminacaoOfflineWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class NovaInseminacaoOfflineModel
    extends FlutterFlowModel<NovaInseminacaoOfflineWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for touro widget.
  String? touroValue;
  FormFieldController<String>? touroValueController;
  // State field(s) for dtInseminacao widget.
  FocusNode? dtInseminacaoFocusNode;
  TextEditingController? dtInseminacaoTextController;
  late MaskTextInputFormatter dtInseminacaoMask;
  String? Function(BuildContext, String?)? dtInseminacaoTextControllerValidator;
  DateTime? datePicked;
  // State field(s) for obs widget.
  FocusNode? obsFocusNode;
  TextEditingController? obsTextController;
  String? Function(BuildContext, String?)? obsTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    dtInseminacaoFocusNode?.dispose();
    dtInseminacaoTextController?.dispose();

    obsFocusNode?.dispose();
    obsTextController?.dispose();
  }
}
