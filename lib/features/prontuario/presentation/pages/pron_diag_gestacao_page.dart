import '/data/backend.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/app_card.dart';
import '/data/objectbox/repositories/acao_repository.dart';
import '/data/objectbox/entities/index.dart';
import '/features/prontuario/presentation/widgets/ficha_clinica.dart';
import '/features/prontuario/application/acao_record_adapter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PronDiagGestacaoPage extends StatefulWidget {
  const PronDiagGestacaoPage({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.uidAnimaisProdutores,
    required this.grupoPredominante,
    required this.visitaPresencial,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final DocumentReference? uidAnimaisProdutores;
  final String? grupoPredominante;
  final bool? visitaPresencial;

  static String routeName = 'pronDiagGestacao';
  static String routePath = '/pronDiagGestacao';

  @override
  State<PronDiagGestacaoPage> createState() => _PronDiagGestacaoPageState();
}

class _PronDiagGestacaoPageState extends State<PronDiagGestacaoPage> {
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
          'Diagnótisco de gestação',
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

  Widget _secaoDiagGestacao(BuildContext context) {
    // Mesmo cartao das outras telas de "Ver mais": esta era a unica sem ele.
    return Container(
        width: 500.0,
        constraints: BoxConstraints(maxWidth: 570.0),
        margin: EdgeInsetsDirectional.fromSTEB(12.0, 10.0, 12.0, 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: AppTokens.softShadow(context),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(5.0, 15.0, 5.0, 5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [],
                      ),
                    ],
                  ),
                ),
                StreamBuilder<List<AcaoEntity>>(
                  // Fonte: ObjectBox. Antes era `.snapshots()` do Firestore, e o
                  // filtro por tipo acontecia no card com Visibility em vez de na
                  // query — a tela buscava tudo e escondia o que nao servia.
                  stream: AcaoRepository().watchByAnimalComTipos(
                    widget.uidAnimaisProdutores!.path,
                    incluir: const {'PP', 'DG+', 'DG-'},
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    final acoes = snapshot.data!;
                    if (acoes.isEmpty) return const SecaoVazia();

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: acoes.length,
                      itemBuilder: (context, i) {
                        final item = acaoEntityToRecord(acoes[i]);
                        return LinhaProntuario(
                          identidade: IdentidadeSecao.diagnosticos,
                          data: item.dataVisita,
                          titulo: item.acao,
                          detalhe: null,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
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

        final _ = snapshot.data!;

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
                mainAxisSize: MainAxisSize.max,
                children: [
                  _secaoDiagGestacao(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
