import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../sync_debugger_service.dart';

/// Widget de debug para testar sincronização offline-first
/// Adicione à sua app durante desenvolvimento para debug em tempo real
/// Remova antes de publicar!
class SyncDebugger extends StatefulWidget {
  final bool showByDefault;

  const SyncDebugger({
    Key? key,
    this.showByDefault = true,
  }) : super(key: key);

  @override
  State<SyncDebugger> createState() => _SyncDebuggerState();
}

class _SyncDebuggerState extends State<SyncDebugger> {
  late SyncDebuggerService _debugger;
  bool _isExpanded = false;
  List<SyncDebugEvent> _events = [];

  @override
  void initState() {
    super.initState();
    _initDebugger();
  }

  Future<void> _initDebugger() async {
    try {
      _debugger = await SyncDebuggerService.initialize();
      _debugger.debugEventStream.listen((event) {
        setState(() {
          _events.insert(0, event);
          // Limita a 100 eventos em memória
          if (_events.length > 100) {
            _events = _events.sublist(0, 100);
          }
        });
      });
    } catch (e) {
      debugPrint('Erro ao inicializar SyncDebugger: $e');
    }
  }

  @override
  void dispose() {
    _debugger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Defesa em profundidade: o debugger de sync nunca aparece em release.
    if (kReleaseMode) return const SizedBox.shrink();

    if (!_isExpanded) {
      return Positioned(
        bottom: 16,
        right: 16,
        child: FloatingActionButton.extended(
          onPressed: () => setState(() => _isExpanded = true),
          icon: const Icon(Icons.bug_report),
          label: const Text('Debug Sync'),
          backgroundColor: Colors.purple[700],
        ),
      );
    }

    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      top: 0,
      child: Material(
        color: Colors.black87,
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.purple[900],
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.bug_report, color: Colors.white),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Sincronização Debug',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => setState(() => _isExpanded = false),
                  ),
                ],
              ),
            ),
            // Tabs
            Container(
              color: Colors.purple[800],
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTabButton('Testes', () => _showTestsTab()),
                    _buildTabButton('Dados', () => _showDataTab()),
                    _buildTabButton('Status', () => _showStatusTab()),
                    _buildTabButton('Logs', () => _showLogsTab()),
                  ],
                ),
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildCurrentTab(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  int _currentTab = 0;

  void _showTestsTab() => setState(() => _currentTab = 0);
  void _showDataTab() => setState(() => _currentTab = 1);
  void _showStatusTab() => setState(() => _currentTab = 2);
  void _showLogsTab() => setState(() => _currentTab = 3);

  Widget _buildCurrentTab() {
    switch (_currentTab) {
      case 0:
        return _buildTestsTab();
      case 1:
        return _buildDataTab();
      case 2:
        return _buildStatusTab();
      case 3:
        return _buildLogsTab();
      default:
        return const SizedBox();
    }
  }

  // ========================================================================
  // TAB 1: TESTES
  // ========================================================================

  Widget _buildTestsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'TESTE 1: Validar Persistência Local',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Nome do animal',
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.purple),
            ),
          ),
          onSubmitted: (value) {
            _debugger.validateAnimalSavedLocally(value);
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'TESTE 2: Listar Mudanças Pendentes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => _debugger.listPendingChanges(),
          icon: const Icon(Icons.list),
          label: const Text('Listar Mudanças'),
        ),
        const SizedBox(height: 16),
        const Text(
          'TESTE 3: Sincronizar Agora',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => _debugger.forceSyncNow(),
          icon: const Icon(Icons.cloud_upload),
          label: const Text('Forçar Sincronização'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'TESTE 4: Simular Mudança',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Nome do animal para simular mudança',
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.purple),
            ),
          ),
          onSubmitted: (value) {
            _debugger.simulateAnimalChange(value);
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'TESTE 5: Limpeza',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirmar Limpeza'),
                content: const Text(
                  'Tem certeza que deseja limpar todos os dados locais?\n\nEsta ação é irreversível!',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      _debugger.clearAllLocalData();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Limpar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.delete),
          label: const Text('Limpar Dados Locais'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
        ),
      ],
    );
  }

  // ========================================================================
  // TAB 2: DADOS
  // ========================================================================

  Widget _buildDataTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Dados em Cache Local',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => _debugger.listLocalAnimals(),
          icon: const Icon(Icons.pets),
          label: const Text('Listar Animais'),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => _debugger.listLocalAcoes(),
          icon: const Icon(Icons.assignment),
          label: const Text('Listar Ações'),
        ),
      ],
    );
  }

  // ========================================================================
  // TAB 3: STATUS
  // ========================================================================

  Widget _buildStatusTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Estatísticas de Sincronização',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => _debugger.getSyncStatistics(),
          icon: const Icon(Icons.bar_chart),
          label: const Text('Carregar Estatísticas'),
        ),
      ],
    );
  }

  // ========================================================================
  // TAB 4: LOGS
  // ========================================================================

  Widget _buildLogsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Últimos Eventos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.red),
              onPressed: () => setState(() => _events.clear()),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_events.isEmpty)
          const Center(
            child: Text(
              'Nenhum evento ainda',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ..._events.map((event) {
            final color = {
              SyncDebugEventType.success: Colors.green,
              SyncDebugEventType.error: Colors.red,
              SyncDebugEventType.warning: Colors.orange,
              SyncDebugEventType.info: Colors.blue,
            }[event.type];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color?.withOpacity(0.2),
                border: Border(
                  left: BorderSide(
                    color: color ?? Colors.grey,
                    width: 4,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.message,
                    style: TextStyle(
                      color: color ?? Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (event.details != null) ...[
                    const SizedBox(height: 8),
                    ...event.details!.entries.map((e) {
                      return Text(
                        '• ${e.key}: ${e.value}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      );
                    }).toList(),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    event.timestamp.toString().split('.')[0],
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
      ],
    );
  }
}
