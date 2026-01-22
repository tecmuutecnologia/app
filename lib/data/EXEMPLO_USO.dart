import 'package:flutter/material.dart';
import 'package:tecmuu/data/index.dart';

/// Exemplo de tela usando os repositórios ObjectBox
///
/// Este exemplo mostra como usar os novos repositórios locais
/// para listar animais de uma propriedade
class ExemploListaAnimaisLocal extends StatefulWidget {
  final String propriedadeRef;

  const ExemploListaAnimaisLocal({
    Key? key,
    required this.propriedadeRef,
  }) : super(key: key);

  @override
  State<ExemploListaAnimaisLocal> createState() =>
      _ExemploListaAnimaisLocalState();
}

class _ExemploListaAnimaisLocalState extends State<ExemploListaAnimaisLocal> {
  final _animaisRepository = AnimaisProdutoresRepository();
  List<AnimaisProdutoresEntity> _animais = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnimais();
  }

  Future<void> _loadAnimais() async {
    setState(() => _isLoading = true);

    try {
      // Busca INSTANTÂNEA do banco local!
      final animais =
          await _animaisRepository.getByPropriedade(widget.propriedadeRef);

      setState(() {
        _animais = animais;
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar animais: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addAnimal() async {
    final novoAnimal = AnimaisProdutoresEntity(
      brincoAnimal: DateTime.now().millisecondsSinceEpoch % 100000,
      nomeAnimal: 'Animal ${_animais.length + 1}',
      racaAnimal: 'Holandês',
      status: 'ativa',
      uidTecnicoPropriedade: widget.propriedadeRef,
    );

    // Salva INSTANTANEAMENTE no banco local
    // Sincroniza com Firestore em background
    await _animaisRepository.save(novoAnimal);

    // Recarrega lista
    await _loadAnimais();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Animal adicionado! Sincronizando em background...'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _deleteAnimal(AnimaisProdutoresEntity animal) async {
    await _animaisRepository.delete(animal.id);
    await _loadAnimais();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Animal removido!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animais (Local-First)'),
        actions: [
          // Indicador de sincronização
          IconButton(
            icon: Icon(
              SyncService.instance.isSyncing ? Icons.sync : Icons.cloud_done,
              color: SyncService.instance.isOnline ? Colors.green : Colors.grey,
            ),
            onPressed: () async {
              await SyncService.instance.syncNow();
              setState(() {});
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _animais.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.pets, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('Nenhum animal cadastrado'),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _addAnimal,
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar Primeiro Animal'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadAnimais,
                  child: ListView.builder(
                    itemCount: _animais.length,
                    itemBuilder: (context, index) {
                      final animal = _animais[index];
                      return _AnimalCard(
                        animal: animal,
                        onDelete: () => _deleteAnimal(animal),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAnimal,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _AnimalCard extends StatelessWidget {
  final AnimaisProdutoresEntity animal;
  final VoidCallback onDelete;

  const _AnimalCard({
    required this.animal,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: animal.needsSync ? Colors.orange : Colors.green,
          child: Icon(
            animal.needsSync ? Icons.sync : Icons.check,
            color: Colors.white,
          ),
        ),
        title: Text(
          animal.nomeAnimal ?? 'Sem nome',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Brinco: ${animal.brincoAnimal ?? 'N/A'}'),
            Text('Raça: ${animal.racaAnimal ?? 'N/A'}'),
            Text('Status: ${animal.status ?? 'N/A'}'),
            if (animal.needsSync)
              const Text(
                'Aguardando sincronização...',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirmar exclusão'),
                content: Text(
                    'Deseja excluir ${animal.nomeAnimal ?? 'este animal'}?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onDelete();
                    },
                    child: const Text('Excluir',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
        ),
        isThreeLine: true,
      ),
    );
  }
}

/// Exemplo de widget para técnico
class ExemploPerfilTecnicoLocal extends StatefulWidget {
  final String uidPerson;

  const ExemploPerfilTecnicoLocal({
    Key? key,
    required this.uidPerson,
  }) : super(key: key);

  @override
  State<ExemploPerfilTecnicoLocal> createState() =>
      _ExemploPerfilTecnicoLocalState();
}

class _ExemploPerfilTecnicoLocalState extends State<ExemploPerfilTecnicoLocal> {
  final _tecnicoRepository = TecnicoRepository();
  TecnicoEntity? _tecnico;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTecnico();
  }

  Future<void> _loadTecnico() async {
    setState(() => _isLoading = true);

    try {
      final tecnico = await _tecnicoRepository.getByUidPerson(widget.uidPerson);

      setState(() {
        _tecnico = tecnico;
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar técnico: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_tecnico == null) {
      return const Center(child: Text('Técnico não encontrado'));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoCard(
            title: 'Status',
            value: _tecnico!.liberado == true ? 'Liberado' : 'Bloqueado',
            icon: _tecnico!.liberado == true ? Icons.check_circle : Icons.block,
            color: _tecnico!.liberado == true ? Colors.green : Colors.red,
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Produtores',
            value:
                '${_tecnico!.quantidadeProdutoresCadastrados ?? 0} / ${_tecnico!.limiteProdutoresContratado ?? 0}',
            subtitle: 'Restantes: ${_tecnico!.restanteLimiteProdutores ?? 0}',
            icon: Icons.people,
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Animais',
            value:
                '${_tecnico!.quantidadeAnimaisCadastrados ?? 0} / ${_tecnico!.limiteAnimaisContratado ?? 0}',
            subtitle: 'Restantes: ${_tecnico!.restanteLimiteAnimais ?? 0}',
            icon: Icons.pets,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;

  const _InfoCard({
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
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
