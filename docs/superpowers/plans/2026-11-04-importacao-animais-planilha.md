# Importação de animais por planilha + vagas do plano — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fazer o limite de animais e de produtores do plano valer de verdade (devolução de vaga, limite vindo do plano, recálculo na sincronização, bloqueio) e permitir ao técnico importar o rebanho de uma planilha `.xlsx`.

**Architecture:** Regras em funções puras de domínio (vagas, plano ativo, regra de cadastro, leitura da planilha), testadas sem Firebase/ObjectBox. Repositórios e telas só aplicam essas regras: gravação sempre no ObjectBox (offline-first), contadores do técnico por delta na fila (`QueueIncrement`), e o recálculo absoluto só no aparelho do técnico, online, com a fila do técnico vazia. Parte A (Tasks 1–5) é independente e pode ir sozinha para a `dev`; Parte B (Tasks 6–11) é a importação.

**Tech Stack:** Flutter 3.47, Dart 3, Riverpod, ObjectBox, Cloud Firestore, `excel` 2.1.0, `file_picker` 10.1.9, `path_provider`, `share_plus` (novo).

**Spec:** `docs/superpowers/specs/2026-11-04-importacao-animais-planilha-design.md`

## Global Constraints

- Toda a UI e mensagens em pt-BR.
- Não mudar caminhos do Firestore. Animais em `tecnico/{id}/animaisProdutores` com `uidTecnicoPropriedade`; propriedades em `tecnico/{id}/propriedades`.
- Nunca `doc.delete()` em coleção sincronizada (exclusão = marca `excluido`, `lib/core/sync/exclusao_remota.dart`).
- Gravação de animal sempre via `criarAnimalOffline` (ObjectBox + `needsSync`); cota via `TecnicoRepository` (local na hora + `QueueIncrement` na fila).
- Nenhum animal ou propriedade é removido ou escondido por estar acima do limite; quem passou só não cadastra novos.
- Animal ativo (ocupa vaga) = `!isDeleted && !ehDescarte(status)`. Sêmen e touro contam.
- Produtor ativo (ocupa vaga) = propriedade do técnico com `contaCriada == true`, inclusive na lixeira (`isDeleted == true`).
- Aparelho sem o `TecnicoEntity` local (produtor) não bloqueia.
- Importação só aparece para o técnico logado. Android e iOS.
- Não rodar `flutter run`/rebuild do app: validação no aparelho é com hot reload, feita pelo controlador ao final.
- Testes: `flutter test <arquivo>`; análise: `flutter analyze <arquivos tocados>` sem novos issues.
- Commits terminam com `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`. Sem push, merge ou deploy.

## Review Focus

1. Recálculo rodando com débito ainda na fila (animal criado offline, sync volta) → não pode descontar duas vezes: o recálculo é pulado enquanto houver operação pendente do técnico (Task 4, teste `pulaComFilaPendente`).
2. Plano sem `limiteAnimais`/`limitePropriedade` (campo ausente → getter devolve 0) → manter o limite atual, nunca zerar o saldo de todo mundo (Task 1, teste `limiteAusenteMantemAtual`).
3. Planilha com linhas em branco no fim (comum ao apagar conteúdo no Excel) → ignoradas, não contadas como recusadas (Task 8, teste `ignoraLinhasVazias`).
4. Mesma planilha importada duas vezes, e linha repetida dentro da planilha → recusa "já cadastrado" / "repetido na linha N", nada duplicado (Task 9, testes `reimportarNaoDuplica` e `repetidaNaPlanilha`).
5. Saldo menor que as válidas → importa só os X primeiros e o restante aparece como "limite do plano atingido" no resultado (Task 9, teste `cortaNoLimite`).

---

## Parte A — Vagas do plano

### Task 1: Regras puras de vagas e do plano ativo

**Files:**
- Create: `lib/domain/plano/vagas.dart`
- Create: `lib/domain/plano/plano_ativo.dart`
- Test: `test/domain/plano/vagas_test.dart`, `test/domain/plano/plano_ativo_test.dart`

