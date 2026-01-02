import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'listacompleta_bkp_ultimo_widget.dart' show ListacompletaBkpUltimoWidget;
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ListacompletaBkpUltimoModel
    extends FlutterFlowModel<ListacompletaBkpUltimoWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in listacompletaBkpUltimo widget.
  bool? respostaNet;
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
  // State field(s) for ListView widget.

  PagingController<DocumentSnapshot?, AnimaisProdutoresRecord>?
      listViewPagingController1;
  Query? listViewPagingQuery1;

  // State field(s) for ListView widget.

  PagingController<DocumentSnapshot?, AnimaisProdutoresRecord>?
      listViewPagingController3;
  Query? listViewPagingQuery3;

  // State field(s) for ListView widget.

  PagingController<DocumentSnapshot?, AnimaisProdutoresRecord>?
      listViewPagingController5;
  Query? listViewPagingQuery5;

  // State field(s) for ListView widget.

  PagingController<DocumentSnapshot?, AnimaisProdutoresRecord>?
      listViewPagingController13;
  Query? listViewPagingQuery13;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
    searchListFocusNode?.dispose();
    searchListTextController?.dispose();

    listViewPagingController1?.dispose();

    listViewPagingController3?.dispose();

    listViewPagingController5?.dispose();

    listViewPagingController13?.dispose();
  }

  /// Additional helper methods.
  PagingController<DocumentSnapshot?, AnimaisProdutoresRecord>
      setListViewController1(
    Query query, {
    DocumentReference<Object?>? parent,
  }) {
    listViewPagingController1 ??= _createListViewController1(query, parent);
    if (listViewPagingQuery1 != query) {
      listViewPagingQuery1 = query;
      listViewPagingController1?.refresh();
    }
    return listViewPagingController1!;
  }

  PagingController<DocumentSnapshot?, AnimaisProdutoresRecord>
      _createListViewController1(
    Query query,
    DocumentReference<Object?>? parent,
  ) {
    final controller =
        PagingController<DocumentSnapshot?, AnimaisProdutoresRecord>(
            firstPageKey: null);
    return controller
      ..addPageRequestListener(
        (nextPageMarker) => queryAnimaisProdutoresRecordPage(
          parent: parent,
          queryBuilder: (_) => listViewPagingQuery1 ??= query,
          nextPageMarker: nextPageMarker,
          controller: controller,
          pageSize: 25,
          isStream: false,
        ),
      );
  }

  PagingController<DocumentSnapshot?, AnimaisProdutoresRecord>
      setListViewController3(
    Query query, {
    DocumentReference<Object?>? parent,
  }) {
    listViewPagingController3 ??= _createListViewController3(query, parent);
    if (listViewPagingQuery3 != query) {
      listViewPagingQuery3 = query;
      listViewPagingController3?.refresh();
    }
    return listViewPagingController3!;
  }

  PagingController<DocumentSnapshot?, AnimaisProdutoresRecord>
      _createListViewController3(
    Query query,
    DocumentReference<Object?>? parent,
  ) {
    final controller =
        PagingController<DocumentSnapshot?, AnimaisProdutoresRecord>(
            firstPageKey: null);
    return controller
      ..addPageRequestListener(
        (nextPageMarker) => queryAnimaisProdutoresRecordPage(
          parent: parent,
          queryBuilder: (_) => listViewPagingQuery3 ??= query,
          nextPageMarker: nextPageMarker,
          controller: controller,
          pageSize: 25,
          isStream: false,
        ),
      );
  }

  PagingController<DocumentSnapshot?, AnimaisProdutoresRecord>
      setListViewController5(
    Query query, {
    DocumentReference<Object?>? parent,
  }) {
    listViewPagingController5 ??= _createListViewController5(query, parent);
    if (listViewPagingQuery5 != query) {
      listViewPagingQuery5 = query;
      listViewPagingController5?.refresh();
    }
    return listViewPagingController5!;
  }

  PagingController<DocumentSnapshot?, AnimaisProdutoresRecord>
      _createListViewController5(
    Query query,
    DocumentReference<Object?>? parent,
  ) {
    final controller =
        PagingController<DocumentSnapshot?, AnimaisProdutoresRecord>(
            firstPageKey: null);
    return controller
      ..addPageRequestListener(
        (nextPageMarker) => queryAnimaisProdutoresRecordPage(
          parent: parent,
          queryBuilder: (_) => listViewPagingQuery5 ??= query,
          nextPageMarker: nextPageMarker,
          controller: controller,
          pageSize: 25,
          isStream: false,
        ),
      );
  }

  PagingController<DocumentSnapshot?, AnimaisProdutoresRecord>
      setListViewController13(
    Query query, {
    DocumentReference<Object?>? parent,
  }) {
    listViewPagingController13 ??= _createListViewController13(query, parent);
    if (listViewPagingQuery13 != query) {
      listViewPagingQuery13 = query;
      listViewPagingController13?.refresh();
    }
    return listViewPagingController13!;
  }

  PagingController<DocumentSnapshot?, AnimaisProdutoresRecord>
      _createListViewController13(
    Query query,
    DocumentReference<Object?>? parent,
  ) {
    final controller =
        PagingController<DocumentSnapshot?, AnimaisProdutoresRecord>(
            firstPageKey: null);
    return controller
      ..addPageRequestListener(
        (nextPageMarker) => queryAnimaisProdutoresRecordPage(
          parent: parent,
          queryBuilder: (_) => listViewPagingQuery13 ??= query,
          nextPageMarker: nextPageMarker,
          controller: controller,
          pageSize: 25,
          isStream: false,
        ),
      );
  }
}
