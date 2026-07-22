// ignore_for_file: unnecessary_null_comparison, unused_import

import '/data/backend.dart';
import '/core/ui/app_card.dart';
import '/data/objectbox/index.dart';
import '/domain/animais/classificacao_animal.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/instant_timer.dart';
import '/features/animais/presentation/widgets/descarte_animal_widget.dart';
import '../widgets/registrar_secagem_widget.dart';
import '../widgets/registro_aborto_widget.dart';
import '/features/sincronizacao/presentation/widgets/alerta_sem_internet_widget.dart';
import '/core/services/index.dart' as actions;
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
  InstantTimer? _instantTimer;
  bool? _respostaNet = true;
  FocusNode? _searchListFocusNode;
  TextEditingController? _searchListTextController;
  final String? Function(BuildContext, String?)?
      _searchListTextControllerValidator = null;

  /// Lista de animais existentes (fonte ObjectBox). Antes em
  /// FFAppState.animaisProdutoresExistentes; agora estado local desta tela.
  List<AnimaisProdutoresStruct> _animaisExistentes = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Fonte única: carrega a lista do ObjectBox (offline-first). A tela renderiza
    // sempre desta lista; o Firestore é usado apenas para sincronizar.
    _recarregarAnimais();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _instantTimer = InstantTimer.periodic(
        duration: Duration(seconds: 5),
        callback: (timer) async {
          _respostaNet = await actions.checkInternetConnection();

          safeSetState(() {});
          if (_respostaNet!) {
            safeSetState(() {});
          } else {
            // Offline: notificação passiva via SyncStatusBanner (app-wide);
            // sem modal bloqueante nem flag global. O respostaNet acima já
            // atualiza a UI e o sync ao reconectar é automático.
          }
        },
        startImmediately: false,
      );
    });

    _searchListTextController ??= TextEditingController();
    _searchListFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _instantTimer?.cancel();
    _searchListFocusNode?.dispose();
    _searchListTextController?.dispose();

    super.dispose();
  }

  /// Recarrega a lista a partir do ObjectBox (fonte única offline-first).
  /// Chamado no `initState` e após cada ação (Aborto/Secagem), para o animal
  /// que deixa de estar prenhe sumir do card imediatamente.
  void _recarregarAnimais() {
    if (ObjectBoxService.isInitialized) {
      _animaisExistentes = AnimalRepository()
          .getAll()
          .where((a) => !a.isDeleted)
          .map(animalEntityToStruct)
          .toList();
    }
  }

  /// `true` quando o animal deve aparecer na lista de prenhas: é da
  /// propriedade, é Vaca/Novilha prenha e não carrega a data-sentinela
  /// 31/12/2050. Mesma regra usada na lista padrão e na busca.
  bool _ehPrenhaVisivel(BuildContext context, AnimaisProdutoresStruct item) {
    return (item.uidTecnicoPropriedade == widget.uidPropriedade) &&
        (ehVacaOuNovilha(item.grupoAnimal) && ehPrenha(item.status)) &&
        (dateTimeFormat(
              "d/M/y",
              item.compararDtUltimaInseminacao,
              locale: FFLocalizations.of(context).languageCode,
            ) !=
            '31/12/2050');
  }

  /// Item da LISTA PADRÃO (sem busca ativa).
  Widget _itemPrenha(BuildContext context, AnimaisProdutoresStruct item) {
    return Visibility(
      visible: _ehPrenhaVisivel(context, item),
      child: _linhaCard(context, item),
    );
  }

  /// Item da lista de RESULTADOS DA BUSCA: além de prenha, o nome/brinco
  /// precisa casar com o texto pesquisado.
  Widget _itemPrenhaBusca(BuildContext context, AnimaisProdutoresStruct item) {
    return Visibility(
      visible: _ehPrenhaVisivel(context, item) &&
          ((item.nomeAnimal
                  .toLowerCase()
                  .contains(_searchListTextController.text.toLowerCase())) ||
              (item.brincoAnimal
                  .toString()
                  .contains(_searchListTextController.text))),
      child: _linhaCard(context, item),
    );
  }

  /// Envelopa o cartão com padding + InkWell (abre o prontuário do animal).
  Widget _linhaCard(BuildContext context, AnimaisProdutoresStruct item) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 10.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: AppTokens.softShadow(context),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
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
              onLongPress: () async {},
              child: _conteudoCard(context, item),
            ),
          ),
        ),
      ),
    );
  }

  /// Conteúdo do cartão: avatar + nome + ações no topo e, abaixo, a faixa de
  /// datas ocupando a largura TOTAL do card.
  ///
  /// Antes era um GridView 3x2 (childAspectRatio 2.0) que espremia avatar,
  /// nome, três datas e dois botões em células de tamanho fixo. Depois a faixa
  /// de datas ficou ao lado do avatar, mas ali sobravam só ~83px por data — o
  /// suficiente para "20/12" e não para o ano. Movendo a faixa para baixo, ela
  /// recupera a largura do avatar (~56px) e cada data ganha ~100px, cabendo o
  /// ano inteiro.
  Widget _conteudoCard(BuildContext context, AnimaisProdutoresStruct item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _avatarGrupo(context, item),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      () {
                        if ((item.nomeAnimal != '') &&
                            (item.brincoAnimal != null) &&
                            (item.brincoAnimal != -1)) {
                          return '${item.nomeAnimal} - ${item.brincoAnimal.toString()}';
                        } else if (item.nomeAnimal != '') {
                          return item.nomeAnimal;
                        } else {
                          return item.brincoAnimal.toString();
                        }
                      }(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            font: GoogleFonts.readexPro(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .fontStyle,
                          ),
                    ),
                    const SizedBox(height: 12.0),
                    _botoesAcao(context, item),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        _blocoDatas(context, item),
      ],
    );
  }

  /// Avatar circular do grupo (VAC/NOV), no mesmo padrão das telas de
  /// inseminações e diagnóstico de gestação.
  Widget _avatarGrupo(BuildContext context, AnimaisProdutoresStruct item) {
    return Container(
      width: 44.0,
      height: 44.0,
      decoration: BoxDecoration(
        color: () {
          if (ehVaca(item.grupoAnimal)) {
            return AppTokens.brand;
          } else if (ehNovilha(item.grupoAnimal)) {
            return AppTokens.secondary;
          } else {
            return FlutterFlowTheme.of(context).secondaryText;
          }
        }(),
        shape: BoxShape.circle,
      ),
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Text(
        () {
          if (ehVaca(item.grupoAnimal)) {
            return 'VAC';
          } else if (ehNovilha(item.grupoAnimal)) {
            return 'NOV';
          } else {
            return 'N/C';
          }
        }(),
        style: FlutterFlowTheme.of(context).titleMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
              ),
              color: Colors.white,
              fontSize: 13.0,
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
            ),
      ),
    );
  }

  /// As três datas do ciclo da prenhez agrupadas num painel legível, em vez de
  /// rótulos soltos de 10px espalhados pelo grid. A previsão de parto recebe
  /// destaque por ser a informação-chave de um animal prenhe.
  Widget _blocoDatas(BuildContext context, AnimaisProdutoresStruct item) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(12.0, 10.0, 12.0, 10.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _tileData(
                  context, 'Inseminada', item.dtUltimaInseminacao, false),
            ),
            _divisor(context),
            Expanded(
              child:
                  _tileData(context, 'Prev. parto', item.dtPartoPrevisto, true),
            ),
            _divisor(context),
            Expanded(
              child: _tileData(
                  context, 'Sec. prevista', item.dtSecPrevista, false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divisor(BuildContext context) {
    return VerticalDivider(
      width: 17.0,
      thickness: 1.0,
      color: FlutterFlowTheme.of(context).alternate,
    );
  }

  /// Rótulo pequeno + valor destacado. Data vazia vira '—' em vez de sumir,
  /// para o usuário perceber que o dado não existe.
  Widget _tileData(
      BuildContext context, String rotulo, String valor, bool destaque) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          rotulo,
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: FlutterFlowTheme.of(context).labelSmall.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelSmall.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 11.0,
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
              ),
        ),
        const SizedBox(height: 3.0),
        // FittedBox em vez de ellipsis: numa tela estreita a data ENCOLHE em
        // vez de perder o ano ("20/12/2026" nunca vira "20/12...").
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            valor.isEmpty ? '—' : valor,
            maxLines: 1,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  color: destaque
                      ? AppTokens.brand
                      : FlutterFlowTheme.of(context).primaryText,
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
          ),
        ),
      ],
    );
  }

  /// Ações do card. "Secagem" só aparece para animal que está lactando: vaca,
  /// ou novilha com lactação induzida. Novilha prenha nunca lactou — registrar
  /// secagem nela a deixaria com status 'Seca' e grupo 'Novilhas', invisível
  /// tanto aqui quanto na tela de Secas (que filtra ehVacaSeca, só Vacas).
  Widget _botoesAcao(BuildContext context, AnimaisProdutoresStruct item) {
    final podeSecar =
        ehVaca(item.grupoAnimal) || (item.dtInducaoLactacao != null);
    return Row(
      children: [
        Expanded(child: _botaoAborto(context, item)),
        if (podeSecar) ...[
          const SizedBox(width: 8.0),
          Expanded(child: _botaoSecagem(context, item)),
        ],
      ],
    );
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
      options: _opcoesBotao(context, AppTokens.secondary),
    );
  }

  /// Estilo compartilhado dos botões de ação (mesma métrica das telas de
  /// inseminações e diagnóstico de gestação).
  FFButtonOptions _opcoesBotao(BuildContext context, Color cor) {
    return FFButtonOptions(
      height: 40.0,
      padding: EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 6.0, 0.0),
      iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
      color: cor,
      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
            font: GoogleFonts.readexPro(
              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
            ),
            color: Colors.white,
            fontSize: 12.0,
            letterSpacing: 0.0,
            fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
          ),
      elevation: 0.0,
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
    );
  }

  /// Lista ordenada pela data de inseminação (mais antigas primeiro) — as
  /// prenhas mais adiantadas, que parem antes, aparecem no topo.
  List<AnimaisProdutoresStruct> _animaisOrdenados() {
    return _animaisExistentes
        .map((e) => e)
        .toList()
        .sortedList(keyOf: (e) => e.compararDtUltimaInseminacao, desc: false)
        .toList();
  }

  /// Campo de busca no mesmo padrão das telas de inseminações e diagnóstico
  /// de gestação.
  Widget _campoBusca(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: TextFormField(
        controller: _searchListTextController,
        focusNode: _searchListFocusNode,
        onChanged: (_) => safeSetState(() {}),
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'Pesquisar animal',
          labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(14.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppTokens.secondary,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(14.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(14.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(14.0),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).primaryBackground,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          suffixIcon: _searchListTextController.text.isNotEmpty
              ? InkWell(
                  onTap: () {
                    _searchListTextController?.clear();
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
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
        validator: _searchListTextControllerValidator.asValidator(context),
        maxLines: 1,
      ),
    );
  }

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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            backgroundColor:
                (_respostaNet ?? true) ? Color(0xFFF75E38) : Color(0xFFF2886E),
            automaticallyImplyLeading: false,
            actions: [],
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
                        padding:
                            EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
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
                            context.pushNamed(
                              InicioPropriedadePage.routeName,
                              queryParameters: {
                                'nomePropriedade': serializeParam(
                                  widget.nomePropriedade,
                                  ParamType.String,
                                ),
                                'uidPropriedade': serializeParam(
                                  widget.uidPropriedade,
                                  ParamType.DocumentReference,
                                ),
                                'uidTecnico': serializeParam(
                                  widget.uidTecnico,
                                  ParamType.DocumentReference,
                                ),
                                'emailPropriedade': serializeParam(
                                  widget.emailPropriedade,
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
                        ),
                      ),
                      Text(
                        'Prenhas',
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              font: GoogleFonts.outfit(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .fontStyle,
                              ),
                              color: Colors.white,
                              fontSize: 22.0,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .fontStyle,
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
        ),
        body: Container(
          width: MediaQuery.sizeOf(context).width * 1.0,
          height: MediaQuery.sizeOf(context).height * 1.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            primary: false,
            scrollDirection: Axis.vertical,
            children: [
              _campoBusca(context),
              if (_searchListTextController.text == '')
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    primary: false,
                    scrollDirection: Axis.vertical,
                    children: [
                      Builder(
                        builder: (context) {
                          final animaisExistentes = _animaisOrdenados();

                          return ListView.builder(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 120.0),
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: animaisExistentes.length,
                            itemBuilder: (context, animaisExistentesIndex) {
                              final animaisExistentesItem =
                                  animaisExistentes[animaisExistentesIndex];
                              return _itemPrenha(
                                  context, animaisExistentesItem);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              if (_searchListTextController.text != '')
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    primary: false,
                    scrollDirection: Axis.vertical,
                    children: [
                      Builder(
                        builder: (context) {
                          final animaisExistentes = _animaisOrdenados();

                          return ListView.builder(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 120.0),
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: animaisExistentes.length,
                            itemBuilder: (context, animaisExistentesIndex) {
                              final animaisExistentesItem =
                                  animaisExistentes[animaisExistentesIndex];
                              return _itemPrenhaBusca(
                                  context, animaisExistentesItem);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
