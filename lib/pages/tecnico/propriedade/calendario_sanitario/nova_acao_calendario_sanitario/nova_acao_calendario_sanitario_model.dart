import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'nova_acao_calendario_sanitario_widget.dart'
    show NovaAcaoCalendarioSanitarioWidget;
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class NovaAcaoCalendarioSanitarioModel
    extends FlutterFlowModel<NovaAcaoCalendarioSanitarioWidget> {
  ///  Local state fields for this component.

  int qtdInicialAnimais = 0;

  int qtdMaxAnimais = 0;

  int qtdInicialAnimais1 = 0;

  int qtdMaxAnimais1 = 0;

  int qtdInicialAnimais2 = 0;

  int qtdMaxAnimais2 = 0;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // State field(s) for tipo widget.
  String? tipoValue;
  FormFieldController<String>? tipoValueController;
  // State field(s) for valoracao widget.
  String? valoracaoValue;
  FormFieldController<String>? valoracaoValueController;
  // State field(s) for dtAcao widget.
  FocusNode? dtAcaoFocusNode;
  TextEditingController? dtAcaoTextController;
  late MaskTextInputFormatter dtAcaoMask;
  String? Function(BuildContext, String?)? dtAcaoTextControllerValidator;
  DateTime? datePicked;
  // State field(s) for obs widget.
  FocusNode? obsFocusNode;
  TextEditingController? obsTextController;
  String? Function(BuildContext, String?)? obsTextControllerValidator;
  // Stores action output result for [Firestore Query - Query a collection] action in btnRegistrar widget.
  AnimaisProdutoresRecord? outPesquisaAnimalSelecionado;
  // Stores action output result for [Firestore Query - Query a collection] action in btnRegistrar widget.
  ResumoDaVisitaRecord? outUidResumoDaVisita;
  // Stores action output result for [Firestore Query - Query a collection] action in btnRegistrar widget.
  AnimaisProdutoresRecord? outPesquisaAnimalSelecionado1;
  // Stores action output result for [Firestore Query - Query a collection] action in btnRegistrar widget.
  RecomendacoesRecord? outUidRecomendacoes;
  // Stores action output result for [Backend Call - Create Document] action in btnRegistrar widget.
  ResumoDaVisitaRecord? outNewUidResumoDaVisita;
  // Stores action output result for [Firestore Query - Query a collection] action in btnRegistrar widget.
  AnimaisProdutoresRecord? outPesquisaAnimalSelecionado2;
  // Stores action output result for [Firestore Query - Query a collection] action in btnRegistrar widget.
  RecomendacoesRecord? outUidRecomendacoes2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    dtAcaoFocusNode?.dispose();
    dtAcaoTextController?.dispose();

    obsFocusNode?.dispose();
    obsTextController?.dispose();
  }
}
