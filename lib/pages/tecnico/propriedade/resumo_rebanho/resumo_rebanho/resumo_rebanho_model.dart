import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'resumo_rebanho_widget.dart' show ResumoRebanhoWidget;
import 'package:flutter/material.dart';

class ResumoRebanhoModel extends FlutterFlowModel<ResumoRebanhoWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in resumoRebanho widget.
  bool? respostaNet;
  // State field(s) for categoriaAnimal widget.
  List<String>? categoriaAnimalValue;
  FormFieldController<List<String>>? categoriaAnimalValueController;
  // State field(s) for statusAnimal widget.
  List<String>? statusAnimalValue;
  FormFieldController<List<String>>? statusAnimalValueController;
  // State field(s) for check_ultimoparto widget.
  bool? checkUltimopartoValue;
  // State field(s) for check_ultimaia widget.
  bool? checkUltimaiaValue;
  // State field(s) for check_del widget.
  bool? checkDelValue;
  // State field(s) for check_touro widget.
  bool? checkTouroValue;
  // State field(s) for check_secagem widget.
  bool? checkSecagemValue;
  // State field(s) for check_preparto widget.
  bool? checkPrepartoValue;
  // State field(s) for check_dias_aberto widget.
  bool? checkDiasAbertoValue;
  // State field(s) for check_intervalo_entrePartos widget.
  bool? checkIntervaloEntrePartosValue;
  // State field(s) for check_paricao widget.
  bool? checkParicaoValue;
  // Stores action output result for [Backend Call - Read Document] action in btnGerarRelatorio widget.
  PropriedadesRecord? outUidPropriedade;
  // Stores action output result for [Backend Call - Read Document] action in btnGerarRelatorio widget.
  TecnicoRecord? outUidTecnico;
  // Stores action output result for [Firestore Query - Query a collection] action in btnGerarRelatorio widget.
  PersonRecord? outUidPersonTecnico;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
  }
}
