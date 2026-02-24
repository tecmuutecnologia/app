# 🎯 MATRIZ DE PRIORIZAÇÃO - OTIMIZAÇÃO TECMUU

## Urgência vs Complexidade

```
CRÍTICO E FÁCIL (Fazer PRIMEIRO!)
├─ Timer 300ms → 5s ⭐⭐⭐⭐⭐ (30 min)
├─ Adicionar limites queries ⭐⭐⭐⭐⭐ (1h)
└─ Remover context.watch ⭐⭐⭐⭐⭐ (1h)

IMPORTANTE E FÁCIL (Fazer depois)
├─ Cancelar listeners ⭐⭐⭐⭐ (30 min)
├─ Cache inteligente ⭐⭐⭐ (2h)
└─ Pagination básica ⭐⭐⭐ (2h)

RECOMENDADO E MÉDIO (Se tiver tempo)
├─ CachedNetworkImage ⭐⭐ (1h)
├─ Lazy loading ⭐⭐ (2h)
└─ Skeleton loaders ⭐⭐ (1h)

NICE-TO-HAVE (Futuro)
├─ Debounce search ⭐ (1h)
└─ Performance monitoring ⭐ (2h)
```

---

## 📊 TABELA COMPARATIVA

| Item | Impacto | Tempo | Risco | Prioridade | Status |
|------|---------|-------|-------|------------|--------|
| **Timer 300ms** | ⭐⭐⭐⭐⭐ | 30min | 🟢 | 🔴 CRITICAL | ☐ TODO |
| **Query Limits** | ⭐⭐⭐⭐⭐ | 1h | 🟢 | 🔴 CRITICAL | ☐ TODO |
| **context.watch** | ⭐⭐⭐⭐ | 1h | 🟢 | 🔴 CRITICAL | ☐ TODO |
| **Listeners cancel** | ⭐⭐⭐ | 30min | 🟢 | 🟠 HIGH | ☐ TODO |
| **AppCache** | ⭐⭐⭐⭐ | 2h | 🟡 | 🟠 HIGH | ☐ TODO |
| **Pagination** | ⭐⭐⭐⭐ | 2h | 🟡 | 🟠 HIGH | ☐ TODO |
| **Cached Images** | ⭐⭐⭐ | 1h | 🟢 | 🟡 MEDIUM | ☐ TODO |
| **Lazy Loading** | ⭐⭐⭐ | 2h | 🟡 | 🟡 MEDIUM | ☐ TODO |
| **Skeletons** | ⭐⭐ | 1h | 🟢 | 🟡 MEDIUM | ☐ TODO |
| **Debounce** | ⭐⭐ | 1h | 🟢 | 🟢 LOW | ☐ TODO |

---

## 🗓️ ROADMAP RECOMENDADO

### Semana 1: FASE 1 - Quick Wins
**META:** +40% performance

```
Dia 1 (Monday) - 2h
├─ Timer 300ms → 5s (3 widgets) ✓
└─ Compile & basic test

Dia 2 (Tuesday) - 3h
├─ Query limits backend.dart ✓
└─ Test com DevTools Memory

Dia 3 (Wednesday) - 2h
├─ context.watch cleanup ✓
└─ Test com DevTools CPU

Dia 4 (Thursday) - 1.5h
├─ Listeners cancel main.dart ✓
└─ Final test

Dia 5 (Friday) - 1.5h
├─ Validação completa
├─ Comparar antes/depois
└─ Deploy to staging
```

**Total Semana 1:** 10h → +40% performance

---

### Semana 2: FASE 2 - Cache & Pagination
**META:** +35% performance

```
Dia 1 (Monday) - 2h
├─ Implementar AppCache
└─ Testar com 1 página

Dia 2 (Tuesday) - 2h
├─ Pagination lista_animais
└─ Pagination lista_inseminacoes

Dia 3 (Wednesday) - 2h
├─ Lazy loading widgets
└─ Test performance

Dia 4 (Thursday) - 1h
├─ Agregação de queries
└─ Parallel loading test

Dia 5 (Friday) - 1h
├─ Validação final
└─ Deploy to staging
```

**Total Semana 2:** 8h → +35% performance adicional

---

### Semana 3: FASE 3 - Polish
**META:** +10% performance

