# Desempenho online e sincronização resiliente

Data: 2026-08-10

## Problema

O aplicativo fica perceptivelmente mais lento **quando online**, e a sincronização
inicial quebra com `RESOURCE_EXHAUSTED` sem conseguir se recuperar.

O diagnóstico foi feito com o app rodando em emulador Android, com o log nativo do
Firestore ligado (`FirebaseFirestore.setLoggingEnabled(true)`) e instrumentação
temporária nas leituras do ObjectBox, para distinguir o que é leitura local do que
é ida à rede.

Sete defeitos foram identificados. Cinco causam consumo de rede e rebuilds
desnecessários; dois quebram a sincronização inicial.

### 1. Sincronização inicial é tudo-ou-nada

`performFullDownload` (`offline_first_sync_service.dart:156`) executa oito etapas
em sequência dentro de um único `try`. Qualquer exceção cai no `catch` da linha 214
e aborta tudo, **sem marcar `initial_download` como completo**.

O log de uma execução real:

```
21:14:23.509  🏡 38 propriedade(s) baixada(s)
21:14:23.571  ❌ Erro no download completo: RESOURCE_EXHAUSTED: Quota exceeded.
```

As etapas `referencias`, `usuario`, `tecnico`, `produtores` e `propriedades`
tinham concluído. Como nada disso é registrado, o próximo login **rebaixa tudo
desde a primeira etapa** — inclusive as 38 propriedades já gravadas no ObjectBox.
Sob restrição de quota, cada tentativa gasta o orçamento nas etapas que já deram
certo e nunca alcança a que faltou.

### 2. `count()` cosmético derruba o download inteiro

`_downloadTodosAnimais` (`offline_first_sync_service.dart:527`) abre com:

```dart
final total = (await colecao.count().get()).count ?? 0;
```

Esse valor alimenta **apenas** o total da barra de progresso. A paginação em
`_baixarAnimaisPaginado` não depende dele: ela usa `orderBy(documentId)` +
`startAfterDocument` e para quando a página vem vazia.

No log acima não existe a linha `🐄 N animal(is) baixado(s)` — nenhuma página foi
sequer tentada. A `aggregation query` falhou e levou junto todo o download.

Um indicador cosmético não pode derrubar a sincronização, sob qualquer plano de
billing.

### 3. Quarenta listeners `.snapshots()` permanentes

`RemoteSyncListenersService.startAllListeners`
(`remote_sync_listeners_service.dart:450`) abre um listener para animais, um para
ações, e **um por propriedade** para tratamentos. Com as 38 propriedades desta
conta, são 40 listeners permanentes.

`ARCHITECTURE.md` descreve esse serviço como "HOJE INATIVO". Está desatualizado:
`offline_first_sync_gateway.dart:87` o inicializa a cada login.

No attach inicial, cada listener entrega todos os documentos existentes como
`added`, e cada um é gravado no ObjectBox na isolate principal.

### 4. Dashboard conta animais pelo Firestore

`_buildAnimaisAtivosStatCard` (`dashboard_tecnico_page.dart:314`) usa
`StreamBuilder<List<AnimaisProdutoresRecord>>` sobre `queryAnimaisProdutoresRecord`.
O helper `queryCollection` (`backend.dart:2255`) devolve `query.snapshots()` com
`limit: 500`.

É um stream ao vivo de até 500 documentos de animal para exibir **um número**. O
mesmo dado está no ObjectBox.

### 5. Dezesseis telas fazem rebuild a cada cinco segundos

Dezesseis telas repetem este bloco no `initState` (exemplo em
`lista_animais_page.dart:77`):

```dart
_instantTimer = InstantTimer.periodic(
  duration: Duration(seconds: 5),
  callback: (timer) async {
    _respostaNet = await actions.checkInternetConnection();
    safeSetState(() {});
    if (_respostaNet!) { safeSetState(() {}); }
    ...
```

O `safeSetState` é incondicional: a árvore inteira é reconstruída a cada cinco
segundos, haja mudança ou não. Os timers são cancelados no `dispose`, então não há
vazamento — o custo é o rebuild periódico.

`_respostaNet` é consumido em um único lugar por tela: a cor de um botão
(`0xFFF75E38` quando online, `0xFFF2886E` quando offline — dois laranjas
próximos). O app já tem `isOnlineProvider` (`core/di/providers.dart:33`),
alimentado pelo `ConnectivityService`, que emite apenas em transição real.

