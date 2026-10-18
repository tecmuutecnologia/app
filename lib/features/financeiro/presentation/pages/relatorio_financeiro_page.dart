import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/core/ui/app_card.dart';
import '/core/ui/cabecalho_tela.dart';
import '/core/ui/card_animal_lista.dart';
import '/core/ui/painel_lista.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/features/financeiro/presentation/pages/editar_relatorio_financeiro_page.dart';
import '/features/financeiro/presentation/pages/novo_relatorio_financeiro_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RelatorioFinanceiroPage extends StatefulWidget {
  const RelatorioFinanceiroPage({
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

  static String routeName = 'relatorioFinanceiro';
  static String routePath = '/relatorioFinanceiro';

  @override
  State<RelatorioFinanceiroPage> createState() =>
      _RelatorioFinanceiroPageState();
}

class _RelatorioFinanceiroPageState extends State<RelatorioFinanceiroPage> {
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

  static const _meses = [
    'jan',
    'fev',
    'mar',
    'abr',
    'mai',
    'jun',
    'jul',
    'ago',
    'set',
    'out',
    'nov',
    'dez',
  ];

  /// `dtRelatorio` é texto `dd/MM/yyyy`. Ordenar o TEXTO punha o dia na
  /// frente do mês e do ano: 30/01 vinha antes de 15/10.
  static DateTime? _data(String? texto) {
    final p = (texto ?? '').split('/');
    if (p.length != 3) return null;
    final d = int.tryParse(p[0]),
        m = int.tryParse(p[1]),
        a = int.tryParse(p[2]);
    if (d == null || m == null || a == null) return null;
    return DateTime(a, m, d);
  }

  void _abrir(FinanceiroEntity relatorio) {
    context.pushNamed(
      EditarRelatorioFinanceiroPage.routeName,
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
        'financeiroLocalId': serializeParam(
          relatorio.id,
          ParamType.int,
        ),
      }.withoutNulls,
    );
  }

  /// Card no desenho dos Receituários: bloco de data à esquerda e, ao lado,
  /// o resumo do mês (recebido, líquido e custo por litro).
  Widget _cardRelatorio(BuildContext context, FinanceiroEntity relatorio) {
    final tema = FlutterFlowTheme.of(context);
    final data = _data(relatorio.dtRelatorio);
    final litros = relatorio.litrosLeiteMes;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
      child: AppCard(
        padding: const EdgeInsets.all(12.0),
        onTap: () => _abrir(relatorio),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
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
                        data == null ? '--' : '${data.day}'.padLeft(2, '0'),
                        style: GoogleFonts.readexPro(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w700,
                            color: AppTokens.brand,
                            height: 1.0),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        data == null
                            ? ''
                            : _meses[data.month - 1].toUpperCase(),
                        style: GoogleFonts.readexPro(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            color: AppTokens.brand),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        relatorio.dtRelatorio ?? '',
                        style: GoogleFonts.readexPro(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: tema.primaryText),
                      ),
                      Text(
                        litros > 0
                            ? '${formatNumber(litros, formatType: FormatType.decimal, decimalType: DecimalType.commaDecimal)} L de leite no mês'
                            : 'Produção não informada',
                        style: GoogleFonts.readexPro(
                            fontSize: 12.0, color: tema.secondaryText),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: tema.secondaryText),
              ],
            ),
            const SizedBox(height: 12.0),
            FaixaInfoAnimal(tiles: [
              InfoAnimal('Recebido', relatorio.totalRecebidoMes ?? ''),
              InfoAnimal('Líquido', relatorio.faturamentoLiquido ?? '',
                  destaque: true),
              InfoAnimal('Custo/L', relatorio.custoLitroLeite ?? ''),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _vazio(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 48.0, 32.0, 32.0),
      child: Column(
        children: [
          const MenuIconTile(icon: Icons.attach_money_rounded, size: 64.0),
          const SizedBox(height: 16.0),
          Text('Nenhum relatório ainda',
              style: GoogleFonts.readexPro(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: tema.primaryText)),
          const SizedBox(height: 4.0),
          Text(
            'Toque em "Novo relatório" para registrar a produção e os custos do mês.',
            textAlign: TextAlign.center,
            style: GoogleFonts.readexPro(
                fontSize: 13.0, color: tema.secondaryText),
          ),
        ],
      ),
    );
  }

  /// Rodapé fixo com a ação principal, sempre visível.
  Widget _rodapeNovo(BuildContext context) {
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
          onPressed: () {
            context.pushNamed(
              NovoRelatorioFinanceiroPage.routeName,
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
          },
          text: 'Novo relatório',
          icon: const Icon(Icons.add_rounded, size: 20.0),
          options: FFButtonOptions(
            width: double.infinity,
            height: 48.0,
            padding: EdgeInsets.zero,
            iconPadding: EdgeInsets.zero,
            color: AppTokens.brand,
            textStyle: GoogleFonts.readexPro(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w600),
            elevation: 0.0,
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(LayoutLista.raio),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: const CabecalhoTela(titulo: 'Relatório financeiro'),
      bottomNavigationBar: _rodapeNovo(context),
      // Fonte única ObjectBox (offline-first): a lista vem do banco local e o
      // Firestore serve só para sincronizar.
      body: StreamBuilder<List<FinanceiroEntity>>(
        stream: FinanceiroRepository()
            .watchByParentPath(widget.uidPropriedade!.path),
        builder: (context, snapshot) {
          final relatorios = (snapshot.data ?? <FinanceiroEntity>[])
              .where((e) => !e.isDeleted)
              .toList()
            // Mais recente primeiro, pela data de verdade.
            ..sort((a, b) => (_data(b.dtRelatorio) ?? DateTime(0))
                .compareTo(_data(a.dtRelatorio) ?? DateTime(0)));
          if (relatorios.isEmpty) return _vazio(context);
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
            itemCount: relatorios.length,
            itemBuilder: (context, i) => _cardRelatorio(context, relatorios[i]),
          );
        },
      ),
    );
  }
}
