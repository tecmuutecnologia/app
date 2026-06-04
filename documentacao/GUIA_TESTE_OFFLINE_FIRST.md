# 🔧 Guia de Teste - Sincronização Offline-First

## Objetivo
Validar que o aplicativo está funcionando corretamente com o padrão **offline-first**, onde:
1. ✅ Dados são salvos **LOCALMENTE** no ObjectBox quando você registra uma ação
2. ✅ Mudanças são marcadas com `needsSync = true`
3. ✅ Quando houver internet, dados são **sincronizados** com o Firestore
4. ✅ Se trocar de dispositivo, dados são **recarregados** do Firestore
5. ✅ Se outro dispositivo modificar dados, as mudanças chegam **automaticamente** via Firestore

---

## 📱 Cenário 1: Salvar Dados Localmente (OFFLINE)

### Precondições
- [ ] App instalado no Android
- [ ] Smartphone conectado via USB
- [ ] Airplane Mode ATIVADO (para garantir offline)

### Passo a Passo

```bash
# 1. Inicie o app em debug
flutter run -d 9TCI6X596TWK9HAA

# 2. No aplicativo:
#    - Faça login
#    - Tente registrar uma AÇÃO (ex: "Inseminação realizada")
#    - Tente CRIAR um novo ANIMAL
#    - Tente REGISTRAR um TRATAMENTO
```

### O Que Verificar

Abra o **SyncDebugger** (botão roxa "Debug Sync" no canto inferior direito) e:

#### TAB "Testes":
1. **Teste 1**: Digite o nome do animal registrado
   - ✅ Esperado: "✅ Animal 'xxxx' salvo localmente no ObjectBox"
   - ✅ Deve mostrar: `needsSync: true`
   - ❌ Problema: Se não encontrar ou `needsSync: false`, o animal não foi marcado para sincronização

2. **Teste 2**: Clique em "Listar Mudanças"
   - ✅ Esperado: Mostrar quantidade de animais, ações e tratamentos pendentes
   - ✅ Exemplo: "animaisPendentes: 1, acoesPendentes: 2, tratamentosPendentes: 1"

#### TAB "Dados":
3. **Listar Animais**: Clique em "Listar Animais"
   - ✅ Esperado: Ver todos os animais criados, com `sync: true`
   - ✅ Deve mostrar quantidade total em cache

4. **Listar Ações**: Clique em "Listar Ações"  
   - ✅ Esperado: Ver todas as ações, marcadas para sincronização

#### TAB "Status":
5. **Estatísticas**: Clique em "Carregar Estatísticas"
   - ✅ Esperado: Ver totais de dados em cache
   - ✅ `isOnline: false` (porque está em airplane mode)

#### TAB "Logs":
6. Todos os eventos devem aparecer registrados aqui

---

## 🌐 Cenário 2: Sincronizar com Firestore (ONLINE)

### Precondições
- [ ] Dados locais já foram criados (Cenário 1 completo)
- [ ] Airplane Mode DESATIVADO
- [ ] Internet ativa (WiFi ou dados)

### Passo a Passo

```bash
# 1. Desative airplane mode no smartphone
# 2. Aguarde conexão restaurar (± 5 segundos)
# 3. O app deve detectar automáticamente
```

### O Que Verificar

#### TAB "Testes":
1. **Teste 3**: Clique em "Forçar Sincronização"
   - ✅ Esperado: "✅ Sincronização completada com sucesso"
   - ⏳ Pode levar alguns segundos (depende da conexão)

#### TAB "Logs":
2. Você deve ver eventos:
   - "🔄 Conexão restaurada - sincronizando pendências"
   - "✅ Sincronização de alterações concluída"
   - "🐄 X animal(is) sincronizado(s)"
   - "📋 X ação(ões) sincronizada(s)"

#### Firestore Console:
3. Abra https://console.firebase.google.com
   - Acesse seu projeto **project-tecmuu-app**
   - Navegue até **Firestore Database**
   - Verifique que os dados aparecem nas coleções
   - ✅ Exemplo: `produtor -> propriedades -> animaisProdutores -> acoes`

#### App (TAB "Dados"):
4. Clique novamente em "Listar Mudanças" no Teste 2
   - ✅ Esperado: Quantidade volta para 0
   - ❌ Problema: Se ainda houver mudanças, a sincronização falhou

---

## 📲 Cenário 3: Atualização Remota (Outro Dispositivo)

### Precondições  
- [ ] Sincronização do Cenário 2 completa
- [ ] Animal X criado e sincronizado

### Passo a Passo

```bash
# 1. Acesse Firestore Console
# 2. Navegue até: produtor -> propriedades -> animaisProdutores
# 3. Abra o documento do animal criado
# 4. Clique em "Editar"
# 5. Mude um campo (ex: "pesoAnimal" de "500" para "550")
# 6. Clique "Atualizar"
```

### O Que Verificar

#### No Smartphone (TAB "Dados"):
1. Clique em "Listar Animais"
   - ✅ Esperado: O peso deve estar atualizado (550)
   - ⏳ Pode levar 5-30 segundos (depende do listener do Firestore)
   - ❌ Problema: Se não atualizar, o listener não está funcionando

---

## 🔄 Cenário 4: Desinstalar e Reinstalar App

### Precondições
- [ ] Dados sincronizados no Firestore (Cenário 2 completo)
- [ ] Pelo menos 1 animal e 1 ação sincronizados

### Passo a Passo

```bash
# 1. Desinstale o app
flutter clean
adb uninstall br.app.tecmuu

# 2. Reinstale
flutter run -d 9TCI6X596TWK9HAA

# 3. Faça login com a mesma conta
```

### O Que Verificar

