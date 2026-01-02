import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'editar_animal_widget.dart' show EditarAnimalWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditarAnimalModel extends FlutterFlowModel<EditarAnimalWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in editarAnimal widget.
  bool? respostaNet;
  // State field(s) for nome widget.
  FocusNode? nomeFocusNode;
  TextEditingController? nomeTextController;
  String? Function(BuildContext, String?)? nomeTextControllerValidator;
  // State field(s) for brinco widget.
  FocusNode? brincoFocusNode;
  TextEditingController? brincoTextController;
  String? Function(BuildContext, String?)? brincoTextControllerValidator;
  // State field(s) for raca widget.
  String? racaValue;
  FormFieldController<String>? racaValueController;
  // State field(s) for grupo widget.
  String? grupoValue;
  FormFieldController<String>? grupoValueController;
  // State field(s) for Switch widget.
  bool? switchValue;
  // State field(s) for peso widget.
  FocusNode? pesoFocusNode;
  TextEditingController? pesoTextController;
  String? Function(BuildContext, String?)? pesoTextControllerValidator;
  // State field(s) for dataNascimento widget.
  FocusNode? dataNascimentoFocusNode;
  TextEditingController? dataNascimentoTextController;
  late MaskTextInputFormatter dataNascimentoMask;
  String? Function(BuildContext, String?)?
      dataNascimentoTextControllerValidator;
  String? _dataNascimentoTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    return null;
  }

  DateTime? datePicked;
  // State field(s) for touro widget.
  FocusNode? touroFocusNode;
  TextEditingController? touroTextController;
  String? Function(BuildContext, String?)? touroTextControllerValidator;
  // State field(s) for vaca widget.
  FocusNode? vacaFocusNode;
  TextEditingController? vacaTextController;
  String? Function(BuildContext, String?)? vacaTextControllerValidator;

  @override
  void initState(BuildContext context) {
    dataNascimentoTextControllerValidator =
        _dataNascimentoTextControllerValidator;
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    nomeFocusNode?.dispose();
    nomeTextController?.dispose();

    brincoFocusNode?.dispose();
    brincoTextController?.dispose();

    pesoFocusNode?.dispose();
    pesoTextController?.dispose();

    dataNascimentoFocusNode?.dispose();
    dataNascimentoTextController?.dispose();

    touroFocusNode?.dispose();
    touroTextController?.dispose();

    vacaFocusNode?.dispose();
    vacaTextController?.dispose();
  }
}
