import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'diagnosticogestacao_modo1_off_widget.dart'
    show DiagnosticogestacaoModo1OffWidget;
import 'package:flutter/material.dart';

class DiagnosticogestacaoModo1OffModel
    extends FlutterFlowModel<DiagnosticogestacaoModo1OffWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in diagnosticogestacaoModo1Off widget.
  bool? respostaNet;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
  }
}
