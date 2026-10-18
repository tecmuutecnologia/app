// ignore_for_file: unnecessary_null_comparison, unused_local_variable

import '/core/ui/cabecalho_tela.dart';
import '/core/ui/card_animal_lista.dart';
import '/core/ui/painel_lista.dart';
import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/core/ui/flutter_flow_calendar.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/app_card.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '../widgets/selecao_animal_calendario_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarioSanitarioPage extends StatefulWidget {
  const CalendarioSanitarioPage({
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

  static String routeName = 'calendarioSanitario';
  static String routePath = '/calendarioSanitario';

  @override
  State<CalendarioSanitarioPage> createState() =>
      _CalendarioSanitarioPageState();
}

class _CalendarioSanitarioPageState extends State<CalendarioSanitarioPage> {
  DateTimeRange? _calendarSelectedDay;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _calendarSelectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  /// Ações da propriedade, sem as excluídas — fonte única ObjectBox
  /// (offline-first). Antes eram dois StreamBuilders do Firestore, que sem rede
  /// prendiam a tela no CircularProgressIndicator.
  Stream<List<AcaoSanitarioEntity>> get _acoes => AcaoSanitarioRepository()
      .watchByParentPath(widget.uidPropriedade!.path)
      .map((l) => l.where((e) => !e.isDeleted).toList());

  String _formatar(DateTime? dia) => dateTimeFormat("dd/MM/yyyy", dia,
      locale: FFLocalizations.of(context).languageCode);

  /// Calendário num card, com uma bolinha nos dias que têm ação — antes era
  /// preciso tocar dia por dia para descobrir onde havia registro.
  Widget _calendario(BuildContext context, List<AcaoSanitarioEntity> acoes) {
    final tema = FlutterFlowTheme.of(context);
    final porDia = <String, int>{};
    for (final a in acoes) {
      final dia = a.dtAcaoFormatada ?? '';
      if (dia.isNotEmpty) porDia[dia] = (porDia[dia] ?? 0) + 1;
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
      padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
      decoration: BoxDecoration(
        color: tema.secondaryBackground,
        borderRadius: BorderRadius.circular(AppTokens.radius),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: FlutterFlowCalendar(
        color: AppTokens.brand,
        iconColor: tema.secondaryText,
        weekFormat: false,
        weekStartsMonday: true,
        // Mês e setas na mesma linha (eram duas, a de baixo só com ícones).
        twoRowHeader: false,
        initialDate: getCurrentTimestamp,
        rowHeight: 44.0,
        eventLoader: (dia) =>
            List.filled(porDia[_formatar(dia)] ?? 0, true, growable: false),
        onChange: (DateTimeRange? novo) =>
            safeSetState(() => _calendarSelectedDay = novo),
        titleStyle: GoogleFonts.outfit(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: tema.primaryText),
        dayOfWeekStyle:
            GoogleFonts.readexPro(fontSize: 12.0, color: tema.secondaryText),
        dateStyle:
            GoogleFonts.readexPro(fontSize: 14.0, color: tema.primaryText),
        selectedDateStyle: GoogleFonts.readexPro(
            fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.white),
        inactiveDateStyle: GoogleFonts.readexPro(
            fontSize: 14.0, color: tema.secondaryText.withValues(alpha: 0.5)),
        locale: FFLocalizations.of(context).languageCode,
      ),
    );
  }

  /// Título da lista do dia, com quantas ações há nele.
  Widget _tituloDoDia(BuildContext context, int quantidade) {
    final tema = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Ações em ${_formatar(_calendarSelectedDay?.start)}',
              style: GoogleFonts.readexPro(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: tema.primaryText),
            ),
          ),
          if (quantidade > 0)
            Text('$quantidade',
                style: GoogleFonts.readexPro(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                    color: AppTokens.brand)),
        ],
      ),
    );
  }

  Widget _vazio(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 24.0),
      child: Column(
        children: [
          Icon(Icons.event_available_outlined,
              size: 36.0, color: tema.secondaryText.withValues(alpha: 0.6)),
          const SizedBox(height: 8.0),
          Text(
            'Nenhuma ação registrada neste dia.',
            textAlign: TextAlign.center,
            style: GoogleFonts.readexPro(
                fontSize: 13.0, color: tema.secondaryText),
          ),
        ],
      ),
    );
  }

  /// Card de uma ação: animal em destaque, tipo/ação e a observação (só
  /// quando existe — antes aparecia "Obs.: null").
  Widget _cardAcao(BuildContext context, AcaoSanitarioEntity acao) {
    final tema = FlutterFlowTheme.of(context);
    final animal = _animalDaAcao(acao);
    final titulo = animal == null
        ? (acao.nomeAnimal?.isNotEmpty ?? false)
            ? acao.nomeAnimal!
            : 'Animal'
        : tituloNomeBrinco(animal.nomeAnimal, animal.brincoAnimal);
    final tipo = [acao.tipoAcao, acao.acao]
        .where((t) => t != null && t.isNotEmpty)
        .join(' · ');
    final obs = acao.obsVisita?.trim() ?? '';
    return Container(
      margin: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
      decoration: BoxDecoration(
        color: tema.secondaryBackground,
        borderRadius: BorderRadius.circular(AppTokens.radius),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: const BoxDecoration(
                color: AppTokens.brandTint, shape: BoxShape.circle),
            child: const Icon(Icons.vaccines_outlined,
                color: AppTokens.brand, size: 20.0),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.readexPro(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: tema.primaryText)),
                if (tipo.isNotEmpty)
                  Text(tipo,
                      style: GoogleFonts.readexPro(
                          fontSize: 13.0, color: tema.primaryText)),
                if (obs.isNotEmpty && obs != 'null') ...[
                  const SizedBox(height: 4.0),
                  Text(obs,
                      style: GoogleFonts.readexPro(
                          fontSize: 12.0, color: tema.secondaryText)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Rodapé fixo com a ação principal da tela, sempre visível.
  Widget _rodapeNovaAcao(BuildContext context) {
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
          onPressed: () async {
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
                  child: SelecaoAnimalCalendarioWidget(
                    uidPropriedade: widget.uidPropriedade!,
                    nomePropriedade: widget.nomePropriedade!,
                    uidTecnico: widget.uidTecnico!,
                    emailPropriedade: widget.emailPropriedade!,
                    visitaPresencial: widget.visitaPresencial!,
                  ),
                ),
              ),
            );
            safeSetState(() {});
          },
          text: 'Registrar nova ação',
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

  /// Resolve o animal da ação no ObjectBox. O entity guarda o CAMINHO da
  /// referência; o id do Firestore é o último segmento. Convertido para struct
  /// porque `AnimaisProdutoresStruct` expõe `nomeAnimal`/`brincoAnimal` com a
  /// mesma API do antigo `AnimaisProdutoresRecord`.
  AnimaisProdutoresStruct? _animalDaAcao(AcaoSanitarioEntity acao) {
    final caminho = acao.uidAnimalAnimaisProdutoresPath;
    if (caminho == null || caminho.isEmpty) return null;
    final entity = AnimalRepository().getByFirestoreId(caminho.split('/').last);
    return entity == null ? null : animalEntityToStruct(entity);
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
        appBar: const CabecalhoTela(titulo: 'Calendário sanitário'),
        bottomNavigationBar: _rodapeNovaAcao(context),
        body: StreamBuilder<List<AcaoSanitarioEntity>>(
          stream: _acoes,
          builder: (context, snapshot) {
            final acoes = snapshot.data ?? const <AcaoSanitarioEntity>[];
            final diaSelecionado = _formatar(_calendarSelectedDay?.start);
            final doDia = acoes
                .where((e) => e.dtAcaoFormatada == diaSelecionado)
                .toList();
            return ListView(
              padding: const EdgeInsets.only(bottom: 16.0),
              children: [
                _calendario(context, acoes),
                _tituloDoDia(context, doDia.length),
                if (doDia.isEmpty) _vazio(context),
                for (final acao in doDia) _cardAcao(context, acao),
              ],
            );
          },
        ),
      ),
    );
  }
}
