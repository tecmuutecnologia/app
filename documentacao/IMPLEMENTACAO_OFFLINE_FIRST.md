# 🚀 Sistema Offline-First - Guia de Implementação Completo

## 📦 O Que Foi Criado

### 1. **SyncDebuggerService** ✅
- Serviço de debug em tempo real
- Valida persistência local no ObjectBox
- Lista mudanças pendentes
- Força sincronização sob demanda
- Simula mudanças para testes

**Localização:** `lib/backend/objectbox/sync_debugger_service.dart`

### 2. **SyncDebuggerWidget** ✅
- Widget de debug visual
- 4 tabs: Testes, Dados, Status, Logs
- Interface interativa para validar sincronização
- Mostra eventos em tempo real

**Localização:** `lib/backend/objectbox/widgets/sync_debugger_widget.dart`

### 3. **RemoteSyncListenersService** ✅
- Listeners para mudanças remotas no Firestore
- Sincronização BIDIRECIONAL automática
- Resolução automática de conflitos (last-write-wins)
- Monitora Animais, Ações, Tratamentos

**Localização:** `lib/backend/objectbox/remote_sync_listeners_service.dart`

### 4. **Guia de Teste Completo** ✅
**Localização:** `documentacao/GUIA_TESTE_OFFLINE_FIRST.md`

---

## 🔧 Como Integrar

### Passo 1: Inicializar os Serviços

Abra seu `main.dart` e adicione:

```dart
import 'backend/objectbox/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ... seu código existente ...
  
  // Inicializa ObjectBox e sincronização
  if (!kIsWeb) {
    await ObjectBoxAuthHelper.initializeOfflineFirst();
    await SyncDebuggerService.initialize();
    await RemoteSyncListenersService.initialize();
  }

  runApp(MyApp());
}
```

### Passo 2: Adicionar Debug Widget (Desenvolvimento)

Abra sua página principal e adicione:

```dart
import 'backend/objectbox/widgets/sync_debugger_widget.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... seu conteúdo ...
      
      // Adicione no final do Stack:
      Stack(
        children: [
          // seu conteúdo principal
          // ...
          
          // Debug widget (remova antes de publicar!)
          if (kDebugMode)
            const SyncDebugger(),
        ],
      ),
    );
  }
}
```

### Passo 3: Ativar Listeners Remotos

Após fazer login do usuário:

```dart
// Em seu código de login
Future<void> onUserLogin(User user) async {
  // ... seu código existente ...
  
  // Ativa listeners para mudanças remotas
  final listenersService = RemoteSyncListenersService.instance;
  
  // Obtenha os paths das propriedades do usuário
  // e ative listeners para cada uma
  final propriedades = ObjectBoxService.instance.propriedadeBox.getAll();
  for (final prop in propriedades) {
    if (prop.firestoreId != null && prop.parentPath != null) {
      listenersService.listenToAnimalsChanges(
        '${prop.parentPath}/propriedades/${prop.firestoreId}',
      );
    }
  }
}
```

### Passo 4: Limpar Listeners ao Logout

```dart
Future<void> onUserLogout() async {
  // Remove todos os listeners
  RemoteSyncListenersService.instance.removeAllListeners();
  
  // Para sincronização periódica
  OfflineFirstSyncService.instance.stopPeriodicSync();
  
  // Limpa dados locais
  await ObjectBoxAuthHelper.onUserLogout(currentUser?.uid);
}
```

---

## 📱 Como Usar o Debug Widget

### Cenário 1: Validar Dados Locais (Offline)

1. **Ative Airplane Mode** no smartphone
2. **Registre uma ação** no app
3. **Abra Debug Widget** (botão roxo no canto)
4. **Tab "Testes"** → Teste 1 → Digite nome do animal
5. **Esperado:** ✅ "Animal salvo localmente"

### Cenário 2: Sincronizar (Online)

1. **Desative Airplane Mode**
2. **Tab "Testes"** → Teste 3 → Clique "Forçar Sincronização"
3. **Tab "Logs"** → Veja eventos de sincronização
4. **Firestore Console** → Verifique dados lá

### Cenário 3: Listar Dados em Cache

1. **Tab "Dados"** → Clique "Listar Animais"
2. **Veja quantidade em cache:**
   ```
   • Animal 1 (sync: false, id: abc123)
   • Animal 2 (sync: true, id: novo)
   ```

---

## 🔄 Fluxo de Sincronização

```
┌─────────────────────────────────────────────────────┐
│           Ação do Usuário (Local)                    │
│  - Cria/edita animal, ação ou tratamento            │
└──────────────────┬──────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────┐
│  ObjectBox (Banco Local)                            │
│  ✅ Salva IMEDIATAMENTE                             │
│  ✅ Marca needsSync = true                          │
└──────────────────┬──────────────────────────────────┘
                   │
                   ▼
        ┌──────────────────────┐
        │ Internet Disponível? │
        └──────────────┬──────┬─┘
                       │      │
                   SIM │      │ NÃO
                       │      │
         ┌─────────────▼─┐   │
         │  Firestore    │   │
         │  Upload ✅    │   │
         │ needsSync=false
         └─────────────────┘   │
                               │
                     ┌─────────▼──────┐
                     │ Fila Pendente  │
                     │ (retry auto)   │
                     └────────────────┘
```

