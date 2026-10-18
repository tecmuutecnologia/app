// ignore_for_file: dead_code, unnecessary_null_comparison, dead_null_aware_expression, unused_import

import '/core/ui/cabecalho_tela.dart';
import '/core/ui/painel_lista.dart';
import 'dart:async';

import '/core/connectivity/connectivity_service.dart';
import '/data/backend.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/domain/animais/classificacao_animal.dart';
import '/data/objectbox/index.dart';
import '/core/constants/grupos_racas_constantes.dart';
import '/core/ui/flutter_flow_drop_down.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/app_card.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/form_field_controller.dart';
import '/core/services/index.dart' as actions;
import '/core/ui/custom_functions.dart' as functions;
import '/features/propriedades/presentation/pages/inicio_propriedade_page.dart';
import 'package:collection/collection.dart';
import '/features/animais/application/animais_providers.dart';
import '/features/relatorios/application/categorias_do_relatorio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// Status extras fixos (antes em FFAppState.statusExtras, que nunca era
/// escrito — constante de fato). Combinados com os status vindos do Firestore
/// nas opções do dropdown de categoria.
const kStatusExtrasFixos = ['Indução de Lactação', 'Descarte'];

class ResumoRebanhoPage extends ConsumerStatefulWidget {
  const ResumoRebanhoPage({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.diasDg,
    this.empresaTecnico,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? diasDg;
  final String? empresaTecnico;

  static String routeName = 'resumoRebanho';
  static String routePath = '/resumoRebanho';

  @override
  ConsumerState<ResumoRebanhoPage> createState() => _ResumoRebanhoPageState();
}

class _ResumoRebanhoPageState extends ConsumerState<ResumoRebanhoPage> {
  List<String>? _categoriaAnimalValue;
  FormFieldController<List<String>>? _categoriaAnimalValueController;
  List<String>? _statusAnimalValue;
  FormFieldController<List<String>>? _statusAnimalValueController;

  /// Colunas do relatório, na ordem em que aparecem. O valor inicial é o
  /// mesmo dos antigos checkboxes (todas marcadas, menos "Última ação").
  final Map<String, bool> _colunas = {
    'Último parto': true,
    'Última inseminação': true,
    'DEL': true,
    'Touro': true,
    'Secagem': true,
    'Pré-parto': true,
    'Dias em aberto': true,
    'Intervalo entre partos': true,
    'Previsão de parto': true,
    'Última ação': false,
  };
  bool _coluna(String nome) => _colunas[nome] ?? false;

  String _formatoExportacao = 'PDF';

  /// Enquanto o relatório é gerado o botão fica ocupado: evita gerar dois
  /// arquivos com um toque duplo e mostra que algo está acontecendo.
  bool _gerando = false;

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

  Widget _campoGrupo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      // Grupos vêm das tabelas de referência do ObjectBox (com fallback para
      // as constantes). Antes era um StreamBuilder do Firestore, que offline
      // prendia a tela no CircularProgressIndicator.
      child: Builder(
        builder: (context) {
          final categoriaAnimalGrupoRecordList = _gruposDisponiveis;

          return FlutterFlowDropDown<String>(
            multiSelectController: _categoriaAnimalValueController ??=
                FormListFieldController<String>(
                    _categoriaAnimalValue ??= List<String>.from(
              categoriaAnimalGrupoRecordList,
            )),
            // Sempre a tabela de referência LOCAL. Antes isto era
            // `online ? repositório : constante`, invertido para o
            // offline-first: o repositório É local, e a constante podia
            // divergir da tabela real.
            options: categoriaAnimalGrupoRecordList,
            width: double.infinity,
            height: LayoutLista.alturaControle,
            searchHintTextStyle: FlutterFlowTheme.of(context)
                .labelMedium
                .override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
            searchTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
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
            textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
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
            hintText: 'Categoria animal',
            searchHintText: 'Pesquise uma categoria...',
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 24.0,
            ),
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            elevation: 2.0,
            borderColor: Colors.transparent,
            borderWidth: 1.0,
            borderRadius: LayoutLista.raio,
            margin: EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 4.0),
            hidesUnderline: true,
            isSearchable: true,
            isMultiSelect: true,
            onMultiSelectChanged: (val) =>
                safeSetState(() => _categoriaAnimalValue = val),
          );
        },
      ),
    );
  }

  Widget _campoStatus(BuildContext context) {
    return Builder(
      builder: (context) {
        // `descricao` é nullable na entity; normaliza para List<String>.
        final statusAnimalStatusAnimaisRecordList = ReferenciaRepository()
            .statusAnimais()
            .map((e) => e.descricao ?? '')
            .where((d) => d.isNotEmpty)
            .toList();

        return FlutterFlowDropDown<String>(
          multiSelectController: _statusAnimalValueController ??=
              FormListFieldController<String>(
                  _statusAnimalValue ??= List<String>.from(
            functions.combinarListas(
                    statusAnimalStatusAnimaisRecordList
                        .where((d) => d != 'Parto Induzido')
                        .toList(),
                    kStatusExtrasFixos.toList()) ??
                [],
          )),
          options: functions.combinarListas(
              statusAnimalStatusAnimaisRecordList
                  .where((d) => d != 'Parto Induzido')
                  .toList(),
              kStatusExtrasFixos.toList())!,
          width: double.infinity,
          height: LayoutLista.alturaControle,
          searchHintTextStyle: FlutterFlowTheme.of(context)
              .labelMedium
              .override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          searchTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
          textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
          hintText: 'Status',
          searchHintText: 'Pesquise um status...',
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24.0,
          ),
          fillColor: FlutterFlowTheme.of(context).primaryBackground,
          elevation: 2.0,
          borderColor: Colors.transparent,
          borderWidth: 1.0,
          borderRadius: LayoutLista.raio,
          margin: EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 4.0),
          hidesUnderline: true,
          isSearchable: true,
          isMultiSelect: true,
          onMultiSelectChanged: (val) =>
              safeSetState(() => _statusAnimalValue = val),
        );
      },
    );
  }

  /// Seção da tela: card branco com título (e ação opcional à direita).
  Widget _secao(BuildContext context,
      {required IconData icone,
      required String titulo,
      Widget? acao,
      String? ajuda,
      required List<Widget> filhos}) {
    final tema = FlutterFlowTheme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
      padding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 16.0),
      decoration: BoxDecoration(
        color: tema.secondaryBackground,
        borderRadius: BorderRadius.circular(AppTokens.radius),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icone, color: AppTokens.brand, size: 20.0),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  titulo,
                  style: GoogleFonts.readexPro(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: tema.primaryText,
                  ),
                ),
              ),
              if (acao != null) acao,
            ],
          ),
          if (ajuda != null) ...[
            const SizedBox(height: 2.0),
            Text(ajuda,
                style: GoogleFonts.readexPro(
                    fontSize: 12.0, color: tema.secondaryText)),
          ],
          const SizedBox(height: 12.0),
          ...filhos,
        ],
      ),
    );
  }

  Widget _rotuloCampo(BuildContext context, String texto) => Padding(
        padding: const EdgeInsets.only(bottom: 4.0, left: 2.0),
        child: Text(texto,
            style: GoogleFonts.readexPro(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: FlutterFlowTheme.of(context).secondaryText)),
      );

  /// Colunas como chips: um toque marca/desmarca, e todas cabem sem rolar
  /// (eram 10 linhas altas com checkbox).
  Widget _secaoColunas(BuildContext context) {
    final marcadas = _colunas.values.where((v) => v).length;
    final todas = marcadas == _colunas.length;
    return _secao(
      context,
      icone: Icons.view_column_rounded,
      titulo: 'Colunas  ·  $marcadas de ${_colunas.length}',
      acao: TextButton(
        onPressed: () => safeSetState(() {
          for (final k in _colunas.keys) {
            _colunas[k] = !todas;
          }
        }),
        style: TextButton.styleFrom(
          foregroundColor: AppTokens.brand,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          minimumSize: const Size(0, 36.0),
        ),
        child: Text(todas ? 'Limpar' : 'Marcar todas',
            style: GoogleFonts.readexPro(
                fontSize: 13.0, fontWeight: FontWeight.w600)),
      ),
      filhos: [
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            for (final nome in _colunas.keys)
              _chipOpcao(
                context,
                rotulo: nome,
                marcado: _coluna(nome),
                aoTocar: () =>
                    safeSetState(() => _colunas[nome] = !_coluna(nome)),
              ),
          ],
        ),
      ],
    );
  }

  /// Chip laranja monocromático: marcado = fundo laranja claro, texto e
  /// check laranja; desmarcado = cinza.
  Widget _chipOpcao(BuildContext context,
      {required String rotulo,
      required bool marcado,
      required VoidCallback aoTocar}) {
    final tema = FlutterFlowTheme.of(context);
    return Semantics(
      button: true,
      selected: marcado,
      child: InkWell(
        onTap: aoTocar,
        borderRadius: BorderRadius.circular(LayoutLista.raio),
        child: Container(
          height: LayoutLista.alturaChip,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: marcado ? AppTokens.brandTint : tema.primaryBackground,
            borderRadius: BorderRadius.circular(LayoutLista.raio),
            border: Border.all(
              // ignore: deprecated_member_use
              color: marcado
                  ? AppTokens.brand.withOpacity(0.5)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                marcado ? Icons.check_rounded : Icons.add_rounded,
                size: 16.0,
                color: marcado ? AppTokens.brand : tema.secondaryText,
              ),
              const SizedBox(width: 6.0),
              Text(
                rotulo,
                style: GoogleFonts.readexPro(
                  fontSize: 13.0,
                  fontWeight: marcado ? FontWeight.w600 : FontWeight.w400,
                  color: marcado ? AppTokens.brand : tema.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// PDF ou Excel com um toque (era um dropdown de duas opções).
  Widget _secaoFormato(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    Widget opcao(String formato, IconData icone) {
      final ativo = _formatoExportacao == formato;
      return Expanded(
        child: Semantics(
          button: true,
          selected: ativo,
          child: InkWell(
            onTap: () => safeSetState(() => _formatoExportacao = formato),
            borderRadius: BorderRadius.circular(LayoutLista.raio),
            child: Container(
              height: LayoutLista.alturaControle,
              decoration: BoxDecoration(
                color: ativo ? AppTokens.brandTint : tema.primaryBackground,
                borderRadius: BorderRadius.circular(LayoutLista.raio),
                border: Border.all(
                  color: ativo ? AppTokens.brand : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icone,
                      size: 18.0,
                      color: ativo ? AppTokens.brand : tema.secondaryText),
                  const SizedBox(width: 8.0),
                  Text(
                    formato,
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: ativo ? AppTokens.brand : tema.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return _secao(
      context,
      icone: Icons.file_download_outlined,
      titulo: 'Formato',
      filhos: [
        Row(
          children: [
            opcao('PDF', Icons.picture_as_pdf_rounded),
            const SizedBox(width: 8.0),
            opcao('Excel', Icons.table_chart_rounded),
          ],
        ),
      ],
    );
  }

  /// Gera o relatório com os filtros, colunas e formato escolhidos.
  Future<void> _gerarRelatorio(List<AnimalEntity> animaisDoRelatorio) async {
    if (_gerando) return;
    safeSetState(() => _gerando = true);
    try {
      // Cabeçalho do relatório (propriedade e técnico) lido do
      // ObjectBox. Antes eram três idas ao Firestore, que offline
      // não retornavam e abortavam a exportação.
      final propriedade =
          PropriedadeRepository().getByFirestoreId(widget.uidPropriedade!.id);
      final tecnico =
          TecnicoRepository().getByFirestoreId(widget.uidTecnico!.id);
      final personTecnico = tecnico?.uidPerson == null
          ? null
          : PersonRepository().getByUid(tecnico!.uidPerson!);

      // Nenhuma categoria marcada significa TODAS: antes o clique
      // morria num `if (length >= 1)` sem aviso nenhum.
      final categorias = categoriasDoRelatorio(
        _categoriaAnimalValue,
        _gruposDisponiveis,
      );

      // Verificar qual formato foi selecionado
      if (_formatoExportacao == 'Excel') {
        // Gerar Excel
        await actions.createResumoRebanhoExcel(
          animaisDoRelatorio,
          _coluna('Último parto'),
          _coluna('Última inseminação'),
          _coluna('DEL'),
          _coluna('Touro'),
          _coluna('Secagem'),
          _coluna('Pré-parto'),
          _coluna('Previsão de parto'),
          _coluna('Dias em aberto'),
          _coluna('Intervalo entre partos'),
          categorias,
          _statusAnimalValue?.toList(),
          propriedade?.displayName ?? '',
          '${propriedade?.endereco ?? ''} - ${propriedade?.cidade ?? ''}',
          personTecnico?.displayName ?? '',
          personTecnico?.phoneNumber ?? '',
          personTecnico?.email ?? '',
          personTecnico?.empresa ?? '',
          _coluna('Última ação'),
          widget.uidTecnico!,
        );
      } else {
        // Gerar PDF (padrão)
        await actions.createResumoRebanho(
          animaisDoRelatorio,
          _coluna('Último parto'),
          _coluna('Última inseminação'),
          _coluna('DEL'),
          _coluna('Touro'),
          _coluna('Secagem'),
          _coluna('Pré-parto'),
          _coluna('Previsão de parto'),
          _coluna('Dias em aberto'),
          _coluna('Intervalo entre partos'),
          categorias,
          _statusAnimalValue?.toList(),
          propriedade?.displayName ?? '',
          '${propriedade?.endereco ?? ''} - ${propriedade?.cidade ?? ''}',
          personTecnico?.displayName ?? '',
          personTecnico?.phoneNumber ?? '',
          personTecnico?.email ?? '',
          personTecnico?.empresa ?? '',
          _coluna('Última ação'),
          widget.uidTecnico!,
        );
      }
    } finally {
      safeSetState(() => _gerando = false);
    }
  }

  /// Rodapé fixo com o botão: sempre visível, sem precisar rolar até o fim.
  Widget _rodapeGerar(
      BuildContext context, List<AnimalEntity> animaisDoRelatorio) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: const [
          BoxShadow(
              color: Color(0x14000000),
              blurRadius: 16.0,
              offset: Offset(0, -4)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
      child: SafeArea(
        top: false,
        child: FFButtonWidget(
          onPressed:
              _gerando ? null : () => _gerarRelatorio(animaisDoRelatorio),
          text: _gerando
              ? 'Gerando relatório...'
              : 'Gerar relatório em $_formatoExportacao',
          icon: _gerando
              ? const SizedBox(
                  width: 16.0,
                  height: 16.0,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.0, color: Colors.white),
                )
              : Icon(
                  _formatoExportacao == 'Excel'
                      ? Icons.table_chart_rounded
                      : Icons.picture_as_pdf_rounded,
                  size: 18.0,
                ),
          options: FFButtonOptions(
            width: double.infinity,
            height: 48.0,
            padding: EdgeInsets.zero,
            iconPadding: EdgeInsets.zero,
            color: AppTokens.brand,
            textStyle: GoogleFonts.readexPro(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
            elevation: 0.0,
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(LayoutLista.raio),
            // Gerando: continua laranja (mais claro), não vira "desabilitado".
            // ignore: deprecated_member_use
            disabledColor: AppTokens.brand.withOpacity(0.7),
            disabledTextColor: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Grupos que o relatório oferece (tabela de referência local, sem sêmens).
  List<String> get _gruposDisponiveis =>
      ReferenciaRepository().grupos().where((d) => !ehSemens(d)).toList();

  @override
  Widget build(BuildContext context) {
    // context.watch<FFAppState>();

    // Lista REATIVA do ObjectBox: era uma leitura única dentro de um `Builder`,
    // então animal que chegasse pela escuta em tempo real (ou cadastrado em
    // outra tela) só entrava no relatório depois de sair e voltar. Entrega as
    // ENTIDADES: a exportação não precisa mais de `DocumentReference`, e é isso
    // que faz o animal criado offline aparecer.
    final animaisAsync = ref
        .watch(animaisByPropriedadeProvider(widget.uidPropriedade?.path ?? ''));

    return animaisAsync.when(
      loading: () => Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: const Center(child: Text('Erro ao carregar os animais.')),
      ),
      data: (animaisDoRelatorio) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: const CabecalhoTela(titulo: 'Resumo do rebanho'),
            bottomNavigationBar: _rodapeGerar(context, animaisDoRelatorio),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 16.0),
              children: [
                _secao(
                  context,
                  icone: Icons.tune_rounded,
                  titulo: 'Animais do relatório',
                  ajuda: 'Deixe vazio para incluir todos.',
                  filhos: [
                    // Rótulo próprio: com tudo selecionado o dropdown mostra a
                    // lista de valores e o hint some — não dava para saber
                    // qual campo era qual.
                    _rotuloCampo(context, 'Categorias'),
                    _campoGrupo(context),
                    const SizedBox(height: 10.0),
                    _rotuloCampo(context, 'Status'),
                    _campoStatus(context),
                  ],
                ),
                _secaoColunas(context),
                _secaoFormato(context),
              ],
            ),
          ),
        );
      },
    );
  }
}