### 6. Aquecimento de cache bloqueia o login

`offline_first_sync_gateway.dart:93-99` executa quatro queries Firestore
sequenciais com `await` antes de devolver o destino, sob o rótulo "Aquecimento de
cache do Firestore para as telas seguintes". As telas seguintes leem do ObjectBox,
que o download completo acabou de popular.

### 7. Remoção dos listeners deixa o app sem caminho de entrada

`startPeriodicSync` (`offline_first_sync_service.dart:1444`) chama
`syncPendingChangesToFirestore`, que é **exclusivamente push**
(`offline_first_sync_service.dart:851`). Hoje o único caminho pelo qual uma
alteração remota chega ao aparelho são os listeners do item 3. Removê-los sem
substituto deixaria o app sem receber mudanças feitas em outro dispositivo.

## Solução

### 1. Checkpoint por etapa

`SyncMetadataEntity` já tem `collectionName` e `initialSyncComplete`. Passa a
existir uma linha por valor de `SyncEtapa`, além da linha agregadora
`initial_download`.

`performFullDownload` percorre as oito etapas em laço:

```
para cada etapa em SyncEtapa.values:
  se etapaCompleta(etapa): continua
  executa a etapa
  marca etapa completa
se todas completas: marca initial_download completo
```

Falha em uma etapa interrompe o laço, mas preserva as marcas anteriores. A
retomada começa na primeira etapa não marcada.

`needsInitialSync()` continua consultando `initial_download` e não muda de
semântica.

A ordem das etapas é a de `SyncEtapa`, que já reproduz a ordem atual de execução.
Dependências entre etapas (referências antes de tudo, técnico antes de animais)
são respeitadas porque o laço é sequencial e uma etapa só é pulada quando já
concluiu com sucesso.

### 2. `count()` best-effort

O `count()` passa a ser embrulhado e a falha, tolerada:

```dart
int? total;
try {
  total = (await colecao.count().get()).count;
} catch (e) {
  debugPrint('⚠️ count() indisponível, progresso indeterminado: $e');
}
```

`total == null` significa barra indeterminada. `_reportProgress` e
`progressoGlobal` (`sync_etapa.dart`) já tratam `total` nulo — `progressoGlobal`
devolve `etapa.inicio` nesse caso. O download prossegue normalmente.

Mesmo tratamento no ramo do produtor, onde o `count()` roda uma vez por
propriedade.

### 3. Erro de cota deixa de ser fatal

Nova `SyncCotaExcedidaException` em `core/sync/sync_exceptions.dart`, levantada
quando a causa é `FirebaseException` com `code == 'resource-exhausted'`.

`SyncPageController` a trata como caso não-fatal: entra no app com os dados
parciais, exibindo aviso em vez de erro. Texto:

> A cota diária do Firebase foi atingida. Seus dados até aqui foram salvos e você
> pode usar o app normalmente. O restante será baixado automaticamente.

Não há retry automático: para restrição de cota ele apenas atrasa a entrada.

Combinado com o item 1, a próxima tentativa retoma da etapa que faltou.

### 4. Listeners saem, entra pull incremental

`startAllListeners` deixa de ser chamado em `offline_first_sync_gateway.dart:87`.
O `RemoteSyncListenersService` permanece no repositório sem chamador — sua remoção
é trabalho à parte.

**Pré-requisito: os documentos no Firestore não têm timestamp de modificação.**
`lastModified` existe apenas como campo local do ObjectBox
(`syncable_entity.dart:27`); nenhum `toFirestore()` o escreve. Uma query delta é
impossível sobre o estado atual dos dados.

Portanto, o item ganha duas partes.

**4a. Passar a carimbar `lastModified` no Firestore.** `BaseSyncRepository`
acrescenta `'lastModified': FieldValue.serverTimestamp()` ao payload em
`firestorePayloadFor`, e o mesmo é feito nos caminhos de escrita do
`OfflineFirstSyncService` (`_syncModified*`). O carimbo é do servidor, não do
relógio do aparelho, para não depender da hora local.

**4b. Pull incremental sobre esse campo.** `startPeriodicSync` ganha
`_pullRemoteChanges()`, executado antes do push:

- para cada coleção (animais, ações, tratamentos), consulta
  `where('lastModified', isGreaterThan: <lastFullSync da etapa>)`;
- grava o resultado no ObjectBox pelo mesmo caminho de upsert do download
  completo;
- atualiza `lastFullSync` da etapa.