```
Dia 1 (Monday) - 1h
├─ CachedNetworkImage em 3 páginas
└─ Test loading

Dia 2 (Tuesday) - 1h
├─ Skeleton loaders
└─ UX improvement

Dia 3 (Wednesday) - 1h
├─ Debounce search
└─ Test performance

Dia 4-5 (Thu-Fri) - 2h
├─ Final cleanup
├─ Full regression test
└─ Deploy to production
```

**Total Semana 3:** 5h → +10% performance adicional

---

## 🎯 CHECKLIST DETALHADO

### PHASE 1: Quick Wins (10h total)

- [ ] **Dia 1: Timer** (2h)
  - [ ] Abrir `resumo_rebanho_widget.dart`
  - [ ] Mudar Timer 300ms → 5s
  - [ ] Mudar startImmediately: true → false
  - [ ] Repetir em `sincronizar_widget.dart`
  - [ ] Repetir em `inicio_propriedade_widget.dart`
  - [ ] Compile e teste básico
  - [ ] Commit: "chore: optimize instant timer from 300ms to 5s"

- [ ] **Dia 2: Query Limits** (3h)
  - [ ] Abrir `backend.dart`
  - [ ] Procurar `queryAnimaisProdutoresRecord` (linha ~1180)
  - [ ] Mudar `int limit = -1` → `int limit = 500`
  - [ ] Repetir para: AcoesRecord, TratamentosRecord, ResumoDaVisitaRecord, RecomendacoesRecord
  - [ ] Compile e teste com DevTools Memory
  - [ ] Validar RAM decreased
  - [ ] Commit: "feat: add limits to firestore queries"

- [ ] **Dia 3: context.watch Cleanup** (2h)
  - [ ] Procurar todas as páginas com `context.watch<FFAppState>()`
  - [ ] Listar: resumo_rebanho, inicio_propriedade, sincronizar, listacompleta, lista_inseminacoes, animais_prenhas, dashboard, etc
  - [ ] Comentar ou remover linhas
  - [ ] Compile e teste com DevTools CPU
  - [ ] Validar CPU idle < 10%
  - [ ] Commit: "refactor: remove unnecessary context.watch calls"

- [ ] **Dia 4: Listeners Cleanup** (1.5h)
  - [ ] Abrir `main.dart`
  - [ ] Adicionar `late StreamSubscription` variables
  - [ ] Guardar listeners em variables
  - [ ] Adicionar `.cancel()` no `dispose()`
  - [ ] Compile e teste
  - [ ] Commit: "fix: properly cancel stream subscriptions"

- [ ] **Dia 5: Validação Final** (1.5h)
  - [ ] Abrir DevTools
  - [ ] Memory tab: RAM antes/depois
  - [ ] CPU Profiler: compare
  - [ ] Timeline: check for jank
  - [ ] Test em device real
  - [ ] Documentar resultados
  - [ ] Commit: "docs: performance optimization results - Phase 1"

### PHASE 2: Cache & Pagination (8h total)

- [ ] **Dia 1: AppCache** (2h)
  - [ ] Adicionar classe `CacheEntry` em `app_state.dart`
  - [ ] Adicionar classe `AppCache`
  - [ ] Adicionar métodos get/set
  - [ ] Integrar com FFAppState
  - [ ] Teste básico
  - [ ] Commit: "feat: implement intelligent caching system"

- [ ] **Dia 2: Pagination** (2h)
  - [ ] Implementar em `lista_animais_widget.dart`
  - [ ] Implementar em `lista_inseminacoes_widget.dart`
  - [ ] Implementar em `listacompleta_widget.dart`
  - [ ] Test scroll performance
  - [ ] Commit: "feat: implement pagination for large lists"

- [ ] **Dia 3: Lazy Loading & Parallel** (2h)
  - [ ] Adicionar VisibilityDetector para widgets pesados
  - [ ] Implementar Future.wait para queries paralelas
  - [ ] Test performance
  - [ ] Commit: "feat: lazy loading and parallel queries"

- [ ] **Dia 4: Validação** (1h)
  - [ ] DevTools Memory: validate cache efficiency
  - [ ] DevTools Network: validate Firebase reads reduced
  - [ ] Test em device real
  - [ ] Commit: "docs: phase 2 performance results"

