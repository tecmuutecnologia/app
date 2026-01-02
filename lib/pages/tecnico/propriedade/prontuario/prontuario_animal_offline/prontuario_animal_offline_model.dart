import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import 'prontuario_animal_offline_widget.dart'
    show ProntuarioAnimalOfflineWidget;
import 'package:flutter/material.dart';

class ProntuarioAnimalOfflineModel
    extends FlutterFlowModel<ProntuarioAnimalOfflineWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in prontuarioAnimalOffline widget.
  bool? respostaNet;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
  }
}
