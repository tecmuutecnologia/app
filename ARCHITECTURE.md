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
features/        adaptadores/lógica por feature (ex.: animal_struct_adapter)
pages/           telas FlutterFlow legadas (vão sendo esvaziadas)
flutter_flow/    utilitários gerados (mantidos)
```

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

## Pendências conhecidas (precisam de device / sequência de release)

- **Listeners remotos** (`RemoteSyncListenersService`) estão definidos mas
  **nunca iniciados** — sync em tempo real inativa; só `performFullDownload`.
- **Variantes `_offline`** (≈13) só podem ser removidas após a migração de dados
  legados propagar (usuário abrir online 1×) + validação no device.
- **Biometria/secure_storage/AuthRepository**: dependem de plataforma + device.
- **listacompleta** (14.9k linhas): filtros variados + extração de componentes de
  UI — fazer incremental com o app rodando.
