// ignore_for_file: unnecessary_null_comparison, dead_code

import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/features/prontuario/presentation/widgets/ficha_clinica.dart';
import '/features/prontuario/application/acao_record_adapter.dart';
import '/core/ui/app_card.dart';
import '/core/ui/custom_functions.dart' as functions;
import '/features/prontuario/presentation/pages/pron_abortos_page.dart';
import '/features/prontuario/presentation/pages/pron_acoes_page.dart';
import '/features/prontuario/presentation/pages/pron_cios_page.dart';
import '/features/prontuario/presentation/pages/pron_diag_gestacao_page.dart';
import '/features/prontuario/presentation/pages/pron_inseminacoes_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProntuarioAnimalPage extends StatefulWidget {
  const ProntuarioAnimalPage({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.uidAnimaisProdutores,
    required this.grupoPredominante,
    required this.visitaPresencial,
    required this.diasDg,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final DocumentReference? uidAnimaisProdutores;
  final String? grupoPredominante;
  final bool? visitaPresencial;
  final String? diasDg;

  static String routeName = 'prontuarioAnimal';
  static String routePath = '/prontuarioAnimal';

  @override
  State<ProntuarioAnimalPage> createState() => _ProntuarioAnimalPageState();
}

class _ProntuarioAnimalPageState extends State<ProntuarioAnimalPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Card extraído do build (Fase 4).
  Widget _buildCard8(
      BuildContext context, AcaoSanitarioEntity item, int index) {
    return LinhaProntuario(
      identidade: IdentidadeSecao.doencas,
      data: item.dtAcaoFormatada ?? '',
      titulo: item.acao ?? '',
      detalhe: (item.obsVisita?.isEmpty ?? true) ? null : item.obsVisita,
    );
  }

  Widget _buildCard7(
      BuildContext context, AcaoSanitarioEntity item, int index) {
    return LinhaProntuario(
      identidade: IdentidadeSecao.exames,
      data: item.dtAcaoFormatada ?? '',
      titulo: item.acao ?? '',
      detalhe: (item.obsVisita?.isEmpty ?? true) ? null : item.obsVisita,
    );
  }

  Widget _buildCard6(
      BuildContext context, AcaoSanitarioEntity item, int index) {
    return LinhaProntuario(
      identidade: IdentidadeSecao.vacinas,
      data: item.dtAcaoFormatada ?? '',
      titulo: item.acao ?? '',
      detalhe: (item.obsVisita?.isEmpty ?? true) ? null : item.obsVisita,
    );
  }

  Widget _buildCard5(BuildContext context, AcoesRecord item, int index) {
    return LinhaProntuario(
      identidade: IdentidadeSecao.cios,
      data: item.dataVisita,
      titulo: 'Fez cio',
      detalhe: null,
    );
  }

  Widget _buildCard4(BuildContext context, AcoesRecord item, int index) {
    return LinhaProntuario(
      identidade: IdentidadeSecao.diagnosticos,
      data: item.dataVisita,
      titulo: item.acao,
      detalhe: null,
    );
  }

  Widget _buildCard3(BuildContext context, AcoesRecord item, int index) {
    return LinhaProntuario(
      identidade: IdentidadeSecao.abortos,
      data: item.dtAborto,
      titulo: 'Aborto',
      detalhe: null,
    );
  }

  Widget _buildCard2(BuildContext context, AcoesRecord item, int index) {
    return LinhaProntuario(
      identidade: IdentidadeSecao.acoes,
      data: item.dataVisita,
      titulo: item.acao,
      detalhe: item.obsVisita.isEmpty ? null : item.obsVisita,
      onLongPress: () async {
        final confirmou = await showDialog<bool>(
              context: context,
              builder: (alertDialogContext) => AlertDialog(
                title: const Text('Deseja realmente eliminar essa ação?'),
                content: const Text('Ação ao confirmar, é irreversível.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext, false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext, true),
                    child: const Text('Confirmar'),
                  ),
                ],
              ),
            ) ??
            false;
        if (!confirmou) return;

        // Exclusão offline-first. A busca anterior era um
        // `queryTratamentosRecordOnce` SEM parent — ou seja, na coleção raiz
        // `tratamentos`, que não existe — seguida de `.reference.delete()`. O
        // `!` sobre um resultado sempre null fazia a exclusão lançar exceção.
        final tratamentoRepo = TratamentoRepository();
        for (final t in tratamentoRepo.getAll().where((e) =>
            !e.isDeleted && e.uidAcaoLancadaPath == item.reference.path)) {
          await tratamentoRepo.softDelete(t);
        }
        final acaoRepo = AcaoRepository();
        final acaoLocal = acaoRepo.getByFirestoreId(item.reference.id);
        if (acaoLocal != null) {
          await acaoRepo.softDelete(acaoLocal);
        }
        safeSetState(() {});
      },
    );
  }

  Widget _buildCard1(BuildContext context, AcoesRecord item, int index) {
    return LinhaProntuario(
      identidade: IdentidadeSecao.inseminacoes,
      data: item.dataVisita,
      titulo: item.touroInseminacao.isNotEmpty ? item.touroInseminacao : 'IA',
      detalhe: item.dataPartoPrevisto.isEmpty
          ? null
          : 'Parto previsto: ${item.dataPartoPrevisto}',
    );
  }

  Widget _cabecalho(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
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
          'Prontuário do animal',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                font: GoogleFonts.outfit(
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
                color: Colors.white,
                fontSize: 22.0,
                letterSpacing: 0.0,
                fontWeight:
                    FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                fontStyle:
                    FlutterFlowTheme.of(context).headlineMedium.fontStyle,
              ),
        ),
      ],
    );
  }

  Widget _conteudo(BuildContext context) {
    return Container(
      width: 500.0,
      constraints: BoxConstraints(
        maxWidth: 570.0,
      ),
      margin: EdgeInsetsDirectional.fromSTEB(12.0, 10.0, 12.0, 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tituloRegistro(context),
            Divider(
              height: 2.0,
              thickness: 1.0,
              color: Color(0xFFE5E7EB),
            ),
            _tituloInseminacoes(context),
            _listaInseminacoes(context),
            _tituloAcoes(context),
            _listaAcoes(context),
            _tituloAbortos(context),
            _listaAbortos(context),
            _tituloDiagGestacao(context),
            _listaDiagGestacao(context),
            _tituloCios(context),
            _listaCios(context),
            _tituloVacinas(context),
            _listaVacinas(context),
            _tituloExames(context),
            _listaExames(context),
            _tituloDoencas(context),
            _listaDoencas(context),
          ],
        ),
      ),
    );
  }

  Widget _tituloRegistro(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Registro do animal:',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tituloInseminacoes(BuildContext context) {
    return TituloSecao(
      titulo: 'Inseminações',
      identidade: IdentidadeSecao.inseminacoes,
      onVerMais: () async {
        context.pushNamed(
          PronInseminacoesPage.routeName,
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
              widget.uidAnimaisProdutores,
              ParamType.DocumentReference,
            ),
            'grupoPredominante': serializeParam(
              widget.grupoPredominante,
              ParamType.String,
            ),
            'visitaPresencial': serializeParam(
              widget.visitaPresencial,
              ParamType.bool,
            ),
          }.withoutNulls,
        );
      },
    );
  }

  Widget _listaInseminacoes(BuildContext context) {
    return SingleChildScrollView(
      // A pagina inteira ja rola; sem isto cada secao vira sua propria
      // area de rolagem e o dedo prende dentro dela.
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          StreamBuilder<List<AcaoEntity>>(
            // Fonte: ObjectBox. Antes era um `.snapshots()` do Firestore
            // por secao — cinco listeners de rede por animal aberto.
            stream: AcaoRepository().watchByAnimalComTipos(
              widget.uidAnimaisProdutores!.path,
              incluir: const {'Inseminada'},
              limite: 3,
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              final acoes = snapshot.data!;
              if (acoes.isEmpty) return const SecaoVazia();

              return CorpoSecao(
                  child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                // A pagina inteira ja rola; sem isto cada secao vira sua
                // propria area de rolagem e o dedo prende dentro da lista.
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: acoes.length,
                itemBuilder: (context, listViewIndex) {
                  return _buildCard1(context,
                      acaoEntityToRecord(acoes[listViewIndex]), listViewIndex);
                },
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget _tituloAcoes(BuildContext context) {
    return TituloSecao(
      titulo: 'Ações',
      identidade: IdentidadeSecao.acoes,
      onVerMais: () async {
        context.pushNamed(
          PronAcoesPage.routeName,
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
              widget.uidAnimaisProdutores,
              ParamType.DocumentReference,
            ),
            'grupoPredominante': serializeParam(
              widget.grupoPredominante,
              ParamType.String,
            ),
            'visitaPresencial': serializeParam(
              widget.visitaPresencial,
              ParamType.bool,
            ),
          }.withoutNulls,
        );
      },
    );
  }

  Widget _listaAcoes(BuildContext context) {
    return SingleChildScrollView(
      // A pagina inteira ja rola; sem isto cada secao vira sua propria
      // area de rolagem e o dedo prende dentro dela.
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          StreamBuilder<List<AcaoEntity>>(
            // Fonte: ObjectBox. Antes era um `.snapshots()` do Firestore
            // por secao — cinco listeners de rede por animal aberto.
            stream: AcaoRepository().watchByAnimalComTipos(
              widget.uidAnimaisProdutores!.path,
              excluir: const {
                'Inseminada',
                'Cio',
                'PP',
                'DG+',
                'DG-',
                'Inseminada PP'
              },
              limite: 3,
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              final acoes = snapshot.data!;
              if (acoes.isEmpty) return const SecaoVazia();

              return CorpoSecao(
                  child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                // A pagina inteira ja rola; sem isto cada secao vira sua
                // propria area de rolagem e o dedo prende dentro da lista.
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: acoes.length,
                itemBuilder: (context, listViewIndex) {
                  return _buildCard2(context,
                      acaoEntityToRecord(acoes[listViewIndex]), listViewIndex);
                },
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget _tituloAbortos(BuildContext context) {
    return TituloSecao(
      titulo: 'Abortos',
      identidade: IdentidadeSecao.abortos,
      onVerMais: () async {
        context.pushNamed(
          PronAbortosPage.routeName,
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
              widget.uidAnimaisProdutores,
              ParamType.DocumentReference,
            ),
            'grupoPredominante': serializeParam(
              widget.grupoPredominante,
              ParamType.String,
            ),
            'visitaPresencial': serializeParam(
              widget.visitaPresencial,
              ParamType.bool,
            ),
          }.withoutNulls,
        );
      },
    );
  }

  Widget _listaAbortos(BuildContext context) {
    return SingleChildScrollView(
      // A pagina inteira ja rola; sem isto cada secao vira sua propria
      // area de rolagem e o dedo prende dentro dela.
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          StreamBuilder<List<AcaoEntity>>(
            // Fonte: ObjectBox. Antes era um `.snapshots()` do Firestore
            // por secao — cinco listeners de rede por animal aberto.
            stream: AcaoRepository().watchByAnimalComTipos(
              widget.uidAnimaisProdutores!.path,
              incluir: const {'Aborto'},
              limite: 3,
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              final acoes = snapshot.data!;
              if (acoes.isEmpty) return const SecaoVazia();

              return CorpoSecao(
                  child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                // A pagina inteira ja rola; sem isto cada secao vira sua
                // propria area de rolagem e o dedo prende dentro da lista.
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: acoes.length,
                itemBuilder: (context, listViewIndex) {
                  return _buildCard3(context,
                      acaoEntityToRecord(acoes[listViewIndex]), listViewIndex);
                },
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget _tituloDiagGestacao(BuildContext context) {
    return TituloSecao(
      titulo: 'Diagnósticos de gestação',
      identidade: IdentidadeSecao.diagnosticos,
      onVerMais: () async {
        context.pushNamed(
          PronDiagGestacaoPage.routeName,
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
              widget.uidAnimaisProdutores,
              ParamType.DocumentReference,
            ),
            'grupoPredominante': serializeParam(
              widget.grupoPredominante,
              ParamType.String,
            ),
            'visitaPresencial': serializeParam(
              widget.visitaPresencial,
              ParamType.bool,
            ),
          }.withoutNulls,
        );
      },
    );
  }

  Widget _listaDiagGestacao(BuildContext context) {
    return SingleChildScrollView(
      // A pagina inteira ja rola; sem isto cada secao vira sua propria
      // area de rolagem e o dedo prende dentro dela.
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          StreamBuilder<List<AcaoEntity>>(
            // Fonte: ObjectBox. Antes era um `.snapshots()` do Firestore
            // por secao — cinco listeners de rede por animal aberto.
            stream: AcaoRepository().watchByAnimalComTipos(
              widget.uidAnimaisProdutores!.path,
              incluir: const {'PP', 'DG+', 'DG-'},
              limite: 3,
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              final acoes = snapshot.data!;
              if (acoes.isEmpty) return const SecaoVazia();

              return CorpoSecao(
                  child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                // A pagina inteira ja rola; sem isto cada secao vira sua
                // propria area de rolagem e o dedo prende dentro da lista.
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: acoes.length,
                itemBuilder: (context, listViewIndex) {
                  return _buildCard4(context,
                      acaoEntityToRecord(acoes[listViewIndex]), listViewIndex);
                },
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget _tituloCios(BuildContext context) {
    return TituloSecao(
      titulo: 'Cios',
      identidade: IdentidadeSecao.cios,
      onVerMais: () async {
        context.pushNamed(
          PronCiosPage.routeName,
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
              widget.uidAnimaisProdutores,
              ParamType.DocumentReference,
            ),
            'grupoPredominante': serializeParam(
              widget.grupoPredominante,
              ParamType.String,
            ),
            'visitaPresencial': serializeParam(
              widget.visitaPresencial,
              ParamType.bool,
            ),
          }.withoutNulls,
        );
      },
    );
  }

  Widget _listaCios(BuildContext context) {
    return SingleChildScrollView(
      // A pagina inteira ja rola; sem isto cada secao vira sua propria
      // area de rolagem e o dedo prende dentro dela.
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          StreamBuilder<List<AcaoEntity>>(
            // Fonte: ObjectBox. Antes era um `.snapshots()` do Firestore
            // por secao — cinco listeners de rede por animal aberto.
            stream: AcaoRepository().watchByAnimalComTipos(
              widget.uidAnimaisProdutores!.path,
              incluir: const {'Cio'},
              limite: 3,
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              final acoes = snapshot.data!;
              if (acoes.isEmpty) return const SecaoVazia();

              return CorpoSecao(
                  child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                // A pagina inteira ja rola; sem isto cada secao vira sua
                // propria area de rolagem e o dedo prende dentro da lista.
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: acoes.length,
                itemBuilder: (context, listViewIndex) {
                  return _buildCard5(context,
                      acaoEntityToRecord(acoes[listViewIndex]), listViewIndex);
                },
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget _tituloVacinas(BuildContext context) {
    return TituloSecao(
      titulo: 'Vacinas',
      identidade: IdentidadeSecao.vacinas,
      onVerMais: () async {
        context.pushNamed(
          PronCiosPage.routeName,
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
              widget.uidAnimaisProdutores,
              ParamType.DocumentReference,
            ),
            'grupoPredominante': serializeParam(
              widget.grupoPredominante,
              ParamType.String,
            ),
            'visitaPresencial': serializeParam(
              widget.visitaPresencial,
              ParamType.bool,
            ),
          }.withoutNulls,
        );
      },
    );
  }

  Widget _listaVacinas(BuildContext context) {
    return SingleChildScrollView(
      // A pagina inteira ja rola; sem isto cada secao vira sua propria
      // area de rolagem e o dedo prende dentro dela.
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Fonte única ObjectBox: ações da propriedade filtradas por animal e
          // tipo. Antes apontava para tecnico/acoesSanitario, path que deixou
          // de existir com a mudanca da colecao para a propriedade.
          StreamBuilder<List<AcaoSanitarioEntity>>(
            stream: AcaoSanitarioRepository()
                .watchByParentPath(widget.uidPropriedade?.path ?? ''),
            builder: (context, snapshot) {
              final listViewAcoesSanitarioRecordList =
                  _sanitariasDoAnimal(snapshot.data, 'Vacina');
              if (listViewAcoesSanitarioRecordList.isEmpty) {
                return const SecaoVazia();
              }

              return CorpoSecao(
                  child: ListView.builder(
                padding: EdgeInsets.zero,
                primary: false,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: listViewAcoesSanitarioRecordList.length,
                itemBuilder: (context, listViewIndex) {
                  final listViewAcoesSanitarioRecord =
                      listViewAcoesSanitarioRecordList[listViewIndex];
                  return _buildCard6(
                      context, listViewAcoesSanitarioRecord, listViewIndex);
                },
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget _tituloExames(BuildContext context) {
    return TituloSecao(
      titulo: 'Exames',
      identidade: IdentidadeSecao.exames,
      onVerMais: () async {
        context.pushNamed(
          PronCiosPage.routeName,
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
              widget.uidAnimaisProdutores,
              ParamType.DocumentReference,
            ),
            'grupoPredominante': serializeParam(
              widget.grupoPredominante,
              ParamType.String,
            ),
            'visitaPresencial': serializeParam(
              widget.visitaPresencial,
              ParamType.bool,
            ),
          }.withoutNulls,
        );
      },
    );
  }

  Widget _listaExames(BuildContext context) {
    return SingleChildScrollView(
      // A pagina inteira ja rola; sem isto cada secao vira sua propria
      // area de rolagem e o dedo prende dentro dela.
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Fonte única ObjectBox: ações da propriedade filtradas por animal e
          // tipo. Antes apontava para tecnico/acoesSanitario, path que deixou
          // de existir com a mudanca da colecao para a propriedade.
          StreamBuilder<List<AcaoSanitarioEntity>>(
            stream: AcaoSanitarioRepository()
                .watchByParentPath(widget.uidPropriedade?.path ?? ''),
            builder: (context, snapshot) {
              final listViewAcoesSanitarioRecordList =
                  _sanitariasDoAnimal(snapshot.data, 'Exame');
              if (listViewAcoesSanitarioRecordList.isEmpty) {
                return const SecaoVazia();
              }

              return CorpoSecao(
                  child: ListView.builder(
                padding: EdgeInsets.zero,
                primary: false,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: listViewAcoesSanitarioRecordList.length,
                itemBuilder: (context, listViewIndex) {
                  final listViewAcoesSanitarioRecord =
                      listViewAcoesSanitarioRecordList[listViewIndex];
                  return _buildCard7(
                      context, listViewAcoesSanitarioRecord, listViewIndex);
                },
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget _tituloDoencas(BuildContext context) {
    return TituloSecao(
      titulo: 'Doenças',
      identidade: IdentidadeSecao.doencas,
      onVerMais: () async {
        context.pushNamed(
          PronCiosPage.routeName,
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
              widget.uidAnimaisProdutores,
              ParamType.DocumentReference,
            ),
            'grupoPredominante': serializeParam(
              widget.grupoPredominante,
              ParamType.String,
            ),
            'visitaPresencial': serializeParam(
              widget.visitaPresencial,
              ParamType.bool,
            ),
          }.withoutNulls,
        );
      },
    );
  }

  Widget _listaDoencas(BuildContext context) {
    return SingleChildScrollView(
      // A pagina inteira ja rola; sem isto cada secao vira sua propria
      // area de rolagem e o dedo prende dentro dela.
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Fonte única ObjectBox: ações da propriedade filtradas por animal e
          // tipo. Antes apontava para tecnico/acoesSanitario, path que deixou
          // de existir com a mudanca da colecao para a propriedade.
          StreamBuilder<List<AcaoSanitarioEntity>>(
            stream: AcaoSanitarioRepository()
                .watchByParentPath(widget.uidPropriedade?.path ?? ''),
            builder: (context, snapshot) {
              final listViewAcoesSanitarioRecordList =
                  _sanitariasDoAnimal(snapshot.data, 'Doença');
              if (listViewAcoesSanitarioRecordList.isEmpty) {
                return const SecaoVazia();
              }

              return CorpoSecao(
                  child: ListView.builder(
                padding: EdgeInsets.zero,
                primary: false,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: listViewAcoesSanitarioRecordList.length,
                itemBuilder: (context, listViewIndex) {
                  final listViewAcoesSanitarioRecord =
                      listViewAcoesSanitarioRecordList[listViewIndex];
                  return _buildCard8(
                      context, listViewAcoesSanitarioRecord, listViewIndex);
                },
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget _rotuloNomeBrinco(
      BuildContext context, dynamic prontuarioAnimalAnimaisProdutoresRecord) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nome ou brinco:',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
              Text(
                () {
                  if ((prontuarioAnimalAnimaisProdutoresRecord.nomeAnimal !=
                          '') &&
                      (prontuarioAnimalAnimaisProdutoresRecord.brincoAnimal !=
                          null) &&
                      (prontuarioAnimalAnimaisProdutoresRecord.brincoAnimal !=
                          -1)) {
                    return '${prontuarioAnimalAnimaisProdutoresRecord.nomeAnimal} - ${prontuarioAnimalAnimaisProdutoresRecord.brincoAnimal.toString()}';
                  } else if (prontuarioAnimalAnimaisProdutoresRecord
                          .nomeAnimal !=
                      '') {
                    return prontuarioAnimalAnimaisProdutoresRecord.nomeAnimal;
                  } else {
                    return prontuarioAnimalAnimaisProdutoresRecord.brincoAnimal
                        .toString();
                  }
                }(),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
              Text(
                'Nascimento:',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
              Text(
                prontuarioAnimalAnimaisProdutoresRecord.dtNascimento,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tituloInfoGerais(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(15.0, 25.0, 15.0, 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppTokens.secondary, size: 20.0),
                  const SizedBox(width: 8.0),
                  Flexible(
                    child: Text(
                      'Informações gerais:',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.readexPro(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _listaInfoGerais(
      BuildContext context, dynamic prontuarioAnimalAnimaisProdutoresRecord) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      // A pagina inteira ja rola; sem isto a lista vira sua propria area de
      // rolagem e o dedo prende dentro dela.
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      children: [
        _linhaMae(context, prontuarioAnimalAnimaisProdutoresRecord),
        _linhaGrupo(context, prontuarioAnimalAnimaisProdutoresRecord),
        _linhaNumeroRegistro(context, prontuarioAnimalAnimaisProdutoresRecord),
      ],
    );
  }

  Widget _tituloReproducao(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(15.0, 25.0, 15.0, 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Reprodução:',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _listaReproducao(
      BuildContext context, dynamic prontuarioAnimalAnimaisProdutoresRecord) {
    return ListView(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      children: [
        _linhaUltimoParto(context, prontuarioAnimalAnimaisProdutoresRecord),
        _linhaTotalPartos(context, prontuarioAnimalAnimaisProdutoresRecord),
        _linhaDel(context, prontuarioAnimalAnimaisProdutoresRecord),
      ],
    );
  }

  Widget _linhaMae(
      BuildContext context, dynamic prontuarioAnimalAnimaisProdutoresRecord) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 5.0, 20.0, 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mãe:',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
              Text(
                valueOrDefault<String>(
                  prontuarioAnimalAnimaisProdutoresRecord.vaca,
                  'N/C',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pai:',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
              Text(
                valueOrDefault<String>(
                  prontuarioAnimalAnimaisProdutoresRecord.touro,
                  'N/C',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _linhaGrupo(
      BuildContext context, dynamic prontuarioAnimalAnimaisProdutoresRecord) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 5.0, 20.0, 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Grupo:',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
              Text(
                valueOrDefault<String>(
                  prontuarioAnimalAnimaisProdutoresRecord.grupoAnimal,
                  'N/C',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Raça:',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
              Text(
                valueOrDefault<String>(
                  prontuarioAnimalAnimaisProdutoresRecord.racaAnimal,
                  'N/C',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _linhaNumeroRegistro(
      BuildContext context, dynamic prontuarioAnimalAnimaisProdutoresRecord) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 5.0, 20.0, 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nº registro:',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
              Text(
                (prontuarioAnimalAnimaisProdutoresRecord.brincoAnimal !=
                            null) &&
                        (prontuarioAnimalAnimaisProdutoresRecord.brincoAnimal !=
                            -1)
                    ? prontuarioAnimalAnimaisProdutoresRecord.brincoAnimal
                        .toString()
                    : 'N/C',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status:',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
              Text(
                valueOrDefault<String>(
                  prontuarioAnimalAnimaisProdutoresRecord.status,
                  'N/C',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _linhaUltimoParto(
      BuildContext context, dynamic prontuarioAnimalAnimaisProdutoresRecord) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 5.0, 20.0, 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Último parto:',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
              Text(
                valueOrDefault<String>(
                  prontuarioAnimalAnimaisProdutoresRecord.dtUltimoParto,
                  'N/C',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Última inseminação:',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
              Text(
                valueOrDefault<String>(
                  prontuarioAnimalAnimaisProdutoresRecord.dtUltimaInseminacao,
                  'N/C',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _linhaTotalPartos(
      BuildContext context, dynamic prontuarioAnimalAnimaisProdutoresRecord) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 5.0, 20.0, 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total partos:',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
              Text(
                valueOrDefault<String>(
                  prontuarioAnimalAnimaisProdutoresRecord.totalPartos
                      .toString(),
                  'N/C',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total inseminações:',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
              Text(
                valueOrDefault<String>(
                  prontuarioAnimalAnimaisProdutoresRecord.totalInseminacoes
                      .toString(),
                  'N/C',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _linhaDel(
      BuildContext context, dynamic prontuarioAnimalAnimaisProdutoresRecord) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 5.0, 20.0, 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DEL:',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
              Text(
                prontuarioAnimalAnimaisProdutoresRecord.dtUltimoParto != ''
                    ? functions
                        .calcularDiferencaEmDias(
                            prontuarioAnimalAnimaisProdutoresRecord
                                .dtUltimoParto)
                        .toString()
                    : 'N/D',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ],
          ),
          if (prontuarioAnimalAnimaisProdutoresRecord.dtDesmame != null)
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Data desmame:',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
                Text(
                  dateTimeFormat(
                    "dd/MM/yyyy",
                    prontuarioAnimalAnimaisProdutoresRecord.dtDesmame!,
                    locale: FFLocalizations.of(context).languageCode,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FontWeight.bold,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  List<AcaoSanitarioEntity> _sanitariasDoAnimal(
      List<AcaoSanitarioEntity>? todas, String tipoAcao) {
    final caminhoAnimal = widget.uidAnimaisProdutores?.path;
    if (caminhoAnimal == null) return const [];
    final filtradas = (todas ?? const <AcaoSanitarioEntity>[])
        .where((e) =>
            !e.isDeleted &&
            e.tipoAcao == tipoAcao &&
            e.uidAnimalAnimaisProdutoresPath == caminhoAnimal)
        .toList();
    return filtradas.length > 3 ? filtradas.sublist(0, 3) : filtradas;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return StreamBuilder<AnimaisProdutoresRecord>(
      stream: AnimaisProdutoresRecord.getDocument(widget.uidAnimaisProdutores!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFF75E38),
                  ),
                ),
              ),
            ),
          );
        }

        final prontuarioAnimalAnimaisProdutoresRecord = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            appBar: PreferredSize(
              // 80 em vez de 100: o titulo ocupava so a faixa de cima e
              // sobravam ~20 de gradiente vazio antes da curva.
              preferredSize: Size.fromHeight(80.0),
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
                        _cabecalho(context),
                      ],
                    ),
                    centerTitle: true,
                    expandedTitleScale: 1.0,
                  ),
                  elevation: 0.0,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Um bloco so: os ramos online e offline eram identicos —
                  // heranca do FlutterFlow, de quando o online lia do
                  // Firestore e o offline do estado local. Hoje os dois leem
                  // do ObjectBox.
                  Container(
                    width: 500.0,
                    constraints: BoxConstraints(
                      maxWidth: 570.0,
                    ),
                    margin:
                        EdgeInsetsDirectional.fromSTEB(12.0, 10.0, 12.0, 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: AppTokens.softShadow(context),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _rotuloNomeBrinco(
                              context, prontuarioAnimalAnimaisProdutoresRecord),
                          Divider(
                            height: 2.0,
                            thickness: 1.0,
                            color: Color(0xFFE5E7EB),
                          ),
                          _tituloInfoGerais(context),
                          Divider(
                            height: 2.0,
                            thickness: 1.0,
                            color: Color(0xFFE5E7EB),
                          ),
                          _listaInfoGerais(
                              context, prontuarioAnimalAnimaisProdutoresRecord),
                          Divider(
                            height: 2.0,
                            thickness: 1.0,
                            color: Color(0xFFE5E7EB),
                          ),
                          _tituloReproducao(context),
                          Divider(
                            height: 2.0,
                            thickness: 1.0,
                            color: Color(0xFFE5E7EB),
                          ),
                          _listaReproducao(
                              context, prontuarioAnimalAnimaisProdutoresRecord),
                        ],
                      ),
                    ),
                  ),
                  _conteudo(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
