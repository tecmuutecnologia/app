# Arquitetura Local-First com ObjectBox

Esta pasta contém a implementação da arquitetura local-first usando ObjectBox como banco de dados local e Firebase Firestore como backend.

## Estrutura

```
lib/data/
├── local/              # Entidades ObjectBox (@Entity)
│   └── person_entity.dart
├── repositories/       # Repositórios com padrão local-first
│   ├── base_repository.dart
│   └── person_repository.dart
├── sync/              # Serviços de sincronização
│   └── sync_service.dart
├── objectbox_store.dart  # Singleton do ObjectBox Store
└── index.dart         # Exportações
```

## Fluxo Local-First

### 1. Leitura de Dados
```dart
// Busca primeiro do ObjectBox (instantâneo)
final person = await personRepository.getById(1);

// Lista todos localmente
final allPersons = await personRepository.getAll();
```

### 2. Escrita de Dados
```dart
// Salva primeiro localmente (instantâneo)
final person = PersonEntity(
  displayName: 'João Silva',
  email: 'joao@example.com',
  cpf: '123.456.789-00',
);

await personRepository.save(person);
// Retorna imediatamente, sincronização em background
```

### 3. Sincronização Automática
O `SyncService` gerencia:
- Sincronização periódica (padrão: 5 minutos)
- Sincronização ao restaurar conexão
- Retry automático em caso de falha

## Setup Inicial

### 1. Inicializar ObjectBox no main.dart

```dart
import 'package:tecmuu/data/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa Firebase
  await Firebase.initializeApp(/*...*/);
  
  // Inicializa ObjectBox ANTES de runApp
  await ObjectBoxStore.init();
  
  // Inicializa serviço de sincronização
  await SyncService.instance.init();
  
  runApp(MyApp());
}
```

### 2. Gerar código ObjectBox

Execute após criar/modificar entidades:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Isso gera o arquivo `objectbox.g.dart` necessário.

## Criando Novas Entidades

### 1. Criar Entidade no ObjectBox

```dart
import 'package:objectbox/objectbox.dart';

@Entity()
class MinhaEntidade {
  @Id()
  int id = 0;
  
  @Unique()
  String? firestoreId;
  
  String? meuCampo;
  
  @Property(type: PropertyType.date)
  DateTime? createdAt;
  
  // Campos de controle
  @Property(type: PropertyType.date)
  DateTime? lastSyncedAt;
  bool needsSync = false;
  bool isDeleted = false;
  
  // Métodos helper
  void markForSync() { needsSync = true; }
  void markAsSynced() {
    needsSync = false;
    lastSyncedAt = DateTime.now();
  }
  
  // Conversão Firestore
  factory MinhaEntidade.fromFirestore({
    required String firestoreId,
    required Map<String, dynamic> data,
  }) {
    return MinhaEntidade(/*...*/);
  }
  
  Map<String, dynamic> toFirestoreMap() {
    return {/*...*/};
  }
}
```

### 2. Criar Repositório

```dart
class MinhaEntidadeRepository 
    implements BaseRepository<MinhaEntidade, MinhaEntidade> {
  
  late final Box<MinhaEntidade> _box;
  final CollectionReference _firestoreCollection =
      FirebaseFirestore.instance.collection('minha_colecao');
  
  MinhaEntidadeRepository() {
    _box = ObjectBoxStore.instance.store.box<MinhaEntidade>();
  }
  
  // Implementar métodos do BaseRepository
  @override
  Future<MinhaEntidade?> getById(int localId) async {
    return _box.get(localId);
  }
  
  // ... outros métodos
}
```

### 3. Adicionar ao SyncService

```dart
// Em sync_service.dart, adicione ao método syncNow():
await _minhaEntidadeRepository.fullSync();
```

### 4. Gerar código

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Uso nos Widgets

### Exemplo: Buscar e Exibir

```dart
class MeuWidget extends StatefulWidget {
  @override
  _MeuWidgetState createState() => _MeuWidgetState();
}

class _MeuWidgetState extends State<MeuWidget> {
  final _personRepository = PersonRepository();
  List<PersonEntity> _persons = [];
  
  @override
  void initState() {
    super.initState();
    _loadPersons();
  }
  
  Future<void> _loadPersons() async {
    final persons = await _personRepository.getAll();
    setState(() {
      _persons = persons;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _persons.length,
      itemBuilder: (context, index) {
        final person = _persons[index];
        return ListTile(
          title: Text(person.displayName ?? ''),
          subtitle: Text(person.email ?? ''),
        );
      },
    );
  }
}
```

### Exemplo: Criar/Atualizar

```dart
Future<void> _savePerson() async {
  final person = PersonEntity(
    displayName: _nameController.text,
    email: _emailController.text,
    cpf: _cpfController.text,
  );
  
  await _personRepository.save(person);
  // Retorna instantaneamente!
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Salvo localmente!')),
  );
}
```

## Sincronização Manual

```dart
// Força sincronização imediata
await SyncService.instance.syncNow();

// Verifica status
final isOnline = SyncService.instance.isOnline;
final isSyncing = SyncService.instance.isSyncing;
```

## Benefícios

1. **Offline-First**: App funciona sem internet
2. **Performance**: Leituras instantâneas do banco local
3. **UX Melhorada**: Sem delays de rede nas operações
4. **Sync Automático**: Dados sincronizam em background
5. **Resiliente**: Retry automático em falhas
6. **Escalável**: Fácil adicionar novas entidades

## Próximos Passos

1. Criar entidades para outros records do Firestore:
   - PropriedadesEntity
   - AnimaisProdutoresEntity
   - TecnicoEntity
   - ProdutorEntity
   - etc.

2. Implementar repositórios correspondentes

3. Adicionar repositórios ao SyncService

4. Migrar widgets para usar repositórios em vez de Firestore direto

5. Implementar UI de status de sincronização

6. Adicionar tratamento de conflitos (se necessário)
