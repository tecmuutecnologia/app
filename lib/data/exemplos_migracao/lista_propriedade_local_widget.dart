import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ✅ NOVO: Importar repositórios ObjectBox
import '/data/index.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/utils/flutter_flow_theme.dart';

/// EXEMPLO DE MIGRAÇÃO: Lista de Propriedades
///
/// Esta é uma versão migrada da ListaPropriedadeWidget
/// usando ObjectBox em vez de Firestore direto
///
/// MUDANÇAS PRINCIPAIS:
/// 1. ❌ Removido: StreamBuilder<List<TecnicoRecord>>
/// 2. ✅ Adicionado: TecnicoRepository e PropriedadesRepository
/// 3. ✅ Adicionado: Estado local com _loadData()
/// 4. ✅ Adicionado: RefreshIndicator para pull-to-refresh
/// 5. ✅ Adicionado: Indicador de sincronização
class ListaPropriedadeLocalWidget extends StatefulWidget {
  const ListaPropriedadeLocalWidget({
    super.key,
    required this.visitaPresencial,
  });

  final bool? visitaPresencial;

  static String routeName = 'listaPropriedadeLocal';
  static String routePath = '/listaPropriedadeLocal';

  @override
  State<ListaPropriedadeLocalWidget> createState() =>
      _ListaPropriedadeLocalWidgetState();
}

class _ListaPropriedadeLocalWidgetState
    extends State<ListaPropriedadeLocalWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // ✅ NOVO: Repositórios ObjectBox
  final _tecnicoRepo = TecnicoRepository();
  final _propriedadesRepo = PropriedadesRepository();

  // ✅ NOVO: Estado local
  TecnicoEntity? _tecnico;
  List<PropriedadesEntity> _propriedades = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ✅ NOVO: Método para carregar dados (INSTANTÂNEO do banco local!)
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Buscar técnico por UID do usuário atual
      final tecnico = await _tecnicoRepo.getByUidPerson(currentUserUid);

      if (tecnico == null) {
        setState(() {
          _error = 'Técnico não encontrado';
          _isLoading = false;
        });
        return;
      }

      // Buscar propriedades do técnico
      final propriedades = await _propriedadesRepo.getByTecnico(
        'tecnico/${tecnico.firestoreId}',
      );

      setState(() {
        _tecnico = tecnico;
        _propriedades = propriedades;
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar dados: $e');
      setState(() {
        _error = 'Erro ao carregar dados: $e';
        _isLoading = false;
      });
    }
  }

  // ✅ NOVO: Widget para cards de estatísticas
  Widget _buildStatCard(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Color(0xFFF75E38)),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // ✅ NOVO: Widget para card de propriedade
  Widget _buildPropriedadeCard(PropriedadesEntity propriedade) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: propriedade.needsSync
              ? Colors.orange.withValues(alpha: 0.2)
              : Colors.green.withValues(alpha: 0.2),
          child: Icon(
            propriedade.needsSync ? Icons.sync : Icons.check,
            color: propriedade.needsSync ? Colors.orange : Colors.green,
          ),
        ),
        title: Text(
          propriedade.displayName ?? 'Sem nome',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (propriedade.cidade != null)
              Text('Cidade: ${propriedade.cidade}'),
            if (propriedade.cpf != null) Text('CPF: ${propriedade.cpf}'),
            if (propriedade.needsSync)
              Text(
                'Aguardando sincronização...',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Detalhes: ${propriedade.displayName}')),
          );
        },
        isThreeLine: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ NOVO: Loading state simplificado
    if (_isLoading) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFF75E38),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text('Carregando do banco local...'),
            ],
          ),
        ),
      );
    }

    // ✅ NOVO: Error state
    if (_error != null) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(_error!),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadData,
                child: Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      );
    }

    // ✅ NOVO: Empty state
    if (_tecnico == null) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Center(
          child: Text('Técnico não encontrado'),
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            backgroundColor: Color(0xFFF75E38),
            automaticallyImplyLeading: false,
            actions: [
              // ✅ NOVO: Indicador de sincronização
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: Icon(
                    SyncService.instance.isSyncing
                        ? Icons.sync
                        : SyncService.instance.isOnline
                            ? Icons.cloud_done
                            : Icons.cloud_off,
                    color: SyncService.instance.isOnline
                        ? Colors.white
                        : Colors.white70,
                  ),
                  onPressed: () async {
                    await SyncService.instance.syncNow();
                    await _loadData();
                    setState(() {});
                  },
                  tooltip: SyncService.instance.isOnline
                      ? 'Online - Clique para sincronizar'
                      : 'Offline',
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Text(
                        'Propriedades (Local)',
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              font: GoogleFonts.outfit(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .fontStyle,
                              ),
                              color: Colors.white,
                              fontSize: 22.0,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .fontStyle,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              centerTitle: true,
              expandedTitleScale: 1.0,
            ),
            elevation: 2.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // ✅ NOVO: Estatísticas do técnico
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        'Propriedades',
                        _propriedades.length.toString(),
                        Icons.home,
                      ),
                      _buildStatCard(
                        'Limite',
                        (_tecnico!.limiteProdutoresContratado ?? 0).toString(),
                        Icons.people,
                      ),
                      _buildStatCard(
                        'Disponível',
                        (_tecnico!.restanteLimiteProdutores ?? 0).toString(),
                        Icons.add_circle,
                      ),
                    ],
                  ),
                ),
              ),

              // ✅ NOVO: Lista com RefreshIndicator
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadData,
                  child: _propriedades.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.home_outlined,
                                  size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('Nenhuma propriedade cadastrada'),
                              SizedBox(height: 8),
                              Text(
                                'Arraste para baixo para atualizar',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _propriedades.length,
                          itemBuilder: (context, index) {
                            final propriedade = _propriedades[index];
                            return _buildPropriedadeCard(propriedade);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
