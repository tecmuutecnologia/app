# Venda de animais — Plano de implementação

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Registrar a venda de animais (data + valor), tirá-los do rebanho como baixa e mostrar a receita por mês numa aba "Vendas" do Financeiro, preservada mesmo se o animal for removido.

**Architecture:** Venda é um registro próprio (`VendaAnimalEntity`, coleção `tecnico/{t}/propriedades/{p}/vendasAnimais`) sincronizado como o `financeiro`. O animal vendido fica com `status = 'Descarte'` + `tipoBaixa = 'venda'` (compatível com versões antigas). As regras de baixa ficam em funções puras de domínio que devolvem os mapas de atualização; um serviço fino aplica nos repositórios. UI: `flutter_slidable` na lista, botões em Bezerros/Editar, filtro Descartados|Vendidos na aba Descarte, abas Relatórios|Vendas no Financeiro.

**Tech Stack:** Flutter 3.47, ObjectBox (codegen), Cloud Firestore, `flutter_slidable`, `intl`, `mask_text_input_formatter`.

**Spec:** `docs/superpowers/specs/2026-11-18-venda-animais-design.md`

## Global Constraints

- Branch `feat/venda-animais`. Nunca merge em `main`/`dev` sem ordem explícita.
- Offline-first: toda gravação via repositório ObjectBox; tela nunca escreve no Firestore.
- Exclusão = soft delete (`isDeleted`/`excluido`), nunca `delete()`.
- Animal vendido: `status: 'Descarte'`, `tipoBaixa: 'venda'`, `motivoDescarteAnimal: 'Venda'`, `dtDescarteAnimal` = data da venda.
- Filtros: vendido = `status == 'Descarte' && tipoBaixa == 'venda'`; descartado = `status == 'Descarte' && tipoBaixa != 'venda'`. Nunca só `tipoBaixa`.
- Sêmens (`ehSemens(grupo)`) nunca podem ser vendidos; touros podem.
- Datas no formato `dd/MM/yyyy` (padrão do app, máscara `##/##/####`). Valor em `double` reais, exibido com `NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')`.
- Desfazer volta ao `statusAnterior`/`idStatusAnteriorAnimal`; ausente ⇒ `'Vazia'`/`2`.
- Vender um descartado não mexe em vaga; desfazer essa venda devolve aos Descartados.
- Receita de vendas **não** entra nos relatórios financeiros mensais.
- Textos de UI em pt-BR. Ao terminar cada task com UI, hot reload no app rodando; tasks com schema/pacote exigem build completo (avisar o usuário antes — apaga login no emulador).
- Deploy de regras Firestore só com autorização explícita do usuário, lendo antes as regras publicadas, conta `tecmuutecnologia@`.

## Review Focus

1. Campo de baixa precisa ser **limpo** ao desfazer: `aplicarDadosNoAnimal` e `updateFromFirestore` usam `?? atual` (null não limpa). Campos novos usam `containsKey`; teste em Task 2.
2. Valor digitado "1.234,56", "1234,5", "0", vazio, negativo: só `> 0` passa; teste em Task 4.
3. Data inválida/futura no modal ("31/02/2026", data após hoje): rejeitada; teste em Task 4.
4. Vender duas vezes o mesmo animal (toque duplo, ou já vendido via outro aparelho): bloqueado; teste em Task 3.
5. Venda cujo `dtVenda` não parseia não pode derrubar a aba Vendas: vai para grupo "Sem data" no fim; teste em Task 1.

---

### Task 1: Domínio da baixa e agrupamento de vendas

**Files:**
- Create: `lib/domain/animais/baixa_animal.dart`
- Create: `lib/domain/financeiro/vendas_por_mes.dart`
- Test: `test/domain/animais/baixa_animal_test.dart`, `test/domain/financeiro/vendas_por_mes_test.dart`

