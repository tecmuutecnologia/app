// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

import '/core/connectivity/connectivity_service.dart';
import '/data/backend.dart';
import '/core/ui/flutter_flow_button_tabbar.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/app_card.dart';
import '/features/animais/presentation/pages/cadastrar_novo_animal_page.dart';
import '/features/animais/presentation/pages/editar_animal_page.dart';
import '/features/animais/presentation/animal_group_list_view.dart';
import '/features/animais/application/ordenacao_animais.dart';
import '/features/animais/presentation/widgets/seletor_ordem_animais.dart';
import '/features/animais/presentation/widgets/descarte_animal_widget.dart';
import '/data/objectbox/repositories/animal_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ListaAnimaisPage extends StatefulWidget {
  const ListaAnimaisPage({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    int? tabBarOpenSelected,
    required this.visitaPresencial,
    int? initialTabSelect,
    this.diasDg,
    bool? permiteDescarte,
  })  : this.permiteDescarte = permiteDescarte ?? false,
        this.tabBarOpenSelected = tabBarOpenSelected ?? 1,
        this.initialTabSelect = initialTabSelect ?? 0;

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final int tabBarOpenSelected;
  final bool? visitaPresencial;
  final int initialTabSelect;
  final String? diasDg;

  /// Libera o descarte por arrasto. Padrao `false` e so a navegacao do tecnico
  /// liga: o produtor abre a MESMA tela pelo menu dele, e descarte (com motivo
  /// e data, alimentando os indicadores do rebanho) e decisao de manejo.
  final bool permiteDescarte;

  static String routeName = 'listaAnimais';
  static String routePath = '/listaAnimais';

  @override
  State<ListaAnimaisPage> createState() => _ListaAnimaisPageState();
}