**Interfaces:**
- Produces:
  - `bool animalOcupaVaga(AnimalEntity a)` — `!a.isDeleted && !ehDescarte(a.status)` (`ehDescarte` de `lib/domain/animais/classificacao_animal.dart`).
  - `int contarAnimaisAtivos(Iterable<AnimalEntity> animais, {required String tecnicoPath})` — filtra `parentPath == tecnicoPath` e `animalOcupaVaga`.
  - `int contarProdutoresAtivos(Iterable<PropriedadeEntity> props, {required String tecnicoPath})` — `parentPath == tecnicoPath && contaCriada` (lixeira conta).
  - `class SaldoVagas { final int limite; final int quantidade; final int restante; }` com `==`/`hashCode`.
  - `SaldoVagas recalcularSaldo({required int limiteDoPlano, required int limiteAtual, required int ativos})` — `limite = limiteDoPlano > 0 ? limiteDoPlano : limiteAtual`; `quantidade = ativos`; `restante = limite - ativos` (pode ser negativo).
  - `bool temVaga(int? restante)` — `restante == null || restante > 0` (null = técnico ausente no aparelho → não bloqueia).
  - `int quantosCabem({required int? restante, required int validos})` — `restante == null ? validos : restante.clamp(0, validos)`.
  - `String? tecnicoIdDoPath(String? parentPath)` — `'tecnico/abc'` → `'abc'`; qualquer outra forma → `null`.
  - Em `plano_ativo.dart`: `class AssinaturaResumo { final String path; final String? planoPath; }`, `class AtivaResumo { final String? assinaturaPath; final DateTime? dtAssinatura; }`, `String? planoAtivoPath({required List<AssinaturaResumo> assinaturas, required List<AtivaResumo> ativas})` — escolhe, entre as ativas cujo `assinaturaPath` está em `assinaturas`, a de `dtAssinatura` mais recente (null perde), e devolve o `planoPath` da assinatura apontada; nada casou → `null`.

- [ ] **Step 1: Write the failing tests**

```dart
// vagas_test.dart
test('descartado e excluído não ocupam vaga', () {
  expect(animalOcupaVaga(AnimalEntity(status: 'Vazia')), isTrue);
  expect(animalOcupaVaga(AnimalEntity(status: 'Descarte')), isFalse);
  expect(animalOcupaVaga(AnimalEntity(status: 'Vazia', isDeleted: true)), isFalse);
});
test('conta só animais do técnico', () {
  final a = [
    AnimalEntity(parentPath: 'tecnico/t1', status: 'Vazia'),
    AnimalEntity(parentPath: 'tecnico/t1', grupoAnimal: 'Sêmens'),
    AnimalEntity(parentPath: 'tecnico/t1', status: 'Descarte'),
    AnimalEntity(parentPath: 'tecnico/t2', status: 'Vazia'),
  ];
  expect(contarAnimaisAtivos(a, tecnicoPath: 'tecnico/t1'), 2);
});
test('produtor na lixeira continua ocupando vaga', () {
  final p = [
    PropriedadeEntity(parentPath: 'tecnico/t1', contaCriada: true),
    PropriedadeEntity(parentPath: 'tecnico/t1', contaCriada: true, isDeleted: true),
    PropriedadeEntity(parentPath: 'tecnico/t1', contaCriada: false),
  ];
  expect(contarProdutoresAtivos(p, tecnicoPath: 'tecnico/t1'), 2);
});
test('recalcula pelo plano e permite saldo negativo', () {
  expect(recalcularSaldo(limiteDoPlano: 200, limiteAtual: 50, ativos: 230),
      const SaldoVagas(limite: 200, quantidade: 230, restante: -30));
});
test('limiteAusenteMantemAtual', () {
  expect(recalcularSaldo(limiteDoPlano: 0, limiteAtual: 50, ativos: 10),
      const SaldoVagas(limite: 50, quantidade: 10, restante: 40));
});
test('temVaga e quantosCabem', () {
  expect(temVaga(null), isTrue);
  expect(temVaga(0), isFalse);
  expect(temVaga(-3), isFalse);
  expect(quantosCabem(restante: 3, validos: 10), 3);
  expect(quantosCabem(restante: -2, validos: 10), 0);
  expect(quantosCabem(restante: null, validos: 10), 10);
});
test('tecnicoIdDoPath', () {
  expect(tecnicoIdDoPath('tecnico/abc'), 'abc');
  expect(tecnicoIdDoPath('produtor/abc'), isNull);
  expect(tecnicoIdDoPath(null), isNull);
});

// plano_ativo_test.dart
test('acha o plano pela ativa que aponta para a assinatura mais nova', () {
  final assinaturas = [
    const AssinaturaResumo(path: 'assinatura-tecnico/a1', planoPath: 'planos-tecnicos/start'),
    const AssinaturaResumo(path: 'assinatura-tecnico/a2', planoPath: 'planos-tecnicos/pro'),
  ];
  final ativas = [AtivaResumo(assinaturaPath: 'assinatura-tecnico/a2', dtAssinatura: DateTime(2026, 5))];
  expect(planoAtivoPath(assinaturas: assinaturas, ativas: ativas), 'planos-tecnicos/pro');
});
test('duas ativas: vence a de dtAssinatura mais recente', () { /* a1@2026-01 vs a2@2026-05 → pro */ });
test('ativa apontando para assinatura de outro técnico ou nenhuma → null', () {
  expect(planoAtivoPath(assinaturas: const [], ativas: const []), isNull);
});
```

- [ ] **Step 2: Run** `flutter test test/domain/plano/` — Expected: FAIL (arquivos não existem).
- [ ] **Step 3: Implement** os dois arquivos conforme Interfaces (só Dart puro + entidades).
- [ ] **Step 4: Run** `flutter test test/domain/plano/` — Expected: PASS.
- [ ] **Step 5: Commit** `feat(plano): regras puras de vagas e do plano ativo`.