**Interfaces:**
- Produces:
  - `const kTipoBaixaVenda = 'venda'; const kTipoBaixaDescarte = 'descarte'; const kMotivoVenda = 'Venda';`
  - `bool ehVendido(String? status, String? tipoBaixa)`; `bool ehDescartadoSemVenda(String? status, String? tipoBaixa)`
  - `bool podeVender({required String? grupo, required String? status, required String? tipoBaixa, required bool isDeleted})` — falso para sêmens, vendidos, excluídos.
  - `class VendaResumo { String id; String titulo; DateTime? data; String dtTexto; double valor; }`
  - `class GrupoVendasMes { DateTime? mes; String rotulo; double total; List<VendaResumo> vendas; }`
  - `List<GrupoVendasMes> agruparVendasPorMes(List<VendaResumo> vendas)` — mês mais recente primeiro; dentro do mês, data mais recente primeiro; `data == null` vai para grupo `rotulo: 'Sem data'` no fim. Rótulo: `'Novembro 2026'` (`DateFormat('MMMM yyyy', 'pt_BR')`, primeira letra maiúscula).
  - `DateTime? parseDataBr(String? s)` — reusar util existente se houver (`grep -rn "dd/MM/yyyy" lib/core lib/domain`); senão criar aqui, estrito (rejeita 31/02).

- [ ] **Step 1: Testes falhando**

```dart
test('sêmen nunca vende', () => expect(podeVender(grupo: 'Sêmens', status: 'Vazia', tipoBaixa: null, isDeleted: false), isFalse));
test('touro vende', () => expect(podeVender(grupo: 'Touros', status: 'Ativo', tipoBaixa: null, isDeleted: false), isTrue));
test('descartado pode ser vendido', () => expect(podeVender(grupo: 'Vacas', status: 'Descarte', tipoBaixa: null, isDeleted: false), isTrue));
test('vendido não revende', () => expect(podeVender(grupo: 'Vacas', status: 'Descarte', tipoBaixa: 'venda', isDeleted: false), isFalse));
test('tipoBaixa sem status Descarte não é vendido', () => expect(ehVendido('Vazia', 'venda'), isFalse));
test('agrupa por mês, mais recente primeiro, total somado', () {
  final g = agruparVendasPorMes([v('a', DateTime(2026,10,5), 100), v('b', DateTime(2026,11,2), 50), v('c', DateTime(2026,11,20), 25.5)]);
  expect(g.map((x) => x.rotulo), ['Novembro 2026', 'Outubro 2026']);
  expect(g.first.total, 75.5);
  expect(g.first.vendas.map((x) => x.id), ['c', 'b']);
});
test('venda sem data vai para "Sem data" no fim', () { /* data null → último grupo, rotulo 'Sem data' */ });
test('parseDataBr rejeita 31/02/2026', () => expect(parseDataBr('31/02/2026'), isNull));
```

- [ ] **Step 2:** `flutter test test/domain/animais/baixa_animal_test.dart test/domain/financeiro/vendas_por_mes_test.dart` → FAIL (símbolos inexistentes).
- [ ] **Step 3:** Implementar. `initializeDateFormatting('pt_BR')` no `setUpAll` do teste se o locale exigir.
- [ ] **Step 4:** Rodar de novo → PASS.
- [ ] **Step 5:** Commit `feat(vendas): regras de baixa e agrupamento de vendas por mês`.

---

### Task 2: Campos de baixa no animal

**Files:**
- Modify: `lib/data/objectbox/entities/animal_entity.dart` (campos, construtor, `fromFirestore`, `toFirestore`, `updateFromFirestore`)
- Modify: `lib/data/objectbox/repositories/animal_repository.dart:25` (`aplicarDadosNoAnimal`)
- Modify: `lib/data/schema/structs/animais_produtores_struct.dart`, `lib/features/animais/application/animal_struct_adapter.dart`
- Regenerate: `lib/objectbox.g.dart`, `lib/objectbox-model.json`
- Test: `test/repositories/aplicar_dados_no_animal_test.dart`, `test/entities/animal_entity_test.dart`, `test/features/animal_struct_adapter_test.dart`

**Interfaces:**
- Produces (em `AnimalEntity` e no struct, mesmas chaves no Firestore):
  `String? tipoBaixa; String? statusAnterior; int? idStatusAnteriorAnimal; String? dtVendaAnimal; double? valorVendaAnimal; String? idVendaAtual; String? motivoDescarteAnterior; String? dtDescarteAnterior;`
- Lista exportada `const kCamposBaixa = [...]` (as 8 chaves) em `baixa_animal.dart` — Task 3 usa para limpar.

