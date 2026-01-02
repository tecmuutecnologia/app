import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'lista_inseminacoes_bkp_dez_widget.dart'
    show ListaInseminacoesBkpDezWidget;
import 'package:flutter/material.dart';

class ListaInseminacoesBkpDezModel
    extends FlutterFlowModel<ListaInseminacoesBkpDezWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in listaInseminacoesBkpDez widget.
  bool? respostaNet;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
  }
}
