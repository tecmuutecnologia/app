import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'registrar_secagem_widget.dart' show RegistrarSecagemWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegistrarSecagemModel extends FlutterFlowModel<RegistrarSecagemWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Read Document] action in registrarSecagem widget.
  AnimaisProdutoresRecord? outUidAnimaisAnimal;
  // State field(s) for dtSecagem widget.
  FocusNode? dtSecagemFocusNode;
  TextEditingController? dtSecagemTextController;
  late MaskTextInputFormatter dtSecagemMask;
  String? Function(BuildContext, String?)? dtSecagemTextControllerValidator;
  DateTime? datePicked;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  AcoesRecord? outUidAcaoRealizada;
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
    dtSecagemFocusNode?.dispose();
    dtSecagemTextController?.dispose();
  }
}