- [ ] **Step 1: Testes falhando**

```dart
test('update com chave presente e null limpa campo de baixa', () {
  final a = AnimalEntity(tipoBaixa: 'venda', valorVendaAnimal: 10);
  aplicarDadosNoAnimal(a, {'tipoBaixa': null, 'valorVendaAnimal': null});
  expect(a.tipoBaixa, isNull); expect(a.valorVendaAnimal, isNull);
});
test('update sem a chave preserva', () { /* {'nomeAnimal': 'x'} não toca tipoBaixa */ });
test('updateFromFirestore com chave null limpa tipoBaixa', ...);
test('toFirestore inclui as 8 chaves mesmo null', ...);
// adapter: round-trip entity→struct→entity preserva os 8 campos (estender o teste existente)
```

- [ ] **Step 2:** Rodar os três arquivos → FAIL.
- [ ] **Step 3:** Implementar. Campos novos com `if (data.containsKey(k)) entity.k = data[k]` (não `??`) em `aplicarDadosNoAnimal` e `updateFromFirestore`; `valorVendaAnimal` via `(x as num?)?.toDouble()`.
- [ ] **Step 4:** `dart run build_runner build --delete-conflicting-outputs` → gera sem erro; `git diff lib/objectbox-model.json` mostra só propriedades novas em `AnimalEntity`.
- [ ] **Step 5:** Rodar testes → PASS; `flutter test` inteiro → PASS.
- [ ] **Step 6:** Commit `feat(vendas): campos de baixa no animal`.

---

### Task 3: Entidade e sincronização da venda

**Files:**
- Create: `lib/data/objectbox/entities/venda_animal_entity.dart` (exportar em `entities/index.dart`)
- Create: `lib/data/objectbox/repositories/venda_animal_repository.dart`
- Modify: `lib/data/objectbox/objectbox_service.dart` (box, `removeAll`, `_pendentes`), `lib/data/objectbox/objectbox_auth_helper.dart:142` (purge)
- Modify: `lib/data/objectbox/offline_first_sync_service.dart` (download junto ao financeiro ~1157; `_syncModifiedVendas` espelhando `_syncModifiedFinanceiro` ~1637 e chamado ao lado dele ~1360; `_etapaDe` e `_aplicarDelta` para `TipoEscuta.vendas`; `Future<void> puxarVendas(String propriedadePath)`)
- Modify: `lib/core/sync/escuta_remota.dart` (enum + `alvosDeVendas`)
- Test: `test/entities/venda_animal_entity_test.dart`, `test/core/sync/escuta_remota_test.dart`

**Interfaces:**
- Produces:
  - `VendaAnimalEntity implements SyncableEntity` com `firestoreId, parentPath (path da propriedade), uidPropriedadePath, uidTecnicoPath, animalId, nomeAnimal, brincoAnimal, grupoAnimal, String dtVenda ('dd/MM/yyyy'), double valorVenda` + campos de sync iguais ao `FinanceiroEntity`; `fromFirestore(data, id, {parentPath})`, `toFirestore()`.
  - `VendaAnimalRepository extends BaseSyncRepository<VendaAnimalEntity>`: `collectionName = 'vendasAnimais'`, `syncedByModifiedLoop = true`, `preGeneratesFirestoreId = true`, `getByFirestoreId`, `getByParentPath`, `getPendingSync`, `Stream<List<VendaAnimalEntity>> watchByParentPath(String)` — mesmo molde de `FinanceiroRepository`.
  - `TipoEscuta.vendas`; `List<AlvoEscuta> alvosDeVendas(String propriedadePath)` → um alvo `apenasPull: true`, `colecaoPath: '$propriedadePath/vendasAnimais'`, etapa `financeiro`.
  - `OfflineFirstSyncService.puxarVendas(String propriedadePath)` — sem gate de técnico (produtor e técnico), `avancarMarcaDaEtapa: false`; no-op offline ou sem sync inicial.

