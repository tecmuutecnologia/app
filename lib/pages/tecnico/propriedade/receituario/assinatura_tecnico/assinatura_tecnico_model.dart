import '/flutter_flow/flutter_flow_util.dart';
import 'assinatura_tecnico_widget.dart' show AssinaturaTecnicoWidget;
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class AssinaturaTecnicoModel extends FlutterFlowModel<AssinaturaTecnicoWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for assTecnico widget.
  SignatureController? assTecnicoController;
  String uploadedSignatureUrl = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    assTecnicoController?.dispose();
  }
}
