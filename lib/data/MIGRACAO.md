# Guia de Migração: Firestore → ObjectBox

Este guia mostra como migrar o código existente que usa Firestore diretamente para usar os repositórios ObjectBox local-first.

## 📋 Estratégia de Migração

### Abordagem Recomendada: **Migração Gradual**

Não precisa migrar tudo de uma vez! Migre tela por tela, priorizando:
1. ✅ Telas de listagem (lista de animais, propriedades)
2. ✅ Telas de formulário (cadastro, edição)
3. ✅ Telas de dashboard (visão geral)

---

## 🔄 Padrões de Migração

### 1. Listagem Simples

#### ❌ Antes (Firestore direto)
```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ListaAnimaisWidget extends StatefulWidget {
  @override
  _ListaAnimaisWidgetState createState() => _ListaAnimaisWidgetState();
}

class _ListaAnimaisWidgetState extends State<ListaAnimaisWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tecnico')
          .doc(tecnicoId)
          .collection('propriedades')
          .doc(propriedadeId)
          .collection('animais_produtores')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        
        if (!snapshot.hasData) {
          return Text('Nenhum animal');
        }
        
        final animais = snapshot.data!.docs
            .map((doc) => AnimaisProdutoresRecord.fromSnapshot(doc))
            .toList();
        
        return ListView.builder(
          itemCount: animais.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(animais[index].nomeAnimal),
            );
          },
        );
      },
    );
  }
}
```

#### ✅ Depois (ObjectBox local-first)
```dart
import 'package:tecmuu/data/index.dart';

class ListaAnimaisWidget extends StatefulWidget {
  final String propriedadeRef;
  
  const ListaAnimaisWidget({Key? key, required this.propriedadeRef}) : super(key: key);
  
  @override
  _ListaAnimaisWidgetState createState() => _ListaAnimaisWidgetState();
}

class _ListaAnimaisWidgetState extends State<ListaAnimaisWidget> {
  final _animaisRepo = AnimaisProdutoresRepository();
  List<AnimaisProdutoresEntity> _animais = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadAnimais();
  }
  
  Future<void> _loadAnimais() async {
    setState(() => _isLoading = true);
    
    // INSTANTÂNEO! Busca do banco local
    final animais = await _animaisRepo.getByPropriedade(widget.propriedadeRef);
    
    setState(() {
      _animais = animais;
      _isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (_animais.isEmpty) {
      return Center(child: Text('Nenhum animal'));
    }
    
    return RefreshIndicator(
      onRefresh: _loadAnimais,
      child: ListView.builder(
        itemCount: _animais.length,
        itemBuilder: (context, index) {
          final animal = _animais[index];
          return ListTile(
            title: Text(animal.nomeAnimal ?? ''),
            subtitle: Text('Brinco: ${animal.brincoAnimal}'),
            trailing: animal.needsSync 
                ? Icon(Icons.sync, color: Colors.orange)
                : Icon(Icons.check, color: Colors.green),
          );
        },
      ),
    );
  }
}
```

**Benefícios:**
- ✅ 200x mais rápido (1ms vs 200ms)
- ✅ Funciona offline
- ✅ Menos código (sem StreamBuilder complexo)
- ✅ Pull-to-refresh nativo

---

### 2. Buscar Item Único

#### ❌ Antes
```dart
// Buscar técnico do usuário atual
final tecnicoSnapshot = await FirebaseFirestore.instance
    .collection('tecnico')
    .where('uidPerson', isEqualTo: currentUserUid)
    .limit(1)
    .get();

if (tecnicoSnapshot.docs.isEmpty) {
  // Não encontrado
  return;
}

final tecnico = TecnicoRecord.fromSnapshot(tecnicoSnapshot.docs.first);
print('Limite produtores: ${tecnico.limiteProdutoresContratado}');
```

#### ✅ Depois
```dart
// Buscar técnico do usuário atual
final tecnico = await TecnicoRepository().getByUidPerson(currentUserUid);

if (tecnico == null) {
  // Não encontrado
  return;
}

print('Limite produtores: ${tecnico.limiteProdutoresContratado}');
```

---

### 3. Criar Novo Item

#### ❌ Antes
```dart
// Criar novo animal
await FirebaseFirestore.instance
    .collection('tecnico')
    .doc(tecnicoId)
    .collection('propriedades')
    .doc(propriedadeId)
    .collection('animais_produtores')
    .add({
      'brincoAnimal': 12345,
      'nomeAnimal': 'Mimosa',
      'racaAnimal': 'Holandês',
      'status': 'ativa',
    });

ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Animal cadastrado!')),
);
```

