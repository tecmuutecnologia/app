import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'nova_propriedade_widget.dart' show NovaPropriedadeWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class NovaPropriedadeModel extends FlutterFlowModel<NovaPropriedadeWidget> {
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
      return 'Digite no mínimo 5 caracteres.';
    }
    if (val.length > 150) {
      return 'Máximo 150 caracteres.';
    }

    return null;
  }

  // State field(s) for cpf widget.
  FocusNode? cpfFocusNode;
  TextEditingController? cpfTextController;
  late MaskTextInputFormatter cpfMask;
  String? Function(BuildContext, String?)? cpfTextControllerValidator;
  String? _cpfTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    if (val.length < 11) {
      return 'Digite no mínimo 11 caracteres.';
    }
    if (val.length > 50) {
      return 'Máximo 50 caracteres.';
    }

    return null;
  }

  // State field(s) for email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  String? _emailTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    if (val.length < 5) {
      return 'Digite no mínimo 5 caracteres.';
    }
    if (val.length > 150) {
      return 'Máximo 150 caracteres.';
    }
    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Has to be a valid email address.';
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

    if (val.length < 12) {
      return 'Digite no mínimo 11 caracteres.';
    }
    if (val.length > 50) {
      return 'Máximo 12 caracteres.';
    }

    return null;
  }

  // State field(s) for cidade widget.
  FocusNode? cidadeFocusNode;
  TextEditingController? cidadeTextController;
  String? Function(BuildContext, String?)? cidadeTextControllerValidator;
  String? _cidadeTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    if (val.length < 5) {
      return 'Digite no mínimo 5 caracteres.';
    }
    if (val.length > 50) {
      return 'Máximo 50 caracteres.';
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
      return 'Digite no mínimo 3 caracteres.';
    }
    if (val.length > 150) {
      return 'Máximo 150 caracteres.';
    }

    return null;
  }

  // State field(s) for cep widget.
  FocusNode? cepFocusNode;
  TextEditingController? cepTextController;
  late MaskTextInputFormatter cepMask;
  String? Function(BuildContext, String?)? cepTextControllerValidator;
  String? _cepTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    if (val.length < 8) {
      return 'Digite no mínimo 8 caracteres.';
    }
    if (val.length > 10) {
      return 'Máximo 10 caracteres.';
    }

    return null;
  }

  // State field(s) for complemento widget.
  FocusNode? complementoFocusNode;
  TextEditingController? complementoTextController;
  String? Function(BuildContext, String?)? complementoTextControllerValidator;
  // State field(s) for diasdg widget.
  String? diasdgValue;
  FormFieldController<String>? diasdgValueController;
  // State field(s) for senha widget.
  FocusNode? senhaFocusNode;
  TextEditingController? senhaTextController;
  late bool senhaVisibility;
  String? Function(BuildContext, String?)? senhaTextControllerValidator;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  PersonRecord? outRetornoPersonExist;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  PropriedadesRecord? outUidPersonCpf;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  PersonRecord? uidPersonProdutor;

  @override
  void initState(BuildContext context) {
    nomeTextControllerValidator = _nomeTextControllerValidator;
    cpfTextControllerValidator = _cpfTextControllerValidator;
    emailTextControllerValidator = _emailTextControllerValidator;
    celularTextControllerValidator = _celularTextControllerValidator;
    cidadeTextControllerValidator = _cidadeTextControllerValidator;
    enderecoTextControllerValidator = _enderecoTextControllerValidator;
    cepTextControllerValidator = _cepTextControllerValidator;
    senhaVisibility = false;
  }

  @override
  void dispose() {
    nomeFocusNode?.dispose();
    nomeTextController?.dispose();

    cpfFocusNode?.dispose();
    cpfTextController?.dispose();

    emailFocusNode?.dispose();
    emailTextController?.dispose();

    celularFocusNode?.dispose();
    celularTextController?.dispose();

    cidadeFocusNode?.dispose();
    cidadeTextController?.dispose();

    enderecoFocusNode?.dispose();
    enderecoTextController?.dispose();

    cepFocusNode?.dispose();
    cepTextController?.dispose();

    complementoFocusNode?.dispose();
    complementoTextController?.dispose();

    senhaFocusNode?.dispose();
    senhaTextController?.dispose();
  }
}