- [ ] **Step 1: Testes falhando** — round-trip `fromFirestore(toFirestore())` preserva todos os campos; `valorVenda` aceita `int` do Firestore; `alvosDeVendas('tecnico/t/propriedades/p')` tem `colecaoPath` `.../vendasAnimais` e `apenasPull`; `chaveDeMarca` dele é `pull_tecnico/t/propriedades/p/vendasAnimais`.
- [ ] **Step 2:** Rodar → FAIL.
- [ ] **Step 3:** Implementar entidade, repositório, registro no `ObjectBoxService`/purge, download, push e pull. Rodar `build_runner`.
- [ ] **Step 4:** Rodar testes → PASS; `flutter analyze` sem novos avisos.
- [ ] **Step 5:** Commit `feat(vendas): entidade e sync de vendasAnimais`.

---

### Task 4: Serviço de baixa (vender / descartar / desfazer)

**Files:**
- Create: `lib/features/animais/application/baixa_animal_service.dart`
- Modify: `lib/domain/animais/baixa_animal.dart` (funções puras de mapa)
- Test: `test/domain/animais/baixa_animal_test.dart`, `test/features/animais/baixa_animal_service_test.dart` (se houver molde de teste com ObjectBox; senão só domínio)

**Interfaces:**
- Consumes: Task 1, 2, 3.
- Produces (puras, em `baixa_animal.dart`):
  - `double? parseValorReais(String texto)` — aceita `'1.234,56'`, `'1234,5'`, `'R$ 10,00'`; `null` se vazio/inválido/`<= 0`.
  - `String? validarDataVenda(String texto, {required DateTime hoje})` — mensagem de erro ou `null`; rejeita inválida e futura.
  - `Map<String, dynamic> dadosVenda({required AnimalEntity animal, required String dtVenda, required double valor, required String idVenda})` — se o animal já é descartado: `statusAnterior: 'Descarte'`, `motivoDescarteAnterior`/`dtDescarteAnterior` = atuais; senão `statusAnterior = animal.status`, `idStatusAnteriorAnimal = animal.idStatusAnimal`. Sempre `status: 'Descarte'`, `tipoBaixa: 'venda'`, `motivoDescarteAnimal: 'Venda'`, `dtDescarteAnimal`/`dtVendaAnimal: dtVenda`, `valorVendaAnimal`, `idVendaAtual`.
  - `Map<String, dynamic> dadosDescarte({required AnimalEntity animal, required String dt, required String? motivo})` — status Descarte, `tipoBaixa: 'descarte'`, `statusAnterior`/`idStatusAnteriorAnimal`.
  - `Map<String, dynamic> dadosDesfazerVenda(AnimalEntity animal)` — se `statusAnterior == 'Descarte'`: volta a descartado (`tipoBaixa: 'descarte'`, motivo/dt anteriores); senão `status: statusAnterior ?? 'Vazia'`, `idStatusAnimal: idStatusAnteriorAnimal ?? 2`. Todas as chaves de `kCamposBaixa` não usadas vão como `null`.
  - `Map<String, dynamic> dadosDesfazerDescarte(AnimalEntity animal)` — `statusAnterior ?? 'Vazia'`, `idStatusAnteriorAnimal ?? 2`, limpa `kCamposBaixa`.
  - `bool vendaMexeEmVaga(AnimalEntity a)` = `animalOcupaVaga(a)`; `bool desfazerVendaMexeEmVaga(AnimalEntity a)` = `a.statusAnterior != 'Descarte'`.
- Produces (serviço, `BaixaAnimalService({AnimalRepository?, VendaAnimalRepository?, TecnicoRepository?})`):
  - `Future<void> vender({required AnimalEntity animal, required String propriedadePath, required String dtVenda, required double valor})` — lança `StateError` se `!podeVender(...)`; cria venda (cópia nome/brinco/grupo, `uidTecnicoPath = tecnico do parentPath`), atualiza animal, `devolverCotaAnimais` se ocupava.
  - `Future<void> descartar({required AnimalEntity animal, required String dt, required String? motivo})`
  - `Future<void> desfazerVenda(AnimalEntity animal)` — soft delete da venda `idVendaAtual` (se achar), aplica `dadosDesfazerVenda`, `debitarCotaAnimais` se `desfazerVendaMexeEmVaga`. **A checagem de vaga (`garantirVagaAnimal`) fica na UI antes de chamar**, como hoje.
  - `Future<void> desfazerDescarte(AnimalEntity animal)` — aplica `dadosDesfazerDescarte` + `debitarCotaAnimais`.

