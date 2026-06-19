// ignore_for_file: unnecessary_null_comparison, dead_null_aware_expression

import '/data/backend.dart';
import '/core/ui/app_card.dart';
import '/domain/animais/classificacao_animal.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import 'dart:ui';
import '/features/financeiro/presentation/widgets/index.dart' as custom_widgets;
import '/core/ui/custom_functions.dart' as functions;
import '/features/financeiro/presentation/pages/relatorio_financeiro_page.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class NovoRelatorioFinanceiroPage extends StatefulWidget {
  const NovoRelatorioFinanceiroPage({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.diasDg,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? diasDg;

  static String routeName = 'novoRelatorioFinanceiro';
  static String routePath = '/novoRelatorioFinanceiro';

  @override
  State<NovoRelatorioFinanceiroPage> createState() =>
      _NovoRelatorioFinanceiroPageState();
}

class _NovoRelatorioFinanceiroPageState
    extends State<NovoRelatorioFinanceiroPage> {
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

  DateTime? _datePicked;
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

    _dtRelatorioTextController ??= TextEditingController();
    _dtRelatorioFocusNode ??= FocusNode();

    _dtRelatorioMask = MaskTextInputFormatter(mask: '##/##/####');

    _vacasLactacaoFocusNode ??= FocusNode();

    _litrosLeiteDiaTextController ??= TextEditingController();
    _litrosLeiteDiaFocusNode ??= FocusNode();

    _litrosLeiteMesTextController ??= TextEditingController();
    _litrosLeiteMesFocusNode ??= FocusNode();

    _totalRecebidoTextController ??= TextEditingController();
    _totalRecebidoFocusNode ??= FocusNode();

    _faturamentoLiquidoTextController ??= TextEditingController();
    _faturamentoLiquidoFocusNode ??= FocusNode();

    _mediaProducaoVacaTextController ??= TextEditingController();
    _mediaProducaoVacaFocusNode ??= FocusNode();

    _custoLitroLeiteTextController ??= TextEditingController();
    _custoLitroLeiteFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {
          _dtRelatorioTextController?.text = dateTimeFormat(
            "dd/MM/yyyy",
            getCurrentTimestamp,
            locale: FFLocalizations.of(context).languageCode,
          );
        }));
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

  Widget _p1(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
          child: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 50.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
        ),
        Text(
          'Novo relatório financeiro',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                font: GoogleFonts.outfit(
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
                color: Colors.white,
                fontSize: 22.0,
                letterSpacing: 0.0,
                fontWeight:
                    FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                fontStyle:
                    FlutterFlowTheme.of(context).headlineMedium.fontStyle,
              ),
        ),
      ],
    );
  }

  Widget _p2(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _p4(context),
            _p5(context),
            _p6(context),
            _p7(context),
            _p8(context),
            Container(
              width: MediaQuery.sizeOf(context).width * 1.0,
              height: 45.0,
              child: custom_widgets.PrecoRecebidoLitro(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: 45.0,
                bordercolor: FlutterFlowTheme.of(context).primary,
                borderRadius: 10.0,
                initialValue: '0,00',
                onChanged: (v) => _precoRecebidoLitro = v,
              ),
            ),
            _p9(context),
            Container(
              width: MediaQuery.sizeOf(context).width * 1.0,
              height: 45.0,
              child: custom_widgets.DespesasNoMes(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: 45.0,
                bordercolor: FlutterFlowTheme.of(context).primary,
                borderRadius: 10.0,
                initialValue: '0,00',
                onChanged: (v) => _despesasNoMes = v,
              ),
            ),
            _p10(context),
          ].divide(SizedBox(height: 12.0)),
        ),
      ),
    );
  }

  Widget _p3(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _p11(context),
        _p12(context),
        _p13(context),
        _p14(context),
        if ((_totalRecebidoTextController.text != '') &&
            (_faturamentoLiquidoTextController.text != '') &&
            (_mediaProducaoVacaTextController.text != '') &&
            (_custoLitroLeiteTextController.text != ''))
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
            child: FFButtonWidget(
              onPressed: () async {
                if (_formKey.currentState == null ||
                    !_formKey.currentState!.validate()) {
                  return;
                }

                await FinanceiroRecord.createDoc(widget.uidTecnico!)
                    .set(createFinanceiroRecordData(
                  uidPropriedade: widget.uidPropriedade,
                  uidTecnico: widget.uidTecnico,
                  dtRelatorio: _dtRelatorioTextController.text,
                  vacasLactacao:
                      int.tryParse(_vacasLactacaoTextController.text),
                  litrosLeiteMes:
                      int.tryParse(_litrosLeiteMesTextController.text),
                  litrosLeitePorDia:
                      int.tryParse(_litrosLeiteDiaTextController.text),
                  precoRecebidoPorLitro: _precoRecebidoLitro.toString(),
                  despesasNoMes: _despesasNoMes.toString(),
                  totalRecebidoMes: _totalRecebidoTextController.text,
                  faturamentoLiquido: _faturamentoLiquidoTextController.text,
                  mediaProducaoVaca: _mediaProducaoVacaTextController.text,
                  custoLitroLeite: _custoLitroLeiteTextController.text,
                ));

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
              },
              text: 'Salvar relatório',
              icon: Icon(
                Icons.save,
                size: 15.0,
              ),
              options: FFButtonOptions(
                width: double.infinity,
                height: 48.0,
                padding: EdgeInsets.all(0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: Color(0xFF048508),
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                      color: Colors.white,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).titleSmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleSmall.fontStyle,
                    ),
                elevation: 4.0,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(60.0),
              ),
            ),
          ),
      ],
    );
  }

  Widget _p4(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
            child: TextFormField(
              controller: _dtRelatorioTextController,
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
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppTokens.secondary,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
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
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
              maxLength: 10,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      maxLength}) =>
                  null,
              keyboardType: TextInputType.datetime,
              validator:
                  _dtRelatorioTextControllerValidator.asValidator(context),
              inputFormatters: [_dtRelatorioMask],
            ),
          ),
        ),
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            // calendarNascimento
            await showModalBottomSheet<bool>(
                context: context,
                builder: (context) {
                  final _datePickedCupertinoTheme = CupertinoTheme.of(context);
                  return ScrollConfiguration(
                    behavior: const MaterialScrollBehavior().copyWith(
                      dragDevices: {
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.touch,
                        PointerDeviceKind.stylus,
                        PointerDeviceKind.unknown
                      },
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      child: CupertinoTheme(
                        data: _datePickedCupertinoTheme.copyWith(
                          textTheme:
                              _datePickedCupertinoTheme.textTheme.copyWith(
                            dateTimePickerTextStyle:
                                FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .override(
                                      font: GoogleFonts.outfit(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .fontStyle,
                                    ),
                          ),
                        ),
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          minimumDate: DateTime(1900),
                          initialDateTime: getCurrentTimestamp,
                          maximumDate: (DateTime.fromMicrosecondsSinceEpoch(
                                  2024708400000000) ??
                              DateTime(2050)),
                          backgroundColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          use24hFormat: false,
                          onDateTimeChanged: (newDateTime) => safeSetState(() {
                            _datePicked = newDateTime;
                          }),
                        ),
                      ),
                    ),
                  );
                });
            safeSetState(() {
              _dtRelatorioTextController?.text = dateTimeFormat(
                "dd/MM/yyyy",
                _datePicked,
                locale: FFLocalizations.of(context).languageCode,
              );
              _dtRelatorioMask.updateMask(
                newValue: TextEditingValue(
                  text: _dtRelatorioTextController!.text,
                ),
              );
            });
          },
          child: Icon(
            Icons.calendar_month,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24.0,
          ),
        ),
      ],
    );
  }

  Widget _p5(BuildContext context) {
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
            text: vacasLactacaoAnimaisProdutoresRecordList
                .where((e) =>
                    (ehVazia(e.status)) ||
                    (ehPrenha(e.status)) ||
                    (ehInseminada(e.status)) ||
                    (ehInseminadaPP(e.status)))
                .toList()
                .length
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
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).alternate,
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

  Widget _p6(BuildContext context) {
    return TextFormField(
      controller: _litrosLeiteDiaTextController,
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
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).alternate,
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

  Widget _p7(BuildContext context) {
    return TextFormField(
      controller: _litrosLeiteMesTextController,
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
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).alternate,
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

  Widget _p8(BuildContext context) {
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

  Widget _p9(BuildContext context) {
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

  Widget _p10(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FFButtonWidget(
          onPressed: () async {
            if ((_dtRelatorioTextController.text != '') &&
                (_vacasLactacaoTextController.text != '') &&
                (_litrosLeiteDiaTextController.text != '') &&
                (_litrosLeiteMesTextController.text != '') &&
                (_despesasNoMes != null) &&
                (_precoRecebidoLitro != null)) {
              safeSetState(() {
                _totalRecebidoTextController?.text =
                    functions.calcularTotalRecebido(
                        _precoRecebidoLitro.toString(),
                        _litrosLeiteMesTextController.text);
              });
              safeSetState(() {
                _faturamentoLiquidoTextController?.text =
                    functions.subtracaoFaturamentoLiquido(
                        _totalRecebidoTextController.text,
                        _despesasNoMes.toString());
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
                _custoLitroLeiteTextController?.text =
                    functions.calcularCustoPorLitro(
                        _litrosLeiteMesTextController.text,
                        _despesasNoMes.toString());
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
          },
          text: 'Autocalcular',
          icon: Icon(
            Icons.calculate_outlined,
            size: 15.0,
          ),
          options: FFButtonOptions(
            height: 40.0,
            padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            color: FlutterFlowTheme.of(context).primary,
            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleSmall.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleSmall.fontStyle,
                  ),
                  color: Colors.white,
                  fontSize: 13.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleSmall.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                ),
            elevation: 3.0,
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
          child: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              await showDialog(
                context: context,
                builder: (alertDialogContext) {
                  return AlertDialog(
                    title: Text('Preencha todos os campos acima.'),
                    content: Text('Os campos abaixo serão autocalculados.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(alertDialogContext),
                        child: Text('Ok'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(
              Icons.question_mark_sharp,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 15.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _p11(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
      child: Container(
        decoration: BoxDecoration(),
        child: TextFormField(
          controller: _totalRecebidoTextController,
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
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).alternate,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedErrorBorder: UnderlineInputBorder(
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

  Widget _p12(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: TextFormField(
        controller: _faturamentoLiquidoTextController,
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
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).alternate,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedErrorBorder: UnderlineInputBorder(
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

  Widget _p13(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
      child: Container(
        decoration: BoxDecoration(),
        child: TextFormField(
          controller: _mediaProducaoVacaTextController,
          focusNode: _mediaProducaoVacaFocusNode,
          autofocus: false,
          textCapitalization: TextCapitalization.none,
          readOnly: true,
          obscureText: false,
          decoration: InputDecoration(
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
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).alternate,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedErrorBorder: UnderlineInputBorder(
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

  Widget _p14(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
      child: Container(
        decoration: BoxDecoration(),
        child: TextFormField(
          controller: _custoLitroLeiteTextController,
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
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).alternate,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedErrorBorder: UnderlineInputBorder(
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

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF75E38), Color(0xFFEC3B5B)],
                  begin: AlignmentDirectional(-1.0, -1.0),
                  end: AlignmentDirectional(1.0, 1.0),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.0),
                  bottomRight: Radius.circular(24.0),
                ),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                actions: [],
                flexibleSpace: FlexibleSpaceBar(
                  title: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _p1(context),
                    ],
                  ),
                  centerTitle: true,
                  expandedTitleScale: 1.0,
                ),
                elevation: 0.0,
              )),
        ),
        body: SafeArea(
          top: true,
          child: Container(
            width: MediaQuery.sizeOf(context).width * 1.0,
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _p2(context),
                      _p3(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
