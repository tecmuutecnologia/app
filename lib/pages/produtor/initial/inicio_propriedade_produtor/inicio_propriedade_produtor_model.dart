import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'inicio_propriedade_produtor_widget.dart'
    show InicioPropriedadeProdutorWidget;
import 'package:flutter/material.dart';

class InicioPropriedadeProdutorModel
    extends FlutterFlowModel<InicioPropriedadeProdutorWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in inicioPropriedadeProdutor widget.
  bool? respostaNet;

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

    /// Dispose query cache managers for this widget.

    clearCacheAnimaisListaCompletaCache();
  }
}