- [ ] **Step 1: Testes falhando**

```dart
test('valor', () { expect(parseValorReais('1.234,56'), 1234.56); expect(parseValorReais('0'), isNull); expect(parseValorReais(''), isNull); expect(parseValorReais('-5'), isNull); });
test('data futura rejeitada', () => expect(validarDataVenda('19/11/2026', hoje: DateTime(2026,11,18)), isNotNull));
test('data inválida rejeitada', () => expect(validarDataVenda('31/02/2026', hoje: DateTime(2026,11,18)), isNotNull));
test('vender ativo guarda status anterior', () { final m = dadosVenda(animal: AnimalEntity(status: 'Prenha', idStatusAnimal: 5), dtVenda: '18/11/2026', valor: 10, idVenda: 'v1'); expect(m['statusAnterior'], 'Prenha'); expect(m['status'], 'Descarte'); expect(m['tipoBaixa'], 'venda'); expect(m['motivoDescarteAnimal'], 'Venda'); });
test('vender descartado guarda descarte anterior', () { /* statusAnterior 'Descarte', motivoDescarteAnterior = 'Idade' */ });
test('desfazer venda de descartado volta a descartado com motivo original e não mexe em vaga', ...);
test('desfazer venda limpa campos de venda (chaves presentes com null)', ...);
test('desfazer descarte antigo sem statusAnterior volta Vazia/2', ...);
test('vender já vendido lança StateError', ...); // serviço, se houver molde ObjectBox de teste
```

- [ ] **Step 2:** Rodar → FAIL. **Step 3:** Implementar. **Step 4:** Rodar → PASS.
- [ ] **Step 5:** Commit `feat(vendas): serviço de baixa com venda e desfazer`.

---

### Task 5: Modal Vender + descarte usando o serviço

**Files:**
- Create: `lib/features/animais/presentation/widgets/vender_animal_widget.dart`
- Create: `lib/features/animais/presentation/abrir_baixa.dart` — helpers `Future<void> abrirVenda(BuildContext, {required AnimalEntity animal, required String propriedadePath})` e `abrirDescarte(...)` (move o corpo de `_abrirDescarte` de `lista_animais_page.dart:137` para cá, reaproveitado nas Tasks 6–8)
- Modify: `lib/features/animais/presentation/widgets/descarte_animal_widget.dart:~478` (gravar via `BaixaAnimalService.descartar`)
- Test: `test/features/animais/vender_animal_widget_test.dart`

**Interfaces:**
- Consumes: Task 4.
- Produces: `VenderAnimalWidget({required AnimalEntity animal, required String propriedadePath})` — bottom sheet no estilo do `DescarteAnimalWidget`: título "Vender {nome/brinco}", campo Data (pré-preenchido `DateFormat('dd/MM/yyyy').format(hoje)`, máscara, seletor), campo Valor (teclado numérico, prefixo "R$"), botão "Salvar". Erros inline: "Informe uma data válida" / "Data no futuro" / "Informe o valor da venda". Salvar desabilita enquanto grava (evita toque duplo) e fecha com `Navigator.pop(context, true)`.

- [ ] **Step 1: Teste de widget falhando** — data vem preenchida com hoje; Salvar com valor vazio mostra "Informe o valor da venda" e não chama o serviço (injetar serviço fake via parâmetro opcional `service`).
- [ ] **Step 2:** FAIL. **Step 3:** Implementar; trocar a gravação do descarte pelo serviço (mantém a confirmação e a devolução de vaga, agora dentro do serviço). **Step 4:** PASS + `flutter test`.
- [ ] **Step 5:** Commit `feat(vendas): modal de venda e descarte via serviço de baixa`.

---

### Task 6: Arrasto Vender | Descartar e botão fixo nos Bezerros

**Files:**
- Modify: `pubspec.yaml` (`flutter_slidable: ^4.0.0`; se não resolver com o SDK, `^3.1.2`)
- Modify: `lib/features/animais/presentation/animal_group_list_view.dart:158-212` (trocar `Dismissible`/`_faixaDescartar` por `Slidable`)
- Modify: `lib/features/animais/presentation/pages/lista_animais_page.dart` (passar `onVender`; `mostrarBotaoVender: true` só na aba Bezerros)
- Test: `test/features/animal_group_list_view_test.dart`