### Task 2: Devolução de vaga no descarte e na exclusão

**Files:**
- Modify: `lib/data/objectbox/repositories/tecnico_repository.dart` (junto de `debitarCotaAnimais`)
- Modify: `lib/features/animais/presentation/widgets/descarte_animal_widget.dart:477-486`
- Modify: `lib/data/objectbox/repositories/animal_repository.dart:298` (`delete`)

**Interfaces:**
- Consumes: `tecnicoIdDoPath`, `animalOcupaVaga` (Task 1).
- Produces:
  - `void devolverCotaAnimais(String tecnicoFirestoreId, {int quantidade = 1})` — espelho de `debitarCotaAnimais`: local `quantidadeAnimaisCadastrados -= q` (sem passar de 0), `restanteLimiteAnimais += q`, e `PendingOperationEntity` com `QueueIncrement(-q)` / `QueueIncrement(q)`. Técnico ausente → no-op.
  - `bool temOperacaoPendente(String tecnicoFirestoreId)` — existe `PendingOperationEntity` com `collectionName == 'tecnico'` e `firestoreId == tecnicoFirestoreId`.

- [ ] **Step 1:** Implementar os dois métodos em `TecnicoRepository` (sem teste unitário: o repo não tem ObjectBox em teste; a matemática é a de `debitarCotaAnimais`).
- [ ] **Step 2:** No descarte, guardar `final ocupava = animalOcupaVaga(entidade)` ANTES do `repo.update`; depois do update, se `ocupava`, `devolverCotaAnimais(tecnicoIdDoPath(entidade.parentPath)!)` quando o id não for nulo. O id vem do `parentPath` do animal, não de `widget.uidTecnico` (o produtor abre a mesma tela).
- [ ] **Step 3:** Em `AnimalRepository.delete`, mesma regra: se `animalOcupaVaga(entity)` antes de `pushDelete`, devolver a vaga após o push com sucesso (`Result` ok).
- [ ] **Step 4: Run** `flutter analyze lib/data/objectbox/repositories lib/features/animais/presentation/widgets/descarte_animal_widget.dart` — Expected: sem novos issues; `flutter test` inteiro verde.
- [ ] **Step 5: Commit** `fix(plano): descarte e exclusão devolvem a vaga do animal`.

### Task 3: Bloqueio sem vaga (cadastro manual, parto, ativação de produtor)

**Files:**
- Create: `lib/features/plano/presentation/aviso_limite_plano.dart`
- Modify: `lib/features/animais/presentation/pages/cadastrar_novo_animal_page.dart:213` (`_cadastrarAnimal`, logo após a checagem de duplicidade)
- Modify: `lib/features/secas/presentation/widgets/registrar_parto_widget.dart:349` (dentro de `if (_novoAnimalValue == true)`, antes de `_registrarPartoMaeOfflineFirst`)
- Modify: `lib/features/propriedades/presentation/pages/lista_propriedade_page.dart:629` (`_ativarConta`, antes do loading)
- Modify: `lib/features/propriedades/presentation/pages/editar_propriedade_page.dart:~1109` ("Liberar Acesso", antes de criar a conta)
- Test: `test/features/plano/aviso_limite_plano_test.dart`

**Interfaces:**
- Consumes: `temVaga` (Task 1), `TecnicoRepository.getByFirestoreId`.
- Produces:
  - `Future<bool> garantirVagaAnimal(BuildContext context, {required String? tecnicoFirestoreId})` — lê `TecnicoRepository().getByFirestoreId(id)?.restanteLimiteAnimais`; com vaga devolve `true`; sem vaga mostra `AlertDialog` título `'Limite de animais do plano atingido.'`, conteúdo `'Descarte animais ou troque de plano para cadastrar novos.'`, botão `'Ok'`, e devolve `false`. Id nulo ou técnico ausente → `true`.
  - `Future<bool> garantirVagaProdutor(BuildContext context, {required String? tecnicoFirestoreId})` — idem com `restanteLimiteProdutores`, título `'Limite de produtores do plano atingido.'`, conteúdo `'Exclua uma propriedade ou troque de plano para ativar novas contas.'`.

- [ ] **Step 1: Write the failing widget test** — o `TecnicoRepository` não é injetável em teste, então extrair `Future<bool> mostrarAvisoSeSemVaga(BuildContext, {required int? restante, required String titulo, required String mensagem})` e testar ela: `restante: 0` → diálogo com o título aparece e retorna `false` após tocar `Ok`; `restante: 5` e `restante: null` → nenhum diálogo, `true`. `garantirVaga*` só lê o repo e delega.
- [ ] **Step 2: Run** `flutter test test/features/plano/aviso_limite_plano_test.dart` — FAIL.
- [ ] **Step 3: Implement** o arquivo e ligar os quatro pontos: cadastro (`widget.uidTecnico?.id`), parto (`widget.uidTecnico?.id`, retorna sem gravar nada, nem a mãe), ativação (`tecnico.firestoreId`) e liberar acesso (`widget.uidTecnico?.id`).
- [ ] **Step 4: Run** o teste — PASS; `flutter analyze` dos arquivos tocados limpo.
- [ ] **Step 5: Commit** `feat(plano): bloqueia cadastro, parto e ativação sem vaga`.

