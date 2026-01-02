import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'dashboard_tecnico_widget.dart' show DashboardTecnicoWidget;
import 'package:flutter/material.dart';

class DashboardTecnicoModel extends FlutterFlowModel<DashboardTecnicoWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in dashboardTecnico widget.
  bool? respostaNet;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
  }
}
