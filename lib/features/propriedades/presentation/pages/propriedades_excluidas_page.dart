// ignore_for_file: unused_import
import '/core/auth/firebase_auth/auth_util.dart';
import '/core/ui/app_card.dart';
import '/data/backend.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/di/providers.dart';
import '/core/result/result.dart';
import '/data/objectbox/entities/index.dart';
import '/features/propriedades/application/propriedades_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class PropriedadesExcluiasPage extends ConsumerStatefulWidget {
  const PropriedadesExcluiasPage({
    super.key,
    required this.visitaPresencial,
    required this.uidTecnico,
  });

  final bool? visitaPresencial;
  final DocumentReference? uidTecnico;

  static String routeName = 'propriedadesExcluidas';
  static String routePath = '/propriedadesExcluidas';

  @override
  ConsumerState<PropriedadesExcluiasPage> createState() =>
      _PropriedadesExcluiasPageState();
}

class _PropriedadesExcluiasPageState
    extends ConsumerState<PropriedadesExcluiasPage> {
  FocusNode? _searchFocusNode;
  TextEditingController? _searchController;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _searchController ??= TextEditingController();
    _searchFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _searchFocusNode?.dispose();
    _searchController?.dispose();

    super.dispose();
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
              context.pop();
            },
          ),
        ),
        Text(
          'Propriedades Excluídas',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                font: GoogleFonts.outfit(
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
                color: Colors.white,
                fontSize: 20.0,
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

  Widget _campoBusca(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: TextFormField(
        controller: _searchController,
        onChanged: (_) => safeSetState(() {}),
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'Pesquisar propriedade excluída',
          labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(14.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTokens.secondary,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(14.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(14.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(14.0),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).primaryBackground,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          suffixIcon: _searchController!.text.isNotEmpty
              ? InkWell(
                  onTap: () => safeSetState(() {
                    _searchController?.clear();
                  }),
                  child: Icon(
                    Icons.clear,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 18.0,
                  ),
                )
              : null,
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
        maxLines: 1,
        validator: _searchController == null ? null : (value) => null,
      ),
    );
  }

  Widget _secaoLista(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _listaExcluidas(context),
      ],
    );
  }

  Widget _listaExcluidas(BuildContext context) {
    // Lixeira lida do ObjectBox: aparece mesmo offline, e restaurar/excluir
    // refletem na hora (a query deixa de casar com o registro).
    final tecnicoPath =
        widget.uidTecnico?.path ?? ref.watch(tecnicoPathProvider);
    if (tecnicoPath == null) {
      return Expanded(child: _mensagem(context, 'Técnico não encontrado.'));
    }

    final excluidas =
        ref.watch(propriedadesExcluidasProvider(tecnicoPath)).valueOrNull ??
            const <PropriedadeEntity>[];

    final searchQuery = (_searchController?.text ?? '').toLowerCase();
    final lista = searchQuery.isEmpty
        ? excluidas
        : excluidas
            .where((p) =>
                (p.displayName ?? '').toLowerCase().contains(searchQuery))
            .toList();

    if (lista.isEmpty) {
      return Expanded(
        child: _mensagem(
          context,
          searchQuery.isNotEmpty
              ? 'Nenhuma propriedade encontrada com "$searchQuery"'
              : 'A lixeira está vazia.\nPropriedades excluídas aparecem aqui '
                  'e podem ser restauradas.',
          icone: searchQuery.isNotEmpty
              ? Icons.search_off_rounded
              : Icons.delete_outline_rounded,
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 1.0, 0.0, 0.0),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 4.0, bottom: 24.0),
          itemCount: lista.length,
          itemBuilder: (context, listViewIndex) {
            final entity = lista[listViewIndex];
            return Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 10.0),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoPropriedade(context, entity),
                    _botoesAcao(context, entity),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _mensagem(BuildContext context, String texto, {IconData? icone}) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icone != null) ...[
              Container(
                width: 64.0,
                height: 64.0,
                decoration: const BoxDecoration(
                  color: AppTokens.brandTint,
                  shape: BoxShape.circle,
                ),
                child: Icon(icone, color: AppTokens.brand, size: 30.0),
              ),
              const SizedBox(height: 16.0),
            ],
            Text(
              texto,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.readexPro(),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// Mesma linha de topo dos cards da lista de propriedades (avatar + nome +
  /// subtítulo). O aro do avatar fica cinza: a propriedade está fora de uso.
  Widget _infoPropriedade(BuildContext context, PropriedadeEntity entity) {
    final cinza = FlutterFlowTheme.of(context).secondaryText;
    final subtitulo = [
      if ((entity.cidade ?? '').trim().isNotEmpty) entity.cidade!.trim(),
      if (entity.deletedAt != null)
        'Excluída em ${dateTimeFormat('dd/MM/yyyy', entity.deletedAt)}',
    ].join(' · ');

    return Row(
      children: [
        Container(
          width: 44.0,
          height: 44.0,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: cinza, width: 2.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(44.0),
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  'assets/images/Logo-white_(1).png',
                  width: 35.0,
                  height: 35.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entity.displayName ?? 'Propriedade',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      font: GoogleFonts.readexPro(),
                      letterSpacing: 0.0,
                    ),
              ),
              if (subtitulo.isNotEmpty) ...[
                const SizedBox(height: 4.0),
                Text(
                  subtitulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        font: GoogleFonts.readexPro(),
                        color: cinza,
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Restaurar é a ação principal (roxo cheio, como "Ativar conta" na lista);
  /// excluir de vez é destrutiva e fica em tom suave para não competir.
  Widget _botoesAcao(BuildContext context, PropriedadeEntity entity) {
    final vermelho = FlutterFlowTheme.of(context).error;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
      child: Row(
        children: [
          Expanded(
            child: FFButtonWidget(
              onPressed: () => _restaurar(context, entity),
              text: 'Restaurar',
              icon: const Icon(Icons.restore_rounded, size: 18.0),
              options: FFButtonOptions(
                height: 44.0,
                color: AppTokens.secondary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      font: GoogleFonts.readexPro(),
                      color: Colors.white,
                      letterSpacing: 0.0,
                    ),
                elevation: 0.0,
                borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: FFButtonWidget(
              onPressed: () => _excluirDeVez(context, entity),
              text: 'Excluir de vez',
              icon: Icon(Icons.delete_forever_outlined,
                  size: 18.0, color: vermelho),
              options: FFButtonOptions(
                height: 44.0,
                color: vermelho.withValues(alpha: 0.1),
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      font: GoogleFonts.readexPro(),
                      color: vermelho,
                      letterSpacing: 0.0,
                    ),
                elevation: 0.0,
                borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _restaurar(
      BuildContext context, PropriedadeEntity entity) async {
    final confirmRestore = await showDialog<bool>(
      context: context,
      builder: (alertDialogContext) {
        return AlertDialog(
          title: const Text('Restaurar propriedade'),
          content: const Text('Deseja restaurar esta propriedade?'),
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
        );
      },
    );

    if (confirmRestore != true) {
      return;
    }

    // Offline-first: grava local e sincroniza (ou enfileira). O item some da
    // lixeira sozinho — a query reativa deixa de casar com ele, sem precisar
    // de setState.
    final result =
        await ref.read(propriedadeRepositoryProvider).restaurar(entity);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result is Success
            ? 'Propriedade restaurada com sucesso.'
            : 'Não foi possível restaurar a propriedade.'),
      ),
    );
  }

  Future<void> _excluirDeVez(
      BuildContext context, PropriedadeEntity entity) async {
    final confirmDialogResponse = await showDialog<bool>(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: const Text('Excluir Permanentemente'),
              content: const Text(
                  'Tem certeza que deseja excluir permanentemente essa propriedade? Esta ação não poderá ser desfeita.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext, false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext, true),
                  child: const Text('Excluir'),
                ),
              ],
            );
          },
        ) ??
        false;
    if (!confirmDialogResponse) {
      return;
    }

    // Apaga o documento no Firestore e remove o registro local (enfileira o
    // DELETE se estiver offline).
    await ref.read(propriedadeRepositoryProvider).excluirPermanente(entity);

    if (!context.mounted) return;
    await showDialog(
      context: context,
      builder: (alertDialogContext) {
        return AlertDialog(
          title: const Text('Excluída!'),
          content: const Text('Propriedade excluída permanentemente.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(alertDialogContext),
              child: const Text('Ok'),
            ),
          ],
        );
      },
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
        body: SafeArea(
          top: true,
          // Sem SingleChildScrollView: a busca fica fixa e a ListView é o único
          // scrollable, com altura limitada — assim ela virtualiza de verdade.
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _campoBusca(context),
              // A Row da seção precisa do Expanded: sem ele a Column lhe dá
              // altura ilimitada e a ListView lá dentro estoura o layout.
              Expanded(child: _secaoLista(context)),
            ],
          ),
        ),
      ),
    );
  }
}