### Task 4: Limite vem do plano + recálculo na sincronização

**Files:**
- Create: `lib/data/plano/vagas_do_plano_service.dart`
- Create: `lib/core/sync/decisao_recalculo.dart`
- Modify: `lib/data/objectbox/offline_first_sync_service.dart` (fim de `performFullDownload` após `_updateStatus(SyncStatus.completed)`; no `Timer.periodic` de `startPeriodicSync` após `syncPendingChangesToFirestore()`)
- Test: `test/core/sync/decisao_recalculo_test.dart`

**Interfaces:**
- Consumes: Task 1 inteira; `TecnicoRepository.temOperacaoPendente` (Task 2).
- Produces:
  - `Map<String, int>? camposParaGravar({required TecnicoEntity atual, required SaldoVagas animais, required SaldoVagas produtores, required bool filaPendente})` em `decisao_recalculo.dart` — `null` se `filaPendente` ou se nada mudou; senão só os campos que mudaram entre `limiteAnimaisContratado`, `quantidadeAnimaisCadastrados`, `restanteLimiteAnimais`, `limiteProdutoresContratado`, `quantidadeProdutoresCadastrados`, `restanteLimiteProdutores`.
  - `class VagasDoPlanoService { VagasDoPlanoService({FirebaseFirestore? firestore, ObjectBoxService? objectBox}); Future<void> recalcular(String tecnicoFirestoreId); }` — lê `assinatura-tecnico where idTecnico == tecnico/{id}`, depois `assinatura-ativa-tecnico where idAssinaturaTecnico whereIn` (lotes de 30), resolve com `planoAtivoPath`, lê o plano (`limiteAnimais`, `limitePropriedade`); conta ativos no ObjectBox (`contarAnimaisAtivos`/`contarProdutoresAtivos` com `tecnicoPath: 'tecnico/{id}'`); `recalcularSaldo` dos dois; `camposParaGravar`; se não-nulo, `doc('tecnico/{id}').update(campos)` e só depois aplica no `TecnicoEntity` local com `box.put` (sem `needsSync`). Falha de leitura do plano → `limiteDoPlano: 0` (mantém o atual). Qualquer exceção é logada e engolida.
  - No sync service: `Future<void> _recalcularVagas()` — só se online e existir `TecnicoEntity` local cujo `uidPerson` está em `chavesUidPerson(authUid: _lastUserId, personDocId: <person local>.firestoreId)` (mesma chave de `_downloadTecnico`); no aparelho do produtor não há esse técnico e nada roda; chama `VagasDoPlanoService().recalcular(ref.id)`.

- [ ] **Step 1: Write the failing tests** (`decisao_recalculo_test.dart`):
  - `pulaComFilaPendente`: `filaPendente: true` → `null` mesmo com valores diferentes.
  - `semMudancaNaoGrava`: saldo igual ao atual → `null`.
  - `gravaSoOQueMudou`: atual `limiteAnimaisContratado: 50, quantidade: 40, restante: 10`, novo `SaldoVagas(limite: 200, quantidade: 38, restante: 162)` e produtores iguais → mapa com exatamente as 3 chaves de animais e valores `200, 38, 162`.
- [ ] **Step 2: Run** `flutter test test/core/sync/decisao_recalculo_test.dart` — FAIL.
- [ ] **Step 3: Implement** `decisao_recalculo.dart`, `VagasDoPlanoService` e os dois ganchos no sync service.
- [ ] **Step 4: Run** o teste — PASS; `flutter test` inteiro verde; `flutter analyze` limpo nos arquivos tocados.
- [ ] **Step 5: Commit** `feat(plano): limite vem do plano ativo e é recalculado na sincronização`.

### Task 5: Tela de planos grava o novo limite

**Files:**
- Modify: `lib/features/plano/presentation/pages/subscription_plan_tecnico_page.dart:339-520` (`_botaoAssinar`, ramos grátis e pago)

**Interfaces:**
- Consumes: `planoAtivoPath` (Task 1), `VagasDoPlanoService.recalcular` (Task 4).

- [ ] **Step 1:** Trocar a busca da `assinatura-ativa-tecnico` "a partir do primeiro `assinatura-tecnico`" (`singleRecord: true`, hoje falha a partir da segunda troca) por: todas as assinaturas do técnico → ativa que aponta para qualquer uma delas (mesma consulta em lotes do Task 4; extrair o helper de consulta para `VagasDoPlanoService` como `Future<DocumentReference?> buscarAtiva(String tecnicoFirestoreId)` e usá-lo aqui). Ativa inexistente → criar uma nova `assinatura-ativa-tecnico` em vez do `!`.
- [ ] **Step 2:** Após atualizar a ativa (nos dois ramos), `await VagasDoPlanoService().recalcular(widget.uidTecnico!.id)` antes do diálogo de sucesso.
- [ ] **Step 3: Run** `flutter analyze lib/features/plano lib/data/plano` — limpo; `flutter test` verde.
- [ ] **Step 4: Commit** `fix(plano): troca de plano atualiza os limites do técnico`.

