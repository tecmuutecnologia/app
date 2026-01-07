import '/backend/backend.dart';
import '/components/ui/flutter_flow_util.dart';
import '/utils/instant_timer.dart';
import '/utils/request_manager.dart';

import '/index.dart';
import 'lista_animais_widget.dart' show ListaAnimaisWidget;
import 'package:flutter/material.dart';

class ListaAnimaisModel extends FlutterFlowModel<ListaAnimaisWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in listaAnimais widget.
  bool? respostaNet;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for searchList_bezerras widget.
  FocusNode? searchListBezerrasFocusNode;
  TextEditingController? searchListBezerrasTextController;
  String? Function(BuildContext, String?)?
      searchListBezerrasTextControllerValidator;
  // State field(s) for searchList_bezerros widget.
  FocusNode? searchListBezerrosFocusNode;
  TextEditingController? searchListBezerrosTextController;
  String? Function(BuildContext, String?)?
      searchListBezerrosTextControllerValidator;
  // State field(s) for searchList_novilhas widget.
  FocusNode? searchListNovilhasFocusNode;
  TextEditingController? searchListNovilhasTextController;
  String? Function(BuildContext, String?)?
      searchListNovilhasTextControllerValidator;
  // State field(s) for searchList_semens widget.
  FocusNode? searchListSemensFocusNode;
  TextEditingController? searchListSemensTextController;
  String? Function(BuildContext, String?)?
      searchListSemensTextControllerValidator;
  // State field(s) for searchList_Touros widget.
  FocusNode? searchListTourosFocusNode;
  TextEditingController? searchListTourosTextController;
  String? Function(BuildContext, String?)?
      searchListTourosTextControllerValidator;
  // State field(s) for searchList_vacas widget.
  FocusNode? searchListVacasFocusNode;
  TextEditingController? searchListVacasTextController;
  String? Function(BuildContext, String?)?
      searchListVacasTextControllerValidator;

  /// Query cache managers for this widget.

  final _bezerrasAnimaisProdutorManager =
      StreamRequestManager<List<AnimaisProdutoresRecord>>();
  Stream<List<AnimaisProdutoresRecord>> bezerrasAnimaisProdutor({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<AnimaisProdutoresRecord>> Function() requestFn,
  }) =>
      _bezerrasAnimaisProdutorManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearBezerrasAnimaisProdutorCache() =>
      _bezerrasAnimaisProdutorManager.clear();
  void clearBezerrasAnimaisProdutorCacheKey(String? uniqueKey) =>
      _bezerrasAnimaisProdutorManager.clearRequest(uniqueKey);

  final _bezerrosAnimaisProdutorManager =
      StreamRequestManager<List<AnimaisProdutoresRecord>>();
  Stream<List<AnimaisProdutoresRecord>> bezerrosAnimaisProdutor({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<AnimaisProdutoresRecord>> Function() requestFn,
  }) =>
      _bezerrosAnimaisProdutorManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearBezerrosAnimaisProdutorCache() =>
      _bezerrosAnimaisProdutorManager.clear();
  void clearBezerrosAnimaisProdutorCacheKey(String? uniqueKey) =>
      _bezerrosAnimaisProdutorManager.clearRequest(uniqueKey);

  final _novilhasAnimaisProdutorManager =
      StreamRequestManager<List<AnimaisProdutoresRecord>>();
  Stream<List<AnimaisProdutoresRecord>> novilhasAnimaisProdutor({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<AnimaisProdutoresRecord>> Function() requestFn,
  }) =>
      _novilhasAnimaisProdutorManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearNovilhasAnimaisProdutorCache() =>
      _novilhasAnimaisProdutorManager.clear();
  void clearNovilhasAnimaisProdutorCacheKey(String? uniqueKey) =>
      _novilhasAnimaisProdutorManager.clearRequest(uniqueKey);

  final _semensAnimaisProdutorManager =
      StreamRequestManager<List<AnimaisProdutoresRecord>>();
  Stream<List<AnimaisProdutoresRecord>> semensAnimaisProdutor({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<AnimaisProdutoresRecord>> Function() requestFn,
  }) =>
      _semensAnimaisProdutorManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearSemensAnimaisProdutorCache() =>
      _semensAnimaisProdutorManager.clear();
  void clearSemensAnimaisProdutorCacheKey(String? uniqueKey) =>
      _semensAnimaisProdutorManager.clearRequest(uniqueKey);

  final _tourosAnimaisProdutorManager =
      StreamRequestManager<List<AnimaisProdutoresRecord>>();
  Stream<List<AnimaisProdutoresRecord>> tourosAnimaisProdutor({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<AnimaisProdutoresRecord>> Function() requestFn,
  }) =>
      _tourosAnimaisProdutorManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearTourosAnimaisProdutorCache() =>
      _tourosAnimaisProdutorManager.clear();
  void clearTourosAnimaisProdutorCacheKey(String? uniqueKey) =>
      _tourosAnimaisProdutorManager.clearRequest(uniqueKey);

  final _vacasAnimaisProdutorManager =
      StreamRequestManager<List<AnimaisProdutoresRecord>>();
  Stream<List<AnimaisProdutoresRecord>> vacasAnimaisProdutor({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<AnimaisProdutoresRecord>> Function() requestFn,
  }) =>
      _vacasAnimaisProdutorManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearVacasAnimaisProdutorCache() => _vacasAnimaisProdutorManager.clear();
  void clearVacasAnimaisProdutorCacheKey(String? uniqueKey) =>
      _vacasAnimaisProdutorManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
    tabBarController?.dispose();
    searchListBezerrasFocusNode?.dispose();
    searchListBezerrasTextController?.dispose();

    searchListBezerrosFocusNode?.dispose();
    searchListBezerrosTextController?.dispose();

    searchListNovilhasFocusNode?.dispose();
    searchListNovilhasTextController?.dispose();

    searchListSemensFocusNode?.dispose();
    searchListSemensTextController?.dispose();

    searchListTourosFocusNode?.dispose();
    searchListTourosTextController?.dispose();

    searchListVacasFocusNode?.dispose();
    searchListVacasTextController?.dispose();

    /// Dispose query cache managers for this widget.

    clearBezerrasAnimaisProdutorCache();

    clearBezerrosAnimaisProdutorCache();

    clearNovilhasAnimaisProdutorCache();

    clearSemensAnimaisProdutorCache();

    clearTourosAnimaisProdutorCache();

    clearVacasAnimaisProdutorCache();
  }
}
