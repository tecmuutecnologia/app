import 'dart:async';

import '/core/connectivity/connectivity_service.dart';
import '/data/backend.dart';
import '/core/ui/flutter_flow_button_tabbar.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/app_card.dart';
import '/features/animais/application/ordenacao_animais.dart';
import '/features/animais/presentation/widgets/seletor_ordem_animais.dart';
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

class _RecriacaoPageState extends State<RecriacaoPage>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Estado de view (antes no RecriacaoModel/FlutterFlowModel).
  StreamSubscription<bool>? _conectividadeSub;
  bool? _respostaNet = true;

  /// Abas da Recria: "Todos" primeiro (o padrão e o "limpar filtro"), depois
  /// os grupos na mesma ordem das abas da tela de Animais.
  static const _abas = ['Todos', 'Bezerras', 'Bezerros', 'Novilhas', 'Touros'];
  late final TabController _tabBarController = TabController(
      length: _abas.length, vsync: this)
    ..addListener(() {
      if (_tabBarController.indexIsChanging) return;
      safeSetState(() {
        // "Inseminação" só existe em Novilhas: fora dela volta a Nome.
        if (_categoria != 'Novilhas' && _ordem == OrdemAnimais.inseminacao) {
          _ordem = OrdemAnimais.nome;
          _crescente = true;
        }
      });
    });
  String get _categoria => _abas[_tabBarController.index];

  // Busca e ordenação: os mesmos controles e a mesma regra da tela de
  // Animais, mais "Inseminação" na aba Novilhas.
  final TextEditingController _buscaController = TextEditingController();
  final FocusNode _buscaFocusNode = FocusNode();
  OrdemAnimais _ordem = OrdemAnimais.nome;
  bool _crescente = true;

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
    // Conectividade por transicao real, nao por polling: antes era um
    // timer periodico de 5s cujo callback chamava safeSetState
    // incondicionalmente, reconstruindo a arvore inteira houvesse mudanca
    // ou nao. O valor alimenta um unico lugar: a cor de um botao.
    _respostaNet = ConnectivityService.instance.isOnline;
    _conectividadeSub =
        ConnectivityService.instance.onStatusChange.listen((online) {
      if (mounted) safeSetState(() => _respostaNet = online);
    });
  }

  @override
  void dispose() {
    _conectividadeSub?.cancel();
    _tabBarController.dispose();
    _buscaFocusNode.dispose();
    _buscaController.dispose();
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
    context.safePop();
  }

  /// Mesmo layout da tela de Animais: busca e ordem fixas no topo, abas
  /// logo abaixo, e só a lista rola.
  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _cabecalhoBuscaEOrdem(context),
        _abasDeCategoria(context),
        Expanded(child: _buildAnimalList(context)),
      ],
    );
  }

  /// Igual ao `_cabecalhoBuscaEOrdem` da lista de animais.
  Widget _cabecalhoBuscaEOrdem(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _campoBuscaTexto(context),
          const SizedBox(height: 10.0),
          SeletorOrdemAnimais(
            ordem: _ordem,
            crescente: _crescente,
            mostrarInseminacao: _categoria == 'Novilhas',
            // Trocar de criterio recomeca crescente: o resultado de um toque
            // nao deve depender da direcao deixada no criterio anterior.
            onSelecionar: (nova) => safeSetState(() {
              _ordem = nova;
              _crescente = true;
            }),
            onInverter: () => safeSetState(() => _crescente = !_crescente),
          ),
        ],
      ),
    );
  }

  Widget _campoBuscaTexto(BuildContext context) {
    return TextFormField(
      controller: _buscaController,
      focusNode: _buscaFocusNode,
      onChanged: (_) => safeSetState(() {}),
      decoration: InputDecoration(
        labelText: 'Pesquisar por nome ou brinco',
        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(),
              letterSpacing: 0.0,
            ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
          borderRadius: BorderRadius.circular(14.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppTokens.secondary, width: 1.5),
          borderRadius: BorderRadius.circular(14.0),
        ),
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
        prefixIcon: Icon(
          Icons.search_rounded,
          color: FlutterFlowTheme.of(context).secondaryText,
        ),
        suffixIcon: _buscaController.text.isNotEmpty
            ? InkWell(
                onTap: () {
                  _buscaController.clear();
                  safeSetState(() {});
                },
                child: Icon(
                  Icons.clear,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 18.0,
                ),
              )
            : null,
      ),
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.readexPro(),
            letterSpacing: 0.0,
          ),
      maxLines: 1,
    );
  }

  /// Mesma barra de abas da lista de animais. Aqui a aba só filtra a lista
  /// (não há uma página por aba), então não há `TabBarView`.
  Widget _abasDeCategoria(BuildContext context) {
    return Align(
      alignment: const Alignment(-1.0, 0),
      child: FlutterFlowButtonTabBar(
        useToggleButtonStyle: false,
        isScrollable: true,
        labelStyle: FlutterFlowTheme.of(context).titleMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
            ),
        unselectedLabelStyle: const TextStyle(),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF525D67),
        backgroundColor: AppTokens.secondary,
        unselectedBackgroundColor: const Color(0xFFC5C5C5),
        borderColor: AppTokens.secondary,
        borderWidth: 2.0,
        borderRadius: 12.0,
        elevation: 0.0,
        labelPadding:
            const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
        buttonMargin:
            const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 16.0, 0.0),
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
        tabs: [for (final aba in _abas) Tab(text: aba)],
        controller: _tabBarController,
        onTap: (_) {},
      ),
    );
  }

  Widget _buildAnimalList(BuildContext context) {
    return AnimalListWidget(
      uidPropriedade: widget.uidPropriedade,
      nomePropriedade: widget.nomePropriedade,
      uidTecnico: widget.uidTecnico,
      emailPropriedade: widget.emailPropriedade,
      visitaPresencial: widget.visitaPresencial,
      diasDg: widget.diasDg,
      filterCategory: _categoria,
      ordem: _ordem,
      crescente: _crescente,
      busca: _buscaController.text,
      onAcaoConcluida: () => safeSetState(() {}),
    );
  }
}
