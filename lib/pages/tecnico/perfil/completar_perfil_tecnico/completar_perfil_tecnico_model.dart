import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'completar_perfil_tecnico_widget.dart' show CompletarPerfilTecnicoWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CompletarPerfilTecnicoModel
    extends FlutterFlowModel<CompletarPerfilTecnicoWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for nome widget.
  FocusNode? nomeFocusNode;
  TextEditingController? nomeTextController;
  String? Function(BuildContext, String?)? nomeTextControllerValidator;
  String? _nomeTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    if (val.length < 5) {
      return 'Mínimo 5 caracteres.';
    }

    return null;
  }

  // State field(s) for empresa widget.
  FocusNode? empresaFocusNode;
  TextEditingController? empresaTextController;
  String? Function(BuildContext, String?)? empresaTextControllerValidator;
  // State field(s) for cpf widget.
  FocusNode? cpfFocusNode;
  TextEditingController? cpfTextController;
  late MaskTextInputFormatter cpfMask;
  String? Function(BuildContext, String?)? cpfTextControllerValidator;
  String? _cpfTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    if (val.length < 14) {
      return 'Mínimo 14 caracteres.';
    }

    return null;
  }

  // State field(s) for dtnascimento widget.
  FocusNode? dtnascimentoFocusNode;
  TextEditingController? dtnascimentoTextController;
  late MaskTextInputFormatter dtnascimentoMask;
  String? Function(BuildContext, String?)? dtnascimentoTextControllerValidator;
  String? _dtnascimentoTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    if (val.length < 10) {
      return 'Mínimo 10 caracteres.';
    }

    return null;
  }

  // State field(s) for celular widget.
  FocusNode? celularFocusNode;
  TextEditingController? celularTextController;
  late MaskTextInputFormatter celularMask;
  String? Function(BuildContext, String?)? celularTextControllerValidator;
  String? _celularTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    if (val.length < 15) {
      return 'Mínimo 15 caracteres.';
    }

    return null;
  }

  // State field(s) for cidadeuf widget.
  FocusNode? cidadeufFocusNode;
  TextEditingController? cidadeufTextController;
  String? Function(BuildContext, String?)? cidadeufTextControllerValidator;
  String? _cidadeufTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    if (val.length < 10) {
      return 'Mínimo 10 caracteres.';
    }

    return null;
  }

  // State field(s) for endereco widget.
  FocusNode? enderecoFocusNode;
  TextEditingController? enderecoTextController;
  String? Function(BuildContext, String?)? enderecoTextControllerValidator;
  String? _enderecoTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    if (val.length < 3) {
      return 'Mínimo 3 caracteres.';
    }

    return null;
  }

  // State field(s) for bairro widget.
  FocusNode? bairroFocusNode;
  TextEditingController? bairroTextController;
  String? Function(BuildContext, String?)? bairroTextControllerValidator;
  String? _bairroTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    if (val.length < 3) {
      return 'Mínimo 3 caracteres.';
    }

    return null;
  }

  // Stores action output result for [Firestore Query - Query a collection] action in btnAvancar widget.
  PersonRecord? outUidPersonExists;
  // Stores action output result for [Backend Call - Create Document] action in btnAvancar widget.
  TecnicoRecord? outUidTecnico;
  // Stores action output result for [Backend Call - Create Document] action in btnAvancar widget.
  AssinaturaTecnicoRecord? outAssinaturaTecnico;

  @override
  void initState(BuildContext context) {
    nomeTextControllerValidator = _nomeTextControllerValidator;
    cpfTextControllerValidator = _cpfTextControllerValidator;
    dtnascimentoTextControllerValidator = _dtnascimentoTextControllerValidator;
    celularTextControllerValidator = _celularTextControllerValidator;
    cidadeufTextControllerValidator = _cidadeufTextControllerValidator;
    enderecoTextControllerValidator = _enderecoTextControllerValidator;
    bairroTextControllerValidator = _bairroTextControllerValidator;
  }

  @override
  void dispose() {
    nomeFocusNode?.dispose();
    nomeTextController?.dispose();

    empresaFocusNode?.dispose();
    empresaTextController?.dispose();

    cpfFocusNode?.dispose();
    cpfTextController?.dispose();

    dtnascimentoFocusNode?.dispose();
    dtnascimentoTextController?.dispose();

    celularFocusNode?.dispose();
    celularTextController?.dispose();

    cidadeufFocusNode?.dispose();
    cidadeufTextController?.dispose();

    enderecoFocusNode?.dispose();
    enderecoTextController?.dispose();

    bairroFocusNode?.dispose();
    bairroTextController?.dispose();
  }
}
