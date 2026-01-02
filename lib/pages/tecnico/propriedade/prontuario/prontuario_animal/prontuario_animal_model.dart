import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'prontuario_animal_widget.dart' show ProntuarioAnimalWidget;
import 'package:flutter/material.dart';

class ProntuarioAnimalModel extends FlutterFlowModel<ProntuarioAnimalWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in prontuarioAnimal widget.
  bool? respostaNet;
  // Stores action output result for [Firestore Query - Query a collection] action in Card widget.
  TratamentosRecord? deleteAcaoUidTratamentos;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
  }
}
