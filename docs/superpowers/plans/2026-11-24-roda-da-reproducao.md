# Roda da Reprodução Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Tela "Roda da Reprodução" (paleta Embrapa) para produtor e técnico: roda do ciclo de 365 dias + "Esta semana", lendo os dados locais e abrindo as janelas de registro existentes.

**Architecture:** Regras puras em `lib/domain/roda_reproducao/` (sem Flutter, testadas); adaptador `AnimalEntity → AnimalRoda`; widget de roda com `CustomPainter` (portado do spike); página que observa `animaisByPropriedadeProvider` e recalcula sozinha após cada registro.

**Tech Stack:** Flutter/Dart, Riverpod (provider existente), ObjectBox (via provider), `flutter_test`.

**Spec:** `docs/superpowers/specs/2026-11-24-roda-da-reproducao-design.md`

## Global Constraints

- Paleta Embrapa: pós-parto `#E5482F`, cobertura `#F2C230` (número escuro), prenhe `#2F7FD8`, seca `#7AA64A`, novilha coberta `#F6B3C6` (número escuro), novilha prenhe/pré-parto `#E4589A`.
- Faixas: 0–83 pós-parto, 83–143 cobertura, 143–305 prenhe, 305–365 seca; marcas 30/45/60, 83 "Cobrir", 104 "Cio 21d", 123 "DG 40d", 305 "Secar", 335 "30"; "HOJE · PARTO" embaixo, sentido horário.
- Gestação 280 dias (`dtPartoPrevisto`, senão IA + 280).
- Nada é gravado pela roda; avançar a data é só simulação.
- Seguir `docs/padrao-layout-listas.md`. Textos da UI em pt-BR.
- Sem commits durante a execução (o usuário pede quando quiser).

## Review Focus

- Animal com datas vazias/inválidas/sentinela 31/12/2050 → fica fora da roda, sem exceção.
- Vaca vazia há > 365 dias → fora da roda, contada em "+N fora do ciclo" e em Atrasadas.
- Novilha prenhe passando do dia 312 → **não** vira "secagem atrasada" nem entra em "Secar".
- DG+ anterior à IA atual → conta como "sem diagnóstico".
- 60+ animais na mesma semana → bolinhas não se sobrepõem.

---

### Task 1: Regras do ciclo (domínio)

**Files:**
- Create: `lib/domain/roda_reproducao/ciclo_reproducao.dart`
- Test: `test/domain/roda_reproducao/ciclo_reproducao_test.dart`

**Interfaces:**
- Produces:
  - constantes `kCiclo=365, kDiaCobertura=83, kFimCobertura=143, kDiaSecar=305, kGestacao=280`
  - `enum FaseRoda { posParto, cobertura, prenhe, seca }`, `FaseRoda faseDoDia(int dia)`
  - `class AnimalRoda { String id; String nome; int brinco; String status; String grupo; DateTime? parto; DateTime? ia; DateTime? partoPrevisto; DateTime? dgMais; DateTime? pp; DateTime? inducao; bool get novilha; bool get coberta; bool get semDiagnostico; FaseRoda get faseEstado; }`
  - `enum AlertaRoda { semCobertura, dgAtrasado, secagemAtrasada, partoAtrasado, foraDoCiclo }`
  - `class PosicaoRoda { AnimalRoda animal; int diaBruto; int dia /*0..364*/; FaseRoda faixa; AlertaRoda? alerta; bool get naRoda; int? diasPosIa; int? diasPosParto; DateTime? partoPrevistoEfetivo; }`
  - `PosicaoRoda? calcularPosicao(AnimalRoda a, DateTime data)` (null = não entra: bezerra/recria/descarte/novilha vazia/sem datas)

- [ ] **Step 1: testes** (data base `DateTime(2026,11,24)`):
  - `vazia pariu há 10 dias → dia 10, faixa posParto, sem alerta`
  - `vazia 90 dias → alerta semCobertura`; `vazia 400 dias → naRoda false, alerta foraDoCiclo`
  - `prenhe com partoPrevisto em 5 dias → dia 360, faixa seca`; `sem partoPrevisto usa IA+280` (IA há 100 dias → dia 365−180=185)
  - `inseminada há 70 dias sem DG → dgAtrasado`; `DG+ anterior à IA atual → semDiagnostico true`
  - `vaca prenhe dia 313 → secagemAtrasada`; `novilha prenhe dia 330 → sem alerta`
  - `seca com parto previsto há 4 dias → partoAtrasado`; `há 3 dias → sem alerta`
  - `indução mais recente que o parto vale como parto` (indução há 20 d, parto há 500 d → dia 20)
  - `aborto não muda âncora` (vazia, parto há 200 d, ia limpa → dia 200, semCobertura)
  - `bezerra / descarte / novilha vazia → null`
  - `faseEstado`: Vazia→posParto, Inseminada/Inseminada PP→cobertura, Prenha→prenhe, Seca/Pré Parto→seca (usar `ehInseminada`, `ehInseminadaPP`, `ehPrenha`, `ehSeca`, `ehPreParto` de `lib/domain/animais/classificacao_animal.dart`).
