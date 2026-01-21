# 📋 QUICK REFERENCE - Linhas Exatas para Correção

## 🔴 CRÍTICOS - Fix Hoje

### 1. `lib/main.dart`

**Linhas:** 80-82 (initState)  
**Problema:** Listeners nunca descartados

```dart
// ANTES (linha 80-82)
userStream = tecmuuFirebaseUserStream()
  ..listen((user) {
    _appStateNotifier.update(user);
  });
jwtTokenStream.listen((_) {});

// DEPOIS
late StreamSubscription<BaseAuthUser> _userSubscription;
late StreamSubscription _jwtSubscription;

// Em initState (substituir):
_userSubscription = tecmuuFirebaseUserStream()
  .listen((user) {
    _appStateNotifier.update(user);
  });
_jwtSubscription = jwtTokenStream.listen((_) {});

// Adicionar dispose():
@override
void dispose() {
  _userSubscription.cancel();
  _jwtSubscription.cancel();
  super.dispose();
}
```

---

### 2. `lib/pages/tecnico/propriedade/inicio_propriedade/inicio_propriedade_widget.dart`

**Linhas:** 64-110 (initState - InstantTimer)  
**Problema:** Timer 300ms rodando indefinidamente

```dart
// ANTES (linha 64)
_model.instantTimer = InstantTimer.periodic(
  duration: Duration(milliseconds: 300),  // ❌ MUITO RÁPIDO
  callback: (timer) async {
    _model.respostaNet = await actions.checkInternetConnection();
    safeSetState(() {});
    if (_model.respostaNet!) {
      FFAppState().verificaInternet = -1;
      safeSetState(() {});
    } else {
      if (FFAppState().verificaInternet == -1) {
        FFAppState().verificaInternet = 0;
        safeSetState(() {});
        _model.instantTimer?.cancel();
        // ... resto

// DEPOIS
_model.instantTimer = InstantTimer.periodic(
  duration: Duration(seconds: 10),  // ✅ A cada 10 segundos
  callback: (timer) async {
    if (!mounted) {  // ✅ Verificar se widget ainda existe
      timer.cancel();
      return;
    }
    _model.respostaNet = await actions.checkInternetConnection();
    safeSetState(() {});
    // ... resto do callback igual
```

**Linhas:** ~380 (dispose)  
**Verificar se tem:**
```dart
@override
void dispose() {
  _model.dispose();  // ✅ Deve estar aqui
  super.dispose();
}
```

---

### 3. `lib/pages/tecnico/propriedade/lista_completa/listacompleta/listacompleta_widget.dart`

**Linhas:** 82-109 (initState - InstantTimer)  
**Problema:** Mesmo problema - timer 300ms

```dart
// ANTES (linha 82)
_model.instantTimer = InstantTimer.periodic(
  duration: Duration(milliseconds: 300),  // ❌ MUITO RÁPIDO
  // ... resto igual ao anterior

// DEPOIS - mesma solução:
Duration(milliseconds: 300) → Duration(seconds: 10)
Adicionar: if (!mounted) { timer.cancel(); return; }
```

**Linhas:** ~132 (dispose - verificar)
```dart
@override
void dispose() {
  _model.dispose();
  super.dispose();
}
```

---

### 4. `lib/pages/tecnico/propriedade/resumo_rebanho/resumo_rebanho/resumo_rebanho_widget.dart`

**Linhas:** 56-66 (initState - InstantTimer)  
**Problema:** Timer 1000ms (melhor que 300ms, mas ainda pode melhorar)

```dart
// ANTES (linha 56)
_model.instantTimer = InstantTimer.periodic(
  duration: Duration(milliseconds: 1000),
  callback: (timer) async {
    _model.respostaNet = await actions.checkInternetConnection();
    safeSetState(() {});
  },
  startImmediately: true,
);

// DEPOIS
_model.instantTimer = InstantTimer.periodic(
  duration: Duration(seconds: 10),  // Aumentar para 10 segundos
  callback: (timer) async {
    if (!mounted) {
      timer.cancel();
      return;
    }
    _model.respostaNet = await actions.checkInternetConnection();
    safeSetState(() {});
  },
  startImmediately: true,
);
```