#### ✅ Depois
```dart
// Criar novo animal
final animal = AnimaisProdutoresEntity(
  brincoAnimal: 12345,
  nomeAnimal: 'Mimosa',
  racaAnimal: 'Holandês',
  status: 'ativa',
  parentReference: 'tecnico/$tecnicoId/propriedades/$propriedadeId',
  uidTecnicoPropriedade: 'tecnico/$tecnicoId/propriedades/$propriedadeId',
);

// Salva INSTANTANEAMENTE no local
await AnimaisProdutoresRepository().save(animal);

// Sincroniza em background automaticamente!
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Animal cadastrado! Sincronizando...')),
);
```

---

### 4. Atualizar Item

#### ❌ Antes
```dart
// Atualizar animal
await FirebaseFirestore.instance
    .collection('tecnico')
    .doc(tecnicoId)
    .collection('propriedades')
    .doc(propriedadeId)
    .collection('animais_produtores')
    .doc(animalId)
    .update({
      'nomeAnimal': 'Novo Nome',
      'status': 'prenha',
    });
```

#### ✅ Depois
```dart
// Buscar animal
final animal = await AnimaisProdutoresRepository()
    .getByBrinco(12345);

if (animal != null) {
  // Atualizar
  animal.nomeAnimal = 'Novo Nome';
  animal.status = 'prenha';
  
  // Salva instantaneamente
  await AnimaisProdutoresRepository().save(animal);
}
```

---

### 5. Deletar Item

#### ❌ Antes
```dart
// Deletar animal
await FirebaseFirestore.instance
    .collection('tecnico')
    .doc(tecnicoId)
    .collection('propriedades')
    .doc(propriedadeId)
    .collection('animais_produtores')
    .doc(animalId)
    .delete();
```

#### ✅ Depois
```dart
// Deletar animal (soft delete)
final animal = await AnimaisProdutoresRepository()
    .getByBrinco(12345);

if (animal != null) {
  await AnimaisProdutoresRepository().delete(animal.id);
  // Marca como deletado localmente e sincroniza a deleção
}
```

---

## 🎯 Checklist de Migração Por Tela

### Para cada tela que você migrar:

- [ ] **Identificar queries Firestore**
  - Buscar `FirebaseFirestore.instance`
  - Buscar `StreamBuilder<QuerySnapshot>`
  - Buscar `.snapshots()`, `.get()`, `.add()`, `.update()`, `.delete()`

- [ ] **Importar repositório**
  ```dart
  import 'package:tecmuu/data/index.dart';
  ```

- [ ] **Substituir StreamBuilder por StatefulWidget + initState**
  - Criar método `_loadData()`
  - Chamar no `initState()`
  - Adicionar `RefreshIndicator` para pull-to-refresh

- [ ] **Substituir queries**
  - `.getAll()` para listar todos
  - `.getByXxx()` para filtrar
  - `.save()` para criar/atualizar
  - `.delete()` para remover

- [ ] **Testar offline**
  - Desligar WiFi
  - Verificar se funciona
  - Reconectar e ver sincronização

- [ ] **Verificar indicadores de sincronização**
  - Mostrar `needsSync` com ícone laranja
  - Adicionar status online/offline no AppBar

---

## 📦 Entidades Disponíveis

| Firestore Collection | ObjectBox Entity | Repository |
|---------------------|------------------|------------|
| `person` | `PersonEntity` | `PersonRepository()` |
| `tecnico` | `TecnicoEntity` | `TecnicoRepository()` |
| `produtor` | `ProdutorEntity` | `ProdutorRepository()` |
| `propriedades` | `PropriedadesEntity` | `PropriedadesRepository()` |
| `animais_produtores` | `AnimaisProdutoresEntity` | `AnimaisProdutoresRepository()` |

---

## 🔍 Métodos Especializados dos Repositórios

### PersonRepository
```dart
final repo = PersonRepository();

await repo.getAll();              // Todos os persons
await repo.getByUid(uid);         // Por UID
await repo.getByEmpresa(empresa); // Por empresa
```

### TecnicoRepository
```dart
final repo = TecnicoRepository();

await repo.getAll();                    // Todos os técnicos
await repo.getByUidPerson(uidPerson);   // Por UID da pessoa
await repo.getLiberados();              // Apenas liberados
```

### ProdutorRepository
```dart
final repo = ProdutorRepository();

await repo.getAll();                    // Todos os produtores
await repo.getByUidPerson(uidPerson);   // Por UID da pessoa
await repo.getByTecnico(uidTecnico);    // Por técnico
await repo.getLiberados();              // Apenas liberados
```

