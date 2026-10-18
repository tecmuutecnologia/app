// ignore_for_file: unnecessary_null_comparison
import '/core/ui/cabecalho_tela.dart';
import 'dart:async';

import '/core/connectivity/connectivity_service.dart';
import '/data/backend.dart';
import '/core/ui/app_card.dart';
import '/core/ui/card_animal_lista.dart';
import '/core/ui/painel_lista.dart';
import '/domain/animais/classificacao_animal.dart';
import '/data/objectbox/index.dart';
import '/features/diagnostico_gestacao/application/filtros_dg.dart';
import '/features/shared/widgets/selo_hoje.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/features/animais/application/ordenacao_animais.dart';
import '/features/animais/presentation/widgets/seletor_ordem_animais.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '../widgets/dg_mais_widget.dart';
import '../widgets/dg_menos_widget.dart';
import '../widgets/confirma_pp_widget.dart';
import '/features/prontuario/presentation/pages/prontuario_animal_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DiagnosticogestacaoPage extends StatefulWidget {
  const DiagnosticogestacaoPage({
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

  static String routeName = 'diagnosticogestacao';
  static String routePath = '/diagnosticogestacao';

  @override
  State<DiagnosticogestacaoPage> createState() =>
      _DiagnosticogestacaoPageState();
}

class _DiagnosticogestacaoPageState extends State<DiagnosticogestacaoPage> {
  StreamSubscription<bool>? _conectividadeSub;
  bool? _respostaNet = true;
  FocusNode? _searchListFocusNode;
  TextEditingController? _searchListTextController;

  /// Lista de animais existentes (fonte ObjectBox). Antes em
  /// FFAppState.animaisProdutoresExistentes; agora estado local desta tela.
  List<AnimaisProdutoresStruct> _animaisExistentes = [];

  /// Critério e direção da ordem, nos mesmos chips da lista de animais
  /// (Nome A-Z / Brinco). Tocar no chip ativo inverte a direção.
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

  /// Recarrega a lista a partir do ObjectBox (fonte única offline-first). Chamado
  /// no `initState` e após cada ação (DG+/DG-/PP) para refletir imediatamente as
  /// mudanças de status: DG+ (Prenha) e DG- (Vazia) removem o card; PP habilita
  /// o botão DG+.
  void _recarregarAnimais() {
    if (ObjectBoxService.isInitialized) {
      // So os animais DESTA propriedade (consulta indexada), em vez do
      // rebanho inteiro do tecnico filtrado card a card.
      _animaisExistentes = AnimalRepository()
          .getAnimaisByPropriedade(widget.uidPropriedade?.path ?? '')
          .where((a) => !a.isDeleted)
          .map(animalEntityToStruct)
          .toList();
    }
  }

  /// `true` quando o animal está vencido para diagnóstico de gestação: é da
  /// propriedade, tem data de última inseminação, é Vaca/Novilha, está
  /// Inseminada ou Inseminada PP, e já passou do prazo (dtUltimaInseminacao +
  /// diasDg <= hoje). Mesma regra usada na lista e na busca.
  /// Card de um animal da lista. O filtro acontece antes, em
  /// `vencidosParaDg` — aqui so se desenha.
  Widget _itemDgElegivel(BuildContext context, AnimaisProdutoresStruct item) {
    return _linhaAnimal(context, item);
  }

  /// Card no padrão de listas: título com o selo "Hoje", touro e data da
  /// inseminação na faixa de informações e as ações PP / DG+ / DG- por último.
  /// Tocar abre o prontuário.
  Widget _linhaAnimal(BuildContext context, AnimaisProdutoresStruct item) {
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
          InfoAnimal('Touro', item.nomeTouroUltimaInseminacao, ehData: false),
          InfoAnimal('Inseminada em', item.dtUltimaInseminacao),
        ],
        // Ordem do fluxo positivo (PP → DG+) e o negativo por último.
        acoes: LinhaAcoes(children: [
          _botaoPp(context, item),
          _botaoDgMais(context, item),
          _botaoDgMenos(context, item),
        ]),
      ),
    );
  }

  /// PP — marca prenhez parcial. Primeiro à esquerda. Verde-azulado.
  Widget _botaoPp(BuildContext context, AnimaisProdutoresStruct item) {
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
                child: ConfirmaPpWidget(
                  uidPropriedade: widget.uidPropriedade!,
                  nomePropriedade: widget.nomePropriedade!,
                  uidTecnico: widget.uidTecnico!,
                  emailPropriedade: widget.emailPropriedade!,
                  uidAnimaisProdutores: item.uidAnimal,
                  uidAnimalOffline: item.uidAnimalOffline,
                  grupoPredominante: item.grupoAnimal,
                  nomeAnimal: item.nomeAnimal,
                  visitaPresencial: widget.visitaPresencial!,
                  diasDg: widget.diasDg!,
                ),
              ),
            );
          },
        ).then((value) {
          _recarregarAnimais();
          safeSetState(() {});
        });
      },
      text: 'PP',
      icon: Icon(
        Icons.notifications,
        size: 15.0,
      ),
      // Verde-azulado: da família do DG+ (verde) sem confundir com ele. Fica
      // sólido porque, antes do PP, o DG+ está desabilitado e o PP é a ação
      // principal do card.
      options: _opcoesBotao(context, const Color(0xFF0F9488)),
    );
  }

  /// DG- — envia o animal para vazias (com confirmação dentro do widget).
  /// Última posição, mais à direita. Vermelho (theme.error).
  Widget _botaoDgMenos(BuildContext context, AnimaisProdutoresStruct item) {
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
                child: DgMenosWidget(
                  uidPropriedade: widget.uidPropriedade!,
                  nomePropriedade: widget.nomePropriedade!,
                  uidTecnico: widget.uidTecnico!,
                  emailPropriedade: widget.emailPropriedade!,
                  uidAnimaisProdutores: item.uidAnimal,
                  uidAnimalOffline: item.uidAnimalOffline,
                  grupoPredominante: item.grupoAnimal,
                  nomeAnimal: item.nomeAnimal,
                  visitaPresencial: widget.visitaPresencial!,
                ),
              ),
            );
          },
        ).then((value) {
          _recarregarAnimais();
          safeSetState(() {});
        });
      },
      text: 'DG -',
      icon: Icon(
        Icons.cancel_rounded,
        size: 15.0,
      ),
      options: _opcoesBotao(context, FlutterFlowTheme.of(context).error),
    );
  }

  /// DG+ — confirma prenhez. Posição do meio, logo após o PP. Verde. Só habilita
  /// depois que o animal passou por PP (status 'Inseminada PP' ou dtPP != '').
  Widget _botaoDgMais(BuildContext context, AnimaisProdutoresStruct item) {
    final habilitado = ehInseminadaPP(item.status) || (item.dtPP != '');
    return FFButtonWidget(
      onPressed: !habilitado
          ? null
          : () async {
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
                      child: DgMaisWidget(
                        uidPropriedade: widget.uidPropriedade!,
                        nomePropriedade: widget.nomePropriedade!,
                        uidTecnico: widget.uidTecnico!,
                        emailPropriedade: widget.emailPropriedade!,
                        uidAnimaisProdutores: item.uidAnimal,
                        uidAnimalOffline: item.uidAnimalOffline,
                        grupoPredominante: item.grupoAnimal,
                        nomeAnimal: item.nomeAnimal,
                        visitaPresencial: widget.visitaPresencial!,
                        diasDg: widget.diasDg!,
                      ),
                    ),
                  );
                },
              ).then((value) {
                _recarregarAnimais();
                safeSetState(() {});
              });
            },
      text: 'DG +',
      icon: Icon(
        Icons.check_circle,
        size: 15.0,
      ),
      options: _opcoesBotao(context, AppTokens.positivo),
    );
  }

  FFButtonOptions _opcoesBotao(BuildContext context, Color cor) =>
      opcoesBotaoCard(context, cor);

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
          titulo: 'Diagnóstico de gestação',
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
            // diferenca era so o filtro de busca, que mora em `vencidosParaDg`.
            Expanded(
              child: Builder(
                builder: (context) {
                  final visiveis = ordenarStructs(
                    vencidosParaDg(
                      _animaisExistentes,
                      diasDg: widget.diasDg ?? '0',
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
                        _itemDgElegivel(context, visiveis[i]),
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