São três queries delta a cada cinco minutos, trazendo apenas o que mudou, contra
40 listeners permanentes que releem coleções inteiras no attach.

**Limitação conhecida e aceita.** Filtro de intervalo no Firestore **exclui
documentos que não possuem o campo**. Os documentos que já existem hoje não têm
`lastModified` e só passarão a ter quando forem escritos por esta versão ou
posterior. Consequência: uma alteração feita por um cliente em versão antiga,
durante a janela de atualização, não é capturada pelo pull.

Isso é aceitável e limitado: o download completo inicial (que não usa filtro)
continua trazendo tudo, e a partir do momento em que todos os aparelhos estiverem
atualizados o campo passa a existir em todo documento que muda. Não haverá
backfill em massa — reescrever toda a base só para criar o campo custaria mais
leituras e escritas do que o problema que se quer resolver.

O mesmo pull dispara quando o app volta do background e quando a conectividade
retorna (o listener de conectividade do sync service já existe).

**Consequência aceita:** mudanças remotas deixam de aparecer instantaneamente e
passam a chegar em até cinco minutos, ou imediatamente ao reabrir o app. Para um
app offline-first cujo editor primário é o próprio técnico, é uma troca favorável.

### 5. Dashboard lê do ObjectBox

`_buildAnimaisAtivosStatCard` passa a `ref.watch` de um provider sobre
`AnimalRepository`, com o filtro de descarte e sêmens aplicado localmente,
reaproveitando `ehDescarte`. O `StreamBuilder` e o import de
`AnimaisProdutoresRecord` saem da tela.

### 6. Timer de cinco segundos sai das dezesseis telas

Em cada tela: remoção do `InstantTimer.periodic`, do campo `_respostaNet`, do
`_instantTimer` e do cancelamento no `dispose`. A cor do botão passa a vir de
`ref.watch(isOnlineProvider)`.

Telas afetadas: `prontuario_animal`, `diagnosticogestacao`, `editar_animal`,
`lista_animais`, `cadastrar_novo_animal`, `inicio_propriedade`,
`exame_ginecologico`, `importacao_animais`, `dashboard_tecnico`, `recriacao`,
`secas`, `listacompleta`, `resumo_rebanho`, `inicio_propriedade_produtor`,
`lista_inseminacoes`, `animais_prenhas`.

Telas que ainda não são `ConsumerWidget`/`ConsumerStatefulWidget` são convertidas.
`core/services/check_internet_connection.dart` fica sem uso e é removido junto com
seu export em `core/services/index.dart`.

### 7. Aquecimento de cache removido

As quatro queries de `offline_first_sync_gateway.dart:93-99` são removidas. A
query de `person` logo acima permanece: seu resultado decide o destino.

## Testes

O checkpoint e o pull incremental concentram a lógica de decisão e recebem testes
de unidade com gateway falso:

- retoma da primeira etapa não marcada, sem reexecutar as anteriores;
- falha no meio preserva as marcas das etapas concluídas;
- todas as etapas completas marcam `initial_download`;
- `count()` que lança não interrompe o download e resulta em `total` nulo;
- `resource-exhausted` vira `SyncCotaExcedidaException`, não `SyncFalhaException`;
- pull incremental consulta com a janela `lastModified > lastFullSync` e avança a
  marca;
- `firestorePayloadFor` inclui `lastModified` no payload de escrita.

O teste de round-trip do `AnimaisProdutoresStruct` já existente deve continuar
passando: `lastModified` entra no payload de escrita, não no `updateFromFirestore`.

Os itens 5, 6 e 7 são substituição de fonte de dados e remoção de código; são
cobertos pelos testes de widget existentes e pelo gate de análise.

## Índices do Firestore

O pull do ramo do técnico é um filtro de intervalo em campo único
(`lastModified`), atendido pelo índice automático de campo único.

O pull do ramo do produtor combina `where('uidTecnicoPropriedade', isEqualTo: …)`
com o intervalo em `lastModified`, o que exige **índice composto**. Ele precisa ser
criado antes de a versão ir para produção; o Firestore devolve o link de criação
na mensagem de erro da primeira execução.

## Fora de escopo

- Remoção do arquivo `remote_sync_listeners_service.dart`.
- Decomposição de `FFAppState`.
- A instrumentação de diagnóstico (`core/diagnostics/`, log nativo do Firestore,
  nomes de rota em `nav.dart`) é temporária e é revertida ao fim do trabalho.
