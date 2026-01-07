import '/components/ui/flutter_flow_util.dart';
import '/utils/instant_timer.dart';
import '/index.dart';
import 'diagnosticogestacao_widget.dart' show DiagnosticogestacaoWidget;
import 'package:flutter/material.dart';

class DiagnosticogestacaoModel
    extends FlutterFlowModel<DiagnosticogestacaoWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in diagnosticogestacao widget.
  bool? respostaNet = true;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
  }
}
