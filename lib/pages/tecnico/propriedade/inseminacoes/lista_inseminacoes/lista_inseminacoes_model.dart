import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'lista_inseminacoes_widget.dart' show ListaInseminacoesWidget;
import 'package:flutter/material.dart';

class ListaInseminacoesModel extends FlutterFlowModel<ListaInseminacoesWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in listaInseminacoes widget.
  bool? respostaNet;
  // State field(s) for searchList widget.
  FocusNode? searchListFocusNode;
  TextEditingController? searchListTextController;
  String? Function(BuildContext, String?)? searchListTextControllerValidator;

  /// Query cache managers for this widget.

  final _allAnimaisInseminacoesManager =
      StreamRequestManager<List<AnimaisProdutoresRecord>>();
  Stream<List<AnimaisProdutoresRecord>> allAnimaisInseminacoes({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<AnimaisProdutoresRecord>> Function() requestFn,
  }) =>
      _allAnimaisInseminacoesManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearAllAnimaisInseminacoesCache() =>
      _allAnimaisInseminacoesManager.clear();
  void clearAllAnimaisInseminacoesCacheKey(String? uniqueKey) =>
      _allAnimaisInseminacoesManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
    searchListFocusNode?.dispose();
    searchListTextController?.dispose();

    /// Dispose query cache managers for this widget.

    clearAllAnimaisInseminacoesCache();
  }
}
