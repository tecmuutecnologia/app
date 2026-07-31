// ignore_for_file: unused_import, unused_local_variable, unnecessary_null_comparison

import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/domain/animais/classificacao_animal.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/app_card.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/instant_timer.dart';
import '/features/diagnostico_gestacao/presentation/widgets/confirma_pp_widget.dart';
import '/features/diagnostico_gestacao/presentation/widgets/dg_mais_widget.dart';
import '/features/diagnostico_gestacao/presentation/widgets/dg_menos_widget.dart';
import '/features/exame_ginecologico/presentation/widgets/nova_acao_exame_ginecologico_widget.dart';
import '/features/inseminacoes/presentation/widgets/nova_inseminacao_widget.dart';
import '/features/prenhas/presentation/widgets/registrar_secagem_widget.dart';
import '/features/prenhas/presentation/widgets/registro_aborto_widget.dart';
import '/features/recria/presentation/widgets/desmame_widget.dart';
import '/features/secas/presentation/widgets/registrar_parto_widget.dart';
import '/features/secas/presentation/widgets/registrar_pre_parto_widget.dart';
import '/features/sincronizacao/presentation/widgets/alerta_sem_internet_widget.dart';
import '/core/services/index.dart' as actions;
import '/core/ui/custom_functions.dart' as functions;
import '/features/prontuario/presentation/pages/prontuario_animal_page.dart';
import '/features/propriedades/presentation/pages/inicio_propriedade_page.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ListacompletaPage extends StatefulWidget {
  const ListacompletaPage({
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

  static String routeName = 'listacompleta';
  static String routePath = '/listacompleta';

  @override
  State<ListacompletaPage> createState() => _ListacompletaPageState();
}

class _ListacompletaPageState extends State<ListacompletaPage> {
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
    if (ObjectBoxService.isInitialized) {
      _animaisExistentes = AnimalRepository()
          .getAll()
          .where((a) => !a.isDeleted)
          .map(animalEntityToStruct)
          .toList();
    }

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

  /// Card (frente/verso) de um animal na lista completa. Extraído do build
  /// (Fase 4): era ~3600 linhas inline no itemBuilder.
  /// Lista já filtrada — só os animais que de fato aparecem.
  ///
  /// Antes o filtro vivia num `Visibility` DENTRO do card: o `child:` era
  /// avaliado de qualquer forma, então cada bezerro/touro/sêmen montava a
  /// árvore inteira do cartão (avatar, selos e ate 14 grupos de botoes) só para
  /// ser escondido em seguida. Somado ao `shrinkWrap` da lista, que constroi
  /// TODOS os itens de uma vez, o resultado era a tela travar em rebanhos
  /// grandes — independente de conexao.
  List<AnimaisProdutoresStruct> _animaisVisiveis() {
    final busca = _searchListTextController.text.toLowerCase();
    return _animaisExistentes.where((item) {
      if (item.uidTecnicoPropriedade != widget.uidPropriedade) return false;
      if (!(ehNovilha(item.grupoAnimal) || ehVaca(item.grupoAnimal))) {
        return false;
      }
      if (busca.isEmpty) return true;
      return item.nomeAnimal.toLowerCase().contains(busca) ||
          item.brincoAnimal.toString().contains(busca);
    }).toList();
  }

  /// Campo de busca no mesmo padrao das telas de inseminacoes, diagnostico de
  /// gestacao e prenhas.
  ///
  /// Antes eram dois blocos: um cabecalho "Pesquisa rapida:" (rotulo redundante
  /// — o campo ja tem placeholder) e um Container de 10% da ALTURA DA TELA
  /// envolvendo o input, que por isso variava de tamanho conforme o aparelho.
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
                font: GoogleFonts.readexPro(),
                letterSpacing: 0.0,
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
              font: GoogleFonts.readexPro(),
              letterSpacing: 0.0,
            ),
        validator: _searchListTextControllerValidator.asValidator(context),
        maxLines: 1,
      ),
    );
  }

  /// Faixa agrupando as datas, separadas por divisores — mesmo desenho da tela
  /// de prenhas. Antes cada data era um `Text` solto de 12px empilhado
  /// ("Inseminada em: 12/03/2026"), sem hierarquia entre rotulo e valor.
  Widget _faixaInfo(BuildContext context, List<Widget> tiles) {
    final filhos = <Widget>[];
    for (var i = 0; i < tiles.length; i++) {
      if (i > 0) {
        filhos.add(VerticalDivider(
          width: 17.0,
          thickness: 1.0,
          color: FlutterFlowTheme.of(context).alternate,
        ));
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

  /// Rotulo pequeno + valor destacado; vazio vira '—'. `FittedBox` faz a data
  /// encolher em vez de perder o ano ("20/12/2026" nunca vira "20/12...").
  Widget _tileInfo(BuildContext context, String rotulo, String valor,
      {bool destaque = false}) {
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
                font: GoogleFonts.readexPro(),
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 11.0,
                letterSpacing: 0.0,
              ),
        ),
        const SizedBox(height: 3.0),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            valor.isEmpty ? '—' : valor,
            maxLines: 1,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                  color: destaque
                      ? AppTokens.brand
                      : FlutterFlowTheme.of(context).primaryText,
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }

  /// Estilo padrao dos botoes de acao (altura 40, texto branco 12, cantos
  /// `radiusSmall`) — mesma metrica das demais telas. Antes cada um dos 34
  /// botoes trazia seu proprio FFButtonOptions com altura 25 e largura fixa.
  FFButtonOptions _opcoesBotao(BuildContext context, Color cor) {
    return FFButtonOptions(
      height: 40.0,
      padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
      iconPadding: EdgeInsets.zero,
      color: cor,
      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
            font: GoogleFonts.readexPro(),
            color: Colors.white,
            fontSize: 12.0,
            letterSpacing: 0.0,
          ),
      elevation: 0.0,
      borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
      borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
    );
  }

  /// Selo textual para indicadores de estado. Substitui os ícones soltos de
  /// 24-30px que não diziam a que se referiam (um check verde podia ser
  /// "ação feita hoje" ou "inseminada", dependendo de onde estava).
  Widget _selo(BuildContext context, String texto, Color cor, IconData icone) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 3.0, 8.0, 3.0),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, color: cor, size: 13.0),
          const SizedBox(width: 4.0),
          Text(
            texto,
            style: FlutterFlowTheme.of(context).labelSmall.override(
                  font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                  color: cor,
                  fontSize: 11.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  /// Atalho para o prontuário. Antes era so um icone do FontAwesome (pollH),
  /// sem rotulo — nada indicava que abria o prontuario do animal.
  Widget _chipProntuario(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 5.0),
      decoration: BoxDecoration(
        color: AppTokens.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.assignment_outlined,
              color: AppTokens.secondary, size: 15.0),
          const SizedBox(width: 5.0),
          Text(
            'Prontuário',
            style: FlutterFlowTheme.of(context).labelSmall.override(
                  font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                  color: AppTokens.secondary,
                  fontSize: 11.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalCard(
      BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Visibility(
      visible: (item.uidTecnicoPropriedade == widget.uidPropriedade) &&
          ((ehNovilha(item.grupoAnimal)) || (ehVaca(item.grupoAnimal))),
      child: _front1(context, item, index),
    );
  }

  /// Card filtrado por busca (2a lista da listacompleta). Extraído do build
  /// (Fase 4).
  Widget _buildAnimalCardFiltrado(
      BuildContext context, AnimaisProdutoresStruct item, int index) {
    final searchText = _searchListTextController.text.toLowerCase();
    final matchesSearch = searchText.isEmpty ||
        item.nomeAnimal.toLowerCase().contains(searchText) ||
        item.brincoAnimal.toString().contains(searchText);
    return Visibility(
      visible: (item.uidTecnicoPropriedade == widget.uidPropriedade) &&
          matchesSearch &&
          ((ehNovilha(item.grupoAnimal)) || (ehVaca(item.grupoAnimal))),
      child: _front2(context, item, index),
    );
  }

  Widget _front1(
      BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12.0, 6.0, 12.0, 6.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: AppTokens.softShadow(context),
          borderRadius: BorderRadius.circular(AppTokens.radius),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 44.0,
                              height: 44.0,
                              decoration: BoxDecoration(
                                color: () {
                                  if (ehVaca(item.grupoAnimal)) {
                                    return AppTokens.brand;
                                  } else if (ehNovilha(item.grupoAnimal)) {
                                    return AppTokens.secondary;
                                  } else {
                                    return FlutterFlowTheme.of(context)
                                        .secondaryText;
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
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      font: GoogleFonts.readexPro(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                      color: Colors.white,
                                      fontSize: 13.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 8.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${() {
                                    if ((item.nomeAnimal != '') &&
                                        (item.brincoAnimal != null) &&
                                        (item.brincoAnimal != -1)) {
                                      return '${item.nomeAnimal} - ${item.brincoAnimal.toString()}';
                                    } else if (item.nomeAnimal != '') {
                                      return item.nomeAnimal;
                                    } else {
                                      return item.brincoAnimal.toString();
                                    }
                                  }()}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
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
                                // Status em linha propria: antes vinha concatenado
                                // no nome ("Mimosa - 12 - Prenha").
                                if (item.status != '')
                                  Text(
                                    item.status,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.readexPro(),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                if (ehDescarte(item.status))
                                  _selo(
                                      context,
                                      'Descartado',
                                      Color(0xFFFE0000),
                                      Icons.delete_forever_rounded),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5.0, 0.0, 0.0, 0.0),
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
                                            'uidAnimaisProdutores':
                                                serializeParam(
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
                                      child: _chipProntuario(context),
                                    ),
                                  ),
                                ),
                                if ((item.dtUltimaAcao != '') &&
                                    (functions.verificaDataAcaoDataAtual(
                                            item.dtUltimaAcao) ==
                                        true))
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5.0, 0.0, 0.0, 0.0),
                                    child: _selo(context, 'Hoje',
                                        Color(0xFF048508), Icons.check_circle),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Acoes que antes ficavam no VERSO do cartao (FlipCard).
              _back3(context, item, index),
            ],
          ),
        ),
      ),
    );
  }

  Widget _back3(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((ehVazia(item.status)) &&
            ((ehBezerras(item.grupoAnimal)) || (ehBezerros(item.grupoAnimal))))
          _part1(context, item, index),
        if ((ehVazia(item.status)) &&
            ((!ehBezerras(item.grupoAnimal)) &&
                (!ehBezerros(item.grupoAnimal))))
          _part2(context, item, index),
        if ((item.status == 'Pré Parto') &&
            ((!ehBezerras(item.grupoAnimal)) &&
                (!ehBezerros(item.grupoAnimal))))
          _part3(context, item, index),
        if ((ehPrenha(item.status)) &&
            (ehNovilha(item.grupoAnimal)) &&
            ((!ehBezerras(item.grupoAnimal)) &&
                (!ehBezerros(item.grupoAnimal))))
          _part4(context, item, index),
        if ((ehSeca(item.status)) &&
            (ehVaca(item.grupoAnimal)) &&
            ((!ehBezerras(item.grupoAnimal)) &&
                (!ehBezerros(item.grupoAnimal))))
          _part5(context, item, index),
        if ((ehPrenha(item.status)) &&
            (ehVaca(item.grupoAnimal)) &&
            ((!ehBezerras(item.grupoAnimal)) &&
                (!ehBezerros(item.grupoAnimal))))
          _part6(context, item, index),
        if (((ehInseminadaPP(item.status)) || (ehInseminada(item.status))) &&
            ((!ehBezerras(item.grupoAnimal)) &&
                (!ehBezerros(item.grupoAnimal))))
          _part7(context, item, index)
      ],
    );
  }

  Widget _front2(
      BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12.0, 6.0, 12.0, 6.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: AppTokens.softShadow(context),
          borderRadius: BorderRadius.circular(AppTokens.radius),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 44.0,
                              height: 44.0,
                              decoration: BoxDecoration(
                                color: () {
                                  if (ehVaca(item.grupoAnimal)) {
                                    return AppTokens.brand;
                                  } else if (ehNovilha(item.grupoAnimal)) {
                                    return AppTokens.secondary;
                                  } else {
                                    return FlutterFlowTheme.of(context)
                                        .secondaryText;
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
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      font: GoogleFonts.readexPro(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                      color: Colors.white,
                                      fontSize: 13.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 8.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${() {
                                    if ((item.nomeAnimal != '') &&
                                        (item.brincoAnimal != null) &&
                                        (item.brincoAnimal != -1)) {
                                      return '${item.nomeAnimal} - ${item.brincoAnimal.toString()}';
                                    } else if (item.nomeAnimal != '') {
                                      return item.nomeAnimal;
                                    } else {
                                      return item.brincoAnimal.toString();
                                    }
                                  }()}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
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
                                // Status em linha propria: antes vinha concatenado
                                // no nome ("Mimosa - 12 - Prenha").
                                if (item.status != '')
                                  Text(
                                    item.status,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.readexPro(),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                if (ehDescarte(item.status))
                                  _selo(
                                      context,
                                      'Descartado',
                                      Color(0xFFFE0000),
                                      Icons.delete_forever_rounded),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5.0, 0.0, 0.0, 0.0),
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
                                            'uidAnimaisProdutores':
                                                serializeParam(
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
                                      child: _chipProntuario(context),
                                    ),
                                  ),
                                ),
                                if ((item.dtUltimaAcao != '') &&
                                    (functions.verificaDataAcaoDataAtual(
                                            item.dtUltimaAcao) ==
                                        true))
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5.0, 0.0, 0.0, 0.0),
                                    child: _selo(context, 'Hoje',
                                        Color(0xFF048508), Icons.check_circle),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Acoes que antes ficavam no VERSO do cartao (FlipCard).
              _back4(context, item, index),
            ],
          ),
        ),
      ),
    );
  }

  Widget _back4(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((ehVazia(item.status)) &&
            ((ehBezerras(item.grupoAnimal)) || (ehBezerros(item.grupoAnimal))))
          _part8(context, item, index),
        if ((ehVazia(item.status)) &&
            ((!ehBezerras(item.grupoAnimal)) &&
                (!ehBezerros(item.grupoAnimal))))
          _part9(context, item, index),
        if ((item.status == 'Pré Parto') &&
            ((!ehBezerras(item.grupoAnimal)) &&
                (!ehBezerros(item.grupoAnimal))))
          _part10(context, item, index),
        if ((ehPrenha(item.status)) &&
            (ehNovilha(item.grupoAnimal)) &&
            ((!ehBezerras(item.grupoAnimal)) &&
                (!ehBezerros(item.grupoAnimal))))
          _part11(context, item, index),
        if ((ehSeca(item.status)) &&
            (ehVaca(item.grupoAnimal)) &&
            ((!ehBezerras(item.grupoAnimal)) &&
                (!ehBezerros(item.grupoAnimal))))
          _part12(context, item, index),
        if ((ehPrenha(item.status)) &&
            (ehVaca(item.grupoAnimal)) &&
            ((!ehBezerras(item.grupoAnimal)) &&
                (!ehBezerros(item.grupoAnimal))))
          _part13(context, item, index),
        if (((ehInseminadaPP(item.status)) || (ehInseminada(item.status))) &&
            ((!ehBezerras(item.grupoAnimal)) &&
                (!ehBezerros(item.grupoAnimal))))
          _part14(context, item, index)
      ],
    );
  }

  Widget _part1(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: _faixaInfo(context, [
                  _tileInfo(context, 'Nascimento', item.dtNascimento),
                ])),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
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
                            child: DesmameWidget(
                              mode: DesmameMode.online,
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
                              itemUidIndex: index,
                            ),
                          ),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  },
                  text: 'Desmamar',
                  icon: Icon(
                    Icons.pause,
                    size: 15.0,
                  ),
                  options: _opcoesBotao(context, Color(0xFF048508)),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
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
                      ).then((value) => safeSetState(() {}));
                    },
                    text: 'Ação',
                    icon: Icon(
                      Icons.add_alert,
                      size: 15.0,
                    ),
                    options: _opcoesBotao(context, AppTokens.secondary),
                  ),
                ),
                if ((ehInseminada(item.status)) ||
                    (ehInseminadaPP(item.status)))
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                    child: _selo(
                        context,
                        'Inseminada',
                        FlutterFlowTheme.of(context).success,
                        Icons.check_sharp),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _part2(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: _faixaInfo(context, [
                  _tileInfo(
                      context,
                      'DEL',
                      item.dtUltimoParto != ''
                          ? functions
                              .calcularDiferencaEmDias(item.dtUltimoParto)
                              .toString()
                          : ''),
                  _tileInfo(context, 'Último parto', item.dtUltimoParto),
                ])),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
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
                              child: NovaInseminacaoWidget(
                                uidPropriedade: widget.uidPropriedade!,
                                nomePropriedade: widget.nomePropriedade!,
                                uidTecnico: widget.uidTecnico!,
                                emailPropriedade: widget.emailPropriedade!,
                                grupoPredominante: item.grupoAnimal,
                                nomeAnimal: item.nomeAnimal,
                                visitaPresencial: widget.visitaPresencial!,
                                dtUltimaInseminacao: item.dtUltimaInseminacao,
                                brincoAnimal: item.brincoAnimal.toString(),
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
                    options: _opcoesBotao(context, AppTokens.brand),
                  ),
                ),
                FFButtonWidget(
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
                    ).then((value) => safeSetState(() {}));
                  },
                  text: 'Ação',
                  icon: Icon(
                    Icons.add_alert,
                    size: 15.0,
                  ),
                  options: _opcoesBotao(context, AppTokens.secondary),
                ),
                if ((ehInseminada(item.status)) ||
                    (ehInseminadaPP(item.status)))
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                    child: _selo(
                        context,
                        'Inseminada',
                        FlutterFlowTheme.of(context).success,
                        Icons.check_sharp),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _part3(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: _faixaInfo(context, [
                _tileInfo(context, 'Inseminada', item.dtUltimaInseminacao),
                _tileInfo(context, 'Pré parto prev.', item.dtPrePartoPrevista),
                _tileInfo(context, 'Parto previsto', item.dtPartoPrevisto,
                    destaque: true),
              ])),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FFButtonWidget(
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
                  ).then((value) => safeSetState(() {}));
                },
                text: 'Parto',
                icon: Icon(
                  Icons.add_alert,
                  size: 15.0,
                ),
                options: _opcoesBotao(context, Color(0xFF048508)),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
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
                    ).then((value) => safeSetState(() {}));
                  },
                  text: 'Aborto',
                  icon: Icon(
                    Icons.cancel_sharp,
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
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: _faixaInfo(context, [
                _tileInfo(context, 'Inseminada', item.dtUltimaInseminacao),
                _tileInfo(context, 'Pré parto prev.', item.dtPrePartoPrevista),
                _tileInfo(context, 'Parto previsto', item.dtPartoPrevisto,
                    destaque: true),
              ])),
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
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
                    ).then((value) => safeSetState(() {}));
                  },
                  text: 'Aborto',
                  icon: Icon(
                    Icons.cancel_sharp,
                    size: 15.0,
                  ),
                  options:
                      _opcoesBotao(context, FlutterFlowTheme.of(context).error),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
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
                      ).then((value) => safeSetState(() {}));
                    },
                    text: 'Parto',
                    icon: Icon(
                      Icons.add_alert,
                      size: 15.0,
                    ),
                    options: _opcoesBotao(context, Color(0xFF048508)),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
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
                      ).then((value) => safeSetState(() {}));
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
          ),
        ],
      ),
    );
  }

  Widget _part5(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: _faixaInfo(context, [
                _tileInfo(context, 'Inseminada', item.dtUltimaInseminacao),
                _tileInfo(context, 'Pré parto prev.', item.dtPrePartoPrevista),
                _tileInfo(context, 'Parto previsto', item.dtPartoPrevisto,
                    destaque: true),
              ])),
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
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
                    ).then((value) => safeSetState(() {}));
                  },
                  text: 'Parto',
                  icon: Icon(
                    Icons.add_alert,
                    size: 15.0,
                  ),
                  options: _opcoesBotao(context, Color(0xFF048508)),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
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
                      ).then((value) => safeSetState(() {}));
                    },
                    text: 'Pré-parto',
                    icon: Icon(
                      Icons.check,
                      size: 15.0,
                    ),
                    options: _opcoesBotao(context, AppTokens.secondary),
                  ),
                ),
                FFButtonWidget(
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
                    ).then((value) => safeSetState(() {}));
                  },
                  text: 'Aborto',
                  icon: Icon(
                    Icons.cancel_sharp,
                    size: 15.0,
                  ),
                  options:
                      _opcoesBotao(context, FlutterFlowTheme.of(context).error),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _part6(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: _faixaInfo(context, [
                _tileInfo(context, 'Inseminada', item.dtUltimaInseminacao),
                Text(
                  'Prev. do Parto: ${item.dtPartoPrevisto}',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
                Text(
                  'Sc. Prevista: ${item.dtSecPrevista}',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
              ])),
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 10.0, 0.0),
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
                      ).then((value) => safeSetState(() {}));
                    },
                    text: 'Aborto',
                    icon: Icon(
                      Icons.check_circle_outline_sharp,
                      size: 15.0,
                    ),
                    options: _opcoesBotao(
                        context, FlutterFlowTheme.of(context).error),
                  ),
                ),
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
                                dtSecPrevista: functions
                                    .converteDataStringDate(item.dtSecPrevista),
                              ),
                            ),
                          );
                        },
                      ).then((value) => safeSetState(() {}));
                    },
                    text: 'Secagem',
                    icon: Icon(
                      Icons.cancel_rounded,
                      size: 15.0,
                    ),
                    options: _opcoesBotao(context, AppTokens.secondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _part7(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: _faixaInfo(context, [
                _tileInfo(context, 'Inseminada', item.dtUltimaInseminacao),
              ])),
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
                  onPressed: ((!ehInseminadaPP(item.status)) &&
                          (item.dtPP == ''))
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
                          ).then((value) => safeSetState(() {}));
                        },
                  text: 'DG +',
                  icon: Icon(
                    Icons.check_circle,
                    size: 15.0,
                  ),
                  options: _opcoesBotao(context, Color(0xFF048508)),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
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
                      ).then((value) => safeSetState(() {}));
                    },
                    text: 'PP',
                    icon: Icon(
                      Icons.notifications,
                      size: 15.0,
                    ),
                    options: _opcoesBotao(context, AppTokens.secondary),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
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
                      ).then((value) => safeSetState(() {}));
                    },
                    text: 'DG -',
                    icon: Icon(
                      Icons.cancel_rounded,
                      size: 15.0,
                    ),
                    options: _opcoesBotao(
                        context, FlutterFlowTheme.of(context).error),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _part8(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: _faixaInfo(context, [
                  _tileInfo(context, 'Nascimento', item.dtNascimento),
                ])),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
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
                            child: DesmameWidget(
                              mode: DesmameMode.online,
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
                              itemUidIndex: index,
                            ),
                          ),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  },
                  text: 'Desmamar',
                  icon: Icon(
                    Icons.pause,
                    size: 15.0,
                  ),
                  options: _opcoesBotao(context, Color(0xFF048508)),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
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
                      ).then((value) => safeSetState(() {}));
                    },
                    text: 'Ação',
                    icon: Icon(
                      Icons.add_alert,
                      size: 15.0,
                    ),
                    options: _opcoesBotao(context, AppTokens.secondary),
                  ),
                ),
                if ((ehInseminada(item.status)) ||
                    (ehInseminadaPP(item.status)))
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                    child: _selo(
                        context,
                        'Inseminada',
                        FlutterFlowTheme.of(context).success,
                        Icons.check_sharp),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _part9(BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: _faixaInfo(context, [
                  _tileInfo(
                      context,
                      'DEL',
                      item.dtUltimoParto != ''
                          ? functions
                              .calcularDiferencaEmDias(item.dtUltimoParto)
                              .toString()
                          : ''),
                  _tileInfo(context, 'Último parto', item.dtUltimoParto),
                ])),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
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
                              child: NovaInseminacaoWidget(
                                uidPropriedade: widget.uidPropriedade!,
                                nomePropriedade: widget.nomePropriedade!,
                                uidTecnico: widget.uidTecnico!,
                                emailPropriedade: widget.emailPropriedade!,
                                grupoPredominante: item.grupoAnimal,
                                nomeAnimal: item.nomeAnimal,
                                visitaPresencial: widget.visitaPresencial!,
                                dtUltimaInseminacao: item.dtUltimaInseminacao,
                                brincoAnimal: item.brincoAnimal.toString(),
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
                    options: _opcoesBotao(context, AppTokens.brand),
                  ),
                ),
                FFButtonWidget(
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
                    ).then((value) => safeSetState(() {}));
                  },
                  text: 'Ação',
                  icon: Icon(
                    Icons.add_alert,
                    size: 15.0,
                  ),
                  options: _opcoesBotao(context, AppTokens.secondary),
                ),
                if ((ehInseminada(item.status)) ||
                    (ehInseminadaPP(item.status)))
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                    child: _selo(
                        context,
                        'Inseminada',
                        FlutterFlowTheme.of(context).success,
                        Icons.check_sharp),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _part10(
      BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: _faixaInfo(context, [
                _tileInfo(context, 'Inseminada', item.dtUltimaInseminacao),
                _tileInfo(context, 'Pré parto prev.', item.dtPrePartoPrevista),
                _tileInfo(context, 'Parto previsto', item.dtPartoPrevisto,
                    destaque: true),
              ])),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FFButtonWidget(
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
                  ).then((value) => safeSetState(() {}));
                },
                text: 'Parto',
                icon: Icon(
                  Icons.add_alert,
                  size: 15.0,
                ),
                options: _opcoesBotao(context, Color(0xFF048508)),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
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
                    ).then((value) => safeSetState(() {}));
                  },
                  text: 'Aborto',
                  icon: Icon(
                    Icons.cancel_sharp,
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

  Widget _part11(
      BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: _faixaInfo(context, [
                _tileInfo(context, 'Inseminada', item.dtUltimaInseminacao),
                _tileInfo(context, 'Pré parto prev.', item.dtPrePartoPrevista),
                _tileInfo(context, 'Parto previsto', item.dtPartoPrevisto,
                    destaque: true),
              ])),
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
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
                    ).then((value) => safeSetState(() {}));
                  },
                  text: 'Aborto',
                  icon: Icon(
                    Icons.cancel_sharp,
                    size: 15.0,
                  ),
                  options:
                      _opcoesBotao(context, FlutterFlowTheme.of(context).error),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
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
                      ).then((value) => safeSetState(() {}));
                    },
                    text: 'Parto',
                    icon: Icon(
                      Icons.add_alert,
                      size: 15.0,
                    ),
                    options: _opcoesBotao(context, Color(0xFF048508)),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
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
                      ).then((value) => safeSetState(() {}));
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
          ),
        ],
      ),
    );
  }

  Widget _part12(
      BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: _faixaInfo(context, [
                _tileInfo(context, 'Inseminada', item.dtUltimaInseminacao),
                _tileInfo(context, 'Pré parto prev.', item.dtPrePartoPrevista),
                _tileInfo(context, 'Parto previsto', item.dtPartoPrevisto,
                    destaque: true),
              ])),
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
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
                    ).then((value) => safeSetState(() {}));
                  },
                  text: 'Parto',
                  icon: Icon(
                    Icons.add_alert,
                    size: 15.0,
                  ),
                  options: _opcoesBotao(context, Color(0xFF048508)),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
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
                      ).then((value) => safeSetState(() {}));
                    },
                    text: 'Pré-parto',
                    icon: Icon(
                      Icons.check,
                      size: 15.0,
                    ),
                    options: _opcoesBotao(context, AppTokens.secondary),
                  ),
                ),
                FFButtonWidget(
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
                    ).then((value) => safeSetState(() {}));
                  },
                  text: 'Aborto',
                  icon: Icon(
                    Icons.cancel_sharp,
                    size: 15.0,
                  ),
                  options:
                      _opcoesBotao(context, FlutterFlowTheme.of(context).error),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _part13(
      BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: _faixaInfo(context, [
                _tileInfo(context, 'Inseminada', item.dtUltimaInseminacao),
                Text(
                  'Prev. do Parto: ${item.dtPartoPrevisto}',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
                Text(
                  'Sc. Prevista: ${item.dtSecPrevista}',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
              ])),
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 10.0, 0.0),
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
                      ).then((value) => safeSetState(() {}));
                    },
                    text: 'Aborto',
                    icon: Icon(
                      Icons.check_circle_outline_sharp,
                      size: 15.0,
                    ),
                    options: _opcoesBotao(
                        context, FlutterFlowTheme.of(context).error),
                  ),
                ),
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
                                dtSecPrevista: functions
                                    .converteDataStringDate(item.dtSecPrevista),
                              ),
                            ),
                          );
                        },
                      ).then((value) => safeSetState(() {}));
                    },
                    text: 'Secagem',
                    icon: Icon(
                      Icons.cancel_rounded,
                      size: 15.0,
                    ),
                    options: _opcoesBotao(context, AppTokens.secondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _part14(
      BuildContext context, AnimaisProdutoresStruct item, int index) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: _faixaInfo(context, [
                _tileInfo(context, 'Inseminada', item.dtUltimaInseminacao),
              ])),
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
                  onPressed: ((!ehInseminadaPP(item.status)) &&
                          (item.dtPP == ''))
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
                          ).then((value) => safeSetState(() {}));
                        },
                  text: 'DG +',
                  icon: Icon(
                    Icons.check_circle,
                    size: 15.0,
                  ),
                  options: _opcoesBotao(context, Color(0xFF048508)),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
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
                      ).then((value) => safeSetState(() {}));
                    },
                    text: 'PP',
                    icon: Icon(
                      Icons.notifications,
                      size: 15.0,
                    ),
                    options: _opcoesBotao(context, AppTokens.secondary),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
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
                      ).then((value) => safeSetState(() {}));
                    },
                    text: 'DG -',
                    icon: Icon(
                      Icons.cancel_rounded,
                      size: 15.0,
                    ),
                    options: _opcoesBotao(
                        context, FlutterFlowTheme.of(context).error),
                  ),
                ),
              ],
            ),
          ),
        ],
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
          child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF75E38), Color(0xFFEC3B5B)],
                  begin: AlignmentDirectional(-1.0, -1.0),
                  end: AlignmentDirectional(1.0, 1.0),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.0),
                  bottomRight: Radius.circular(24.0),
                ),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
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
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 0.0, 0.0),
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
                            'Lista completa',
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
              )),
        ),
        body: Container(
          width: MediaQuery.sizeOf(context).width * 1.0,
          height: MediaQuery.sizeOf(context).height * 1.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Column(
            children: [
              _campoBusca(context),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final lista = _animaisVisiveis();
                    final buscando = _searchListTextController.text.isNotEmpty;
                    return ListView.builder(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 120.0),
                      itemCount: lista.length,
                      itemBuilder: (context, i) => buscando
                          ? _buildAnimalCardFiltrado(context, lista[i], i)
                          : _buildAnimalCard(context, lista[i], i),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
