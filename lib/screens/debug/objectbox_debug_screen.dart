import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tecmuu/data/objectbox_debug.dart';

/// Tela de debug para inspecionar dados do ObjectBox
class ObjectBoxDebugScreen extends StatefulWidget {
  const ObjectBoxDebugScreen({Key? key}) : super(key: key);

  static const String routeName = '/debug/objectbox';

  @override
  State<ObjectBoxDebugScreen> createState() => _ObjectBoxDebugScreenState();
}

class _ObjectBoxDebugScreenState extends State<ObjectBoxDebugScreen> {
  String _debugOutput = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      await ObjectBoxDebug.logStorePathAndFiles();
      await ObjectBoxDebug.logEntityCounts();
      final animais = await ObjectBoxDebug.snapshotAnimais();
      setState(() {
        _debugOutput =
            'ObjectBox Snapshot:\n${animais.length} animais encontrados\n';
        if (animais.isNotEmpty) {
          for (final animal in animais.take(5)) {
            _debugOutput +=
                'ID: ${animal.id}, Nome: ${animal.nomeAnimal}, Brinco: ${animal.brincoAnimal}\n';
          }
          if (animais.length > 5) {
            _debugOutput += '... e ${animais.length - 5} mais\n';
          }
        }
      });
    } catch (e) {
      setState(() => _debugOutput = 'Erro: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _launchAdminUI() async {
    try {
      const url = 'http://localhost:8081';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Admin UI não está disponível.\nCertifique-se de que o app está rodando em modo Debug.',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao abrir Admin UI: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ObjectBox Debug'),
        backgroundColor: Colors.amber.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin UI Button
            ElevatedButton.icon(
              onPressed: _launchAdminUI,
              icon: const Icon(Icons.web),
              label: const Text('Abrir Admin UI (http://localhost:8081)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Refresh Button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _loadInitialData,
              icon: const Icon(Icons.refresh),
              label: const Text('Atualizar dados'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Debug Info
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _debugOutput.isEmpty
                        ? 'Clique em "Atualizar dados" para carregar info do ObjectBox'
                        : _debugOutput,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Info Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue.shade50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'ObjectBox Admin UI (Modo Debug)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Interface web para inspecionar dados em tempo real',
                  ),
                  Text(
                    '• URL padrão: http://localhost:8081',
                  ),
                  Text(
                    '• Só funciona em modo Debug (kDebugMode)',
                  ),
                  Text(
                    '• Disponível durante execução do app',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
