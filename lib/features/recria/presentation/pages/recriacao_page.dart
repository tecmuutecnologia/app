import '/data/backend.dart';
import '/core/ui/flutter_flow_choice_chips.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/app_card.dart';
import '/core/ui/form_field_controller.dart';
import '/core/ui/instant_timer.dart';
import '/core/services/index.dart' as actions;
import '/features/propriedades/presentation/pages/inicio_propriedade_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
      InicioPropriedadePage.routeName,
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

    // Uma única faixa: chips rolando na horizontal + ordenação fixa à direita.
    //
    // Antes eram DUAS faixas empilhadas — um cabeçalho "Filtragem:" (rótulo
    // redundante: os chips já se explicam) e, abaixo, os chips em `Wrap`, que
    // quebravam em 2-3 linhas em telas estreitas. Somando cabeçalho, quebras e
    // paddings de 15px, os filtros comiam ~160px antes da lista começar.
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 12.0, 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
              child: _buildChoiceChips(context),
            ),
          ),
          if (isNovilhasSelected) ...[
            const SizedBox(width: 8.0),
            _buildSortButton(context, isAscending),
          ],
        ],
      ),
    );
  }

  Widget _buildChoiceChips(BuildContext context) {
    return FlutterFlowChoiceChips(
      // "Todos" primeiro: é o padrão inicial e o "limpar filtro" — quem quer
      // voltar à lista completa acha sem precisar rolar até o fim.
      options: const [
        ChipData('Todos'),
        ChipData('Bezerros'),
        ChipData('Bezerras'),
        ChipData('Touros'),
        ChipData('Novilhas'),
      ],
      onChanged: (val) =>
          safeSetState(() => _choiceChipsValue = val?.firstOrNull),
      selectedChipStyle: ChipStyle(
        backgroundColor: AppTokens.secondary,
        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.readexPro(),
              color: Colors.white,
              letterSpacing: 0.0,
            ),
        iconColor: Colors.white,
        iconSize: 18.0,
        elevation: 0.0,
        borderRadius: BorderRadius.circular(20.0),
      ),
      unselectedChipStyle: ChipStyle(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.readexPro(),
              color: FlutterFlowTheme.of(context).secondaryText,
              letterSpacing: 0.0,
            ),
        iconColor: FlutterFlowTheme.of(context).secondaryText,
        iconSize: 18.0,
        elevation: 0.0,
        borderRadius: BorderRadius.circular(20.0),
      ),
      chipSpacing: 8.0,
      rowSpacing: 8.0,
      multiselect: false,
      initialized: _choiceChipsValue != null,
      alignment: WrapAlignment.start,
      controller: _choiceChipsValueController ??=
          FormFieldController<List<String>>(['Todos']),
      // Rolagem horizontal em vez de `Wrap`: mantém os filtros em UMA linha
      // (~40px) independente de quantas opções existam, em vez de quebrar em
      // 2-3 linhas nas telas estreitas.
      wrapped: false,
    );
  }

  /// Alterna a ordem alfabética da lista. Antes era um botão só com um ícone de
  /// seta (duas variantes muito parecidas), sem indicar o que ordenava nem em
  /// que ordem estava. Agora mostra o estado ATUAL por extenso ("A-Z"/"Z-A").
  Widget _buildSortButton(BuildContext context, bool isAscending) {
    return FFButtonWidget(
      onPressed: () {
        _ordenacaoQuery = !isAscending;
        safeSetState(() {});
      },
      text: isAscending ? 'A-Z' : 'Z-A',
      icon: Icon(
        isAscending ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
        size: 15.0,
      ),
      options: FFButtonOptions(
        height: 40.0,
        padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
        iconPadding: EdgeInsets.zero,
        color: AppTokens.secondary,
        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
              font: GoogleFonts.readexPro(),
              color: Colors.white,
              fontSize: 12.0,
              letterSpacing: 0.0,
            ),
        elevation: 0.0,
        borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
        borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
      ),
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