- [ ] **Step 2:** `flutter test test/domain/roda_reproducao/ciclo_reproducao_test.dart` → FAIL (arquivo não existe).
- [ ] **Step 3:** implementar. Âncora da coberta: `365 − (partoPrevistoEfetivo − data)`. Âncora da vazia: a mais recente entre `parto` e `inducao` (se `inducao` for depois do parto). Alertas na ordem: foraDoCiclo, partoAtrasado (coberta, diaBruto > 368), semCobertura (vazia > 83), dgAtrasado (semDiagnostico, diasPosIa > 60), secagemAtrasada (vaca `ehPrenha`, não novilha, diaBruto > 312). Elegível: grupo Vacas/Novilhas (`ehVacaOuNovilha`), não descarte; novilha só se coberta.
- [ ] **Step 4:** teste → PASS.

### Task 2: Tarefas da semana e contadores (domínio)

**Files:**
- Create: `lib/domain/roda_reproducao/tarefas_semana.dart`
- Test: `test/domain/roda_reproducao/tarefas_semana_test.dart`

**Interfaces:**
- Consumes: Task 1.
- Produces:
  - `enum AbaSemana { parir, secar, diagnostico, cio, posParto, atrasadas }` + `String rotuloAba(AbaSemana)` ("Parir", "Secar", "Diagnóstico", "Cio 21d", "Pós-parto 30d", "Atrasadas")
  - `Set<AbaSemana> abasDe(PosicaoRoda p, {required int diasDg})`
  - `Map<AbaSemana, List<PosicaoRoda>> agruparSemana(List<PosicaoRoda> ps, {required int diasDg})` (alertas primeiro, depois por dia)
  - `Map<FaseRoda, int> contarPorEstado(List<PosicaoRoda> ps)` (só `naRoda`)
  - `List<PosicaoRoda> naFaixa(List<PosicaoRoda> ps, FaseRoda f)` (alertas primeiro)

- [ ] **Step 1: testes:**
  - parir: coberta não-semDiagnostico com parto previsto em 0..7 dias ou atrasado → parir
  - secar: vaca Prenha dia ≥ 298 → secar; novilha prenhe dia 300 → não
  - diagnostico: inseminada sem DG com diasPosIa ≥ diasDg (ex.: diasDg=30, 31 dias → sim; 29 → não); novilha incluída
  - cio: diasPosIa 18 e 24 → sim; 17 e 25 → não
  - posParto: vazia 28..45 dias pós-parto → sim
  - atrasadas: qualquer alerta
  - contarPorEstado: conta pela cor (vazia no dia 150 conta em posParto)
- [ ] **Step 2:** rodar → FAIL. **Step 3:** implementar. **Step 4:** rodar → PASS.

### Task 3: Adaptador e rótulo do brinco

**Files:**
- Create: `lib/features/roda_reproducao/application/animal_roda_adapter.dart`
- Test: `test/features/roda_reproducao/animal_roda_adapter_test.dart`

**Interfaces:**
- Produces: `AnimalRoda animalRodaDe(AnimalEntity e)`; `String rotuloBrinco(int brinco, String nome)` (≤ 4 dígitos inteiro; 5+ → 4 últimos; brinco 0 → inicial do nome maiúscula, ou "?").
- Datas: `parseDataBr` (`lib/domain/financeiro/vendas_por_mes.dart`); ano < 1990 ou ≥ 2050 → null. `inducao` = `dtInducaoLactacao`; `pp` = `dtPP`; `id` = uid usado pelas janelas (o mesmo campo que a página de DG passa em `uidAnimaisProdutores`).

- [ ] **Step 1: testes:** datas `dd/MM/yyyy` convertidas; `""`, `"31/12/2050"`, lixo → null; `rotuloBrinco(850808,'x')=="0808"`, `(1234,'x')=="1234"`, `(0,'mimosa')=="M"`, `(0,'')=="?"`.
- [ ] **Step 2–4:** FAIL → implementar → PASS.

### Task 4: Widget da roda

**Files:**
- Create: `lib/features/roda_reproducao/presentation/widgets/roda_widget.dart` (widget + `CustomPainter` + paleta Embrapa)
- Create: `lib/features/roda_reproducao/presentation/widgets/geometria_roda.dart` (puro: ângulo, ponto, `diaDoAngulo`, `distribuirBolinhas`)
- Test: `test/features/roda_reproducao/geometria_roda_test.dart`

