// ignore_for_file: unnecessary_null_comparison

import '/core/ui/cabecalho_tela.dart';
import 'dart:async';

import '/core/connectivity/connectivity_service.dart';
import '/data/backend.dart';
import '/core/ui/abas_pilula.dart';
import '/core/ui/painel_lista.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/features/animais/presentation/pages/cadastrar_novo_animal_page.dart';
import '/features/animais/presentation/pages/editar_animal_page.dart';
import '/features/animais/presentation/animal_group_list_view.dart';
import '/features/animais/application/ordenacao_animais.dart';
import '/features/animais/application/animais_providers.dart';
import '/features/animais/presentation/widgets/seletor_ordem_animais.dart';
import '/features/animais/presentation/widgets/descarte_animal_widget.dart';
import '/data/objectbox/repositories/animal_repository.dart';
import '/data/objectbox/entities/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp show Consumer;

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
          uidAnimaisProdutores: FirebaseFirestore.instance
              .doc('${widget.uidTecnico!.path}/animaisProdutores/$firestoreId'),
          grupoPredominante: grupo,
          nomeAnimal: animal.nomeAnimal ?? '',
          visitaPresencial: widget.visitaPresencial ?? false,
          diasDg: widget.diasDg ?? '',
        ),
      ),
    );
  }

  static const _grupos = [
    'Bezerras',
    'Bezerros',
    'Novilhas',
    'Sêmens',
    'Touros',
    'Vacas',
  ];

  /// Painel do padrao de listas (`docs/padrao-layout-listas.md`): busca,
  /// ordenacao e as abas por grupo, com quantos animais ha em cada uma.
  ///
  /// Fica fora da `TabBarView` de proposito: o criterio de ordem e o termo
  /// digitado valem para a categoria que estiver aberta, e repetir o controle
  /// dentro de cada aba faria o tecnico reconfigurar tudo a cada troca.
  ///
  /// A ordenacao fica numa linha propria, e nao ao lado da busca: com dois
  /// botoes ao lado do campo sobraria pouca largura justamente para quem
  /// recebe texto longo, que e o campo de busca.
  Widget _painelBuscaEAbas(BuildContext context) {
    return PainelLista(
      busca: CampoBuscaLista(
        controller: _buscaController,
        focusNode: _buscaFocusNode,
        dica: 'Pesquisar por nome ou brinco',
        onChanged: (_) => safeSetState(() {}),
      ),
      linhas: [
        SeletorOrdemAnimais(
          ordem: _ordem,
          crescente: _crescente,
          alturaMinima: LayoutLista.alturaChip,
          raio: LayoutLista.raio,
          // Trocar de criterio recomeca crescente: o resultado de um toque
          // nao deve depender da direcao deixada no criterio anterior.
          onSelecionar: (nova) => safeSetState(() {
            _ordem = nova;
            _crescente = true;
          }),
          onInverter: () => safeSetState(() => _crescente = !_crescente),
        ),
      ],
      // Contagem pelo MESMO provider e filtro de busca da lista de cada aba,
      // para o numero nunca divergir do que aparece embaixo.
      abas: rp.Consumer(
        builder: (context, ref, _) => AbasPilula(
          controller: _tabBarController!,
          abas: [
            for (final grupo in _grupos)
              AbaPilula(
                grupo,
                contagem: _contarVisiveis(ref
                    .watch(animaisByGrupoProvider((
                      propriedadePath: widget.uidPropriedade!.path,
                      grupo: grupo,
                    )))
                    .value),
              ),
          ],
        ),
      ),
    );
  }

  /// Quantos animais da aba aparecem com a busca atual; `null` (sem
  /// contador) enquanto a aba ainda carrega.
  int? _contarVisiveis(List<AnimalEntity>? animais) => animais == null
      ? null
      : aplicarBuscaEOrdem(animais,
              ordem: _ordem,
              crescente: _crescente,
              busca: _buscaController.text)
          .length;

  /// Conteúdo principal da tela: a lista de animais de cada aba (grupo).
  Widget _abasDeAnimais(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        floatingActionButton: btnNovoAnimal(context),
        appBar: CabecalhoTela(
          titulo: 'Animais',
          online: _respostaNet ?? true,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _painelBuscaEAbas(context),
            _abasDeAnimais(context),
          ],
        ),
      ),
    );
  }
}
