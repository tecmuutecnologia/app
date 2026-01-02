import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/pages/tecnico/propriedade/dignostico_gestacao/confirma_pp/confirma_pp_widget.dart';
import '/pages/tecnico/propriedade/dignostico_gestacao/dg_mais/dg_mais_widget.dart';
import '/pages/tecnico/propriedade/dignostico_gestacao/dg_menos/dg_menos_widget.dart';
import '/pages/tecnico/propriedade/exame_ginecologico/nova_acao_exame_ginecologico/nova_acao_exame_ginecologico_widget.dart';
import '/pages/tecnico/propriedade/inseminacoes/nova_inseminacao/nova_inseminacao_widget.dart';
import '/pages/tecnico/propriedade/prenhas/registrar_secagem/registrar_secagem_widget.dart';
import '/pages/tecnico/propriedade/prenhas/registro_aborto/registro_aborto_widget.dart';
import '/pages/tecnico/propriedade/recria/desmame/desmame_widget.dart';
import '/pages/tecnico/propriedade/secas/registrar_parto/registrar_parto_widget.dart';
import '/pages/tecnico/propriedade/secas/registrar_parto_induzido/registrar_parto_induzido_widget.dart';
import '/pages/tecnico/propriedade/secas/registrar_pre_parto/registrar_pre_parto_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flip_card/flip_card.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'listacompleta_copy_model.dart';
export 'listacompleta_copy_model.dart';

