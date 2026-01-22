# Template: Criar Nova Entidade ObjectBox

## Passo a Passo Completo

### 1️⃣ Criar Entidade ObjectBox

Arquivo: `lib/data/local/animais_produtores_entity.dart`

```dart
import 'package:objectbox/objectbox.dart';

/// Entidade local do ObjectBox para AnimaisProdutores
@Entity()
class AnimaisProdutoresEntity {
  @Id()
  int id = 0;

  @Unique()
  String? firestoreId;

  // Copie todos os campos do Firestore Record correspondente
  String? brincoAnimal;
  String? nomeAnimal;
  String? sexo;
  String? raca;
  
  @Property(type: PropertyType.date)
  DateTime? dataNascimento;
  
  String? propriedadeRef; // ID da propriedade
  String? status;
  bool? ativa;
  
  // Campos de controle
  @Property(type: PropertyType.date)
  DateTime? lastSyncedAt;
  bool needsSync = false;
  bool isDeleted = false;

  AnimaisProdutoresEntity({
    this.id = 0,
    this.firestoreId,
    this.brincoAnimal,
    this.nomeAnimal,
    this.sexo,
    this.raca,
    this.dataNascimento,
    this.propriedadeRef,
    this.status,
    this.ativa,
    this.lastSyncedAt,
    this.needsSync = false,
    this.isDeleted = false,
  });

  /// Cria a partir do Firestore
  factory AnimaisProdutoresEntity.fromFirestore({
    required String firestoreId,
    required Map<String, dynamic> data,
  }) {
    return AnimaisProdutoresEntity(
      firestoreId: firestoreId,
      brincoAnimal: data['brincoAnimal'] as String?,
      nomeAnimal: data['nomeAnimal'] as String?,
      sexo: data['sexo'] as String?,
      raca: data['raca'] as String?,
      dataNascimento: data['dataNascimento'] as DateTime?,
      propriedadeRef: data['propriedadeRef'] as String?,
      status: data['status'] as String?,
      ativa: data['ativa'] as bool?,
      lastSyncedAt: DateTime.now(),
      needsSync: false,
    );
  }

  /// Converte para Map do Firestore
  Map<String, dynamic> toFirestoreMap() {
    return {
      'brincoAnimal': brincoAnimal,
      'nomeAnimal': nomeAnimal,
      'sexo': sexo,
      'raca': raca,
      'dataNascimento': dataNascimento,
      'propriedadeRef': propriedadeRef,
      'status': status,
      'ativa': ativa,
    };
  }

  void markForSync() => needsSync = true;
  void markAsSynced() {
    needsSync = false;
    lastSyncedAt = DateTime.now();
  }
}
```

### 2️⃣ Criar Repositório

