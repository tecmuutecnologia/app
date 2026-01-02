import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'listacompleta_copy_widget.dart' show ListacompletaCopyWidget;
import 'package:flutter/material.dart';

class ListacompletaCopyModel extends FlutterFlowModel<ListacompletaCopyWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for searchList widget.
  FocusNode? searchListFocusNode;
  TextEditingController? searchListTextController;
  String? Function(BuildContext, String?)? searchListTextControllerValidator;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchListFocusNode?.dispose();
    searchListTextController?.dispose();
  }
}
