# Guia de Arquitetura Offline-First com ObjectBox

## Visão Geral

O aplicativo Tecmuu utiliza uma arquitetura **offline-first** com ObjectBox como banco de dados local e Firestore como fonte de verdade na nuvem.

### Fluxo de Dados

```
┌──────────────────────────────────────────────────────────────────┐
│                          LOGIN                                    │
├──────────────────────────────────────────────────────────────────┤
│  1. Usuário faz login                                            │
│  2. Verifica se é primeiro acesso ou dispositivo novo            │
│  3. Se sim: Download completo do Firestore → ObjectBox           │
│  4. Se não: Usa dados locais e sincroniza pendências             │
└──────────────────────────────────────────────────────────────────┘
                               ↓
┌──────────────────────────────────────────────────────────────────┐
│                      USO DO APP (Offline-First)                  │
├──────────────────────────────────────────────────────────────────┤
│  • Lê dados do ObjectBox (rápido, sempre disponível)             │
│  • Escreve no ObjectBox com needsSync = true                     │
│  • Funciona 100% offline                                         │
└──────────────────────────────────────────────────────────────────┘
                               ↓
┌──────────────────────────────────────────────────────────────────┐
│                      SINCRONIZAÇÃO                               │
├──────────────────────────────────────────────────────────────────┤
│  • Quando online: envia alterações (needsSync=true) ao Firestore │
│  • Sincronização periódica (a cada 5 minutos)                    │
│  • Ao reconectar: sincroniza automaticamente                     │
│  • Ao trocar dispositivo: download completo                      │
└──────────────────────────────────────────────────────────────────┘
```

## Estrutura de Arquivos

```
lib/backend/objectbox/
├── entities/                        # Entidades ObjectBox
│   ├── index.dart                   # Exportações
│   ├── person_entity.dart           # Usuário
│   ├── tecnico_entity.dart          # Técnico
│   ├── produtor_entity.dart         # Produtor
│   ├── propriedade_entity.dart      # Propriedade
│   ├── animal_entity.dart           # Animal
│   ├── acao_entity.dart             # Ações (inseminação, etc.)
│   ├── acao_da_visita_entity.dart   # Ações da visita
│   ├── tratamento_entity.dart       # Tratamentos e ações sanitárias
│   ├── financeiro_entity.dart       # Dados financeiros
│   ├── visita_entities.dart         # Resumo e recomendações
│   ├── reference_entities.dart      # Tabelas de referência
│   └── sync_metadata_entity.dart    # Metadados de sincronização
│
├── objectbox_service.dart           # Singleton do ObjectBox Store
├── offline_first_sync_service.dart  # Serviço principal de sincronização
├── sync_service.dart                # Serviço legado (compatibilidade)
├── objectbox_auth_helper.dart       # Integração com autenticação
│
├── repositories/                    # Repositórios (camada de abstração)
│   └── ...
│
├── widgets/                         # Widgets de UI para sincronização
│   ├── sync_status_widget.dart      # Indicador de status legado
│   └── sync_widgets.dart            # Widgets offline-first
│
└── index.dart                       # Exportações do módulo
```

## Uso

### Inicialização (main.dart)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initFirebase();
  
  // Inicializa ObjectBox para armazenamento offline-first
  if (!kIsWeb) {
    await ObjectBoxAuthHelper.initializeOfflineFirst();
  }
  
  runApp(MyApp());
}
```

### Após Login do Usuário

```dart
// No firebase_auth_manager.dart ou onde trata o login
Future<void> onLoginSuccess(User user) async {
  await ObjectBoxAuthHelper.onUserLogin(user);
}
```

### Lendo Dados Locais

```dart
import 'package:tecmuu/backend/objectbox/index.dart';

// Obter todos os animais
final animais = ObjectBoxService.instance.animalBox.getAll();

// Filtrar por propriedade
final query = ObjectBoxService.instance.animalBox
    .query(AnimalEntity_.parentPath.equals(propriedadePath))
    .build();
final animaisPropriedade = query.find();
query.close();
```

### Salvando Dados (Offline-First)

```dart
// Criar ou atualizar um animal
final animal = AnimalEntity(
  nome: 'Mimosa',
  brinco: '001',
  parentPath: '/produtor/xxx/propriedades/yyy',
);

// Marca para sincronização quando online
animal.markAsModified(currentUserId);

// Salva localmente
ObjectBoxService.instance.animalBox.put(animal);

// A sincronização acontece automaticamente quando online
```

### Sincronização Manual

```dart
// Forçar sincronização de alterações pendentes
await ObjectBoxAuthHelper.syncPendingChanges();