Arquivo: `lib/data/repositories/animais_produtores_repository.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../objectbox.g.dart';
import '../local/animais_produtores_entity.dart';
import '../objectbox_store.dart';
import 'base_repository.dart';

class AnimaisProdutoresRepository 
    implements BaseRepository<AnimaisProdutoresEntity, AnimaisProdutoresEntity> {
  
  late final Box<AnimaisProdutoresEntity> _box;
  final CollectionReference _firestoreCollection =
      FirebaseFirestore.instance.collection('animais_produtores');

  AnimaisProdutoresRepository() {
    _box = ObjectBoxStore.instance.store.box<AnimaisProdutoresEntity>();
  }

  @override
  Future<AnimaisProdutoresEntity?> getById(int localId) async {
    return _box.get(localId);
  }

  @override
  Future<AnimaisProdutoresEntity?> getByFirestoreId(String firestoreId) async {
    final query = _box
        .query(AnimaisProdutoresEntity_.firestoreId.equals(firestoreId))
        .build();
    final result = query.findFirst();
    query.close();
    return result;
  }

  @override
  Future<List<AnimaisProdutoresEntity>> getAll() async {
    final query = _box
        .query(AnimaisProdutoresEntity_.isDeleted.equals(false))
        .build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Busca animais por propriedade
  Future<List<AnimaisProdutoresEntity>> getByPropriedade(String propriedadeId) async {
    final query = _box
        .query(AnimaisProdutoresEntity_.propriedadeRef.equals(propriedadeId) &
            AnimaisProdutoresEntity_.isDeleted.equals(false))
        .build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Busca animais ativos
  Future<List<AnimaisProdutoresEntity>> getAtivos() async {
    final query = _box
        .query(AnimaisProdutoresEntity_.ativa.equals(true) &
            AnimaisProdutoresEntity_.isDeleted.equals(false))
        .build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Busca por brinco
  Future<AnimaisProdutoresEntity?> getByBrinco(String brinco) async {
    final query = _box
        .query(AnimaisProdutoresEntity_.brincoAnimal.equals(brinco) &
            AnimaisProdutoresEntity_.isDeleted.equals(false))
        .build();
    final result = query.findFirst();
    query.close();
    return result;
  }

  @override
  Future<int> save(AnimaisProdutoresEntity item) async {
    item.markForSync();
    final id = _box.put(item);
    
    syncWithFirestore().catchError((e) {
      print('Erro ao sincronizar animal: $e');
    });
    
    return id;
  }

  @override
  Future<List<int>> saveAll(List<AnimaisProdutoresEntity> items) async {
    for (final item in items) {
      item.markForSync();
    }
    final ids = _box.putMany(items);
    
    syncWithFirestore().catchError((e) {
      print('Erro ao sincronizar animais: $e');
    });
    
    return ids;
  }

  @override
  Future<void> delete(int localId) async {
    final animal = await getById(localId);
    if (animal != null) {
      animal.isDeleted = true;
      animal.markForSync();
      _box.put(animal);
      
      syncWithFirestore().catchError((e) {
        print('Erro ao sincronizar deleção de animal: $e');
      });
    }
  }

  @override
  Future<void> syncWithFirestore() async {
    final query = _box
        .query(AnimaisProdutoresEntity_.needsSync.equals(true))
        .build();
    final itemsToSync = query.find();
    query.close();

    for (final item in itemsToSync) {
      try {
        if (item.isDeleted) {
          if (item.firestoreId != null) {
            await _firestoreCollection.doc(item.firestoreId).delete();
          }
          _box.remove(item.id);
        } else {
          if (item.firestoreId != null) {
            await _firestoreCollection
                .doc(item.firestoreId)
                .update(item.toFirestoreMap());
          } else {
            final docRef = await _firestoreCollection.add(item.toFirestoreMap());
            item.firestoreId = docRef.id;
          }
          
          item.markAsSynced();
          _box.put(item);
        }
      } catch (e) {
        print('Erro ao sincronizar item ${item.id}: $e');
      }
    }
  }

  @override
  Future<void> fetchFromFirestore() async {
    try {
      final snapshot = await _firestoreCollection.get();
      
      for (final doc in snapshot.docs) {
        final firestoreId = doc.id;
        final data = doc.data() as Map<String, dynamic>;
        
        final existingQuery = _box
            .query(AnimaisProdutoresEntity_.firestoreId.equals(firestoreId))
            .build();
        final existing = existingQuery.findFirst();
        existingQuery.close();
        
        if (existing != null) {
          if (!existing.needsSync) {
            final updated = AnimaisProdutoresEntity.fromFirestore(
              firestoreId: firestoreId,
              data: data,
            );
            updated.id = existing.id;
            _box.put(updated);
          }
        } else {
          final newEntity = AnimaisProdutoresEntity.fromFirestore(
            firestoreId: firestoreId,
            data: data,
          );
          _box.put(newEntity);
        }
      }
    } catch (e) {
      print('Erro ao buscar animais do Firestore: $e');
      rethrow;
    }
  }

  Future<void> fullSync() async {
    await fetchFromFirestore();
    await syncWithFirestore();
  }
}
```

### 3️⃣ Adicionar ao SyncService

Edite `lib/data/sync/sync_service.dart`:

```dart
// No topo do arquivo, adicione o import:
import '../repositories/animais_produtores_repository.dart';

// Na classe SyncService, adicione:
final AnimaisProdutoresRepository _animaisRepository = AnimaisProdutoresRepository();

// No método syncNow(), adicione:
await _animaisRepository.fullSync();
```

