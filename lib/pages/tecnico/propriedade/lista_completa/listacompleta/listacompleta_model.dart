import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'listacompleta_widget.dart' show ListacompletaWidget;
import 'package:flutter/material.dart';

class ListacompletaModel extends FlutterFlowModel<ListacompletaWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in listacompleta widget.
  bool? respostaNet;
  // State field(s) for searchList widget.
  FocusNode? searchListFocusNode;
  TextEditingController? searchListTextController;
  String? Function(BuildContext, String?)? searchListTextControllerValidator;

  /// Query cache managers for this widget.

  final _cacheAnimaisListaCompletaManager =
      StreamRequestManager<List<AnimaisProdutoresRecord>>();
  Stream<List<AnimaisProdutoresRecord>> cacheAnimaisListaCompleta({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<AnimaisProdutoresRecord>> Function() requestFn,
  }) =>
      _cacheAnimaisListaCompletaManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearCacheAnimaisListaCompletaCache() =>
      _cacheAnimaisListaCompletaManager.clear();
  void clearCacheAnimaisListaCompletaCacheKey(String? uniqueKey) =>
      _cacheAnimaisListaCompletaManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
    searchListFocusNode?.dispose();
    searchListTextController?.dispose();

    /// Dispose query cache managers for this widget.

    clearCacheAnimaisListaCompletaCache();
  }
}
