import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'resumo_visita_atual_widget.dart' show ResumoVisitaAtualWidget;
import 'package:flutter/material.dart';

class ResumoVisitaAtualModel extends FlutterFlowModel<ResumoVisitaAtualWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for obsGeral widget.
  FocusNode? obsGeralFocusNode;
  TextEditingController? obsGeralTextController;
  String? Function(BuildContext, String?)? obsGeralTextControllerValidator;
  // Stores action output result for [Backend Call - Read Document] action in btnSalvarGerarPdf widget.
  PropriedadesRecord? outUidPropriedade2;
  // Stores action output result for [Backend Call - Read Document] action in btnSalvarGerarPdf widget.
  TecnicoRecord? outUidTecnico2;
  // Stores action output result for [Firestore Query - Query a collection] action in btnSalvarGerarPdf widget.
  PersonRecord? outUidPersonTecnico2;
  // Stores action output result for [Backend Call - Read Document] action in btnGerarPdf widget.
  PropriedadesRecord? outUidPropriedade;
  // Stores action output result for [Backend Call - Read Document] action in btnGerarPdf widget.
  TecnicoRecord? outUidTecnico;
  // Stores action output result for [Firestore Query - Query a collection] action in btnGerarPdf widget.
  PersonRecord? outUidPersonTecnico;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    obsGeralFocusNode?.dispose();
    obsGeralTextController?.dispose();
  }
}
