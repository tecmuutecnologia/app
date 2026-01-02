import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'lista_animais_tratamentos_widget.dart'
    show ListaAnimaisTratamentosWidget;
import 'package:flutter/material.dart';

class ListaAnimaisTratamentosModel
    extends FlutterFlowModel<ListaAnimaisTratamentosWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for tratamentoRecomendacao widget.
  FocusNode? tratamentoRecomendacaoFocusNode;
  TextEditingController? tratamentoRecomendacaoTextController;
  String? Function(BuildContext, String?)?
      tratamentoRecomendacaoTextControllerValidator;
  // Stores action output result for [Firestore Query - Query a collection] action in tratamentoRecomendacao widget.
  RecomendacoesRecord? outUidRecomendacaoObs;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tratamentoRecomendacaoFocusNode?.dispose();
    tratamentoRecomendacaoTextController?.dispose();
  }
}
