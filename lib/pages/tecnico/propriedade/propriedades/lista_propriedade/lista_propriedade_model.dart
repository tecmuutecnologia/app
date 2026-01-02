import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'lista_propriedade_widget.dart' show ListaPropriedadeWidget;
import 'package:flutter/material.dart';

class ListaPropriedadeModel extends FlutterFlowModel<ListaPropriedadeWidget> {
  late TextEditingController searchController;

  @override
  void initState(BuildContext context) {
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
  }
}
