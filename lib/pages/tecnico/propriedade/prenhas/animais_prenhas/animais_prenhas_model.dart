import '/core/ui/flutter_flow_util.dart';
import '/core/ui/instant_timer.dart';
import '/index.dart';
import 'animais_prenhas_widget.dart' show AnimaisPrenhasWidget;
import 'package:flutter/material.dart';

class AnimaisPrenhasModel extends FlutterFlowModel<AnimaisPrenhasWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in animaisPrenhas widget.
  bool? respostaNet = true;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
  }
}
