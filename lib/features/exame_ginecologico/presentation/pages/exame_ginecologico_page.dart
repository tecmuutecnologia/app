// ignore_for_file: unnecessary_null_comparison
import 'dart:async';

import '/core/connectivity/connectivity_service.dart';
import '/data/backend.dart';
import '/core/ui/app_card.dart';
import '/domain/animais/classificacao_animal.dart';
import '/data/objectbox/index.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '../widgets/nova_acao_exame_ginecologico_widget.dart';
import '/features/prontuario/presentation/pages/prontuario_animal_page.dart';
import '/core/ui/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
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
      _animaisExistentes = AnimalRepository()
          .getAll()
          .where((a) => !a.isDeleted)
          .map(animalEntityToStruct)
          .toList();
    }
  }

  /// `true` quando o animal entra na lista de exame ginecológico: é da
  /// propriedade, está Vazia, é Vaca/Novilha e não tem lactação induzida.
  bool _ehExameVisivel(AnimaisProdutoresStruct item) {
    return (item.uidTecnicoPropriedade == widget.uidPropriedade) &&
        (ehVazia(item.status)) &&
        ((ehNovilha(item.grupoAnimal)) || (ehVaca(item.grupoAnimal))) &&
        (item.dtInducaoLactacao == null);
  }

  /// Item da LISTA PADRÃO (sem busca ativa).
  Widget _itemExame(BuildContext context, AnimaisProdutoresStruct item) {
    return Visibility(
      visible: _ehExameVisivel(item),
      child: _linhaCard(context, item),
    );
  }

  /// Item da lista de RESULTADOS DA BUSCA: além de elegível, o nome/brinco
  /// precisa casar com o texto pesquisado.
  Widget _itemExameBusca(BuildContext context, AnimaisProdutoresStruct item) {
    return Visibility(
      visible: _ehExameVisivel(item) &&
          ((item.nomeAnimal
                  .toLowerCase()
                  .contains(_searchListTextController.text.toLowerCase())) ||
              (item.brincoAnimal
                  .toString()
                  .contains(_searchListTextController.text))),
      child: _linhaCard(context, item),
    );
  }

  /// Envelopa o cartão: sombra suave, cantos arredondados e o InkWell que abre
  /// o prontuário do animal.
  Widget _linhaCard(BuildContext context, AnimaisProdutoresStruct item) {
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
            child: _conteudoCard(context, item),
          ),
        ),
      ),
    );
  }

  /// Conteúdo do cartão: avatar + nome + ação no topo e, abaixo, a faixa de
  /// informação na largura TOTAL do card (mesmo desenho da tela de prenhas).
  Widget _conteudoCard(BuildContext context, AnimaisProdutoresStruct item) {
    // Ação já registrada hoje: vira um selo ao lado do nome, em vez de um
    // ícone solto ao lado do botão (que competia com ele por espaço).
    final feitaHoje = (item.dtUltimaAcao != '') &&
        (functions.verificaDataAcaoDataAtual(item.dtUltimaAcao) == true);

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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
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
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
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
                        ),
                        if (feitaHoje) _seloFeitaHoje(context),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Expanded(child: _botaoAcao(context, item)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        _faixaInfo(context, [
          _tileInfo(context, 'Última ação', item.dtUltimaAcao,
              alinhaInicio: true),
        ]),
      ],
    );
  }

  /// Selo "feita hoje": substitui o ícone verde solto, deixando claro a QUE se
  /// refere o check.
  Widget _seloFeitaHoje(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 3.0, 8.0, 3.0),
      decoration: BoxDecoration(
        color: Color(0x1A048508),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            color: Color(0xFF048508),
            size: 13.0,
          ),
          const SizedBox(width: 4.0),
          Text(
            'Hoje',
            style: FlutterFlowTheme.of(context).labelSmall.override(
                  font: GoogleFonts.readexPro(
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelSmall.fontStyle,
                  ),
                  color: Color(0xFF048508),
                  fontSize: 11.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                ),
          ),
        ],
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
      options: _opcoesBotao(context, AppTokens.secondary),
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

  /// Rótulo pequeno + valor destacado. Valor vazio vira '—'. Datas usam
  /// `FittedBox` (encolhem em vez de perder o ano). [alinhaInicio] alinha à
  /// esquerda — usado quando há um único tile, em que centralizar fica solto.
  Widget _tileInfo(BuildContext context, String rotulo, String valor,
      {bool destaque = false, bool alinhaInicio = false}) {
    final alinha =
        alinhaInicio ? CrossAxisAlignment.start : CrossAxisAlignment.center;
    final alinhaTexto = alinhaInicio ? TextAlign.start : TextAlign.center;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alinha,
      children: [
        Text(
          rotulo,
          maxLines: 1,
          textAlign: alinhaTexto,
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

  /// Estilo compartilhado dos botões de ação — mesma métrica das demais telas.
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

  /// Campo de busca no mesmo padrão das telas anteriores.
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
                        'Exame ginecológico',
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
                          final listOfflineExistente =
                              _animaisExistentes.toList();

                          return ListView.builder(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 120.0),
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: listOfflineExistente.length,
                            itemBuilder: (context, listOfflineExistenteIndex) {
                              final listOfflineExistenteItem =
                                  listOfflineExistente[
                                      listOfflineExistenteIndex];
                              return _itemExame(
                                  context, listOfflineExistenteItem);
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
                          final listOfflineExistente =
                              _animaisExistentes.toList();

                          return ListView.builder(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 120.0),
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: listOfflineExistente.length,
                            itemBuilder: (context, listOfflineExistenteIndex) {
                              final listOfflineExistenteItem =
                                  listOfflineExistente[
                                      listOfflineExistenteIndex];
                              return _itemExameBusca(
                                  context, listOfflineExistenteItem);
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
