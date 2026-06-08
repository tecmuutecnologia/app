# Roteiro de Teste — Offline-first (sync hardening + animal-criado-offline)

Valida os commits desta sessão: ref da ação, fim da dupla-sync, reconcile de
`firestoreId`, snapshot da fila, E3p2 (agir sobre animal criado offline),
bezerro offline-first (passo 1) e parto de mãe-offline (passo 2).

## Pré-requisitos
- **Device real** (não simulador), build **debug**.
- **Base já sincronizada** antes de começar (logar online uma vez) — NÃO base
  limpa: assim também se valida a migração de schema do ObjectBox.
- Acesso ao **Console do Firebase → Firestore** para conferir documentos.
- Forma de cortar a rede (modo avião / Wi-Fi off). "Offline" abaixo = sem rede.
- Útil: ver os logs (`flutter run`) — há prints-âncora:
  - `🔗 N ação(ões) vinculada(s) ao animal recém-sincronizado` (cascata E3p2)
  - `📋 N ação(ões) sincronizada(s)`, `🐄 N animal(is) sincronizado(s)`

> Onde olhar no Firestore: ações em `tecnico/{uidTecnico}/acoes`; animais em
> `tecnico/{uidTecnico}/animaisProdutores`.

---

## Bloco A — Motor de sync (Fase 1, hardening)

### A1 — Ação online carrega a ref do animal e NÃO duplica
1. **Online**, animal **já sincronizado**, registre uma **inseminação**.
2. Firestore → `acoes`: deve existir **1** doc novo.
- [ ] Tem campo `uidAnimalAnimaisProdutores` = referência ao doc do animal
- [ ] Tem campo `uidPropriedade`
- [ ] É **um** doc só (sem duplicata)

### A2 — Ação offline → reconectar (1 doc, com ref)
1. **Offline**, registre uma ação em animal sincronizado.
2. **Reconecte** e aguarde o sync.
- [ ] Firestore: **1** doc da ação, com `uidAnimalAnimaisProdutores` preenchido
- [ ] **Sem** duplicata (não aparecem 2 docs da mesma ação)

### A3 — Edição posterior sincroniza (reconcile do firestoreId)
1. **Offline**, edite um dado (ex.: registrar uma ação que muda status do animal).
2. **Reconecte** (deixe sincronizar).
3. **Edite de novo** o mesmo animal/ação e reconecte.
- [ ] A **segunda** edição também chega ao Firestore (não vira no-op)

---

## Bloco B — E3p2: agir sobre animal criado OFFLINE

### B1 — Criar animal offline e sincronizar
1. **Offline**, cadastre um **novo animal**.
- [ ] Ele **aparece na lista** mesmo offline (vem do ObjectBox)
2. **Reconecte**.
- [ ] Firestore `animaisProdutores`: o animal aparece, **1** doc só

### B2 — ⭐ Ação sobre animal criado offline ANTES de sincronizar (núcleo do E3p2)
1. **Offline**, cadastre um animal novo.
2. **Sem reconectar**, registre uma **ação** nele pela lista (ex.: inseminação).
3. **Reconecte** e aguarde.
- [ ] Log mostra `🔗 ... ação(ões) vinculada(s) ...`
- [ ] Firestore: **o animal** subiu **e** **a ação** subiu logo depois
- [ ] A ação tem `uidAnimalAnimaisProdutores` = ref do **animal recém-criado**
- [ ] **Nada órfão** (ação sem ref) e **nada duplicado**
4. Repita o B2 com outras ações para cobrir as forms migradas:
- [ ] Inseminação  - [ ] Registrar cio  - [ ] DG (+ / −)  - [ ] Confirma PP
- [ ] Exame ginecológico  - [ ] Induzir lactação  - [ ] Registrar secagem
- [ ] Registrar aborto

### B3 — Migração legado→ObjectBox no login (passo 3a, anti-descarte)
Valida que animais presos no array antigo persistido NÃO são mais descartados.
1. Simular "usuário de upgrade": ter itens em `animaisProdutoresOffline`
   (SharedPreferences `ff_animaisProdutoresOffline`). Ex.: criar animal offline
   numa build ANTERIOR a esta sessão, ou injetar via debug.
2. Atualizar para esta build e **logar online** (passa pelo `sync_technician`).
- [ ] Os animais antigos **aparecem nas listas do ObjectBox**
- [ ] **Sobem ao Firestore** em `animaisProdutores` (1 doc cada, sem duplicata)
- [ ] Logar de novo: **não** duplica (idempotente por `uidAnimalOffline`)

---

## Bloco C — Parto + bezerro (passos 1 e 2)

### C1 — Parto ONLINE com novo bezerro
1. **Online**, animal sincronizado, registre **parto** marcando **"novo animal"**.
- [ ] Mãe atualizada (status `Vazia`, +1 parto)
- [ ] Bezerro criado no Firestore `animaisProdutores` **e** aparece na lista local

### C2 — Parto OFFLINE com bezerro (passo 1)
1. **Offline**, registre parto + bezerro de uma vaca sincronizada.
- [ ] O **bezerro aparece na lista** (ObjectBox) mesmo offline
- [ ] A mãe aparece atualizada localmente
2. **Reconecte**.
- [ ] Firestore: mãe atualizada **e** bezerro criado, **sem** perda/duplicata

### C3 — ⭐ Parto de mãe criada OFFLINE (passo 2)
1. **Offline**, cadastre uma **vaca nova**.
2. **Sem reconectar**, registre o **parto dela** pela lista do ObjectBox, com bezerro.
3. **Reconecte**.
- [ ] A **vaca (mãe)** sobe ao Firestore
- [ ] O **parto** está refletido nela (status/partos/datas)
- [ ] O **bezerro** sobe também
- [ ] Vínculos corretos, sem perda/duplicata

---

## Bloco D — Regressão rápida
- [ ] Login **offline** (reabrir o app sem rede) funciona
- [ ] Não há duplicação de animais/ações ao alternar online/offline algumas vezes
- [ ] Build **release** não mostra o botão/menu de **debug** no dashboard

---

## Se algo falhar, me passe
- Qual bloco/passo (ex.: **B2 – inseminação**).
- O que apareceu vs. o esperado (ex.: "ação sem `uidAnimalAnimaisProdutores`",
  "2 docs", "bezerro não apareceu na lista").
- Trechos do log com os emojis-âncora (🔗 / 📋 / 🐄 / ❌).
- Print do doc no Firestore quando for sobre campos/refs.

> Atenção: o **passo 3** (remover as variantes `_offline` + o array do FFAppState)
> NÃO foi feito ainda — é deleção data-crítica e só entra **depois** que este
> roteiro passar no device.
