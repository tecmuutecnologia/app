import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'acoes_falhadas_widget.dart' show AcoesFalhadasWidget;
import 'package:flutter/material.dart';

class AcoesFalhadasModel extends FlutterFlowModel<AcoesFalhadasWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in acoesFalhadas widget.
  bool? respostaNet;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
  }
}
