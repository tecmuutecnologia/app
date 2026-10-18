// ignore_for_file: unnecessary_null_comparison, unused_import

import '/core/ui/cabecalho_tela.dart';
import 'dart:async';

import '/core/connectivity/connectivity_service.dart';
import '/data/backend.dart';
import '/core/ui/app_card.dart';
import '/data/objectbox/index.dart';
import '/features/prenhas/application/filtros_prenhas.dart';
import '/domain/animais/classificacao_animal.dart';
import '/domain/animais/ordenacao_animal.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/card_animal_lista.dart';
import '/core/ui/painel_lista.dart';
import '/features/animais/application/ordenacao_animais.dart';
import '/features/animais/presentation/widgets/seletor_ordem_animais.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/features/animais/presentation/widgets/descarte_animal_widget.dart';
import '../widgets/registrar_secagem_widget.dart';
import '../widgets/registro_aborto_widget.dart';
import '/features/sincronizacao/presentation/widgets/alerta_sem_internet_widget.dart';
import '/core/ui/custom_functions.dart' as functions;
import '/features/propriedades/presentation/pages/inicio_propriedade_page.dart';
import '/features/prontuario/presentation/pages/prontuario_animal_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AnimaisPrenhasPage extends StatefulWidget {
  const AnimaisPrenhasPage({
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

  static String routeName = 'animaisPrenhas';
  static String routePath = '/animaisPrenhas';

  @override
  State<AnimaisPrenhasPage> createState() => _AnimaisPrenhasPageState();
}

class _AnimaisPrenhasPageState extends State<AnimaisPrenhasPage> {
  StreamSubscription<bool>? _conectividadeSub;
  bool? _respostaNet = true;
  FocusNode? _searchListFocusNode;
  TextEditingController? _searchListTextController;

  /// Lista de animais existentes (fonte ObjectBox). Antes em
  /// FFAppState.animaisProdutoresExistentes; agora estado local desta tela.
  List<AnimaisProdutoresStruct> _animaisExistentes = [];

  /// Critério e direção da ordem, nos chips do padrão de listas. Começa por
  /// inseminação, mais antigas primeiro: as prenhas mais adiantadas, que
  /// parem antes, aparecem no topo.
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

  /// Recarrega a lista a partir do ObjectBox (fonte única offline-first).
  /// Chamado no `initState` e após cada ação (Aborto/Secagem), para o animal
  /// que deixa de estar prenhe sumir do card imediatamente.
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

  /// Card de um animal da lista. O filtro acontece antes, em
  /// `prenhasVisiveis` — aqui so se desenha.
  Widget _itemPrenha(BuildContext context, AnimaisProdutoresStruct item) {
    return _linhaCard(context, item);
  }

  /// Card no padrão de listas: avatar + nome, as três datas do ciclo da
  /// prenhez (a previsão de parto em destaque) e as ações por último. Tocar
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
        info: [
          InfoAnimal('Inseminada', item.dtUltimaInseminacao),
          InfoAnimal('Prev. parto', item.dtPartoPrevisto, destaque: true),
          InfoAnimal('Sec. prevista', item.dtSecPrevista),
        ],
        acoes: _botoesAcao(context, item),
      ),
    );
  }

  /// Ações do card. "Secagem" só aparece para animal que está lactando: vaca,
  /// ou novilha com lactação induzida. Novilha prenha nunca lactou — registrar
  /// secagem nela a deixaria com status 'Seca' e grupo 'Novilhas', invisível
  /// tanto aqui quanto na tela de Secas (que filtra ehVacaSeca, só Vacas).
  Widget _botoesAcao(BuildContext context, AnimaisProdutoresStruct item) {
    final podeSecar =
        ehVaca(item.grupoAnimal) || (item.dtInducaoLactacao != null);
    // Aborto (negativo) por último, na ponta direita — como o DG- no
    // diagnóstico de gestação.
    return LinhaAcoes(children: [
      if (podeSecar) _botaoSecagem(context, item),
      _botaoAborto(context, item),
    ]);
  }

  Widget _botaoAborto(BuildContext context, AnimaisProdutoresStruct item) {
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
        Icons.cancel_outlined,
        size: 15.0,
      ),
      options: _opcoesBotao(context, FlutterFlowTheme.of(context).error),
    );
  }

  Widget _botaoSecagem(BuildContext context, AnimaisProdutoresStruct item) {
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
                child: RegistrarSecagemWidget(
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
                  dtSecPrevista:
                      functions.converteDataStringDate(item.dtSecPrevista),
                ),
              ),
            );
          },
        ).then((value) {
          _recarregarAnimais();
          safeSetState(() {});
        });
      },
      text: 'Secagem',
      icon: Icon(
        Icons.water_drop_outlined,
        size: 15.0,
      ),
      // Verde do app: o azul destoava da paleta laranja/verde/vermelho.
      options: _opcoesBotao(context, AppTokens.positivo),
    );
  }

  /// Estilo compartilhado dos botões de ação (mesma métrica das telas de
  /// inseminações e diagnóstico de gestação).
  FFButtonOptions _opcoesBotao(BuildContext context, Color cor) =>
      opcoesBotaoCard(context, cor);

  /// Lista na ordem escolhida nos chips (padrão: inseminação, mais antigas
  /// primeiro).
  List<AnimaisProdutoresStruct> _animaisOrdenados() =>
      ordenarStructs(_animaisExistentes, ordem: _ordem, crescente: _crescente);

  @override
  Widget build(BuildContext context) {
    // context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: CabecalhoTela(
          titulo: 'Prenhas',
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
                  mostrarInseminacao: true,
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
            // diferenca era so o filtro de busca, que mora em
            // `prenhasVisiveis`.
            Expanded(
              child: Builder(
                builder: (context) {
                  final visiveis = prenhasVisiveis(
                    _animaisOrdenados(),
                    busca: _searchListTextController.text,
                  );
                  return ListView.builder(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 8.0, 0.0, 120.0),
                    primary: false,
                    itemCount: visiveis.length,
                    itemBuilder: (context, i) =>
                        _itemPrenha(context, visiveis[i]),
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