---

## 🌐 Sincronização Bidirecional

```
Dispositivo A              Firestore              Dispositivo B
─────────────              ─────────              ─────────────

Edita Animal ──────────►  Animal v2  ◄────────── Edita Animal
  v1: 500kg                (v2)                    v3: 600kg

                 ┌─────────────────────┐
                 │ Listener ativa no   │
                 │ Dispositivo B       │
                 └────────────┬────────┘
                              │
                    ▼─────────▼────────▼
                    
          ObjectBox B recebe v2
          Se v2 é mais recente que local,
          atualiza automaticamente!
```

---

## ✅ Checklist de Testes

### Offline-First
- [ ] Dados salvos localmente quando registrados
- [ ] `needsSync = true` ao criar/editar
- [ ] Sem internet = sem erro, operação pendente

### Sincronização Upload
- [ ] Ao conectar, dados locais sobem para Firestore
- [ ] `needsSync = false` após sucesso
- [ ] FirestoreID preenchido para novos registros

### Sincronização Download
- [ ] Outro dispositivo modifica dado
- [ ] Mudança chega automaticamente via listener
- [ ] Timestamp mais recente vence em caso de conflito

### Reinstalar App
- [ ] Desinstala app
- [ ] Reinstala
- [ ] Faz login
- [ ] Dados voltam do Firestore (download completo)

### Performance
- [ ] App responde em < 100ms localmente
- [ ] Sincronização de 10 itens em < 5s
- [ ] 100+ registros não travam o app

---

## 🚨 Possíveis Problemas

### Problema 1: Dados não sincronizam
**Solução:**
```dart
// Verifique no Debug Widget - Tab "Testes"
// Teste 2: Listar Mudanças
// Se vazio, nada para sincronizar (normal)

// Se houver mudanças, teste Teste 3: Forçar Sincronização
```

### Problema 2: Dados não chegam do Firestore
**Solução:**
```dart
// Verifique if listener está ativo
print(RemoteSyncListenersService.instance.activeListenersCount);

// Ative listener manual
listenersService.listenToAnimalsChanges(
  'produtor/xyz/propriedades/abc'
);
```

### Problema 3: Conflito de edição
**Solução:**
```
A edita em 10:00
B edita em 10:05

Timestamp B (10:05) é mais recente = B vence!
Se B tem needsSync=true, é ignorado (prioriza local)
```

### Problema 4: ObjectBox cheio / Muito lento
**Solução:**
```dart
// Limpe dados antigos periodicamente
// Ou use paginação ao listar dados

// Debug Widget - Tab "Testes" - "Limpar Dados Locais"
```

---

## 📊 Métricas de Sucesso

| Métrica | Alvo | Teste |
|---------|------|-------|
| Latência local | < 100ms | Tab Dados → Listar Animais |
| Taxa sincronização | 100% | Tab Testes → Teste 3 |
| Tempo download inicial | < 30s | Reinstalar app + login |
| Listeners ativos | > 0 | `activeListenersCount` |
| Conflitos resolvidos | 100% | Cenário bidirecional |

---

## 🛠️ Comandos Úteis

```bash
# Ver logs em tempo real
flutter logs -d 9TCI6X596TWK9HAA

# Ver apenas logs da app
flutter logs -d 9TCI6X596TWK9HAA --grep "tecmuu\|flutter\|ObjectBox"

# Simular offline
adb shell svc wifi disable

# Simular online
adb shell svc wifi enable

# Limpar build
flutter clean && flutter pub get

# Recompilar
flutter run -d 9TCI6X596TWK9HAA --debug
```

---

## 📚 Referências

- **ObjectBox:** `lib/backend/objectbox/objectbox_service.dart`
- **Sync Service:** `lib/backend/objectbox/offline_first_sync_service.dart`
- **Debugger:** `lib/backend/objectbox/sync_debugger_service.dart`
- **Listeners:** `lib/backend/objectbox/remote_sync_listeners_service.dart`
- **Guia de Teste:** `documentacao/GUIA_TESTE_OFFLINE_FIRST.md`

---

## ⚡ Próximos Passos

1. **Implementar backoff exponencial** para retry de falhas
2. **Adicionar compressão** para sync de dados grandes
3. **Implementar soft delete** para melhor rastreabilidade
4. **Adicionar criptografia** para dados sensíveis em cache
5. **Criar dashboard** para monitorar status de sincronização

---

## 📞 Suporte

Se encontrar problemas:

1. Verifique o **Debug Widget** (Tab "Logs")
2. Confira `flutter logs` para erros
3. Abra **Firestore Console** para validar dados remotos
4. Siga o **GUIA_TESTE_OFFLINE_FIRST.md** passo a passo
