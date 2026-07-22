import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/domain/animais/classificacao_animal.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/core/ui/app_card.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/custom_functions.dart' as functions;
import '/features/propriedades/presentation/pages/inicio_propriedade_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Uma fatia de uma composição parte-todo: rótulo, valor e cor.
///
/// A cor acompanha a CATEGORIA, nunca a posição na lista. A versão anterior
/// derivava as cores da ordem de uma lista que já vinha com os zeros removidos
/// (`retornaContagemGrupos`), enquanto a legenda usava rótulos fixos — bastava
/// um grupo zerado para legenda e fatias se desalinharem.
class _Fatia {
  const _Fatia(this.rotulo, this.valor, this.cor);
  final String rotulo;
  final int valor;
  final Color cor;
}

/// Um número-síntese do painel.
class _Indicador {
  const _Indicador(this.rotulo, this.valor, {this.sufixo});
  final String rotulo;
  final String valor;
  final String? sufixo;
}

class IndicesZootecnicosPage extends StatefulWidget {
  const IndicesZootecnicosPage({
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

  static String routeName = 'indicesZootecnicos';
  static String routePath = '/indicesZootecnicos';

  @override
  State<IndicesZootecnicosPage> createState() => _IndicesZootecnicosPageState();
}

class _IndicesZootecnicosPageState extends State<IndicesZootecnicosPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// Paleta categórica validada (banda de luminosidade, piso de croma,
  /// separação para daltonismo e piso de visão normal). Atribuída em ordem
  /// FIXA — uma categoria mantém sua cor mesmo que outra zere.
  static const _paleta = <Color>[
    Color(0xFF2A78D6), // azul
    Color(0xFFEB6834), // laranja
    Color(0xFF1BAF7A), // água
    Color(0xFFEDA100), // amarelo
    Color(0xFFE87BA4), // magenta
    Color(0xFF008300), // verde
  ];

  List<AnimaisProdutoresStruct> get _animais {
    if (!ObjectBoxService.isInitialized || widget.uidPropriedade == null) {
      return const [];
    }
    return AnimalRepository()
        .getAnimaisByPropriedade(widget.uidPropriedade!.path)
        .where((a) => !a.isDeleted)
        .map(animalEntityToStruct)
        .toList();
  }

  /// Último relatório financeiro da propriedade — fonte dos dois indicadores
  /// econômicos.
  FinanceiroEntity? get _financeiro {
    if (!ObjectBoxService.isInitialized || widget.uidPropriedade == null) {
      return null;
    }
    final lista = FinanceiroRepository()
        .getByParentPath(widget.uidPropriedade!.path)
        .where((e) => !e.isDeleted)
        .toList()
      ..sort((a, b) => (b.dtRelatorio ?? '').compareTo(a.dtRelatorio ?? ''));
    return lista.isEmpty ? null : lista.first;
  }

  @override
  Widget build(BuildContext context) {
    final semSemens = _animais.where((a) => !ehSemens(a.grupoAnimal)).toList();
    final fin = _financeiro;

    final paraDiasAberto = semSemens
        .where((a) => a.dtUltimaInseminacao != '' && a.dtUltimoParto != '')
        .toList();
    final paraIntervalo = semSemens
        .where(
            (a) => a.dtUltimoPartoContingencia != '' && a.dtPartoPrevisto != '')
        .toList();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: _appBar(context),
        body: SafeArea(
          top: true,
          child: ListView(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 32),
            children: [
              // Números-síntese primeiro: são a leitura de relance da tela.
              _gradeIndicadores(context, [
                _Indicador('Animais ativos', '${semSemens.length}'),
                _Indicador('Vacas em lactação',
                    '${semSemens.where((a) => ehVaca(a.grupoAnimal)).length}'),
                _Indicador(
                  'Dias em aberto',
                  valueOrDefault<String>(
                    functions
                        .calcularIntervaloMedio(
                          paraDiasAberto.map((e) => e.dtUltimoParto).toList(),
                          paraDiasAberto
                              .map((e) => e.dtUltimaInseminacao)
                              .toList(),
                        )
                        ?.toString(),
                    '0',
                  ),
                  sufixo: 'dias',
                ),
                _Indicador(
                  'Intervalo entre partos',
                  valueOrDefault<String>(
                    functions
                        .mediaDiasEntreDatas(
                          paraIntervalo
                              .map((e) => e.dtUltimoPartoContingencia)
                              .toList(),
                          paraIntervalo.map((e) => e.dtPartoPrevisto).toList(),
                        )
                        ?.toString(),
                    '0',
                  ),
                  sufixo: 'dias',
                ),
                _Indicador(
                  'Média produção animal',
                  (fin?.mediaProducaoVaca ?? '').isEmpty
                      ? '—'
                      : fin!.mediaProducaoVaca!,
                  sufixo: 'L',
                ),
                _Indicador(
                  'Custo litro leite',
                  (fin?.custoLitroLeite ?? '').isEmpty
                      ? '—'
                      : fin!.custoLitroLeite!,
                ),
              ]),
              const SizedBox(height: 24),
              _composicao(
                context,
                titulo: 'Categorias',
                subtitulo: 'Composição do rebanho por grupo',
                fatias: _porCategoria(semSemens),
              ),
              const SizedBox(height: 16),
              _composicao(
                context,
                titulo: 'Reprodução',
                subtitulo: 'Situação reprodutiva do rebanho',
                fatias: _porReproducao(semSemens),
              ),
              const SizedBox(height: 16),
              _composicao(
                context,
                titulo: 'Rebanho produtivo',
                subtitulo: 'Fase produtiva das fêmeas',
                fatias: _porFaseProdutiva(semSemens),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Composições (parte-todo)
  // ---------------------------------------------------------------------------

  List<_Fatia> _porCategoria(List<AnimaisProdutoresStruct> animais) {
    const grupos = ['Vacas', 'Novilhas', 'Bezerras', 'Bezerros', 'Touros'];
    return [
      for (var i = 0; i < grupos.length; i++)
        _Fatia(
          grupos[i],
          animais.where((a) => a.grupoAnimal == grupos[i]).length,
          _paleta[i],
        ),
    ];
  }

  /// "Prenha" agrupa Inseminada PP, Prenha, Seca e Pré Parto — mesma regra da
  /// `retornaReproducaoQuantidade` original.
  List<_Fatia> _porReproducao(List<AnimaisProdutoresStruct> animais) {
    const prenha = {'Inseminada PP', 'Prenha', 'Seca', 'Pré Parto'};
    var vazia = 0, inseminada = 0, gestante = 0;
    for (final a in animais) {
      if (prenha.contains(a.status)) {
        gestante++;
      } else if (a.status == 'Vazia') {
        vazia++;
      } else if (a.status == 'Inseminada') {
        inseminada++;
      }
    }
    return [
      _Fatia('Vazia', vazia, _paleta[0]),
      _Fatia('Inseminada', inseminada, _paleta[1]),
      _Fatia('Prenha', gestante, _paleta[2]),
    ];
  }

  /// "Lactação" agrupa Vazia, Inseminada, Inseminada PP e Prenha — mesma regra
  /// da `retornaRebanhoProdutivoId` original.
  List<_Fatia> _porFaseProdutiva(List<AnimaisProdutoresStruct> animais) {
    const lactacao = {'Vazia', 'Inseminada', 'Inseminada PP', 'Prenha'};
    var emLactacao = 0, secas = 0, prePartos = 0;
    for (final a in animais) {
      if (lactacao.contains(a.status)) {
        emLactacao++;
      } else if (a.status == 'Seca') {
        secas++;
      } else if (a.status == 'Pré Parto') {
        prePartos++;
      }
    }
    return [
      _Fatia('Lactação', emLactacao, _paleta[0]),
      _Fatia('Seca', secas, _paleta[1]),
      _Fatia('Pré Parto', prePartos, _paleta[2]),
    ];
  }

  // ---------------------------------------------------------------------------
  // Blocos visuais
  // ---------------------------------------------------------------------------

  /// Grade que se adapta à largura: 2 colunas no celular, 3 em telas maiores.
  ///
  /// Antes eram duas `Row` de três cartões de 120px FIXOS — 360px mais
  /// espaçamentos, que estouravam a largura em qualquer celular comum. Era a
  /// origem do layout quebrado.
  Widget _gradeIndicadores(BuildContext context, List<_Indicador> itens) {
    return LayoutBuilder(
      builder: (context, c) {
        final colunas = c.maxWidth >= 560 ? 3 : 2;
        const espaco = 12.0;
        final largura = (c.maxWidth - espaco * (colunas - 1)) / colunas;
        return Wrap(
          spacing: espaco,
          runSpacing: espaco,
          children: [
            for (final i in itens)
              SizedBox(width: largura, child: _tileIndicador(context, i)),
          ],
        );
      },
    );
  }

  /// Stat tile: rótulo pequeno em cima, número grande embaixo. O número É o
  /// dado — não precisa de gráfico em volta.
  Widget _tileIndicador(BuildContext context, _Indicador i) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(AppTokens.radius),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            child: Text(
              i.rotulo,
              maxLines: 2,
              style: FlutterFlowTheme.of(context).labelSmall.override(
                    font: GoogleFonts.readexPro(),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 11.0,
                    letterSpacing: 0.0,
                  ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    i.valor,
                    maxLines: 1,
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          font: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 26.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
              if (i.sufixo != null) ...[
                const SizedBox(width: 4),
                Text(
                  i.sufixo!,
                  style: FlutterFlowTheme.of(context).labelSmall.override(
                        font: GoogleFonts.readexPro(),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 11.0,
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// Composição parte-todo como barra empilhada horizontal + legenda com valor
  /// e percentual.
  ///
  /// Substitui os gráficos de pizza. Com rótulos longos ("Bezerras",
  /// "Inseminada", "Pré Parto") e leitura em celular, a barra horizontal é mais
  /// legível: as fatias ficam alinhadas e comparáveis, e a legenda traz o
  /// número — então a identidade nunca depende só da cor.
  Widget _composicao(
    BuildContext context, {
    required String titulo,
    required String subtitulo,
    required List<_Fatia> fatias,
  }) {
    final visiveis = fatias.where((f) => f.valor > 0).toList();
    final total = visiveis.fold<int>(0, (s, f) => s + f.valor);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(AppTokens.radius),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            font: GoogleFonts.readexPro(
                                fontWeight: FontWeight.w600),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitulo,
                      style: FlutterFlowTheme.of(context).labelSmall.override(
                            font: GoogleFonts.readexPro(),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 11.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                '$total',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      font: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 22.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (total == 0)
            Text(
              'Sem animais nesta composição.',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.readexPro(),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            )
          else ...[
            _barraEmpilhada(context, visiveis),
            const SizedBox(height: 14),
            for (final f in visiveis) _linhaLegenda(context, f, total),
          ],
        ],
      ),
    );
  }

  /// Barra fina, cantos arredondados nas pontas e 2px de respiro entre as
  /// fatias — o vão usa a cor da superfície, não uma borda.
  Widget _barraEmpilhada(BuildContext context, List<_Fatia> fatias) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 10,
        child: Row(
          children: [
            for (var i = 0; i < fatias.length; i++) ...[
              if (i > 0) const SizedBox(width: 2),
              Expanded(
                flex: fatias[i].valor,
                child: Container(color: fatias[i].cor),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Legenda: marcador na cor da série + rótulo, com valor e percentual à
  /// direita. O texto usa tokens de tinta, nunca a cor da série.
  Widget _linhaLegenda(BuildContext context, _Fatia f, int total) {
    final pct = total == 0 ? 0 : (f.valor * 100 / total).round();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: f.cor,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              f.rotulo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.readexPro(),
                    letterSpacing: 0.0,
                  ),
            ),
          ),
          Text(
            '${f.valor}',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 42,
            child: Text(
              '$pct%',
              textAlign: TextAlign.end,
              style: FlutterFlowTheme.of(context).labelSmall.override(
                    font: GoogleFonts.readexPro(),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 11.0,
                    letterSpacing: 0.0,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
      child: AppBar(
        backgroundColor: const Color(0xFFF75E38),
        automaticallyImplyLeading: false,
        actions: const [],
        flexibleSpace: FlexibleSpaceBar(
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                child: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30.0,
                  borderWidth: 1.0,
                  buttonSize: 50.0,
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () async {
                    context.pushNamed(
                      InicioPropriedadePage.routeName,
                      queryParameters: {
                        'nomePropriedade': serializeParam(
                          widget.nomePropriedade,
                          ParamType.String,
                        ),
                        'uidPropriedade': serializeParam(
                          widget.uidPropriedade,
                          ParamType.DocumentReference,
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
                  },
                ),
              ),
              Expanded(
                child: Text(
                  'Índices zootécnicos',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        font: GoogleFonts.outfit(),
                        color: Colors.white,
                        fontSize: 22.0,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
            ],
          ),
          centerTitle: true,
          expandedTitleScale: 1.0,
        ),
        elevation: 0.0,
      ),
    );
  }
}