**Interfaces:**
- Consumes: Task 5 (`abrirVenda`, `abrirDescarte`).
- Produces: `AnimalGroupListView` ganha `final void Function(String firestoreId)? onVender;` e `final bool mostrarBotaoVender;` (default false). `endActionPane` com `ScrollMotion`, `extentRatio` ~0.5, duas `SlidableAction`: **Vender** (`AppTokens.brand`, `Icons.sell_outlined`) e **Descartar** (`error`, `Icons.inventory_2_outlined`); Vender ausente quando `!podeVender(...)` (sêmens). Tocar fora fecha (`SlidableAutoCloseBehavior` envolvendo a lista). Botão fixo: `TextButton.icon` "Vender" no card quando `mostrarBotaoVender && podeVender`.

- [ ] **Step 1: Testes de widget falhando** — arrastar card revela "Vender" e "Descartar" e o card permanece; tocar "Vender" chama `onVender(id)`; em grupo Sêmens só "Descartar"; com `mostrarBotaoVender` o botão aparece sem arrastar; animal em baixa não arrasta.
- [ ] **Step 2:** FAIL. **Step 3:** `flutter pub get`; implementar. **Step 4:** PASS.
- [ ] **Step 5:** Commit `feat(vendas): arrasto vender/descartar e botão vender nos bezerros`.
- [ ] **Step 6:** Avisar o usuário: pacote novo + schema ⇒ **build completo** (Tasks 2–3 já exigiam); validar no aparelho o arrasto travando aberto.

---

### Task 7: Vender e Descartar no Editar animal

**Files:**
- Modify: `lib/features/animais/presentation/pages/editar_animal_page.dart` (perto do fim do formulário, antes do `RodapeAcao` ~1478)

**Interfaces:** Consumes `abrirVenda`/`abrirDescarte` (Task 5), `podeVender`, `ehDescarte`.

- [ ] **Step 1:** Adicionar uma linha com dois botões contornados "Vender" e "Descartar" no fim do formulário. Vender só se `podeVender`; ambos ocultos se `ehDescarte(animal.status)`. Se o modal retornar `true`, sair da tela (`_voltar()`), sem salvar edições pendentes — antes de abrir o modal, se houver alterações não salvas, perguntar "Descartar alterações e continuar?" (`confirmarAcao`).
- [ ] **Step 2:** `flutter analyze` limpo; hot reload; validar no app: vender pelo editar leva de volta e o animal sumiu da lista.
- [ ] **Step 3:** Commit `feat(vendas): vender e descartar pelo editar animal`.

---

### Task 8: Aba Descarte com Descartados | Vendidos

**Files:**
- Modify: `lib/features/secas/application/filtros_secas.dart:54` (aba descarte recebe subfiltro)
- Modify: `lib/features/secas/presentation/pages/secas_page.dart` (subfiltro, cards, ações, lote ~394–482, `_restaurar` ~663)
- Test: `test/features/secas/filtros_secas_test.dart` (criar se não existir no diretório)

**Interfaces:**
- Consumes: Task 1 (`ehVendido`, `ehDescartadoSemVenda`), Task 4 (serviço), Task 5 (`abrirVenda`).
- Produces: `enum SubfiltroDescarte { descartados, vendidos }`; filtro da aba descarte usa `ehDescartadoSemVenda` / `ehVendido` com `item.tipoBaixa`.

- [ ] **Step 1: Teste falhando** — item `status 'Descarte', tipoBaixa null` só em Descartados; `tipoBaixa 'venda'` só em Vendidos; `status 'Vazia', tipoBaixa 'venda'` em nenhum.
- [ ] **Step 2:** FAIL. **Step 3:** Implementar:
  - Pílulas internas "Descartados (n)" | "Vendidos (n)" no topo da aba; trocar limpa a seleção.
  - Card descartado: "Desfazer descarte" (antes "Restaurar"; usa `garantirVagaAnimal` + `desfazerDescarte`), "Vender" (abre modal; sem vaga), "Eliminar".
  - Card vendido: mostra data e valor (`R$`); "Desfazer venda" (confirmação: "A receita desta venda sairá do Financeiro."; `garantirVagaAnimal` só se `desfazerVendaMexeEmVaga`), "Eliminar" (mensagem: "A venda continua no Financeiro.").
  - Lote: em Descartados "Desfazer descarte"/"Eliminar"; em Vendidos "Desfazer venda"/"Eliminar"; vaga "todos ou nenhum" conta só os que mexem em vaga.
