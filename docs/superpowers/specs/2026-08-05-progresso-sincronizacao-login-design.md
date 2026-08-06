# Progresso de sincronização no login

Data: 2026-08-05

## Problema

No primeiro login de um técnico com muitos animais (~3000), o botão "Entrar" fica
travado por dezenas de segundos sem nenhum aviso. Para o usuário, o aplicativo
parece ter congelado.

A causa é a posição do download completo na cadeia de chamadas:

```
login_technician_page.dart:398   authManager.signInWithEmail(...)
  firebase_auth_manager.dart:326   await ObjectBoxAuthHelper.onUserLogin(user)
    objectbox_auth_helper.dart:78    await syncService.performFullDownload(...)
login_technician_page.dart:407   context.pushNamedAuth(SyncTechnicianPage...)
```

O download inteiro roda **dentro** do `onPressed` do botão. A `SyncTechnicianPage`
— a tela da vaquinha com "Sincronizando, aguarde..." — só é aberta **depois** que
tudo já baixou, e ali executa apenas algumas queries de aquecimento de cache do
Firestore. A tela de sincronização está cobrindo a parte rápida do processo e não
a lenta.

`login_produtor_page.dart:241` tem o mesmo problema e sequer navega para uma tela
de sincronização.

### Dois agravantes

**A infraestrutura de progresso existe e está morta.** `OfflineFirstSyncService`
expõe `progressStream` (`Stream<SyncProgress>`) e já chama `_reportProgress()` em
oito etapas (`offline_first_sync_service.dart:149-198`). Existe um
`InitialSyncProgressWidget` pronto em `sync_widgets.dart:51`. Nenhum arquivo do
projeto usa o widget e ninguém escuta o stream.

**A UI thread trava de verdade.** `_salvarAnimais`
(`offline_first_sync_service.dart:537`) faz, por animal, uma query no ObjectBox
(`build()/findFirst()`) e um `put()` individual: 3000 queries e 3000 transações
separadas na isolate principal. `_downloadAcoes` (`:563`) repete o padrão. Uma
barra de progresso sozinha não resolveria — ela ficaria parada durante a etapa dos
animais.

## Decisões

| Decisão | Escolha |
|---|---|
| O que exibir | Etapa + % + contadores + ritmo + ETA |
| Escopo | Técnico e produtor, mesma tela |
| Falha no meio | Tela de erro com "Tentar novamente" e "Continuar assim mesmo" |
| Onde roda o download | Dentro da tela de sincronização |

Velocidade em MB/s **não** será exibida: o Firestore não expõe bytes baixados, e
qualquer número nessa unidade seria inventado. O ritmo é medido em registros por
segundo, que é uma grandeza real e verificável.

## Arquitetura

### O auth manager volta a só autenticar

Remove-se `await ObjectBoxAuthHelper.onUserLogin()` de `_signInOrCreateAccount`
(`firebase_auth_manager.dart:326`). O login retorna assim que o Firebase autentica.

Isso é contido: o app tem só três pontos de entrada autenticada —
`login_technician_page.dart:398`, `login_produtor_page.dart:241` e
`create_account_technician_page.dart:421` — e todos desembocam na tela de
sincronização. Os dois logins passam a navegar direto para ela; a criação de conta
continua indo para `CompletarPerfilTecnicoPage`, que já navega para a tela de
sincronização em `completar_perfil_tecnico_page.dart:1157`. Conta recém-criada não
tem dados, então o download completo dela é trivial.

### `SyncTechnicianPage` vira `SyncPage`

Novo caminho: `lib/features/sync/presentation/pages/sync_page.dart`, rota
`/sincronizando`. Usada por técnico e produtor.

As 220 linhas atuais misturam orquestração e UI. Quebra-se em três peças:

**`SyncPageController`** — orquestra a sequência: download completo → busca
`person`/`tecnico` → liga `RemoteSyncListenersService` → aquece caches Firestore →
resolve o destino. Segue o padrão de `login_technician_controller.dart`. Expõe um
estado selado:

```
Preparando
Baixando(etapa, atual?, total?, progresso)
Erro(tipo, etapa?, mensagem)
Concluido(destino)
```

`Erro.tipo` distingue os dois casos que pedem UI diferente: `falhaDownload` (uma
etapa quebrou; oferece "Tentar novamente" e "Continuar assim mesmo") e
`semConexao` (offline sem dados locais; oferece só "Tentar novamente", porque não
há dado parcial com que continuar). `etapa` é nulo em `semConexao`.

Não conhece GoRouter nem widgets.

