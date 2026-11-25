# Roda da Reprodução

Tela que adapta ao Tecmuu a "Roda da Reprodução" da Embrapa (programa Balde
Cheio — manual em vídeo: https://www.youtube.com/watch?v=KGZwovot5cc).

**Para que serve:** bater o olho e saber o que fazer na semana (parir, secar,
diagnóstico, cio, pós-parto, atrasadas) e ter um retrato do rebanho inteiro
num único ciclo de 365 dias.

**Quem vê:** produtor e técnico, no menu da propriedade (card "Roda da
Reprodução", entre "Resumo Rebanho" e "Calendário Sanitário"). Funciona offline: lê os
animais do banco local (ObjectBox). A roda **não grava nada** — os registros
usam as janelas que já existem no app.

Branch: `feat/roda-da-produtividade` · desenho aprovado em 24/11/2026
(`docs/superpowers/specs/2026-11-24-roda-da-reproducao-design.md`).

---

## 1. Como ler a roda

```
            ┌───────── PRENHE (azul) ─────────┐
   COBERTURA│                                 │
   (amarelo)│        ● bolinhas = animais      │
   DG 40d ──┤        cor  = estado real        │
   Cio 21d ─┤        faixa = onde deveria estar│
   Cobrir ──┤              (centro: total)     │
            │                                  ├── Secar
 PÓS-PARTO  │                                  │
 (vermelho) │                                  │ SECA (verde)
   60 45 30 └──────────── ▲ HOJE · PARTO ──────┘ 30
```

- O ciclo tem **365 dias**. **HOJE · PARTO** fica fixo embaixo; os dias
  correm no sentido horário (sobem pela esquerda).
- **Faixas fixas (paleta Embrapa):**

| Dias do ciclo | Faixa | Cor | Marcas |
|---|---|---|---|
| 0 – 83 | Pós-parto | vermelho `#E5482F` | 30, 45, 60 |
| 83 – 143 | Cobertura | amarelo `#F2C230` | 83 "Cobrir", 104 "Cio 21d", 123 "DG 40d" |
| 143 – 305 | Prenhe | azul `#2F7FD8` | — |
| 305 – 365 | Seca | verde `#7AA64A` | 305 "Secar", 335 "30" |

- O **anel interno dos meses** gira com a data: o mês de hoje fica embaixo e
  os anteriores seguem no sentido horário.
- **Cor da bolinha = estado real do animal** (status):
  Vazia/Aborto → vermelho · Inseminada/Inseminada PP → amarelo ·
  Prenha → azul · Seca/Pré-parto → verde.
  **Novilhas** cobertas ficam rosa-claro `#F6B3C6`; prenhes ou em pré-parto,
  rosa-forte `#E4589A` (como no app da Embrapa).
- **Anel escuro + selo "!" vermelho = fora da fase** (ver §3).
- Número na bolinha: brinco de até 4 dígitos inteiro; 5 ou mais dígitos
  mostra os 4 últimos (o número completo aparece ao tocar); sem brinco, a
  inicial do nome.
- Bolinhas do mesmo dia **empilham para dentro**, ao longo do raio (como no
  original). Se não houver espaço, deslizam **no máximo 12 dias** para o lado.
  Se ainda não couber, as bolinhas diminuem um pouco (até 7,5 px de raio,
  para o número continuar legível — o **zoom de pinça** vai até 3,5×). O que
  sobrar (ex.: lote grande de IATF no mesmo dia) vira um **selo escuro
  "+N"** perto do dia certo, num espaço livre (não cobre bolinhas); tocar
  nele filtra a faixa daquele dia. Assim nenhum animal é desenhado em outra faixa.
- No centro: total de animais na roda, a data exibida e "**+N fora do
  ciclo**" (vazias há mais de 365 dias, que não têm lugar honesto na roda).

## 2. Posição de cada animal (dia do ciclo)

| Situação | Dia do ciclo na data D |
|---|---|
| **Coberta** (Inseminada, Inseminada PP, Prenha, Seca, Pré-parto) | `365 − (parto previsto − D)` |
| **Vazia / Aborto** | `D − último parto` |
| **Vaca em indução de lactação** (indução mais recente que o último parto) | `D − data da indução` |

- **Parto previsto** = `dtPartoPrevisto` gravado; sem ele, **IA + 280 dias**
  (mesma conta do app, `somarDataParto`). Assim a vaca chega em "HOJE ·
  PARTO" exatamente no dia do parto previsto e a secagem prevista do app
  (IA + 220) cai na marca "Secar" (305). A IA fica no dia 85, 2 dias depois
  da marca "Cobrir" — diferença dos 282 dias da Embrapa, decisão consciente.
- **DG−, "Fez cio" e aborto não mudam a âncora**: a vaca continua posicionada
  pelo último parto (regra da Embrapa: "com DG negativo ela volta a ficar
  vermelha na data do parto anterior"). A abortada aparece em Atrasadas.
- **Não entram na roda:** bezerros/bezerras, recria, touros, sêmen,
  descartados/vendidos, novilha vazia, e qualquer animal sem a data que a
  regra precisa.
- Datas aceitas: `dd/MM/aaaa`, também sem zero à esquerda (`5/3/2026`).
  Datas vazias, inexistentes (`31/02`), sentinela (ano ≥ 2050, ex.:
  `31/12/2050`) ou < 1990 contam como "sem data".
- **Datas impossíveis** — parto no futuro, ou parto previsto a mais de 365
  dias — deixam o animal fora da roda (antes ele cairia em "HOJE · PARTO").

## 3. Alertas ("fora da fase")

| Alerta | Regra | Texto |
|---|---|---|
| Sem cobertura | vazia com **> 83 dias** pós-parto | "Sem cobertura há N dias (ideal até 83)" |
| DG atrasado | inseminada **sem DG+ deste ciclo** com **> 60 dias** da IA (DG+ anterior à IA atual não conta) | "N dias da IA sem diagnóstico" |
| Secagem atrasada | **vaca** prenhe no dia **> 312** (305 + 7) — novilha não seca | "Secagem atrasada N dias" |
| Parto atrasado | coberta com DG, **> 3 dias** depois do parto previsto | "Parto atrasado N dias" |
| Fora do ciclo | vazia com **> 365 dias** pós-parto (sai da roda) | "Fora do ciclo: N dias desde o parto" |

Coberta com mais de 365 dias fica desenhada no dia 364 (junto do "hoje") com
o alerta correspondente.

## 4. "Esta semana"

Janela = **7 dias** a partir da data exibida. Abas com contador:

| Aba | Quem entra | Botões |
|---|---|---|
| **Parir** | coberta com parto previsto em até 7 dias ou já atrasado — **inclusive inseminada nunca diagnosticada** (o produtor vê a vaca parindo) | Parto |
| **Secar** | **vaca** prenhe (status Prenha) a partir do dia 298 | Secagem |
| **Diagnóstico** | inseminada sem DG com dias pós-IA ≥ `diasDg` da propriedade (mesmo critério da tela de DG; inclui novilhas) | PP · DG+ · DG− (DG+ só depois do PP, como na tela de DG) |
| **Cio 21d** | inseminada sem DG com 18 a 24 dias pós-IA | Fez cio · Inseminar |
| **Pós-parto 30d** | vazia com 28 a 45 dias pós-parto (avaliação reprodutiva) | Exame |
| **Atrasadas** | qualquer alerta da §3 | conforme o alerta |

Ordem em cada aba: fora da fase primeiro, depois pelo dia do ciclo.

Inseminada sem DG a partir de 273 dias da IA (a 7 dias do parto) mostra
**Parto · DG−** em vez de PP/DG+/DG− fora da aba Parir.

## 5. Interações

- **Contadores** (Pós-parto / Cobertura / Prenhe / Seca) contam pela **cor**
  (estado real), igual à legenda.
- **Tocar numa faixa da roda ou num contador** troca a lista por **todos os
  animais posicionados naquela faixa** ("Faixa Cobertura"), fora da fase
  primeiro; as outras faixas e bolinhas ficam esmaecidas. "Limpar" (ou tocar
  de novo) volta para "Esta semana". A tela não rola sozinha.
- **Tocar numa bolinha** abre a folha do animal: último parto, dias pós-parto,
  última IA, parto previsto, aviso de fase, botões de registro e
  "Abrir prontuário".
- **Hoje / +7 dias / +30 dias** simulam a data: a roda gira e as abas se
  recalculam. Aparece o aviso "Simulação: onde cada animal estará em
  dd/mm/aaaa se nada for registrado até lá." Nada é gravado.
- Depois de qualquer registro feito pela roda, a tela recarrega do banco e a
  bolinha muda de cor/posição na hora.

## 6. Arquivos

| Arquivo | O que tem |
|---|---|
| `lib/domain/roda_reproducao/ciclo_reproducao.dart` | constantes do ciclo, `FaseRoda`, `AnimalRoda`, `PosicaoRoda`, `calcularPosicao`, alertas |
| `lib/domain/roda_reproducao/tarefas_semana.dart` | `AbaSemana`, `abasDe`, `agruparSemana`, `contarPorEstado`, `naFaixa` |
| `lib/features/roda_reproducao/application/animal_roda_adapter.dart` | `AnimalEntity → AnimalRoda`, `rotuloBrinco` |
| `lib/features/roda_reproducao/application/acoes_roda.dart` | `acoesPara`, `dgMaisHabilitado`, `textoAlerta` |
| `lib/features/roda_reproducao/presentation/widgets/geometria_roda.dart` | dia ↔ ângulo, distribuição das bolinhas sem sobreposição |
| `lib/features/roda_reproducao/presentation/widgets/roda_widget.dart` | paleta Embrapa, `RodaWidget` + pintor (faixas, marcas, meses, bolinhas, centro) |
| `lib/features/roda_reproducao/presentation/widgets/card_tarefa_roda.dart` | card da lista, botões, folha do animal |
| `lib/features/roda_reproducao/presentation/pages/roda_reproducao_page.dart` | a tela (rota `rodaReproducao`) |
| `lib/app/router/nav.dart` | rota registrada |
| `lib/features/produtor/presentation/widgets/propriedade_menu_grid.dart` | card no menu do produtor |
| `lib/features/propriedades/presentation/pages/inicio_propriedade_page.dart` | card no menu do técnico |
| `lib/core/ui/abas_pilula.dart` | **correção compartilhada**: as pílulas agora rolam só na horizontal (antes rolavam a página e escondiam a roda) |

## 7. Testes

| Teste | Cobre |
|---|---|
| `test/domain/roda_reproducao/ciclo_reproducao_test.dart` | faixas, cor por status, posição de vazia/coberta, IA+280, indução, aborto, todos os alertas e limites, elegibilidade, novilha |
| `test/domain/roda_reproducao/tarefas_semana_test.dart` | cada aba e seus limites, `diasDg`, novilha fora de Secar, ordenação, contadores pela cor, filtro por faixa |
| `test/features/roda_reproducao/animal_roda_adapter_test.dart` | datas `dd/MM/yyyy`, sentinela 2050, lixo, rótulo do brinco |
| `test/features/roda_reproducao/acoes_roda_test.dart` | botões por aba/alerta/estado, DG+ só após PP, textos de alerta |
| `test/features/roda_reproducao/geometria_roda_test.dart` | dia 0 embaixo, sentido horário, inverso ângulo↔dia, 5/20/60/150 no mesmo dia sem sobreposição e sem sair ±12 dias (sobra vira "+N"), selos sem cobrir bolinhas (caso real do teste100), 60 animais espalhados sem grupos, empilhamento para dentro |
| `test/features/roda_reproducao/desempenho_roda_test.dart` | 300/600/1000 animais distribuídos em < 250 ms (medido: 5–18 ms) |
| `test/features/roda_reproducao/roda_reproducao_page_test.dart` | contadores, aba Parir/Atrasadas, filtro por faixa + Limpar, aviso de simulação |
| `test/core/ui/abas_pilula_test.dart` | trocar de aba não rola a página |

Rodar: `flutter test test/domain/roda_reproducao test/features/roda_reproducao test/core/ui/abas_pilula_test.dart`.
Suíte completa em 24/11/2026: 878 testes, todos verdes.

**Validação manual** (iPhone 17 iOS 26.2, produtor **teste100**): menu → roda
com 24 animais reais e 1 fora do ciclo, folha do animal, filtro "Cobertura",
"+30 dias". Nenhum registro foi feito durante a validação.

## 8. Limitações conhecidas e próximos passos (v2)

- Imprimir/compartilhar a imagem da roda (o original permite) — fora da v1.
- Busca por brinco, filtros extras e importação de arquivo da Embrapa — fora
  da v1.
- Os dias das faixas (83/143/305) e das marcas são fixos, como no original.
- A tela recarrega ao abrir e após registros feitos nela; uma mudança vinda
  de outro aparelho (sync em tempo real) aparece ao reabrir a tela.
- Coberta sem IA **e** sem parto previsto não entra na roda.
