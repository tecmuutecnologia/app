// ignore_for_file: unnecessary_null_comparison
import '/core/ui/cabecalho_tela.dart';
import 'dart:async';

import '/features/shared/widgets/selo_hoje.dart';
import '/core/connectivity/connectivity_service.dart';
import '/data/backend.dart';
import '/core/ui/app_card.dart';
import '/data/objectbox/index.dart';
import '/features/exame_ginecologico/application/filtros_exame.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/card_animal_lista.dart';
import '/core/ui/painel_lista.dart';
import '/features/animais/application/ordenacao_animais.dart';
import '/features/animais/presentation/widgets/seletor_ordem_animais.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '../widgets/nova_acao_exame_ginecologico_widget.dart';
import '/features/prontuario/presentation/pages/prontuario_animal_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class ExameGinecologicoPage extends StatefulWidget {
  const ExameGinecologicoPage({
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

  static String routeName = 'exameGinecologico';
  static String routePath = '/exameGinecologico';

  @override
  State<ExameGinecologicoPage> createState() => _ExameGinecologicoPageState();
}

class _ExameGinecologicoPageState extends State<ExameGinecologicoPage> {
  StreamSubscription<bool>? _conectividadeSub;
  bool? _respostaNet = true;
  FocusNode? _searchListFocusNode;
  TextEditingController? _searchListTextController;

  /// Lista de animais existentes (fonte ObjectBox). Antes em
  /// FFAppState.animaisProdutoresExistentes; agora estado local desta tela.
  List<AnimaisProdutoresStruct> _animaisExistentes = [];

  /// Critério e direção da ordem, nos chips do padrão de listas (Nome A-Z /
  /// Brinco). Tocar no chip ativo inverte a direção.
  OrdemAnimais _ordem = OrdemAnimais.nome;
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

    _searchListTextController ??= TextEditingController();
    _searchListFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _conectividadeSub?.cancel();
    _searchListFocusNode?.dispose();
    _searchListTextController?.dispose();

    super.dispose();
  }

  /// Card extraído do build (Fase 4).
  /// Recarrega a lista a partir do ObjectBox (fonte única offline-first).
  /// Chamado no `initState` e após a ação, para o animal que deixa de estar
  /// vazio sumir da lista imediatamente (inclusive offline).
  void _recarregarAnimais() {
    if (ObjectBoxService.isInitialized) {
      // So os animais DESTA propriedade (consulta indexada), em vez do
      // rebanho inteiro do tecnico filtrado card a card.
      _animaisExistentes = AnimalRepository()
          .getAnimaisByPropriedade(widget.uidPropriedade?.path ?? '')
          .where((a) => !a.isDeleted)
          .map(animalEntityToStruct)
          .toList()
        // A consulta do ObjectBox devolve ordem de insercao, que espelha a
        // ordem de documentId do Firestore — nem numerica, nem alfabetica.
        ..sort(compararStructs);
    }
  }

  /// `true` quando o animal entra na lista de exame ginecológico: é da
  /// propriedade, está Vazia, é Vaca/Novilha e não tem lactação induzida.
  /// Card de um animal da lista. O filtro acontece antes, em
  /// `elegiveisExame` — aqui so se desenha.
  Widget _itemExame(BuildContext context, AnimaisProdutoresStruct item) {
    return _linhaCard(context, item);
  }

  /// Card no padrão de listas: avatar + nome com o selo "Hoje", a última ação
  /// e o status na faixa de informações e o botão "Ação" por último. Tocar
  /// abre o prontuário.
  Widget _linhaCard(BuildContext context, AnimaisProdutoresStruct item) {
    return CartaoLista(
      aoTocar: () async {
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
      child: ConteudoCardAnimal(
        grupo: item.grupoAnimal,
        titulo: tituloNomeBrinco(item.nomeAnimal, item.brincoAnimal),
        selo: SeloHoje(dtUltimaAcao: item.dtUltimaAcao),
        info: [
          InfoAnimal('Última ação', item.dtUltimaAcao),
          InfoAnimal('Status', item.status, ehData: false),
        ],
        acoes: LinhaAcoes(children: [_botaoAcao(context, item)]),
      ),
    );
  }

  Widget _botaoAcao(BuildContext context, AnimaisProdutoresStruct item) {
    return FFButtonWidget(
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
                child: NovaAcaoExameGinecologicoWidget(
                  uidPropriedade: widget.uidPropriedade!,
                  nomePropriedade: widget.nomePropriedade!,
                  uidTecnico: widget.uidTecnico!,
                  emailPropriedade: widget.emailPropriedade!,
                  visitaPresencial: widget.visitaPresencial!,
                  diasDg: widget.diasDg!,
                  uidAnimaisProdutores: item.uidAnimal,
                  uidAnimalOffline: item.uidAnimalOffline,
                  nomeAnimal: item.nomeAnimal,
                  brincoAnimal: item.brincoAnimal.toString(),
                  grupoAnimal: item.grupoAnimal,
                ),
              ),
            );
          },
        ).then((value) {
          _recarregarAnimais();
          safeSetState(() {});
        });
      },
      text: 'Ação',
      icon: Icon(
        Icons.add_alert,
        size: 15.0,
      ),
      // Verde, como as demais ações de registro do padrão de listas.
      options: _opcoesBotao(context, AppTokens.positivo),
    );
  }

  /// Estilo compartilhado dos botões de ação — mesma métrica das demais telas.
  FFButtonOptions _opcoesBotao(BuildContext context, Color cor) =>
      opcoesBotaoCard(context, cor);

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
          titulo: 'Exame ginecológico',
          online: _respostaNet ?? true,
        ),
        body: Column(
          children: [
            PainelLista(
              busca: CampoBuscaLista(
                controller: _searchListTextController!,
                focusNode: _searchListFocusNode,
                onChanged: (_) => safeSetState(() {}),
              ),
              linhas: [
                SeletorOrdemAnimais(
                  ordem: _ordem,
                  crescente: _crescente,
                  alturaMinima: LayoutLista.alturaChip,
                  raio: LayoutLista.raio,
                  // Trocar de criterio recomeca crescente, como na lista de
                  // animais.
                  onSelecionar: (nova) => safeSetState(() {
                    _ordem = nova;
                    _crescente = true;
                  }),
                  onInverter: () =>
                      safeSetState(() => _crescente = !_crescente),
                ),
              ],
            ),
            // O painel fica fixo; só a lista rola. UMA lista, nao duas: a
            // diferenca era so o filtro de busca, que mora em `elegiveisExame`.
            Expanded(
              child: Builder(
                builder: (context) {
                  final visiveis = ordenarStructs(
                    elegiveisExame(
                      _animaisExistentes,
                      busca: _searchListTextController.text,
                    ),
                    ordem: _ordem,
                    crescente: _crescente,
                  );
                  return ListView.builder(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 8.0, 0.0, 120.0),
                    primary: false,
                    itemCount: visiveis.length,
                    itemBuilder: (context, i) =>
                        _itemExame(context, visiveis[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
