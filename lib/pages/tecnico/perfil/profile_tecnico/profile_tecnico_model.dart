import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'profile_tecnico_widget.dart' show ProfileTecnicoWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ProfileTecnicoModel extends FlutterFlowModel<ProfileTecnicoWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for yourName widget.
  FocusNode? yourNameFocusNode;
  TextEditingController? yourNameTextController;
  String? Function(BuildContext, String?)? yourNameTextControllerValidator;
  // State field(s) for empresa widget.
  FocusNode? empresaFocusNode;
  TextEditingController? empresaTextController;
  String? Function(BuildContext, String?)? empresaTextControllerValidator;
  // State field(s) for dt widget.
  FocusNode? dtFocusNode;
  TextEditingController? dtTextController;
  late MaskTextInputFormatter dtMask;
  String? Function(BuildContext, String?)? dtTextControllerValidator;
  // State field(s) for celular widget.
  FocusNode? celularFocusNode;
  TextEditingController? celularTextController;
  late MaskTextInputFormatter celularMask;
  String? Function(BuildContext, String?)? celularTextControllerValidator;
  // State field(s) for endereco widget.
  FocusNode? enderecoFocusNode;
  TextEditingController? enderecoTextController;
  String? Function(BuildContext, String?)? enderecoTextControllerValidator;
  // State field(s) for bairro widget.
  FocusNode? bairroFocusNode;
  TextEditingController? bairroTextController;
  String? Function(BuildContext, String?)? bairroTextControllerValidator;
  // Stores action output result for [Firestore Query - Query a collection] action in Text widget.
  ProdutorRecord? uidProdutor;
  // Stores action output result for [Firestore Query - Query a collection] action in Text widget.
  AssinaturaProdutorRecord? uidAssinaturaProdutor;
  // Stores action output result for [Firestore Query - Query a collection] action in Text widget.
  AssinaturaAtivaProdutorRecord? uidAssinaturaAtivaProdutor;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    yourNameFocusNode?.dispose();
    yourNameTextController?.dispose();

    empresaFocusNode?.dispose();
    empresaTextController?.dispose();

    dtFocusNode?.dispose();
    dtTextController?.dispose();

    celularFocusNode?.dispose();
    celularTextController?.dispose();

    enderecoFocusNode?.dispose();
    enderecoTextController?.dispose();

    bairroFocusNode?.dispose();
    bairroTextController?.dispose();
  }
}