#### TAB "Dados" (após login):
1. Clique em "Listar Animais"
   - ✅ Esperado: **Os mesmos animais aparecem**, mesmo após desinstalar!
   - ✅ Deve ver: `needsSync: false` (porque foram baixados, não criados localmente)
   - ❌ Problema: Se a lista estiver vazia, o download inicial falhou

2. Clique em "Listar Ações"
   - ✅ Esperado: As mesmas ações aparecem

#### TAB "Status":
3. "Carregar Estatísticas"
   - ✅ Esperado: Totais dos dados baixados
   - ✅ `initialSyncComplete: true`

---

## ⚠️ Cenário 5: Conflito de Edição

### Precondições
- [ ] Animal sincronizado
- [ ] Internet ativa

### Passo a Passo

```bash
# 1. No smartphone:
#    - Abra o animal
#    - Mude o nome para "Animal A"
#    - NÃO submita ainda

# 2. Em outro lugar (Firestore Console):
#    - Mude o mesmo animal para "Animal B"

# 3. No smartphone:
#    - Agora submita a mudança (salve "Animal A")
```

### O Que Verificar

#### TAB "Testes":
1. "Listar Mudanças"
   - ✅ Esperado: O app tem a mudança pendente
   
2. "Forçar Sincronização"
   - Deve aparecer um conflito (ou override)
   - ⚠️ Nota: Implemente estratégia de conflito (timestamp mais recente vence)

#### Firestore:
3. Verifique qual valor prevaleceu
   - Se usou "last-write-wins": "Animal A" (do smartphone venceu por ser mais recente)

---

## 🐛 Cenário 6: Fila de Retry

### Precondições
- [ ] Simulador de latência/perda de conexão

### Passo a Passo

```bash
# 1. Crie uma ação offline
# 2. Ative internet
# 3. Simule perda de conexão DURANTE a sincronização
#    (adb shell svc wifi disable)
# 4. Reative internet
```

### O Que Verificar

#### TAB "Testes":
1. "Listar Mudanças"
   - ✅ Esperado: Operação com `retryCount: 1` (tentou 1x)

2. "Forçar Sincronização" novamente
   - ✅ Esperado: `retryCount: 2`
   - ✅ Deve sincronizar na próxima tentativa bem-sucedida

#### TAB "Logs":
3. Deve ver eventos como:
   - "⚠️ Operação X falhou, tentativa 1 de 5"
   - "✅ Operação X sincronizada com sucesso (tentativa 2)"

---

## 📊 Cenário 7: Performance

### Passo a Passo

```bash
# 1. Crie 50+ animais, 100+ ações, 50+ tratamentos
# 2. Desative internet (Airplane Mode)
# 3. Use o app normalmente
# 4. Meça o tempo de resposta (cliques, navegação)
```

### O Que Verificar

- ✅ App responde em < 100ms (local é rápido!)
- ✅ Sem lag ao navegar
- ✅ Cache funciona sem problema

---

## 🔐 Caso de Teste: Dados Sensíveis

### Verificar
- [ ] Senha do usuário não é salva no ObjectBox
- [ ] Tokens JWT não são persistidos em claro
- [ ] Apenas dados necessários estão em cache

---

## 🚀 Resumo da Checklist

### ✅ Offline-First Funcionando Corretamente
- [ ] Dados salvos localmente quando registrados (Cenário 1)
- [ ] Mudanças sincronizam com Firestore quando online (Cenário 2)
- [ ] Mudanças remotas chegam ao app (Cenário 3)
- [ ] Download completo ao reinstalar (Cenário 4)
- [ ] Estratégia de conflito funciona (Cenário 5)
- [ ] Retry automático funciona (Cenário 6)
- [ ] Performance é boa (Cenário 7)

### ⚠️ Pontos Críticos a Monitorar
1. **`needsSync` flag**: Sempre deve estar correto
2. **Timestamp**: Sempre atualizar `lastModified` e `lastSynced`
3. **FirestoreID**: Novos registros devem ganhar ID após sincronização
4. **Listeners**: Mudanças remotas devem chegar automaticamente
5. **Retry**: Falhas de rede não devem perder dados

---

## 🛠️ Comandos Úteis para Debug

```bash
# Ver logs em tempo real
flutter logs -d 9TCI6X596TWK9HAA

# Ver apenas logs da app
flutter logs -d 9TCI6X596TWK9HAA --grep "tecmuu\|flutter"

# Simular perda de internet
adb shell svc wifi disable   # Desativa WiFi
adb shell svc wifi enable    # Reativa WiFi

# Limpar dados do app
adb uninstall br.app.tecmuu

# Acessar Firebase Console
# https://console.firebase.google.com/project/project-tecmuu-app/firestore/data

# Acessar DevTools
# http://127.0.0.1:9101
```

---

## 📝 Notas Importantes

1. **ObjectBox é LOCAL** - Dados não saem do dispositivo sem sua autorização
2. **Firestore é NUVEM** - Dados são persistidos para recuperação
3. **Sincronização é BIDIRECIONAL** - Mudanças fluem dos dois lados
4. **Conflitos são RESOLVIDOS** - A versão mais recente (timestamp) vence
5. **Retry é AUTOMÁTICO** - Falhas são reexecutadas

---

## 🎯 Métricas de Sucesso

| Métrica | Target | Status |
|---------|--------|--------|
| Dados salvos localmente | 100% | [ ] |
| Mudanças sincronizadas | 100% | [ ] |
| Taxa de sucesso de sync | > 95% | [ ] |
| Tempo de resposta (local) | < 100ms | [ ] |
| Tempo de sync (10 registros) | < 5s | [ ] |
| Taxa de retenção de dados | 100% | [ ] |

