import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/core/ui/app_card.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import 'resumo_visita_atual_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReceituariosListaPage extends StatefulWidget {
  const ReceituariosListaPage({
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

  static String routeName = 'receituariosLista';
  static String routePath = '/receituariosLista';

  @override
  State<ReceituariosListaPage> createState() => _ReceituariosListaPageState();
}

class _ReceituariosListaPageState extends State<ReceituariosListaPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
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
          'Receituários',
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

  /// `resumo_da_visita` é coleção TOP-LEVEL, então a referência é reconstruída
  /// só com o `firestoreId`.
  DocumentReference? _refDoResumo(ResumoVisitaEntity e) {
    if (e.firestoreId == null) return null;
    return FirebaseFirestore.instance.doc('resumo_da_visita/${e.firestoreId}');
  }

  /// Receituário assinado: tem ao menos uma assinatura E a data de assinatura.
  /// Campos são nullable no entity, daí o `?? ''`.
  bool _assinado(ResumoVisitaEntity e) {
    final temAssinatura =
        (e.assinaturaProdutor ?? '') != '' || (e.assinaturaTecnico ?? '') != '';
    return temAssinatura && (e.dtAssinaturaFormatado ?? '') != '';
  }

  static const _meses = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];
  static const _diasSemana = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo',
  ];

  String _tituloMes(DateTime d) => '${_meses[d.month - 1]} ${d.year}';

  void _abrir(ResumoVisitaEntity resumo) {
    context.pushNamed(
      ResumoVisitaAtualPage.routeName,
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
        'uidResumoVisita': serializeParam(
          _refDoResumo(resumo),
          ParamType.DocumentReference,
        ),
        'diasDg': serializeParam(
          widget.diasDg,
          ParamType.String,
        ),
      }.withoutNulls,
    );
  }

  Widget _cabecalhoMes(BuildContext context, _Mes mes) {
    final tema = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4.0, 14.0, 4.0, 10.0),
      child: Row(
        children: [
          Text(
            mes.titulo,
            style: tema.titleSmall.override(
              font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
              color: tema.primaryText,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (mes.pendentes > 0)
            Text(
              mes.pendentes == 1 ? '1 pendente' : '${mes.pendentes} pendentes',
              style: tema.bodySmall.override(
                font: GoogleFonts.readexPro(fontWeight: FontWeight.w500),
                color: AppTokens.brand,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  /// Card de uma visita. O status vem num selo explícito — antes o card
  /// pendente era só pintado de rosa, sem dizer o que a cor significava.
  Widget _cardResumo(BuildContext context, ResumoVisitaEntity resumo) {
    final tema = FlutterFlowTheme.of(context);
    final data = resumo.dtVisita!;
    final assinado = _assinado(resumo);
    final corStatus = assinado ? AppTokens.positivo : AppTokens.brand;

    return AppCard(
      padding: const EdgeInsets.all(12.0),
      onTap: () => _abrir(resumo),
      child: Row(
        children: [
          // Bloco de calendário: o dia em destaque, o mês abreviado embaixo.
          Container(
            width: 56.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: AppTokens.brandTint,
              borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.day.toString().padLeft(2, '0'),
                  style: tema.titleLarge.override(
                    font: GoogleFonts.readexPro(fontWeight: FontWeight.w700),
                    color: AppTokens.brand,
                    fontSize: 22.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w700,
                    lineHeight: 1.0,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  _meses[data.month - 1].substring(0, 3).toUpperCase(),
                  style: tema.bodySmall.override(
                    font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                    color: AppTokens.brand,
                    fontSize: 11.0,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // A data em destaque, como no layout antigo; o dia da semana
                // fica de apoio embaixo.
                Text(
                  dateTimeFormat('dd/MM/yyyy', data,
                      locale: FFLocalizations.of(context).languageCode),
                  style: tema.bodyLarge.override(
                    font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                    color: tema.primaryText,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _diasSemana[data.weekday - 1],
                  style: tema.bodySmall.override(
                    font: GoogleFonts.readexPro(),
                    color: tema.secondaryText,
                    letterSpacing: 0.0,
                  ),
                ),
                const SizedBox(height: 6.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 3.0),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: corStatus.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        assinado
                            ? Icons.check_circle_rounded
                            : Icons.draw_rounded,
                        size: 14.0,
                        color: corStatus,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        assinado ? 'Assinado' : 'Assinatura pendente',
                        style: tema.bodySmall.override(
                          font: GoogleFonts.readexPro(
                              fontWeight: FontWeight.w600),
                          color: corStatus,
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: tema.secondaryText),
        ],
      ),
    );
  }

  Widget _vazio(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MenuIconTile(icon: Icons.receipt_long_rounded, size: 64.0),
            const SizedBox(height: 16.0),
            Text(
              'Nenhum receituário ainda',
              style: tema.titleSmall.override(
                font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                color: tema.primaryText,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Os receituários das visitas desta propriedade aparecem aqui.',
              textAlign: TextAlign.center,
              style: tema.bodySmall.override(
                font: GoogleFonts.readexPro(),
                color: tema.secondaryText,
                letterSpacing: 0.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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
                      _cabecalho(context),
                    ],
                  ),
                  centerTitle: true,
                  expandedTitleScale: 1.0,
                ),
                elevation: 0.0,
              )),
        ),
        // Fonte única ObjectBox (offline-first): permite consultar receituários
        // já emitidos sem rede. A EMISSÃO continua online, pois nasce do
        // bookkeeping de visita (ResumoDaVisita + Tratamentos + Recomendações).
        body: StreamBuilder<List<ResumoVisitaEntity>>(
          stream: ResumoVisitaRepository()
              .watchByPropriedade(widget.uidPropriedade?.path ?? ''),
          builder: (context, snapshot) {
            final resumos = (snapshot.data ?? <ResumoVisitaEntity>[])
                .where((e) => !e.isDeleted && e.dtVisita != null)
                .toList()
              ..sort((a, b) => b.dtVisita!.compareTo(a.dtVisita!));

            if (snapshot.hasData && resumos.isEmpty) {
              return _vazio(context);
            }

            // Lista achatada: cabeçalho de mês seguido das visitas dele.
            final itens = <Object>[];
            String? mesAtual;
            for (final r in resumos) {
              final mes = _tituloMes(r.dtVisita!);
              if (mes != mesAtual) {
                mesAtual = mes;
                itens.add(_Mes(
                  mes,
                  resumos
                      .where((x) =>
                          _tituloMes(x.dtVisita!) == mes && !_assinado(x))
                      .length,
                ));
              }
              itens.add(r);
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0),
              itemCount: itens.length,
              itemBuilder: (context, i) {
                final item = itens[i];
                if (item is _Mes) return _cabecalhoMes(context, item);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: _cardResumo(context, item as ResumoVisitaEntity),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// Cabeçalho de mês na lista, com quantos receituários do mês faltam assinar.
class _Mes {
  const _Mes(this.titulo, this.pendentes);
  final String titulo;
  final int pendentes;
}