---

### 5. `lib/backend/backend.dart`

**Múltiplas linhas com `int limit = -1` → `int limit = 50`**

**Lista completa (50+ ocorrências):**

```dart
// Linhas para PROCURAR e SUBSTITUIR:

// PROCURE:        int limit = -1,
// SUBSTITUA POR:  int limit = 50,

// Funções afetadas (exemplos):
```

**Linhas específicas:**

| Função | Linhas | Tipo |
|--------|--------|------|
| queryCidadesRecord | 73, 83, 96 | Stream, Future, Page |
| queryGrupoRecord | 151, 161, 174 | Stream, Future, Page |
| queryStatusAnimaisRecord | 229, 239, 252 | Stream, Future, Page |
| queryPlanosProdutorRecord | 307, 317, 330 | Stream, Future, Page |
| queryPlanosTecnicosRecord | 385, 395, 408 | Stream, Future, Page |
| queryEmpresasRecord | 463, 473, 486 | Stream, Future, Page |
| queryPersonRecord | 541, 551, 564 | Stream, Future, Page |
| ... | ... | ... |

**Como fazer RÁPIDO com Find & Replace:**
```
Find:     int limit = -1,
Replace:  int limit = 50,
Replace All
```

---

## 🟡 IMPORTANTE - Próximas Semanas

### 6. `lib/pages/tecnico/propriedade/lista_completa/listacompleta/listacompleta_widget.dart`

**Linhas:** ~150 (build method)  
**Problema:** `context.watch<FFAppState>()`

```dart
// ANTES (linha ~150 em build())
@override
Widget build(BuildContext context) {
  context.watch<FFAppState>();  // ❌ Rebuild de TUDO

  return GestureDetector(
    // ... 22.000+ linhas

// DEPOIS - Extrair em sub-widget:
@override
Widget build(BuildContext context) {
  // ✅ SEM context.watch() aqui
  
  return GestureDetector(
    onTap: () { FocusScope.of(context).unfocus(); },
    child: Scaffold(
      appBar: _ListacompletaAppBar(
        nomePropriedade: widget.nomePropriedade!,
        // ... params
      ),
      body: Container(...),  // Resto da página
    ),
  );
}

// ✅ Novo sub-widget (adicionar antes de ListacompletaWidget):
class _ListacompletaAppBar extends StatelessWidget {
  final String nomePropriedade;
  // ... outros params necessários

  @override
  Widget build(BuildContext context) {
    // ✅ ÚNICO widget que observa FFAppState
    final respostaNet = context.select<FFAppState, bool>(
      (state) => state.verificaInternet == -1,
    );

    return AppBar(
      backgroundColor: respostaNet ? Color(0xFFF75E38) : Color(0xFFF2886E),
      // ... resto do AppBar
    );
  }
}
```

---

### 7. `lib/app_state.dart`

**Linhas:** 10-200+ (initializePersistedState)  
**Problema:** Carregamento ineficiente com SharedPreferences

**Não alterar agora** - deixar para próxima fase.  
Quando chegar a hora, substituir por Hive (vide GUIA_IMPLEMENTACAO.md).

---

### 8. `lib/pages/tecnico/propriedade/lista_completa/listacompleta/listacompleta_widget.dart`

**Linhas:** 214-222 (StreamBuilder GrupoRecord)  
**Problema:** Carrega dados sem limit

```dart
// ANTES
StreamBuilder<List<GrupoRecord>>(
  stream: queryGrupoRecord(
    queryBuilder: (grupoRecord) => grupoRecord.where(
      'descricao',
      isNotEqualTo: 'Sêmens',
    ),
    // ❌ Sem limit
  ),

// DEPOIS
StreamBuilder<List<GrupoRecord>>(
  stream: queryGrupoRecord(
    queryBuilder: (grupoRecord) => grupoRecord.where(
      'descricao',
      isNotEqualTo: 'Sêmens',
    ),
    limit: 50,  // ✅ Adicionar limit
  ),
```

---

### 9. `lib/pages/tecnico/propriedade/resumo_rebanho/resumo_rebanho/resumo_rebanho_widget.dart`