### PropriedadesRepository
```dart
final repo = PropriedadesRepository();

await repo.getAll();                // Todos as propriedades
await repo.getByTecnico(tecnicoRef); // Por técnico
await repo.getByProdutor(produtorRef); // Por produtor
await repo.getByCpf(cpf);           // Por CPF
```

### AnimaisProdutoresRepository
```dart
final repo = AnimaisProdutoresRepository();

await repo.getAll();                      // Todos os animais
await repo.getByPropriedade(propriedadeRef); // Por propriedade
await repo.getByBrinco(brinco);           // Por brinco
await repo.getByStatus(status);           // Por status
```

---

## 🚀 Começando a Migração

### Passo 1: Escolher uma tela simples
Recomendado: Uma tela de listagem pequena

### Passo 2: Fazer backup
```bash
git checkout -b migracao-objectbox-lista-animais
```

### Passo 3: Migrar seguindo os exemplos acima

### Passo 4: Testar
- Funciona online? ✅
- Funciona offline? ✅
- Sincroniza quando reconecta? ✅

### Passo 5: Commit
```bash
git add .
git commit -m "Migrar lista de animais para ObjectBox"
```

### Passo 6: Repetir para outras telas

---

## ⚠️ Casos Especiais

### Subcoleções (ex: animais_produtores)
```dart
// ObjectBox não tem subcoleções nativas
// Usamos parentReference para manter hierarquia

// Salvar com parent reference
final animal = AnimaisProdutoresEntity(
  parentReference: 'tecnico/$tecnicoId/propriedades/$propriedadeId',
  // ... outros campos
);
await AnimaisProdutoresRepository().save(animal);

// Buscar por parent reference
final animais = await AnimaisProdutoresRepository()
    .getByPropriedade('tecnico/$tecnicoId/propriedades/$propriedadeId');
```

### DocumentReference
```dart
// Firestore usa DocumentReference
DocumentReference tecnicoRef = FirebaseFirestore.instance
    .collection('tecnico')
    .doc(tecnicoId);

// ObjectBox usa String (path do documento)
String tecnicoRef = 'tecnico/$tecnicoId';
```

### Timestamps
```dart
// Entity já tem campos DateTime nativos
@Property(type: PropertyType.date)
DateTime? createdTime;

// Firestore timestamps são convertidos automaticamente
```

---

## 💡 Dicas

1. **Não delete código Firestore imediatamente**
   - Comente o código antigo
   - Mantenha por algumas semanas
   - Delete depois que confirmar que funciona

2. **Use feature flags**
   ```dart
   const useObjectBox = true; // ou false para voltar ao Firestore
   
   if (useObjectBox) {
     // Código ObjectBox
   } else {
     // Código Firestore antigo
   }
   ```

3. **Monitore sincronização**
   ```dart
   // No AppBar ou em algum lugar visível
   if (SyncService.instance.isSyncing) {
     CircularProgressIndicator();
   }
   ```

4. **Force sync quando necessário**
   ```dart
   // Após operações críticas
   await SyncService.instance.syncNow();
   ```

---

## 📊 Progresso da Migração

Crie um arquivo `MIGRACAO_PROGRESS.md` para acompanhar:

```markdown
# Progresso da Migração ObjectBox

## ✅ Migrado
- [ ] Dashboard Técnico
- [ ] Lista de Propriedades
- [ ] Lista de Animais
- [ ] Cadastro de Animal
- [ ] Edição de Animal
- [ ] Prontuário do Animal

## 🔄 Em Progresso
- [ ] 

## ⏳ Pendente
- [ ] Todas as outras telas

## 📈 Estatísticas
- Telas migradas: 0/50
- Performance gain: N/A
- Bugs encontrados: 0
```

---

## ❓ Troubleshooting

### Erro: "ObjectBoxStore não foi inicializado"
**Solução**: Verificar se `ObjectBoxStore.init()` foi chamado no `main.dart`

### Dados não aparecem
**Solução**: Verificar se já foi feito o primeiro fetch do Firestore
```dart
await SyncService.instance.syncNow();
```

### Sincronização não funciona
**Solução**: Verificar conectividade
```dart
print('Online: ${SyncService.instance.isOnline}');
```

---

## 🎉 Resultado Final

Após migrar todas as telas:
- ✅ App 100x mais rápido
- ✅ Funciona offline
- ✅ Menos uso de dados móveis
- ✅ Melhor experiência do usuário
- ✅ Código mais limpo e testável
