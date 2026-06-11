# Arquitetura — Tecmuu (offline-first)

Guia curto do padrão-alvo para o time. Descreve o estado **atual** da refatoração
(não o ideal futuro). Para o plano completo de fases, ver o histórico de commits
e os guias em [`documentacao/`](documentacao/INDICE.md).

## Princípio central: offline-first

**A fonte da verdade local é o ObjectBox. A UI lê dele. O Firestore é o destino
de sincronização.** Toda escrita segue:

1. grava no **ObjectBox** primeiro (`needsSync = true`);
2. se **online**, tenta refletir no Firestore na hora;
3. se **offline** ou em erro, **enfileira** para retry — e sincroniza ao reconectar.

Nunca bloquear a UI esperando rede. Nunca ler `currentUserUid`/Firestore direto de
um widget novo — passar por repositório.

## Camadas (`lib/`)

```
core/            infra transversal: connectivity/, sync/ (codec, ConflictResolver),
                 security/ (PasswordHasher), result/ (Result<T>)
backend/objectbox/
  entities/      entidades ObjectBox (implementam SyncableEntity)
  repositories/  1 repo por agregado, sobre BaseSyncRepository<E>
  offline_first_sync_service.dart   o "SyncEngine" (download + push + fila)
  remote_sync_listeners_service.dart  listeners Firestore->ObjectBox (HOJE INATIVO)
domain/          regras puras testáveis (ex.: animais/classificacao_animal.dart)
features/        feature-first: <feature>/presentation/{pages,widgets,controllers},
                 application/, domain/, data/
pages/           telas FlutterFlow legadas (vão sendo migradas p/ features/)
flutter_flow/    utilitários gerados (mantidos durante a migração)
```

## Migração da UI (FlutterFlow → feature-first)

Programa **incremental por feature** (ver plano completo no histórico). A camada de
dados já é offline-first; a migração agora move a **apresentação** do padrão FlutterFlow
(`pages/<área>/<tela>/<tela>_widget.dart` + `_model.dart` extends `FlutterFlowModel`) para
`features/<feature>/presentation/`. Cada tela compila e passa no gate isoladamente.

**Receita por tela** (referência-ouro: `features/auth/presentation/` — login do técnico):
1. `X_widget.dart` → `features/<f>/presentation/pages/x_page.dart`; classe `XWidget`→`XPage`
   `extends ConsumerStatefulWidget` (ou `ConsumerWidget`).
2. Controllers/`FocusNode`/validators de `TextField` → `State` da page (ciclo de vida de UI).
   Remover `createModel`/`_model.` e o `export '..._model.dart'`.
3. **Estado efêmero de UI** (visibilidade de senha, índice de aba, toggles locais) fica no
   `State` com `setState` — `ConsumerStatefulWidget` só é necessário quando a tela usa `ref`.
   **Estado de negócio/app** (o que estava no `FlutterFlowModel` com lógica ou lia `FFAppState`) →
   `presentation/controllers/x_controller.dart`: `XController extends Notifier<XState>`
   (estado imutável + `copyWith`), consumido via `ref.watch`/`ref.read`. Escritas passam pelos
   repositórios offline-first — nunca Firestore/`currentUserUid` direto.
4. Imports: **sem** `import '/index.dart'`; referenciar telas/route names por import direto.
   Tema/i18n via `flutter_flow_util.dart` (relocação p/ `core/ui` vem na fase de app-shell).
5. Atualizar a rota (`flutter_flow/nav/nav.dart` hoje) e a entrada do `index.dart`; deletar
   `X_model.dart` e a pasta antiga.

## Repositórios (`BaseSyncRepository<E>`)

Centraliza o CRUD offline-first. Subclasse só declara `box` e `collectionName`.

- `add()` → `needsSync=true` + `put` local + `pushCreate`.
- `save()` / `softDelete()` análogos.
- `pushCreate/Update/Delete`: online tenta Firestore + reconcilia (`firestoreId`,
  limpa `needsSync`); offline/erro **enfileira** via `QueuePayloadCodec`.
- `firestorePayloadFor(entity)`: hook para reanexar `DocumentReference` que a
  entidade pura não constrói (ex.: `AcaoRepository` adiciona
  `uidAnimalAnimaisProdutores`/`uidPropriedade`).
