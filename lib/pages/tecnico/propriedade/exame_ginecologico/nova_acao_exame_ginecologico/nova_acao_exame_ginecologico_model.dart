import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'nova_acao_exame_ginecologico_widget.dart'
    show NovaAcaoExameGinecologicoWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class NovaAcaoExameGinecologicoModel
    extends FlutterFlowModel<NovaAcaoExameGinecologicoWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for acoesDispo widget.
  String? acoesDispoValue;
  FormFieldController<String>? acoesDispoValueController;
  // State field(s) for dtAcao widget.
  FocusNode? dtAcaoFocusNode;
  TextEditingController? dtAcaoTextController;
  late MaskTextInputFormatter dtAcaoMask;
  String? Function(BuildContext, String?)? dtAcaoTextControllerValidator;
  DateTime? datePicked;
  // State field(s) for obsInfo widget.
  FocusNode? obsInfoFocusNode;
  TextEditingController? obsInfoTextController;
  String? Function(BuildContext, String?)? obsInfoTextControllerValidator;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  AcoesRecord? uidAcaoLancada;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  ResumoDaVisitaRecord? outUidResumoDaVisita;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  RecomendacoesRecord? outUidRecomendacoes;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  ResumoDaVisitaRecord? outNewUidResumoDaVisita;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  RecomendacoesRecord? outUidRecomendacoes2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    dtAcaoFocusNode?.dispose();
    dtAcaoTextController?.dispose();

    obsInfoFocusNode?.dispose();
    obsInfoTextController?.dispose();
  }
}
