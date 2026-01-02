import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'animais_prenhas_bkp_recente_widget.dart'
    show AnimaisPrenhasBkpRecenteWidget;
import 'package:flutter/material.dart';

class AnimaisPrenhasBkpRecenteModel
    extends FlutterFlowModel<AnimaisPrenhasBkpRecenteWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in animaisPrenhasBkpRecente widget.
  bool? respostaNet;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
  }
}