- [ ] **Step 4:** PASS; hot reload; validar no app.
- [ ] **Step 5:** Commit `feat(vendas): aba descarte separa descartados e vendidos`.

---

### Task 9: Aba Vendas no Financeiro

**Files:**
- Modify: `lib/features/financeiro/presentation/pages/relatorio_financeiro_page.dart` (abas pílula, rodapé só em Relatórios)
- Create: `lib/features/financeiro/presentation/widgets/vendas_por_mes_view.dart`
- Test: `test/features/financeiro/vendas_por_mes_view_test.dart`

**Interfaces:**
- Consumes: `VendaAnimalRepository.watchByParentPath` (Task 3), `agruparVendasPorMes` (Task 1), `puxarVendas` (Task 3).
- Produces: `VendasPorMesView({required String propriedadePath})` — filtra `!isDeleted`, mapeia para `VendaResumo` (`titulo` = `tituloNomeBrinco(nome, brinco)`), cabeçalho por mês "Novembro 2026 · R$ 12.400,00", linhas com título, data e valor; vazio: "Nenhuma venda registrada". Chama `puxarVendas` uma vez no `initState`.

- [ ] **Step 1: Teste de widget falhando** — com duas vendas em meses diferentes mostra dois cabeçalhos com totais formatados `R$ 1.234,56`; venda `isDeleted` não aparece; lista vazia mostra o texto vazio.
- [ ] **Step 2:** FAIL. **Step 3:** Implementar; abas "Relatórios" | "Vendas" seguindo `docs/padrao-layout-listas.md`. **Step 4:** PASS; hot reload; validar.
- [ ] **Step 5:** Commit `feat(vendas): aba vendas no financeiro`.

---

### Task 10: Regra do Firestore e fila

**Files:**
- Modify: `firebase/firestore.rules` (perto da regra de `financeiro`, linha ~62)

- [ ] **Step 1:** Baixar as regras publicadas (`firebase firestore:rules:get` / console com `--account tecmuutecnologia@...`) e comparar com `firebase/firestore.rules`; partir da versão publicada.
- [ ] **Step 2:** Adicionar `match /tecnico/{tecnico}/propriedades/{propriedade}/vendasAnimais/{document}` com as mesmas condições do `financeiro` publicado (e `{path=**}/vendasAnimais` se o financeiro tiver o equivalente).
- [ ] **Step 3:** Verificar no `offline_first_sync_service.dart` (~1459 e no `_syncModifiedVendas`) que erro de permissão mantém `needsSync = true` (não marca como sincronizado). Se marcar, corrigir e cobrir com teste.
- [ ] **Step 4:** Mostrar o diff das regras ao usuário e **pedir autorização** para `firebase deploy --only firestore:rules`. Deploy só após o "sim".
- [ ] **Step 5:** Commit `feat(vendas): regra firestore de vendasAnimais`.

---

### Task 11: Verificação final

- [ ] `flutter analyze` sem novos problemas; `flutter test` inteiro PASS.
- [ ] Build completo no aparelho/emulador (avisar antes). Roteiro manual, online e **offline**:
  1. Arrastar vaca → trava em Vender | Descartar; vender com hoje e R$ 1.500 → some da lista, aparece em Secas › Descarte › Vendidos e no Financeiro › Vendas no mês atual.
  2. Bezerro: botão Vender no card. Sêmen: sem Vender.
  3. Editar touro → Vender.
  4. Descartar vaca, depois Vender pelo card descartado → vai para Vendidos; Desfazer venda → volta a Descartados com motivo original; contagem de vagas inalterada.
  5. Desfazer venda de animal ativo → volta ao status anterior (ex.: Prenha) e a venda some do Financeiro.
  6. Eliminar um vendido → venda continua no Financeiro.
  7. Offline: vender; reconectar → venda sobe; outro aparelho/produtor vê ao abrir Financeiro › Vendas.
- [ ] Atualizar memória do projeto (estado da branch) e reportar ao usuário.
