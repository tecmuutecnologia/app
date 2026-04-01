# Guia de Implementação - ObjectBox com Firestore

## Visão Geral

Este guia explica como foi implementada a integração do ObjectBox como banco de dados offline local, trabalhando em conjunto com o Firestore para sincronização na nuvem.

## Arquitetura

```
┌─────────────────────────────────────────────────────────────┐
│                        Aplicativo                           │
├─────────────────────────────────────────────────────────────┤
│                     Repositories                            │
│         (AnimalRepository, PropriedadeRepository, etc)      │
├─────────────────────────────────────────────────────────────┤
│     ObjectBox (Local)          ←→       SyncService         │
│     - Leitura rápida                    - Sincronização     │
│     - Funciona offline                  - Fila de pendências│
├─────────────────────────────────────────────────────────────┤
│                        Firestore                            │
│                  (Fonte de verdade)                         │
└─────────────────────────────────────────────────────────────┘
```

## Estrutura de Arquivos

```
lib/backend/objectbox/
├── entities/
│   ├── animal_entity.dart          # Entidade Animal
│   ├── person_entity.dart          # Entidade Person
│   ├── produtor_entity.dart        # Entidade Produtor
│   ├── propriedade_entity.dart     # Entidade Propriedade
│   ├── tecnico_entity.dart         # Entidade Técnico
│   ├── sync_metadata_entity.dart   # Metadados de sincronização
│   └── index.dart                  # Exportações
├── repositories/
│   ├── animal_repository.dart      # Repositório de Animais
│   └── index.dart
├── widgets/
│   ├── sync_status_widget.dart     # Widget de status
│   └── index.dart
├── objectbox_service.dart          # Serviço principal do ObjectBox
├── sync_service.dart               # Serviço de sincronização
├── objectbox_auth_helper.dart      # Helper de autenticação
└── index.dart                      # Exportações principais
```

## Passos para Completar a Implementação

### 1. Instalar Dependências

Execute no terminal:

```bash
cd /Users/tecmuu/Desktop/tecmuu
flutter pub get
```

### 2. Gerar Código do ObjectBox

O ObjectBox precisa gerar código automaticamente. Execute:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Isso criará o arquivo `lib/backend/objectbox.g.dart` com as classes auxiliares.

### 3. Configurar iOS (se necessário)

No arquivo `ios/Podfile`, certifique-se de ter a versão mínima do iOS:

```ruby
platform :ios, '12.0'
```

### 4. Configurar Android (se necessário)

No arquivo `android/app/build.gradle`, verifique o minSdkVersion:

```gradle
defaultConfig {
    minSdkVersion 21  // Mínimo para ObjectBox
}
```

## Como Usar

### Acessando Dados Offline

```dart
import 'package:tecmuu/backend/objectbox/index.dart';

// Em qualquer widget ou página
final animalRepo = AnimalRepository();

// Buscar animais de uma propriedade
final animais = animalRepo.getAnimaisByPropriedade('produtor/xyz/propriedades/abc');

// Criar um novo animal (funciona offline!)
final novoAnimal = await animalRepo.create(
  propriedadePath: 'produtor/xyz/propriedades/abc',
  data: {
    'nomeAnimal': 'Mimosa',
    'racaAnimal': 'Holandesa',
    'status': 'Ativo',
  },
);

// Buscar animais
final resultados = animalRepo.search('Mimosa');

// Stream reativo (atualiza automaticamente a UI)
animalRepo.watchAnimaisByPropriedade('path').listen((animais) {
  // Atualiza UI
});
```

### Exibindo Status de Sincronização

```dart
import 'package:tecmuu/backend/objectbox/widgets/sync_status_widget.dart';

// Na AppBar
AppBar(
  title: Text('Animais'),
  actions: [
    SyncStatusIcon(), // Mostra ícone de status
  ],
)

// Em qualquer lugar da tela
SyncStatusIndicator() // Mostra badge com status
```

### Sincronização Manual

```dart
import 'package:tecmuu/backend/objectbox/index.dart';

// Forçar sincronização
await ObjectBoxAuthHelper.forceSync(userId);

// Ver operações pendentes
final pendentes = ObjectBoxAuthHelper.getPendingOperationsCount();
```

### Integrar com Login/Logout

No seu código de autenticação:

```dart
// Após login bem-sucedido
await ObjectBoxAuthHelper.onUserLogin(firebaseUser);

// Antes/após logout
await ObjectBoxAuthHelper.onUserLogout(userId);
```

## Fluxo de Sincronização

### Online

1. **Leitura**: Primeiro ObjectBox, depois Firestore se necessário
2. **Escrita**: Salva no ObjectBox, depois envia ao Firestore
3. **Atualização**: Sincroniza incrementalmente

### Offline

1. **Leitura**: Apenas do ObjectBox (instantâneo!)
2. **Escrita**: Salva no ObjectBox + adiciona à fila de pendências
3. **Reconexão**: Sincroniza fila automaticamente

## Benefícios

1. **Performance**: Leitura local é muito mais rápida
2. **Offline**: App funciona sem internet
3. **Custo**: Reduz leituras no Firestore ($$)
4. **UX**: Dados aparecem instantaneamente
5. **Sincronização**: Dados disponíveis em qualquer dispositivo

## Próximos Passos

1. **Criar mais repositórios**: Implemente repositórios para Propriedade, Produtor, etc.
2. **Migrar queries**: Substitua gradualmente as queries diretas ao Firestore pelos repositórios
3. **Adicionar indicadores**: Use `SyncStatusWidget` nas telas principais
4. **Testar offline**: Desabilite a internet e teste o funcionamento

## Troubleshooting

### Erro: "objectbox.g.dart not found"

Execute:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Erro: "Store is null"

Certifique-se de inicializar o ObjectBox no `main.dart` antes de usar.

### Dados não sincronizam

1. Verifique a conexão com a internet
2. Verifique se há operações pendentes: `getPendingOperationsCount()`
3. Force sincronização: `forceSync(userId)`

## Considerações de Segurança

- Os dados são armazenados localmente sem criptografia
- Para dados sensíveis, considere usar `objectbox_sync_flutter` com criptografia
- Os dados persistem mesmo após reinstalação (a menos que o usuário limpe dados do app)
