import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'registrar_pre_parto_widget.dart' show RegistrarPrePartoWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegistrarPrePartoModel extends FlutterFlowModel<RegistrarPrePartoWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for dtPreParto widget.
  FocusNode? dtPrePartoFocusNode;
  TextEditingController? dtPrePartoTextController;
  late MaskTextInputFormatter dtPrePartoMask;
  String? Function(BuildContext, String?)? dtPrePartoTextControllerValidator;
  DateTime? datePicked;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  ResumoDaVisitaRecord? outUidResumoDaVisita;
  // Stores action output result for [Backend Call - Read Document] action in Button widget.
  AnimaisProdutoresRecord? uidAnimalRecebeAcao1;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  RecomendacoesRecord? outUidRecomendacoes;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  ResumoDaVisitaRecord? outNewUidResumoDaVisita;
  // Stores action output result for [Backend Call - Read Document] action in Button widget.
  AnimaisProdutoresRecord? uidAnimalRecebeAcao;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  RecomendacoesRecord? outUidRecomendacoes2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    dtPrePartoFocusNode?.dispose();
    dtPrePartoTextController?.dispose();
  }
}
