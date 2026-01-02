import '/flutter_flow/flutter_flow_util.dart';
import 'assinatura_produtor_widget.dart' show AssinaturaProdutorWidget;
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class AssinaturaProdutorModel
    extends FlutterFlowModel<AssinaturaProdutorWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for assProdutor widget.
  SignatureController? assProdutorController;
  String uploadedSignatureUrl = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    assProdutorController?.dispose();
  }
}
