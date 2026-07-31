// ignore_for_file: unnecessary_null_comparison
import '/data/backend.dart';
import '/core/ui/app_card.dart';
import '/domain/animais/classificacao_animal.dart';
import '/data/objectbox/index.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/instant_timer.dart';
import '/core/services/index.dart' as actions;
import '/core/ui/custom_functions.dart' as functions;
import '../widgets/dg_mais_widget.dart';
import '../widgets/dg_menos_widget.dart';
import '../widgets/confirma_pp_widget.dart';
import '/features/prontuario/presentation/pages/prontuario_animal_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

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
            // sem flag global. O respostaNet acima já atualiza a UI.
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

  /// Recarrega a lista a partir do ObjectBox (fonte única offline-first). Chamado
  /// no `initState` e após cada ação (DG+/DG-/PP) para refletir imediatamente as
  /// mudanças de status: DG+ (Prenha) e DG- (Vazia) removem o card; PP habilita
  /// o botão DG+.
  void _recarregarAnimais() {
    if (ObjectBoxService.isInitialized) {
      _animaisExistentes = AnimalRepository()
          .getAll()
          .where((a) => !a.isDeleted)
          .map(animalEntityToStruct)
          .toList();
    }
  }

  /// `true` quando o animal está vencido para diagnóstico de gestação: é da
  /// propriedade, tem data de última inseminação, é Vaca/Novilha, está
  /// Inseminada ou Inseminada PP, e já passou do prazo (dtUltimaInseminacao +
  /// diasDg <= hoje). Mesma regra usada na lista e na busca.
  bool _vencidoParaDg(AnimaisProdutoresStruct item) {
    return (item.uidTecnicoPropriedade == widget.uidPropriedade) &&
        (item.dtUltimaInseminacao != '') &&
        ((ehVaca(item.grupoAnimal)) || (ehNovilha(item.grupoAnimal))) &&
        ((ehInseminada(item.status)) || (ehInseminadaPP(item.status))) &&
        (functions.converterStringParaData(
                item.dtUltimaInseminacao, widget.diasDg!) <=
            functions.obterDataAtual());
  }

  /// Item da LISTA PADRÃO (sem busca ativa): mostra o cartão dos animais
  /// vencidos para DG.
  Widget _itemDgElegivel(BuildContext context, AnimaisProdutoresStruct item) {
    return Visibility(
      visible: _vencidoParaDg(item),
      child: _linhaAnimal(context, item),
    );
  }

  /// Item da lista de RESULTADOS DA BUSCA: além de vencido para DG, o nome/brinco
  /// precisa casar com o texto pesquisado.
  Widget _itemDgBusca(BuildContext context, AnimaisProdutoresStruct item) {
    return Visibility(
      visible: _vencidoParaDg(item) &&
          ((item.nomeAnimal
                  .toLowerCase()
                  .contains(_searchListTextController.text.toLowerCase())) ||
              (item.brincoAnimal
                  .toString()
                  .contains(_searchListTextController.text))),
      child: _linhaAnimal(context, item),
    );
  }

  /// Envelopa o cartão com o padding + InkWell (abre o prontuário do animal),
  /// igual à tela de inseminações.
  Widget _linhaAnimal(BuildContext context, AnimaisProdutoresStruct item) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(12.0, 6.0, 12.0, 6.0),
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
        child: _cartaoAnimal(context, item),
      ),
    );
  }

  /// Cartão visual de um animal na lista de DG (mesmo padrão da tela de
  /// inseminações): avatar do grupo (VAC/NOV), nome + brinco, touro e data da
  /// última inseminação, e a linha de ações PP / DG- / DG+.
  Widget _cartaoAnimal(BuildContext context, AnimaisProdutoresStruct item) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: AppTokens.softShadow(context),
        borderRadius: BorderRadius.circular(AppTokens.radius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 0.0, 12.0),
            child: Container(
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
                        fontWeight:
                            FlutterFlowTheme.of(context).titleMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleMedium.fontStyle,
                      ),
                      color: Colors.white,
                      fontSize: 13.0,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).titleMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleMedium.fontStyle,
                    ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
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
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          font: GoogleFonts.readexPro(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight:
                              FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                        ),
                  ),
                  if (item.nomeTouroUltimaInseminacao != '')
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                      child: Text(
                        'Touro: ${item.nomeTouroUltimaInseminacao}',
                        style:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                      ),
                    ),
                  if (item.dtUltimaInseminacao != '')
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                      child: Text(
                        'Inseminada em: ${item.dtUltimaInseminacao}',
                        style:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                      ),
                    ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      Expanded(child: _botaoPp(context, item)),
                      SizedBox(width: 8.0),
                      Expanded(child: _botaoDgMenos(context, item)),
                      SizedBox(width: 8.0),
                      Expanded(child: _botaoDgMais(context, item)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// PP — marca prenhez parcial. Primeiro à esquerda. Roxo (secondary).
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
      options: _opcoesBotao(context, AppTokens.secondary),
    );
  }

  /// DG- — envia o animal para vazias (com confirmação dentro do widget). Ao
  /// meio. Vermelho (theme.error).
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

  /// DG+ — confirma prenhez. Última posição, mais à direita. Verde. Só habilita
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
      options: _opcoesBotao(context, Color(0xFF048508)),
    );
  }

  /// Estilo compartilhado dos 3 botões de ação (mesma métrica dos botões da tela
  /// de inseminações): altura 40, texto branco 12, cantos `radiusSmall`.
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
      disabledColor: FlutterFlowTheme.of(context).primaryBackground,
      disabledTextColor: FlutterFlowTheme.of(context).secondaryText,
    );
  }

  /// Campo de busca no mesmo padrão da tela de inseminações.
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
                            context.safePop();
                          },
                        ),
                      ),
                      Text(
                        'Diagnóstico de gestação',
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
                          final animaisExistentes = _animaisExistentes.toList();

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
                              return _itemDgElegivel(
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
                          final animaisExistentes = _animaisExistentes.toList();

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
                              return _itemDgBusca(
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