// Forçar download completo (cuidado: sobrescreve dados locais)
await ObjectBoxAuthHelper.forceFullSync(userId);
```

### Verificando Status de Conexão

```dart
// Verificar se está online
final isOnline = ObjectBoxAuthHelper.isOnline;

// Contar operações pendentes
final pendingCount = ObjectBoxAuthHelper.getPendingOperationsCount();
```

### Widgets de UI

```dart
// Indicador de status de sincronização
StreamBuilder<SyncStatus>(
  stream: ObjectBoxAuthHelper.syncStatusStream,
  builder: (context, snapshot) {
    return OfflineFirstSyncStatusIndicator(
      status: snapshot.data ?? SyncStatus.idle,
    );
  },
)

// Banner de conexão com botão de sincronização
ConnectionStatusBanner(
  isOnline: ObjectBoxAuthHelper.isOnline,
  syncStatus: currentStatus,
  pendingOperations: ObjectBoxAuthHelper.getPendingOperationsCount(),
  onSync: () => ObjectBoxAuthHelper.syncPendingChanges(),
)
```

## Entidades Disponíveis

| Entidade | Coleção Firestore | Descrição |
|----------|-------------------|-----------|
| `PersonEntity` | person | Dados do usuário |
| `TecnicoEntity` | tecnico | Dados do técnico |
| `ProdutorEntity` | produtor | Dados do produtor |
| `PropriedadeEntity` | propriedades (sub) | Propriedades rurais |
| `AnimalEntity` | animaisProdutores (sub) | Animais do rebanho |
| `AcaoEntity` | acoes (sub) | Ações reprodutivas |
| `AcaoDaVisitaEntity` | acoes_da_visita (sub) | Ações da visita |
| `TratamentoEntity` | tratamentos (sub) | Tratamentos aplicados |
| `AcaoSanitarioEntity` | acoes_sanitario (sub) | Ações sanitárias |
| `FinanceiroEntity` | financeiro (sub) | Dados financeiros |
| `ResumoVisitaEntity` | resumo_da_visita (sub) | Resumo de visitas |
| `RecomendacaoEntity` | recomendacoes (sub) | Recomendações |
| `GrupoEntity` | grupo | Grupos de animais |
| `RacaEntity` | racas | Raças |
| `StatusAnimalEntity` | status_animais | Status dos animais |
| `StatusProdutivoEntity` | status_produtivo | Status produtivo |
| `TipoAcaoEntity` | tipo_acoes | Tipos de ações |
| `CalendarioSanitarioEntity` | calendario_sanitario | Calendário sanitário |
| `CidadeEntity` | cidades | Cidades |

## Campos de Sincronização

Todas as entidades principais possuem os seguintes campos para controle de sincronização:

```dart
@Unique()
String? firestoreId;     // ID do documento no Firestore

String? parentPath;      // Path do documento pai (para subcoleções)

@Property(type: PropertyType.date)
DateTime? lastSynced;    // Última sincronização com Firestore

@Property(type: PropertyType.date)
DateTime? lastModified;  // Última modificação local

bool needsSync;          // true = precisa enviar ao Firestore
```

## Padrão de Entidade

```dart
@Entity()
class ExemploEntity {
  @Id()
  int id = 0;

  @Unique()
  String? firestoreId;

  String? parentPath;

  // ... campos de dados ...

  @Property(type: PropertyType.date)
  DateTime? lastSynced;

  bool needsSync;

  ExemploEntity({
    this.firestoreId,
    this.parentPath,
    // ...
    this.needsSync = false,
  });

  factory ExemploEntity.fromFirestore(
    Map<String, dynamic> data,
    String docId,
    String parentPath,
  ) {
    return ExemploEntity(
      firestoreId: docId,
      parentPath: parentPath,
      // ... mapeamento de campos ...
      lastSynced: DateTime.now(),
      needsSync: false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      // ... campos para enviar ...
    };
  }

  void markAsModified(String userId) {
    lastModified = DateTime.now();
    needsSync = true;
  }
}
```

## Benefícios

1. **Velocidade**: Leitura instantânea do banco local
2. **Disponibilidade**: Funciona 100% offline
3. **Economia**: Reduz drasticamente leituras do Firestore
4. **Experiência**: App sempre responsivo
5. **Troca de dispositivo**: Dados baixados automaticamente

## Considerações

- **Conflitos**: Em caso de edição simultânea em dispositivos diferentes, a última alteração enviada prevalece
- **Espaço**: Dados ficam armazenados localmente (considere limpar dados antigos se necessário)
- **Primeira sincronização**: Pode demorar dependendo da quantidade de dados

## Comandos Úteis

```bash
# Regenerar código ObjectBox após modificar entidades
dart run build_runner build --delete-conflicting-outputs

# Limpar e regenerar
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```