---

## Parte B — Importação

### Task 6: Regra de cadastro extraída (função pura)

**Files:**
- Create: `lib/domain/animais/regras_cadastro_animal.dart`
- Test: `test/domain/animais/regras_cadastro_animal_test.dart`

**Interfaces:**
- Produces:
  - `class EntradaCadastroAnimal { final String nome; final String brinco; final String? raca; final String? grupo; final String peso; final String dtNascimento; final String touro; final String vaca; final String? status; final String dtUltimaInseminacao; final String dtUltimoParto; final String? touroInseminacao; final bool? liberaInseminacao; final DateTime hoje; }` — textos vazios = `''`, datas em `dd/MM/yyyy`, como os controllers do formulário.
  - `sealed class ResultadoCadastro`; `class CadastroValido extends ResultadoCadastro { final AnimaisProdutoresStruct animal; }` (sem `uidTecnicoPropriedade` nem `uidAnimalOffline`: quem chama preenche); `class CadastroRecusado extends ResultadoCadastro { final String titulo; final String mensagem; }`.
  - `ResultadoCadastro montarAnimal(EntradaCadastroAnimal e)`.

A regra é a cadeia de `if`s de `_cadastrarAnimal` (`cadastrar_novo_animal_page.dart:271-1320`), transcrita sem mudar valores. Pontos fixos:
- Ordem: nome e brinco vazios → `('Nome ou brinco obrigatório.', 'Preencha ao menos um dos campos.')`. Raça/grupo nulos são checados antes pela tela/planilha.
- Comuns a todos: `brincoAnimal = brinco != '' ? int.tryParse(brinco) : -1`; `brincoAnimalOrder = brinco != '' ? int.tryParse(brinco) : 999999`; `nomeBrincoConcat` = `'nome - brinco'` se os dois (e brinco ≠ `'-1'`), senão o que houver.
- Vacas/Novilhas sem status → `('Status é obrigatório.', 'Selecione ao menos um status.')`.
- Inseminada: com inseminação e sem parto → `idStatusAnimal: 3`, previsões por `somarDataParto/Secagem/PreParto(dtUltimaInseminacao)`, `totalInseminacoes: 1`, `compararDtUltimaInseminacao`; com os dois → idem + `dtUltimoParto`, `totalPartos: 1`, `dtUltimoPartoContingencia`; sem inseminação → recusa `('Data última inseminação vazia ou Touro inseminação não selecionado.', 'Preencha os campos obrigatórios.')` (hoje sai calado; decisão no spec).
- Seca: só Vacas, `idStatusAnimal: 4`; Novilhas → `('O status de "Seca" é permitido somente em vacas.', 'Atualize o status.')`.
- Vazia: `idStatusAnimal: 2`, `totalPartos: parto != '' ? 1 : 0`, `dtUltimoParto`, `dtUltimoPartoContingencia`.
- Prenha (6), Inseminada PP (1), Pré Parto (5): exigem inseminação (mesma recusa acima); Prenha grava `dtDgMais = hoje`; PP e Pré Parto gravam `dtPP` e `dtUltimoPP = hoje`; todos com previsões, `totalInseminacoes: 1`, `dtUltimoParto`, `dtUltimoPartoContingencia`.
- Touros/Sêmens: `liberaInseminacao: e.liberaInseminacao`; demais grupos: só os comuns.
- `hoje` formatado com `DateFormat('dd/MM/yyyy')` (substitui `dateTimeFormat(..., getCurrentTimestamp, locale)`).
- Usar `lib/core/ui/custom_functions.dart` para as somas de data.

- [ ] **Step 1: Write the failing tests** — um teste por ramo acima, conferindo `idStatusAnimal`, `status`, as três previsões (ex.: inseminação `'01/01/2026'` → `dtPartoPrevisto == '08/10/2026'`, `dtSecPrevista == '09/08/2026'`, `dtPrePartoPrevista == '17/09/2026'`), `totalInseminacoes`, `totalPartos`, `dtDgMais`/`dtPP` = `hoje`, `brincoAnimal == -1` e `brincoAnimalOrder == 999999` sem brinco, e cada `CadastroRecusado` com título e mensagem exatos.
- [ ] **Step 2: Run** `flutter test test/domain/animais/regras_cadastro_animal_test.dart` — FAIL.
- [ ] **Step 3: Implement** `montarAnimal`.
- [ ] **Step 4: Run** — PASS.
- [ ] **Step 5: Commit** `refactor(animais): regra de cadastro vira função pura testada`.

### Task 7: Cadastro manual usa `montarAnimal`