class ListacompletaCopyWidget extends StatefulWidget {
  const ListacompletaCopyWidget({
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

  static String routeName = 'listacompletaCopy';
  static String routePath = '/listacompletaCopy';

  @override
  State<ListacompletaCopyWidget> createState() =>
      _ListacompletaCopyWidgetState();
}

class _ListacompletaCopyWidgetState extends State<ListacompletaCopyWidget> {
  late ListacompletaCopyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListacompletaCopyModel());

    _model.searchListTextController ??= TextEditingController();
    _model.searchListFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
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
                            context.pushNamed(
                              InicioPropriedadeWidget.routeName,
                              queryParameters: {
                                'nomePropriedade': serializeParam(
                                  widget.nomePropriedade,
                                  ParamType.String,
                                ),
                                'uidPropriedade': serializeParam(
                                  widget.uidPropriedade,
                                  ParamType.DocumentReference,
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
                        ),
                      ),
                      Text(
                        'Lista completa',
                        style: FlutterFlowTheme.of(context)
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
                              color: Colors.white,
                              fontSize: 22.0,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .fontStyle,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              centerTitle: true,
              expandedTitleScale: 1.0,
            ),
            elevation: 0.0,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: 100.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                  child: Container(
                    width: 100.0,
                    height: 100.0,
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
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 8.0, 0.0),
                              child: TextFormField(
                                controller: _model.searchListTextController,
                                focusNode: _model.searchListFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.searchListTextController',
                                  Duration(milliseconds: 2000),
                                  () => safeSetState(() {}),
                                ),
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Pesquisa rápida...',
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          FlutterFlowTheme.of(context).tertiary,
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
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Color(0xFFE46D3A),
                                  ),
                                  suffixIcon: _model.searchListTextController!
                                          .text.isNotEmpty
                                      ? InkWell(
                                          onTap: () async {
                                            _model.searchListTextController
                                                ?.clear();
                                            safeSetState(() {});
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            color: Color(0xFF974E2D),
                                            size: 22,
                                          ),
                                        )
                                      : null,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.readexPro(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                validator: _model
                                    .searchListTextControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (alertDialogContext) {
                                  return AlertDialog(
                                    title: Text('Trabalhando nessa parte.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(alertDialogContext),
                                        child: Text('Ok'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            text: 'Buscar',
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).tertiary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                              elevation: 3.0,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                child: Text(
                  'Filtro por categoria:',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(15.0, 5.0, 15.0, 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                15.0, 5.0, 15.0, 15.0),
                            child: FlutterFlowChoiceChips(
                              options: [
                                ChipData('Inseminada'),
                                ChipData('Inseminada PP'),
                                ChipData('Vazia'),
                                ChipData('Prenha'),
                                ChipData('Pré Parto'),
                                ChipData('Seca'),
                                ChipData('Parto Induzido'),
                                ChipData('Todos')
                              ],
                              onChanged: (val) => safeSetState(() =>
                                  _model.choiceChipsValue = val?.firstOrNull),
                              selectedChipStyle: ChipStyle(
                                backgroundColor:
                                    FlutterFlowTheme.of(context).tertiary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.readexPro(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                iconColor:
                                    FlutterFlowTheme.of(context).primaryText,
                                iconSize: 18.0,
                                elevation: 4.0,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              unselectedChipStyle: ChipStyle(
                                backgroundColor:
                                    FlutterFlowTheme.of(context).alternate,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.readexPro(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                iconColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                                iconSize: 18.0,
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              chipSpacing: 12.0,
                              rowSpacing: 12.0,
                              multiselect: false,
                              initialized: _model.choiceChipsValue != null,
                              alignment: WrapAlignment.center,
                              controller: _model.choiceChipsValueController ??=
                                  FormFieldController<List<String>>(
                                ['Todos'],
                              ),
                              wrapped: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_model.choiceChipsValue == 'Todos')
                StreamBuilder<List<AnimaisProdutoresRecord>>(
                  stream: queryAnimaisProdutoresRecord(
                    parent: widget.uidTecnico,
                    queryBuilder: (animaisProdutoresRecord) =>
                        animaisProdutoresRecord
                            .where(
                              'uidTecnicoPropriedade',
                              isEqualTo: widget.uidPropriedade,
                            )
                            .orderBy('nomeAnimal')
                            .orderBy('brincoAnimalOrder'),
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
                    List<AnimaisProdutoresRecord>
                        listViewTodosChoiceAnimaisProdutoresRecordList =
                        snapshot.data!;

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount:
                          listViewTodosChoiceAnimaisProdutoresRecordList.length,
                      itemBuilder: (context, listViewTodosChoiceIndex) {
                        final listViewTodosChoiceAnimaisProdutoresRecord =
                            listViewTodosChoiceAnimaisProdutoresRecordList[
                                listViewTodosChoiceIndex];
                        return Visibility(
                          visible: ((listViewTodosChoiceAnimaisProdutoresRecord
                                          .grupoAnimal ==
                                      'Novilhas') ||
                                  (listViewTodosChoiceAnimaisProdutoresRecord
                                          .grupoAnimal ==
                                      'Vacas')) &&
                              (listViewTodosChoiceAnimaisProdutoresRecord
                                      .status !=
                                  'Descarte'),
                          child: FlipCard(
                            fill: Fill.fillBack,
                            direction: FlipDirection.VERTICAL,
                            speed: 400,
                            front: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 12.0, 16.0, 12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: GridView(
                                        padding: EdgeInsets.zero,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 0.0,
                                          mainAxisSpacing: 0.0,
                                          childAspectRatio: 2.0,
                                        ),
                                        primary: false,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 50.0,
                                                height: 50.0,
                                                decoration: BoxDecoration(
                                                  color: () {
                                                    if (listViewTodosChoiceAnimaisProdutoresRecord
                                                            .grupoAnimal ==
                                                        'Vacas') {
                                                      return Color(0xFF048508);
                                                    } else if (listViewTodosChoiceAnimaisProdutoresRecord
                                                            .grupoAnimal ==
                                                        'Novilhas') {
                                                      return Color(0xFFFF0076);
                                                    } else {
                                                      return Color(0x00000000);
                                                    }
                                                  }(),
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Text(
                                                  () {
                                                    if (listViewTodosChoiceAnimaisProdutoresRecord
                                                            .grupoAnimal ==
                                                        'Vacas') {
                                                      return 'VAC';
                                                    } else if (listViewTodosChoiceAnimaisProdutoresRecord
                                                            .grupoAnimal ==
                                                        'Novilhas') {
                                                      return 'NOV';
                                                    } else {
                                                      return 'N/C';
                                                    }
                                                  }(),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontStyle,
                                                        ),
                                                        color: Colors.white,
                                                        fontSize: 13.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${() {
                                                  if ((listViewTodosChoiceAnimaisProdutoresRecord
                                                                  .nomeAnimal !=
                                                              '') &&
                                                      (listViewTodosChoiceAnimaisProdutoresRecord
                                                              .brincoAnimal !=
                                                          null) &&
                                                      (listViewTodosChoiceAnimaisProdutoresRecord
                                                              .brincoAnimal !=
                                                          -1)) {
                                                    return '${listViewTodosChoiceAnimaisProdutoresRecord.nomeAnimal} - ${listViewTodosChoiceAnimaisProdutoresRecord.brincoAnimal.toString()}';
                                                  } else if (listViewTodosChoiceAnimaisProdutoresRecord
                                                              .nomeAnimal !=
                                                          '') {
                                                    return listViewTodosChoiceAnimaisProdutoresRecord
                                                        .nomeAnimal;
                                                  } else {
                                                    return listViewTodosChoiceAnimaisProdutoresRecord
                                                        .brincoAnimal
                                                        .toString();
                                                  }
                                                }()} - ${listViewTodosChoiceAnimaisProdutoresRecord.status}',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyLarge
                                                    .override(
                                                      font:
                                                          GoogleFonts.readexPro(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontStyle,
                                                      ),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(5.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Icon(
                                                      Icons.add_circle_sharp,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .tertiary,
                                                      size: 30.0,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  5.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          context.pushNamed(
                                                            ProntuarioAnimalWidget
                                                                .routeName,
                                                            queryParameters: {
                                                              'uidPropriedade':
                                                                  serializeParam(
                                                                widget
                                                                    .uidPropriedade,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                              'nomePropriedade':
                                                                  serializeParam(
                                                                widget
                                                                    .nomePropriedade,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'uidTecnico':
                                                                  serializeParam(
                                                                widget
                                                                    .uidTecnico,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                              'emailPropriedade':
                                                                  serializeParam(
                                                                widget
                                                                    .emailPropriedade,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'uidAnimaisProdutores':
                                                                  serializeParam(
                                                                listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                              'grupoPredominante':
                                                                  serializeParam(
                                                                listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .grupoAnimal,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'visitaPresencial':
                                                                  serializeParam(
                                                                widget
                                                                    .visitaPresencial,
                                                                ParamType.bool,
                                                              ),
                                                              'diasDg':
                                                                  serializeParam(
                                                                widget.diasDg,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        },
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .pollH,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .tertiary,
                                                          size: 30.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  if ((listViewTodosChoiceAnimaisProdutoresRecord
                                                                  .dtUltimaAcao !=
                                                              '') &&
                                                      (functions.verificaDataAcaoDataAtual(
                                                              listViewTodosChoiceAnimaisProdutoresRecord
                                                                  .dtUltimaAcao) ==
                                                          true))
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  5.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Icon(
                                                        Icons.check_circle,
                                                        color:
                                                            Color(0xFF048508),
                                                        size: 30.0,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            back: ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: [
                                if ((listViewTodosChoiceAnimaisProdutoresRecord
                                            .status ==
                                        'Vazia') &&
                                    ((listViewTodosChoiceAnimaisProdutoresRecord
                                                .grupoAnimal ==
                                            'Terneiras') ||
                                        (listViewTodosChoiceAnimaisProdutoresRecord
                                                .grupoAnimal ==
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 5.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'Data nascimento: ${listViewTodosChoiceAnimaisProdutoresRecord.dtNascimento}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 5.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child: DesmameWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
                                                                    .emailPropriedade!,
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            diasDg:
                                                                widget.diasDg!,
                                                            uidAnimaisProdutores:
                                                                listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                            nomeAnimal:
                                                                listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .nomeAnimal,
                                                            brincoAnimal:
                                                                listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .brincoAnimal
                                                                    .toString(),
                                                            grupoAnimal:
                                                                listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .grupoAnimal,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Desmamar',
                                                icon: Icon(
                                                  Icons.pause,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 25.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          24.0, 0.0, 24.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFF048508),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                NovaAcaoExameGinecologicoWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                              uidAnimaisProdutores:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              nomeAnimal:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              brincoAnimal:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .brincoAnimal
                                                                      .toString(),
                                                              grupoAnimal:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Ação',
                                                  icon: Icon(
                                                    Icons.add_alert,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 100.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF1A03E9),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 4.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              if ((listViewTodosChoiceAnimaisProdutoresRecord
                                                          .status ==
                                                      'Inseminada') ||
                                                  (listViewTodosChoiceAnimaisProdutoresRecord
                                                          .status ==
                                                      'Inseminada PP'))
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          10.0, 0.0, 0.0, 0.0),
                                                  child: Icon(
                                                    Icons.check_sharp,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .success,
                                                    size: 24.0,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if ((listViewTodosChoiceAnimaisProdutoresRecord
                                            .status ==
                                        'Vazia') &&
                                    ((listViewTodosChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiras') &&
                                        (listViewTodosChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 5.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'DEL: ${listViewTodosChoiceAnimaisProdutoresRecord.dtUltimoParto != '' ? functions.calcularDiferencaEmDias(listViewTodosChoiceAnimaisProdutoresRecord.dtUltimoParto).toString() : 'N/D'}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                  Text(
                                                    'Último parto: ${listViewTodosChoiceAnimaisProdutoresRecord.dtUltimoPartoContingencia}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 5.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 10.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                NovaInseminacaoWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              uidAnimaisProdutores:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              grupoPredominante:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                              nomeAnimal:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              dtUltimaInseminacao:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .dtUltimaInseminacao,
                                                              brincoAnimal:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .brincoAnimal
                                                                      .toString(),
                                                              diasDg: widget
                                                                  .diasDg!,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Inseminar',
                                                  icon: Icon(
                                                    Icons.playlist_add,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(24.0, 0.0,
                                                                24.0, 0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF7E39EF),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              NovaAcaoExameGinecologicoWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
                                                                    .emailPropriedade!,
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            diasDg:
                                                                widget.diasDg!,
                                                            uidAnimaisProdutores:
                                                                listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                            nomeAnimal:
                                                                listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .nomeAnimal,
                                                            brincoAnimal:
                                                                listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .brincoAnimal
                                                                    .toString(),
                                                            grupoAnimal:
                                                                listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .grupoAnimal,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Ação',
                                                icon: Icon(
                                                  Icons.add_alert,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 100.0,
                                                  height: 25.0,
                                                  padding: EdgeInsets.all(0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFF1A03E9),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 4.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              if ((listViewTodosChoiceAnimaisProdutoresRecord
                                                          .status ==
                                                      'Inseminada') ||
                                                  (listViewTodosChoiceAnimaisProdutoresRecord
                                                          .status ==
                                                      'Inseminada PP'))
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          10.0, 0.0, 0.0, 0.0),
                                                  child: Icon(
                                                    Icons.check_sharp,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .success,
                                                    size: 24.0,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if ((listViewTodosChoiceAnimaisProdutoresRecord
                                            .status ==
                                        'Pré Parto') &&
                                    ((listViewTodosChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiras') &&
                                        (listViewTodosChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Inseminada em: ${listViewTodosChoiceAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Pré parto prev.: ${listViewTodosChoiceAnimaisProdutoresRecord.dtPrePartoPrevista}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Parto previsto: ${listViewTodosChoiceAnimaisProdutoresRecord.dtPartoPrevisto}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FFButtonWidget(
                                              onPressed: () async {
                                                await showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  enableDrag: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                      },
                                                      child: Padding(
                                                        padding: MediaQuery
                                                            .viewInsetsOf(
                                                                context),
                                                        child:
                                                            RegistrarPartoWidget(
                                                          uidPropriedade: widget
                                                              .uidPropriedade!,
                                                          nomePropriedade: widget
                                                              .nomePropriedade!,
                                                          uidTecnico: widget
                                                              .uidTecnico!,
                                                          emailPropriedade: widget
                                                              .emailPropriedade!,
                                                          visitaPresencial: widget
                                                              .visitaPresencial!,
                                                          diasDg:
                                                              widget.diasDg!,
                                                          uidAnimaisProdutores:
                                                              listViewTodosChoiceAnimaisProdutoresRecord
                                                                  .reference,
                                                          nomeVacaAtual:
                                                              listViewTodosChoiceAnimaisProdutoresRecord
                                                                  .nomeAnimal,
                                                          nomeTourtoUltimaInseminacao:
                                                              listViewTodosChoiceAnimaisProdutoresRecord
                                                                  .nomeTouroUltimaInseminacao,
                                                          brincoVacaAtual:
                                                              listViewTodosChoiceAnimaisProdutoresRecord
                                                                  .brincoAnimal
                                                                  .toString(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).then((value) =>
                                                    safeSetState(() {}));
                                              },
                                              text: 'Parto',
                                              icon: Icon(
                                                Icons.add_alert,
                                                size: 15.0,
                                              ),
                                              options: FFButtonOptions(
                                                width: 100.0,
                                                height: 25.0,
                                                padding: EdgeInsets.all(0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color: Color(0xFF12BE24),
                                                textStyle: FlutterFlowTheme.of(
                                                        context)
                                                    .titleSmall
                                                    .override(
                                                      font:
                                                          GoogleFonts.readexPro(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontStyle,
                                                      ),
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontStyle,
                                                    ),
                                                elevation: 3.0,
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      10.0, 0.0, 0.0, 0.0),
                                              child: FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              RegistroAbortoWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
                                                                    .emailPropriedade!,
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            diasDg:
                                                                widget.diasDg!,
                                                            uidAnimaisProdutores:
                                                                listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                            nomeAnimal:
                                                                listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .nomeAnimal,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Aborto',
                                                icon: Icon(
                                                  Icons.cancel_sharp,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 100.0,
                                                  height: 25.0,
                                                  padding: EdgeInsets.all(0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFFAE0303),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                if ((listViewTodosChoiceAnimaisProdutoresRecord
                                            .status ==
                                        'Prenha') &&
                                    (listViewTodosChoiceAnimaisProdutoresRecord
                                            .grupoAnimal ==
                                        'Novilhas') &&
                                    ((listViewTodosChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiras') &&
                                        (listViewTodosChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Inseminada em: ${listViewTodosChoiceAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Pré parto prev.: ${listViewTodosChoiceAnimaisProdutoresRecord.dtPrePartoPrevista}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Parto previsto: ${listViewTodosChoiceAnimaisProdutoresRecord.dtPartoPrevisto}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 5.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              RegistroAbortoWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
                                                                    .emailPropriedade!,
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            diasDg:
                                                                widget.diasDg!,
                                                            uidAnimaisProdutores:
                                                                listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                            nomeAnimal:
                                                                listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .nomeAnimal,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Aborto',
                                                icon: Icon(
                                                  Icons.cancel_sharp,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 100.0,
                                                  height: 25.0,
                                                  padding: EdgeInsets.all(0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFFAE0303),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                RegistrarPartoWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                              uidAnimaisProdutores:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              nomeVacaAtual:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              nomeTourtoUltimaInseminacao:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .nomeTouroUltimaInseminacao,
                                                              brincoVacaAtual:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .brincoAnimal
                                                                      .toString(),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Parto',
                                                  icon: Icon(
                                                    Icons.add_alert,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 100.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF12BE24),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                RegistrarPrePartoWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                              uidAnimaisProdutores:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              nomeAnimal:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              brincoAnimal:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .brincoAnimalOrder
                                                                      .toString(),
                                                              grupoAnimal:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                              dtPrePartoPrevista:
                                                                  functions.converteDataStringDate(
                                                                      listViewTodosChoiceAnimaisProdutoresRecord
                                                                          .dtPrePartoPrevista),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Pré-parto',
                                                  icon: Icon(
                                                    Icons.check,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 100.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF1A03E9),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if ((listViewTodosChoiceAnimaisProdutoresRecord
                                            .status ==
                                        'Seca') &&
                                    (listViewTodosChoiceAnimaisProdutoresRecord
                                            .grupoAnimal ==
                                        'Vacas') &&
                                    ((listViewTodosChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiras') &&
                                        (listViewTodosChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Inseminada em: ${listViewTodosChoiceAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Pré parto prev.: ${listViewTodosChoiceAnimaisProdutoresRecord.dtPrePartoPrevista}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Parto previsto: ${listViewTodosChoiceAnimaisProdutoresRecord.dtPartoPrevisto}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 5.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              RegistrarPartoWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
                                                                    .emailPropriedade!,
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            diasDg:
                                                                widget.diasDg!,
                                                            uidAnimaisProdutores:
                                                                listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                            nomeVacaAtual:
                                                                listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .nomeAnimal,
                                                            nomeTourtoUltimaInseminacao:
                                                                listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .nomeTouroUltimaInseminacao,
                                                            brincoVacaAtual:
                                                                listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .brincoAnimal
                                                                    .toString(),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Parto',
                                                icon: Icon(
                                                  Icons.add_alert,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 100.0,
                                                  height: 25.0,
                                                  padding: EdgeInsets.all(0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFF12BE24),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 10.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                RegistrarPrePartoWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                              uidAnimaisProdutores:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              nomeAnimal:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              brincoAnimal:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .brincoAnimalOrder
                                                                      .toString(),
                                                              grupoAnimal:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                              dtPrePartoPrevista:
                                                                  functions.converteDataStringDate(
                                                                      listViewTodosChoiceAnimaisProdutoresRecord
                                                                          .dtPrePartoPrevista),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Pré-parto',
                                                  icon: Icon(
                                                    Icons.check,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 100.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF1A03E9),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              RegistroAbortoWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
                                                                    .emailPropriedade!,
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            diasDg:
                                                                widget.diasDg!,
                                                            uidAnimaisProdutores:
                                                                listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                            nomeAnimal:
                                                                listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .nomeAnimal,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Aborto',
                                                icon: Icon(
                                                  Icons.cancel_sharp,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 100.0,
                                                  height: 25.0,
                                                  padding: EdgeInsets.all(0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFFAE0303),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if ((listViewTodosChoiceAnimaisProdutoresRecord
                                            .status ==
                                        'Prenha') &&
                                    (listViewTodosChoiceAnimaisProdutoresRecord
                                            .grupoAnimal ==
                                        'Vacas') &&
                                    ((listViewTodosChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiras') &&
                                        (listViewTodosChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Inseminada em: ${listViewTodosChoiceAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Pré parto prev.: ${listViewTodosChoiceAnimaisProdutoresRecord.dtPrePartoPrevista}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Parto previsto: ${listViewTodosChoiceAnimaisProdutoresRecord.dtPartoPrevisto}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 5.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 4.0, 10.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                RegistroAbortoWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                              uidAnimaisProdutores:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              nomeAnimal:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Aborto',
                                                  icon: Icon(
                                                    Icons
                                                        .check_circle_outline_sharp,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 100.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFFAE0303),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 4.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                RegistrarSecagemWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                              uidAnimaisProdutores:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              nomeAnimal:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              brincoAnimal:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .brincoAnimalOrder
                                                                      .toString(),
                                                              grupoAnimal:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                              dtSecPrevista: functions
                                                                  .converteDataStringDate(
                                                                      listViewTodosChoiceAnimaisProdutoresRecord
                                                                          .dtSecPrevista),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Secagem',
                                                  icon: Icon(
                                                    Icons.cancel_rounded,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 100.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFFE9AB05),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (((listViewTodosChoiceAnimaisProdutoresRecord
                                                .status ==
                                            'Inseminada PP') ||
                                        (listViewTodosChoiceAnimaisProdutoresRecord
                                                .status ==
                                            'Inseminada')) &&
                                    ((listViewTodosChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiras') &&
                                        (listViewTodosChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Inseminada em: ${listViewTodosChoiceAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 5.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FFButtonWidget(
                                                onPressed: ((listViewTodosChoiceAnimaisProdutoresRecord
                                                                .status !=
                                                            'Inseminada PP') &&
                                                        (listViewTodosChoiceAnimaisProdutoresRecord
                                                                    .dtPP ==
                                                                ''))
                                                    ? null
                                                    : () async {
                                                        await showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          enableDrag: false,
                                                          context: context,
                                                          builder: (context) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                FocusScope.of(
                                                                        context)
                                                                    .unfocus();
                                                                FocusManager
                                                                    .instance
                                                                    .primaryFocus
                                                                    ?.unfocus();
                                                              },
                                                              child: Padding(
                                                                padding: MediaQuery
                                                                    .viewInsetsOf(
                                                                        context),
                                                                child:
                                                                    DgMaisWidget(
                                                                  uidPropriedade:
                                                                      widget
                                                                          .uidPropriedade!,
                                                                  nomePropriedade:
                                                                      widget
                                                                          .nomePropriedade!,
                                                                  uidTecnico:
                                                                      widget
                                                                          .uidTecnico!,
                                                                  emailPropriedade:
                                                                      widget
                                                                          .emailPropriedade!,
                                                                  uidAnimaisProdutores:
                                                                      listViewTodosChoiceAnimaisProdutoresRecord
                                                                          .reference,
                                                                  grupoPredominante:
                                                                      listViewTodosChoiceAnimaisProdutoresRecord
                                                                          .grupoAnimal,
                                                                  nomeAnimal:
                                                                      listViewTodosChoiceAnimaisProdutoresRecord
                                                                          .nomeAnimal,
                                                                  visitaPresencial:
                                                                      widget
                                                                          .visitaPresencial!,
                                                                  diasDg: widget
                                                                      .diasDg!,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ).then((value) =>
                                                            safeSetState(
                                                                () {}));
                                                      },
                                                text: 'DG +',
                                                icon: Icon(
                                                  Icons.check_circle,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 80.0,
                                                  height: 25.0,
                                                  padding: EdgeInsets.all(0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFF00FF09),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  disabledColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primaryBackground,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                ConfirmaPpWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              uidAnimaisProdutores:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              grupoPredominante:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                              nomeAnimal:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'PP',
                                                  icon: Icon(
                                                    Icons.notifications,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 80.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF1A03E9),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 4.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                DgMenosWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              uidAnimaisProdutores:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              grupoPredominante:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                              nomeAnimal:
                                                                  listViewTodosChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'DG -',
                                                  icon: Icon(
                                                    Icons.cancel_rounded,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 80.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFFAE0303),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              if (_model.choiceChipsValue == 'Parto Induzido')
                StreamBuilder<List<AnimaisProdutoresRecord>>(
                  stream: queryAnimaisProdutoresRecord(
                    parent: widget.uidTecnico,
                    queryBuilder: (animaisProdutoresRecord) =>
                        animaisProdutoresRecord
                            .where(
                              'uidTecnicoPropriedade',
                              isEqualTo: widget.uidPropriedade,
                            )
                            .where(
                              'status',
                              isEqualTo: 'Vazia',
                            )
                            .orderBy('nomeAnimal')
                            .orderBy('brincoAnimalOrder'),
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
                    List<AnimaisProdutoresRecord>
                        listViewPartoInduzidoChoiceAnimaisProdutoresRecordList =
                        snapshot.data!;

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount:
                          listViewPartoInduzidoChoiceAnimaisProdutoresRecordList
                              .length,
                      itemBuilder: (context, listViewPartoInduzidoChoiceIndex) {
                        final listViewPartoInduzidoChoiceAnimaisProdutoresRecord =
                            listViewPartoInduzidoChoiceAnimaisProdutoresRecordList[
                                listViewPartoInduzidoChoiceIndex];
                        return Visibility(
                          visible: ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord.grupoAnimal ==
                                      'Novilhas') ||
                                  (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                          .grupoAnimal ==
                                      'Vacas')) &&
                              (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                      .status !=
                                  'Descarte') &&
                              (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                      .dtInducaoLactacao !=
                                  null),
                          child: FlipCard(
                            fill: Fill.fillBack,
                            direction: FlipDirection.VERTICAL,
                            speed: 400,
                            front: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 12.0, 16.0, 12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: GridView(
                                        padding: EdgeInsets.zero,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 0.0,
                                          mainAxisSpacing: 0.0,
                                          childAspectRatio: 2.0,
                                        ),
                                        primary: false,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 50.0,
                                                height: 50.0,
                                                decoration: BoxDecoration(
                                                  color: () {
                                                    if (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                            .grupoAnimal ==
                                                        'Vacas') {
                                                      return Color(0xFF048508);
                                                    } else if (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                            .grupoAnimal ==
                                                        'Novilhas') {
                                                      return Color(0xFFFF0076);
                                                    } else {
                                                      return Color(0x00000000);
                                                    }
                                                  }(),
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Text(
                                                  () {
                                                    if (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                            .grupoAnimal ==
                                                        'Vacas') {
                                                      return 'VAC';
                                                    } else if (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                            .grupoAnimal ==
                                                        'Novilhas') {
                                                      return 'NOV';
                                                    } else {
                                                      return 'N/C';
                                                    }
                                                  }(),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontStyle,
                                                        ),
                                                        color: Colors.white,
                                                        fontSize: 13.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${() {
                                                  if ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                  .nomeAnimal !=
                                                              '') &&
                                                      (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                              .brincoAnimal !=
                                                          null) &&
                                                      (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                              .brincoAnimal !=
                                                          -1)) {
                                                    return '${listViewPartoInduzidoChoiceAnimaisProdutoresRecord.nomeAnimal} - ${listViewPartoInduzidoChoiceAnimaisProdutoresRecord.brincoAnimal.toString()}';
                                                  } else if (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                              .nomeAnimal !=
                                                          '') {
                                                    return listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                        .nomeAnimal;
                                                  } else {
                                                    return listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                        .brincoAnimal
                                                        .toString();
                                                  }
                                                }()} - ${listViewPartoInduzidoChoiceAnimaisProdutoresRecord.status}',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyLarge
                                                    .override(
                                                      font:
                                                          GoogleFonts.readexPro(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontStyle,
                                                      ),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(5.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Icon(
                                                      Icons.add_circle_sharp,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .tertiary,
                                                      size: 30.0,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  5.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          context.pushNamed(
                                                            ProntuarioAnimalWidget
                                                                .routeName,
                                                            queryParameters: {
                                                              'uidPropriedade':
                                                                  serializeParam(
                                                                widget
                                                                    .uidPropriedade,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                              'nomePropriedade':
                                                                  serializeParam(
                                                                widget
                                                                    .nomePropriedade,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'uidTecnico':
                                                                  serializeParam(
                                                                widget
                                                                    .uidTecnico,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                              'emailPropriedade':
                                                                  serializeParam(
                                                                widget
                                                                    .emailPropriedade,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'uidAnimaisProdutores':
                                                                  serializeParam(
                                                                listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                              'grupoPredominante':
                                                                  serializeParam(
                                                                listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .grupoAnimal,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'visitaPresencial':
                                                                  serializeParam(
                                                                widget
                                                                    .visitaPresencial,
                                                                ParamType.bool,
                                                              ),
                                                              'diasDg':
                                                                  serializeParam(
                                                                widget.diasDg,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        },
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .pollH,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .tertiary,
                                                          size: 30.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  if ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                  .dtUltimaAcao !=
                                                              '') &&
                                                      (functions.verificaDataAcaoDataAtual(
                                                              listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                  .dtUltimaAcao) ==
                                                          true))
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  5.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Icon(
                                                        Icons.check_circle,
                                                        color:
                                                            Color(0xFF048508),
                                                        size: 30.0,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            back: ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: [
                                if ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                            .status ==
                                        'Vazia') &&
                                    (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                            .dtInducaoLactacao !=
                                        null))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 5.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'Indução lactação:${listViewPartoInduzidoChoiceAnimaisProdutoresRecord.dtPartoPrevisto}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 5.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 4.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                RegistrarPartoInduzidoWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                              uidAnimaisProdutores:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              nomeAnimal: listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                              .nomeAnimal !=
                                                                          ''
                                                                  ? listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal
                                                                  : listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .brincoAnimal
                                                                      .toString(),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Induzir lactação',
                                                  icon: Icon(
                                                    Icons.add_alert,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 140.0,
                                                    height: 40.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF12BE24),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              if ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                          .status ==
                                                      'Inseminada') ||
                                                  (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                          .status ==
                                                      'Inseminada PP'))
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          10.0, 0.0, 0.0, 0.0),
                                                  child: Icon(
                                                    Icons.check_sharp,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .success,
                                                    size: 24.0,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                            .status ==
                                        'Vazia') &&
                                    ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                .grupoAnimal ==
                                            'Terneiras') ||
                                        (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                .grupoAnimal ==
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 5.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'Data nascimento: ${listViewPartoInduzidoChoiceAnimaisProdutoresRecord.dtNascimento}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 5.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child: DesmameWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
                                                                    .emailPropriedade!,
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            diasDg:
                                                                widget.diasDg!,
                                                            uidAnimaisProdutores:
                                                                listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                            nomeAnimal:
                                                                listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .nomeAnimal,
                                                            brincoAnimal:
                                                                listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .brincoAnimal
                                                                    .toString(),
                                                            grupoAnimal:
                                                                listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .grupoAnimal,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Desmamar',
                                                icon: Icon(
                                                  Icons.pause,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 25.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          24.0, 0.0, 24.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFF048508),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                NovaAcaoExameGinecologicoWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                              uidAnimaisProdutores:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              nomeAnimal:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              brincoAnimal:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .brincoAnimal
                                                                      .toString(),
                                                              grupoAnimal:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Ação',
                                                  icon: Icon(
                                                    Icons.add_alert,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 100.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF1A03E9),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 4.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              if ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                          .status ==
                                                      'Inseminada') ||
                                                  (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                          .status ==
                                                      'Inseminada PP'))
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          10.0, 0.0, 0.0, 0.0),
                                                  child: Icon(
                                                    Icons.check_sharp,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .success,
                                                    size: 24.0,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                            .status ==
                                        'Vazia') &&
                                    ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiras') &&
                                        (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 5.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'DEL: ${listViewPartoInduzidoChoiceAnimaisProdutoresRecord.dtUltimoParto != '' ? functions.calcularDiferencaEmDias(listViewPartoInduzidoChoiceAnimaisProdutoresRecord.dtUltimoParto).toString() : 'N/D'}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                  Text(
                                                    'Último parto: ${listViewPartoInduzidoChoiceAnimaisProdutoresRecord.dtUltimoPartoContingencia}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 5.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 10.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                NovaInseminacaoWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              uidAnimaisProdutores:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              grupoPredominante:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                              nomeAnimal:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              dtUltimaInseminacao:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .dtUltimaInseminacao,
                                                              brincoAnimal:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .brincoAnimal
                                                                      .toString(),
                                                              diasDg: widget
                                                                  .diasDg!,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Inseminar',
                                                  icon: Icon(
                                                    Icons.playlist_add,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(24.0, 0.0,
                                                                24.0, 0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF7E39EF),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              NovaAcaoExameGinecologicoWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
                                                                    .emailPropriedade!,
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            diasDg:
                                                                widget.diasDg!,
                                                            uidAnimaisProdutores:
                                                                listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                            nomeAnimal:
                                                                listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .nomeAnimal,
                                                            brincoAnimal:
                                                                listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .brincoAnimal
                                                                    .toString(),
                                                            grupoAnimal:
                                                                listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .grupoAnimal,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Ação',
                                                icon: Icon(
                                                  Icons.add_alert,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 100.0,
                                                  height: 25.0,
                                                  padding: EdgeInsets.all(0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFF1A03E9),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 4.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              if ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                          .status ==
                                                      'Inseminada') ||
                                                  (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                          .status ==
                                                      'Inseminada PP'))
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          10.0, 0.0, 0.0, 0.0),
                                                  child: Icon(
                                                    Icons.check_sharp,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .success,
                                                    size: 24.0,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                            .status ==
                                        'Pré Parto') &&
                                    ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiras') &&
                                        (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Inseminada em: ${listViewPartoInduzidoChoiceAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Pré parto prev.: ${listViewPartoInduzidoChoiceAnimaisProdutoresRecord.dtPrePartoPrevista}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Parto previsto: ${listViewPartoInduzidoChoiceAnimaisProdutoresRecord.dtPartoPrevisto}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FFButtonWidget(
                                              onPressed: () async {
                                                await showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  enableDrag: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                      },
                                                      child: Padding(
                                                        padding: MediaQuery
                                                            .viewInsetsOf(
                                                                context),
                                                        child:
                                                            RegistrarPartoWidget(
                                                          uidPropriedade: widget
                                                              .uidPropriedade!,
                                                          nomePropriedade: widget
                                                              .nomePropriedade!,
                                                          uidTecnico: widget
                                                              .uidTecnico!,
                                                          emailPropriedade: widget
                                                              .emailPropriedade!,
                                                          visitaPresencial: widget
                                                              .visitaPresencial!,
                                                          diasDg:
                                                              widget.diasDg!,
                                                          uidAnimaisProdutores:
                                                              listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                  .reference,
                                                          nomeVacaAtual:
                                                              listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                  .nomeAnimal,
                                                          nomeTourtoUltimaInseminacao:
                                                              listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                  .nomeTouroUltimaInseminacao,
                                                          brincoVacaAtual:
                                                              listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                  .brincoAnimal
                                                                  .toString(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).then((value) =>
                                                    safeSetState(() {}));
                                              },
                                              text: 'Parto',
                                              icon: Icon(
                                                Icons.add_alert,
                                                size: 15.0,
                                              ),
                                              options: FFButtonOptions(
                                                width: 100.0,
                                                height: 25.0,
                                                padding: EdgeInsets.all(0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color: Color(0xFF12BE24),
                                                textStyle: FlutterFlowTheme.of(
                                                        context)
                                                    .titleSmall
                                                    .override(
                                                      font:
                                                          GoogleFonts.readexPro(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontStyle,
                                                      ),
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontStyle,
                                                    ),
                                                elevation: 3.0,
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      10.0, 0.0, 0.0, 0.0),
                                              child: FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              RegistroAbortoWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
                                                                    .emailPropriedade!,
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            diasDg:
                                                                widget.diasDg!,
                                                            uidAnimaisProdutores:
                                                                listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                            nomeAnimal:
                                                                listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .nomeAnimal,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Aborto',
                                                icon: Icon(
                                                  Icons.cancel_sharp,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 100.0,
                                                  height: 25.0,
                                                  padding: EdgeInsets.all(0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFFAE0303),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                if ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                            .status ==
                                        'Prenha') &&
                                    (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                            .grupoAnimal ==
                                        'Novilhas') &&
                                    ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiras') &&
                                        (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Inseminada em: ${listViewPartoInduzidoChoiceAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Pré parto prev.: ${listViewPartoInduzidoChoiceAnimaisProdutoresRecord.dtPrePartoPrevista}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Parto previsto: ${listViewPartoInduzidoChoiceAnimaisProdutoresRecord.dtPartoPrevisto}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 5.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              RegistroAbortoWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
                                                                    .emailPropriedade!,
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            diasDg:
                                                                widget.diasDg!,
                                                            uidAnimaisProdutores:
                                                                listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                            nomeAnimal:
                                                                listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .nomeAnimal,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Aborto',
                                                icon: Icon(
                                                  Icons.cancel_sharp,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 100.0,
                                                  height: 25.0,
                                                  padding: EdgeInsets.all(0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFFAE0303),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                RegistrarPartoWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                              uidAnimaisProdutores:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              nomeVacaAtual:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              nomeTourtoUltimaInseminacao:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .nomeTouroUltimaInseminacao,
                                                              brincoVacaAtual:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .brincoAnimal
                                                                      .toString(),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Parto',
                                                  icon: Icon(
                                                    Icons.add_alert,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 100.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF12BE24),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                RegistrarPrePartoWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                              uidAnimaisProdutores:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              nomeAnimal:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              brincoAnimal:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .brincoAnimalOrder
                                                                      .toString(),
                                                              grupoAnimal:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                              dtPrePartoPrevista:
                                                                  functions.converteDataStringDate(
                                                                      listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                          .dtPrePartoPrevista),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Pré-parto',
                                                  icon: Icon(
                                                    Icons.check,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 100.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF1A03E9),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                            .status ==
                                        'Seca') &&
                                    (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                            .grupoAnimal ==
                                        'Vacas') &&
                                    ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiras') &&
                                        (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Inseminada em: ${listViewPartoInduzidoChoiceAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Pré parto prev.: ${listViewPartoInduzidoChoiceAnimaisProdutoresRecord.dtPrePartoPrevista}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Parto previsto: ${listViewPartoInduzidoChoiceAnimaisProdutoresRecord.dtPartoPrevisto}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 5.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              RegistrarPartoWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
                                                                    .emailPropriedade!,
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            diasDg:
                                                                widget.diasDg!,
                                                            uidAnimaisProdutores:
                                                                listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                            nomeVacaAtual:
                                                                listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .nomeAnimal,
                                                            nomeTourtoUltimaInseminacao:
                                                                listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .nomeTouroUltimaInseminacao,
                                                            brincoVacaAtual:
                                                                listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .brincoAnimal
                                                                    .toString(),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Parto',
                                                icon: Icon(
                                                  Icons.add_alert,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 100.0,
                                                  height: 25.0,
                                                  padding: EdgeInsets.all(0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFF12BE24),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 10.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                RegistrarPrePartoWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                              uidAnimaisProdutores:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              nomeAnimal:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              brincoAnimal:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .brincoAnimalOrder
                                                                      .toString(),
                                                              grupoAnimal:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                              dtPrePartoPrevista:
                                                                  functions.converteDataStringDate(
                                                                      listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                          .dtPrePartoPrevista),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Pré-parto',
                                                  icon: Icon(
                                                    Icons.check,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 100.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF1A03E9),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              RegistroAbortoWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
                                                                    .emailPropriedade!,
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            diasDg:
                                                                widget.diasDg!,
                                                            uidAnimaisProdutores:
                                                                listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                            nomeAnimal:
                                                                listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .nomeAnimal,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Aborto',
                                                icon: Icon(
                                                  Icons.cancel_sharp,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 100.0,
                                                  height: 25.0,
                                                  padding: EdgeInsets.all(0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFFAE0303),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                            .status ==
                                        'Prenha') &&
                                    (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                            .grupoAnimal ==
                                        'Vacas') &&
                                    ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiras') &&
                                        (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Inseminada em: ${listViewPartoInduzidoChoiceAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Pré parto prev.: ${listViewPartoInduzidoChoiceAnimaisProdutoresRecord.dtPrePartoPrevista}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Parto previsto: ${listViewPartoInduzidoChoiceAnimaisProdutoresRecord.dtPartoPrevisto}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 5.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 4.0, 10.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                RegistroAbortoWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                              uidAnimaisProdutores:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              nomeAnimal:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Aborto',
                                                  icon: Icon(
                                                    Icons
                                                        .check_circle_outline_sharp,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 100.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFFAE0303),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 4.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                RegistrarSecagemWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                              uidAnimaisProdutores:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              nomeAnimal:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              brincoAnimal:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .brincoAnimalOrder
                                                                      .toString(),
                                                              grupoAnimal:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                              dtSecPrevista: functions
                                                                  .converteDataStringDate(
                                                                      listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                          .dtSecPrevista),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Secagem',
                                                  icon: Icon(
                                                    Icons.cancel_rounded,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 100.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFFE9AB05),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                .status ==
                                            'Inseminada PP') ||
                                        (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                .status ==
                                            'Inseminada')) &&
                                    ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiras') &&
                                        (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Inseminada em: ${listViewPartoInduzidoChoiceAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 5.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FFButtonWidget(
                                                onPressed: ((listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                .status !=
                                                            'Inseminada PP') &&
                                                        (listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                    .dtPP ==
                                                                ''))
                                                    ? null
                                                    : () async {
                                                        await showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          enableDrag: false,
                                                          context: context,
                                                          builder: (context) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                FocusScope.of(
                                                                        context)
                                                                    .unfocus();
                                                                FocusManager
                                                                    .instance
                                                                    .primaryFocus
                                                                    ?.unfocus();
                                                              },
                                                              child: Padding(
                                                                padding: MediaQuery
                                                                    .viewInsetsOf(
                                                                        context),
                                                                child:
                                                                    DgMaisWidget(
                                                                  uidPropriedade:
                                                                      widget
                                                                          .uidPropriedade!,
                                                                  nomePropriedade:
                                                                      widget
                                                                          .nomePropriedade!,
                                                                  uidTecnico:
                                                                      widget
                                                                          .uidTecnico!,
                                                                  emailPropriedade:
                                                                      widget
                                                                          .emailPropriedade!,
                                                                  uidAnimaisProdutores:
                                                                      listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                          .reference,
                                                                  grupoPredominante:
                                                                      listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                          .grupoAnimal,
                                                                  nomeAnimal:
                                                                      listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                          .nomeAnimal,
                                                                  visitaPresencial:
                                                                      widget
                                                                          .visitaPresencial!,
                                                                  diasDg: widget
                                                                      .diasDg!,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ).then((value) =>
                                                            safeSetState(
                                                                () {}));
                                                      },
                                                text: 'DG +',
                                                icon: Icon(
                                                  Icons.check_circle,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 80.0,
                                                  height: 25.0,
                                                  padding: EdgeInsets.all(0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFF00FF09),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  disabledColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primaryBackground,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                ConfirmaPpWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              uidAnimaisProdutores:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              grupoPredominante:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                              nomeAnimal:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'PP',
                                                  icon: Icon(
                                                    Icons.notifications,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 80.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF1A03E9),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 4.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                DgMenosWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              uidAnimaisProdutores:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              grupoPredominante:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                              nomeAnimal:
                                                                  listViewPartoInduzidoChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'DG -',
                                                  icon: Icon(
                                                    Icons.cancel_rounded,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 80.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFFAE0303),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              if (_model.choiceChipsValue != 'Todos')
                StreamBuilder<List<AnimaisProdutoresRecord>>(
                  stream: queryAnimaisProdutoresRecord(
                    parent: widget.uidTecnico,
                    queryBuilder: (animaisProdutoresRecord) =>
                        animaisProdutoresRecord
                            .where(
                              'uidTecnicoPropriedade',
                              isEqualTo: widget.uidPropriedade,
                            )
                            .where(
                              'status',
                              isEqualTo: _model.choiceChipsValue,
                            )
                            .orderBy('nomeAnimal')
                            .orderBy('brincoAnimalOrder'),
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
                    List<AnimaisProdutoresRecord>
                        listViewCategoriaChoiceAnimaisProdutoresRecordList =
                        snapshot.data!;

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount:
                          listViewCategoriaChoiceAnimaisProdutoresRecordList
                              .length,
                      itemBuilder: (context, listViewCategoriaChoiceIndex) {
                        final listViewCategoriaChoiceAnimaisProdutoresRecord =
                            listViewCategoriaChoiceAnimaisProdutoresRecordList[
                                listViewCategoriaChoiceIndex];
                        return Visibility(
                          visible: ((listViewCategoriaChoiceAnimaisProdutoresRecord
                                          .grupoAnimal ==
                                      'Novilhas') ||
                                  (listViewCategoriaChoiceAnimaisProdutoresRecord
                                          .grupoAnimal ==
                                      'Vacas')) &&
                              (listViewCategoriaChoiceAnimaisProdutoresRecord
                                      .status !=
                                  'Descarte'),
                          child: FlipCard(
                            fill: Fill.fillBack,
                            direction: FlipDirection.VERTICAL,
                            speed: 400,
                            front: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 12.0, 16.0, 12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: GridView(
                                        padding: EdgeInsets.zero,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 0.0,
                                          mainAxisSpacing: 0.0,
                                          childAspectRatio: 2.0,
                                        ),
                                        primary: false,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 50.0,
                                                height: 50.0,
                                                decoration: BoxDecoration(
                                                  color: () {
                                                    if (listViewCategoriaChoiceAnimaisProdutoresRecord
                                                            .grupoAnimal ==
                                                        'Vacas') {
                                                      return Color(0xFF048508);
                                                    } else if (listViewCategoriaChoiceAnimaisProdutoresRecord
                                                            .grupoAnimal ==
                                                        'Novilhas') {
                                                      return Color(0xFFFF0076);
                                                    } else {
                                                      return Color(0x00000000);
                                                    }
                                                  }(),
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Text(
                                                  () {
                                                    if (listViewCategoriaChoiceAnimaisProdutoresRecord
                                                            .grupoAnimal ==
                                                        'Vacas') {
                                                      return 'VAC';
                                                    } else if (listViewCategoriaChoiceAnimaisProdutoresRecord
                                                            .grupoAnimal ==
                                                        'Novilhas') {
                                                      return 'NOV';
                                                    } else {
                                                      return 'N/C';
                                                    }
                                                  }(),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontStyle,
                                                        ),
                                                        color: Colors.white,
                                                        fontSize: 13.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${() {
                                                  if ((listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                  .nomeAnimal !=
                                                              '') &&
                                                      (listViewCategoriaChoiceAnimaisProdutoresRecord
                                                              .brincoAnimal !=
                                                          null) &&
                                                      (listViewCategoriaChoiceAnimaisProdutoresRecord
                                                              .brincoAnimal !=
                                                          -1)) {
                                                    return '${listViewCategoriaChoiceAnimaisProdutoresRecord.nomeAnimal} - ${listViewCategoriaChoiceAnimaisProdutoresRecord.brincoAnimal.toString()}';
                                                  } else if (listViewCategoriaChoiceAnimaisProdutoresRecord
                                                              .nomeAnimal !=
                                                          '') {
                                                    return listViewCategoriaChoiceAnimaisProdutoresRecord
                                                        .nomeAnimal;
                                                  } else {
                                                    return listViewCategoriaChoiceAnimaisProdutoresRecord
                                                        .brincoAnimal
                                                        .toString();
                                                  }
                                                }()} - ${listViewCategoriaChoiceAnimaisProdutoresRecord.status}',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyLarge
                                                    .override(
                                                      font:
                                                          GoogleFonts.readexPro(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontStyle,
                                                      ),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(5.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Icon(
                                                      Icons.add_circle_sharp,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .tertiary,
                                                      size: 30.0,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  5.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          context.pushNamed(
                                                            ProntuarioAnimalWidget
                                                                .routeName,
                                                            queryParameters: {
                                                              'uidPropriedade':
                                                                  serializeParam(
                                                                widget
                                                                    .uidPropriedade,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                              'nomePropriedade':
                                                                  serializeParam(
                                                                widget
                                                                    .nomePropriedade,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'uidTecnico':
                                                                  serializeParam(
                                                                widget
                                                                    .uidTecnico,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                              'emailPropriedade':
                                                                  serializeParam(
                                                                widget
                                                                    .emailPropriedade,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'uidAnimaisProdutores':
                                                                  serializeParam(
                                                                listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                              'grupoPredominante':
                                                                  serializeParam(
                                                                listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .grupoAnimal,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'visitaPresencial':
                                                                  serializeParam(
                                                                widget
                                                                    .visitaPresencial,
                                                                ParamType.bool,
                                                              ),
                                                              'diasDg':
                                                                  serializeParam(
                                                                widget.diasDg,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        },
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .pollH,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .tertiary,
                                                          size: 30.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  if ((listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                  .dtUltimaAcao !=
                                                              '') &&
                                                      (functions.verificaDataAcaoDataAtual(
                                                              listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                  .dtUltimaAcao) ==
                                                          true))
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  5.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Icon(
                                                        Icons.check_circle,
                                                        color:
                                                            Color(0xFF048508),
                                                        size: 30.0,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            back: ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: [
                                if ((listViewCategoriaChoiceAnimaisProdutoresRecord
                                            .status ==
                                        'Vazia') &&
                                    ((listViewCategoriaChoiceAnimaisProdutoresRecord
                                                .grupoAnimal ==
                                            'Terneiras') ||
                                        (listViewCategoriaChoiceAnimaisProdutoresRecord
                                                .grupoAnimal ==
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 5.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'Data nascimento: ${listViewCategoriaChoiceAnimaisProdutoresRecord.dtNascimento}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 5.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child: DesmameWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
                                                                    .emailPropriedade!,
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            diasDg:
                                                                widget.diasDg!,
                                                            uidAnimaisProdutores:
                                                                listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                            nomeAnimal:
                                                                listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .nomeAnimal,
                                                            brincoAnimal:
                                                                listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .brincoAnimal
                                                                    .toString(),
                                                            grupoAnimal:
                                                                listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .grupoAnimal,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Desmamar',
                                                icon: Icon(
                                                  Icons.pause,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 25.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          24.0, 0.0, 24.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFF048508),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                NovaAcaoExameGinecologicoWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                              uidAnimaisProdutores:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              nomeAnimal:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              brincoAnimal:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .brincoAnimal
                                                                      .toString(),
                                                              grupoAnimal:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Ação',
                                                  icon: Icon(
                                                    Icons.add_alert,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 100.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF1A03E9),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 4.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              if ((listViewCategoriaChoiceAnimaisProdutoresRecord
                                                          .status ==
                                                      'Inseminada') ||
                                                  (listViewCategoriaChoiceAnimaisProdutoresRecord
                                                          .status ==
                                                      'Inseminada PP'))
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          10.0, 0.0, 0.0, 0.0),
                                                  child: Icon(
                                                    Icons.check_sharp,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .success,
                                                    size: 24.0,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if ((listViewCategoriaChoiceAnimaisProdutoresRecord
                                            .status ==
                                        'Vazia') &&
                                    ((listViewCategoriaChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiras') &&
                                        (listViewCategoriaChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 5.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'DEL: ${listViewCategoriaChoiceAnimaisProdutoresRecord.dtUltimoParto != '' ? functions.calcularDiferencaEmDias(listViewCategoriaChoiceAnimaisProdutoresRecord.dtUltimoParto).toString() : 'N/D'}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                  Text(
                                                    'Último parto: ${listViewCategoriaChoiceAnimaisProdutoresRecord.dtUltimoPartoContingencia}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 5.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 10.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                NovaInseminacaoWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              uidAnimaisProdutores:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              grupoPredominante:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                              nomeAnimal:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              dtUltimaInseminacao:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .dtUltimaInseminacao,
                                                              brincoAnimal:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .brincoAnimal
                                                                      .toString(),
                                                              diasDg: widget
                                                                  .diasDg!,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Inseminar',
                                                  icon: Icon(
                                                    Icons.playlist_add,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(24.0, 0.0,
                                                                24.0, 0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF7E39EF),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              NovaAcaoExameGinecologicoWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
                                                                    .emailPropriedade!,
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            diasDg:
                                                                widget.diasDg!,
                                                            uidAnimaisProdutores:
                                                                listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                            nomeAnimal:
                                                                listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .nomeAnimal,
                                                            brincoAnimal:
                                                                listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .brincoAnimal
                                                                    .toString(),
                                                            grupoAnimal:
                                                                listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .grupoAnimal,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Ação',
                                                icon: Icon(
                                                  Icons.add_alert,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 100.0,
                                                  height: 25.0,
                                                  padding: EdgeInsets.all(0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFF1A03E9),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 4.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              if ((listViewCategoriaChoiceAnimaisProdutoresRecord
                                                          .status ==
                                                      'Inseminada') ||
                                                  (listViewCategoriaChoiceAnimaisProdutoresRecord
                                                          .status ==
                                                      'Inseminada PP'))
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          10.0, 0.0, 0.0, 0.0),
                                                  child: Icon(
                                                    Icons.check_sharp,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .success,
                                                    size: 24.0,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if ((listViewCategoriaChoiceAnimaisProdutoresRecord
                                            .status ==
                                        'Pré Parto') &&
                                    ((listViewCategoriaChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiras') &&
                                        (listViewCategoriaChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Inseminada em: ${listViewCategoriaChoiceAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Pré parto prev.: ${listViewCategoriaChoiceAnimaisProdutoresRecord.dtPrePartoPrevista}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Parto previsto: ${listViewCategoriaChoiceAnimaisProdutoresRecord.dtPartoPrevisto}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FFButtonWidget(
                                              onPressed: () async {
                                                await showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  enableDrag: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                      },
                                                      child: Padding(
                                                        padding: MediaQuery
                                                            .viewInsetsOf(
                                                                context),
                                                        child:
                                                            RegistrarPartoWidget(
                                                          uidPropriedade: widget
                                                              .uidPropriedade!,
                                                          nomePropriedade: widget
                                                              .nomePropriedade!,
                                                          uidTecnico: widget
                                                              .uidTecnico!,
                                                          emailPropriedade: widget
                                                              .emailPropriedade!,
                                                          visitaPresencial: widget
                                                              .visitaPresencial!,
                                                          diasDg:
                                                              widget.diasDg!,
                                                          uidAnimaisProdutores:
                                                              listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                  .reference,
                                                          nomeVacaAtual:
                                                              listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                  .nomeAnimal,
                                                          nomeTourtoUltimaInseminacao:
                                                              listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                  .nomeTouroUltimaInseminacao,
                                                          brincoVacaAtual:
                                                              listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                  .brincoAnimal
                                                                  .toString(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).then((value) =>
                                                    safeSetState(() {}));
                                              },
                                              text: 'Parto',
                                              icon: Icon(
                                                Icons.add_alert,
                                                size: 15.0,
                                              ),
                                              options: FFButtonOptions(
                                                width: 100.0,
                                                height: 25.0,
                                                padding: EdgeInsets.all(0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color: Color(0xFF12BE24),
                                                textStyle: FlutterFlowTheme.of(
                                                        context)
                                                    .titleSmall
                                                    .override(
                                                      font:
                                                          GoogleFonts.readexPro(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontStyle,
                                                      ),
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontStyle,
                                                    ),
                                                elevation: 3.0,
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      10.0, 0.0, 0.0, 0.0),
                                              child: FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              RegistroAbortoWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
                                                                    .emailPropriedade!,
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            diasDg:
                                                                widget.diasDg!,
                                                            uidAnimaisProdutores:
                                                                listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                            nomeAnimal:
                                                                listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .nomeAnimal,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Aborto',
                                                icon: Icon(
                                                  Icons.cancel_sharp,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 100.0,
                                                  height: 25.0,
                                                  padding: EdgeInsets.all(0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFFAE0303),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                if ((listViewCategoriaChoiceAnimaisProdutoresRecord
                                            .status ==
                                        'Prenha') &&
                                    (listViewCategoriaChoiceAnimaisProdutoresRecord
                                            .grupoAnimal ==
                                        'Novilhas') &&
                                    ((listViewCategoriaChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiras') &&
                                        (listViewCategoriaChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Inseminada em: ${listViewCategoriaChoiceAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Pré parto prev.: ${listViewCategoriaChoiceAnimaisProdutoresRecord.dtPrePartoPrevista}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Parto previsto: ${listViewCategoriaChoiceAnimaisProdutoresRecord.dtPartoPrevisto}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 5.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              RegistroAbortoWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
                                                                    .emailPropriedade!,
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            diasDg:
                                                                widget.diasDg!,
                                                            uidAnimaisProdutores:
                                                                listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                            nomeAnimal:
                                                                listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .nomeAnimal,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Aborto',
                                                icon: Icon(
                                                  Icons.cancel_sharp,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 100.0,
                                                  height: 25.0,
                                                  padding: EdgeInsets.all(0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFFAE0303),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                RegistrarPartoWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                              uidAnimaisProdutores:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              nomeVacaAtual:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              nomeTourtoUltimaInseminacao:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .nomeTouroUltimaInseminacao,
                                                              brincoVacaAtual:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .brincoAnimal
                                                                      .toString(),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Parto',
                                                  icon: Icon(
                                                    Icons.add_alert,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 100.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF12BE24),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                RegistrarPrePartoWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                              uidAnimaisProdutores:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              nomeAnimal:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              brincoAnimal:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .brincoAnimalOrder
                                                                      .toString(),
                                                              grupoAnimal:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                              dtPrePartoPrevista:
                                                                  functions.converteDataStringDate(
                                                                      listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                          .dtPrePartoPrevista),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Pré-parto',
                                                  icon: Icon(
                                                    Icons.check,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 100.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF1A03E9),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if ((listViewCategoriaChoiceAnimaisProdutoresRecord
                                            .status ==
                                        'Seca') &&
                                    (listViewCategoriaChoiceAnimaisProdutoresRecord
                                            .grupoAnimal ==
                                        'Vacas') &&
                                    ((listViewCategoriaChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiras') &&
                                        (listViewCategoriaChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Inseminada em: ${listViewCategoriaChoiceAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Pré parto prev.: ${listViewCategoriaChoiceAnimaisProdutoresRecord.dtPrePartoPrevista}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Parto previsto: ${listViewCategoriaChoiceAnimaisProdutoresRecord.dtPartoPrevisto}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 5.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              RegistrarPartoWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
                                                                    .emailPropriedade!,
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            diasDg:
                                                                widget.diasDg!,
                                                            uidAnimaisProdutores:
                                                                listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                            nomeVacaAtual:
                                                                listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .nomeAnimal,
                                                            nomeTourtoUltimaInseminacao:
                                                                listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .nomeTouroUltimaInseminacao,
                                                            brincoVacaAtual:
                                                                listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .brincoAnimal
                                                                    .toString(),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Parto',
                                                icon: Icon(
                                                  Icons.add_alert,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 100.0,
                                                  height: 25.0,
                                                  padding: EdgeInsets.all(0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFF12BE24),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 10.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                RegistrarPrePartoWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                              uidAnimaisProdutores:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              nomeAnimal:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              brincoAnimal:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .brincoAnimalOrder
                                                                      .toString(),
                                                              grupoAnimal:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                              dtPrePartoPrevista:
                                                                  functions.converteDataStringDate(
                                                                      listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                          .dtPrePartoPrevista),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Pré-parto',
                                                  icon: Icon(
                                                    Icons.check,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 100.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF1A03E9),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              RegistroAbortoWidget(
                                                            uidPropriedade: widget
                                                                .uidPropriedade!,
                                                            nomePropriedade: widget
                                                                .nomePropriedade!,
                                                            uidTecnico: widget
                                                                .uidTecnico!,
                                                            emailPropriedade:
                                                                widget
                                                                    .emailPropriedade!,
                                                            visitaPresencial:
                                                                widget
                                                                    .visitaPresencial!,
                                                            diasDg:
                                                                widget.diasDg!,
                                                            uidAnimaisProdutores:
                                                                listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .reference,
                                                            nomeAnimal:
                                                                listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .nomeAnimal,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Aborto',
                                                icon: Icon(
                                                  Icons.cancel_sharp,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 100.0,
                                                  height: 25.0,
                                                  padding: EdgeInsets.all(0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFFAE0303),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if ((listViewCategoriaChoiceAnimaisProdutoresRecord
                                            .status ==
                                        'Prenha') &&
                                    (listViewCategoriaChoiceAnimaisProdutoresRecord
                                            .grupoAnimal ==
                                        'Vacas') &&
                                    ((listViewCategoriaChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiras') &&
                                        (listViewCategoriaChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Inseminada em: ${listViewCategoriaChoiceAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Pré parto prev.: ${listViewCategoriaChoiceAnimaisProdutoresRecord.dtPrePartoPrevista}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  'Parto previsto: ${listViewCategoriaChoiceAnimaisProdutoresRecord.dtPartoPrevisto}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 5.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 4.0, 10.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                RegistroAbortoWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                              uidAnimaisProdutores:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              nomeAnimal:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Aborto',
                                                  icon: Icon(
                                                    Icons
                                                        .check_circle_outline_sharp,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 100.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFFAE0303),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 4.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                RegistrarSecagemWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                              uidAnimaisProdutores:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              nomeAnimal:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              brincoAnimal:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .brincoAnimalOrder
                                                                      .toString(),
                                                              grupoAnimal:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                              dtSecPrevista: functions
                                                                  .converteDataStringDate(
                                                                      listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                          .dtSecPrevista),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'Secagem',
                                                  icon: Icon(
                                                    Icons.cancel_rounded,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 100.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFFE9AB05),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (((listViewCategoriaChoiceAnimaisProdutoresRecord
                                                .status ==
                                            'Inseminada PP') ||
                                        (listViewCategoriaChoiceAnimaisProdutoresRecord
                                                .status ==
                                            'Inseminada')) &&
                                    ((listViewCategoriaChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiras') &&
                                        (listViewCategoriaChoiceAnimaisProdutoresRecord
                                                .grupoAnimal !=
                                            'Terneiros')))
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Inseminada em: ${listViewCategoriaChoiceAnimaisProdutoresRecord.dtUltimaInseminacao}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 5.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FFButtonWidget(
                                                onPressed: ((listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                .status !=
                                                            'Inseminada PP') &&
                                                        (listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                    .dtPP ==
                                                                ''))
                                                    ? null
                                                    : () async {
                                                        await showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          enableDrag: false,
                                                          context: context,
                                                          builder: (context) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                FocusScope.of(
                                                                        context)
                                                                    .unfocus();
                                                                FocusManager
                                                                    .instance
                                                                    .primaryFocus
                                                                    ?.unfocus();
                                                              },
                                                              child: Padding(
                                                                padding: MediaQuery
                                                                    .viewInsetsOf(
                                                                        context),
                                                                child:
                                                                    DgMaisWidget(
                                                                  uidPropriedade:
                                                                      widget
                                                                          .uidPropriedade!,
                                                                  nomePropriedade:
                                                                      widget
                                                                          .nomePropriedade!,
                                                                  uidTecnico:
                                                                      widget
                                                                          .uidTecnico!,
                                                                  emailPropriedade:
                                                                      widget
                                                                          .emailPropriedade!,
                                                                  uidAnimaisProdutores:
                                                                      listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                          .reference,
                                                                  grupoPredominante:
                                                                      listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                          .grupoAnimal,
                                                                  nomeAnimal:
                                                                      listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                          .nomeAnimal,
                                                                  visitaPresencial:
                                                                      widget
                                                                          .visitaPresencial!,
                                                                  diasDg: widget
                                                                      .diasDg!,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ).then((value) =>
                                                            safeSetState(
                                                                () {}));
                                                      },
                                                text: 'DG +',
                                                icon: Icon(
                                                  Icons.check_circle,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 80.0,
                                                  height: 25.0,
                                                  padding: EdgeInsets.all(0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFF00FF09),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  disabledColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primaryBackground,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                ConfirmaPpWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              uidAnimaisProdutores:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              grupoPredominante:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                              nomeAnimal:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                              diasDg: widget
                                                                  .diasDg!,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'PP',
                                                  icon: Icon(
                                                    Icons.notifications,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 80.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFF1A03E9),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 4.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                DgMenosWidget(
                                                              uidPropriedade:
                                                                  widget
                                                                      .uidPropriedade!,
                                                              nomePropriedade:
                                                                  widget
                                                                      .nomePropriedade!,
                                                              uidTecnico: widget
                                                                  .uidTecnico!,
                                                              emailPropriedade:
                                                                  widget
                                                                      .emailPropriedade!,
                                                              uidAnimaisProdutores:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .reference,
                                                              grupoPredominante:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .grupoAnimal,
                                                              nomeAnimal:
                                                                  listViewCategoriaChoiceAnimaisProdutoresRecord
                                                                      .nomeAnimal,
                                                              visitaPresencial:
                                                                  widget
                                                                      .visitaPresencial!,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'DG -',
                                                  icon: Icon(
                                                    Icons.cancel_rounded,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: 80.0,
                                                    height: 25.0,
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0xFFAE0303),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
