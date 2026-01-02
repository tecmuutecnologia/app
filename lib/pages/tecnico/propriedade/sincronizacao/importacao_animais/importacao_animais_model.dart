import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'importacao_animais_widget.dart' show ImportacaoAnimaisWidget;
import 'package:flutter/material.dart';

class ImportacaoAnimaisModel extends FlutterFlowModel<ImportacaoAnimaisWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in importacaoAnimais widget.
  bool? respostaNet;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
  }
}
