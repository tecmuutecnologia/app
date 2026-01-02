import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'nova_inseminacao_backup_widget.dart' show NovaInseminacaoBackupWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class NovaInseminacaoBackupModel
    extends FlutterFlowModel<NovaInseminacaoBackupWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Read Document] action in novaInseminacaoBackup widget.
  AnimaisProdutoresRecord? outUidAnimaisAnimal;
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
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  AcoesRecord? outUidAcaoRealizada;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  AcoesRecord? outUidAcaoRealizada2;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  AcoesRecord? outUidAcaoRealizada3;

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