**Interfaces:**
- Consumes: Tasks 1, 3.
- Produces: `RodaWidget({required List<PosicaoRoda> posicoes, required DateTime data, FaseRoda? faixaDestacada, required void Function(FaseRoda) aoTocarFaixa, required void Function(PosicaoRoda) aoTocarAnimal, required int foraDoCiclo})`.
- Portar do spike (`lib/features/roda_reproducao/presentation/pages/roda_reproducao_spike_page.dart`: `_Geo`, `_distribuir`, `_PintorRoda`) mantendo só a paleta Embrapa: faixas sólidas com marcas a cada 7 dias, marcas/rótulos da Global Constraints, meses girando no anel interno, centro com total + "+N fora do ciclo", alerta = anel escuro + selo "!" vermelho, novilha rosa, zoom por pinça (`InteractiveViewer`, 1–3x).

- [ ] **Step 1: testes:** `angulo(0)` aponta para baixo (π/2); `diaDoAngulo(ponto(100, r)) == 100`; `distribuirBolinhas` com 60 posições no mesmo dia → nenhuma distância entre centros < diâmetro.
- [ ] **Step 2–4:** FAIL → implementar → PASS; `flutter analyze lib/features/roda_reproducao` sem issues.

### Task 5: Página

**Files:**
- Create: `lib/features/roda_reproducao/presentation/pages/roda_reproducao_page.dart`
- Create: `lib/features/roda_reproducao/presentation/widgets/folha_animal_roda.dart`, `card_tarefa_roda.dart`
- Test: `test/features/roda_reproducao/roda_reproducao_page_test.dart`

**Interfaces:**
- Consumes: Tasks 1–4; `animaisByPropriedadeProvider(uidPropriedadePath)`; janelas existentes abertas exatamente como suas telas fazem: parto (`RegistrarPartoWidget`, Secas), secagem (`RegistrarSecagemWidget`, Prenhas), PP/DG+/DG− (como `diagnosticogestacao_page.dart`, respeitando `podeRegistrarDgMais`), cio (`RegistrarCioWidget`), inseminar (`NovaInseminacaoWidget`), exame (`NovaAcaoExameGinecologicoWidget`), prontuário.
- Produces: `RodaReproducaoPage({required DocumentReference? uidPropriedade, required String nomePropriedade, required String uidTecnico, required String emailPropriedade, required String diasDg, required bool visitaPresencial, ...})` — mesmos parâmetros que a página de DG recebe dos dois menus.

Layout (spec, seção "Tela"): `CabecalhoTela`, painel branco com propriedade·data, roda, contadores por estado (4 chips), seletor Hoje/+7/+30 (≠ hoje → faixa "Simulação: onde cada animal estará se nada for registrado"), "Esta semana" com `AbasPilula` + contador, cards `CartaoLista`/`ConteudoCardAnimal` com `SeloStatus`; toque na faixa troca a lista pela faixa ("Faixa X · Limpar") sem rolar; toque na bolinha abre a folha; estado vazio "Nenhum animal aqui nesta semana."

- [ ] **Step 1: teste de widget** com `ProviderScope` sobrescrevendo o provider com 6 animais: mostra contadores corretos, aba "Parir" com o animal esperado, tocar "+30 dias" mostra a faixa de simulação.
- [ ] **Step 2–4:** FAIL → implementar → PASS; analyze limpo.

### Task 6: Entradas nos menus, remoção do spike, teste no simulador

**Files:**
- Modify: `lib/features/produtor/presentation/widgets/propriedade_menu_grid.dart` (trocar card SPIKE por "Roda da Reprodução", ícone `Icons.donut_large_rounded`)
- Modify: `lib/features/propriedades/presentation/pages/inicio_propriedade_page.dart` (card equivalente após "Diagnóstico Gestação")
- Delete: `lib/features/roda_reproducao/presentation/pages/roda_reproducao_spike_page.dart`

- [ ] `flutter analyze` + `flutter test test/domain/roda_reproducao test/features/roda_reproducao` → tudo verde.
- [ ] Hot reload no iPhone 17 iOS 26.2 (produtor **teste100**); abrir a roda, conferir contadores, abas, folha, +7/+30; screenshots no scratchpad. Nenhum registro em dados que não sejam do teste100.

### Task 7: Documentação

**Files:**
- Create: `docs/roda-da-reproducao.md` — regras (faixas, posição, alertas, abas, novilhas, aborto/indução, gestação 280), telas e arquivos, como testar, limitações e v2 (imprimir/compartilhar).
