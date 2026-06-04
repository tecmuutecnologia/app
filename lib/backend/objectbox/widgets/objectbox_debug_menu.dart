import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../objectbox_debug_service.dart';

/// Widget para acessar ferramentas de debug do ObjectBox
/// Use em tela de desenvolvimento ou admin
class ObjectBoxDebugMenu extends StatefulWidget {
  const ObjectBoxDebugMenu({Key? key}) : super(key: key);

  @override
  State<ObjectBoxDebugMenu> createState() => _ObjectBoxDebugMenuState();
}

class _ObjectBoxDebugMenuState extends State<ObjectBoxDebugMenu> {
  String _statusMessage = '';
  bool _isLoading = false;

  void _showMessage(String message, {bool isError = false}) {
    setState(() {
      _statusMessage = message;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _startAdmin() async {
    setState(() => _isLoading = true);
    try {
      final success = await ObjectBoxDebugService.startAdmin();
      if (success) {
        _showMessage(
            '✅ ObjectBox Admin iniciado! Acesse http://localhost:8090');
      } else {
        _showMessage('❌ Erro ao iniciar admin', isError: true);
      }
    } catch (e) {
      _showMessage('❌ Erro: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _stopAdmin() async {
    setState(() => _isLoading = true);
    try {
      await ObjectBoxDebugService.stopAdmin();
      _showMessage('✅ Admin parado');
    } catch (e) {
      _showMessage('❌ Erro: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showStats() {
    ObjectBoxDebugService.printDatabaseStats();
    _showMessage('📊 Estatísticas exibidas no console');
  }

  void _showSessions() {
    ObjectBoxDebugService.printSessions();
    _showMessage('🔐 Sessões exibidas no console');
  }

  void _showDebugData() {
    final data = ObjectBoxDebugService.exportDebugData();
    print('═══════════════════════════════════════════════════════');
    print('📊 DEBUG DATA (JSON):');
    print('═══════════════════════════════════════════════════════');
    data.forEach((key, value) {
      print('$key: $value');
    });
    print('═══════════════════════════════════════════════════════\n');
    _showMessage('📊 Dados exportados no console');
  }

  Future<void> _clearSessions() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Sessões'),
        content: const Text('Tem certeza que deseja remover todas as sessões?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      setState(() => _isLoading = true);
      try {
        await ObjectBoxDebugService.clearAllSessions();
        _showMessage('✅ Sessões removidas');
      } catch (e) {
        _showMessage('❌ Erro: $e', isError: true);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ CUIDADO!'),
        content: const Text(
          'Tem certeza que deseja limpar TODOS os dados do ObjectBox?\n\n'
          'Esta ação é irreversível!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                const Text('Limpar TUDO', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      setState(() => _isLoading = true);
      try {
        await ObjectBoxDebugService.clearAllData();
        _showMessage('✅ Banco de dados limpo', isError: true);
      } catch (e) {
        _showMessage('❌ Erro: $e', isError: true);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Defesa em profundidade: ferramentas de debug nunca aparecem em release,
    // mesmo que sejam acionadas por algum caminho não previsto.
    if (kReleaseMode) return const SizedBox.shrink();

    final status = ObjectBoxDebugService.getStatus();
    final isInitialized = status['initialized'] as bool;
    final adminRunning = status['adminRunning'] as bool;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔧 ObjectBox Debug'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📊 Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('ObjectBox: '),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isInitialized ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isInitialized
                              ? '✅ Inicializado'
                              : '❌ Não inicializado',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Admin: '),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: adminRunning ? Colors.green : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          adminRunning ? '✅ Rodando' : '⭕ Parado',
                        ),
                      ],
                    ),
                    if (_statusMessage.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Última ação: $_statusMessage',
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Admin Section
            const Text(
              '🌐 ObjectBox Admin',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Admin é uma ferramenta web para inspecionar e editar dados do ObjectBox em tempo real.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading || !isInitialized ? null : _startAdmin,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Iniciar Admin (localhost:8090)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading || !adminRunning ? null : _stopAdmin,
                icon: const Icon(Icons.stop),
                label: const Text('Parar Admin'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Inspection Section
            const Text(
              '🔍 Inspeção de Dados',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading || !isInitialized ? null : _showStats,
                icon: const Icon(Icons.bar_chart),
                label: const Text('Exibir Estatísticas (Console)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading || !isInitialized ? null : _showSessions,
                icon: const Icon(Icons.security),
                label: const Text('Exibir Sessões (Console)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading || !isInitialized ? null : _showDebugData,
                icon: const Icon(Icons.code),
                label: const Text('Exportar JSON Debug (Console)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Danger Zone
            const Text(
              '⚠️ Zona de Perigo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading || !isInitialized ? null : _clearSessions,
                icon: const Icon(Icons.delete),
                label: const Text('Limpar Todas as Sessões'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading || !isInitialized ? null : _clearAll,
                icon: const Icon(Icons.warning),
                label: const Text('🗑️ Limpar TODO o ObjectBox'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Help
            Card(
              color: Colors.amber[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '💡 Como Usar ObjectBox Admin',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '1. Clique em "Iniciar Admin"\n'
                      '2. Abra seu navegador no PC/Mac\n'
                      '3. Acesse: http://localhost:8090\n'
                      '4. Inspecione, edite e teste dados em tempo real\n\n'
                      'O Admin só funciona enquanto o app está rodando!',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            if (_isLoading) ...[
              const SizedBox(height: 16),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
