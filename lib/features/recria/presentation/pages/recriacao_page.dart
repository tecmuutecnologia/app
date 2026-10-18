import 'dart:async';

import '/core/connectivity/connectivity_service.dart';
import '/data/backend.dart';
import '/core/ui/abas_pilula.dart';
import '/core/ui/cabecalho_tela.dart';
import '/core/ui/painel_lista.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/features/recria/application/filtros_recria.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/features/animais/application/ordenacao_animais.dart';
import '/features/animais/presentation/widgets/seletor_ordem_animais.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) => CabecalhoTela(
        titulo: 'Recria',
        online: _respostaNet ?? true,
        aoVoltar: _navigateBack,
      );

  void _navigateBack() {
    context.safePop();
  }

  /// Padrão de listas (`docs/padrao-layout-listas.md`): painel fixo com
  /// busca, ordem e abas; só a lista rola.
  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _painelBuscaEAbas(context),
        Expanded(child: _buildAnimalList(context)),
      ],
    );
  }

  /// Busca, ordem (com "Inseminação" na aba Novilhas) e as abas com quantos
  /// animais há em cada uma — pela MESMA regra da lista (`apareceNaRecria`) e
  /// com a busca aplicada.
  Widget _painelBuscaEAbas(BuildContext context) {
    final daPropriedade = animaisProdutoresExistentesObjectBox()
        .where((a) =>
            a.uidTecnicoPropriedade == widget.uidPropriedade &&
            apareceNaRecria(
                grupo: a.grupoAnimal,
                status: a.status,
                temInducaoLactacao: a.dtInducaoLactacao != null))
        .toList();
    int contar(String aba) => ordenarStructs(
          aba == 'Todos'
              ? daPropriedade
              : daPropriedade.where((a) => a.grupoAnimal == aba).toList(),
          ordem: _ordem,
          busca: _buscaController.text,
        ).length;

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
          mostrarInseminacao: _categoria == 'Novilhas',
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
      // A aba só filtra a lista (não há uma página por aba), então não há
      // `TabBarView`.
      abas: AbasPilula(
        controller: _tabBarController,
        abas: [for (final aba in _abas) AbaPilula(aba, contagem: contar(aba))],
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
