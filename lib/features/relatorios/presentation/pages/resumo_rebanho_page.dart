// ignore_for_file: dead_code, unnecessary_null_comparison, dead_null_aware_expression, unused_import

import '/data/backend.dart';
import '/core/constants/grupos_racas_constantes.dart';
import '/core/ui/flutter_flow_drop_down.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/app_card.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/form_field_controller.dart';
import '/core/ui/instant_timer.dart';
import '/core/services/index.dart' as actions;
import '/core/ui/custom_functions.dart' as functions;
import '/features/propriedades/presentation/pages/inicio_propriedade_page.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// Status extras fixos (antes em FFAppState.statusExtras, que nunca era
/// escrito — constante de fato). Combinados com os status vindos do Firestore
/// nas opções do dropdown de categoria.
const kStatusExtrasFixos = ['Indução de Lactação', 'Descarte'];

class ResumoRebanhoPage extends StatefulWidget {
  const ResumoRebanhoPage({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.diasDg,
    this.empresaTecnico,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? diasDg;
  final String? empresaTecnico;

  static String routeName = 'resumoRebanho';
  static String routePath = '/resumoRebanho';

  @override
  State<ResumoRebanhoPage> createState() => _ResumoRebanhoPageState();
}

class _ResumoRebanhoPageState extends State<ResumoRebanhoPage> {
  InstantTimer? _instantTimer;
  bool? _respostaNet = true;
  List<String>? _categoriaAnimalValue;
  FormFieldController<List<String>>? _categoriaAnimalValueController;
  List<String>? _statusAnimalValue;
  FormFieldController<List<String>>? _statusAnimalValueController;
  bool? _checkUltimopartoValue;
  bool? _checkUltimaiaValue;
  bool? _checkDelValue;
  bool? _checkTouroValue;
  bool? _checkSecagemValue;
  bool? _checkPrepartoValue;
  bool? _checkDiasAbertoValue;
  bool? _checkIntervaloEntrePartosValue;
  bool? _checkParicaoValue;
  bool? _checkUltimaAcaoValue;
  String? _formatoExportacaoValue;
  FormFieldController<String>? _formatoExportacaoValueController;
  PropriedadesRecord? _outUidPropriedade;
  TecnicoRecord? _outUidTecnico;
  PersonRecord? _outUidPersonTecnico;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _instantTimer = InstantTimer.periodic(
        duration: Duration(milliseconds: 1000),
        callback: (timer) async {
          _respostaNet = await actions.checkInternetConnection();

          safeSetState(() {});
        },
        startImmediately: false,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _instantTimer?.cancel();

    super.dispose();
  }

  Widget _cabecalho(BuildContext context) {
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
              context.pushNamed(
                InicioPropriedadePage.routeName,
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
          'Resumo do rebanho',
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

  Widget _tituloFiltro(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.tune_rounded,
              color: AppTokens.secondary, size: 20.0),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(
              'Filtro do relatório:',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.readexPro(
                      fontWeight: FontWeight.w800,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w800,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _campoGrupo(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
      child: StreamBuilder<List<GrupoRecord>>(
        stream: queryGrupoRecord(
          queryBuilder: (grupoRecord) => grupoRecord.where(
            'descricao',
            isNotEqualTo: 'Sêmens',
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
          List<GrupoRecord> categoriaAnimalGrupoRecordList = snapshot.data!;

          return FlutterFlowDropDown<String>(
            multiSelectController: _categoriaAnimalValueController ??=
                FormListFieldController<String>(
                    _categoriaAnimalValue ??= List<String>.from(
              categoriaAnimalGrupoRecordList.map((e) => e.descricao).toList() ??
                  [],
            )),
            options: _respostaNet!
                ? categoriaAnimalGrupoRecordList
                    .map((e) => e.descricao)
                    .toList()
                : kGruposDescricoes.toList(),
            width: double.infinity,
            height: 50.0,
            searchHintTextStyle: FlutterFlowTheme.of(context)
                .labelMedium
                .override(
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
            searchTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
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
            textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
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
            hintText: 'Categoria animal',
            searchHintText: 'Pesquise uma categoria...',
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 24.0,
            ),
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            elevation: 2.0,
            borderColor: FlutterFlowTheme.of(context).alternate,
            borderWidth: 2.0,
            borderRadius: 8.0,
            margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
            hidesUnderline: true,
            isSearchable: true,
            isMultiSelect: true,
            onMultiSelectChanged: (val) =>
                safeSetState(() => _categoriaAnimalValue = val),
          );
        },
      ),
    );
  }

  Widget _campoStatus(BuildContext context) {
    return StreamBuilder<List<StatusAnimaisRecord>>(
      stream: queryStatusAnimaisRecord(),
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
        List<StatusAnimaisRecord> statusAnimalStatusAnimaisRecordList =
            snapshot.data!;

        return FlutterFlowDropDown<String>(
          multiSelectController: _statusAnimalValueController ??=
              FormListFieldController<String>(
                  _statusAnimalValue ??= List<String>.from(
            functions.combinarListas(
                    statusAnimalStatusAnimaisRecordList
                        .where((e) => e.descricao != 'Parto Induzido')
                        .toList()
                        .map((e) => e.descricao)
                        .toList(),
                    kStatusExtrasFixos.toList()) ??
                [],
          )),
          options: functions.combinarListas(
              statusAnimalStatusAnimaisRecordList
                  .where((e) => e.descricao != 'Parto Induzido')
                  .toList()
                  .map((e) => e.descricao)
                  .toList(),
              kStatusExtrasFixos.toList())!,
          width: double.infinity,
          height: 50.0,
          searchHintTextStyle: FlutterFlowTheme.of(context)
              .labelMedium
              .override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          searchTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
          textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
          hintText: 'Status',
          searchHintText: 'Pesquise um status...',
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24.0,
          ),
          fillColor: FlutterFlowTheme.of(context).primaryBackground,
          elevation: 2.0,
          borderColor: FlutterFlowTheme.of(context).alternate,
          borderWidth: 2.0,
          borderRadius: 8.0,
          margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
          hidesUnderline: true,
          isSearchable: true,
          isMultiSelect: true,
          onMultiSelectChanged: (val) =>
              safeSetState(() => _statusAnimalValue = val),
        );
      },
    );
  }

  Widget _tituloColunas(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 25.0, 0.0, 0.0),
      child: Text(
        'Colunas exibição relatório:',
        textAlign: TextAlign.center,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FontWeight.w800,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              fontSize: 16.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w800,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
      ),
    );
  }

  Widget _colunaUltimoParto(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Último Parto',
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                  ),
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                ),
          ),
          Theme(
            data: ThemeData(
              checkboxTheme: CheckboxThemeData(
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              unselectedWidgetColor: FlutterFlowTheme.of(context).secondaryText,
            ),
            child: Checkbox(
              value: _checkUltimopartoValue ??= true,
              onChanged: (newValue) async {
                safeSetState(() => _checkUltimopartoValue = newValue!);
              },
              side: (FlutterFlowTheme.of(context).secondaryText != null)
                  ? BorderSide(
                      width: 2,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    )
                  : null,
              activeColor: FlutterFlowTheme.of(context).tertiary,
              checkColor: FlutterFlowTheme.of(context).info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _colunaUltimaInseminacao(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Última Inseminação',
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                  ),
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                ),
          ),
          Theme(
            data: ThemeData(
              checkboxTheme: CheckboxThemeData(
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              unselectedWidgetColor: FlutterFlowTheme.of(context).secondaryText,
            ),
            child: Checkbox(
              value: _checkUltimaiaValue ??= true,
              onChanged: (newValue) async {
                safeSetState(() => _checkUltimaiaValue = newValue!);
              },
              side: (FlutterFlowTheme.of(context).secondaryText != null)
                  ? BorderSide(
                      width: 2,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    )
                  : null,
              activeColor: FlutterFlowTheme.of(context).tertiary,
              checkColor: FlutterFlowTheme.of(context).info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _colunaDel(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'DEL',
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                  ),
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                ),
          ),
          Theme(
            data: ThemeData(
              checkboxTheme: CheckboxThemeData(
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              unselectedWidgetColor: FlutterFlowTheme.of(context).secondaryText,
            ),
            child: Checkbox(
              value: _checkDelValue ??= true,
              onChanged: (newValue) async {
                safeSetState(() => _checkDelValue = newValue!);
              },
              side: (FlutterFlowTheme.of(context).secondaryText != null)
                  ? BorderSide(
                      width: 2,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    )
                  : null,
              activeColor: FlutterFlowTheme.of(context).tertiary,
              checkColor: FlutterFlowTheme.of(context).info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _colunaTouro(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Touro',
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                  ),
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                ),
          ),
          Theme(
            data: ThemeData(
              checkboxTheme: CheckboxThemeData(
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              unselectedWidgetColor: FlutterFlowTheme.of(context).secondaryText,
            ),
            child: Checkbox(
              value: _checkTouroValue ??= true,
              onChanged: (newValue) async {
                safeSetState(() => _checkTouroValue = newValue!);
              },
              side: (FlutterFlowTheme.of(context).secondaryText != null)
                  ? BorderSide(
                      width: 2,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    )
                  : null,
              activeColor: FlutterFlowTheme.of(context).tertiary,
              checkColor: FlutterFlowTheme.of(context).info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _colunaSecagem(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Secagem',
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                  ),
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                ),
          ),
          Theme(
            data: ThemeData(
              checkboxTheme: CheckboxThemeData(
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              unselectedWidgetColor: FlutterFlowTheme.of(context).secondaryText,
            ),
            child: Checkbox(
              value: _checkSecagemValue ??= true,
              onChanged: (newValue) async {
                safeSetState(() => _checkSecagemValue = newValue!);
              },
              side: (FlutterFlowTheme.of(context).secondaryText != null)
                  ? BorderSide(
                      width: 2,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    )
                  : null,
              activeColor: FlutterFlowTheme.of(context).tertiary,
              checkColor: FlutterFlowTheme.of(context).info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _colunaPreParto(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Pré Parto',
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                  ),
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                ),
          ),
          Theme(
            data: ThemeData(
              checkboxTheme: CheckboxThemeData(
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              unselectedWidgetColor: FlutterFlowTheme.of(context).secondaryText,
            ),
            child: Checkbox(
              value: _checkPrepartoValue ??= true,
              onChanged: (newValue) async {
                safeSetState(() => _checkPrepartoValue = newValue!);
              },
              side: (FlutterFlowTheme.of(context).secondaryText != null)
                  ? BorderSide(
                      width: 2,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    )
                  : null,
              activeColor: FlutterFlowTheme.of(context).tertiary,
              checkColor: FlutterFlowTheme.of(context).info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _colunaDiasEmAberto(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Dias Em Aberto',
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                  ),
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                ),
          ),
          Theme(
            data: ThemeData(
              checkboxTheme: CheckboxThemeData(
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              unselectedWidgetColor: FlutterFlowTheme.of(context).secondaryText,
            ),
            child: Checkbox(
              value: _checkDiasAbertoValue ??= true,
              onChanged: (newValue) async {
                safeSetState(() => _checkDiasAbertoValue = newValue!);
              },
              side: (FlutterFlowTheme.of(context).secondaryText != null)
                  ? BorderSide(
                      width: 2,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    )
                  : null,
              activeColor: FlutterFlowTheme.of(context).tertiary,
              checkColor: FlutterFlowTheme.of(context).info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _colunaIntervaloPartos(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Intervalo Entre Partos',
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                  ),
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                ),
          ),
          Theme(
            data: ThemeData(
              checkboxTheme: CheckboxThemeData(
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              unselectedWidgetColor: FlutterFlowTheme.of(context).secondaryText,
            ),
            child: Checkbox(
              value: _checkIntervaloEntrePartosValue ??= true,
              onChanged: (newValue) async {
                safeSetState(() => _checkIntervaloEntrePartosValue = newValue!);
              },
              side: (FlutterFlowTheme.of(context).secondaryText != null)
                  ? BorderSide(
                      width: 2,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    )
                  : null,
              activeColor: FlutterFlowTheme.of(context).tertiary,
              checkColor: FlutterFlowTheme.of(context).info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _colunaPrevisaoParto(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Previsão Parto',
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                  ),
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                ),
          ),
          Theme(
            data: ThemeData(
              checkboxTheme: CheckboxThemeData(
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              unselectedWidgetColor: FlutterFlowTheme.of(context).secondaryText,
            ),
            child: Checkbox(
              value: _checkParicaoValue ??= true,
              onChanged: (newValue) async {
                safeSetState(() => _checkParicaoValue = newValue!);
              },
              side: (FlutterFlowTheme.of(context).secondaryText != null)
                  ? BorderSide(
                      width: 2,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    )
                  : null,
              activeColor: FlutterFlowTheme.of(context).tertiary,
              checkColor: FlutterFlowTheme.of(context).info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _colunaUltimaAcao(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Última Ação',
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                  ),
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                ),
          ),
          Theme(
            data: ThemeData(
              checkboxTheme: CheckboxThemeData(
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              unselectedWidgetColor: FlutterFlowTheme.of(context).secondaryText,
            ),
            child: Checkbox(
              value: _checkUltimaAcaoValue ??= false,
              onChanged: (newValue) async {
                safeSetState(() => _checkUltimaAcaoValue = newValue!);
              },
              side: (FlutterFlowTheme.of(context).secondaryText != null)
                  ? BorderSide(
                      width: 2,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    )
                  : null,
              activeColor: FlutterFlowTheme.of(context).tertiary,
              checkColor: FlutterFlowTheme.of(context).info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _campoFormatoExportacao(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Formato de Exportação',
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                  ),
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                ),
          ),
          SizedBox(height: 10.0),
          FlutterFlowDropDown<String>(
            controller: _formatoExportacaoValueController ??=
                FormFieldController<String>(
              _formatoExportacaoValue ??= 'PDF',
            ),
            options: ['PDF', 'Excel'],
            onChanged: (val) {
              safeSetState(() {
                _formatoExportacaoValue = val;
              });
            },
            width: MediaQuery.sizeOf(context).width * 0.8,
            height: 50.0,
            textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
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
            hintText: 'Selecione o formato',
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 24.0,
            ),
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            elevation: 2.0,
            borderColor: FlutterFlowTheme.of(context).alternate,
            borderWidth: 2.0,
            borderRadius: 8.0,
            margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
            hidesUnderline: true,
            isSearchable: false,
            isMultiSelect: false,
          ),
        ],
      ),
    );
  }

  Widget _botaoExportar(
      BuildContext context, dynamic resumoRebanhoAnimaisProdutoresRecordList) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 30.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FFButtonWidget(
            onPressed: () async {
              var _shouldSetState = false;
              if (_categoriaAnimalValue!.length >= 1) {
                _outUidPropriedade = await PropriedadesRecord.getDocumentOnce(
                    widget.uidPropriedade!);
                _shouldSetState = true;
                _outUidTecnico =
                    await TecnicoRecord.getDocumentOnce(widget.uidTecnico!);
                _shouldSetState = true;
                _outUidPersonTecnico = await queryPersonRecordOnce(
                  queryBuilder: (personRecord) => personRecord.where(
                    'uid',
                    isEqualTo: _outUidTecnico?.uidPerson,
                  ),
                  singleRecord: true,
                ).then((s) => s.firstOrNull);
                _shouldSetState = true;

                // Verificar qual formato foi selecionado
                if (_formatoExportacaoValue == 'Excel') {
                  // Gerar Excel
                  await actions.createResumoRebanhoExcel(
                    resumoRebanhoAnimaisProdutoresRecordList
                        .map((e) => e.reference)
                        .toList(),
                    _checkUltimopartoValue == true,
                    _checkUltimaiaValue == true,
                    _checkDelValue == true,
                    _checkTouroValue == true,
                    _checkSecagemValue == true,
                    _checkPrepartoValue == true,
                    _checkParicaoValue == true,
                    _checkDiasAbertoValue!,
                    _checkIntervaloEntrePartosValue!,
                    _categoriaAnimalValue!.toList(),
                    _statusAnimalValue?.toList(),
                    _outUidPropriedade!.displayName,
                    '${_outUidPropriedade?.endereco} - ${_outUidPropriedade?.cidade}',
                    _outUidPersonTecnico!.displayName,
                    _outUidPersonTecnico!.phoneNumber,
                    _outUidPersonTecnico!.email,
                    _outUidPersonTecnico!.empresa,
                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/tecmuu-xingpe/assets/mjfv0ghrztrz/logo-2.png',
                    _checkUltimaAcaoValue ?? false,
                    widget.uidTecnico!,
                  );
                } else {
                  // Gerar PDF (padrão)
                  await actions.createResumoRebanho(
                    resumoRebanhoAnimaisProdutoresRecordList
                        .map((e) => e.reference)
                        .toList(),
                    _checkUltimopartoValue == true,
                    _checkUltimaiaValue == true,
                    _checkDelValue == true,
                    _checkTouroValue == true,
                    _checkSecagemValue == true,
                    _checkPrepartoValue == true,
                    _checkParicaoValue == true,
                    _checkDiasAbertoValue!,
                    _checkIntervaloEntrePartosValue!,
                    _categoriaAnimalValue!.toList(),
                    _statusAnimalValue?.toList(),
                    _outUidPropriedade!.displayName,
                    '${_outUidPropriedade?.endereco} - ${_outUidPropriedade?.cidade}',
                    _outUidPersonTecnico!.displayName,
                    _outUidPersonTecnico!.phoneNumber,
                    _outUidPersonTecnico!.email,
                    _outUidPersonTecnico!.empresa,
                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/tecmuu-xingpe/assets/mjfv0ghrztrz/logo-2.png',
                    _checkUltimaAcaoValue ?? false,
                    widget.uidTecnico!,
                  );
                }
                if (_shouldSetState) safeSetState(() {});
                return;
              } else {
                await showDialog(
                  context: context,
                  builder: (alertDialogContext) {
                    return AlertDialog(
                      title: Text('Selecione ao menos uma categoria.'),
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

              if (_shouldSetState) safeSetState(() {});
            },
            text: 'Gerar relatório',
            icon: Icon(
              _formatoExportacaoValue == 'Excel'
                  ? Icons.table_chart
                  : Icons.picture_as_pdf,
              size: 15.0,
            ),
            options: FFButtonOptions(
              width: MediaQuery.sizeOf(context).width * 0.8,
              height: 40.0,
              padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: Color(0xFFFF8E04),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    // context.watch<FFAppState>();

    return StreamBuilder<List<AnimaisProdutoresRecord>>(
      stream: queryAnimaisProdutoresRecord(
        parent: widget.uidTecnico,
        queryBuilder: (animaisProdutoresRecord) =>
            animaisProdutoresRecord.where(
          'uidTecnicoPropriedade',
          isEqualTo: widget.uidPropriedade,
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
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
        List<AnimaisProdutoresRecord> resumoRebanhoAnimaisProdutoresRecordList =
            snapshot.data!;

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
                          _cabecalho(context),
                        ],
                      ),
                      centerTitle: true,
                      expandedTitleScale: 1.0,
                    ),
                    elevation: 0.0,
                  )),
            ),
            body: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  _tituloFiltro(context),
                  _campoGrupo(context),
                  _campoStatus(context),
                  _tituloColunas(context),
                  _colunaUltimoParto(context),
                  _colunaUltimaInseminacao(context),
                  _colunaDel(context),
                  _colunaTouro(context),
                  _colunaSecagem(context),
                  _colunaPreParto(context),
                  _colunaDiasEmAberto(context),
                  _colunaIntervaloPartos(context),
                  _colunaPrevisaoParto(context),
                  _colunaUltimaAcao(context),
                  _campoFormatoExportacao(context),
                  _botaoExportar(context, resumoRebanhoAnimaisProdutoresRecordList),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
