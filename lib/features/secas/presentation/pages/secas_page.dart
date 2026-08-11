// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

import '/core/connectivity/connectivity_service.dart';
import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/domain/animais/classificacao_animal.dart';
import '/core/ui/flutter_flow_button_tabbar.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/app_card.dart';
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
  final String? Function(BuildContext, String?)?
      _searchListTextControllerValidator = null;
  TabController? _tabBarController;

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
    )..addListener(() => safeSetState(() {}));

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

  /// Recarrega a lista a partir do ObjectBox (fonte única offline-first).
  ///
  /// Chamado no `initState` e após CADA ação. Sem isto a tela renderiza a lista
  /// em memória carregada na abertura: a gravação acontece (inclusive offline),
  /// mas o animal continua exibido na aba antiga — parecendo que "nada
  /// aconteceu". Ex.: pré-parto muda o status de 'Seca' para 'Pré Parto', então
  /// o animal deve sair da aba "Vacas secas" e aparecer em "Pré Parto".
  void _recarregarAnimais() {
    if (ObjectBoxService.isInitialized) {
      _animaisExistentes = AnimalRepository()
          .getAll()
          .where((a) => !a.isDeleted)
          .map(animalEntityToStruct)
          .toList()
        // `getAll()` devolve ordem de insercao do ObjectBox, que espelha a
        // ordem de documentId do Firestore — nem numerica, nem alfabetica.
        ..sort(compararStructs);
    }
  }

  // ---------------------------------------------------------------------------
  // Blocos visuais compartilhados pelos 4 cards (mesmo padrão das telas de
  // Inseminações, Diagnóstico de Gestação e Prenhas).
  // ---------------------------------------------------------------------------

  /// Envelopa o cartão: sombra suave, cantos arredondados e o InkWell que abre
  /// o prontuário do animal.
  Widget _linhaCard(
      BuildContext context, AnimaisProdutoresStruct item, Widget conteudo) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(12.0, 6.0, 12.0, 6.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: AppTokens.softShadow(context),
          borderRadius: BorderRadius.circular(AppTokens.radius),
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
            child: conteudo,
          ),
        ),
      ),
    );
  }

  /// Conteúdo do cartão: avatar + nome + ações no topo e, abaixo, a faixa de
  /// informações ocupando a largura TOTAL do card (mesmo desenho da tela de
  /// prenhas, onde as datas cabem inteiras — com ano — por terem a largura toda).
  Widget _conteudoCard(BuildContext context, AnimaisProdutoresStruct item,
      {required Widget botoes, required List<Widget> info}) {
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
                    botoes,
                  ],
                ),
              ),
            ),
          ],
        ),
        if (info.isNotEmpty) ...[
          const SizedBox(height: 12.0),
          _faixaInfo(context, info),
        ],
      ],
    );
  }

  /// Avatar circular do grupo (VAC/NOV).
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

  /// Faixa agrupando os tiles de informação, separados por divisores.
  Widget _faixaInfo(BuildContext context, List<Widget> tiles) {
    final filhos = <Widget>[];
    for (var i = 0; i < tiles.length; i++) {
      if (i > 0) {
        filhos.add(_divisor(context));
      }
      filhos.add(Expanded(child: tiles[i]));
    }
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
          children: filhos,
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

  /// Rótulo pequeno + valor destacado. Valor vazio vira '—' para o usuário
  /// perceber que o dado não existe.
  ///
  /// [ehData] usa `FittedBox` em vez de reticências: numa tela estreita a data
  /// ENCOLHE em vez de perder o ano ("20/12/2026" nunca vira "20/12..."). Para
  /// texto livre (ex.: motivo do descarte) usa reticências, que é o correto.
  Widget _tileInfo(BuildContext context, String rotulo, String valor,
      {bool destaque = false, bool ehData = true}) {
    final estiloValor = FlutterFlowTheme.of(context).bodyMedium.override(
          font: GoogleFonts.readexPro(
            fontWeight: FontWeight.w600,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
          color: destaque
              ? AppTokens.brand
              : FlutterFlowTheme.of(context).primaryText,
          fontSize: 14.0,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w600,
          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
        );
    final texto = valor.isEmpty ? '—' : valor;

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
        if (ehData)
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(texto, maxLines: 1, style: estiloValor),
          )
        else
          Text(
            texto,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: estiloValor,
          ),
      ],
    );
  }

  /// Estilo compartilhado dos botões de ação (altura 40, texto branco 12,
  /// cantos `radiusSmall`) — mesma métrica das demais telas.
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

  /// Card extraído do build (Fase 4).
  /// `true` quando o animal casa com o texto pesquisado (nome ou brinco).
  /// Busca vazia casa com todos. Aplicado nas 4 abas.
  bool _casaBusca(AnimaisProdutoresStruct item) {
    final termo = _searchListTextController?.text ?? '';
    if (termo.isEmpty) return true;
    return item.nomeAnimal.toLowerCase().contains(termo.toLowerCase()) ||
        item.brincoAnimal.toString().contains(termo);
  }

  /// Campo de busca no mesmo padrão das telas de inseminações, diagnóstico de
  /// gestação e prenhas. Fica acima das abas e filtra as quatro listas.
  Widget _campoBusca(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 4.0),
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
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
            borderRadius: BorderRadius.circular(14.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: AppTokens.secondary, width: 1.5),
            borderRadius: BorderRadius.circular(14.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error, width: 1.0),
            borderRadius: BorderRadius.circular(14.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error, width: 1.0),
            borderRadius: BorderRadius.circular(14.0),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).primaryBackground,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          suffixIcon: (_searchListTextController?.text ?? '').isNotEmpty
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

  /// Card da aba "Descarte".
  Widget _buildCard4(
      BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Visibility(
      visible: (item.uidTecnicoPropriedade == widget.uidPropriedade) &&
          _casaBusca(item) &&
          (ehDescarte(item.status)),
      child: _linhaCard(
        context,
        item,
        _conteudoCard(
          context,
          item,
          botoes: _part2(context, item, index),
          info: [
            _tileInfo(context, 'Data do descarte', item.dtDescarteAnimal),
            _tileInfo(context, 'Motivo', item.motivoDescarteAnimal,
                ehData: false),
          ],
        ),
      ),
    );
  }

  /// Card da aba "Indução Lactação".
  Widget _buildCard3(
      BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Visibility(
      visible: (item.uidTecnicoPropriedade == widget.uidPropriedade) &&
          _casaBusca(item) &&
          (item.dtInducaoLactacao != null),
      child: _linhaCard(
        context,
        item,
        _conteudoCard(
          context,
          item,
          botoes: _botaoInduzirLactacao(context, item, index),
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
      ),
    );
  }

  Widget _botaoInduzirLactacao(
      BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Row(
      children: [
        Expanded(
          child: FFButtonWidget(
            onPressed: () async {
              if ((item.grupoAnimal == 'Novilha') ||
                  (ehNovilha(item.grupoAnimal))) {
                _animaisExistentes[index].grupoAnimal = 'Vacas';
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
            options: _opcoesBotao(context, AppTokens.secondary),
          ),
        ),
      ],
    );
  }

  /// Card da aba "Pré Parto".
  Widget _buildCard2(
      BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Visibility(
      visible: (item.uidTecnicoPropriedade == widget.uidPropriedade) &&
          _casaBusca(item) &&
          (item.status == 'Pré Parto') &&
          (dateTimeFormat(
                "d/M/y",
                item.compararDtUltimaInseminacao,
                locale: FFLocalizations.of(context).languageCode,
              ) !=
              '31/12/2050'),
      child: _linhaCard(
        context,
        item,
        _conteudoCard(
          context,
          item,
          botoes: _part4(context, item, index),
          info: _datasCiclo(context, item),
        ),
      ),
    );
  }

  /// Card da aba "Vacas secas".
  Widget _buildCard1(
      BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Visibility(
      visible: (item.uidTecnicoPropriedade == widget.uidPropriedade) &&
          _casaBusca(item) &&
          ehVacaSeca(item.grupoAnimal, item.status) &&
          (dateTimeFormat(
                "d/M/y",
                item.compararDtUltimaInseminacao,
                locale: FFLocalizations.of(context).languageCode,
              ) !=
              '31/12/2050'),
      child: _linhaCard(
        context,
        item,
        _conteudoCard(
          context,
          item,
          botoes: _part6(context, item, index),
          info: _datasCiclo(context, item),
        ),
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

  Widget _part2(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      var confirmDialogResponse = await showDialog<bool>(
                            context: context,
                            builder: (alertDialogContext) {
                              return AlertDialog(
                                title: Text(
                                    'Deseja realmente restaurar  o animal?'),
                                content: Text(
                                    'Ele voltará para a lista do rebanho com o status vazia.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(
                                        alertDialogContext, false),
                                    child: Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(alertDialogContext, true),
                                    child: Text('Confirmar'),
                                  ),
                                ],
                              );
                            },
                          ) ??
                          false;
                      if (confirmDialogResponse) {
                        _animaisExistentes[index].status = 'Vazia';
                        safeSetState(() {});
                        // Restaurar offline-first: aplica status 'Vazia' no animal via
                        // AnimalRepository (persiste no ObjectBox e sincroniza).
                        final restItem =
                            _animaisExistentes.elementAtOrNull(index);
                        final repoRest = AnimalRepository();
                        final entRest = restItem?.uidAnimal != null
                            ? repoRest.getByFirestoreId(restItem!.uidAnimal!.id)
                            : ((restItem?.uidAnimalOffline ?? '').isNotEmpty
                                ? repoRest.getByUidAnimalOffline(
                                    restItem!.uidAnimalOffline)
                                : null);
                        if (entRest != null) {
                          await repoRest.update(entRest,
                              {'status': 'Vazia', 'idStatusAnimal': 2});
                        }
                        _recarregarAnimais();
                        safeSetState(() {});
                        Navigator.pop(context);
                        return;
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    text: 'Restaurar',
                    icon: Icon(
                      Icons.restore,
                      size: 15.0,
                    ),
                    options: _opcoesBotao(context, AppTokens.secondary),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    var confirmDialogResponse = await showDialog<bool>(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              title: Text('Deseja realmente apagar o animal?'),
                              content: Text('Essa ação é irreversível.'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext, false),
                                  child: Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext, true),
                                  child: Text('Confirmar'),
                                ),
                              ],
                            );
                          },
                        ) ??
                        false;
                    if (confirmDialogResponse) {
                      // Exclusão offline-first: soft delete no ObjectBox; o
                      // sync (online imediato ou fila ao reconectar) propaga.
                      final repoApagar = AnimalRepository();
                      final entApagar = item.uidAnimal != null
                          ? repoApagar.getByFirestoreId(item.uidAnimal!.id)
                          : (item.uidAnimalOffline.isNotEmpty
                              ? repoApagar
                                  .getByUidAnimalOffline(item.uidAnimalOffline)
                              : null);
                      if (entApagar != null) {
                        await repoApagar.softDelete(entApagar);
                      }
                      // Recarrega do ObjectBox (o soft delete já o exclui da
                      // lista) em vez de mexer no índice da lista em memória.
                      _recarregarAnimais();
                      safeSetState(() {});
                      Navigator.pop(context);
                      return;
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  text: 'Eliminar',
                  icon: Icon(
                    Icons.clear,
                    size: 15.0,
                  ),
                  options:
                      _opcoesBotao(context, FlutterFlowTheme.of(context).error),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _part4(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
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
                    options: _opcoesBotao(
                        context, FlutterFlowTheme.of(context).error),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
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
                  options: _opcoesBotao(context, Color(0xFF048508)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _part6(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
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
                    options: _opcoesBotao(
                        context, FlutterFlowTheme.of(context).error),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
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
                    options: _opcoesBotao(context, Color(0xFF048508)),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
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
                              dtPrePartoPrevista:
                                  functions.converteDataStringDate(
                                      item.dtPrePartoPrevista),
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
                  options: _opcoesBotao(context, AppTokens.secondary),
                ),
              ),
            ],
          ),
        ],
      ),
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
                        'Animais em secagem',
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                children: [
                  _campoBusca(context),
                  Align(
                    alignment: Alignment(-1.0, 0),
                    child: FlutterFlowButtonTabBar(
                      useToggleButtonStyle: false,
                      isScrollable: true,
                      labelStyle:
                          FlutterFlowTheme.of(context).titleMedium.override(
                                font: GoogleFonts.readexPro(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .fontStyle,
                              ),
                      unselectedLabelStyle: TextStyle(),
                      labelColor: Colors.white,
                      unselectedLabelColor:
                          FlutterFlowTheme.of(context).secondaryText,
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
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      tabs: [
                        Tab(
                          text: 'Vacas secas',
                        ),
                        Tab(
                          text: 'Pré Parto',
                        ),
                        Tab(
                          text: 'Indução Lactação',
                        ),
                        Tab(
                          text: 'Descarte',
                        ),
                      ],
                      controller: _tabBarController,
                      onTap: (i) async {
                        [
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
                        SingleChildScrollView(
                          primary: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Builder(
                                builder: (context) {
                                  final vacasExistenteOffline =
                                      _animaisExistentes
                                          .map((e) => e)
                                          .toList()
                                          .sortedList(
                                              keyOf: (e) =>
                                                  e.compararDtUltimaInseminacao,
                                              desc: false)
                                          .toList();

                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: vacasExistenteOffline.length,
                                    itemBuilder:
                                        (context, vacasExistenteOfflineIndex) {
                                      final vacasExistenteOfflineItem =
                                          vacasExistenteOffline[
                                              vacasExistenteOfflineIndex];
                                      return _buildCard1(
                                          context,
                                          vacasExistenteOfflineItem,
                                          vacasExistenteOfflineIndex);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          primary: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Builder(
                                builder: (context) {
                                  final animaisExistentesOffline =
                                      _animaisExistentes
                                          .map((e) => e)
                                          .toList()
                                          .sortedList(
                                              keyOf: (e) =>
                                                  e.compararDtUltimaInseminacao,
                                              desc: false)
                                          .toList();

                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: animaisExistentesOffline.length,
                                    itemBuilder: (context,
                                        animaisExistentesOfflineIndex) {
                                      final animaisExistentesOfflineItem =
                                          animaisExistentesOffline[
                                              animaisExistentesOfflineIndex];
                                      return _buildCard2(
                                          context,
                                          animaisExistentesOfflineItem,
                                          animaisExistentesOfflineIndex);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          primary: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Builder(
                                builder: (context) {
                                  final animaisExistenteOffline =
                                      _animaisExistentes.toList();

                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: animaisExistenteOffline.length,
                                    itemBuilder: (context,
                                        animaisExistenteOfflineIndex) {
                                      final animaisExistenteOfflineItem =
                                          animaisExistenteOffline[
                                              animaisExistenteOfflineIndex];
                                      return _buildCard3(
                                          context,
                                          animaisExistenteOfflineItem,
                                          animaisExistenteOfflineIndex);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          primary: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Builder(
                                builder: (context) {
                                  final animaisExistentesOfflineDescarte =
                                      _animaisExistentes.toList();

                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount:
                                        animaisExistentesOfflineDescarte.length,
                                    itemBuilder: (context,
                                        animaisExistentesOfflineDescarteIndex) {
                                      final animaisExistentesOfflineDescarteItem =
                                          animaisExistentesOfflineDescarte[
                                              animaisExistentesOfflineDescarteIndex];
                                      return _buildCard4(
                                          context,
                                          animaisExistentesOfflineDescarteItem,
                                          animaisExistentesOfflineDescarteIndex);
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