**Files:**
- Modify: `lib/features/animais/presentation/pages/cadastrar_novo_animal_page.dart:213-1320`

**Interfaces:**
- Consumes: `montarAnimal`, `EntradaCadastroAnimal` (Task 6); `garantirVagaAnimal` (Task 3).

- [ ] **Step 1:** Reescrever `_cadastrarAnimal`: validação do form → raça/grupo → duplicidade (como hoje) → `garantirVagaAnimal` → `montarAnimal(EntradaCadastroAnimal(...dos controllers..., hoje: DateTime.now()))` → `CadastroRecusado` mostra o `AlertDialog` com título/mensagem e botão `'Ok'`; `CadastroValido` preenche `uidTecnicoPropriedade: widget.uidPropriedade` e `uidAnimalOffline: functions.criarUidRandom()`, chama `_criarAnimal`, overlay de sucesso e a navegação de volta que hoje se repete em cada ramo (extrair para `void _voltarParaLista()` uma vez).
- [ ] **Step 2: Run** `flutter analyze lib/features/animais/presentation/pages/cadastrar_novo_animal_page.dart` — limpo; `flutter test` verde.
- [ ] **Step 3: Commit** `refactor(animais): cadastro manual usa a regra extraída`.

### Task 8: Leitura e normalização da planilha

**Files:**
- Create: `lib/domain/animais/importacao/planilha_animais.dart`
- Create: `lib/features/animais/application/ler_xlsx.dart`
- Create: `assets/planilhas/modelo_importacao_animais.xlsx` (cópia de `documentacao/Modelo Planilha de IMPORAÇÃO DE ANIMAIS.xlsx`) e entrada `- assets/planilhas/` no `pubspec.yaml`
- Test: `test/domain/animais/importacao/planilha_animais_test.dart`, `test/features/animais/ler_xlsx_test.dart`

**Interfaces:**
- Consumes: `EntradaCadastroAnimal` (Task 6); `opcoesStatusAnimal` (`lib/features/animais/application/status_animal_opcoes.dart`).
- Produces:
  - `const kCabecalhoModelo = ['Nome', 'Número', 'Raça', 'Categoria', 'Data de Nascimento', 'Pai', 'Mãe', 'Parto', 'Inseminação', 'Status'];`
  - `String? erroDeCabecalho(List<Object?> linha1)` — normaliza (minúsculas, sem acento, sem `*`, sem `(opcional)`, sem espaços) e compara A..J; primeira divergência → `'A coluna D deveria ser Categoria e está Status.'`; célula vazia → `'... e está vazia.'`; ok → `null`.
  - `String normalizar(String s)`.
  - `String? lerData(Object? celula)` → `dd/MM/yyyy` ou `null` (vazia); aceita `DateTime`, texto ISO `2021-11-20T00:00:00.000`, `num` serial Excel (base 1899-12-30), `dd/mm/aaaa`, `dd/mm/aa` (→ 20aa), `dd-mm-aaaa`. Inválida lança `FormatException`.
  - `class LinhaPlanilha { final int numero; final String identificacao; final EntradaCadastroAnimal? entrada; final String? motivo; }` (`numero` = linha do Excel, 2 em diante; `identificacao` = nome/brinco como no `nomeBrincoConcat`).
  - `List<LinhaPlanilha> lerLinhas(List<List<Object?>> linhas, {required List<String> racas, required List<String> grupos, required List<StatusAnimalEntity> status, required DateTime hoje})` — pula a linha 1 e linhas totalmente vazias; por linha: brinco inteiro ou recusa `'número inválido: <v>'`; raça por nome normalizado, sigla do mapa, ou prefixo único, senão `'raça não reconhecida: <v>'`; categoria por normalizado com plural (`vaca`→`vacas`, `semen`→ o grupo cujo normalizado é `semens`, cobre `'Semêns'` da constante e `'Sêmens'` da referência), senão `'categoria não reconhecida: <v>'`; status (`inseminadapp`→`Inseminada PP`, `preparto`→`Pré Parto`, demais por normalizado contra `status`), vazio em Vacas/Novilhas segue para `montarAnimal` recusar; data inválida → `'data inválida na coluna <E|H|I>: <v>'`; data futura → `'data no futuro na coluna <E|H|I>: <dd/MM/yyyy>'`; status fora de `opcoesStatusAnimal(...)` para as datas → `'status <S> não combina com as datas de parto e inseminação'`; por fim `montarAnimal` e um `CadastroRecusado` vira `motivo` = `titulo`.
  - `const kSiglasRaca = {'ho': 'Holandesa', 'je': 'Jersey', 'gir': 'Gir', 'gi': 'Gir', 'gl': 'Girolando', 'gh': 'Girolando', 'pa': 'Pardo Suíço', 'ps': 'Pardo Suíço', 'ne': 'Nelore'};` — só valem se a raça alvo existir em `racas`.
  - `List<List<Object?>> lerXlsx(Uint8List bytes)` em `ler_xlsx.dart` — `Excel.decodeBytes`, primeira aba, `cell?.value` convertido: `SharedString` → `toString()`, `int`/`double` como estão; arquivo inválido lança `FormatException('Arquivo não é uma planilha .xlsx válida.')`.