**Linhas:** 252-259 (StreamBuilder StatusAnimaisRecord)  
**Problema:** Carrega sem filtro/limit

```dart
// ANTES
StreamBuilder<List<StatusAnimaisRecord>>(
  stream: queryStatusAnimaisRecord(),  // ❌ SEM FILTRO
  builder: (context, snapshot) {

// DEPOIS
StreamBuilder<List<StatusAnimaisRecord>>(
  stream: queryStatusAnimaisRecord(
    limit: 50,  // ✅ Adicionar limit
  ),
  builder: (context, snapshot) {
```

---

## 📊 ORDEM DE EXECUÇÃO RECOMENDADA

### ✅ TERÇA (2-3 horas)

1. **Começar por `main.dart`** (20 min)
   - Mais simples, menos risco
   - Ganho imediato: -5% vazamento memória

2. **3x InstantTimer** (30 min)
   - 3 arquivos simples
   - Ganho: -15% CPU

3. **backend.dart** (1 hora)
   - Find/Replace global
   - Ganho: -30% memória

4. **Teste com DevTools** (20 min)
   - Validar melhoria

### ✅ QUARTA-SEXTA (3-4 horas)

5. **context.watch() → select()** (1-2 horas)
   - Extrair sub-widgets
   - Ganho: -40% rebuilds

6. **Testes finais** (20 min)

---

## ✨ CHECKLIST TÉCNICO

```
ANTES DE COMEÇAR:
☐ Git: Criar branch "perf/optimize-app"
☐ Git: Fazer commit limpo antes de começar
☐ DevTools: Abrir e documentar métricas ANTES

MAIN.DART:
☐ Adicionar: late StreamSubscription _userSubscription;
☐ Adicionar: late StreamSubscription _jwtSubscription;
☐ Alterar: initState (armazenar subscriptions)
☐ Adicionar: dispose() (cancelar subscriptions)
☐ Teste: App inicia sem erro

TIMERS (3 arquivos):
☐ inicio_propriedade_widget.dart linha 64
☐ listacompleta_widget.dart linha 82
☐ resumo_rebanho_widget.dart linha 56
☐ Alteração em cada: 300ms→10s, adicionar if (!mounted)
☐ Teste: App navega sem erro

BACKEND.DART:
☐ Find & Replace: int limit = -1, → int limit = 50,
☐ Validação: >50 replacements
☐ Teste: Queries retornam resultados

CONTEXT.SELECT (opcional semana 2):
☐ listacompleta_widget.dart: Extrair AppBar
☐ resumo_rebanho_widget.dart: Extrair AppBar
☐ Teste: Sem rebuild em navegação

FINAL:
☐ DevTools: Comparar métricas DEPOIS
☐ Git: Fazer commits pequenos
☐ Documentar: Tempo total vs ganho real
☐ PR: Submeter para review
```

---

## 📈 MÉTRICAS PARA VALIDAR

### ANTES (Executar agora)
```bash
# Terminal
flutter pub global activate devtools
flutter pub global run devtools

# Abrir http://localhost:9100 e medir:
- Memory Tab: Memória em repouso (MB)
- Performance Tab: FPS durante navegação
- CPU Profiler: Uso CPU idle (%)
- Timeline: Build time (ms)

# Anotar resultados em METRICAS_ANTES.txt
```

### DEPOIS (Executar após Phase 1)
```bash
# Repetir mesmo processo
# Comparar com METRICAS_ANTES.txt

# Esperado:
# Memory: -30%
# FPS: 60 stable
# CPU: -50%
# Build time: -70%
```

---

## 🚀 GO/NO-GO CHECKLIST

**Antes de fazer commit:**

```
☐ Aplicação inicia sem crashes
☐ Navega entre telas sem errors
☐ Lista de animais carrega
☐ DevTools mostra melhoria
☐ Sem console errors
☐ Sem yellow box warnings
☐ Performance visual OK (60 FPS)
☐ Código formatado (dart format)
```

---

**Tempo Total Estimado:** 3-4 horas para Phase 1  
**Ganho esperado:** 40-60% em performance global  
**Risco:** Baixo (mudanças incrementais)  
**Próximo passo:** Comece por `main.dart`