class _ListaAnimaisPageState extends State<ListaAnimaisPage>
    with TickerProviderStateMixin {
  StreamSubscription<bool>? _conectividadeSub;
  bool? _respostaNet = true;
  TabController? _tabBarController;
  int get _tabBarCurrentIndex =>
      _tabBarController != null ? _tabBarController!.index : 0;

  /// Um campo de busca para a tela inteira, e nao um por aba.
  ///
  /// Antes existiam SEIS controllers aqui — um por categoria — criados no
  /// `initState` e descartados no `dispose` sem nunca aparecerem na tela:
  /// resto do FlutterFlow. A busca filtra a aba aberta, entao um campo basta.
  final TextEditingController _buscaController = TextEditingController();
  final FocusNode _buscaFocusNode = FocusNode();

  /// Criterio de ordenacao das SEIS abas. Fica na tela, nao em cada aba, para
  /// o tecnico nao precisar reescolher a ordem ao trocar de categoria.
  OrdemAnimais _ordem = OrdemAnimais.nome;

  /// Direcao do criterio: `true` = A-Z / menor brinco primeiro.
  bool _crescente = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // Conectividade por transicao real, nao por polling: antes era um
      // timer periodico de 5s cujo callback chamava safeSetState
      // incondicionalmente, reconstruindo a arvore inteira houvesse mudanca
      // ou nao. O valor alimenta um unico lugar: a cor de um botao.
      _respostaNet = ConnectivityService.instance.isOnline;
      _conectividadeSub =
          ConnectivityService.instance.onStatusChange.listen((online) {
        if (mounted) safeSetState(() => _respostaNet = online);
      });
    });

    _tabBarController = TabController(
      vsync: this,
      length: 6,
      initialIndex: min(
          valueOrDefault<int>(
            widget.initialTabSelect,
            0,
          ),
          5),
    )..addListener(() => safeSetState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _conectividadeSub?.cancel();
    _tabBarController?.dispose();
    _buscaFocusNode.dispose();
    _buscaController.dispose();

    super.dispose();
  }

  Widget topoPagina(BuildContext context) {
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
          'Animais',
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

  /// Abre o formulario de descarte (motivo + data) do animal arrastado.
  ///
  /// O arrasto so PEDE o descarte; nada e gravado aqui. Quem grava e o
  /// `DescarteAnimalWidget`, no ObjectBox, e o animal some da lista sozinho
  /// porque a aba observa o ObjectBox — e reaparece na aba "Descarte" das
  /// secas, de onde ele pode ser eliminado em definitivo.
  Future<void> _abrirDescarte(String firestoreId, String grupo) async {
    final animal = AnimalRepository().getByFirestoreId(firestoreId);
    if (animal == null || !mounted) return;

    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.viewInsetsOf(context),
        child: DescarteAnimalWidget(
          uidPropriedade: widget.uidPropriedade!,
          nomePropriedade: widget.nomePropriedade!,
          uidTecnico: widget.uidTecnico!,
          emailPropriedade: widget.emailPropriedade!,
          // Animais vivem sob o tecnico — mesma reconstrucao usada no editar.
          uidAnimaisProdutores: FirebaseFirestore.instance.doc(
              '${widget.uidTecnico!.path}/animaisProdutores/$firestoreId'),
          grupoPredominante: grupo,
          nomeAnimal: animal.nomeAnimal ?? '',
          visitaPresencial: widget.visitaPresencial ?? false,
          diasDg: widget.diasDg ?? '',
        ),
      ),
    );
  }

  /// Busca e ordenacao da tela, acima das abas.
  ///
  /// Fica fora da `TabBarView` de proposito: o criterio de ordem e o termo
  /// digitado valem para a categoria que estiver aberta, e repetir o controle
  /// dentro de cada aba faria o tecnico reconfigurar tudo a cada troca.
  ///
  /// Busca em cima e botoes embaixo, e nao os tres na mesma linha: com dois
  /// botoes ao lado do campo sobraria pouca largura justamente para quem
  /// recebe texto longo, que e o campo de busca.
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

  /// O campo em si, no mesmo desenho das telas de secas, prenhas e lista
  /// completa.
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

  /// Conteúdo principal da tela: a barra de abas por grupo (Bezerras, Bezerros,
  /// Novilhas, Sêmens, Touros, Vacas) e a lista de animais de cada aba.
  Widget _abasDeAnimais(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Align(
            alignment: Alignment(-1.0, 0),
            child: FlutterFlowButtonTabBar(
              useToggleButtonStyle: false,
              isScrollable: true,
              labelStyle: FlutterFlowTheme.of(context).titleMedium.override(
                    font: GoogleFonts.readexPro(
                      fontWeight:
                          FlutterFlowTheme.of(context).titleMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleMedium.fontStyle,
                    ),
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).titleMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleMedium.fontStyle,
                  ),
              unselectedLabelStyle: TextStyle(),
              labelColor: Colors.white,
              unselectedLabelColor: Color(0xFF525D67),
              backgroundColor: AppTokens.secondary,
              unselectedBackgroundColor: Color(0xFFC5C5C5),
              borderColor: AppTokens.secondary,
              borderWidth: 2.0,
              borderRadius: 12.0,
              elevation: 0.0,
              labelPadding:
                  EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              buttonMargin:
                  EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 16.0, 0.0),
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              tabs: [
                Tab(
                  text: 'Bezerras',
                ),
                Tab(
                  text: 'Bezerros',
                ),
                Tab(
                  text: 'Novilhas',
                ),
                Tab(
                  text: 'Sêmens',
                ),
                Tab(
                  text: 'Touros',
                ),
                Tab(
                  text: 'Vacas',
                ),
              ],
              controller: _tabBarController,
              onTap: (i) async {
                [
                  () async {},
                  () async {},
                  () async {},
                  () async {},
                  () async {},
                  () async {}
                ][i]();
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabBarController,
              children: [
                AnimalGroupListView(
                  propriedadePath: widget.uidPropriedade!.path,
                  ordem: _ordem,
                  crescente: _crescente,
                  busca: _buscaController.text,
                  grupo: 'Bezerras',
                  permiteDescarte: widget.permiteDescarte,
                  onDescartar: (firestoreId) =>
                      _abrirDescarte(firestoreId, 'Bezerras'),
                  onEditAnimal: (firestoreId) {
                    context.pushNamed(
                      EditarAnimalPage.routeName,
                      queryParameters: {
                        'uidPropriedade': serializeParam(
                            widget.uidPropriedade, ParamType.DocumentReference),
                        'nomePropriedade': serializeParam(
                            widget.nomePropriedade, ParamType.String),
                        'uidTecnico': serializeParam(
                            widget.uidTecnico, ParamType.DocumentReference),
                        'emailPropriedade': serializeParam(
                            widget.emailPropriedade, ParamType.String),
                        'grupoPredominante':
                            serializeParam('Bezerras', ParamType.String),
                        'visitaPresencial': serializeParam(
                            widget.visitaPresencial, ParamType.bool),
                        'initialTabSelect': serializeParam(
                            widget.initialTabSelect, ParamType.int),
                        'uidAnimal': serializeParam(
                            // Animais vivem sob o técnico
                            FirebaseFirestore.instance.doc(
                                '${widget.uidTecnico!.path}/animaisProdutores/$firestoreId'),
                            ParamType.DocumentReference),
                        'diasDg':
                            serializeParam(widget.diasDg, ParamType.String),
                      }.withoutNulls,
                    );
                  },
                ),
                AnimalGroupListView(
                  propriedadePath: widget.uidPropriedade!.path,
                  ordem: _ordem,
                  crescente: _crescente,
                  busca: _buscaController.text,
                  grupo: 'Bezerros',
                  permiteDescarte: widget.permiteDescarte,
                  onDescartar: (firestoreId) =>
                      _abrirDescarte(firestoreId, 'Bezerros'),
                  onEditAnimal: (firestoreId) {
                    context.pushNamed(
                      EditarAnimalPage.routeName,
                      queryParameters: {
                        'uidPropriedade': serializeParam(
                            widget.uidPropriedade, ParamType.DocumentReference),
                        'nomePropriedade': serializeParam(
                            widget.nomePropriedade, ParamType.String),
                        'uidTecnico': serializeParam(
                            widget.uidTecnico, ParamType.DocumentReference),
                        'emailPropriedade': serializeParam(
                            widget.emailPropriedade, ParamType.String),
                        'grupoPredominante':
                            serializeParam('Bezerros', ParamType.String),
                        'visitaPresencial': serializeParam(
                            widget.visitaPresencial, ParamType.bool),
                        'initialTabSelect': serializeParam(
                            widget.initialTabSelect, ParamType.int),
                        'uidAnimal': serializeParam(
                            // Animais vivem sob o técnico
                            FirebaseFirestore.instance.doc(
                                '${widget.uidTecnico!.path}/animaisProdutores/$firestoreId'),
                            ParamType.DocumentReference),
                        'diasDg':
                            serializeParam(widget.diasDg, ParamType.String),
                      }.withoutNulls,
                    );
                  },
                ),
                AnimalGroupListView(
                  propriedadePath: widget.uidPropriedade!.path,
                  ordem: _ordem,
                  crescente: _crescente,
                  busca: _buscaController.text,
                  grupo: 'Novilhas',
                  permiteDescarte: widget.permiteDescarte,
                  onDescartar: (firestoreId) =>
                      _abrirDescarte(firestoreId, 'Novilhas'),
                  onEditAnimal: (firestoreId) {
                    context.pushNamed(
                      EditarAnimalPage.routeName,
                      queryParameters: {
                        'uidPropriedade': serializeParam(
                            widget.uidPropriedade, ParamType.DocumentReference),
                        'nomePropriedade': serializeParam(
                            widget.nomePropriedade, ParamType.String),
                        'uidTecnico': serializeParam(
                            widget.uidTecnico, ParamType.DocumentReference),
                        'emailPropriedade': serializeParam(
                            widget.emailPropriedade, ParamType.String),
                        'grupoPredominante':
                            serializeParam('Novilhas', ParamType.String),
                        'visitaPresencial': serializeParam(
                            widget.visitaPresencial, ParamType.bool),
                        'initialTabSelect': serializeParam(
                            widget.initialTabSelect, ParamType.int),
                        'uidAnimal': serializeParam(
                            // Animais vivem sob o técnico
                            FirebaseFirestore.instance.doc(
                                '${widget.uidTecnico!.path}/animaisProdutores/$firestoreId'),
                            ParamType.DocumentReference),
                        'diasDg':
                            serializeParam(widget.diasDg, ParamType.String),
                      }.withoutNulls,
                    );
                  },
                ),
                AnimalGroupListView(
                  propriedadePath: widget.uidPropriedade!.path,
                  ordem: _ordem,
                  crescente: _crescente,
                  busca: _buscaController.text,
                  grupo: 'Sêmens',
                  permiteDescarte: widget.permiteDescarte,
                  onDescartar: (firestoreId) =>
                      _abrirDescarte(firestoreId, 'Sêmens'),
                  onEditAnimal: (firestoreId) {
                    context.pushNamed(
                      EditarAnimalPage.routeName,
                      queryParameters: {
                        'uidPropriedade': serializeParam(
                            widget.uidPropriedade, ParamType.DocumentReference),
                        'nomePropriedade': serializeParam(
                            widget.nomePropriedade, ParamType.String),
                        'uidTecnico': serializeParam(
                            widget.uidTecnico, ParamType.DocumentReference),
                        'emailPropriedade': serializeParam(
                            widget.emailPropriedade, ParamType.String),
                        'grupoPredominante':
                            serializeParam('Sêmens', ParamType.String),
                        'visitaPresencial': serializeParam(
                            widget.visitaPresencial, ParamType.bool),
                        'initialTabSelect': serializeParam(
                            widget.initialTabSelect, ParamType.int),
                        'uidAnimal': serializeParam(
                            // Animais vivem sob o técnico
                            FirebaseFirestore.instance.doc(
                                '${widget.uidTecnico!.path}/animaisProdutores/$firestoreId'),
                            ParamType.DocumentReference),
                        'diasDg':
                            serializeParam(widget.diasDg, ParamType.String),
                      }.withoutNulls,
                    );
                  },
                ),
                AnimalGroupListView(
                  propriedadePath: widget.uidPropriedade!.path,
                  ordem: _ordem,
                  crescente: _crescente,
                  busca: _buscaController.text,
                  grupo: 'Touros',
                  permiteDescarte: widget.permiteDescarte,
                  onDescartar: (firestoreId) =>
                      _abrirDescarte(firestoreId, 'Touros'),
                  onEditAnimal: (firestoreId) {
                    context.pushNamed(
                      EditarAnimalPage.routeName,
                      queryParameters: {
                        'uidPropriedade': serializeParam(
                            widget.uidPropriedade, ParamType.DocumentReference),
                        'nomePropriedade': serializeParam(
                            widget.nomePropriedade, ParamType.String),
                        'uidTecnico': serializeParam(
                            widget.uidTecnico, ParamType.DocumentReference),
                        'emailPropriedade': serializeParam(
                            widget.emailPropriedade, ParamType.String),
                        'grupoPredominante':
                            serializeParam('Touros', ParamType.String),
                        'visitaPresencial': serializeParam(
                            widget.visitaPresencial, ParamType.bool),
                        'initialTabSelect': serializeParam(
                            widget.initialTabSelect, ParamType.int),
                        'uidAnimal': serializeParam(
                            // Animais vivem sob o técnico
                            FirebaseFirestore.instance.doc(
                                '${widget.uidTecnico!.path}/animaisProdutores/$firestoreId'),
                            ParamType.DocumentReference),
                        'diasDg':
                            serializeParam(widget.diasDg, ParamType.String),
                      }.withoutNulls,
                    );
                  },
                ),
                AnimalGroupListView(
                  propriedadePath: widget.uidPropriedade!.path,
                  ordem: _ordem,
                  crescente: _crescente,
                  busca: _buscaController.text,
                  grupo: 'Vacas',
                  permiteDescarte: widget.permiteDescarte,
                  onDescartar: (firestoreId) =>
                      _abrirDescarte(firestoreId, 'Vacas'),
                  onEditAnimal: (firestoreId) {
                    context.pushNamed(
                      EditarAnimalPage.routeName,
                      queryParameters: {
                        'uidPropriedade': serializeParam(
                            widget.uidPropriedade, ParamType.DocumentReference),
                        'nomePropriedade': serializeParam(
                            widget.nomePropriedade, ParamType.String),
                        'uidTecnico': serializeParam(
                            widget.uidTecnico, ParamType.DocumentReference),
                        'emailPropriedade': serializeParam(
                            widget.emailPropriedade, ParamType.String),
                        'grupoPredominante':
                            serializeParam('Vacas', ParamType.String),
                        'visitaPresencial': serializeParam(
                            widget.visitaPresencial, ParamType.bool),
                        'initialTabSelect': serializeParam(
                            widget.initialTabSelect, ParamType.int),
                        'uidAnimal': serializeParam(
                            // Animais vivem sob o técnico: tecnico/{id}/animaisProdutores/{id}
                            FirebaseFirestore.instance.doc(
                                '${widget.uidTecnico!.path}/animaisProdutores/$firestoreId'),
                            ParamType.DocumentReference),
                        'diasDg':
                            serializeParam(widget.diasDg, ParamType.String),
                      }.withoutNulls,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget btnNovoAnimal(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color(0xFFEC3B5B),
      foregroundColor: Colors.white,
      tooltip: 'Novo animal',
      onPressed: () async {
        context.pushNamed(
          CadastrarNovoAnimalPage.routeName,
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
            'grupoPredominante': serializeParam(
              () {
                if (_tabBarCurrentIndex == 0) {
                  return 'Bezerras';
                } else if (_tabBarCurrentIndex == 1) {
                  return 'Bezerros';
                } else if (_tabBarCurrentIndex == 2) {
                  return 'Novilhas';
                } else if (_tabBarCurrentIndex == 3) {
                  return 'Sêmens';
                } else if (_tabBarCurrentIndex == 4) {
                  return 'Touros';
                } else if (_tabBarCurrentIndex == 5) {
                  return 'Vacas';
                } else {
                  return 'Novilhas';
                }
              }(),
              ParamType.String,
            ),
            'visitaPresencial': serializeParam(
              widget.visitaPresencial,
              ParamType.bool,
            ),
            'initialTabSelect': serializeParam(
              _tabBarCurrentIndex,
              ParamType.int,
            ),
            'diasDg': serializeParam(
              widget.diasDg,
              ParamType.String,
            ),
          }.withoutNulls,
        );

        return;
      },
      child: const Icon(Icons.add, size: 32.0),
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
        floatingActionButton: btnNovoAnimal(context),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            backgroundColor:
                _respostaNet! ? Color(0xFFF75E38) : Color(0xFFF2886E),
            automaticallyImplyLeading: false,
            actions: [],
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  topoPagina(context),
                ],
              ),
              centerTitle: true,
              expandedTitleScale: 1.0,
            ),
            elevation: 0.0,
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _cabecalhoBuscaEOrdem(context),
            _abasDeAnimais(context),
          ],
        ),
      ),
    );
  }
}
