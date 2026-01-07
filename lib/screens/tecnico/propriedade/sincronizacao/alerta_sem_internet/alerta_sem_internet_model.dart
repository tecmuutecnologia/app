import '/backend/backend.dart';
import '/components/ui/flutter_flow_util.dart';
import '/utils/instant_timer.dart';
import 'alerta_sem_internet_widget.dart' show AlertaSemInternetWidget;
import 'package:flutter/material.dart';

class AlertaSemInternetModel extends FlutterFlowModel<AlertaSemInternetWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  TecnicoRecord? outUidTecnico;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  List<AnimaisProdutoresRecord>? outListAnimaisTecnico;
  InstantTimer? instantTimer;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
  }
}