- [ ] **Step 1: Write the failing tests:**
  - `cabecalhoDoModeloPassa`: a linha 1 real do modelo (`['Nome (opcional)', 'Número*', 'Raça*', 'Categoria*', 'Data de Nascimento(opcional)', 'Pai (opcional)', 'Mãe (opcional)', 'Parto (opcional)', 'Inseminação (opcional)', 'Status*']`) → `null`; trocar D e J → `'A coluna D deveria ser Categoria e está Status.'`.
  - `lerData`: `'2021-11-20T00:00:00.000'` → `'20/11/2021'`; `44520` → `'20/11/2021'`; `'20/11/21'` → `'20/11/2021'`; `'20-11-2021'` → `'20/11/2021'`; `'31/02/2021'` lança.
  - `linhaDoModelo`: `[null, 10, 'Ho', 'Vaca', '2021-11-20T00:00:00.000', null, null, '2026-07-03T00:00:00.000', '2026-09-15T00:00:00.000', 'InseminadaPP']` com `hoje: DateTime(2026, 11, 4)` → entrada com `raca 'Holandesa'`, `grupo 'Vacas'`, `status 'Inseminada PP'`, `brinco '10'`, sem motivo.
  - `ignoraLinhasVazias`: três linhas `[null × 10]` no fim → não aparecem.
  - Uma recusa por motivo (número `'10a'`, raça `'Xyz'`, prefixo ambíguo, categoria `'Boi'`, data futura, status incoerente, Seca em Novilha, sem nome nem número).
  - `ler_xlsx_test`: `lerXlsx(File('assets/planilhas/modelo_importacao_animais.xlsx').readAsBytesSync())` tem 2 linhas e a primeira passa em `erroDeCabecalho`; bytes `[1, 2, 3]` lança `FormatException`.
- [ ] **Step 2: Run** `flutter test test/domain/animais/importacao test/features/animais/ler_xlsx_test.dart` — FAIL.
- [ ] **Step 3: Implement**, copiar o asset e registrar no `pubspec.yaml`.
- [ ] **Step 4: Run** — PASS.
- [ ] **Step 5: Commit** `feat(importacao): leitura e validação da planilha de animais`.

### Task 9: Análise e gravação da importação

**Files:**
- Create: `lib/features/animais/application/importar_animais.dart`
- Test: `test/features/animais/importar_animais_test.dart`

**Interfaces:**
- Consumes: `LinhaPlanilha`, `lerLinhas` (Task 8); `montarAnimal` saída (Task 6); `quantosCabem` (Task 1); `criarAnimalOffline`; `TecnicoRepository.debitarCotaAnimais`; `AnimalRepository.existeAnimalAtivoComNomeBrinco`.
- Produces:
  - `class Recusa { final int linha; final String identificacao; final String motivo; }`
  - `class AnaliseImportacao { final List<LinhaPlanilha> validas; final List<Recusa> recusadas; }`
  - `AnaliseImportacao analisarImportacao(List<LinhaPlanilha> linhas, {required bool Function(String nome, int brinco) jaExiste})` — recusa `'já cadastrado'` quando `jaExiste`, `'repetido na linha N'` quando uma linha anterior válida tem o mesmo par (nome, brinco), mantendo a ordem da planilha.
  - `class ResultadoImportacao { final int importados; final List<Recusa> recusadas; }`
  - `Future<ResultadoImportacao> gravarImportacao(AnaliseImportacao a, {required int? restante, required Future<void> Function(LinhaPlanilha) criar, required void Function(int quantidade) debitar, void Function(int feitos, int total)? aoProgredir, int lote = 20})` — grava as `quantosCabem` primeiras, cede ao event loop (`Future.delayed(Duration.zero)`) a cada `lote`, chama `debitar(importados)` uma vez no fim (se > 0); as que não couberam viram `Recusa(... 'limite do plano atingido')`. Erro em `criar` de uma linha vira recusa `'erro ao gravar'` e segue.
  - `Future<ResultadoImportacao> importarAnimais(...)` — a ligação real: `criar` monta o struct com `uidTecnicoPropriedade` + `uidAnimalOffline: criarUidRandom()` e chama `criarAnimalOffline`; `debitar` chama `debitarCotaAnimais(tecnicoId, quantidade: n)`.

- [ ] **Step 1: Write the failing tests** (com `criar`/`debitar`/`jaExiste` falsos):
  - `reimportarNaoDuplica`: `jaExiste` verdadeiro para (`''`, 10) → recusa `'já cadastrado'`, linha e identificação corretas.
  - `repetidaNaPlanilha`: linhas 2 e 5 com o mesmo par → linha 5 recusada `'repetido na linha 2'`.
  - `cortaNoLimite`: 10 válidas, `restante: 3` → `importados == 3`, `debitar` chamado uma vez com 3, 7 recusas `'limite do plano atingido'` para as linhas 5ª..10ª válidas.
  - `semVaga`: `restante: 0` → `criar` nunca chamado, `debitar` nunca chamado.
  - `progresso`: `aoProgredir` recebe o último valor `(total, total)`.
