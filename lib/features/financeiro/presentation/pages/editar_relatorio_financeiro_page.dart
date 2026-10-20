// ignore_for_file: unnecessary_null_comparison, unused_local_variable

import '/core/ui/cabecalho_tela.dart';
import '/core/ui/painel_lista.dart';
import '/core/ui/secao_formulario.dart';
import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/core/ui/app_card.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/features/financeiro/presentation/widgets/index.dart' as custom_widgets;
import '/core/ui/custom_functions.dart' as functions;
import '/features/financeiro/presentation/pages/relatorio_financeiro_page.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class EditarRelatorioFinanceiroPage extends StatefulWidget {
  const EditarRelatorioFinanceiroPage({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.diasDg,
    required this.financeiroLocalId,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? diasDg;

  /// Id local do ObjectBox. Antes era a `DocumentReference` do Firestore, que
  /// só existe depois do sync — relatório criado offline não podia ser editado.
  final int? financeiroLocalId;

  static String routeName = 'editarRelatorioFinanceiro';
  static String routePath = '/editarRelatorioFinanceiro';

  @override
  State<EditarRelatorioFinanceiroPage> createState() =>
      _EditarRelatorioFinanceiroPageState();
}

class _EditarRelatorioFinanceiroPageState
    extends State<EditarRelatorioFinanceiroPage> {
  final _formKey = GlobalKey<FormState>();
  double _precoRecebidoLitro = 0.0;
  double _despesasNoMes = 0.0;
  FocusNode? _dtRelatorioFocusNode;
  TextEditingController? _dtRelatorioTextController;
  late MaskTextInputFormatter _dtRelatorioMask;
  String? _dtRelatorioTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    return null;
  }

  FocusNode? _vacasLactacaoFocusNode;
  TextEditingController? _vacasLactacaoTextController;
  String? _vacasLactacaoTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    return null;
  }

  FocusNode? _litrosLeiteDiaFocusNode;
  TextEditingController? _litrosLeiteDiaTextController;
  String? _litrosLeiteDiaTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    return null;
  }

  FocusNode? _litrosLeiteMesFocusNode;
  TextEditingController? _litrosLeiteMesTextController;
  String? _litrosLeiteMesTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    return null;
  }

  FocusNode? _totalRecebidoFocusNode;
  TextEditingController? _totalRecebidoTextController;
  String? _totalRecebidoTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    return null;
  }

  FocusNode? _faturamentoLiquidoFocusNode;
  TextEditingController? _faturamentoLiquidoTextController;
  String? _faturamentoLiquidoTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    return null;
  }

  FocusNode? _mediaProducaoVacaFocusNode;
  TextEditingController? _mediaProducaoVacaTextController;
  String? _mediaProducaoVacaTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    return null;
  }

  FocusNode? _custoLitroLeiteFocusNode;
  TextEditingController? _custoLitroLeiteTextController;
  String? _custoLitroLeiteTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    return null;
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _dtRelatorioFocusNode ??= FocusNode();

    _dtRelatorioMask = MaskTextInputFormatter(mask: '##/##/####');

    _vacasLactacaoFocusNode ??= FocusNode();

    _litrosLeiteDiaFocusNode ??= FocusNode();

    _litrosLeiteMesFocusNode ??= FocusNode();

    _totalRecebidoFocusNode ??= FocusNode();

    _faturamentoLiquidoFocusNode ??= FocusNode();

    _mediaProducaoVacaFocusNode ??= FocusNode();

    _custoLitroLeiteFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _dtRelatorioFocusNode?.dispose();
    _dtRelatorioTextController?.dispose();
    _vacasLactacaoFocusNode?.dispose();
    _vacasLactacaoTextController?.dispose();
    _litrosLeiteDiaFocusNode?.dispose();
    _litrosLeiteDiaTextController?.dispose();
    _litrosLeiteMesFocusNode?.dispose();
    _litrosLeiteMesTextController?.dispose();
    _totalRecebidoFocusNode?.dispose();
    _totalRecebidoTextController?.dispose();
    _faturamentoLiquidoFocusNode?.dispose();
    _faturamentoLiquidoTextController?.dispose();
    _mediaProducaoVacaFocusNode?.dispose();
    _mediaProducaoVacaTextController?.dispose();
    _custoLitroLeiteFocusNode?.dispose();
    _custoLitroLeiteTextController?.dispose();

    super.dispose();
  }

  /// Produção do mês.
  Widget _camposEntrada(
      BuildContext context, dynamic editarRelatorioFinanceiroFinanceiroRecord) {
    return Column(
      children: [
        SecaoFormulario(
          icone: Icons.water_drop_outlined,
          titulo: 'Produção',
          filhos: [
            _campoData(context, editarRelatorioFinanceiroFinanceiroRecord),
            _campoVacasLactacao(
                context, editarRelatorioFinanceiroFinanceiroRecord),
            _campoLitrosLeiteDia(
                context, editarRelatorioFinanceiroFinanceiroRecord),
            _campoLitrosLeiteMes(
                context, editarRelatorioFinanceiroFinanceiroRecord),
          ],
        ),
        SecaoFormulario(
          icone: Icons.payments_outlined,
          titulo: 'Valores',
          espaco: 6.0,
          filhos: [
            _labelPrecoLitro(context),
            _campoPrecoLitro(
                context, editarRelatorioFinanceiroFinanceiroRecord),
            _labelDespesasMes(context),
            _campoDespesasMes(
                context, editarRelatorioFinanceiroFinanceiroRecord),
          ],
        ),
      ],
    );
  }

  /// Os quatro resultados vêm do botão "Calcular resultado" (antes um
  /// "Autocalcular" pequeno com um "?" que abria um aviso).
  Widget _camposCalculados(
      BuildContext context, dynamic editarRelatorioFinanceiroFinanceiroRecord) {
    return SecaoFormulario(
      icone: Icons.calculate_outlined,
      titulo: 'Resultado',
      ajuda: 'Preencha produção e valores e toque em calcular.',
      filhos: [
        FFButtonWidget(
          onPressed: _calcular,
          text: 'Calcular resultado',
          icon: const Icon(Icons.calculate_outlined, size: 18.0),
          options: FFButtonOptions(
            width: double.infinity,
            height: LayoutLista.alturaControle,
            padding: EdgeInsets.zero,
            iconPadding: EdgeInsets.zero,
            color: AppTokens.brandTint,
            iconColor: AppTokens.brand,
            textStyle: GoogleFonts.readexPro(
                color: AppTokens.brand,
                fontSize: 14.0,
                fontWeight: FontWeight.w600),
            elevation: 0.0,
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(LayoutLista.raio),
          ),
        ),
        _campoTotalRecebido(context, editarRelatorioFinanceiroFinanceiroRecord),
        _campoFaturamentoLiquido(
            context, editarRelatorioFinanceiroFinanceiroRecord),
        _campoMediaProducaoVaca(
            context, editarRelatorioFinanceiroFinanceiroRecord),
        _campoCustoLitroLeite(
            context, editarRelatorioFinanceiroFinanceiroRecord),
      ],
    );
  }

  bool get _calculado =>
      _totalRecebidoTextController.text != '' &&
      _faturamentoLiquidoTextController.text != '' &&
      _mediaProducaoVacaTextController.text != '' &&
      _custoLitroLeiteTextController.text != '';

  Future<void> _calcular() async {
    if ((_dtRelatorioTextController.text != '') &&
        (_vacasLactacaoTextController.text != '') &&
        (_litrosLeiteDiaTextController.text != '') &&
        (_litrosLeiteMesTextController.text != '') &&
        (_despesasNoMes != null) &&
        (_precoRecebidoLitro != null)) {
      safeSetState(() {
        _totalRecebidoTextController?.text = functions.calcularTotalRecebido(
            _precoRecebidoLitro.toString(), _litrosLeiteMesTextController.text);
      });
      safeSetState(() {
        _faturamentoLiquidoTextController?.text =
            functions.subtracaoFaturamentoLiquido(
                _totalRecebidoTextController.text, _despesasNoMes.toString());
      });
      safeSetState(() {
        _mediaProducaoVacaTextController?.text = formatNumber(
          functions.calcularMediaProducaoPorVaca(
              _litrosLeiteDiaTextController.text,
              _vacasLactacaoTextController.text),
          formatType: FormatType.decimal,
          decimalType: DecimalType.commaDecimal,
        );
      });
      safeSetState(() {
        _custoLitroLeiteTextController?.text = functions.calcularCustoPorLitro(
            _litrosLeiteMesTextController.text, _despesasNoMes.toString());
      });
      return;
    } else {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            title: Text('Preencha todos os campos.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
      return;
    }
  }

  Future<void> _salvar(
      dynamic editarRelatorioFinanceiroFinanceiroRecord) async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    await _salvarOfflineFirst(
      vacasLactacao: int.tryParse(_vacasLactacaoTextController.text),
      litrosLeiteMes: int.tryParse(_litrosLeiteMesTextController.text),
      litrosLeitePorDia: int.tryParse(_litrosLeiteDiaTextController.text),
      precoRecebidoPorLitro: _precoRecebidoLitro.toString(),
      despesasNoMes: _despesasNoMes.toString(),
      faturamentoLiquido: _faturamentoLiquidoTextController.text,
      mediaProducaoVaca: _mediaProducaoVacaTextController.text,
      custoLitroLeite: _custoLitroLeiteTextController.text,
      totalRecebidoMes: _totalRecebidoTextController.text,
    );

    // Volta para a tela de onde veio. Só `goNamed` (que troca a pilha
    // inteira) quando não há para onde voltar: antes era sempre `goNamed`,
    // e o voltar da lista nova caía no dashboard, perdendo a propriedade.
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(
        RelatorioFinanceiroPage.routeName,
        queryParameters: {
          'uidPropriedade': serializeParam(
            widget.uidPropriedade,
            ParamType.DocumentReference,
          ),
          'nomePropriedade': serializeParam(
            widget.nomePropriedade,
            ParamType.String,
          ),
          'uidTecnico': serializeParam(
            widget.uidTecnico,
            ParamType.DocumentReference,
          ),
          'emailPropriedade': serializeParam(
            widget.emailPropriedade,
            ParamType.String,
          ),
          'visitaPresencial': serializeParam(
            widget.visitaPresencial,
            ParamType.bool,
          ),
          'diasDg': serializeParam(
            widget.diasDg,
            ParamType.String,
          ),
        }.withoutNulls,
      );
    }
  }

  Widget _campoData(
      BuildContext context, dynamic editarRelatorioFinanceiroFinanceiroRecord) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: TextFormField(
            controller: _dtRelatorioTextController ??= TextEditingController(
              text: editarRelatorioFinanceiroFinanceiroRecord.dtRelatorio ?? '',
            ),
            focusNode: _dtRelatorioFocusNode,
            onChanged: (_) => EasyDebounce.debounce(
              '_dtRelatorioTextController',
              Duration(milliseconds: 2000),
              () => safeSetState(() {}),
            ),
            autofocus: false,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.next,
            readOnly: true,
            obscureText: false,
            decoration: InputDecoration(
              labelText: 'Data relatório',
              hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                    font: GoogleFonts.readexPro(
                      fontWeight:
                          FlutterFlowTheme.of(context).labelMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
              filled: true,
              fillColor: FlutterFlowTheme.of(context).primaryBackground,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppTokens.secondary,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).error,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).error,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              contentPadding:
                  EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
              suffixIcon: _dtRelatorioTextController!.text.isNotEmpty
                  ? InkWell(
                      onTap: () async {
                        _dtRelatorioTextController?.clear();
                        safeSetState(() {});
                      },
                      child: Icon(
                        Icons.clear,
                        size: 22.0,
                      ),
                    )
                  : null,
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
            maxLength: 10,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            buildCounter: (context,
                    {required currentLength, required isFocused, maxLength}) =>
                null,
            keyboardType: TextInputType.datetime,
            validator: _dtRelatorioTextControllerValidator.asValidator(context),
            inputFormatters: [_dtRelatorioMask],
          ),
        ),
      ],
    );
  }

  Widget _campoVacasLactacao(
      BuildContext context, dynamic editarRelatorioFinanceiroFinanceiroRecord) {
    return StreamBuilder<List<AnimaisProdutoresRecord>>(
      stream: queryAnimaisProdutoresRecord(
        parent: widget.uidTecnico,
        queryBuilder: (animaisProdutoresRecord) => animaisProdutoresRecord
            .where(
              'uidTecnicoPropriedade',
              isEqualTo: widget.uidPropriedade,
            )
            .where(
              'grupoAnimal',
              isEqualTo: 'Vacas',
            ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFFF75E38),
                ),
              ),
            ),
          );
        }
        List<AnimaisProdutoresRecord> vacasLactacaoAnimaisProdutoresRecordList =
            snapshot.data!;

        return TextFormField(
          controller: _vacasLactacaoTextController ??= TextEditingController(
            text: editarRelatorioFinanceiroFinanceiroRecord.vacasLactacao
                .toString(),
          ),
          focusNode: _vacasLactacaoFocusNode,
          onChanged: (_) => EasyDebounce.debounce(
            '_vacasLactacaoTextController',
            Duration(milliseconds: 2000),
            () async {},
          ),
          autofocus: true,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Vacas em lactação*',
            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppTokens.secondary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            contentPadding:
                EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
          keyboardType: TextInputType.number,
          cursorColor: FlutterFlowTheme.of(context).primary,
          validator: _vacasLactacaoTextControllerValidator.asValidator(context),
        );
      },
    );
  }

  Widget _campoLitrosLeiteDia(
      BuildContext context, dynamic editarRelatorioFinanceiroFinanceiroRecord) {
    return TextFormField(
      controller: _litrosLeiteDiaTextController ??= TextEditingController(
        text: editarRelatorioFinanceiroFinanceiroRecord.litrosLeitePorDia
            .toString(),
      ),
      focusNode: _litrosLeiteDiaFocusNode,
      onChanged: (_) => EasyDebounce.debounce(
        '_litrosLeiteDiaTextController',
        Duration(milliseconds: 2000),
        () async {
          if (_vacasLactacaoTextController.text != '') {
            safeSetState(() {
              _litrosLeiteMesTextController?.text = functions
                  .calcularLitrosLeiteMes(_litrosLeiteDiaTextController.text)
                  .toString();
            });
            return;
          } else {
            return;
          }
        },
      ),
      autofocus: true,
      textCapitalization: TextCapitalization.none,
      obscureText: false,
      decoration: InputDecoration(
        labelText: 'Litros leite por dia*',
        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTokens.secondary,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      ),
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.readexPro(
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            letterSpacing: 0.0,
            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
      keyboardType: TextInputType.number,
      cursorColor: FlutterFlowTheme.of(context).primary,
      validator: _litrosLeiteDiaTextControllerValidator.asValidator(context),
      inputFormatters: [
        if (!isAndroid && !isiOS)
          TextInputFormatter.withFunction((oldValue, newValue) {
            return TextEditingValue(
              selection: newValue.selection,
              text: newValue.text.toCapitalization(TextCapitalization.none),
            );
          }),
      ],
    );
  }

  Widget _campoLitrosLeiteMes(
      BuildContext context, dynamic editarRelatorioFinanceiroFinanceiroRecord) {
    return TextFormField(
      controller: _litrosLeiteMesTextController ??= TextEditingController(
        text:
            editarRelatorioFinanceiroFinanceiroRecord.litrosLeiteMes.toString(),
      ),
      focusNode: _litrosLeiteMesFocusNode,
      onChanged: (_) => EasyDebounce.debounce(
        '_litrosLeiteMesTextController',
        Duration(milliseconds: 2000),
        () async {},
      ),
      autofocus: true,
      textCapitalization: TextCapitalization.none,
      obscureText: false,
      decoration: InputDecoration(
        labelText: 'Litros leite no mês*',
        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTokens.secondary,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      ),
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.readexPro(
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            letterSpacing: 0.0,
            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
      maxLength: 10,
      maxLengthEnforcement: MaxLengthEnforcement.none,
      buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) =>
          null,
      keyboardType: TextInputType.number,
      cursorColor: FlutterFlowTheme.of(context).primary,
      validator: _litrosLeiteMesTextControllerValidator.asValidator(context),
      inputFormatters: [
        if (!isAndroid && !isiOS)
          TextInputFormatter.withFunction((oldValue, newValue) {
            return TextEditingValue(
              selection: newValue.selection,
              text: newValue.text.toCapitalization(TextCapitalization.none),
            );
          }),
      ],
    );
  }

  Widget _labelPrecoLitro(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(-1.0, 0.0),
      child: Text(
        'Preço litro leite*',
        textAlign: TextAlign.start,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
      ),
    );
  }

  Widget _campoPrecoLitro(
      BuildContext context, dynamic editarRelatorioFinanceiroFinanceiroRecord) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      height: 45.0,
      child: custom_widgets.PrecoRecebidoLitro(
        width: MediaQuery.sizeOf(context).width * 1.0,
        height: 45.0,
        bordercolor: AppTokens.secondary,
        borderRadius: 10.0,
        initialValue:
            editarRelatorioFinanceiroFinanceiroRecord.precoRecebidoPorLitro ??
                '',
        onChanged: (v) => _precoRecebidoLitro = v,
      ),
    );
  }

  Widget _labelDespesasMes(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(-1.0, 0.0),
      child: Text(
        'Despesas do mês*',
        textAlign: TextAlign.start,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
      ),
    );
  }

  Widget _campoDespesasMes(
      BuildContext context, dynamic editarRelatorioFinanceiroFinanceiroRecord) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      height: 45.0,
      child: custom_widgets.DespesasNoMes(
        width: MediaQuery.sizeOf(context).width * 1.0,
        height: 45.0,
        bordercolor: AppTokens.secondary,
        borderRadius: 10.0,
        initialValue:
            editarRelatorioFinanceiroFinanceiroRecord.despesasNoMes ?? '',
        onChanged: (v) => _despesasNoMes = v,
      ),
    );
  }

  Widget _campoTotalRecebido(
      BuildContext context, dynamic editarRelatorioFinanceiroFinanceiroRecord) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
      child: Container(
        decoration: BoxDecoration(),
        child: TextFormField(
          controller: _totalRecebidoTextController ??= TextEditingController(
            text: editarRelatorioFinanceiroFinanceiroRecord.totalRecebidoMes ??
                '',
          ),
          focusNode: _totalRecebidoFocusNode,
          onChanged: (_) => EasyDebounce.debounce(
            '_totalRecebidoTextController',
            Duration(milliseconds: 2000),
            () async {
              safeSetState(() {
                _totalRecebidoTextController?.text = functions.formataMoedaText(
                    double.parse(_totalRecebidoTextController.text));
              });
              safeSetState(() {
                _faturamentoLiquidoTextController?.text =
                    functions.subtracaoFaturamentoLiquido(
                        _totalRecebidoTextController.text,
                        _despesasNoMes.toString());
              });
              return;
            },
          ),
          autofocus: false,
          textCapitalization: TextCapitalization.none,
          readOnly: true,
          obscureText: false,
          decoration: InputDecoration(
            // Resultado calculado: cinza preenchido como os demais campos.
            filled: true,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            labelText: 'Total recebido*',
            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding:
                EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
          cursorColor: FlutterFlowTheme.of(context).primary,
          validator: _totalRecebidoTextControllerValidator.asValidator(context),
          inputFormatters: [
            if (!isAndroid && !isiOS)
              TextInputFormatter.withFunction((oldValue, newValue) {
                return TextEditingValue(
                  selection: newValue.selection,
                  text: newValue.text.toCapitalization(TextCapitalization.none),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _campoFaturamentoLiquido(
      BuildContext context, dynamic editarRelatorioFinanceiroFinanceiroRecord) {
    return Container(
      decoration: BoxDecoration(),
      child: TextFormField(
        controller: _faturamentoLiquidoTextController ??= TextEditingController(
          text: editarRelatorioFinanceiroFinanceiroRecord.faturamentoLiquido ??
              '',
        ),
        focusNode: _faturamentoLiquidoFocusNode,
        onChanged: (_) => EasyDebounce.debounce(
          '_faturamentoLiquidoTextController',
          Duration(milliseconds: 2000),
          () async {
            safeSetState(() {
              _faturamentoLiquidoTextController?.text =
                  functions.formataMoedaText(
                      double.parse(_faturamentoLiquidoTextController.text));
            });
            safeSetState(() {
              _custoLitroLeiteTextController?.text = formatNumber(
                (double.parse(_totalRecebidoTextController.text) -
                        double.parse(_faturamentoLiquidoTextController.text)) /
                    double.parse(_litrosLeiteMesTextController.text),
                formatType: FormatType.decimal,
                decimalType: DecimalType.commaDecimal,
              );
            });
          },
        ),
        autofocus: false,
        textCapitalization: TextCapitalization.none,
        readOnly: true,
        obscureText: false,
        decoration: InputDecoration(
          // Resultado calculado: cinza preenchido como os demais campos.
          filled: true,
          fillColor: FlutterFlowTheme.of(context).primaryBackground,
          labelText: 'Faturamento líquido*',
          labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding:
              EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
        ),
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
        cursorColor: FlutterFlowTheme.of(context).primary,
        validator:
            _faturamentoLiquidoTextControllerValidator.asValidator(context),
        inputFormatters: [
          if (!isAndroid && !isiOS)
            TextInputFormatter.withFunction((oldValue, newValue) {
              return TextEditingValue(
                selection: newValue.selection,
                text: newValue.text.toCapitalization(TextCapitalization.none),
              );
            }),
        ],
      ),
    );
  }

  Widget _campoMediaProducaoVaca(
      BuildContext context, dynamic editarRelatorioFinanceiroFinanceiroRecord) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
      child: Container(
        decoration: BoxDecoration(),
        child: TextFormField(
          controller: _mediaProducaoVacaTextController ??=
              TextEditingController(
            text: editarRelatorioFinanceiroFinanceiroRecord.mediaProducaoVaca ??
                '',
          ),
          focusNode: _mediaProducaoVacaFocusNode,
          autofocus: false,
          textCapitalization: TextCapitalization.none,
          readOnly: true,
          obscureText: false,
          decoration: InputDecoration(
            // Resultado calculado: cinza preenchido como os demais campos.
            filled: true,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            labelText: 'Média produção vaca*',
            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding:
                EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
          cursorColor: FlutterFlowTheme.of(context).primary,
          validator:
              _mediaProducaoVacaTextControllerValidator.asValidator(context),
          inputFormatters: [
            if (!isAndroid && !isiOS)
              TextInputFormatter.withFunction((oldValue, newValue) {
                return TextEditingValue(
                  selection: newValue.selection,
                  text: newValue.text.toCapitalization(TextCapitalization.none),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _campoCustoLitroLeite(
      BuildContext context, dynamic editarRelatorioFinanceiroFinanceiroRecord) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
      child: Container(
        decoration: BoxDecoration(),
        child: TextFormField(
          controller: _custoLitroLeiteTextController ??= TextEditingController(
            text:
                editarRelatorioFinanceiroFinanceiroRecord.custoLitroLeite ?? '',
          ),
          focusNode: _custoLitroLeiteFocusNode,
          onChanged: (_) => EasyDebounce.debounce(
            '_custoLitroLeiteTextController',
            Duration(milliseconds: 2000),
            () async {
              safeSetState(() {
                _custoLitroLeiteTextController?.text =
                    functions.formataMoedaText(
                        double.parse(_custoLitroLeiteTextController.text));
              });
            },
          ),
          autofocus: false,
          textCapitalization: TextCapitalization.none,
          readOnly: true,
          obscureText: false,
          decoration: InputDecoration(
            // Resultado calculado: cinza preenchido como os demais campos.
            filled: true,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            labelText: 'Custo litro de leite*',
            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding:
                EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
          cursorColor: FlutterFlowTheme.of(context).primary,
          validator:
              _custoLitroLeiteTextControllerValidator.asValidator(context),
          inputFormatters: [
            if (!isAndroid && !isiOS)
              TextInputFormatter.withFunction((oldValue, newValue) {
                return TextEditingValue(
                  selection: newValue.selection,
                  text: newValue.text.toCapitalization(TextCapitalization.none),
                );
              }),
          ],
        ),
      ),
    );
  }

  /// Salva a edição offline-first: aplica no ObjectBox e deixa o sync subir
  /// (`_syncModifiedFinanceiro` faz o update no Firestore ao reconectar).
  Future<void> _salvarOfflineFirst({
    int? vacasLactacao,
    int? litrosLeiteMes,
    int? litrosLeitePorDia,
    String? precoRecebidoPorLitro,
    String? despesasNoMes,
    String? faturamentoLiquido,
    String? mediaProducaoVaca,
    String? custoLitroLeite,
    String? totalRecebidoMes,
  }) async {
    final repo = FinanceiroRepository();
    final entity = widget.financeiroLocalId == null
        ? null
        : repo.box.get(widget.financeiroLocalId!);
    if (entity == null) return;

    entity.vacasLactacao = vacasLactacao ?? entity.vacasLactacao;
    entity.litrosLeiteMes = litrosLeiteMes ?? entity.litrosLeiteMes;
    entity.litrosLeitePorDia = litrosLeitePorDia ?? entity.litrosLeitePorDia;
    entity.precoRecebidoPorLitro =
        precoRecebidoPorLitro ?? entity.precoRecebidoPorLitro;
    entity.despesasNoMes = despesasNoMes ?? entity.despesasNoMes;
    entity.faturamentoLiquido = faturamentoLiquido ?? entity.faturamentoLiquido;
    entity.mediaProducaoVaca = mediaProducaoVaca ?? entity.mediaProducaoVaca;
    entity.custoLitroLeite = custoLitroLeite ?? entity.custoLitroLeite;
    entity.totalRecebidoMes = totalRecebidoMes ?? entity.totalRecebidoMes;

    await repo.save(entity);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    // Fonte única ObjectBox: leitura local e sincrona, sem espera de rede.
    final editarRelatorioFinanceiroFinanceiroRecord =
        widget.financeiroLocalId == null
            ? null
            : FinanceiroRepository().box.get(widget.financeiroLocalId!);

    if (editarRelatorioFinanceiroFinanceiroRecord == null) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Center(
          child: Text(
            'Relatório não encontrado.',
            style: FlutterFlowTheme.of(context).bodyMedium,
          ),
        ),
      );
    }

    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: CabecalhoTela(
                titulo:
                    'Relatório de ${editarRelatorioFinanceiroFinanceiroRecord.dtRelatorio ?? ''}'),
            bottomNavigationBar: RodapeAcao(
              texto: 'Salvar alterações',
              icone: Icons.check_rounded,
              aviso: 'Calcule o resultado para salvar.',
              aoTocar: _calculado
                  ? () => _salvar(editarRelatorioFinanceiroFinanceiroRecord)
                  : null,
            ),
            body: SafeArea(
              top: true,
              child: Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    children: [
                      _camposEntrada(
                          context, editarRelatorioFinanceiroFinanceiroRecord),
                      _camposCalculados(
                          context, editarRelatorioFinanceiroFinanceiroRecord),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