### 4️⃣ Exportar no index.dart

Edite `lib/data/index.dart`:

```dart
// Adicione:
export 'local/animais_produtores_entity.dart';
export 'repositories/animais_produtores_repository.dart';
```

### 5️⃣ Gerar Código ObjectBox

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 6️⃣ Usar no Widget

```dart
import 'package:tecmuu/data/index.dart';

class MinhaTelaAnimais extends StatefulWidget {
  @override
  _MinhaTelaAnimaisState createState() => _MinhaTelaAnimaisState();
}

class _MinhaTelaAnimaisState extends State<MinhaTelaAnimais> {
  final _repository = AnimaisProdutoresRepository();
  List<AnimaisProdutoresEntity> _animais = [];

  @override
  void initState() {
    super.initState();
    _loadAnimais();
  }

  Future<void> _loadAnimais() async {
    // Busca instantânea do banco local!
    final animais = await _repository.getAll();
    setState(() => _animais = animais);
  }

  Future<void> _addAnimal() async {
    final animal = AnimaisProdutoresEntity(
      brincoAnimal: '12345',
      nomeAnimal: 'Mimosa',
      sexo: 'F',
      raca: 'Holandês',
      ativa: true,
    );
    
    await _repository.save(animal);
    await _loadAnimais();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animais')),
      body: ListView.builder(
        itemCount: _animais.length,
        itemBuilder: (context, index) {
          final animal = _animais[index];
          return ListTile(
            title: Text(animal.nomeAnimal ?? 'Sem nome'),
            subtitle: Text('Brinco: ${animal.brincoAnimal}'),
            trailing: animal.needsSync
                ? Icon(Icons.sync, color: Colors.orange)
                : Icon(Icons.check, color: Colors.green),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAnimal,
        child: Icon(Icons.add),
      ),
    );
  }
}
```

## 🎯 Checklist para Nova Entidade

- [ ] Criar `lib/data/local/minha_entidade.dart` com @Entity()
- [ ] Criar `lib/data/repositories/minha_entidade_repository.dart`
- [ ] Adicionar repositório ao `SyncService`
- [ ] Exportar no `lib/data/index.dart`
- [ ] Executar `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Testar com `flutter analyze lib/data`
- [ ] Usar no widget

## 💡 Dicas

### Tipos de Dados Especiais

```dart
// DateTime
@Property(type: PropertyType.date)
DateTime? minhaData;

// List<String>
List<String> minhaLista = []; // ObjectBox suporta nativamente

// Relacionamentos (ToOne)
final propriedade = ToOne<PropriedadeEntity>();

// Relacionamentos (ToMany)
@Backlink('animal')
final tratamentos = ToMany<TratamentoEntity>();
```

### Índices para Performance

```dart
// Índice único
@Unique()
String? cpf;

// Índice para buscas rápidas
@Index()
String? status;
```

### Queries Complexas

```dart
// AND
final query = box.query(
  Entity_.campo1.equals('valor1') & 
  Entity_.campo2.equals('valor2')
).build();

// OR
final query = box.query(
  Entity_.campo1.equals('valor1') | 
  Entity_.campo2.equals('valor2')
).build();

// LIKE
final query = box.query(
  Entity_.nome.contains('busca', caseSensitive: false)
).build();

// Ordenação
final query = box.query(Entity_.nome.notNull())
  .order(Entity_.nome)
  .build();

// Limite
final results = query.find(limit: 10);
```

## ⚠️ Importante

1. **Sempre feche queries**: `query.close()`
2. **Sempre mark para sync**: Antes de salvar alterações
3. **Use try-catch**: Em operações Firestore
4. **Teste offline**: Desligue wifi e teste o app
5. **Monitore logs**: "Sincronização concluída" deve aparecer

## 📚 Recursos

- [ObjectBox Dart Docs](https://docs.objectbox.io/getting-started)
- [Query Examples](https://docs.objectbox.io/queries)
- [Relations](https://docs.objectbox.io/relations)
