# 🔧 Guia de Debug - ObjectBox Admin

## 📋 Resumo

ObjectBox Admin é uma ferramenta web que permite inspecionar, editar e testar dados do ObjectBox em tempo real, direto no seu navegador.

---

## 🚀 Como Ativar

### Passo 1: Adicione a Dependência

```bash
cd /Users/tecmuu/Desktop/tecmuu
flutter pub add objectbox_flutter_admin
```

Ou adicione manualmente ao `pubspec.yaml`:

```yaml
dependencies:
  # ... outras dependências
  objectbox_flutter_admin: ^0.3.0  # ou versão mais recente
```

### Passo 2: Use o Debug Menu (Método Mais Fácil)

**Arquivo:** `lib/backend/objectbox/widgets/objectbox_debug_menu.dart`

Adicione uma rota debug ao seu app:

```dart
// lib/main.dart ou seu arquivo de rotas

// Adicione ao seu gerenciador de rotas (GoRouter, etc)
GoRoute(
  path: '/debug/objectbox',
  builder: (context, state) => const ObjectBoxDebugMenu(),
),
```

Ou crie um botão secreto em desenvolvimento:

```dart
// Em qualquer página
GestureDetector(
  onLongPress: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ObjectBoxDebugMenu(),
      ),
    );
  },
  child: Text('DEBUG BASE'),
)
```

### Passo 3: Abra o Debug Menu

```bash
$ flutter run
→ Clique no botão secreto ou navegue para /debug/objectbox
→ Clique em "Iniciar Admin (localhost:8090)"
```

### Passo 4: Acesse ObjectBox Admin

Abra seu navegador PC/Mac:

```
http://localhost:8090
```

---

## 🎯 Usando ObjectBox Admin

### Tela Principal

```
┌─────────────────────────────────────────────┐
│ ObjectBox Admin                             │
├─────────────────────────────────────────────┤
│ 📦 Collections (Tabelas)                    │
│  ├─ Person                                  │
│  ├─ Animal                                  │
│  ├─ Propriedade                             │
│  ├─ UserSession                             │
│  └─ ... outras                              │
│                                             │
│ 🔍 Inspector                                │
│  ├─ Ver registros                          │
│  ├─ Editar dados                           │
│  ├─ Deletar registros                      │
│  └─ Testar queries                         │
└─────────────────────────────────────────────┘
```

### Navegação

1. **Selecionar Tabela** - Clique em uma collection
2. **Ver Dados** - Veja todos os registros
3. **Editar** - Clique em um registro e modifique
4. **Pesquisar** - Use filtros e queries
5. **Recarregar** - Atualize dados em tempo real

---

## 🔧 Ferramentas do Debug Menu

### 1. Iniciar Admin (localhost:8090)

```
✅ Botão: "Iniciar Admin (localhost:8090)"
→ Abre ferramenta web no navegador
→ Funciona enquanto app está rodando
→ Conexão local apenas (seguro)
```

### 2. Exibir Estatísticas

```
✅ Botão: "Exibir Estatísticas (Console)"
→ Exibe no console:
   👤 Pessoas: 15
   👨‍🌾 Técnicos: 3
   👨‍🚜 Produtores: 5
   🏠 Propriedades: 8
   🐄 Animais: 145
   📱 Sessões Ativas: 2
```

### 3. Exibir Sessões

```
✅ Botão: "Exibir Sessões (Console)"
→ Exibe todas as sessões de usuário:
   📧 Email: user@example.com
   Firebase UID: xyz123
   Ativa: ✅
   Último Login: 2026-06-01 10:30:00
```

### 4. Exportar JSON

```
✅ Botão: "Exportar JSON Debug (Console)"
→ Exibe todos os dados em JSON:
   {
     "timestamp": "2026-06-01T10:30:00",
     "stats": { ... },
     "sessoes": [ ... ]
   }
```

### 5. Limpar Sessões

```
⚠️ Botão: "Limpar Todas as Sessões"
→ Remove TODAS as sessões de usuário
→ Users terão que fazer login novamente
```

### 6. Limpar Tudo

```
🗑️ PERIGO! Botão: "Limpar TODO o ObjectBox"
→ Remove TODOS os dados
→ Irreversível!
→ Use apenas em desenvolvimento
```

---

## 🧪 Casos de Uso

### Use Case 1: Inspecionar UserSession

**Problema:** Quero verificar se minha sessão offline está sendo armazenada corretamente.

**Solução:**
1. Abra ObjectBox Admin
2. Navegue até collection: `UserSessionEntity`
3. Veja:
   - Email armazenado ✅
   - passwordHash (SHA256, não legível) ✅
   - sessionToken ✅
   - lastSuccessfulLogin ✅
   - firebaseUid ✅

### Use Case 2: Verificar Operações Pendentes

**Problema:** Dados offline não sincronizam quando volto online.

**Solução:**
1. Abra ObjectBox Admin
2. Navegue até collection: `PendingOperationEntity`
3. Veja quais operações ainda não foram sincronizadas
4. Verifique `needsSync = true` em UserSession
5. Ajuste dados se necessário

### Use Case 3: Debug de Animal Entity

**Problema:** Dados de animais não aparecem na tela.

**Solução:**
1. Abra ObjectBox Admin
2. Navegue até collection: `AnimalEntity`
3. Procure por filtro (ex: `nome contains "Branca"`)
4. Inspecione os dados
5. Veja relacionamentos (propriedadeId, etc)

