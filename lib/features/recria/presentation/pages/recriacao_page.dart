import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import '/custom_code/actions/index.dart' as actions;
import '/pages/tecnico/propriedade/inicio_propriedade/inicio_propriedade_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/animal_list_widget.dart';

/// Página principal da tela de Recriação.
/// Exibe a lista de animais em recriação (Bezerros, Bezerras, Touros, Novilhas)
/// com suporte para modo online e offline.
class RecriacaoPage extends StatefulWidget {
  const RecriacaoPage({
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

  static String routeName = 'recriacao';
  static String routePath = '/recriacao';

  @override
  State<RecriacaoPage> createState() => _RecriacaoPageState();
}

class _RecriacaoPageState extends State<RecriacaoPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// Direção da ordenação da lista (antes em FFAppState.ordenacaoQuery, que era
  /// global e não-persistido, usado só nesta tela). Local: false = descendente.
  bool _ordenacaoQuery = false;

  // Estado de view (antes no RecriacaoModel/FlutterFlowModel).
  InstantTimer? _instantTimer;
  bool? _respostaNet = true;
  FormFieldController<List<String>>? _choiceChipsValueController;
  String? get _choiceChipsValue =>
      _choiceChipsValueController?.value?.firstOrNull;
  set _choiceChipsValue(String? val) =>
      _choiceChipsValueController?.value = val != null ? [val] : [];

  // Constantes de cores
  static const Color _appBarColorOnline = Color(0xFFF75E38);
  static const Color _appBarColorOffline = Color(0xFFF2886E);

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _setupInternetChecker();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  void _setupInternetChecker() {
    _instantTimer = InstantTimer.periodic(
      duration: const Duration(seconds: 5),
      callback: (timer) async {
        _respostaNet = await actions.checkInternetConnection();
        safeSetState(() {});

        if (_respostaNet!) {
          safeSetState(() {});
        } else {
          // Offline: notificação passiva via SyncStatusBanner (app-wide);
          // sem flag global. O respostaNet acima já atualiza a UI.
        }
      },
      startImmediately: false,
    );
  }

  @override
  void dispose() {
    _instantTimer?.cancel();
    super.dispose();
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
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final isOnline = _respostaNet ?? true;

    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
      child: AppBar(
        backgroundColor: isOnline ? _appBarColorOnline : _appBarColorOffline,
        automaticallyImplyLeading: false,
        actions: const [],
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
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        12.0, 0.0, 0.0, 0.0),
                    child: FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 30.0,
                      borderWidth: 1.0,
                      buttonSize: 50.0,
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white, size: 30.0),
                      onPressed: _navigateBack,
                    ),
                  ),
                  Text(
                    'Recria',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          font: GoogleFonts.outfit(),
                          color: Colors.white,
                          fontSize: 22.0,
                          letterSpacing: 0.0,
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
    );
  }

  void _navigateBack() {
    context.pushNamed(
      InicioPropriedadeWidget.routeName,
      queryParameters: {
        'nomePropriedade':
            serializeParam(widget.nomePropriedade, ParamType.String),
        'uidPropriedade':
            serializeParam(widget.uidPropriedade, ParamType.DocumentReference),
        'uidTecnico':
            serializeParam(widget.uidTecnico, ParamType.DocumentReference),
        'emailPropriedade':
            serializeParam(widget.emailPropriedade, ParamType.String),
        'visitaPresencial':
            serializeParam(widget.visitaPresencial, ParamType.bool),
        'diasDg': serializeParam(widget.diasDg, ParamType.String),
      }.withoutNulls,
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      primary: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFilterSection(context),
          _buildAnimalList(context),
        ],
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    final isNovilhasSelected = _choiceChipsValue == 'Novilhas';
    final isAscending = _ordenacaoQuery;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
          child: Text(
            'Filtragem:',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.readexPro(),
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(15.0, 5.0, 15.0, 5.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      15.0, 5.0, 15.0, 15.0),
                  child: _buildChoiceChips(context),
                ),
              ),
              if (isNovilhasSelected) _buildSortButton(context, isAscending),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceChips(BuildContext context) {
    return FlutterFlowChoiceChips(
      options: const [
        ChipData('Bezerros'),
        ChipData('Bezerras'),
        ChipData('Touros'),
        ChipData('Novilhas'),
        ChipData('Todos'),
      ],
      onChanged: (val) =>
          safeSetState(() => _choiceChipsValue = val?.firstOrNull),
      selectedChipStyle: ChipStyle(
        backgroundColor: FlutterFlowTheme.of(context).tertiary,
        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.readexPro(),
              color: FlutterFlowTheme.of(context).primaryText,
              letterSpacing: 0.0,
            ),
        iconColor: FlutterFlowTheme.of(context).primaryText,
        iconSize: 18.0,
        elevation: 4.0,
        borderRadius: BorderRadius.circular(16.0),
      ),
      unselectedChipStyle: ChipStyle(
        backgroundColor: FlutterFlowTheme.of(context).alternate,
        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.readexPro(),
              color: FlutterFlowTheme.of(context).secondaryText,
              letterSpacing: 0.0,
            ),
        iconColor: FlutterFlowTheme.of(context).secondaryText,
        iconSize: 18.0,
        elevation: 0.0,
        borderRadius: BorderRadius.circular(16.0),
      ),
      chipSpacing: 12.0,
      rowSpacing: 12.0,
      multiselect: false,
      initialized: _choiceChipsValue != null,
      alignment: WrapAlignment.center,
      controller: _choiceChipsValueController ??=
          FormFieldController<List<String>>(['Todos']),
      wrapped: true,
    );
  }

  Widget _buildSortButton(BuildContext context, bool isAscending) {
    return FlutterFlowIconButton(
      borderRadius: 8.0,
      buttonSize: 40.0,
      fillColor: FlutterFlowTheme.of(context).tertiary,
      icon: FaIcon(
        isAscending
            ? FontAwesomeIcons.arrowUpWideShort
            : FontAwesomeIcons.arrowDownWideShort,
        color: isAscending
            ? FlutterFlowTheme.of(context).info
            : FlutterFlowTheme.of(context).secondaryBackground,
        size: 24.0,
      ),
      onPressed: () {
        _ordenacaoQuery = !isAscending;
        safeSetState(() {});
      },
    );
  }

  Widget _buildAnimalList(BuildContext context) {
    final isOnline = _respostaNet ?? true;

    return ListView(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        AnimalListWidget(
          uidPropriedade: widget.uidPropriedade,
          nomePropriedade: widget.nomePropriedade,
          uidTecnico: widget.uidTecnico,
          emailPropriedade: widget.emailPropriedade,
          visitaPresencial: widget.visitaPresencial,
          diasDg: widget.diasDg,
          filterCategory: _choiceChipsValue,
          isOnline: isOnline,
          ascending: _ordenacaoQuery,
        ),
      ],
    );
  }
}