- [ ] **Step 2: Run** `flutter test test/features/animais/importar_animais_test.dart` — FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run** — PASS.
- [ ] **Step 5: Commit** `feat(importacao): análise de duplicados e gravação com limite`.

### Task 10: Tela "Importar animais", rota e botão discreto

**Files:**
- Create: `lib/features/animais/presentation/pages/importar_animais_page.dart`
- Create: `lib/features/animais/application/compartilhar_modelo.dart`
- Modify: `lib/app/router/nav.dart` (rota `importarAnimais`, `/importarAnimais`, params `uidPropriedade`, `uidTecnico` como `DocumentReference`)
- Modify: `lib/features/animais/presentation/pages/lista_animais_page.dart:561` (`CabecalhoTela.acoes`)
- Modify: `pubspec.yaml` (`share_plus`, versão atual compatível: `flutter pub add share_plus`)
- Test: `test/features/animais/importar_animais_page_test.dart`

**Interfaces:**
- Consumes: Tasks 1, 3, 8, 9; `tecnicoLogadoProvider` (`lib/features/propriedades/application/propriedades_providers.dart`); `CabecalhoTela` (`lib/core/ui/cabecalho_tela.dart`); `ReferenciaRepository().racas()/grupos()/statusAnimais()`.
- Produces: `ImportarAnimaisPage` (`routeName = 'importarAnimais'`); `Future<void> compartilharModeloPlanilha()` — `rootBundle.load('assets/planilhas/modelo_importacao_animais.xlsx')` → arquivo `Modelo importacao de animais.xlsx` em `getTemporaryDirectory()` → menu de compartilhar do `share_plus` com mimeType `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`.

Comportamento (spec §5):
- Botão: `IconButton(Icons.upload_file_outlined, tooltip: 'Importar animais')` branco no cabeçalho da lista, só quando `tecnicoLogadoProvider` tem valor.
- Tela: `CabecalhoTela(titulo: 'Importar animais')`; dois cartões no padrão de `docs/padrao-layout-listas.md`: "Baixar planilha padrão" (`'Preencha um animal por linha, sem mudar a ordem das colunas.'`) e "Importar planilha" (`'Escolha a planilha .xlsx preenchida.'`).
- Importar: `FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx'], withData: true)` → `lerXlsx` → `erroDeCabecalho` (mostra a mensagem e para) → `lerLinhas` + `analisarImportacao` → nenhuma válida: mostra o resultado direto → `restante` do técnico: se `quantosCabem < validas`, diálogo `'Sua conta permite mais X animais e a planilha tem Y válidos. Os Y−X últimos ficarão de fora.'` com `'Importar os X'` / `'Cancelar'`; com X = 0, `'Sua conta não tem vagas para novos animais.'` só com `'Ok'` → progresso `LinearProgressIndicator` + `'n de total'` com a tela bloqueada para voltar (`PopScope(canPop: false)`) → resultado: `'X importados'`, `'Y não importados'` e lista `'Linha N — identificação — motivo'`, botão `'Voltar para a lista'`.
- Planilha só com cabeçalho → `'A planilha não tem animais.'`.
- Erro de leitura → a mensagem da `FormatException`.

- [ ] **Step 1: Write the failing widget test:** renderizar o resultado (estado final injetado por um construtor `ImportarAnimaisPage.resultadoParaTeste(ResultadoImportacao)` ou widget `ResultadoImportacaoView` separado) e conferir `'3 importados'`, `'2 não importados'` e `'Linha 5 — Mimosa - 12 — já cadastrado'`.
- [ ] **Step 2: Run** — FAIL.
- [ ] **Step 3: Implement** tela, rota, botão, `share_plus`, compartilhamento.
- [ ] **Step 4: Run** o teste — PASS; `flutter analyze` limpo nos arquivos tocados; `flutter test` inteiro verde.
- [ ] **Step 5: Commit** `feat(importacao): tela de importar animais por planilha`.

### Task 11: Documentação

**Files:**
- Create: `docs/importacao-animais-planilha.md`
- Modify: `docs/superpowers/specs/2026-11-04-importacao-animais-planilha-design.md` (marcar o que mudou na implementação, se algo mudou)

- [ ] **Step 1:** Escrever o guia: quem vê o botão, colunas e valores aceitos (siglas de raça, variações de categoria/status, formatos de data), motivos de recusa, como o limite é calculado (plano ativo → limite; ativos; recálculo na sincronização; quando a fila tem pendência), o que bloqueia sem vaga, e a checagem manual de `planos-tecnicos.limiteAnimais`/`limitePropriedade` no console.
- [ ] **Step 2: Commit** `docs: guia da importação de animais e das vagas do plano`.
