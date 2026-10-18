// ignore_for_file: unnecessary_null_comparison, unused_import

import '/core/ui/cabecalho_tela.dart';
import 'dart:async';

import '/core/connectivity/connectivity_service.dart';
import '/data/backend.dart';
import '/features/inseminacoes/application/filtros_inseminacao.dart';
import '/domain/animais/classificacao_animal.dart';
import '/domain/animais/ordenacao_animal.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/features/animais/presentation/animais_ordenados_view.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/features/animais/application/ordenacao_animais.dart';
import '/features/animais/presentation/widgets/seletor_ordem_animais.dart';
import '/core/ui/app_card.dart';
import '/core/ui/card_animal_lista.dart';
import '/core/ui/painel_lista.dart';
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

  /// Critério e direção da ordem, nos mesmos chips da lista de animais
  /// (Nome A-Z / Brinco). Tocar no chip ativo inverte a direção.
  OrdemAnimais _ordem = OrdemAnimais.nome;
  bool _crescente = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

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

  /// Card de um animal elegível, no padrão de listas: título com o selo
  /// "Inseminada", a data da última inseminação na faixa de informações e as
  /// ações "Fez Cio" / "Inseminar" por último. Tocar abre o prontuário.
  Widget _itemAnimalElegivel(
      BuildContext context, AnimaisProdutoresStruct item) {
    return CartaoLista(
      aoTocar: () => context.pushNamed(
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
      ),
      child: ConteudoCardAnimal(
        grupo: item.grupoAnimal,
        titulo: tituloNomeBrinco(item.nomeAnimal, item.brincoAnimal),
        selo: (ehInseminada(item.status) || ehInseminadaPP(item.status))
            ? const SeloStatus('Inseminada')
            : null,
        info: [InfoAnimal('Última inseminação', item.dtUltimaInseminacao)],
        acoes: LinhaAcoes(children: [
          FFButtonWidget(
            onPressed: () => _abrirFolha(
              RegistrarCioWidget(
                uidPropriedade: widget.uidPropriedade!,
                nomePropriedade: widget.nomePropriedade!,
                uidTecnico: widget.uidTecnico!,
                emailPropriedade: widget.emailPropriedade!,
                uidAnimaisProdutores: item.uidAnimal,
                uidAnimalOffline: item.uidAnimalOffline,
                grupoPredominante: item.grupoAnimal,
                nomeAnimal: item.nomeAnimal,
                visitaPresencial: widget.visitaPresencial!,
                brincoAnimal: item.brincoAnimal.toString(),
                diasDg: widget.diasDg!,
              ),
            ),
            text: 'Fez Cio',
            icon: const Icon(Icons.repeat, size: 15.0),
            options: opcoesBotaoCard(context, AppTokens.positivo),
          ),
          FFButtonWidget(
            onPressed: () => _abrirFolha(
              NovaInseminacaoWidget(
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
            text: 'Inseminar',
            icon: const Icon(Icons.playlist_add, size: 15.0),
            options: opcoesBotaoCard(context, AppTokens.brand),
          ),
        ]),
      ),
    );
  }

  /// Abre um formulário na folha inferior e redesenha a lista ao fechar.
  Future<void> _abrirFolha(Widget formulario) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: formulario,
        ),
      ),
    );
    safeSetState(() {});
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: CabecalhoTela(
          titulo: 'Inseminações',
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
            // O painel fica fixo; só a lista rola. `AnimaisOrdenadosView` é a
            // fonte reativa (ObjectBox) e o recorte acontece ANTES de
            // construir, então a lista monta só as linhas visíveis.
            Expanded(
              child: AnimaisOrdenadosView(
                comparador: compararStructs,
                builder: (context, animais) {
                  // O provider entrega o rebanho do APARELHO; a propriedade
                  // e recortada aqui, em Dart, sem montar widget nenhum.
                  final visiveis = ordenarStructs(
                    elegiveisInseminacao(
                      animais.where((a) =>
                          a.uidTecnicoPropriedade == widget.uidPropriedade),
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
                        _itemAnimalElegivel(context, visiveis[i]),
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