### Use Case 4: Limpar Cache de Teste

**Problema:** Testei e criei muitos dados fake.

**Solução:**
1. Abra Debug Menu
2. Clique em "Limpar TODO o ObjectBox"
3. Confirme
4. App reinicia com banco limpo

---

## 📊 Estrutura das Collections

### UserSessionEntity
```
├─ id (int) - ID primária
├─ email (String) - Email @Unique
├─ passwordHash (String) - SHA256 hash
├─ firebaseUid (String?) - UID Firebase
├─ sessionToken (String) - Token único
├─ displayName (String?) - Nome usuário
├─ emailVerified (bool) - Email confirmado?
├─ lastSuccessfulLogin (DateTime?) - Último login
├─ lastSyncedAt (DateTime?) - Última sincronização
├─ needsSync (bool) - Precisa sincronizar?
├─ deviceFingerprint (String?) - Fingerprint
├─ createdAt (DateTime) - Criação
├─ updatedAt (DateTime) - Atualização
└─ isActive (bool) - Sessão ativa?
```

### AnimalEntity
```
├─ id (int)
├─ nome (String)
├─ propriedadeId (int) - FK Propriedade
├─ racaId (int) - FK Raça
├─ statusAnimalId (int) - FK Status
├─ brinco (String?) - Identificação
├─ dataNascimento (DateTime?)
├─ lastSynced (DateTime?) - Última sync
├─ needsSync (bool) - Precisa sincronizar?
├─ isDeleted (bool) - Marcado como deletado?
└─ ... mais campos
```

---

## ⌨️ Atalhos do Console

Você também pode chamar funções diretamente no console:

```dart
// Importar onde você testar
import 'package:tecmuu/backend/objectbox/objectbox_debug_service.dart';

// Ver estatísticas
ObjectBoxDebugService.printDatabaseStats();

// Ver sessões
ObjectBoxDebugService.printSessions();

// Exportar JSON
final data = ObjectBoxDebugService.exportDebugData();
print(data);

// Limpar sessões
await ObjectBoxDebugService.clearAllSessions();

// Limpar tudo
await ObjectBoxDebugService.clearAllData();

// Status
print(ObjectBoxDebugService.getStatus());
```

---

## 🔒 Segurança

### ✅ Seguro em Desenvolvimento

- Admin só funciona em `localhost:8090`
- Não acessa dados sensíveis em clear text
- Senhas são mostradas como hash (não legível)
- Requer app rodando localmente

### ⚠️ Perigo em Produção

- ❌ NÃO ative Admin em produção
- ❌ Dados podem ser acessados/modificados
- ❌ Potencial segurança
- ✅ Use: `if (kDebugMode)` para ativar só em debug

---

## 🐛 Troubleshooting

### Problema: "Admin não inicia"

```
Solução:
1. Verifique if objectbox_flutter_admin está no pubspec.yaml
2. Execute: flutter pub get
3. Rebuild app: flutter run
```

### Problema: "localhost:8090 não abre"

```
Solução:
1. Certifique-se que app está rodando
2. Verifique se porta 8090 está livre
3. Tente porta diferente: ObjectBoxDebugService.startAdmin(port: 9090)
```

### Problema: "Dados não aparecem"

```
Solução:
1. Clique "Exibir Estatísticas" para ver contagens
2. Se vazio, nenhum dado foi salvo
3. Adicione dados e recarregue Admin
4. Use Airplane Mode para forçar offline
```

### Problema: "Não consigo deletar sessão"

```
Solução:
1. Use "Limpar Todas as Sessões" ao invés de individual
2. Ou delete direto no Admin UI
3. App fará logout automático
```

---

## 📝 Checklist de Debug

Ao debugar ObjectBox:

- [ ] Verifique statísticas (quantos registros?)
- [ ] Inspecione UserSessionEntity (sessão criada?)
- [ ] Verifique pendingOperationEntity (operações aguardando?)
- [ ] Teste query filter no Admin
- [ ] Teste editar registro
- [ ] Teste deletar registro (soft delete)
- [ ] Verifique lastSynced timestamps
- [ ] Teste sincronização

---

## 🎓 Exemplo Prático

### Scenario: Debug de Login Offline

```
1. Abra app
2. Faça login online
   → ObjectBox Admin mostra UserSessionEntity criada

3. Feche app
4. Ativar Airplane Mode
5. Abra app
6. Faça login com mesma conta
   → ObjectBox Admin mostra sessão marcada como active
   → lastSuccessfulLogin atualizado
   → needsSync = true (sincronização pendente)

7. Desativar Airplane Mode
8. Esperar 3 segundos
9. No ObjectBox Admin
   → needsSync = false (sincronizado)
   → lastSyncedAt atualizado
```

---

## 🔗 Referências

- **Debug Service:** `lib/backend/objectbox/objectbox_debug_service.dart`
- **Debug Menu Widget:** `lib/backend/objectbox/widgets/objectbox_debug_menu.dart`
- **ObjectBox Docs:** https://docs.objectbox.io/
- **Flutter Admin:** https://github.com/objectbox/objectbox-dart/tree/main/packages/objectbox_flutter_admin

---

**Status:** ✅ PRONTO PARA DEBUG  
**Data:** 1 de junho de 2026  
**Versão:** 1.0.0
