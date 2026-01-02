import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'editar_relatorio_financeiro_widget.dart'
    show EditarRelatorioFinanceiroWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditarRelatorioFinanceiroModel
    extends FlutterFlowModel<EditarRelatorioFinanceiroWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for dtRelatorio widget.
  FocusNode? dtRelatorioFocusNode;
  TextEditingController? dtRelatorioTextController;
  late MaskTextInputFormatter dtRelatorioMask;
  String? Function(BuildContext, String?)? dtRelatorioTextControllerValidator;
  String? _dtRelatorioTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    return null;
  }

  // State field(s) for vacasLactacao widget.
  FocusNode? vacasLactacaoFocusNode;
  TextEditingController? vacasLactacaoTextController;
  String? Function(BuildContext, String?)? vacasLactacaoTextControllerValidator;
  String? _vacasLactacaoTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    return null;
  }

  // State field(s) for litrosLeiteDia widget.
  FocusNode? litrosLeiteDiaFocusNode;
  TextEditingController? litrosLeiteDiaTextController;
  String? Function(BuildContext, String?)?
      litrosLeiteDiaTextControllerValidator;
  String? _litrosLeiteDiaTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    return null;
  }

  // State field(s) for litrosLeiteMes widget.
  FocusNode? litrosLeiteMesFocusNode;
  TextEditingController? litrosLeiteMesTextController;
  String? Function(BuildContext, String?)?
      litrosLeiteMesTextControllerValidator;
  String? _litrosLeiteMesTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    return null;
  }

  // State field(s) for totalRecebido widget.
  FocusNode? totalRecebidoFocusNode;
  TextEditingController? totalRecebidoTextController;
  String? Function(BuildContext, String?)? totalRecebidoTextControllerValidator;
  String? _totalRecebidoTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    return null;
  }

  // State field(s) for faturamentoLiquido widget.
  FocusNode? faturamentoLiquidoFocusNode;
  TextEditingController? faturamentoLiquidoTextController;
  String? Function(BuildContext, String?)?
      faturamentoLiquidoTextControllerValidator;
  String? _faturamentoLiquidoTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    return null;
  }

  // State field(s) for mediaProducaoVaca widget.
  FocusNode? mediaProducaoVacaFocusNode;
  TextEditingController? mediaProducaoVacaTextController;
  String? Function(BuildContext, String?)?
      mediaProducaoVacaTextControllerValidator;
  String? _mediaProducaoVacaTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    return null;
  }

  // State field(s) for custoLitroLeite widget.
  FocusNode? custoLitroLeiteFocusNode;
  TextEditingController? custoLitroLeiteTextController;
  String? Function(BuildContext, String?)?
      custoLitroLeiteTextControllerValidator;
  String? _custoLitroLeiteTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    dtRelatorioTextControllerValidator = _dtRelatorioTextControllerValidator;
    vacasLactacaoTextControllerValidator =
        _vacasLactacaoTextControllerValidator;
    litrosLeiteDiaTextControllerValidator =
        _litrosLeiteDiaTextControllerValidator;
    litrosLeiteMesTextControllerValidator =
        _litrosLeiteMesTextControllerValidator;
    totalRecebidoTextControllerValidator =
        _totalRecebidoTextControllerValidator;
    faturamentoLiquidoTextControllerValidator =
        _faturamentoLiquidoTextControllerValidator;
    mediaProducaoVacaTextControllerValidator =
        _mediaProducaoVacaTextControllerValidator;
    custoLitroLeiteTextControllerValidator =
        _custoLitroLeiteTextControllerValidator;
  }

  @override
  void dispose() {
    dtRelatorioFocusNode?.dispose();
    dtRelatorioTextController?.dispose();

    vacasLactacaoFocusNode?.dispose();
    vacasLactacaoTextController?.dispose();

    litrosLeiteDiaFocusNode?.dispose();
    litrosLeiteDiaTextController?.dispose();

    litrosLeiteMesFocusNode?.dispose();
    litrosLeiteMesTextController?.dispose();

    totalRecebidoFocusNode?.dispose();
    totalRecebidoTextController?.dispose();

    faturamentoLiquidoFocusNode?.dispose();
    faturamentoLiquidoTextController?.dispose();

    mediaProducaoVacaFocusNode?.dispose();
    mediaProducaoVacaTextController?.dispose();

    custoLitroLeiteFocusNode?.dispose();
    custoLitroLeiteTextController?.dispose();
  }
}