**`SyncProgressView`** — renderiza o estado, sem lógica. Substitui o
`InitialSyncProgressWidget` morto de `sync_widgets.dart:51`, que é removido.

**`SyncRateEstimator`** — classe pura. Recebe `(atual, total, timestamp)` e devolve
ritmo em registros/s e ETA. Testável sem Firestore nem ObjectBox.

A divisão segue a regra: o serviço emite **fatos** (etapa, quantos de quantos); a
apresentação calcula ritmo e ETA. `OfflineFirstSyncService` não ganha lógica de UI.

### Papel vem por parâmetro de rota

`SyncPage` recebe `papel` (`tecnico` | `produtor`) de quem navegou, em vez de
deduzir da existência do `TecnicoRecord`. Deduzir confundiria "produtor" com
"técnico sem perfil completo", que é o caso tratado hoje pelo diálogo em
`sync_technician_page.dart:90-104`.

O controller devolve um `SyncDestino` selado:

- `DashboardTecnico`
- `InicioPropriedadeProdutor(propriedade)`
- `CompletarPerfil`

A página traduz para a navegação, incluindo os seis query params que
`_navigateToHome` monta em `login_produtor_page.dart:289-319`.

A navegação final usa `goNamed`, não `pushNamed` como hoje
(`sync_technician_page.dart:85`) — voltar para a tela de sincronização depois de
concluída não faz sentido.

## Fluxo do progresso

### `SyncProgress` ganha estrutura

```dart
class SyncProgress {
  final String message;
  final double progress;
  final SyncEtapa etapa;
  final int? atual;
  final int? total;
}

enum SyncEtapa {
  referencias, usuario, tecnico, produtores,
  propriedades, animais, acoes, financeiro,
}
```

O campo `collection`, hoje sempre nulo em todas as chamadas, é removido.

O serviço passa a expor `SyncProgress? get lastProgress`, para a tela renderizar o
estado correto mesmo se montar depois do primeiro evento.

### Animais passam a ser paginados

`_downloadTodosAnimais` (`:506`) hoje faz um `.get()` único da coleção inteira, o
que impede qualquer contador incremental. Passa a:

1. `collection('animaisProdutores').count().get()` — aggregate query, custo de ~1
   leitura, fornece o denominador real. A API já é usada no projeto em
   `data/backend.dart:2237`.
2. Loop com `.orderBy(FieldPath.documentId).limit(250).startAfterDocument(ultimo)`,
   emitindo progresso a cada lote.

O tamanho do lote é 250, não 500, por causa do ritmo: cada lote é uma amostra para
o `SyncRateEstimator`, e com 500 haveria apenas 6 amostras em 3000 animais — o
ritmo mal apareceria antes de terminar. Com 250 são 12, o suficiente para a média
móvel estabilizar cedo.

O número de documentos lidos (e faturados) não muda; eles descem em páginas.

### `_salvarAnimais` passa a gravar em lote

Por lote, em vez de por animal:

1. Uma query `AnimalEntity_.firestoreId.oneOf(ids)` → mapa `firestoreId → id local`.
2. Um `putMany` com as entidades reconciliadas.
3. `await Future.delayed(Duration.zero)` entre lotes, para a UI thread respirar e a
   barra animar.

`_downloadAcoes` (`:563`) tem o mesmo padrão de `put` por documento e recebe o mesmo
tratamento.

## A tela

Mantém a identidade visual atual — gradiente `#F75E38 → #EC3B5B` e o lottie da vaca
(`assets/jsons/animation_lmv2wwnc.json`). Substitui o texto solto "Sincronizando,
aguarde..." (`sync_technician_page.dart:181`) por um bloco de progresso:

```
🐄 (lottie)

Preparando seus dados

████████████░░░░░░░░   62%

Baixando animais
1.240 de 3.000 · ~380/s
Restam ~5s

✓ Tabelas de referência
✓ Produtores
✓ Propriedades
◐ Animais
○ Ações e tratamentos
○ Financeiro e visitas
```

A checklist tem seis linhas, mas o enum tem oito etapas: `usuario` e `tecnico` são
instantâneas (um documento cada) e piscariam se tivessem linha própria. As duas são
agrupadas na linha "Tabelas de referência" junto com `referencias`. O mapeamento
etapa → linha fica na view, não no serviço.

Três regras impedem que os números virem ruído:

- **Contador, ritmo e ETA só aparecem quando a etapa tem `total`** — hoje apenas
  animais e ações. Etapas curtas mostram só o nome.
- **ETA só após ~2s de amostras**, e é omitido quando cai abaixo de 3s. Uma
  estimativa que salta de "47s" para "4s" destrói mais confiança do que a ausência
  do número.
