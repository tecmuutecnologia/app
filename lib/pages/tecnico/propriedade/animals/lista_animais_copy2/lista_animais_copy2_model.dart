import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'lista_animais_copy2_widget.dart' show ListaAnimaisCopy2Widget;
import 'package:flutter/material.dart';

class ListaAnimaisCopy2Model extends FlutterFlowModel<ListaAnimaisCopy2Widget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in listaAnimaisCopy2 widget.
  bool? respostaNet;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
    tabBarController?.dispose();
  }
}
