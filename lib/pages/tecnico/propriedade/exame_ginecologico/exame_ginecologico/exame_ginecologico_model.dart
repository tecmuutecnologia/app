import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'exame_ginecologico_widget.dart' show ExameGinecologicoWidget;
import 'package:flutter/material.dart';

class ExameGinecologicoModel extends FlutterFlowModel<ExameGinecologicoWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in exameGinecologico widget.
  bool? respostaNet;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
  }
}