- **Ritmo com média móvel de 3 amostras**, senão oscila a cada lote. A janela é
  curta de propósito: são 12 lotes no total, e uma janela maior só produziria
  número depois que o download já acabou.

A checklist de etapas carrega a sensação de avanço quando o ritmo desacelera: o
técnico vê o que já entrou.

### Botão de login

Mesmo sem o download, `signInWithEmail` leva 1-3s de rede. O botão "Entrar" ganha
estado de carregando (spinner + desabilitado), nas duas telas de login. Isso também
elimina o duplo toque.

## Erro, offline e biometria

### `onUserLogin` para de engolir exceções

`objectbox_auth_helper.dart:97-100` captura a exceção e apenas loga. Passa a
propagar. É seguro porque o único chamador atual é o auth manager, de onde a
chamada está saindo; o novo chamador é o controller, que sabe tratar.

### Falha no meio do download

Estado `Erro`. A tela mostra a etapa que falhou, a mensagem técnica recolhida, e
dois botões:

- **Tentar novamente** — rechama `performFullDownload` do início. Seguro: toda
  gravação é upsert por `firestoreId`, nada duplica.
- **Continuar assim mesmo** — vai ao destino com os dados parciais, exibindo uma
  linha que explica que a sincronização será refeita depois.

O "refeita depois" é literal: `initial_download` só é marcado completo em
`offline_first_sync_service.dart:191`, ao fim de tudo. Um download interrompido
deixa a flag incompleta e o próximo login rebaixa tudo. Nada se perde.

### Offline

`performFullDownload` hoje retorna cedo e em silêncio quando `!isOnline`
(`:142-146`), sem lançar nada. Do jeito que está, o controller não distinguiria
isso de sucesso e mandaria o técnico para um dashboard vazio como se estivesse tudo
certo. O método passa a sinalizar a condição, e o controller trata dois casos:

- **Offline sem dados locais** (`animalBox.count() == 0`): tela de "Sem conexão",
  explicando que a primeira sincronização exige internet, com "Tentar novamente".
- **Offline com dados locais**: segue direto para o destino, sem barra. É o caso
  normal do técnico em campo.

### Biometria

O login por biometria (`login_technician_page.dart:452`,
`login_produtor_page.dart:257`) passa pela mesma `SyncPage`. Como quase sempre há
dados locais e/ou o aparelho está offline, ela atravessa a tela rapidamente.

### Voltar bloqueado

`PopScope` impede sair da tela durante o download. Voltar no meio deixaria o
usuário autenticado numa tela de login, com o download órfão e o estado pela metade.

## Testes

O repositório não usa `mockito` nem ObjectBox em teste — `base_sync_repository_test.dart`
testa um predicado puro justamente para evitar isso. A lógica testável precisa ser
pura por construção, o que guiou o desenho acima.

- **`test/core/sync/sync_rate_estimator_test.dart`** — ritmo e ETA com timestamps
  injetados: sem amostras suficientes devolve `null`; a suavização impede saltos;
  ETA é omitido abaixo do piso.
- **`test/features/sync/sync_page_controller_test.dart`** — com um fake do serviço
  escrito à mão (interface estreita: emitir progresso, lançar, informar se está
  online): caminho feliz emite a sequência esperada e resolve o destino certo por
  papel; exceção vira `Erro` com a etapa correta; retry volta para `Baixando`;
  offline com dados locais conclui direto; offline sem dados vira erro de conexão.
- **`test/features/sync/reconciliacao_animais_test.dart`** — função pura extraída de
  `_salvarAnimais`, que recebe `(ids existentes localmente, docs baixados)` e devolve
  a lista a gravar. Testa que o mesmo lote aplicado duas vezes atualiza em vez de
  inserir. É a regressão que o comentário em `:207-212` documenta ter derrubado o
  download inteiro uma vez.
- **`test/features/sync/sync_progress_view_test.dart`** — widget test: exibe
  "1.240 de 3.000"; esconde ritmo quando `total` é nulo; mostra os dois botões no
  estado de erro.

### Validação no dispositivo

Feita pelo usuário, com dois logins:

1. Técnico com ~3000 animais em **instalação limpa** (app reinstalado). Sem isso,
   `needsInitialSync()` retorna falso e o download completo não roda.
2. Segundo login do mesmo técnico, para confirmar que a tela passa rápido e que
   nada duplicou.

## Fora de escopo

- `_downloadFinanceiroEVisitas` — mantém o padrão atual de gravação.
- `RemoteSyncListenersService` — sem alteração.
- Sincronização ao reabrir o app já logado, que hoje não passa por tela nenhuma.
