// ignore_for_file: unused_import, unused_local_variable, unnecessary_null_comparison

import '/domain/animais/data_ultima_acao.dart';
import '/features/shared/widgets/selo_hoje.dart';
import '/data/backend.dart';
import '/domain/animais/classificacao_animal.dart';
import '/domain/animais/dias_desde.dart';
import '/domain/animais/ordenacao_animal.dart';
import '/features/animais/presentation/animais_ordenados_view.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/cabecalho_tela.dart';
import '/core/ui/card_animal_lista.dart';
import '/core/ui/painel_lista.dart';
import '/features/animais/application/ordenacao_animais.dart';
import '/features/animais/presentation/widgets/seletor_ordem_animais.dart';
import '/core/ui/app_card.dart';
import '/core/ui/flutter_flow_widgets.dart';
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
import '/core/ui/custom_functions.dart' as functions;
import '/features/prontuario/presentation/pages/prontuario_animal_page.dart';
import '/features/propriedades/presentation/pages/inicio_propriedade_page.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// O que o card mostra num estado: as informações e as ações.
typedef _ConteudoCard = ({List<Widget> info, List<Widget> acoes});

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
  FocusNode? _searchListFocusNode;
  TextEditingController? _searchListTextController;

  /// Critério e direção da ordem, nos chips do padrão de listas (Nome A-Z /
  /// Brinco). Tocar no chip ativo inverte a direção.
  OrdemAnimais _ordem = OrdemAnimais.nome;
  bool _crescente = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {});

    _searchListTextController ??= TextEditingController();
    _searchListFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
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
  List<AnimaisProdutoresStruct> _animaisVisiveis(
      List<AnimaisProdutoresStruct> animais) {
    final busca = _searchListTextController.text.toLowerCase();
    return animais.where((item) {
      if (item.uidTecnicoPropriedade != widget.uidPropriedade) return false;
      if (!(ehNovilha(item.grupoAnimal) || ehVaca(item.grupoAnimal))) {
        return false;
      }
      if (busca.isEmpty) return true;
      return item.nomeAnimal.toLowerCase().contains(busca) ||
          item.brincoAnimal.toString().contains(busca);
    }).toList();
  }

  /// Abre o prontuario do animal.
  ///
  /// Extraido porque os oito parametros serializados estavam duplicados nos
  /// dois cards (normal e da busca); com o card inteiro clicavel seriam quatro
  /// copias do mesmo bloco.
  void _abrirProntuario(AnimaisProdutoresStruct item) {
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
  }

  /// Card de um animal no padrão de listas (`docs/padrao-layout-listas.md`):
  /// avatar, nome e status, as informações do estado atual e as ações por
  /// último. Tocar no card abre o prontuário.
  ///
  /// Era duplicado — `_front1`/`_back3`/`_part1..7` para a lista e
  /// `_front2`/`_back4`/`_part8..14` para a busca, cópias idênticas.
  Widget _cardAnimal(
      BuildContext context, AnimaisProdutoresStruct item, int index) {
    final conteudo = _conteudoPorEstado(context, item, index);
    return CartaoLista(
      aoTocar: () => _abrirProntuario(item),
      child: ConteudoCardAnimal(
        grupo: item.grupoAnimal,
        titulo: tituloNomeBrinco(item.nomeAnimal, item.brincoAnimal),
        subtitulo: item.status,
        selo: ehDescarte(item.status)
            ? const SeloStatus('Descartado', cor: AppTokens.negativo)
            : SeloHoje(dtUltimaAcao: item.dtUltimaAcao),
        info: conteudo?.info ?? const [],
        acoes: (conteudo?.acoes.isNotEmpty ?? false)
            ? LinhaAcoes(children: conteudo!.acoes)
            : null,
      ),
    );
  }

  /// Informações e ações conforme grupo/status (antes `_back3`).
  _ConteudoCard? _conteudoPorEstado(
      BuildContext context, AnimaisProdutoresStruct item, int index) {
    final bezerro =
        ehBezerras(item.grupoAnimal) || ehBezerros(item.grupoAnimal);
    if (ehVazia(item.status)) {
      return bezerro
          ? _part1(context, item, index)
          : _part2(context, item, index);
    }
    if (bezerro) return null;
    if (item.status == 'Pré Parto') return _part3(context, item, index);
    if (ehPrenha(item.status) && ehNovilha(item.grupoAnimal)) {
      return _part4(context, item, index);
    }
    if (ehSeca(item.status) && ehVaca(item.grupoAnimal)) {
      return _part5(context, item, index);
    }
    if (ehPrenha(item.status) && ehVaca(item.grupoAnimal)) {
      return _part6(context, item, index);
    }
    if (ehInseminadaPP(item.status) || ehInseminada(item.status)) {
      return _part7(context, item, index);
    }
    return null;
  }

  Widget _botao(
          String texto, IconData icone, Color cor, VoidCallback? aoTocar) =>
      FFButtonWidget(
        onPressed: aoTocar,
        text: texto,
        icon: Icon(icone, size: 15.0),
        options: opcoesBotaoCard(context, cor),
      );

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

  /// Bezerros: desmame e ação.
  _ConteudoCard _part1(
          BuildContext context, AnimaisProdutoresStruct item, int index) =>
      (
        info: [
          InfoAnimal('Nascimento', item.dtNascimento),
        ],
        acoes: [
          _botao(
              'Desmamar',
              Icons.pause,
              AppTokens.brand,
              () => _abrirFolha(DesmameWidget(
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
                  ))),
          _botao(
              'Ação',
              Icons.add_alert,
              AppTokens.positivo,
              () => _abrirFolha(NovaAcaoExameGinecologicoWidget(
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
                  ))),
        ],
      );

  /// Vazia: inseminar ou registrar ação.
  _ConteudoCard _part2(
          BuildContext context, AnimaisProdutoresStruct item, int index) =>
      (
        info: [
          InfoAnimal('DEL', diasDesde(item.dtUltimoParto)),
          InfoAnimal('Último parto', item.dtUltimoParto),
        ],
        acoes: [
          _botao(
              'Inseminar',
              Icons.playlist_add,
              AppTokens.brand,
              () => _abrirFolha(NovaInseminacaoWidget(
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
                  ))),
          _botao(
              'Ação',
              Icons.add_alert,
              AppTokens.positivo,
              () => _abrirFolha(NovaAcaoExameGinecologicoWidget(
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
                  ))),
        ],
      );

  /// Pré-parto: parto ou aborto (negativo por último).
  _ConteudoCard _part3(
          BuildContext context, AnimaisProdutoresStruct item, int index) =>
      (
        info: [
          InfoAnimal('Inseminada', item.dtUltimaInseminacao),
          InfoAnimal('Pré parto prev.', item.dtPrePartoPrevista),
          InfoAnimal('Parto previsto', item.dtPartoPrevisto, destaque: true),
        ],
        acoes: [
          _botao(
              'Parto',
              Icons.add_alert,
              AppTokens.positivo,
              () => _abrirFolha(RegistrarPartoWidget(
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
                  ))),
          _botao(
              'Aborto',
              Icons.cancel_sharp,
              AppTokens.negativo,
              () => _abrirFolha(RegistroAbortoWidget(
                    uidPropriedade: widget.uidPropriedade!,
                    nomePropriedade: widget.nomePropriedade!,
                    uidTecnico: widget.uidTecnico!,
                    emailPropriedade: widget.emailPropriedade!,
                    visitaPresencial: widget.visitaPresencial!,
                    diasDg: widget.diasDg!,
                    uidAnimaisProdutores: item.uidAnimal,
                    uidAnimalOffline: item.uidAnimalOffline,
                    nomeAnimal: item.nomeAnimal,
                  ))),
        ],
      );

  /// Novilha prenha: mesma ordem das Secas.
  _ConteudoCard _part4(
          BuildContext context, AnimaisProdutoresStruct item, int index) =>
      (
        info: [
          InfoAnimal('Inseminada', item.dtUltimaInseminacao),
          InfoAnimal('Pré parto prev.', item.dtPrePartoPrevista),
          InfoAnimal('Parto previsto', item.dtPartoPrevisto, destaque: true),
        ],
        acoes: [
          _botao(
              'Parto',
              Icons.add_alert,
              AppTokens.positivo,
              () => _abrirFolha(RegistrarPartoWidget(
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
                  ))),
          _botao(
              'Pré-parto',
              Icons.check,
              AppTokens.brand,
              () => _abrirFolha(RegistrarPrePartoWidget(
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
                    dtPrePartoPrevista: functions
                        .converteDataStringDate(item.dtPrePartoPrevista),
                  ))),
          _botao(
              'Aborto',
              Icons.cancel_sharp,
              AppTokens.negativo,
              () => _abrirFolha(RegistroAbortoWidget(
                    uidPropriedade: widget.uidPropriedade!,
                    nomePropriedade: widget.nomePropriedade!,
                    uidTecnico: widget.uidTecnico!,
                    emailPropriedade: widget.emailPropriedade!,
                    visitaPresencial: widget.visitaPresencial!,
                    diasDg: widget.diasDg!,
                    uidAnimaisProdutores: item.uidAnimal,
                    uidAnimalOffline: item.uidAnimalOffline,
                    nomeAnimal: item.nomeAnimal,
                  ))),
        ],
      );

  /// Vaca seca: mesma ordem das Secas.
  _ConteudoCard _part5(
          BuildContext context, AnimaisProdutoresStruct item, int index) =>
      (
        info: [
          InfoAnimal('Inseminada', item.dtUltimaInseminacao),
          InfoAnimal('Pré parto prev.', item.dtPrePartoPrevista),
          InfoAnimal('Parto previsto', item.dtPartoPrevisto, destaque: true),
        ],
        acoes: [
          _botao(
              'Parto',
              Icons.add_alert,
              AppTokens.positivo,
              () => _abrirFolha(RegistrarPartoWidget(
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
                  ))),
          _botao(
              'Pré-parto',
              Icons.check,
              AppTokens.brand,
              () => _abrirFolha(RegistrarPrePartoWidget(
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
                    dtPrePartoPrevista: functions
                        .converteDataStringDate(item.dtPrePartoPrevista),
                  ))),
          _botao(
              'Aborto',
              Icons.cancel_sharp,
              AppTokens.negativo,
              () => _abrirFolha(RegistroAbortoWidget(
                    uidPropriedade: widget.uidPropriedade!,
                    nomePropriedade: widget.nomePropriedade!,
                    uidTecnico: widget.uidTecnico!,
                    emailPropriedade: widget.emailPropriedade!,
                    visitaPresencial: widget.visitaPresencial!,
                    diasDg: widget.diasDg!,
                    uidAnimaisProdutores: item.uidAnimal,
                    uidAnimalOffline: item.uidAnimalOffline,
                    nomeAnimal: item.nomeAnimal,
                  ))),
        ],
      );

  /// Vaca prenha: igual à tela de Prenhas.
  _ConteudoCard _part6(
          BuildContext context, AnimaisProdutoresStruct item, int index) =>
      (
        info: [
          InfoAnimal('Inseminada', item.dtUltimaInseminacao),
          InfoAnimal('Prev. parto', item.dtPartoPrevisto, destaque: true),
          InfoAnimal('Sec. prevista', item.dtSecPrevista),
        ],
        acoes: [
          _botao(
              'Secagem',
              Icons.water_drop_outlined,
              AppTokens.positivo,
              () => _abrirFolha(RegistrarSecagemWidget(
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
                  ))),
          _botao(
              'Aborto',
              Icons.cancel_outlined,
              AppTokens.negativo,
              () => _abrirFolha(RegistroAbortoWidget(
                    uidPropriedade: widget.uidPropriedade!,
                    nomePropriedade: widget.nomePropriedade!,
                    uidTecnico: widget.uidTecnico!,
                    emailPropriedade: widget.emailPropriedade!,
                    visitaPresencial: widget.visitaPresencial!,
                    diasDg: widget.diasDg!,
                    uidAnimaisProdutores: item.uidAnimal,
                    uidAnimalOffline: item.uidAnimalOffline,
                    nomeAnimal: item.nomeAnimal,
                  ))),
        ],
      );

  /// Inseminada: igual ao diagnóstico de gestação (PP, DG+, DG-).
  _ConteudoCard _part7(
          BuildContext context, AnimaisProdutoresStruct item, int index) =>
      (
        info: [
          InfoAnimal('Dias IA', diasDesde(item.dtUltimaInseminacao)),
          InfoAnimal('Inseminada', item.dtUltimaInseminacao),
        ],
        acoes: [
          _botao(
              'PP',
              Icons.notifications,
              const Color(0xFF0F9488),
              () => _abrirFolha(ConfirmaPpWidget(
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
                  ))),
          _botao(
              'DG +',
              Icons.check_circle,
              AppTokens.positivo,
              !podeRegistrarDgMais(item.status, item.dtPP)
                  ? null
                  : () => _abrirFolha(DgMaisWidget(
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
                      ))),
          _botao(
              'DG -',
              Icons.cancel_rounded,
              AppTokens.negativo,
              () => _abrirFolha(DgMenosWidget(
                    uidPropriedade: widget.uidPropriedade!,
                    nomePropriedade: widget.nomePropriedade!,
                    uidTecnico: widget.uidTecnico!,
                    emailPropriedade: widget.emailPropriedade!,
                    uidAnimaisProdutores: item.uidAnimal,
                    uidAnimalOffline: item.uidAnimalOffline,
                    grupoPredominante: item.grupoAnimal,
                    nomeAnimal: item.nomeAnimal,
                    visitaPresencial: widget.visitaPresencial!,
                  ))),
        ],
      );

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
        appBar: const CabecalhoTela(titulo: 'Lista completa'),
        body: Container(
          width: MediaQuery.sizeOf(context).width * 1.0,
          height: MediaQuery.sizeOf(context).height * 1.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
          ),
          child: Column(
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
              // O painel fica fixo; só a lista rola.
              Expanded(
                child: AnimaisOrdenadosView(
                  comparador: compararStructs,
                  builder: (context, animais) {
                    final lista = ordenarStructs(_animaisVisiveis(animais),
                        ordem: _ordem, crescente: _crescente);
                    return ListView.builder(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 8.0, 0.0, 120.0),
                      itemCount: lista.length,
                      itemBuilder: (context, i) =>
                          _cardAnimal(context, lista[i], i),
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
