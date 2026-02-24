import '/flutter_flow/flutter_flow_util.dart';
import 'propriedades_excluidas_widget.dart' show PropriedadesExcluiasWidget;
import 'package:flutter/material.dart';

class PropriedadesExcluiasModel
    extends FlutterFlowModel<PropriedadesExcluiasWidget> {
  ///
  /// State fields for stateful widgets in this page.

  // State field(s) for searchDeletedProperties widget.
  FocusNode? searchFocusNode;
  TextEditingController? searchController;
  String? Function(BuildContext, String?)? searchControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFocusNode?.dispose();
    searchController?.dispose();
  }
}
