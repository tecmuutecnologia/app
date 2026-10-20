// ignore_for_file: dead_code

import '/core/ui/cabecalho_tela.dart';
import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/util/preenchido.dart';
import '../../application/cabecalho_receituario.dart';
import '../../application/tem_assinatura.dart';
import '/core/ui/app_button.dart';
import '/core/ui/app_card.dart';
import '../widgets/assinatura_produtor_widget.dart';
import '../widgets/assinatura_imagem.dart';
import '../widgets/assinatura_tecnico_widget.dart';
import '../widgets/lista_animais_tratamentos_widget.dart';
import '../widgets/lista_diagnostico_gestacao_widget.dart';
import 'receituarios_lista_page.dart';
import '/core/services/index.dart' as actions;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ResumoVisitaAtualPage extends StatefulWidget {
  const ResumoVisitaAtualPage({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.uidResumoVisita,
    required this.diasDg,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final DocumentReference? uidResumoVisita;
  final String? diasDg;

  static String routeName = 'resumoVisitaAtual';
  static String routePath = '/resumoVisitaAtual';

  @override
  State<ResumoVisitaAtualPage> createState() => _ResumoVisitaAtualPageState();
}

class _ResumoVisitaAtualPageState extends State<ResumoVisitaAtualPage> {
  FocusNode? _obsGeralFocusNode;
  TextEditingController? _obsGeralTextController;
  final String? Function(BuildContext, String?)?
      _obsGeralTextControllerValidator = null;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _obsGeralTextController ??= TextEditingController();
    _obsGeralFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _obsGeralFocusNode?.dispose();
    _obsGeralTextController?.dispose();

    super.dispose();
  }

  /// Volta para a lista de receituários.
  ///
  /// A lista abre o resumo com `pushNamed`, então voltar é `pop`. Antes era
  /// `goNamed`, que troca a pilha inteira: a lista virava a única tela, o
  /// início da propriedade sumia de baixo dela e o voltar da lista caía no
  /// dashboard do técnico — e era preciso iniciar a visita e achar a
  /// propriedade de novo. O `goNamed` fica só para quando não há para onde
  /// voltar (resumo aberto direto por link).
  void _voltarParaReceituarios() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.goNamed(
      ReceituariosListaPage.routeName,
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

  Widget _listaRecomendacoes(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
      // Recomendações do ObjectBox, ligadas pelo CAMPO uidResumoDaVisita.
      child: Builder(
        builder: (context) {
          final listViewRecomendacoesRecordList = RecomendacaoRepository()
              .getDaVisita('resumo_da_visita/${widget.uidResumoVisita?.id}');

          return ListView.builder(
            padding: EdgeInsets.zero,
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: listViewRecomendacoesRecordList.length,
            itemBuilder: (context, listViewIndex) {
              final listViewRecomendacoesRecord =
                  listViewRecomendacoesRecordList[listViewIndex];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: AppCard(
                  padding: const EdgeInsets.fromLTRB(12.0, 14.0, 12.0, 4.0),
                  child: ListaAnimaisTratamentosWidget(
                    key: Key(
                        'Keydky_${listViewIndex}_of_${listViewRecomendacoesRecordList.length}'),
                    parameter1: listViewRecomendacoesRecord.tituloRecomendacao,
                    parameter2: widget.uidResumoVisita!,
                    obsRecomendacao:
                        listViewRecomendacoesRecord.descricaoRecomendacao,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _conteudo(BuildContext context,
      ResumoVisitaEntity resumoVisitaAtualResumoDaVisitaRecord) {
    return // Lista de Diagnóstico de Gestação
        Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: ListaDiagnosticoGestacaoWidget(
        uidResumoVisita: widget.uidResumoVisita!,
        uidTecnico: widget.uidTecnico!,
        uidPropriedade: widget.uidPropriedade!,
        dtVisita: resumoVisitaAtualResumoDaVisitaRecord.dtVisita!,
      ),
    );
  }

  Widget _botaoAdicionarRecomendacao(BuildContext context,
      ResumoVisitaEntity resumoVisitaAtualResumoDaVisitaRecord) {
    return Expanded(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Cada assinatura fica disponível enquanto faltar, mesmo com a
            // visita concluída: dá para concluir com uma só e colher a outra
            // depois. O "Gerar PDF" monta o arquivo com o que houver na hora.
            if (!preenchido(
                resumoVisitaAtualResumoDaVisitaRecord.assinaturaProdutor))
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: AppButton(
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
                            child: AssinaturaProdutorWidget(
                              uidResumoVisita: widget.uidResumoVisita!,
                            ),
                          ),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  },
                  text: 'Assinatura do produtor',
                  icon: Icons.draw_rounded,
                  tipo: AppButtonTipo.secundario,
                ),
              ),
            if (!preenchido(
                resumoVisitaAtualResumoDaVisitaRecord.assinaturaTecnico))
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: AppButton(
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
                            child: AssinaturaTecnicoWidget(
                              uidResumoVisita: widget.uidResumoVisita!,
                            ),
                          ),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  },
                  text: 'Assinatura do técnico',
                  icon: Icons.draw_rounded,
                  tipo: AppButtonTipo.secundario,
                ),
              ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _secaoObservacoes(BuildContext context,
      ResumoVisitaEntity resumoVisitaAtualResumoDaVisitaRecord) {
    return Expanded(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 10.0, 16.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tituloObservacoes(context),
            _campoObservacoes(context),
            // Ação principal primeiro; "Apenas salvar" é a alternativa.
            _botaoConcluirVisita2(
                context, resumoVisitaAtualResumoDaVisitaRecord),
            _botaoConcluirVisita(
                context, resumoVisitaAtualResumoDaVisitaRecord),
          ],
        ),
      ),
    );
  }

  Widget _tituloObservacoes(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.notes_rounded, color: AppTokens.secondary, size: 20.0),
        const SizedBox(width: 8.0),
        Flexible(
          child: Text(
            'Observações gerais:',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
          ),
        ),
      ],
    );
  }

  Widget _campoObservacoes(BuildContext context) {
    return TextFormField(
      controller: _obsGeralTextController,
      focusNode: _obsGeralFocusNode,
      autofocus: false,
      obscureText: false,
      decoration: InputDecoration(
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
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTokens.secondary,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        // Branco: o fundo da página agora é o cinza do app.
        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
        contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
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
      maxLines: 3,
      maxLength: 100,
      maxLengthEnforcement: MaxLengthEnforcement.none,
      buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) =>
          null,
      cursorColor: FlutterFlowTheme.of(context).primary,
      validator: _obsGeralTextControllerValidator.asValidator(context),
    );
  }

  Widget _botaoConcluirVisita(BuildContext context,
      ResumoVisitaEntity resumoVisitaAtualResumoDaVisitaRecord) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 16.0),
      child: AppButton(
        onPressed: () async {
          if ((preenchido(
                  resumoVisitaAtualResumoDaVisitaRecord.assinaturaProdutor)) ||
              (preenchido(
                  resumoVisitaAtualResumoDaVisitaRecord.assinaturaTecnico))) {
            await _assinarOfflineFirst();
            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text('Visita concluída!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(alertDialogContext),
                      child: Text('Ok'),
                    ),
                  ],
                );
              },
            );

            _voltarParaReceituarios();

            return;
          } else {
            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text('Assinatura(s) pendente(s)!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(alertDialogContext),
                      child: Text('Ok'),
                    ),
                  ],
                );
              },
            );
            return;
          }
        },
        text: 'Apenas salvar',
        icon: Icons.check_rounded,
        tipo: AppButtonTipo.secundario,
      ),
    );
  }

  Widget _botaoConcluirVisita2(BuildContext context,
      ResumoVisitaEntity resumoVisitaAtualResumoDaVisitaRecord) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
      child: AppButton(
        onPressed: () async {
          var _shouldSetState = false;
          if ((preenchido(
                  resumoVisitaAtualResumoDaVisitaRecord.assinaturaProdutor)) ||
              (preenchido(
                  resumoVisitaAtualResumoDaVisitaRecord.assinaturaTecnico))) {
            _shouldSetState = true;

            await _assinarOfflineFirst();
            // Fica no resumo: a tela observa o ObjectBox e, com a visita
            // concluída, troca sozinha este botão pelo "Gerar PDF". Antes ela
            // voltava para a lista e só depois o PDF abria, por cima dela.
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Visita concluída. Gerando o PDF…')),
              );
            }

            await _gerarReceituario(() => _gerarPdf(
                resumoVisitaAtualResumoDaVisitaRecord.dtVisitaFormatado ?? ''));
            if (_shouldSetState) safeSetState(() {});
            return;
          } else {
            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text('Assinatura(s) pendente(s)!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(alertDialogContext),
                      child: Text('Ok'),
                    ),
                  ],
                );
              },
            );
            if (_shouldSetState) safeSetState(() {});
            return;
          }
        },
        text: 'Salvar e gerar PDF',
        icon: Icons.picture_as_pdf_rounded,
      ),
    );
  }

  /// Gera o receituário avisando na tela quando falha.
  ///
  /// A ação engolia a exceção (`catch` com `print`), então um clique que dava
  /// erro — um cast de data quebrado, por exemplo — não fazia nada e não dizia
  /// nada. Agora ela propaga e quem chama mostra o motivo.
  Future<void> _gerarReceituario(Future<void> Function() gerar) async {
    try {
      await gerar();
    } catch (e) {
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Não foi possível gerar o PDF'),
          content: Text('$e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    }
  }

  /// Gera o receituário com o cabeçalho lido do aparelho
  /// (ver [carregarCabecalhoReceituario]).
  Future<void> _gerarPdf(String dtVisitaFormatado) async {
    final cronometro = Stopwatch()..start();
    final cab = await carregarCabecalhoReceituario(
      uidPropriedade: widget.uidPropriedade!,
      uidTecnico: widget.uidTecnico!,
    );
    debugPrint('🧾 Cabeçalho em ${cronometro.elapsedMilliseconds}ms');
    await actions.createReceituario(
      widget.uidResumoVisita!,
      cab.nomeProdutor,
      cab.enderecoProdutor,
      cab.nomeTecnico,
      cab.telefoneTecnico,
      dtVisitaFormatado,
      cab.emailTecnico,
      cab.empresaTecnico,
    );
  }

  Widget _botaoGerarPdf(BuildContext context,
      ResumoVisitaEntity resumoVisitaAtualResumoDaVisitaRecord) {
    return Expanded(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
              child: AppButton(
                onPressed: () async {
                  await _gerarReceituario(() => _gerarPdf(
                      resumoVisitaAtualResumoDaVisitaRecord.dtVisitaFormatado ??
                          ''));

                  safeSetState(() {});
                },
                text: 'Gerar PDF',
                icon: Icons.picture_as_pdf_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Registra a assinatura no ObjectBox e deixa o sync subir. Antes era um
  /// `update` direto no Firestore, que offline não concluía.
  Future<void> _assinarOfflineFirst() async {
    final repo = ResumoVisitaRepository();
    final resumo = repo
        .getByPropriedade(widget.uidPropriedade?.path ?? '')
        .where((e) => e.firestoreId == widget.uidResumoVisita?.id)
        .firstOrNull;
    if (resumo == null) return;

    resumo.dtAssinatura = DateTime.now();
    resumo.dtAssinaturaFormatado = dateTimeFormat(
      "dd/MM/yyyy",
      getCurrentTimestamp,
      locale: FFLocalizations.of(context).languageCode,
    );
    resumo.obsGeralVisita = _obsGeralTextController.text;
    await repo.save(resumo);
  }

  @override
  Widget build(BuildContext context) {
    // Fonte única ObjectBox (offline-first): abrir e assinar o receituário
    // deixa de exigir rede.
    return StreamBuilder<List<ResumoVisitaEntity>>(
      stream: ResumoVisitaRepository()
          .watchByPropriedade(widget.uidPropriedade?.path ?? ''),
      builder: (context, snapshot) {
        final resumoVisitaAtualResumoDaVisitaRecord = (snapshot.data ??
                ResumoVisitaRepository()
                    .getByPropriedade(widget.uidPropriedade?.path ?? ''))
            .where((e) =>
                !e.isDeleted && e.firestoreId == widget.uidResumoVisita?.id)
            .firstOrNull;

        if (resumoVisitaAtualResumoDaVisitaRecord == null) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            body: Center(
              child: Text(
                'Receituário não encontrado.',
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: CabecalhoTela(
              titulo:
                  'Visita ${resumoVisitaAtualResumoDaVisitaRecord.dtVisitaFormatado}',
              aoVoltar: _voltarParaReceituarios,
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _listaRecomendacoes(context),
                  _conteudo(context, resumoVisitaAtualResumoDaVisitaRecord),
                  if ((preenchido(resumoVisitaAtualResumoDaVisitaRecord
                          .assinaturaProdutor)) ||
                      (preenchido(resumoVisitaAtualResumoDaVisitaRecord
                          .assinaturaTecnico)))
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                      child: AppCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (preenchido(resumoVisitaAtualResumoDaVisitaRecord
                                .dtAssinaturaFormatado))
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 4.0, 0.0, 0.0),
                                child: Text(
                                  'Visita concluída e assinada em:',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        color: Color(0xFF606A85),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            if (preenchido(resumoVisitaAtualResumoDaVisitaRecord
                                .dtAssinaturaFormatado))
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 4.0, 0.0, 12.0),
                                child: Text(
                                  resumoVisitaAtualResumoDaVisitaRecord
                                          .dtAssinaturaFormatado ??
                                      '',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        color: Color(0xFF606A85),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic,
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                              ),
                            if (temAssinatura(
                                resumoVisitaAtualResumoDaVisitaRecord
                                    .assinaturaTecnico))
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 4.0, 0.0, 0.0),
                                child: Text(
                                  'Assinatura Técnico:',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        color: Color(0xFF606A85),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            if (temAssinatura(
                                resumoVisitaAtualResumoDaVisitaRecord
                                    .assinaturaTecnico))
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: AssinaturaImagem(
                                    resumoVisitaAtualResumoDaVisitaRecord
                                            .assinaturaTecnico ??
                                        '',
                                    width: 250.0,
                                    height: 80.0,
                                  ),
                                ),
                              ),
                            if (temAssinatura(
                                resumoVisitaAtualResumoDaVisitaRecord
                                    .assinaturaProdutor))
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 4.0, 0.0, 0.0),
                                child: Text(
                                  'Assinatura Produtor:',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        color: Color(0xFF606A85),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            if (temAssinatura(
                                resumoVisitaAtualResumoDaVisitaRecord
                                    .assinaturaProdutor))
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: AssinaturaImagem(
                                    resumoVisitaAtualResumoDaVisitaRecord
                                            .assinaturaProdutor ??
                                        '',
                                    width: 250.0,
                                    height: 80.0,
                                  ),
                                ),
                              ),
                            if (preenchido(resumoVisitaAtualResumoDaVisitaRecord
                                .obsGeralVisita))
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 10.0, 0.0, 0.0),
                                child: Text(
                                  'Observação geral visita:',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        color: Color(0xFF606A85),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            if (preenchido(resumoVisitaAtualResumoDaVisitaRecord
                                .obsGeralVisita))
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 4.0, 0.0, 12.0),
                                child: Text(
                                  resumoVisitaAtualResumoDaVisitaRecord
                                          .obsGeralVisita ??
                                      '',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        color: Color(0xFF606A85),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic,
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  if ((!preenchido(resumoVisitaAtualResumoDaVisitaRecord
                          .assinaturaProdutor)) ||
                      (!preenchido(resumoVisitaAtualResumoDaVisitaRecord
                          .assinaturaTecnico)))
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _botaoAdicionarRecomendacao(
                            context, resumoVisitaAtualResumoDaVisitaRecord),
                      ],
                    ),
                  if (((preenchido(resumoVisitaAtualResumoDaVisitaRecord
                              .assinaturaProdutor)) ||
                          (preenchido(resumoVisitaAtualResumoDaVisitaRecord
                              .assinaturaTecnico))) &&
                      // Concluída = tem data de assinatura. "Observações
                      // gerais" é opcional: usá-la como marcador escondia o
                      // "Gerar PDF" de toda visita concluída sem observação.
                      (!preenchido(resumoVisitaAtualResumoDaVisitaRecord
                          .dtAssinaturaFormatado)))
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _secaoObservacoes(
                            context, resumoVisitaAtualResumoDaVisitaRecord),
                      ],
                    ),
                  if (((preenchido(resumoVisitaAtualResumoDaVisitaRecord
                              .assinaturaProdutor)) ||
                          (preenchido(resumoVisitaAtualResumoDaVisitaRecord
                              .assinaturaTecnico))) &&
                      (preenchido(resumoVisitaAtualResumoDaVisitaRecord
                          .dtAssinaturaFormatado)))
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _botaoGerarPdf(
                            context, resumoVisitaAtualResumoDaVisitaRecord),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