- [ ] **Dia 5: Deploy** (1h)
  - [ ] Merge to staging
  - [ ] QA testing
  - [ ] Final adjustments

### PHASE 3: Polish (5h total)

- [ ] **Dia 1: CachedNetworkImage** (1h)
  - [ ] Adicionar `cached_network_image` ao pubspec.yaml
  - [ ] Replacar `Image.network` por `CachedNetworkImage`
  - [ ] Test image loading
  - [ ] Commit: "feat: implement cached network images"

- [ ] **Dia 2: Skeletons** (1h)
  - [ ] Adicionar `shimmer` ao pubspec.yaml
  - [ ] Replacar spinners por skeleton loaders
  - [ ] Test UX
  - [ ] Commit: "feat: add skeleton loading screens"

- [ ] **Dia 3: Debounce** (1h)
  - [ ] Implementar debounce em search fields
  - [ ] Test Firebase reads
  - [ ] Commit: "feat: debounce search queries"

- [ ] **Dia 4-5: Final Testing** (1h)
  - [ ] Full regression test
  - [ ] Test em 3+ devices diferentes
  - [ ] Final DevTools validation
  - [ ] Deploy to production
  - [ ] Monitor performance

---

## 📊 GANHO ESPERADO POR FASE

```
ANTES:
RAM:      250MB ████████████████████░░░░░░░░
CPU:      25%   ██████░░░░░░░░░░░░░░░░░░░░░░░░
Startup:  5s    ██████████████░░░░░░░
Temp:     40°C  ███████████░░░░░░░░░

APÓS FASE 1 (+40%):
RAM:      150MB ██████████░░░░░░░░░░░░░░░░░░
CPU:      8%    ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░
Startup:  3s    █████░░░░░░░░░░░░░░░
Temp:     37°C  ██████░░░░░░░░░░░░░

APÓS FASE 2 (+35% mais):
RAM:      100MB ███████░░░░░░░░░░░░░░░░░░░░░░
CPU:      3%    █░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
Startup:  1.5s  ███░░░░░░░░░░░░░░░░░
Temp:     32°C  ███░░░░░░░░░░░░░░░░░

APÓS FASE 3 (+10% mais):
RAM:      85MB  ████░░░░░░░░░░░░░░░░░░░░░░░░░
CPU:      2%    █░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
Startup:  1.3s  ██░░░░░░░░░░░░░░░░░
Temp:     30°C  ██░░░░░░░░░░░░░░░░░

TOTAL GANHO: -60% RAM, -90% CPU, -75% Startup, -25% Temp
```

---

## 🚀 DICAS DE IMPLEMENTAÇÃO

### 1. Sempre faça em Branch
```bash
git checkout -b feat/optimize-phase-1
```

### 2. Teste frequentemente
```bash
flutter clean
flutter pub get
flutter run --profile
```

### 3. Use DevTools
```bash
flutter pub global run devtools
```

### 4. Commit bem estruturado
```bash
git commit -m "feat: optimize timer and queries

- Change InstantTimer from 300ms to 5s
- Add limits to Firestore queries
- Remove context.watch() from X pages"
```

### 5. Merge quando tudo passar
```bash
git checkout main
git merge feat/optimize-phase-1
```

---

## ⚠️ CHECKLIST DE QA

- [ ] App inicia sem crashes
- [ ] Todas as funcionalidades funcionam
- [ ] Sem memory leaks (DevTools)
- [ ] RAM decreased significantly
- [ ] CPU idle < 5%
- [ ] No jank/lag visual
- [ ] Imagens carregam rápido
- [ ] Listas são responsivas
- [ ] Searches funcionam
- [ ] Firebase calls reduced

---

## 🎯 SUCCESS CRITERIA

| Métrica | Before | After | Goal |
|---------|--------|-------|------|
| RAM | 250MB | < 100MB | ✅ |
| CPU Idle | 25% | < 3% | ✅ |
| Startup | 5s | < 2s | ✅ |
| Temp | 40°C | < 32°C | ✅ |
| Firebase Reads | 50/session | < 20/session | ✅ |
| Crashes | 5%/day | 0% | ✅ |
| User Satisfaction | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ✅ |

---

**Status:** 🟢 Ready to implement!  
**Start Date:** Hoje!  
**Estimated Completion:** 3 semanas  
**Expected Result:** Melhor app no mercado! 🚀
