import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'confirmar_senha_widget.dart' show ConfirmarSenhaWidget;
import 'package:flutter/material.dart';

class ConfirmarSenhaModel extends FlutterFlowModel<ConfirmarSenhaWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for senhaTemporaria widget.
  FocusNode? senhaTemporariaFocusNode;
  TextEditingController? senhaTemporariaTextController;
  late bool senhaTemporariaVisibility;
  String? Function(BuildContext, String?)?
      senhaTemporariaTextControllerValidator;
  String? _senhaTemporariaTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Senha Temporária is required';
    }

    return null;
  }

  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  TecnicoRecord? outUidTecnicoLogged;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  PropriedadesRecord? propriedadeTecnico;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  PropriedadesRecord? outUidPropriedadeNewCadaster;

  @override
  void initState(BuildContext context) {
    senhaTemporariaVisibility = false;
    senhaTemporariaTextControllerValidator =
        _senhaTemporariaTextControllerValidator;
  }

  @override
  void dispose() {
    senhaTemporariaFocusNode?.dispose();
    senhaTemporariaTextController?.dispose();
  }
}
