// ignore_for_file: unnecessary_null_comparison, unused_import

import 'dart:async';

import '/core/connectivity/connectivity_service.dart';
import '/data/backend.dart';
import '/domain/animais/classificacao_animal.dart';
import '/domain/animais/ordenacao_animal.dart';
import '/data/objectbox/index.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/features/shared/widgets/botao_ordenacao.dart';
import '/core/ui/app_card.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/features/animais/presentation/widgets/descarte_animal_widget.dart';
import '../widgets/nova_inseminacao_widget.dart';
import '../widgets/registrar_cio_widget.dart';
import '/features/propriedades/presentation/pages/inicio_propriedade_page.dart';
import '/features/prontuario/presentation/pages/prontuario_animal_page.dart';
import '/features/sincronizacao/presentation/widgets/alerta_sem_internet_widget.dart';
import '/core/ui/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ListaInseminacoesPage extends StatefulWidget {
  const ListaInseminacoesPage({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    this.diasDg,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? diasDg;

  static String routeName = 'listaInseminacoes';
  static String routePath = '/listaInseminacoes';

  @override
  State<ListaInseminacoesPage> createState() => _ListaInseminacoesPageState();
}

class _ListaInseminacoesPageState extends State<ListaInseminacoesPage> {
  StreamSubscription<bool>? _conectividadeSub;
  bool? _respostaNet = true;
  FocusNode? _searchListFocusNode;
  TextEditingController? _searchListTextController;
  final String? Function(BuildContext, String?)?
      _searchListTextControllerValidator = null;

  /// Lista de animais existentes (fonte ObjectBox). Antes em
  /// FFAppState.animaisProdutoresExistentes; agora estado local desta tela.
  List<AnimaisProdutoresStruct> _animaisExistentes = [];

  /// Direção da ordenação da lista. Crescente por padrão: brinco 390 antes de
  /// 430, e nome A antes de Z.
  bool _ordemCrescente = true;

  /// Regra única do domínio, com a direção escolhida no botão.
  int _compararStructs(AnimaisProdutoresStruct a, AnimaisProdutoresStruct b) {
    final c = compararStructs(a, b);
    return _ordemCrescente ? c : -c;
  }

  /// Inverte a ordem e reordena a lista já carregada — sem tocar no ObjectBox,
  /// já que só a direção mudou.
  void _alternarOrdem() {
    safeSetState(() {
      _ordemCrescente = !_ordemCrescente;
      _animaisExistentes = _animaisExistentes.toList()..sort(_compararStructs);
    });
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Fonte única: carrega a lista do ObjectBox (offline-first). A tela renderiza
    // sempre desta lista; o Firestore é usado apenas para sincronizar.
    if (ObjectBoxService.isInitialized) {
      _animaisExistentes = AnimalRepository()
          .getAll()
          .where((a) => !a.isDeleted)
          .map(animalEntityToStruct)
          .toList()
        // `getAll()` devolve ordem de insercao do ObjectBox, que espelha a
        // ordem de documentId do Firestore — nem numerica, nem alfabetica.
        ..sort(_compararStructs);
    }

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

  /// Item da lista de RESULTADOS DA BUSCA: exibe o cartão do animal apenas quando
  /// o nome/brinco casa com o texto pesquisado e o animal é elegível à inseminação.
  Widget _itemAnimalBusca(BuildContext context, AnimaisProdutoresStruct item) {
    return Visibility(
      visible: (item.uidTecnicoPropriedade == widget.uidPropriedade) &&
          ((item.nomeAnimal
                  .toLowerCase()
                  .contains(_searchListTextController.text.toLowerCase())) ||
              (item.brincoAnimal
                  .toString()
                  .contains(_searchListTextController.text))) &&
          ehElegivelInseminacao(item.grupoAnimal, item.status),
      child: Padding(
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
      ),
    );
  }

  /// Item da LISTA PADRÃO (sem busca ativa): exibe o cartão dos animais elegíveis
  /// à inseminação — vacas/novilhas vazias ou já inseminadas.
  Widget _itemAnimalElegivel(
      BuildContext context, AnimaisProdutoresStruct item) {
    return Visibility(
      visible: (item.uidTecnicoPropriedade == widget.uidPropriedade) &&
          (((ehVaca(item.grupoAnimal)) || (ehNovilha(item.grupoAnimal))) &&
              ((ehVazia(item.status)) ||
                  (ehInseminada(item.status)) ||
                  (ehInseminadaPP(item.status)))),
      child: Padding(
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
      ),
    );
  }

  /// Cartão visual de um animal na lista de inseminações: avatar do grupo
  /// (VAC/NOV), nome + brinco, data da última inseminação e as ações "Fez Cio"
  /// e "Inseminar". Reutilizado pela lista padrão e pela busca.
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
                  if (item.dtUltimaInseminacao != '')
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                      child: Text(
                        'Última insem.: ${item.dtUltimaInseminacao}',
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
                  if ((ehInseminada(item.status)) ||
                      (ehInseminadaPP(item.status)))
                    Text(
                      'Inseminada',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.readexPro(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: Color(0xFF048508),
                            fontSize: 11.0,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  const SizedBox(height: 12.0),
                  Row(
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
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  child: Padding(
                                    padding: MediaQuery.viewInsetsOf(context),
                                    child: RegistrarCioWidget(
                                      uidPropriedade: widget.uidPropriedade!,
                                      nomePropriedade: widget.nomePropriedade!,
                                      uidTecnico: widget.uidTecnico!,
                                      emailPropriedade:
                                          widget.emailPropriedade!,
                                      uidAnimaisProdutores: item.uidAnimal,
                                      uidAnimalOffline: item.uidAnimalOffline,
                                      grupoPredominante: item.grupoAnimal,
                                      nomeAnimal: item.nomeAnimal,
                                      visitaPresencial:
                                          widget.visitaPresencial!,
                                      brincoAnimal:
                                          item.brincoAnimal.toString(),
                                      diasDg: widget.diasDg!,
                                    ),
                                  ),
                                );
                              },
                            ).then((value) => safeSetState(() {}));
                          },
                          text: 'Fez Cio',
                          icon: Icon(
                            Icons.repeat,
                            size: 15.0,
                          ),
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 0.0, 10.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: AppTokens.secondary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius:
                                BorderRadius.circular(AppTokens.radiusSmall),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
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
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  child: Padding(
                                    padding: MediaQuery.viewInsetsOf(context),
                                    child: NovaInseminacaoWidget(
                                      uidPropriedade: widget.uidPropriedade!,
                                      nomePropriedade: widget.nomePropriedade!,
                                      uidTecnico: widget.uidTecnico!,
                                      emailPropriedade:
                                          widget.emailPropriedade!,
                                      grupoPredominante: item.grupoAnimal,
                                      nomeAnimal: item.nomeAnimal,
                                      visitaPresencial:
                                          widget.visitaPresencial!,
                                      dtUltimaInseminacao:
                                          item.dtUltimaInseminacao,
                                      brincoAnimal:
                                          item.brincoAnimal.toString(),
                                      diasDg: widget.diasDg!,
                                      uidAnimaisProdutores: item.uidAnimal,
                                      uidAnimalOffline: item.uidAnimalOffline,
                                    ),
                                  ),
                                );
                              },
                            ).then((value) => safeSetState(() {}));
                          },
                          text: 'Inseminar',
                          icon: Icon(
                            Icons.playlist_add,
                            size: 15.0,
                          ),
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 0.0, 10.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: AppTokens.brand,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius:
                                BorderRadius.circular(AppTokens.radiusSmall),
                          ),
                        ),
                      ),
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

  /// Campo de busca no mesmo padrão da tela de propriedades: `TextFormField`
  /// preenchido, cantos arredondados e borda de foco roxa (sem card/sombra).
  Widget _campoBusca(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _campoBuscaTexto(context)),
          const SizedBox(width: 8.0),
          BotaoOrdenacao(
            crescente: _ordemCrescente,
            onAlternar: _alternarOrdem,
          ),
        ],
      ),
    );
  }

  /// O campo em si, sem o padding externo — a linha acima cuida do arranjo.
  Widget _campoBuscaTexto(BuildContext context) {
    return TextFormField(
      controller: _searchListTextController,
      focusNode: _searchListFocusNode,
      onChanged: (_) => safeSetState(() {}),
      obscureText: false,
      decoration: InputDecoration(
        labelText: 'Pesquisar animal',
        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
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
                _respostaNet! ? Color(0xFFF75E38) : Color(0xFFF2886E),
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
                        'Inseminações',
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
                          final listaAnimaisOfflineExistente =
                              _animaisExistentes.toList();

                          return ListView.builder(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 120.0),
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: listaAnimaisOfflineExistente.length,
                            itemBuilder:
                                (context, listaAnimaisOfflineExistenteIndex) {
                              final listaAnimaisOfflineExistenteItem =
                                  listaAnimaisOfflineExistente[
                                      listaAnimaisOfflineExistenteIndex];
                              return _itemAnimalElegivel(
                                  context, listaAnimaisOfflineExistenteItem);
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
                      if (_searchListTextController.text != '')
                        Builder(
                          builder: (context) {
                            final listaAnimaisOfflineExistente =
                                _animaisExistentes.toList();

                            return ListView.builder(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 120.0),
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: listaAnimaisOfflineExistente.length,
                              itemBuilder:
                                  (context, listaAnimaisOfflineExistenteIndex) {
                                final listaAnimaisOfflineExistenteItem =
                                    listaAnimaisOfflineExistente[
                                        listaAnimaisOfflineExistenteIndex];
                                return _itemAnimalBusca(
                                    context, listaAnimaisOfflineExistenteItem);
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
