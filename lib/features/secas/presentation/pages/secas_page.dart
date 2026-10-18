// ignore_for_file: unnecessary_null_comparison

import '/core/ui/cabecalho_tela.dart';
import 'dart:async';

import '/core/connectivity/connectivity_service.dart';
import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/features/secas/application/filtros_secas.dart';
import '/features/secas/application/selecao_animais.dart';
import '/core/ui/abas_pilula.dart';
import '/core/ui/painel_lista.dart';
import '/core/ui/card_animal_lista.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/domain/animais/classificacao_animal.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/features/animais/application/ordenacao_animais.dart';
import '/features/animais/presentation/widgets/seletor_ordem_animais.dart';
import '/core/ui/app_card.dart';
import '/core/ui/confirmar_acao.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/features/prenhas/presentation/widgets/registro_aborto_widget.dart';
import '../widgets/registrar_parto_widget.dart';
import '../widgets/registrar_parto_induzido_widget.dart';
import '../widgets/registrar_pre_parto_widget.dart';
import '/features/prontuario/presentation/pages/prontuario_animal_page.dart';
import '/core/ui/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SecasPage extends StatefulWidget {
  const SecasPage({
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

  static String routeName = 'secas';
  static String routePath = '/secas';

  @override
  State<SecasPage> createState() => _SecasPageState();
}

class _SecasPageState extends State<SecasPage> with TickerProviderStateMixin {
  StreamSubscription<bool>? _conectividadeSub;
  bool? _respostaNet = true;
  FocusNode? _searchListFocusNode;
  TextEditingController? _searchListTextController;
  TabController? _tabBarController;

  /// Marcação de vários animais na aba "Descarte".
  final _selecao = SelecaoAnimais();

  /// Lista de animais existentes (fonte ObjectBox). Antes em
  /// FFAppState.animaisProdutoresExistentes; agora estado local desta tela.
  List<AnimaisProdutoresStruct> _animaisExistentes = [];

  /// Critério e direção da ordem, nos mesmos chips da lista de animais, com o
  /// terceiro chip "Inseminação" — o padrão desta tela, porque para secagem o
  /// que importa é a data (crescente = mais antigas primeiro).
  OrdemAnimais _ordem = OrdemAnimais.inseminacao;
  bool _crescente = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Fonte única: carrega a lista do ObjectBox (offline-first). A tela renderiza
    // sempre desta lista; o Firestore é usado apenas para sincronizar.
    _recarregarAnimais();

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
      length: 4,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {
          // A seleção é da aba "Descarte": sair dela desmarca tudo.
          if (_tabBarController!.index != AbaSecas.descarte.index) {
            _selecao.sair();
          }
        }));

    _searchListTextController ??= TextEditingController();
    _searchListFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _conectividadeSub?.cancel();
    _searchListFocusNode?.dispose();
    _searchListTextController?.dispose();
    _tabBarController?.dispose();

    super.dispose();
  }

  /// Lista de UMA aba: filtra antes de construir e deixa o `ListView`
  /// virtualizar.
  ///
  /// A versao anterior fazia o oposto nos tres pontos: iterava o rebanho
  /// inteiro, escondia card por card com `Visibility` (que esconde um widget
  /// JA montado) e usava `shrinkWrap: true` dentro de um
  /// `SingleChildScrollView`, o que obriga a montar todos os itens de uma vez
  /// para medir a altura. Medido numa propriedade de 3 animais: 2304 cards
  /// construidos para 1 visivel, e 4608 durante a animacao de troca de aba.
  Widget _abaLista(
    AbaSecas aba,
    Widget Function(BuildContext, AnimaisProdutoresStruct) card,
  ) {
    return _listaCards(_itensDaAba(aba), card);
  }

  /// Animais de uma aba, já com a busca e a ordem escolhida.
  List<AnimaisProdutoresStruct> _itensDaAba(AbaSecas aba) {
    return ordenarStructs(
      animaisDaAba(
        _animaisExistentes,
        aba: aba,
        busca: _searchListTextController?.text ?? '',
      ),
      ordem: _ordem,
      crescente: _crescente,
    );
  }

  Widget _listaCards(
    List<AnimaisProdutoresStruct> itens,
    Widget Function(BuildContext, AnimaisProdutoresStruct) card,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0),
      primary: false,
      itemCount: itens.length,
      itemBuilder: (context, i) => card(context, itens[i]),
    );
  }

  /// Recarrega a lista a partir do ObjectBox (fonte única offline-first).
  ///
  /// Chamado no `initState` e após CADA ação. Sem isto a tela renderiza a lista
  /// em memória carregada na abertura: a gravação acontece (inclusive offline),
  /// mas o animal continua exibido na aba antiga — parecendo que "nada
  /// aconteceu". Ex.: pré-parto muda o status de 'Seca' para 'Pré Parto', então
  /// o animal deve sair da aba "Vacas secas" e aparecer em "Pré Parto".
  void _recarregarAnimais() {
    if (ObjectBoxService.isInitialized) {
      // So os animais DESTA propriedade (consulta indexada), em vez de
      // `getAll()` com o rebanho inteiro do tecnico filtrado card a card.
      _animaisExistentes = AnimalRepository()
          .getAnimaisByPropriedade(widget.uidPropriedade?.path ?? '')
          .where((a) => !a.isDeleted)
          .map(animalEntityToStruct)
          .toList()
        // `getAll()` devolve ordem de insercao do ObjectBox, que espelha a
        // ordem de documentId do Firestore — nem numerica, nem alfabetica.
        ..sort(compararStructs);
      _selecao.manterApenas(
          animaisDaAba(_animaisExistentes, aba: AbaSecas.descarte)
              .map(_chaveAnimal));
    }
  }

  /// Identidade do animal na seleção: o documento no Firestore ou, para quem
  /// foi criado offline e ainda não subiu, a identidade local.
  String _chaveAnimal(AnimaisProdutoresStruct item) =>
      item.uidAnimal?.path ?? 'offline:${item.uidAnimalOffline}';

  // ---------------------------------------------------------------------------
  // Blocos visuais compartilhados pelos 4 cards (mesmo padrão das telas de
  // Inseminações, Diagnóstico de Gestação e Prenhas).
  // ---------------------------------------------------------------------------

  /// Envelopa o cartão: sombra suave, cantos arredondados e o InkWell que abre
  /// o prontuário do animal.
  ///
  /// [aoTocar] substitui a abertura do prontuário (no modo de seleção o toque
  /// marca o animal) e [marcado] contorna o card na cor da marca.
  Widget _linhaCard(
      BuildContext context, AnimaisProdutoresStruct item, Widget conteudo,
      {VoidCallback? aoTocar, VoidCallback? aoSegurar, bool marcado = false}) {
    return CartaoLista(
      marcado: marcado,
      aoSegurar: aoSegurar,
      aoTocar: aoTocar ??
          () async {
            context.pushNamed(
              ProntuarioAnimalPage.routeName,
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
                'uidAnimaisProdutores': serializeParam(
                  item.uidAnimal,
                  ParamType.DocumentReference,
                ),
                'grupoPredominante': serializeParam(
                  item.grupoAnimal,
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
      child: conteudo,
    );
  }

  /// Conteúdo do cartão no padrão de listas (`ConteudoCardAnimal`): avatar +
  /// nome, faixa de informações e as ações por último.
  Widget _conteudoCard(BuildContext context, AnimaisProdutoresStruct item,
      {required Widget botoes, required List<Widget> info}) {
    return ConteudoCardAnimal(
      grupo: item.grupoAnimal,
      titulo: tituloNomeBrinco(item.nomeAnimal, item.brincoAnimal),
      info: info,
      acoes: botoes,
    );
  }

  Widget _tileInfo(BuildContext context, String rotulo, String valor,
          {bool destaque = false, bool ehData = true}) =>
      InfoAnimal(rotulo, valor, destaque: destaque, ehData: ehData);

  FFButtonOptions _opcoesBotao(BuildContext context, Color cor) =>
      opcoesBotaoCard(context, cor);

  /// Painel do padrão de listas (`docs/padrao-layout-listas.md`): busca com a
  /// ordenação ao lado e as abas com quantos animais há em cada uma (já com a
  /// busca aplicada). A busca filtra as quatro listas.
  Widget _painelBuscaEAbas(BuildContext context) {
    return PainelLista(
      busca: CampoBuscaLista(
        controller: _searchListTextController!,
        focusNode: _searchListFocusNode,
        onChanged: (_) => safeSetState(() {}),
      ),
      linhas: [
        SeletorOrdemAnimais(
          ordem: _ordem,
          crescente: _crescente,
          mostrarInseminacao: true,
          alturaMinima: LayoutLista.alturaChip,
          raio: LayoutLista.raio,
          // Trocar de criterio recomeca crescente, como na lista de animais.
          onSelecionar: (nova) => safeSetState(() {
            _ordem = nova;
            _crescente = true;
          }),
          onInverter: () => safeSetState(() => _crescente = !_crescente),
        ),
      ],
      abas: AbasPilula(
        controller: _tabBarController!,
        abas: [
          AbaPilula('Vacas secas',
              contagem: _itensDaAba(AbaSecas.vacasSecas).length),
          AbaPilula('Pré-parto',
              contagem: _itensDaAba(AbaSecas.preParto).length),
          AbaPilula('Indução lactação',
              contagem: _itensDaAba(AbaSecas.inducaoLactacao).length),
          AbaPilula('Descarte',
              contagem: _itensDaAba(AbaSecas.descarte).length),
        ],
      ),
    );
  }

  /// Card da aba "Descarte". Segurar o card liga o modo de seleção; nele o
  /// toque marca o animal e os botões dão lugar à caixinha.
  Widget _buildCard4(BuildContext context, AnimaisProdutoresStruct item) {
    final chave = _chaveAnimal(item);
    final selecionando = _selecao.ativa;
    final marcado = _selecao.contem(chave);
    void alternar() => safeSetState(() => _selecao.alternar(chave));

    return _linhaCard(
      context,
      item,
      _conteudoCard(
        context,
        item,
        botoes: selecionando
            ? _marcador(context, marcado, alternar)
            : _part2(context, item),
        info: [
          _tileInfo(context, 'Data do descarte', item.dtDescarteAnimal),
          _tileInfo(context, 'Motivo', item.motivoDescarteAnimal,
              ehData: false),
        ],
      ),
      aoTocar: selecionando ? alternar : null,
      aoSegurar: selecionando
          ? alternar
          : () => safeSetState(() => _selecao.entrar(comChave: chave)),
      marcado: marcado,
    );
  }

  /// Caixinha do card no modo de seleção, na altura dos botões que ela
  /// substitui para o card não pular.
  Widget _marcador(BuildContext context, bool marcado, VoidCallback alternar) {
    return SizedBox(
      height: 40.0,
      child: Row(
        children: [
          Checkbox(
            value: marcado,
            onChanged: (_) => alternar(),
            activeColor: AppTokens.brand,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)),
          ),
          const SizedBox(width: 4.0),
          Text(
            marcado ? 'Selecionado' : 'Toque para selecionar',
            style: GoogleFonts.readexPro(
              color: marcado
                  ? AppTokens.brand
                  : FlutterFlowTheme.of(context).secondaryText,
              fontSize: 13.0,
              fontWeight: marcado ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  /// Aba "Descarte": barra de seleção no topo, lista e, com algum animal
  /// marcado, o rodapé com as ações em lote.
  Widget _abaDescarte(BuildContext context) {
    final itens = _itensDaAba(AbaSecas.descarte);
    return Column(
      children: [
        if (itens.isNotEmpty)
          _barraSelecao(context, itens.map(_chaveAnimal).toList()),
        Expanded(child: _listaCards(itens, _buildCard4)),
        if (_selecao.quantidade > 0) _rodapeSelecao(context),
      ],
    );
  }

  Widget _barraSelecao(BuildContext context, List<String> visiveis) {
    final tema = FlutterFlowTheme.of(context);
    final estiloTexto =
        GoogleFonts.readexPro(color: tema.secondaryText, fontSize: 13.0);
    final estiloAcao = GoogleFonts.readexPro(fontWeight: FontWeight.w600);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 8.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: _selecao.ativa
            ? Row(
                children: [
                  Checkbox(
                    value: _selecao.todosMarcados(visiveis),
                    onChanged: (_) =>
                        safeSetState(() => _selecao.alternarTodos(visiveis)),
                    activeColor: AppTokens.brand,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                  ),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: Text(
                      _selecao.quantidade == 0
                          ? 'Selecionar todos'
                          : '${rotuloAnimais(_selecao.quantidade)} '
                              '${_selecao.quantidade == 1 ? 'selecionado' : 'selecionados'}',
                      style: estiloTexto.copyWith(
                          color: tema.primaryText, fontWeight: FontWeight.w600),
                    ),
                  ),
                  TextButton(
                    onPressed: () => safeSetState(_selecao.sair),
                    style: TextButton.styleFrom(
                        foregroundColor: tema.secondaryText,
                        textStyle: estiloAcao),
                    child: const Text('Cancelar'),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Text(
                      '${rotuloAnimais(visiveis.length)} no descarte',
                      style: estiloTexto,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => safeSetState(() => _selecao.entrar()),
                    icon: const Icon(Icons.checklist_rounded, size: 18.0),
                    label: const Text('Selecionar'),
                    style: TextButton.styleFrom(
                        foregroundColor: AppTokens.brand,
                        textStyle: estiloAcao),
                  ),
                ],
              ),
      ),
    );
  }

  /// Ações em lote. Fica fixo embaixo para o técnico rolar e marcar sem perder
  /// o botão de vista.
  Widget _rodapeSelecao(BuildContext context) {
    final n = _selecao.quantidade;
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16.0,
            offset: Offset(0.0, -6.0),
          ),
        ],
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: FFButtonWidget(
                onPressed: _restaurarSelecionados,
                text: 'Restaurar',
                icon: Icon(Icons.restore, size: 15.0),
                options: _opcoesBotao(context, AppTokens.brand),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: FFButtonWidget(
                onPressed: _eliminarSelecionados,
                text: 'Eliminar $n',
                icon: Icon(Icons.delete_outline_rounded, size: 15.0),
                options: _opcoesBotao(context, AppTokens.negativo),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Os marcados que ainda estão no descarte, inclusive os escondidos pela
  /// busca: a contagem do rodapé é a seleção inteira.
  List<AnimaisProdutoresStruct> _selecionados() =>
      animaisDaAba(_animaisExistentes, aba: AbaSecas.descarte)
          .where((a) => _selecao.contem(_chaveAnimal(a)))
          .toList();

  Future<void> _eliminarSelecionados() async {
    final alvos = _selecionados();
    if (alvos.isEmpty) return;
    final n = alvos.length;
    final confirmou = await confirmarAcao(
      context,
      titulo: n == 1 ? 'Eliminar o animal?' : 'Eliminar $n animais?',
      mensagem: '${rotuloAnimais(n)} '
          '${n == 1 ? 'será eliminado' : 'serão eliminados'}. '
          'Essa ação é irreversível.',
      textoConfirmar: 'Eliminar',
      perigosa: true,
    );
    if (!confirmou) return;
    final repo = AnimalRepository();
    for (final item in alvos) {
      final entidade = _entidade(repo, item);
      if (entidade != null) await repo.softDelete(entidade);
    }
    _concluirLote('${rotuloAnimais(n)} '
        '${n == 1 ? 'eliminado' : 'eliminados'}');
  }

  Future<void> _restaurarSelecionados() async {
    final alvos = _selecionados();
    if (alvos.isEmpty) return;
    final n = alvos.length;
    final confirmou = await confirmarAcao(
      context,
      titulo: n == 1 ? 'Restaurar o animal?' : 'Restaurar $n animais?',
      mensagem: n == 1
          ? 'Ele voltará para a lista do rebanho com o status vazia.'
          : 'Eles voltarão para a lista do rebanho com o status vazia.',
      textoConfirmar: 'Restaurar',
    );
    if (!confirmou) return;
    final repo = AnimalRepository();
    for (final item in alvos) {
      final entidade = _entidade(repo, item);
      if (entidade != null) {
        await repo.update(entidade, {'status': 'Vazia', 'idStatusAnimal': 2});
      }
    }
    _concluirLote('${rotuloAnimais(n)} '
        '${n == 1 ? 'restaurado' : 'restaurados'}');
  }

  void _concluirLote(String aviso) {
    _selecao.sair();
    _recarregarAnimais();
    safeSetState(() {});
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(aviso)));
  }

  /// Card da aba "Indução Lactação".
  Widget _buildCard3(BuildContext context, AnimaisProdutoresStruct item) {
    return _linhaCard(
      context,
      item,
      _conteudoCard(
        context,
        item,
        botoes: _botaoInduzirLactacao(context, item),
        info: [
          _tileInfo(
            context,
            'Indução lactação',
            dateTimeFormat(
              "dd/MM/yyyy",
              item.dtInducaoLactacao,
              locale: FFLocalizations.of(context).languageCode,
            ),
            destaque: true,
          ),
        ],
      ),
    );
  }

  Widget _botaoInduzirLactacao(
      BuildContext context, AnimaisProdutoresStruct item) {
    return Row(
      children: [
        Expanded(
          child: FFButtonWidget(
            onPressed: () async {
              if ((item.grupoAnimal == 'Novilha') ||
                  (ehNovilha(item.grupoAnimal))) {
                item.grupoAnimal = 'Vacas';
                safeSetState(() {});
              }

              await showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                enableDrag: false,
                context: context,
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: Padding(
                      padding: MediaQuery.viewInsetsOf(context),
                      child: RegistrarPartoInduzidoWidget(
                        uidPropriedade: widget.uidPropriedade!,
                        nomePropriedade: widget.nomePropriedade!,
                        uidTecnico: widget.uidTecnico!,
                        emailPropriedade: widget.emailPropriedade!,
                        visitaPresencial: widget.visitaPresencial!,
                        diasDg: widget.diasDg!,
                        uidAnimaisProdutores: item.uidAnimal!,
                        nomeAnimal: item.nomeAnimal,
                      ),
                    ),
                  );
                },
              ).then((value) {
                _recarregarAnimais();
                safeSetState(() {});
              });
            },
            text: 'Induzir lactação',
            icon: Icon(
              Icons.add_alert,
              size: 15.0,
            ),
            options: _opcoesBotao(context, AppTokens.brand),
          ),
        ),
      ],
    );
  }

  /// Card da aba "Pré Parto".
  Widget _buildCard2(BuildContext context, AnimaisProdutoresStruct item) {
    return _linhaCard(
      context,
      item,
      _conteudoCard(
        context,
        item,
        botoes: _part4(context, item),
        info: _datasCiclo(context, item),
      ),
    );
  }

  /// Card da aba "Vacas secas".
  Widget _buildCard1(BuildContext context, AnimaisProdutoresStruct item) {
    return _linhaCard(
      context,
      item,
      _conteudoCard(
        context,
        item,
        botoes: _part6(context, item),
        info: _datasCiclo(context, item),
      ),
    );
  }

  /// As três datas do ciclo (secas e pré-parto). O parto previsto recebe
  /// destaque por ser a data que o técnico usa para se programar.
  List<Widget> _datasCiclo(BuildContext context, AnimaisProdutoresStruct item) {
    return [
      _tileInfo(context, 'Inseminada', item.dtUltimaInseminacao),
      _tileInfo(context, 'Pré parto prev.', item.dtPrePartoPrevista),
      _tileInfo(context, 'Parto previsto', item.dtPartoPrevisto,
          destaque: true),
    ];
  }

  /// Ações da aba "Descarte". Confirmar ou cancelar fecha só o diálogo: a
  /// tela fica aberta para o técnico seguir com o próximo animal. Antes um
  /// `Navigator.pop(context)` a mais fechava a tela e ele voltava ao menu a
  /// cada vaca.
  Widget _part2(BuildContext context, AnimaisProdutoresStruct item) {
    return Row(
      children: [
        Expanded(
          child: FFButtonWidget(
            onPressed: () => _restaurar(item),
            text: 'Restaurar',
            icon: Icon(
              Icons.restore,
              size: 15.0,
            ),
            options: _opcoesBotao(context, AppTokens.brand),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: FFButtonWidget(
            onPressed: () => _eliminar(item),
            text: 'Eliminar',
            icon: Icon(
              Icons.delete_outline_rounded,
              size: 15.0,
            ),
            options: _opcoesBotao(context, AppTokens.negativo),
          ),
        ),
      ],
    );
  }

  /// O animal no ObjectBox: pelo id do Firestore ou, se foi criado offline,
  /// pela identidade local.
  AnimalEntity? _entidade(AnimalRepository repo, AnimaisProdutoresStruct item) {
    if (item.uidAnimal != null)
      return repo.getByFirestoreId(item.uidAnimal!.id);
    if (item.uidAnimalOffline.isNotEmpty) {
      return repo.getByUidAnimalOffline(item.uidAnimalOffline);
    }
    return null;
  }

  /// Devolve o animal ao rebanho com status 'Vazia' (offline-first: grava no
  /// ObjectBox e o repositório sincroniza).
  Future<void> _restaurar(AnimaisProdutoresStruct item) async {
    final confirmou = await confirmarAcao(
      context,
      titulo: 'Restaurar o animal?',
      mensagem: 'Ele voltará para a lista do rebanho com o status vazia.',
      textoConfirmar: 'Restaurar',
    );
    if (!confirmou) return;
    final repo = AnimalRepository();
    final entidade = _entidade(repo, item);
    if (entidade != null) {
      await repo.update(entidade, {'status': 'Vazia', 'idStatusAnimal': 2});
    }
    _recarregarAnimais();
    safeSetState(() {});
  }

  /// Exclusão offline-first: soft delete no ObjectBox; o sync (online
  /// imediato ou fila ao reconectar) propaga.
  Future<void> _eliminar(AnimaisProdutoresStruct item) async {
    final confirmou = await confirmarAcao(
      context,
      titulo: 'Eliminar o animal?',
      mensagem: 'Essa ação é irreversível.',
      textoConfirmar: 'Eliminar',
      perigosa: true,
    );
    if (!confirmou) return;
    final repo = AnimalRepository();
    final entidade = _entidade(repo, item);
    if (entidade != null) await repo.softDelete(entidade);
    // Recarrega do ObjectBox (o soft delete já o exclui da lista) em vez de
    // mexer no índice da lista em memória.
    _recarregarAnimais();
    safeSetState(() {});
  }

  Widget _part4(BuildContext context, AnimaisProdutoresStruct item) {
    return Row(
      children: [
        Expanded(
          child: FFButtonWidget(
            onPressed: () async {
              await showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                enableDrag: false,
                context: context,
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: Padding(
                      padding: MediaQuery.viewInsetsOf(context),
                      child: RegistrarPartoWidget(
                        uidPropriedade: widget.uidPropriedade!,
                        nomePropriedade: widget.nomePropriedade!,
                        uidTecnico: widget.uidTecnico!,
                        emailPropriedade: widget.emailPropriedade!,
                        visitaPresencial: widget.visitaPresencial!,
                        diasDg: widget.diasDg!,
                        uidAnimaisProdutores: item.uidAnimal,
                        uidAnimalOffline: item.uidAnimalOffline,
                        nomeVacaAtual: item.nomeAnimal,
                        nomeTourtoUltimaInseminacao:
                            item.nomeTouroUltimaInseminacao,
                        brincoVacaAtual: item.brincoAnimal.toString(),
                      ),
                    ),
                  );
                },
              ).then((value) {
                _recarregarAnimais();
                safeSetState(() {});
              });
            },
            text: 'Parto',
            icon: Icon(
              Icons.add_alert,
              size: 15.0,
            ),
            options: _opcoesBotao(context, AppTokens.positivo),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: FFButtonWidget(
            onPressed: () async {
              await showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                enableDrag: false,
                context: context,
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: Padding(
                      padding: MediaQuery.viewInsetsOf(context),
                      child: RegistroAbortoWidget(
                        uidPropriedade: widget.uidPropriedade!,
                        nomePropriedade: widget.nomePropriedade!,
                        uidTecnico: widget.uidTecnico!,
                        emailPropriedade: widget.emailPropriedade!,
                        visitaPresencial: widget.visitaPresencial!,
                        diasDg: widget.diasDg!,
                        uidAnimaisProdutores: item.uidAnimal,
                        uidAnimalOffline: item.uidAnimalOffline,
                        nomeAnimal: item.nomeAnimal,
                      ),
                    ),
                  );
                },
              ).then((value) {
                _recarregarAnimais();
                safeSetState(() {});
              });
            },
            text: 'Aborto',
            icon: Icon(
              Icons.cancel_sharp,
              size: 15.0,
            ),
            options: _opcoesBotao(context, AppTokens.negativo),
          ),
        ),
      ],
    );
  }

  /// Ações da aba "Vacas secas": Parto · Pré-parto e o Aborto (negativo)
  /// por último, na ponta direita — regra do padrão de listas.
  Widget _part6(BuildContext context, AnimaisProdutoresStruct item) {
    return Row(
      children: [
        Expanded(
          child: FFButtonWidget(
            onPressed: () async {
              await showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                enableDrag: false,
                context: context,
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: Padding(
                      padding: MediaQuery.viewInsetsOf(context),
                      child: RegistrarPartoWidget(
                        uidPropriedade: widget.uidPropriedade!,
                        nomePropriedade: widget.nomePropriedade!,
                        uidTecnico: widget.uidTecnico!,
                        emailPropriedade: widget.emailPropriedade!,
                        visitaPresencial: widget.visitaPresencial!,
                        diasDg: widget.diasDg!,
                        uidAnimaisProdutores: item.uidAnimal,
                        uidAnimalOffline: item.uidAnimalOffline,
                        nomeVacaAtual: item.nomeAnimal,
                        nomeTourtoUltimaInseminacao:
                            item.nomeTouroUltimaInseminacao,
                        brincoVacaAtual: item.brincoAnimal.toString(),
                      ),
                    ),
                  );
                },
              ).then((value) {
                _recarregarAnimais();
                safeSetState(() {});
              });
            },
            text: 'Parto',
            icon: Icon(
              Icons.add_alert,
              size: 15.0,
            ),
            options: _opcoesBotao(context, AppTokens.positivo),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: FFButtonWidget(
            onPressed: () async {
              await showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                enableDrag: false,
                context: context,
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: Padding(
                      padding: MediaQuery.viewInsetsOf(context),
                      child: RegistrarPrePartoWidget(
                        uidPropriedade: widget.uidPropriedade!,
                        nomePropriedade: widget.nomePropriedade!,
                        uidTecnico: widget.uidTecnico!,
                        emailPropriedade: widget.emailPropriedade!,
                        visitaPresencial: widget.visitaPresencial!,
                        diasDg: widget.diasDg!,
                        uidAnimaisProdutores: item.uidAnimal!,
                        nomeAnimal: item.nomeAnimal,
                        brincoAnimal: item.brincoAnimal.toString(),
                        grupoAnimal: item.grupoAnimal,
                        dtPrePartoPrevista: functions
                            .converteDataStringDate(item.dtPrePartoPrevista),
                      ),
                    ),
                  );
                },
              ).then((value) {
                _recarregarAnimais();
                safeSetState(() {});
              });
            },
            text: 'Pré-parto',
            icon: Icon(
              Icons.check,
              size: 15.0,
            ),
            options: _opcoesBotao(context, AppTokens.brand),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: FFButtonWidget(
            onPressed: () async {
              await showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                enableDrag: false,
                context: context,
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: Padding(
                      padding: MediaQuery.viewInsetsOf(context),
                      child: RegistroAbortoWidget(
                        uidPropriedade: widget.uidPropriedade!,
                        nomePropriedade: widget.nomePropriedade!,
                        uidTecnico: widget.uidTecnico!,
                        emailPropriedade: widget.emailPropriedade!,
                        visitaPresencial: widget.visitaPresencial!,
                        diasDg: widget.diasDg!,
                        uidAnimaisProdutores: item.uidAnimal,
                        uidAnimalOffline: item.uidAnimalOffline,
                        nomeAnimal: item.nomeAnimal,
                      ),
                    ),
                  );
                },
              ).then((value) {
                _recarregarAnimais();
                safeSetState(() {});
              });
            },
            text: 'Aborto',
            icon: Icon(
              Icons.cancel_sharp,
              size: 15.0,
            ),
            options: _opcoesBotao(context, AppTokens.negativo),
          ),
        ),
      ],
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
        appBar: CabecalhoTela(
          titulo: 'Animais em secagem',
          online: _respostaNet ?? true,
          aoVoltar: () {
            // No modo de seleção, voltar só cancela a seleção.
            if (_selecao.ativa) {
              safeSetState(_selecao.sair);
              return;
            }
            context.safePop();
          },
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                children: [
                  _painelBuscaEAbas(context),
                  Expanded(
                    child: TabBarView(
                      controller: _tabBarController,
                      children: [
                        _abaLista(AbaSecas.vacasSecas, _buildCard1),
                        _abaLista(AbaSecas.preParto, _buildCard2),
                        _abaLista(AbaSecas.inducaoLactacao, _buildCard3),
                        _abaDescarte(context),
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
  }
}
