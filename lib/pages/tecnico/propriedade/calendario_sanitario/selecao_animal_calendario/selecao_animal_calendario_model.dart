import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'selecao_animal_calendario_widget.dart'
    show SelecaoAnimalCalendarioWidget;
import 'package:flutter/material.dart';

class SelecaoAnimalCalendarioModel
    extends FlutterFlowModel<SelecaoAnimalCalendarioWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for Checkbox widget.
  bool? checkboxValue1;
  // State field(s) for CheckboxGroupTodos widget.
  FormFieldController<List<String>>? checkboxGroupTodosValueController;
  List<String>? get checkboxGroupTodosValues =>
      checkboxGroupTodosValueController?.value;
  set checkboxGroupTodosValues(List<String>? v) =>
      checkboxGroupTodosValueController?.value = v;

  // State field(s) for Checkbox widget.
  bool? checkboxValue2;
  // State field(s) for CheckboxGroupTerneiros widget.
  FormFieldController<List<String>>? checkboxGroupTerneirosValueController;
  List<String>? get checkboxGroupTerneirosValues =>
      checkboxGroupTerneirosValueController?.value;
  set checkboxGroupTerneirosValues(List<String>? v) =>
      checkboxGroupTerneirosValueController?.value = v;

  // State field(s) for Checkbox widget.
  bool? checkboxValue3;
  // State field(s) for CheckboxGroupNovilhas widget.
  FormFieldController<List<String>>? checkboxGroupNovilhasValueController;
  List<String>? get checkboxGroupNovilhasValues =>
      checkboxGroupNovilhasValueController?.value;
  set checkboxGroupNovilhasValues(List<String>? v) =>
      checkboxGroupNovilhasValueController?.value = v;

  // State field(s) for Checkbox widget.
  bool? checkboxValue4;
  // State field(s) for CheckboxGroupTouros widget.
  FormFieldController<List<String>>? checkboxGroupTourosValueController;
  List<String>? get checkboxGroupTourosValues =>
      checkboxGroupTourosValueController?.value;
  set checkboxGroupTourosValues(List<String>? v) =>
      checkboxGroupTourosValueController?.value = v;

  // State field(s) for Checkbox widget.
  bool? checkboxValue5;
  // State field(s) for CheckboxGroupVacas widget.
  FormFieldController<List<String>>? checkboxGroupVacasValueController;
  List<String>? get checkboxGroupVacasValues =>
      checkboxGroupVacasValueController?.value;
  set checkboxGroupVacasValues(List<String>? v) =>
      checkboxGroupVacasValueController?.value = v;

  // State field(s) for Checkbox widget.
  bool? checkboxValue6;
  // State field(s) for CheckboxGroupTerneiras widget.
  FormFieldController<List<String>>? checkboxGroupTerneirasValueController;
  List<String>? get checkboxGroupTerneirasValues =>
      checkboxGroupTerneirasValueController?.value;
  set checkboxGroupTerneirasValues(List<String>? v) =>
      checkboxGroupTerneirasValueController?.value = v;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
