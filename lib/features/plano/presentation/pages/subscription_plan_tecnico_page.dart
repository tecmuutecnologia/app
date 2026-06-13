import '/backend/backend.dart';
import '/backend/stripe/payment_manager.dart';
import '/core/ui/flutter_flow_drop_down.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/form_field_controller.dart';
import '/pages/tecnico/dashboard/dashboard_tecnico/dashboard_tecnico_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionPlanTecnicoPage extends StatefulWidget {
  const SubscriptionPlanTecnicoPage({
    super.key,
    required this.uidTecnico,
    required this.email,
  });

  final DocumentReference? uidTecnico;
  final String? email;

  static String routeName = 'subscriptionPlanTecnico';
  static String routePath = '/subscriptionPlanTecnico';

  @override
  State<SubscriptionPlanTecnicoPage> createState() =>
      _SubscriptionPlanTecnicoPageState();
}

class _SubscriptionPlanTecnicoPageState
    extends State<SubscriptionPlanTecnicoPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int? _dropDownValue1;
  FormFieldController<int>? _dropDownValueController1;
  double? _dropDownValue2;
  FormFieldController<double>? _dropDownValueController2;

  // Outputs de query/ação (antes no FlutterFlowModel).
  AssinaturaTecnicoRecord? _outUidAssinaturaTecnico;
  AssinaturaAtivaTecnicoRecord? _outUidAssinaturaAtiva;
  PlanosTecnicosRecord? _outUidPlanoFree;
  AssinaturaTecnicoRecord? _outUidNovoPlano;
  String? _outUidPayment;
  PlanosTecnicosRecord? _outUidPlanoEscolhido;
  AssinaturaTecnicoRecord? _outUidAssinaturaPlanoStripe;
  AssinaturaAtivaTecnicoRecord? _outUidAssinaturaAtivaStripe;
  AssinaturaTecnicoRecord? _outUidNovoPlanoPago;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
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
              context.pop();
            },
          ),
        ),
      ],
    );
  }

  Widget _p2(BuildContext context,
      dynamic subscriptionPlanTecnicoPlanosTecnicosRecordList) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 24.0),
      child: Wrap(
        spacing: 16.0,
        runSpacing: 16.0,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        direction: Axis.horizontal,
        runAlignment: WrapAlignment.start,
        verticalDirection: VerticalDirection.down,
        clipBehavior: Clip.none,
        children: [
          _p3(context, subscriptionPlanTecnicoPlanosTecnicosRecordList),
        ],
      ),
    );
  }

  Widget _p3(BuildContext context,
      dynamic subscriptionPlanTecnicoPlanosTecnicosRecordList) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: 430.0,
      ),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(
              0.0,
              2.0,
            ),
          )
        ],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _p4(context),
            _p5(context),
            _p6(context),
            _p7(context, subscriptionPlanTecnicoPlanosTecnicosRecordList),
            Divider(
              height: 32.0,
              thickness: 2.0,
              color: FlutterFlowTheme.of(context).alternate,
            ),
            _p8(context),
            _p9(context),
          ],
        ),
      ),
    );
  }

  Widget _p4(BuildContext context) {
    return Text(
      'Assinatura de plano',
      style: FlutterFlowTheme.of(context).titleLarge.override(
            font: GoogleFonts.outfit(
              fontWeight: FlutterFlowTheme.of(context).titleLarge.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
            ),
            letterSpacing: 0.0,
            fontWeight: FlutterFlowTheme.of(context).titleLarge.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
          ),
    );
  }

  Widget _p5(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 12.0),
      child: Text(
        'Escolha um abaixo',
        style: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
      ),
    );
  }

  Widget _p6(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: FlutterFlowDropDown<int>(
        controller: _dropDownValueController1 ??= FormFieldController<int>(
          _dropDownValue1 ??= 30,
        ),
        options: List<int>.from([30, 180, 365]),
        optionLabels: ['Mensal', 'Semestral (10% off)', 'Anual (20% off)'],
        onChanged: (val) => safeSetState(() => _dropDownValue1 = val),
        width: double.infinity,
        height: 60.0,
        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              color: Color(0xFF57636C),
              fontSize: 16.0,
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
        hintText: 'Tipo assinatura',
        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
        elevation: 2.0,
        borderColor: FlutterFlowTheme.of(context).alternate,
        borderWidth: 2.0,
        borderRadius: 40.0,
        margin: EdgeInsetsDirectional.fromSTEB(24.0, 4.0, 24.0, 4.0),
        hidesUnderline: true,
        isSearchable: false,
        isMultiSelect: false,
      ),
    );
  }

  Widget _p7(BuildContext context,
      dynamic subscriptionPlanTecnicoPlanosTecnicosRecordList) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: FlutterFlowDropDown<double>(
        controller: _dropDownValueController2 ??= FormFieldController<double>(
          _dropDownValue2 ??= 0.0,
        ),
        options: List<double>.from(
            subscriptionPlanTecnicoPlanosTecnicosRecordList
                .map((e) => e.preco)
                .toList()),
        optionLabels: subscriptionPlanTecnicoPlanosTecnicosRecordList
            .map((e) => e.nome)
            .toList(),
        onChanged: (val) => safeSetState(() => _dropDownValue2 = val),
        width: double.infinity,
        height: 60.0,
        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              color: Color(0xFF57636C),
              fontSize: 16.0,
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
        hintText: 'Selecione um plano',
        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
        elevation: 2.0,
        borderColor: FlutterFlowTheme.of(context).alternate,
        borderWidth: 2.0,
        borderRadius: 40.0,
        margin: EdgeInsetsDirectional.fromSTEB(24.0, 4.0, 24.0, 4.0),
        hidesUnderline: true,
        isSearchable: false,
        isMultiSelect: false,
      ),
    );
  }

  Widget _p8(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Total R\$',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.outfit(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 20.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                          ),
                    ),
                  ],
                ),
                Text(
                  valueOrDefault<String>(
                    () {
                      if (_dropDownValue1 == 180) {
                        return formatNumber(
                          (((_dropDownValue2!) * 6) -
                              (((_dropDownValue2!) * 6) * 0.1)),
                          formatType: FormatType.decimal,
                          decimalType: DecimalType.commaDecimal,
                        );
                      } else if (_dropDownValue1 == 365) {
                        return formatNumber(
                          (((_dropDownValue2!) * 12) -
                              (((_dropDownValue2!) * 12) * 0.2)),
                          formatType: FormatType.decimal,
                          decimalType: DecimalType.commaDecimal,
                        );
                      } else {
                        return _dropDownValue2?.toString();
                      }
                    }(),
                    'Grátis',
                  ),
                  style: FlutterFlowTheme.of(context).displaySmall.override(
                        font: GoogleFonts.outfit(
                          fontWeight: FlutterFlowTheme.of(context)
                              .displaySmall
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .displaySmall
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight: FlutterFlowTheme.of(context)
                            .displaySmall
                            .fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).displaySmall.fontStyle,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _p9(BuildContext context) {
    return FFButtonWidget(
      onPressed: () async {
        var _shouldSetState = false;
        if (_dropDownValue2 == 0.0) {
          _outUidAssinaturaTecnico = await queryAssinaturaTecnicoRecordOnce(
            queryBuilder: (assinaturaTecnicoRecord) =>
                assinaturaTecnicoRecord.where(
              'idTecnico',
              isEqualTo: widget.uidTecnico,
            ),
            singleRecord: true,
          ).then((s) => s.firstOrNull);
          _shouldSetState = true;
          _outUidAssinaturaAtiva = await queryAssinaturaAtivaTecnicoRecordOnce(
            queryBuilder: (assinaturaAtivaTecnicoRecord) =>
                assinaturaAtivaTecnicoRecord.where(
              'idAssinaturaTecnico',
              isEqualTo: _outUidAssinaturaTecnico?.reference,
            ),
            singleRecord: true,
          ).then((s) => s.firstOrNull);
          _shouldSetState = true;
          _outUidPlanoFree = await queryPlanosTecnicosRecordOnce(
            queryBuilder: (planosTecnicosRecord) => planosTecnicosRecord.where(
              'nome',
              isEqualTo: 'Start',
            ),
            singleRecord: true,
          ).then((s) => s.firstOrNull);
          _shouldSetState = true;

          var assinaturaTecnicoRecordReference1 =
              AssinaturaTecnicoRecord.collection.doc();
          await assinaturaTecnicoRecordReference1
              .set(createAssinaturaTecnicoRecordData(
            dtAssinatura: getCurrentTimestamp,
            tipoPlano: 'Plano gratuito',
            dtExpiracao: getCurrentTimestamp,
            idPlano: _outUidPlanoFree?.reference,
            idTecnico: widget.uidTecnico,
          ));
          _outUidNovoPlano = AssinaturaTecnicoRecord.getDocumentFromData(
              createAssinaturaTecnicoRecordData(
                dtAssinatura: getCurrentTimestamp,
                tipoPlano: 'Plano gratuito',
                dtExpiracao: getCurrentTimestamp,
                idPlano: _outUidPlanoFree?.reference,
                idTecnico: widget.uidTecnico,
              ),
              assinaturaTecnicoRecordReference1);
          _shouldSetState = true;

          await _outUidAssinaturaAtiva!.reference
              .update(createAssinaturaAtivaTecnicoRecordData(
            dtAssinatura: getCurrentTimestamp,
            dtExpiracao: getCurrentTimestamp,
            tipoPlano: '30',
            idAssinaturaTecnico: _outUidNovoPlano?.reference,
          ));
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: Text('Plano grátis'),
                content: Text('Contratado com sucesso!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext),
                    child: Text('Ok'),
                  ),
                ],
              );
            },
          );

          context.goNamed(DashboardTecnicoWidget.routeName);

          if (_shouldSetState) safeSetState(() {});
          return;
        }
        final paymentResponse = await processStripePayment(
          context,
          amount: () {
            if (_dropDownValue1 == 180) {
              return ((((_dropDownValue2!) * 6) -
                      (((_dropDownValue2!) * 6) * 0.1)))
                  .round();
            } else if (_dropDownValue1 == 365) {
              return ((((_dropDownValue2!) * 12) -
                      (((_dropDownValue2!) * 12) * 0.2)))
                  .round();
            } else {
              return _dropDownValue2!.round();
            }
          }(),
          currency: 'BRL',
          customerEmail: widget.email!,
          description: 'Assinatura Plano Técnico',
          allowGooglePay: false,
          allowApplePay: false,
        );
        if (paymentResponse.paymentId == null &&
            paymentResponse.errorMessage != null) {
          showSnackbar(
            context,
            'Pagamento não concluído. [Erro]: Por favor, tente novamente.',
          );
        }
        _outUidPayment = paymentResponse.paymentId ?? '';

        _shouldSetState = true;
        if (_outUidPayment != '0') {
          _outUidPlanoEscolhido = await queryPlanosTecnicosRecordOnce(
            queryBuilder: (planosTecnicosRecord) => planosTecnicosRecord.where(
              'preco',
              isEqualTo: _dropDownValue2,
            ),
            singleRecord: true,
          ).then((s) => s.firstOrNull);
          _shouldSetState = true;
          _outUidAssinaturaPlanoStripe = await queryAssinaturaTecnicoRecordOnce(
            queryBuilder: (assinaturaTecnicoRecord) =>
                assinaturaTecnicoRecord.where(
              'idTecnico',
              isEqualTo: widget.uidTecnico,
            ),
            singleRecord: true,
          ).then((s) => s.firstOrNull);
          _shouldSetState = true;
          _outUidAssinaturaAtivaStripe =
              await queryAssinaturaAtivaTecnicoRecordOnce(
            queryBuilder: (assinaturaAtivaTecnicoRecord) =>
                assinaturaAtivaTecnicoRecord.where(
              'idAssinaturaTecnico',
              isEqualTo: _outUidAssinaturaPlanoStripe?.reference,
            ),
            singleRecord: true,
          ).then((s) => s.firstOrNull);
          _shouldSetState = true;

          var assinaturaTecnicoRecordReference2 =
              AssinaturaTecnicoRecord.collection.doc();
          await assinaturaTecnicoRecordReference2
              .set(createAssinaturaTecnicoRecordData(
            idPlano: _outUidPlanoEscolhido?.reference,
            dtAssinatura: getCurrentTimestamp,
            tipoPlano: _dropDownValue1?.toString(),
            dtExpiracao: getCurrentTimestamp,
            idTecnico: widget.uidTecnico,
          ));
          _outUidNovoPlanoPago = AssinaturaTecnicoRecord.getDocumentFromData(
              createAssinaturaTecnicoRecordData(
                idPlano: _outUidPlanoEscolhido?.reference,
                dtAssinatura: getCurrentTimestamp,
                tipoPlano: _dropDownValue1?.toString(),
                dtExpiracao: getCurrentTimestamp,
                idTecnico: widget.uidTecnico,
              ),
              assinaturaTecnicoRecordReference2);
          _shouldSetState = true;

          await _outUidAssinaturaAtivaStripe!.reference
              .update(createAssinaturaAtivaTecnicoRecordData(
            tipoPlano: _dropDownValue1?.toString(),
            dtAssinatura: getCurrentTimestamp,
            dtExpiracao: getCurrentTimestamp,
            nomePlano: _outUidPlanoEscolhido?.nome,
            idAssinaturaTecnico: _outUidNovoPlanoPago?.reference,
          ));
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: Text('Parabéns!'),
                content: Text('Plano atualizado com sucesso!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext),
                    child: Text('Ok'),
                  ),
                ],
              );
            },
          );

          context.goNamed(DashboardTecnicoWidget.routeName);

          if (_shouldSetState) safeSetState(() {});
          return;
        } else {
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: Text('Opss, ocorreu um erro'),
                content: Text('Tente mais tarde novamente.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext),
                    child: Text('Ok'),
                  ),
                ],
              );
            },
          );
          if (_shouldSetState) safeSetState(() {});
          return;
        }
      },
      text: 'Confirmar e assinar',
      options: FFButtonOptions(
        width: double.infinity,
        height: 50.0,
        padding: EdgeInsets.all(0.0),
        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        color: Color(0xFFEC3B5B),
        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
            ),
        elevation: 2.0,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(50.0),
        hoverColor: FlutterFlowTheme.of(context).accent1,
        hoverBorderSide: BorderSide(
          color: FlutterFlowTheme.of(context).primary,
          width: 1.0,
        ),
        hoverTextColor: FlutterFlowTheme.of(context).primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PlanosTecnicosRecord>>(
      stream: queryPlanosTecnicosRecord(),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFF75E38),
                  ),
                ),
              ),
            ),
          );
        }
        List<PlanosTecnicosRecord>
            subscriptionPlanTecnicoPlanosTecnicosRecordList = snapshot.data!;

        return PopScope(
          canPop: false,
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(100.0),
              child: AppBar(
                backgroundColor: Color(0xFFF75E38),
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
              ),
            ),
            body: Align(
              alignment: AlignmentDirectional(0.0, -1.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _p2(context,
                        subscriptionPlanTecnicoPlanosTecnicosRecordList),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