- `syncedByModifiedLoop`: quando `true` (animal, ação, tratamento, financeiro,
  visita), o CREATE/UPDATE NÃO vai pela fila — quem cria/atualiza é o laço
  `_syncModifiedX` do SyncEngine (que reconcilia `firestoreId` local). Evita a
  **dupla-sincronização** (fila + laço). DELETE continua na fila.

## SyncEngine (`OfflineFirstSyncService`)

`syncPendingChangesToFirestore()` (em reconexão / periódico) roda, nesta ordem:

1. `_syncModifiedAnimals()` → ... → `_syncModifiedVisitas()` (entidades com
   `needsSync`). Cada laço faz UPDATE (se tem `firestoreId`) ou CREATE (se não
   tem), **reconciliando** `firestoreId`/`needsSync` de volta no ObjectBox.
2. `_processPendingOperations()` (fila) para os demais repositórios; o CREATE
   reconcilia o `firestoreId` local (`_executeQueuedCreate`) e relê o estado
   atual da entidade (evita payload "velho" do enqueue).

## Animal criado offline (`uidAnimalOffline`)

Um animal criado sem rede não tem `firestoreId`. Ele recebe `uidAnimalOffline`
(identidade local). Ações criadas sobre ele guardam esse id (não um path que
ainda não existe). Quando o animal finalmente sobe e ganha `firestoreId`, a
**cascata** `_resolveAcoesParaAnimalSincronizado` preenche o vínculo das ações e
as remarca; como animais sincronizam antes de ações no ciclo, elas sobem já com a
`DocumentReference` correta. Guarda `_acaoVinculoResolvido` impede subir ação com
vínculo offline ainda não resolvido (sem órfãs).

Telas: formulários de ação recebem `uidAnimalOffline` (param opcional) e localizam
o animal por `AnimalRepository.getByUidAnimalOffline`. Criação offline via
`criarAnimalOffline(struct)` (adapter). Migração de dados legados (array
`FFAppState.animaisProdutoresOffline`) acontece no login (`migrarAnimaisOfflineLegado`).

## Resolução de conflito (`ConflictResolver`)

Regra única (Firestore→ObjectBox), pura e testada:
1. local com `needsSync` **vence** (não sobrescreve edição offline);
2. sem pendência, **mais novo vence** (precisão de ms); empate mantém local;
3. sem datas comparáveis, aceita o remoto.

## Domínio puro (`domain/`)

Regras de negócio sem Flutter/IO, 100% testáveis. Ex.:
`domain/animais/classificacao_animal.dart` substitui strings mágicas
(`status == 'Prenha'`) por predicados nomeados (`ehVacaPrenha`), cobertos por
teste de equivalência. As telas-lista passam a chamá-los.

## Segurança (auth offline)

Senha **nunca** é guardada: o verificador é **PBKDF2-HMAC-SHA256** salgado
(`PasswordHasher`), com comparação em tempo constante. Token de sessão é aleatório
(`Random.secure()`). Serviços de debug só sob `kDebugMode`/`kReleaseMode`.

## Gate (a cada commit)

- `dart format` nos arquivos tocados.
- `flutter analyze --no-fatal-infos`: **zero** errors/warnings (infos da baseline
  FlutterFlow são toleradas).
- `flutter test`: verde.

## Sincronização em tempo real (ativa)

`RemoteSyncListenersService.startAllListeners(tecnicoPath)` é iniciado no login
(`sync_technician`) e parado no logout. Escuta `animaisProdutores`/`acoes`/
`tratamentos` sob o técnico e reflete mudanças remotas no ObjectBox, com
conflitos resolvidos por [ConflictResolver]. Coexiste com `performFullDownload`
(carga inicial) e o push offline-first.

## Pendências conhecidas (precisam de device / time)

- **Biometria/PIN + secure_storage** (auth offline): dependem de deps nativas
  (`local_auth`/`flutter_secure_storage`) + config de plataforma + device. O
  verificador de senha já é PBKDF2 e o `AuthRepository` (leitura de auth) existe.
- **Extração de componentes de UI** das telas gigantes (`listacompleta` 7.7k,
  `prontuario_animal`, `cadastrar_novo_animal`): refator sem mudança funcional,
  mas verificável só com o app rodando.
- **Segredos versionados** (`credentials.txt`, `key.properties`, `.p8`, `.jks`):
  ação do time (ver `documentacao/SEGURANCA_SEGREDOS.md`).
